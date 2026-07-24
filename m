Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A84444717
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917983; cv=none; b=ZkHppmQ86898eh8OXtQAgwYoYXCxgqgHfD5wtXF2Fe7UNQa0o8yeKj46ScXDTIVzRjRAXVgSa81+loCryCQX3m2/QexNGJ43f89hdbUkY6UVMJSSTQNF8cixoEIJDCehQFzWaSxLIs8vA8m7R45J4gkH0TvCs4AI+c8tpyxxvdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917983; c=relaxed/simple;
	bh=1XTJK3Lx840hTVloJ+QkptAC6R0ATzlOJmWczBGQqVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtYEH08h0nonSpkawXPIeYdkIJAocx2dw9bxVv8ii1A+CRz4n19d88YATbq5wx+u/qlZ4r/hlDnLUJIwbfMJ4NTlDipcenj3u9jBTSiWlijUFNsfKzwdJVjkZzbBkIVmC3qPNUsUGBJtzyAvFQD0urx2e6uJEj51VoGlPTVcL1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=glSK2nkq; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="glSK2nkq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bF/+yfoOunnPOYW7slQ2o9jMNjAekW4n09UoP+cmvv0=;
	b=glSK2nkq+u2qDK2mr6pVCDnt1XMgKwSj9fbSNrlHNUbSTOgnzYChPT0Gq7SbyeN4qQjcOi
	hJpBBmF7QmR5HB2IP+SkRfTrxOF4SydqIJnC5Yz9Vhw2/gVvgs6X13U1+rJg0s6PFx5IT+
	BCWbGw4G62z7r7dCYnJuxEw+68yzy78=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 15/19] wifi: rtw88: record beacons from the target BSSID before authenticating
Date: Fri, 24 Jul 2026 20:32:45 +0200
Message-ID: <20260724183245.197011-1-luka.gejak@linux.dev>
In-Reply-To: <20260724181858.192903-1-luka.gejak@linux.dev>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The vendor start_clnt_join() does not begin authentication until it has
seen a beacon or probe response from the target BSSID, and the RTL8723BS
firmware depends on that ordering: authenticating earlier leaves the
firmware without the BSS parameters it needs and the exchange times out.

Record such frames from the receive path so the join sequence can wait
for one. The recording is gated on the chip and only active during the
pre-authentication window, so it costs other chips a single test per
frame.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 31 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/main.c     |  2 ++
 drivers/net/wireless/realtek/rtw88/main.h     | 20 ++++++++++++
 drivers/net/wireless/realtek/rtw88/sdio.c     |  5 +++
 4 files changed, 58 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index b01b98d24b0a..ff0f4f0bdc7b 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -15,6 +15,37 @@
 #include "wow.h"
 #include "sar.h"
 
+/* 8723BS SDIO: record a beacon/probe-resp seen from the target BSSID during
+ * the pre-auth window so the join sequence (mgd_prepare_tx) can wait for it,
+ * mirroring the vendor start_clnt_join(). Called from the SDIO RX path.
+ */
+void rtw8723bs_auth_sync_rx(struct rtw_dev *rtwdev,
+			    const struct ieee80211_hdr *hdr, u32 len,
+			    const struct rtw_rx_pkt_stat *pkt_stat,
+			    const struct ieee80211_rx_status *rx_status)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+	unsigned long flags;
+	__le16 fc = hdr->frame_control;
+
+	if (!rtw_is_8723bs(rtwdev) ||
+	    test_bit(RTW_FLAG_SCANNING, rtwdev->flags) ||
+	    pkt_stat->crc_err || pkt_stat->icv_err)
+		return;
+
+	if (!ieee80211_is_beacon(fc) && !ieee80211_is_probe_resp(fc))
+		return;
+
+	spin_lock_irqsave(&sync->lock, flags);
+	if (sync->active && ether_addr_equal(hdr->addr3, sync->bssid)) {
+		sync->seen = true;
+		sync->seen_count++;
+		wake_up(&sync->wait);
+	}
+	spin_unlock_irqrestore(&sync->lock, flags);
+}
+EXPORT_SYMBOL(rtw8723bs_auth_sync_rx);
+
 static void rtw_ops_tx(struct ieee80211_hw *hw,
 		       struct ieee80211_tx_control *control,
 		       struct sk_buff *skb)
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index cd9254370fcc..16228cae252e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2174,11 +2174,13 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
+	spin_lock_init(&rtwdev->auth_sync.lock);
 
 	mutex_init(&rtwdev->mutex);
 	mutex_init(&rtwdev->hal.tx_power_mutex);
 
 	init_waitqueue_head(&rtwdev->coex.wait);
+	init_waitqueue_head(&rtwdev->auth_sync.wait);
 	init_completion(&rtwdev->lps_leave_check);
 	init_completion(&rtwdev->fw_scan_density);
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 9c435c160b61..4918661c92e5 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2060,6 +2060,20 @@ struct rtw_hw_scan_info {
 	u8 op_bw;
 };
 
+/*
+ * Synchronises the pre-auth wait on a beacon or probe response from the
+ * target BSSID before the join sequence continues.
+ */
+struct rtw_auth_sync {
+	wait_queue_head_t wait;
+	/* Protects the fields below. */
+	spinlock_t lock;
+	u8 bssid[ETH_ALEN];
+	bool active;
+	bool seen;
+	u32 seen_count;
+};
+
 struct rtw_dev {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -2136,6 +2150,8 @@ struct rtw_dev {
 	struct completion fw_scan_density;
 	bool ap_active;
 
+	struct rtw_auth_sync auth_sync;
+
 	bool led_registered;
 	char led_name[32];
 	struct led_classdev led_cdev;
@@ -2293,4 +2309,8 @@ bool rtw_core_check_sta_active(struct rtw_dev *rtwdev);
 void rtw_core_enable_beacon(struct rtw_dev *rtwdev, bool enable);
 void rtw_set_ampdu_factor(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf);
+void rtw8723bs_auth_sync_rx(struct rtw_dev *rtwdev,
+			    const struct ieee80211_hdr *hdr, u32 len,
+			    const struct rtw_rx_pkt_stat *pkt_stat,
+			    const struct ieee80211_rx_status *rx_status);
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index f472fe918b12..9cf43df2ec3f 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1267,6 +1267,11 @@ static void rtw_sdio_rx_skb(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	rtw_update_rx_freq_for_invalid(rtwdev, skb, rx_status, pkt_stat);
 	rtw_rx_stats(rtwdev, pkt_stat->vif, skb);
 
+	if (skb->len >= sizeof(struct ieee80211_hdr_3addr))
+		rtw8723bs_auth_sync_rx(rtwdev,
+				       (struct ieee80211_hdr *)skb->data,
+				       skb->len, pkt_stat, rx_status);
+
 	ieee80211_rx_irqsafe(rtwdev->hw, skb);
 }
 
-- 
2.55.0

