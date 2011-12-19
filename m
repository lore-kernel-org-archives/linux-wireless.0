Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4866 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1LSS3P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 13:29:15 -0500
Message-ID: <4EEF8270.8090500@broadcom.com> (sfid-20111219_192919_303546_C219E775)
Date: Mon, 19 Dec 2011 10:29:04 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "GNUtoo@no-log.org" <GNUtoo@no-log.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac + compat wireless + 2.6.35
References: <4ECC1F41.90003@broadcom.com>
 <1323539463-6072-1-git-send-email-GNUtoo@no-log.org>
 <4EE3C515.5050307@broadcom.com>
 <c37d1dd4f7760df63a92b6fc1a187068.squirrel@webmail.no-log.org>
In-Reply-To: <c37d1dd4f7760df63a92b6fc1a187068.squirrel@webmail.no-log.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

On 12/18/2011 03:33 AM, Denis 'GNUtoo' Carikli wrote:
> Hi,
> With the following patch instead of mine:
>    brcm80211: fmac: register a dummy irq handler for SDIO function 2
> it still fails the same way.

Indeed there is no big difference from yours. We tested it on X86 and 
OMAP panda board.

> I added that:
> #define BCMDBG                         1
> after:
>   #include "dhd_proto.h"
>   #include "dhd_dbg.h"
>   in:
> drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
> and:
> insmod brcmfmac.ko brcmf_msg_level=8192

Could you try to load the driver by insmod brcmfmac.ko 
brcmf_msg_level=0x7 and send me the log?

> But it wasn't more verbose so I added MMC debug and I got that:
>
> [  101.534177] mmc2: starting CMD52 arg 00205c00 flags 00000195
> [  101.534327] sdhci [sdhci_irq()]: *** mmc2 got interrupt: 0x00000001
> [  101.534411] mmc2: req done (CMD52): 0: 00001000 00000000 00000000 00000000
> [  101.534562] mmc2: starting CMD52 arg 00205e00 flags 00000195
> --- Then it blocks here ---

Looks like it hangs in the middle of downloading firmware.

Thanks,
Franky

