Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33287 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1KUXkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 18:40:36 -0500
Received: by vcbfk1 with SMTP id fk1so6238943vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 15:40:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECAD52A.6050509@broadcom.com>
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
	<4ECA8908.7070304@broadcom.com>
	<4ECA98DB.4030608@broadcom.com>
	<CADrAYBk7_fsVJUAYNqEZpdBPKOTGUai_UhPT9LMHaEyY+Zm24w@mail.gmail.com>
	<4ECAAD6C.4080103@broadcom.com>
	<CADrAYBndEsNz5nypirSxQPObpSV5BWARWOQzwmBTmzg+tgUbBA@mail.gmail.com>
	<CADrAYB=wDwrzCFEi4-PFepLiLMbPLAGxoaNGtXBaPZPR1onokA@mail.gmail.com>
	<4ECAC99B.8090507@broadcom.com>
	<CADrAYBmhBWVDC=K+F-NU6WkUv-M=WddWvU1pe9AXABEinUBGvQ@mail.gmail.com>
	<4ECAD52A.6050509@broadcom.com>
Date: Tue, 22 Nov 2011 00:40:34 +0100
Message-ID: <CADrAYBntm4GuhcZaErKimv4Z4Nt+Z6=67qdwi7eomZpTOoQsnQ@mail.gmail.com> (sfid-20111122_004039_336953_41C713A4)
Subject: Re: brcm80211 (with bcm4329-chip)
From: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Howard Harte <hharte@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 11:48 PM, Franky Lin <frankyl@broadcom.com> wrote:
> I think both firmware is fine. I was referring to the
> brcm/bcm4329-fullmac-4.txt It's a nvram file contains critical information
> used by firmware. And it's hardware dependent. We have submitted a patch to
> remove the one in Linux firmware repository to avoid confusion as it's for a
> Broadcom internal development board. It may not work with your set up. I
> think there should be a similar file comes with the proprietary driver
> package if you are using a module instead of a 4329 chip. Please use that
> one.

I did two tests one with only changing the nvram-file, and one with
changing both
the firmware and the nvram-file (this is the latest logfile you got).  Both had
the same result.

> I don't have Exynos 4210 spec. But I guess for a such new chip the SDIO host
> should be able to run the bus at 50MHz. You could try to hack the MMC/SDIO
> host driver and reduce the max frequency to 25MHz or even further to 12MHz
> to see if any improvement.

Max clock is 63MHz, and the setting we have now works with 2.6.36 and the
proprietary driver (bcm4329).

Looking at the platform-code we have for 2.6.x, I see that we set
.cd_type                = S3C_SDHCI_CD_GPIO,
Instead of
.cd_type                = S3C_SDHCI_CD_INTERNAL,

I don't know if this matters (looking at the schematics, the clk-pin is the same
for mmc2 as it is for the gpio).  Is this something related to the old
proprietary
driver?


Regards,
Thomas
