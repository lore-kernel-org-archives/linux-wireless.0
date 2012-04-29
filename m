Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47100 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab2D2Wpt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 18:45:49 -0400
Message-ID: <4F9DC495.7060103@hauke-m.de> (sfid-20120430_004623_536930_7F733B5D)
Date: Mon, 30 Apr 2012 00:45:41 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de> <4F9CF839.1040401@broadcom.com> <4F9D4073.200@hauke-m.de> <4F9D7032.40507@broadcom.com>
In-Reply-To: <4F9D7032.40507@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2012 06:45 PM, Arend van Spriel wrote:
> On 04/29/2012 03:21 PM, Hauke Mehrtens wrote:
>> On 04/29/2012 10:13 AM, Arend van Spriel wrote:
>>> On 04/29/2012 02:50 AM, Hauke Mehrtens wrote:
>>>> I have not completely runtime tested these patches as I do not have a
>>>> PCI(e) devices currently supported by brcmsmac. My SoC (BCM4718) and
>>>> the PCI devices connected to my SoC (BCM43224) are currently not
>>>> working with brcmsmac, but they are failing much later that without
>>>> these patches.
>>>
>>> I will test this patch series as well on PCI(e) devices. So you do have
>>> a bcm43224 card, but no laptop to fit it in? Just wondering. I will send
>>> the results.
>>>
>>> Gr. AvS
>>>
>> Hi Arend,
>>
>> Thanks for testing these patches. My bcm43224 is directly soldered on
>> the main board where also the bcm4718 is on, there is no connector or
>> something like that between the bcm4718 and the bcm43224, it is
>> impossible to remove the bcm43224 and plug it into a laptop. The bcm4718
>> has some problems with the PCIe bus see comment on bcma_wflush16() in
>> drivers/net/wireless/brcm80211/brcmsmac/dma.h.
> 
> I see. I have a bcm4718 with a mini-PCIe connector so I assumed that was
> the same for you.
Yes looks like that, you should try it out with brcmsmac. ;-)
> 
>> I now finally got the bcm43224 a little bit working, I was able to scan
>> for networks, but I was unable to connect to one, I just saw 2 networks
>> form devices on my desk, not the other ~15 my Intel card sees. The
>> bcm43224 should just be used for 5GHz on my device and the sprom is also
>> just configuration for 5GHz operation and I have only some 2.4 GHz
>> access points laying around here, so that could be the problem.
>>
>> The Wifi of the bcm4718 is still not working for me. The wifi core has a
>> core rev of 17, I handled it the same as core rev 23, but I am getting
>> the following errors and after that the system freezes.
>>
>> [   80.232000] ieee80211 phy1: wl1: wlc_coreinit: ucode did not
>> self-suspend!

The problem is here, the rest are just other problems because of this.
The driver should abort the initialization at this point.

The ucode does not start after it was loaded onto the device in
brcms_ucode_download(). I never had such problems when using b43.

>> [   80.240000] ieee80211 phy1: wlc_coreinit: txfifo mismatch: ucode size
>> 111 driver size 28518 index 5
>> [   80.380000] ieee80211 phy1: wl1: wlc_suspend_mac_and_wait: waited
>> 83000 uS and MI_MACSSPNDD is still not on.
> 
> In several scenarios the driver puts the d11core in suspended state.
> This message indicates d11core does not end up in suspended state.
> Normally, means the d11core got stuck. The two messages before that look
> interesting.
> 
>> [   80.388000] ieee80211 phy1: wl1: psmdebug 0x00ff8cd4, phydebug
>> 0x00000000, psm_brc 0x0000
> 
> The psmdebug register is the same in all the messages, which confirms
> the d11core is stuck.
> 
>> ... (~6 times the same 2 lines)
>> [   81.132000] ieee80211 phy1: wl1: wlc_suspend_mac_and_wait: waited
>> 83000 uS and MI_MACSSPNDD is still not on.
>> [   81.144000] ieee80211 phy1: wl1: psmdebug 0x00ff8cd4, phydebug
>> 0x00000000, psm_brc 0x0000
>> [   81.156000] ieee80211 phy1: brcms_ops_bss_info_changed: qos enabled:
>> false (implement)
>> [   81.164000] ieee80211 phy1: brcms_ops_config: change power-save mode:
>> false (implement)
>> [   81.256000] ieee80211 phy1: wl1: wlc_suspend_mac_and_wait: waited
>> 83000 uS and MI_MACSSPNDD is still not on.
>> [   81.268000] ieee80211 phy1: wl1: psmdebug 0x00ff8cd4, phydebug
>> 0x00000000, psm_brc 0x0000
>> ... (~3 times the same 2 lines)
>> [   81.708000] ieee80211 phy1: wl1: wlc_suspend_mac_and_wait: waited
>> 83000 uS and MI_MACSSPNDD is still not on.
>> [   81.720000] ieee80211 phy1: wl1: psmdebug 0x00ff8cd4, phydebug
>> 0x00000000, psm_brc 0x0000
>> [   81.732000] ieee80211 phy1: wl1: fifo 0: descriptor error
>> [   81.736000] ieee80211 phy1: wl1: fatal error, reinitializing
> 
> This descriptor error should re-initialize the driver, but there are
> already problems reported about that last resort.
> 
>> b43 is working in access pint mode with the wifi core of the bcm4718.
> 
> I like pints ;-) brcmsmac currently only supports STA mode.
> 
> What firmware are you using?

On b43 I am using firmware version 666.2 from wl 5.100.138, but also
older versions are working. On brcmsmac I am using bcm43xx-0.fw and
bcm43xx_hdr-0.fw from the linux-firmware git repo.

Does the ucode you provide in bcm43xx-0.fw and bcm43xx_hdr-0.fw support
rev 17 ieee80211 cores? For b43 it is the same file for all n-phy based
cores rev >= 16, so for wl it should be the same, but have you added
some special handling into this firmware for brcmsmac?

Hauke
