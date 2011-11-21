Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4977 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1KUWsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 17:48:19 -0500
Message-ID: <4ECAD52A.6050509@broadcom.com> (sfid-20111121_234827_434750_A5053489)
Date: Mon, 21 Nov 2011 14:48:10 -0800
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
 <4ECAAD6C.4080103@broadcom.com>
 <CADrAYBndEsNz5nypirSxQPObpSV5BWARWOQzwmBTmzg+tgUbBA@mail.gmail.com>
 <CADrAYB=wDwrzCFEi4-PFepLiLMbPLAGxoaNGtXBaPZPR1onokA@mail.gmail.com>
 <4ECAC99B.8090507@broadcom.com>
 <CADrAYBmhBWVDC=K+F-NU6WkUv-M=WddWvU1pe9AXABEinUBGvQ@mail.gmail.com>
In-Reply-To: <CADrAYBmhBWVDC=K+F-NU6WkUv-M=WddWvU1pe9AXABEinUBGvQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 02:26 PM, Thomas Langås wrote:
> On Mon, Nov 21, 2011 at 10:58 PM, Franky Lin<frankyl@broadcom.com>  wrote:
>> It's possible that the firmware carshed. Are you using the firmware/nvram
>> from Linux repository? You should use the nvram that fits your platform.
>
> I'm using the one from repository now, yes.
>
> Using the firmware I had from before, the only difference I see is the
> time of when
> the IRQ handler is called, but that is probably just randomness, I guess?

I think both firmware is fine. I was referring to the 
brcm/bcm4329-fullmac-4.txt It's a nvram file contains critical 
information used by firmware. And it's hardware dependent. We have 
submitted a patch to remove the one in Linux firmware repository to 
avoid confusion as it's for a Broadcom internal development board. It 
may not work with your set up. I think there should be a similar file 
comes with the proprietary driver package if you are using a module 
instead of a 4329 chip. Please use that one.

>
> Attached is the log when modprobing with old firmware.
>

The issue you facing is more likely SDIO bus connection issue.
brcmf_sdioh_request_word: Failed to write word, Err: 0xffffffac
mmc1: Got data interrupt 0x00200000 even though no data operation was in 
progress.
These may be both caused by data CRC error/time out.
I don't have Exynos 4210 spec. But I guess for a such new chip the SDIO 
host should be able to run the bus at 50MHz. You could try to hack the 
MMC/SDIO host driver and reduce the max frequency to 25MHz or even 
further to 12MHz to see if any improvement.

Regards,
Franky

