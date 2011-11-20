Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41346 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab1KTWn5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 17:43:57 -0500
Received: by vcbfk1 with SMTP id fk1so5005523vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 14:43:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321775788-12520-3-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
	<1321775788-12520-3-git-send-email-mickflemm@gmail.com>
Date: Mon, 21 Nov 2011 06:43:57 +0800
Message-ID: <CAJ-VmokN00pC40cAhpPYLzkBOpHsRwVC-LZX6=zPTBgaXhc3aw@mail.gmail.com> (sfid-20111120_234406_290699_4687ECC3)
Subject: Re: [PATCH 02/13] ath5k: Maintain PISR snapshot
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. replying to this after having not slept for > 24 hours, thanks to
being in transit between the US and Western Australia..

On 20 November 2011 15:56, Nick Kossifidis <mickflemm@gmail.com> wrote:
> Since we dont read a snapshot of the interrupt
> registers it might be possible to get a new interrupt
> while reading them. In this case we should make sure
> that we clear all SISR bits we get from PISR.

Just to be clear, you _shouldn't_ clear the secondary status mask bit
in the primary status register when you write back 1's to the primary
ISR.
Clear the bits that you read in the secondary status registers. If you
clear the relevant bit in the primary status register then you may
also skip perfectly valid interrupts.

You don't need to check the secondary registers and the primary ISR
bits for consistency. Just read what I did in freebsd-head :
src/sys/dev/ath/ath_hal/ar5416/ar5416_interrupts.c . it works fine.


Adrian
