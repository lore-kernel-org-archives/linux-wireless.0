Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56583 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908Ab2J3RII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 13:08:08 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so304403pad.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2012 10:08:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5077D5D2.6020302@gmail.com>
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
	<20121011203112.GB3317@kroah.com>
	<5077BE43.7050200@gmail.com>
	<CAGRGNgVAuV7bYaU0rMZit81PFdpSprfdJkaqHqnm1WGx_FBtVA@mail.gmail.com>
	<5077D5D2.6020302@gmail.com>
Date: Tue, 30 Oct 2012 10:08:07 -0700
Message-ID: <CAJ-Vmom7ENhQ4mxq6w1yj-o3ZPK1wz2gPfd+m0fcHFvm6kvk8g@mail.gmail.com> (sfid-20121030_180813_033164_A2A29D7B)
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
From: Adrian Chadd <adrian@freebsd.org>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	achadd@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 October 2012 01:33, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:

>> Have you asked the Atheros guys (mostly CC'd) if there's any
>> possibility of the documentation / firmware being released?
>>
>
> Yes I have. Adrian promised to see what could be done regarding docs.
>
> The FW blob is already released under a good license. I guess the best thing
> would be if Adrian or Luis could submit the fw to linux-firmware but lets
> deal with that when/if the driver gets merged.

I've found the firmware source. I have no idea how difficult it will
be to build today, but it's a MIPS CPU core so I should be able to do
it with a cross-compiled MIPS GCC.

I've also found the AR5523 datasheet here.

So, poke me if you'd like me to look up what's going on. It honestly
looks like a MIPS core with a USB device controller and an AR5212 MAC
(the datasheet refers to the AR5212 MAC/BB documentation, so it's
quite likely exactly that.)

On the up side, it's a 30MHz MIPS4kp core with 256KiB of SRAM and some
SPI flash for booting. So it's entirely plausible we could write a
replacement firmware for it based on the FreeBSD AR5212 HAL code (and
whatever extra AR5523 specific mac/bb initvals and calibration data
format.)

In _fact_, since it's basically an AR5212 glued on the side, we could
plausibly extend ath5k and the FreeBSD ath driver to do what ath9k_htc
does. :-)

Ok, that's enough carrot-on-a-stick for y'all.



Adrian
