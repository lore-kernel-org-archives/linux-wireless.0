Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55135 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab3BXP0C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 10:26:02 -0500
Message-ID: <512A30FD.3010509@hauke-m.de> (sfid-20130224_162615_512635_7D0A14C7)
Date: Sun, 24 Feb 2013 16:25:49 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend Van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: [RFC 00/13] brcmsmac: add AP mode
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de> <A47087626F2942499CF47E79803E771E0431BF4D@SJEXCHMB13.corp.ad.broadcom.com> <5129FBB8.1080505@hauke-m.de>
In-Reply-To: <5129FBB8.1080505@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2013 12:38 PM, Hauke Mehrtens wrote:
> On 02/24/2013 11:21 AM, Arend Van Spriel wrote:
>> On Sunday, February 24, 2013 2:05 AM, Hauke Mehrtens wrote:
>>> This patch series contains some cleanup patches for brcmsmac and then
>>> adds beacon and probe response template upload.
>>> With these features AP mode support is added in the last patch.
>>
>> Someone was bound to start on this and we are lately too focussed on
>> brcmfmac. We will review the patches and found out whether our test
>> framework can cover AP mode.
> 
> Yes this needs some review and more testing, I hope this also works with
> power saving stations and so on.
> 
>>> When running AP mode in 5GHz band on my BCM43224 I get the following
>>> errors, and I do not see the network with my Intel IWL6300, the
>>> regulation restrictions in channel.c where changed before:
>>
>> 5GHz is a bit tricky. I will need to find out whether AP mode can work with
>> the current ucode.
> 
> Currently brcmsmac completely denies beaconing on 5GHz in channel.c, how
> could that be changed and still compatible with the interpretation of
> the regulation rules by your lawyers?
> 
>>> [  829.608000] brcmsmac bcma1:0: wl0: wlc_suspend_mac_and_wait:
>>> waited 83000 uS and MI_MACSSPNDD is still not on.
>>> [  829.616000] brcmsmac bcma1:0: wl0: psmdebug 0x00ff808d, phydebug
>>> 0x0000000d, psm_brc 0x0000
>>
>> It generally indicates a hang in the ucode. Are you using the firmware from
>> the linux-firmware repository?
> 
> Instead of these error messages I also got a complete system hang when
> compiling a kernel without lock debugging, the difference between this
> result with lock debugging and the hang without lock debugging is
> probably resulted from different timings.
> 
> I used the ucode extracted from the proprietary driver, because only
> this ucode works with my BCM4716, this is ucode 666.2 from driver
> 5.100.138. I will try the ucode from linux-firmware today.

I just tried the firmware version 610.812 from linux-firmware and there
I do not get an error message or hang when starting the AP in 5GHz mode,
but my iwl6300 card is unable to find this network.

>>> The probe responses are currently send by the ucode based on the
>>> template and by mac80211. I was searching for a switch so disable probe
>>> request forwarding from the ucode to the driver.
>>
>> I am pretty sure there is. I will look into this and let you know.
> 
> That would be nice.
> 
>>> The structure of brcmsmac is pretty complicated, because it copies many
>>> addresses into its own structs and does not use mac80211 structs in
>>> main.c.
>>
>> Yeah. Basically, a lot of conversions are done at mac80211 interface to keep
>> the low-level driver code similar to the code base it came from. That is the
>> path taken. I would like to see a replacement driver some day that shares more
>> structure definitions with the linux wireless subsystem, but for now that is just
>> me daydreaming ;-)
> 
> I saw your code for beaconing and probe response templates, but I mostly
> replaced it with a new version because this architecture was not
> compatible with mac80211. For the Phy code it makes sense and it is
> probably not so hard to stay near your proprietary code base, but I do
> not think this works very well with the rest of the code mostly in main.c.
> 
> Hauke
> 

