Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f189.google.com ([209.85.221.189]:52601 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZFCWyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 18:54:44 -0400
Received: by qyk27 with SMTP id 27so591157qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2009 15:54:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243991624-12406-1-git-send-email-lrodriguez@atheros.com>
References: <1243991624-12406-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 3 Jun 2009 15:54:25 -0700
Message-ID: <43e72e890906031554j5ab00c58w6f4826b339192d7a@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: add locking for rc private data
To: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2009 at 6:13 PM, Luis R. Rodriguez
> Here's an attempt to lock the ath9k rc private data but I
> get a lockdep complaint on this and not sure how to resolve it yet.

As it turns out the locking of the rate control private are *does* not
resolve the incorrect rate table issue we were seeing. In fact the
device works with it but every now and then would see issues with DMA,
the laptop I can reproduce this on is at home and I forgot to send me
the log. I'll try to send that tonight, but at least this indicates
some other incorrect assumption is being made in the rate control code
or driver.

If it helps the traces of WARN_ON indicate this happens mostly when
sending the null func, not sure why. This needs some further review
and because of this until then we'll just have to down grade that
ASSERT.

  Luis
