Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1635 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1AZBuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 20:50:25 -0500
Date: Tue, 25 Jan 2011 20:50:34 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, Bruno Randolf <br1@einfach.org>,
	jirislaby@gmail.com, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath5k: fix error handling in ath5k_hw_dma_stop
Message-ID: <20110126015034.GA8600@hash.localnet>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com> <20110125135249.GA2610@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110125135249.GA2610@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 24 Jan 2011 09:25:11 -0500
Subject: [PATCH] ath5k: fix error handling in ath5k_hw_dma_stop

Review spotted a problem with the error handling in ath5k_hw_dma_stop:
a successful return from ath5k_hw_stop_tx_dma will be treated as
an error, so we always bail out of the loop after processing a single
active queue.  As a result, we may not actually stop some queues during
reset.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

> Patch is good, but does not make code fully correct. When last queue
> is inactive, we return -EINVAL from ath5_hw_dma_stop(). So we need
> also:
> 
>  		if (err && err != -EINVAL)
>  			return err;
> +		err = 0;
>  	}

> But perhaps, would be better just return 0 from 
> ath5k_hw_stop_tx_dma() when queue is inactive.

How about this version instead?  Although returning 0 in the inactive
queue case would be ok, I'd like to keep the diff small since this
seems to fix some reset problems people are now seeing in Linus's tree
and if so I'd like to get it in 2.6.38.

> I think that could fix "ath5k phy0: can't reset hardware (-5)"
> bugs reported in a few places, so patch should go to stable
> as well.

I thought this was older code but it actually landed after 2.6.37
so no need for stable CC.

As a side note, we still quit when the first error is encountered.
Maybe we should try stopping all of the queues anyway if one fails?
On the other hand we could spend a lot of time polling the registers
if the card is truly hosed, so I think this is best for now.

 drivers/net/wireless/ath/ath5k/dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 0064be7..21091c2 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -838,9 +838,9 @@ int ath5k_hw_dma_stop(struct ath5k_hw *ah)
 	for (i = 0; i < qmax; i++) {
 		err = ath5k_hw_stop_tx_dma(ah, i);
 		/* -EINVAL -> queue inactive */
-		if (err != -EINVAL)
+		if (err && err != -EINVAL)
 			return err;
 	}
 
-	return err;
+	return 0;
 }
-- 
1.7.1.1


-- 
Bob Copeland %% www.bobcopeland.com

