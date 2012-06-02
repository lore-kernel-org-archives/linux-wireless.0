Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55639 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab2FBOVO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 10:21:14 -0400
Message-ID: <4FCA2151.50409@hauke-m.de> (sfid-20120602_162149_822608_CE1D4AF6)
Date: Sat, 02 Jun 2012 16:21:05 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de> <4F9CF839.1040401@broadcom.com> <4F9D4073.200@hauke-m.de> <4F9D7032.40507@broadcom.com> <4F9DC495.7060103@hauke-m.de> <4F9FAE48.10102@broadcom.com> <4FA02998.4000506@hauke-m.de>
In-Reply-To: <4FA02998.4000506@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/2012 08:21 PM, Hauke Mehrtens wrote:
> On 05/01/2012 11:35 AM, Arend van Spriel wrote:
>> On 04/30/2012 12:45 AM, Hauke Mehrtens wrote:
>>> On 04/29/2012 06:45 PM, Arend van Spriel wrote:
>>>> What firmware are you using?
>>>
>>> On b43 I am using firmware version 666.2 from wl 5.100.138, but also
>>> older versions are working. On brcmsmac I am using bcm43xx-0.fw and
>>> bcm43xx_hdr-0.fw from the linux-firmware git repo.
>>>
>>> Does the ucode you provide in bcm43xx-0.fw and bcm43xx_hdr-0.fw support
>>> rev 17 ieee80211 cores? For b43 it is the same file for all n-phy based
>>> cores rev>= 16, so for wl it should be the same, but have you added
>>> some special handling into this firmware for brcmsmac?
>>>
>>> Hauke
>>>
>>
>> Yes, the firmware for brcmsmac is specifically for 43224, 43225, and
>> 4313. I have to check with the firmware guys here what is needed for 4718.
> I tried to load the firmware b43 uses (extracted from wl) in version
> 666.2 and my bcm43224 device is working with that firmware like with the
> firmware supposed for brcmsmac (bcm43xx-0.fw). after loading the b43
> firmware my bcm4718 does not show the "wl1: wlc_coreinit: ucode did not
> self-suspend!" line any more, but still "wlc_coreinit: txfifo mismatch:
> ucode size 111 driver size 28518 index 5" and crashes the device after
> that with a Data bus error.
> 
> I am able to connect to a 5GHz AP in client mode with my bcm43224
> connected to the bcm4718 via PCIe with both firmware versions, but I am
> just getting 30.3 Mbits/sec as the maximum speed.
> 
> Hauke

Hi Arend,

I added some more stuff for bcm4718 into brcmsmac and now it is working
in client mode with brcmsmac and the firmware from b43. There was some
code removed which is needed for this chip between the initial commit to
staging and now, I searched for it and added it again.

The BCM4718 only works when using the firmware b43 uses and not when
using the firmware brcmsmac is supposed to use, so there is a limitation
in the firmware to some devices not including bcm4718.
For now I am using a hacked code to load the firmware b43 uses, but I
will write a tool converting it to the format brcmsmac uses, or are you
planing to release a new firmware with support for bcm4718 in the next
few weeks?
With the firmware supposed for brcmsmac I get this message:
ieee80211 phy1: wl1: wlc_coreinit: ucode did not self-suspend!
and some more follow up errors.

The wireless speed is quite poor, I just get 12MBit/s in both
directions, less then with b43, but it uses ieee80211n rates, sirq is at
~70% when doing these transfers. I tested the wireless of the bcm4718
with iperf running on the device and on my PC, the access point was
using ath9k.

I will clean up my patches and will send them to the mailing list in the
next days.

The BCM5357 is not yet working and probably needs a updated nphy code.

Hauke
