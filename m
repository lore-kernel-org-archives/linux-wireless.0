Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3126 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1HYKUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 06:20:02 -0400
Date: Thu, 25 Aug 2011 05:48:49 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status()
 to avoid deadlock
Message-ID: <20110825094849.GA9454@hash.lan> (sfid-20110825_122006_930355_5AF53502)
References: <1314236064-6339-1-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1314236064-6339-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 06:34:24PM -0700, Thomas Pedersen wrote:
> From: Javier Cardona <javier@cozybit.com>
> 
> This driver reports transmission status to the upper layer
> (ath5k_tx_frame_completed()) while holding the lock on the transmission
> queue (txq->lock).  Under failure conditions, the mesh stack will
> attempt to send PERR messages to the previous sender of the failed
> frame.  When that happens the driver will attempt to re-acquire the
> txq->lock lock causing a deadlock.  There are two possible fixes for
> this, (1) we could defer the transmission of the PERR frame until the
> lock is released or 

Of course, as a lazy driver writer I would like this one.  Esp. without
at least a comment in tx_status that it can call back into the driver.

> (2) release the lock before invoking ieee80211_tx_status().  

I was initially worried that we might race against draining buffers
that might also want to free the skb.  That is not the case (skb is
already removed from the structure) -- but there could potentially
be other races with drain since we're mucking with the list that
we're iterating over.  I'm least enthused with this approach.

> (see ath_tx_complete() in ath9k/xmit.c) as well as the rt2x00 and b43
> drivers.  The iwl driver, on the other hand, avoids this problem by
> invoking  ieee80211_tx_status_irqsafe() which effectively defers
> processing of transmission feedback status.  This last approach is the
> least intrusive is implemented here.

I guess it's ok.  The only real potential fallout would be worse rate
adaptation?  Perhaps needs a comment so no one fixes it later.

-- 
Bob Copeland %% www.bobcopeland.com

