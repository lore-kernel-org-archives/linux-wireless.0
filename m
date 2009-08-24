Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:50554 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZHXXeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 19:34:36 -0400
Received: by iwn42 with SMTP id 42so1119674iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 16:34:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090820145239.GC2657@tuxdriver.com>
References: <4A7CA188.1070706@gmail.com> <20090810202622.GB6060@tuxdriver.com>
	<4A811464.4030108@gmail.com> <20090811182514.GF2634@tuxdriver.com>
	<20090820145239.GC2657@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 24 Aug 2009 16:34:18 -0700
Message-ID: <43e72e890908241634w37868afelf28eff02789f3016@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix read buffer overflow
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Roel Kluin <roel.kluin@gmail.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>, m.sujith@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 20, 2009 at 7:52 AM, John W. Linville<linville@tuxdriver.com> wrote:
> Anybody?

Sorry for the delay,

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

This is actually pretty sloppy existing code and I'd prefer to see
this nasty POS code rewritten to avoid such nasty checks from the
start. Also notice how both ath9k_hw_get_legacy_target_powers() and
ath9k_hw_get_target_powers() do exactly the same, except they use a
different name for the bool, a different structure for the calibrated
power targets (array size changes on one element of the struct). But
this patch also fixes another not-noted potential negative rade index
access: lowIndex could be -1 under a special circumstance and this
would prevent that negative index access as well on powInfo[lowIndex].
So although this probably just does not happen right now its safer to
have a fix for two of these theoretical negative array index access
than nothing at hand; a proper rewrite of these two routines as I want
it would require quite a few changes here and more testing. Mentally
lets add that to the TODO list..

  Luis
