Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43125 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZAMTpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:45:46 -0500
Date: Tue, 13 Jan 2009 14:43:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: darklight <darklight.xdarklight@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: ignore the return value of
	ath5k_hw_noise_floor_calibration
Message-ID: <20090113194325.GE3623@tuxdriver.com> (sfid-20090113_204550_554479_DE9A4B15)
References: <888a464d0901091721l6657e755vbfe5bae0367f6413@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <888a464d0901091721l6657e755vbfe5bae0367f6413@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 10, 2009 at 02:21:44AM +0100, darklight wrote:
> hi,
> 
> some weeks ago Felix Fietkau posted a patch for the "ath5k phy0:
> unsupported jumbo" warnings (see here:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/23430 )
> I just had the same problem - after applying Felix' patch the warnings
> went down from 50-100 per day to 5.
> 
> as a quick note: I did not just apply this patch, instead I replaced
> Linus' upstream wireless stack with the one from wireless-testing
> (using kernel version 2.6.28)
> 
> I hope Felix' patch can get into Linus' kernel (mainline) so other
> users can profit from this

It is in Linus' kernel right now:

commit 8b0162a3dc5c30e862b7a73da29e32de3170f5e4
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Mon Nov 3 11:27:38 2008 +0100

    ath5k: ignore the return value of ath5k_hw_noise_floor_calibration

    Noise floor calibration occasionally fails on Atheros hardware.
    This is not fatal and can happen if there's simply too much
    noise on the air. Ignoring the calibration error is the right
    thing to do here, because when the error is ignored, the hardware
    will still work, whereas if the error causes the driver to bail out
    of a bigger configuration function and does not configure the tx
    queues or the IMR (as is the case in reset.c), the hw no longer
    works properly until the next reset.

    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
