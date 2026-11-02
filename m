Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651923;
	b=lYy+gouxp48C8SAuRjOr1cYhtkW7Mwp/PMSlkMCBCgirrScv14JGNDr5iXsMREEoyB23
	 bwCW+nMdUFXzkszZLfV8LeHvxyrrd3iZZAtNrZbe82eLZz0dyV+vKFWN3vATsbGrv3wYu
	 bVWluISxOxQRndO10AQy4DpP4LKdIgJTZOCmHskq5gPPiORNm4kJ2q55jyWMzTciei7tk
	 nTAxICh8SKf9zMFVtHIsAftCBA1Zz3D9y6Iq4OQqHJKIhQwNE4ypPmZ0bu95riCaonnwd
	 i+ezet3jDWHvVUjMiIebYhGbjI3lzYdx28RziGzvfiEn84/PuuQRLE1UcuVBIp3zU9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651923;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=r4d8y63Xdbjd20crX3o78pUbXVfOTYV1Q1r5K5FwErE=;
	b=RSRa+F9kG41lu015d01ntfQbbCtVCE0ZqFUSJEdXaoaMcYIMOO4CHi+C9O5jtSr8A319
	 oGBuWSz1ca9PC5UHnYuD7DPT+vclrHUfB9ySucvpKnxgEe5DbPgvlpAH1PtAcuGJEihaQ
	 UzyT5swzbYFMKhWhNCm7JwcykjW/AAeStIasFN8dq1iNU1K1eqHARAJoFBDl1RtDmFA96
	 yHu6lCtdgpCuDQRDsXCQKC1bZj4FxstI3+y5KQu209b8otrKmf8RZwzr6Ph9sDiia8bs2
	 duXg9S7fwIqab8OsIgX4dgsMygOGROFvnJXssTlogzzR5piLQXcyfbVuwvJS7+dYuGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=anLaRVlp;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42676606D83E
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=anLaRVlp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=r4d8y63Xdbjd20crX3o78pUbXVfOTYV1Q1r5K5FwErE=;
	t=1793651922; x=1794861522; b=anLaRVlpvnIuUb9Vd6pWWGuphIZi9q2Pme9i3BWgRPWWODJ
	FVRkgiKdTEXGZ+89IrF60BHiAF0eaixmb9LWdOCsv0EqG5cos50dJIcDVFt0LMR1UzIKcgCWTxNFG
	CSgebCqAQTszSKlXl68OZffEeD7coDTktNJdpn3myTF+S1ombEL71NrSSCoR2HsUOrAU6F3cKD58B
	d25/zk5/CCVvg8SFF7fHMvEN90sSoLOQWMRw8un1nBpLycwFcmYo5qQtRI0eNyZPnjftU4B+39W0l
	U8fcKhJcaD/bhCblKbS4bIp3mtU/zVLT7X69WAFMOoXOQxCZrHYgSRZShR3ZAXiw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyng-00000001vzr-2Iim;
	Mon, 02 Nov 2026 21:38:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/30] wifi: mac80211: rename vif->txq_mgmt to vif->txq_nan_dw
Date: Mon,  2 Nov 2026 21:22:57 +0100
Message-ID: <20261102203831.1058362-39-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This TXQ only exists for NAN to hold packets for the DW,
and really only for hwsim. Rename it to clarify, we may
have planned to reuse it for something else later, but
that doesn't seem to really work anyway.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_nan.c |  6 +++---
 include/net/mac80211.h                            |  6 ++++--
 net/mac80211/iface.c                              |  8 ++++----
 net/mac80211/tx.c                                 |  4 ++--
 net/mac80211/util.c                               | 10 +++++-----
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index 6f90856099e8..733806e9e46b 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
@@ -1197,7 +1197,7 @@ static void mac80211_hwsim_nan_resume_txqs(struct mac80211_hwsim_data *data)
 
 	/* Check if management queue can transmit */
 	if (mac80211_hwsim_nan_txq_transmitting(data->hw,
-						data->nan.device_vif->txq_mgmt))
+						data->nan.device_vif->txq_nan_dw))
 		goto resume_txqs_timer;
 
 	/* Check if any STA queue can transmit */
@@ -1253,9 +1253,9 @@ mac80211_hwsim_nan_resume_txqs_timer(struct hrtimer *timer)
 
 	/* Wake TX queue for management frames on the NAN device interface */
 	if (mac80211_hwsim_nan_txq_transmitting(data->hw,
-						data->nan.device_vif->txq_mgmt))
+						data->nan.device_vif->txq_nan_dw))
 		ieee80211_hwsim_wake_tx_queue(data->hw,
-					      data->nan.device_vif->txq_mgmt);
+					      data->nan.device_vif->txq_nan_dw);
 
 	/* Wake TX queues for all stations */
 	ieee80211_iterate_stations_atomic(data->hw,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 76ff86ff9974..ddaa311f6208 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2225,7 +2225,9 @@ enum ieee80211_neg_ttlm_res {
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void \*).
  * @txq: the multicast data TX queue
- * @txq_mgmt: the mgmt frame TX queue, currently only exists for NAN devices
+ * @txq_nan_dw: TX queue for NAN frames without a station, which the driver
+ *	should hold until the next discovery window (DW) or according to the
+ *	NAN schedule; only exists for NAN device interfaces
  * @offload_flags: 802.3 -> 802.11 enapsulation offload flags, see
  *	&enum ieee80211_offload_flags.
  */
@@ -2244,7 +2246,7 @@ struct ieee80211_vif {
 	u8 hw_queue[IEEE80211_NUM_ACS];
 
 	struct ieee80211_txq *txq;
-	struct ieee80211_txq *txq_mgmt;
+	struct ieee80211_txq *txq_nan_dw;
 
 	netdev_features_t netdev_features;
 	u32 driver_flags;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8bfd6bc9c9fe..a4f29444ba45 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -711,9 +711,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 	if (sdata->vif.txq)
 		ieee80211_txq_purge(sdata->local, to_txq_info(sdata->vif.txq));
 
-	if (sdata->vif.txq_mgmt)
+	if (sdata->vif.txq_nan_dw)
 		ieee80211_txq_purge(sdata->local,
-				    to_txq_info(sdata->vif.txq_mgmt));
+				    to_txq_info(sdata->vif.txq_nan_dw));
 
 	sdata->bss = NULL;
 
@@ -2450,9 +2450,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	if (sdata->vif.txq)
 		ieee80211_txq_purge(sdata->local, to_txq_info(sdata->vif.txq));
 
-	if (sdata->vif.txq_mgmt)
+	if (sdata->vif.txq_nan_dw)
 		ieee80211_txq_purge(sdata->local,
-				    to_txq_info(sdata->vif.txq_mgmt));
+				    to_txq_info(sdata->vif.txq_nan_dw));
 
 	synchronize_rcu();
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b945bd2fcb46..3eff5e934f7e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1305,7 +1305,7 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 		} else if ((!ieee80211_is_mgmt(hdr->frame_control) ||
 			    ieee80211_is_bufferable_mmpdu(skb)) &&
 			   !sta) {
-			txq = vif->txq_mgmt;
+			txq = vif->txq_nan_dw;
 		}
 	} else if (sta) {
 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
@@ -1501,7 +1501,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 		txqi->txq.tid = tid;
 
 		if (tid == IEEE80211_NUM_TIDS) {
-			sdata->vif.txq_mgmt = &txqi->txq;
+			sdata->vif.txq_nan_dw = &txqi->txq;
 			txqi->txq.ac = IEEE80211_AC_VO;
 		} else {
 			sdata->vif.txq = &txqi->txq;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 44feb80274c6..181e4d787837 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -370,18 +370,18 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 	if (vif->txq) {
 		txqi = to_txq_info(vif->txq);
 
-		/* txq and txq_mgmt are mutually exclusive */
-		WARN_ON_ONCE(vif->txq_mgmt);
+		/* txq and txq_nan_dw are mutually exclusive */
+		WARN_ON_ONCE(vif->txq_nan_dw);
 
 		if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY, &txqi->flags) ||
 		    (ps && atomic_read(&ps->num_sta_ps)) ||
 		    ac != vif->txq->ac)
 			txqi = NULL;
-	} else if (vif->txq_mgmt) {
-		txqi = to_txq_info(vif->txq_mgmt);
+	} else if (vif->txq_nan_dw) {
+		txqi = to_txq_info(vif->txq_nan_dw);
 
 		if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY, &txqi->flags) ||
-		    ac != vif->txq_mgmt->ac)
+		    ac != vif->txq_nan_dw->ac)
 			txqi = NULL;
 	}
 
-- 
2.56.0

