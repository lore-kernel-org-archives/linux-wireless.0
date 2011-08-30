Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1H3MVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 08:21:08 -0400
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status()
 to avoid deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1314236064-6339-1-git-send-email-thomas@cozybit.com> (sfid-20110825_033444_439163_B9A65422)
References: <1314236064-6339-1-git-send-email-thomas@cozybit.com>
	 (sfid-20110825_033444_439163_B9A65422)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 14:21:07 +0200
Message-ID: <1314706867.4011.25.camel@jlt3.sipsolutions.net> (sfid-20110830_142111_755364_1318815D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-24 at 18:34 -0700, Thomas Pedersen wrote:
> From: Javier Cardona <javier@cozybit.com>
> 
> This driver reports transmission status to the upper layer
> (ath5k_tx_frame_completed()) while holding the lock on the transmission
> queue (txq->lock).  Under failure conditions, the mesh stack will
> attempt to send PERR messages to the previous sender of the failed
> frame.

I'd feel a lot more comfortable if the mesh stack didn't do that. I
suppose it could use ieee80211_add_pending_skb() instead?

johannes

