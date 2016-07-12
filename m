Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36907 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbcGLVdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 17:33:07 -0400
Received: by mail-wm0-f50.google.com with SMTP id i5so42158822wmg.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jul 2016 14:33:05 -0700 (PDT)
Subject: Re: building brcmfmac driver for iMX6 Ultralite platform
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Eskowitz <MichaelE@inventeksys.com>
References: <002601d1d305$183c3070$48b49150$@inventeksys.com>
 <6d12bb3e-a01d-34c7-c1a9-b1952a84f99e@broadcom.com>
 <001201d1dc72$0675f030$1361d090$@inventeksys.com>
 <CACna6rzU91CRGmgPtAgEhdqwpSGSs0i-C3qL7OiB8soHk8vq8Q@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <72354044-4f67-bfbd-ed0f-12183dc8fc53@broadcom.com> (sfid-20160712_233419_281175_6828AB7F)
Date: Tue, 12 Jul 2016 23:32:46 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rzU91CRGmgPtAgEhdqwpSGSs0i-C3qL7OiB8soHk8vq8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12-7-2016 23:10, Rafał Miłecki wrote:
> On 12 July 2016 at 21:17, Michael Eskowitz <MichaelE@inventeksys.com> wrote:
>> Arend,
> 
> What about my reply? ;)
> 
> 
>> That is news to me.  I was under the impression that bcmdhd was Broadcom's
>> proprietary (closed source) Linux driver and brcmfmac was the open source
>> Linux driver.
> 
> Don't top post. It's hard to say what you're replying to. bcmdhd is
> also open source (not sure what license), just not mainline.
> 
> 
>> Either way, I am now running
>>
>>         insmod  brcmutil.ko
>>         insmod  brcmfmac.ko
>>
>> I receive no errors and no kernel messages.
>>
>> When I insert the 43341 module into the SDIO slot nothing happens.  I'm
>> guessing that the version of the brcmfmac driver that I built does not
>> support that chip.
> 
> Is is detected by the system? If so, what ID does it use?
> 
> 
>> When I insert the 43362 module into the SDIO slot I receive the following
>> errors
>>
>>         mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
>>         mmc0: new high speed SDIO card at address 0001
>>         brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jun  7 2012
>> 18:27:16 version 5.90.225 FWID 01-d8fe14bd
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>>         brcmfmac: brcmf_add_if: ignore IF event
>>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>>         brcmfmac: brcmf_construct_reginfo: channel 1: f=2412 bw=0
>> sb=-1998840228
>>         brcmfmac: brcmf_construct_reginfo: channel 2: f=2417 bw=0
>> sb=-1998840228
>>
>> and suddenly ifconfig shows the interface wlan0.  The interface looks to be
>> valid as it is displaying a MAC from our address range.
>>
>> Although the interface wlan0 is present I am not able to use wl commands to
>> scan for networks.  wl reports "wl driver adapter not found" for all command
>> arguments.  If I run the command
>>
>>         iwlist  wlan0  scan
>>
>> I'm told that the interface does not support scanning.  If I run wpa_cli and
>> then the commands scan and scanresults I don't see any networks.
> 
> "wl" user space tool uses wlioctl, proprietary protocol, brcmfmac
> doesn't support it.

Well, not quite these days. The wl tool can be built to use nl80211
vendor commands to transport wl commands to firmware. However, my bet is
you have the "classic" wl tool using ioctl() api, which we removed from
brcmfmac years ago.

> iwlist uses wext protocol, legacy one.

iwlist is indeed using wext protocol, but cfg80211 should provide
compatibility layer so cfg80211-based drivers like brcmfmac can work
with it. However, there seem to be issues and not everything runs
smoothly. Apparently no one cares enough about wext.

> Please use nl80211 based tools, e.g. "iw".

So indeed use "iw":

$ sudo ifconfig wlan0 up
$ sudo iw wlan0 scan

Regards,
Arend
