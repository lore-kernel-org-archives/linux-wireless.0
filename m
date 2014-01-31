Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331AbaAaThC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 14:37:02 -0500
Date: Fri, 31 Jan 2014 20:38:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ath9k_htc: avoid scheduling while atomic on
 sta_rc_update
Message-ID: <20140131193850.GC7648@redhat.com> (sfid-20140131_203707_519477_7C80D497)
References: <20140131133707.GA7648@redhat.com>
 <52EBEA45.5090606@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52EBEA45.5090606@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 31, 2014 at 07:24:05PM +0100, Oleksij Rempel wrote:
> I have different HW. How can trigger sta_rc_update?

Below patch should trigger it when any management frame is received
from know sta and print information about it. 

Thanks
Stanislaw

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c9254a6..5cfc98c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1346,9 +1346,7 @@ static void ath9k_htc_sta_rc_update(struct ieee80211_hw *hw,
 {
 	struct ath9k_htc_sta *ista = (struct ath9k_htc_sta *) sta->drv_priv;
 
-	if (!(changed & IEEE80211_RC_SUPP_RATES_CHANGED))
-		return;
-
+	printk("%s: schedule work\n", __func__);
 	schedule_work(&ista->rc_update_work);
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c24ca0d..642b326 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2847,8 +2847,10 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 	rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
 	skb_queue_tail(&sdata->skb_queue, rx->skb);
 	ieee80211_queue_work(&rx->local->hw, &sdata->work);
-	if (rx->sta)
+	if (rx->sta) {
 		rx->sta->rx_packets++;
+		drv_sta_rc_update(rx->local, rx->sta->sdata, &rx->sta->sta, 0);
+	}
 
 	return RX_QUEUED;
 }

