Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40477 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZDVTv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:51:56 -0400
Received: by fxm2 with SMTP id 2so165790fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 12:51:54 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/6] wl12xx: separate platform data into arch-independent code
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
	<1238897428-19639-4-git-send-email-me@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 22:51:52 +0300
In-Reply-To: <1238897428-19639-4-git-send-email-me@bobcopeland.com> (Bob Copeland's message of "Sat\,  4 Apr 2009 22\:10\:25 -0400")
Message-ID: <87fxg0eaav.fsf@litku.valot.fi> (sfid-20090422_215159_955436_C16BFB2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> In order to build the wl12xx driver on any arch, extract the SPI
> config struct into include/linux/spi/ and remove the OMAP tag-based
> retrieval.  The board code can then set the platform data on
> the spi struct device before probe.

I dropped this one because I had done this a bit differently. Basically
I moved all gpio code from wl12xx to the board file:

struct wl12xx_platform_data {
       void (*set_power)(bool enable);
};

And the irq is delivered in spi_board_info.irq. Please take a look and
comment.

-- 
Kalle Valo
