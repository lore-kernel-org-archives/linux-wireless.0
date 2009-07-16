Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:33552 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbZGPJXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:23:54 -0400
Received: by bwz28 with SMTP id 28so1926173bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 02:23:52 -0700 (PDT)
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] wl12xx: loop off by one.
References: <4A524E91.9040400@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Jul 2009 12:23:50 +0300
In-Reply-To: <4A524E91.9040400@gmail.com> (Roel Kluin's message of "Mon\, 06 Jul 2009 21\:20\:49 +0200")
Message-ID: <8763dt56c9.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roel Kluin <roel.kluin@gmail.com> writes:

> with `while (loop++ < INIT_LOOP)' `loop' reaches -1 after the loop.

Sorry, my brains are on vacation mode right now and I can't understand
how loop can reach -1. Here's the code:

    loop = 0;
    while (loop++ < INIT_LOOP) {
          ...
    }

    if (loop >= INIT_LOOP) {
       wl1251_error("timeout waiting for the hardware to "
                    "complete initialization");
       return -EIO;
    }

What am I missing?

Also the patch won't apply to wireless-testing because main.c is renamed
to wl1251_main.c.

-- 
Kalle Valo
