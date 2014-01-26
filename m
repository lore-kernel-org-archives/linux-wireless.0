Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:21807 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaAZIxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 03:53:37 -0500
Message-ID: <52E4CCFF.1020200@broadcom.com> (sfid-20140126_095341_342773_D36C5012)
Date: Sun, 26 Jan 2014 09:53:19 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, <linux-sunxi@googlegroups.com>
CC: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>,
	<benn@cubietech.com>
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com> <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com> <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com> <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com> <52BD68BA.3080304@broadcom.com> <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com> <52CD12D4.5030008@broadcom.com> <CAGb2v64+5Rgs6JxD0iH3bcwXPOm-xyS_LSmWLfx0qiMQwreOeQ@mail.gmail.com> <52E19A27.7000402@redhat.com> <52E23FB2.7010705@broadcom.com> <52E29607.8040102@redhat.com>
In-Reply-To: <52E29607.8040102@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2014 05:34 PM, Hans de Goede wrote:
> Hi,
> 
> On 01/24/2014 11:25 AM, Arend van Spriel wrote:
>> On 01/23/2014 11:39 PM, Hans de Goede wrote:
>>> Hi,
>>>
>>> I've been working on updating sunxi-devel to include more
>>> recent versions if your gmac patches, as well as adding support
>>> for the wifi + bluetooth found on the cubietruck.
>>>
>>> Here is my current work on this:
>>>
>>> https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-devel
>>>
>>> It is close to working, but unfortunately it does not work,
>>> here is what I get in dmesg when I modprove the module:
>>>
>>> [   99.700889] brcmfmac_sdio mmc1:0001:1: device tree node not found
>>> [  100.020984] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
>>> Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01-b30a427d
>>> [  100.260948] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>> [  100.281260] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>> [  100.322508] usbcore: registered new interface driver brcmfmac
>>> [  160.445215] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning
>>> already: status (1)
>>> [  203.445404] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning
>>> already: status (1)
>>> [  256.445140] brcmfmac: brcmf_cfg80211_sched_scan_start: Scanning
>>> already: status (1)
>>
>> Can you enable debug logging in brcmfmac, ie. debug=0xd416 so I can have
>> a look.
> 
> I've captured a log with these flags until the first "Scanning already"
> message, you can find it here:

Bedankt, Hans

Looking at the log it looks more or less ok. wpa_supplicant (assume you
use that) first does three regular scans which end with no APs found.
Not sure why that happens unless you are in a shielded room :-) After
those scans wpa_supplicant tries to tell the device to do a so-called
scheduled scan. Basically, it is a scan offload. However, the driver
still thinks there is a regular scan ongoing. This needs to be
investigated more. I tried to get your repo from github, but got:

error: The requested URL returned error: 403 Forbidden while accessing
https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-devel/info/refs
fatal: HTTP request failed

Gr. AvS

> http://people.fedoraproject.org/~jwrdegoede/log2
> 
> Thanks for looking into this.
> 
> Regards,
> 
> Hans
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

