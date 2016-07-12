Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33048 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbcGLVLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 17:11:05 -0400
Received: by mail-oi0-f46.google.com with SMTP id j185so35309109oih.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jul 2016 14:10:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <001201d1dc72$0675f030$1361d090$@inventeksys.com>
References: <002601d1d305$183c3070$48b49150$@inventeksys.com>
 <6d12bb3e-a01d-34c7-c1a9-b1952a84f99e@broadcom.com> <001201d1dc72$0675f030$1361d090$@inventeksys.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 12 Jul 2016 23:10:38 +0200
Message-ID: <CACna6rzU91CRGmgPtAgEhdqwpSGSs0i-C3qL7OiB8soHk8vq8Q@mail.gmail.com> (sfid-20160712_231115_981118_B540057E)
Subject: Re: building brcmfmac driver for iMX6 Ultralite platform
To: Michael Eskowitz <MichaelE@inventeksys.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 July 2016 at 21:17, Michael Eskowitz <MichaelE@inventeksys.com> wrote:
> Arend,

What about my reply? ;)


> That is news to me.  I was under the impression that bcmdhd was Broadcom's
> proprietary (closed source) Linux driver and brcmfmac was the open source
> Linux driver.

Don't top post. It's hard to say what you're replying to. bcmdhd is
also open source (not sure what license), just not mainline.


> Either way, I am now running
>
>         insmod  brcmutil.ko
>         insmod  brcmfmac.ko
>
> I receive no errors and no kernel messages.
>
> When I insert the 43341 module into the SDIO slot nothing happens.  I'm
> guessing that the version of the brcmfmac driver that I built does not
> support that chip.

Is is detected by the system? If so, what ID does it use?


> When I insert the 43362 module into the SDIO slot I receive the following
> errors
>
>         mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
>         mmc0: new high speed SDIO card at address 0001
>         brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jun  7 2012
> 18:27:16 version 5.90.225 FWID 01-d8fe14bd
>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>         brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
>         brcmfmac: brcmf_add_if: ignore IF event
>         brcmfmac: brcmf_fil_cmd_data: Failed err=-23
>         brcmfmac: brcmf_construct_reginfo: channel 1: f=2412 bw=0
> sb=-1998840228
>         brcmfmac: brcmf_construct_reginfo: channel 2: f=2417 bw=0
> sb=-1998840228
>
> and suddenly ifconfig shows the interface wlan0.  The interface looks to be
> valid as it is displaying a MAC from our address range.
>
> Although the interface wlan0 is present I am not able to use wl commands to
> scan for networks.  wl reports "wl driver adapter not found" for all command
> arguments.  If I run the command
>
>         iwlist  wlan0  scan
>
> I'm told that the interface does not support scanning.  If I run wpa_cli and
> then the commands scan and scanresults I don't see any networks.

"wl" user space tool uses wlioctl, proprietary protocol, brcmfmac
doesn't support it.

iwlist uses wext protocol, legacy one.

Please use nl80211 based tools, e.g. "iw".
