Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49431 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1HZOaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 10:30:25 -0400
Date: Fri, 26 Aug 2011 10:22:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com,
	Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status()
 to avoid deadlock
Message-ID: <20110826142210.GE2579@tuxdriver.com> (sfid-20110826_163027_272249_1978877A)
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
> lock is released or (2) release the lock before invoking
> ieee80211_tx_status().  The ath9k driver implements the second approach
> (see ath_tx_complete() in ath9k/xmit.c) as well as the rt2x00 and b43
> drivers.  The iwl driver, on the other hand, avoids this problem by
> invoking  ieee80211_tx_status_irqsafe() which effectively defers
> processing of transmission feedback status.  This last approach is the
> least intrusive is implemented here.
> 
> Reported by Pedro Larbig (ASPj)
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Missing Signed-off-by...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
