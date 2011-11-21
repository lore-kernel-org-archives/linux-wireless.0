Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3830 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab1KUT6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 14:58:47 -0500
Message-ID: <4ECAAD6C.4080103@broadcom.com> (sfid-20111121_205850_650447_D7D3E852)
Date: Mon, 21 Nov 2011 11:58:36 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Howard Harte" <hharte@broadcom.com>
Subject: Re: brcm80211 (with bcm4329-chip)
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
 <4ECA8908.7070304@broadcom.com> <4ECA98DB.4030608@broadcom.com>
 <CADrAYBk7_fsVJUAYNqEZpdBPKOTGUai_UhPT9LMHaEyY+Zm24w@mail.gmail.com>
In-Reply-To: <CADrAYBk7_fsVJUAYNqEZpdBPKOTGUai_UhPT9LMHaEyY+Zm24w@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 10:45 AM, Thomas Langås wrote:
> On Mon, Nov 21, 2011 at 7:30 PM, Franky Lin<frankyl@broadcom.com>  wrote:
>> Current MMC stack in Linux would not confuse a MMC/SD card and a SDIO
>> device. Basically the intialization and command sets they used are
>> different.
>
> So the crash is unrelated, is what you're saying?   I've attached the
> log if that'll
> give you some more clues.

Yes, it should have nothing to do with the crash.

> Attached is a crash.log-file from the serial console.
>

 > [    5.390000] mmc1: Got data interrupt 0x00200000 even though no 
data operation was in progress.

This is weird.
#define  SDHCI_INT_ADMA_ERROR   0x02000000
Could you check why the the SDIO host controller is generating this kind 
of interrupt?

Also, comment out the line "brcmf_msg_level = BRCMF_ERROR_VAL;" in 
brcmf_c_init of dhd_common.c. Then insert fullmac module by
insmod brcmfmac.ko brcmf_msg_level=0x7. This will give you a more detail 
log of brcmfmac. But I am suspecting even the first SDIO read command 
failed.

Franky

