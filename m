Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44115 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZK1VA2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 16:00:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] mac80211: annotate sleeping driver ops
Date: Sat, 28 Nov 2009 22:00:26 +0100
Cc: linux-wireless@vger.kernel.org
References: <1259439566-26397-1-git-send-email-kalle.valo@iki.fi>
In-Reply-To: <1259439566-26397-1-git-send-email-kalle.valo@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911282200.28477.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 28 November 2009 21:19:26 Kalle Valo wrote:
> mac80211 doesn't seem to use get_tx_stats anywhere currently. Just to be on
> the safe side, I documented it to be atomic, but hopefully the op can be
> removed in the future.

Well, b43 takes a mutex in that callback. I think that's OK, because if it's
never called, it's pretty safe to sleep there. ;)

-- 
Greetings, Michael.
