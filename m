Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55360 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593Ab0DPVNG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:13:06 -0400
Subject: Re: [ath5k-devel] [PATCH] ath5k/ath9k: Fix 64 bits TSF reads
From: Pavel Roskin <proski@gnu.org>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath5k.org
In-Reply-To: <1271369246-6892-1-git-send-email-benoit.papillault@free.fr>
References: <1271369246-6892-1-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain
Date: Fri, 16 Apr 2010 17:13:04 -0400
Message-Id: <1271452384.16507.16.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 00:07 +0200, Benoit Papillault wrote:

> It follows the logic mentionned by Derek, with only 2 register reads
> needed at each additional steps instead of 3 (the minimum number of
> register reads is still 3).

I would prefer an approach whereas tsf_upper2 or tsf_upper1 is chosen
based on whether tsf_lower is more or less than 0x80000000 if
(tsf_upper2 - tsf_upper1) is 1.  If the difference is not 0 or 1, either
the hardware is broken or the kernel was stuck for so long (71 minutes!)
that getting the exact tsf should be the least worry.  That's when
WARN_ON would be appropriate.

The problem with overengineered code is that it doesn't break when it's
better to break and expose the problem :-)

But it's just a suggestion, not a NACK.  It's better to have some fix
than no fix at all.
 
-- 
Regards,
Pavel Roskin
