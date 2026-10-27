Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131092;
	b=j2OSm6YSVzKf+oTnAqosc+sMtY0KHNYE76TMVjNImSxW2TuDYQmowTf+49n+AJysoDXX
	 X4uFJjcviOo+Qx2MJe03oqTQp9/6LjYMglnp3uH81HeR4/IifYdpBVvFUOj6KMx6hEyS5
	 GEdhmyo3exQJP1LsQI1APnHCUmPVeDjLBWqmrbepv9YutqZvK6TJ379BPxc0qBBRNQMYN
	 sX75Bx+A9Qat+20fErE5z/aBn7AzT0KyruJssJtmCyRf5wRjd9Ypxb1AZB8IMzkWlvN4j
	 pfdYvQogbNWSYojMSpMAI64tB3JIS8AHcQCaw8xGxhjpBRAet6ovYsSjezZxHDQjvlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131092;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=95AvJzhM/xchB8MDXKPml0VKPautXK0pNjPRNtwLzXM=;
	b=2FAZebt9AZGDN7Mvn+uLinm4Jk7mo5tygxWjZWL9AzsM1mnHI+B+Fi/wB6bdwAK8jvmI
	 s6nDHCE5KGl1RK4j2PSnforRnNZkv65Dy/xWGdXv3F4QdHy7gKBja5oNT3mayL7L1qI+F
	 4irYJmrIzz8mNRhLb6GA9JOvOD69FDDpenL4lGOE9nEKkZ76/4d/JRtRmdJev5kun6psa
	 TmPcR5LVMmzU7uPXc7v5CAVQ3EHVK+cJzwfioBH9E0Ym/09STHW4uociARE8PHiAMV/j3
	 30qnFZ0ZwY1SNQrUQeszaTpo1qGQR/tUCYTQJFrkN/pip4HwT0Yjo0ukpt/Mj25vAGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=BwhvQ+6s;
	arc=none smtp.remote-ip=95.215.58.10
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACB6606A325
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 19:58:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EACB6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=BwhvQ+6s
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rf4bkKBreJMKUhLWa2MhNhS0R72OKtKUMeDb7Bu1cyY=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793131089; v=1; x=1793735889;
 b=BwhvQ+6s9tGlExaVaHz5c7QK/TthSqF/7sd/4GX6k/L1TtiXejK/HhaxV8cfiakrMsGzvTZZ
 g/MP7YV2OUIotWm8LfV2+XiawfH2YwNO8ctONA6ocCLG+4+f7AABHsxMIKHz1V5h/samCD5EGuo
 A+hAWy2Vj46BLCIsaHo0T/GP64ELU41zs+QeeZnWppI4niyq9bi+Mv8KfTc2D+tWA/9PuXJfWh3
 Q9a2bEsPdwPY8B3nY1sOKPFZHPRXR3Md6BQzqRf4j/cH1WTUnxKpN5FywhfTzSptJfzCQdLV5hc
 cdyUw2S9ejxiOzUmOcdCD5wMyD45+K3gtZk/HHFrfj1NQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 04edb0909a657703;
	Tue, 27 Oct 2026 19:58:09 +0000
X-Mizu-Trace-ID: 04edb0909a657703
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Alex Gavin <a_gavin@icloud.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless 1/4] wifi: mt76: mt7921: keep the sniffer on for real monitor vifs
Date: Tue, 27 Oct 2026 12:58:00 -0700
Message-ID: <20261027195803.711995-2-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027195803.711995-1-lucid_duck@justthetip.ca>
References: <20261027195803.711995-1-lucid_duck@justthetip.ca>
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

mac80211 sets its monitor flag only for the virtual monitor, so a
monitor that reaches the driver as its own vif is not treated as one
and goes deaf after a scan.

Count monitor vifs and treat one like the monitor flag. Start a new
monitor's sniffer on the radio's current channel, and set it up again
after a scan and when another interface goes down, where mac80211
would add the virtual monitor back.

Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 .../wireless/mediatek/mt76/mt7921/debugfs.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 82 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  5 +-
 .../wireless/mediatek/mt76/mt7921/testmode.c  |  4 +-
 drivers/net/wireless/mediatek/mt76/mt792x.h   | 10 +++
 5 files changed, 94 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 62bf33347e9e..685cfddab749 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -189,7 +189,7 @@ mt7921_deep_sleep_set(void *data, u64 val)
 {
 	struct mt792x_dev *dev = data;
 	struct mt76_connac_pm *pm = &dev->pm;
-	bool monitor = !!(dev->mphy.hw->conf.flags & IEEE80211_CONF_MONITOR);
+	bool monitor = mt792x_monitor_active(dev);
 	bool enable = !!val;
 
 	if (mt76_is_usb(&dev->mt76))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 09574d4417cd..40e614b11110 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -297,6 +297,9 @@ static void mt7921_stop(struct ieee80211_hw *hw, bool suspend)
 	mt792x_stop(hw, false);
 }
 
+static void
+mt7921_sniffer_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif);
+
 static int
 mt7921_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
@@ -347,6 +350,15 @@ mt7921_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		mtxq->wcid = idx;
 	}
 
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		dev->monitor_vifs++;
+		mt7921_sniffer_interface_iter(dev, NULL, vif);
+		mt7921_mcu_config_sniffer(mvif, NULL);
+		ieee80211_iterate_active_interfaces_mtx(hw,
+							IEEE80211_IFACE_ITER_RESUME_ALL,
+							mt7921_sniffer_interface_iter, dev);
+	}
+
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 	if (phy->chip_cap & MT792x_CHIP_CAP_RSSI_NOTIFY_EVT_EN)
 		vif->driver_flags |= IEEE80211_VIF_SUPPORTS_CQM_RSSI;
@@ -359,6 +371,66 @@ mt7921_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	return ret;
 }
 
+static void
+mt7921_monitor_collect_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ieee80211_vif **mon = priv;
+	int i;
+
+	if (vif->type != NL80211_IFTYPE_MONITOR)
+		return;
+
+	for (i = 0; i < MT792x_MAX_INTERFACES; i++) {
+		if (!mon[i]) {
+			mon[i] = vif;
+			return;
+		}
+	}
+}
+
+/* A scan takes the radio off the monitor's channel and the sniffer does
+ * not come back by itself, so set it up again when a scan completes or
+ * another interface goes down. The commands sleep, so collect the
+ * monitors first. Called with the device mutex held.
+ */
+static void mt7921_monitor_rearm(struct mt792x_dev *dev)
+{
+	struct ieee80211_vif *mon[MT792x_MAX_INTERFACES] = {};
+	int i;
+
+	if (!dev->monitor_vifs)
+		return;
+
+	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+						   IEEE80211_IFACE_ITER_RESUME_ALL,
+						   mt7921_monitor_collect_iter, mon);
+	for (i = 0; i < MT792x_MAX_INTERFACES && mon[i]; i++) {
+		struct mt792x_vif *mvif = (struct mt792x_vif *)mon[i]->drv_priv;
+		struct ieee80211_chanctx_conf *ctx = mvif->bss_conf.mt76.ctx;
+
+		mt7921_mcu_set_sniffer(dev, mon[i], true);
+		if (ctx)
+			mt7921_mcu_config_sniffer(mvif, ctx);
+	}
+}
+
+static void
+mt7921_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+
+	mt792x_remove_interface(hw, vif);
+
+	mt792x_mutex_acquire(dev);
+	if (vif->type != NL80211_IFTYPE_MONITOR)
+		mt7921_monitor_rearm(dev);
+	else if (!--dev->monitor_vifs)
+		ieee80211_iterate_active_interfaces_mtx(hw,
+							IEEE80211_IFACE_ITER_RESUME_ALL,
+							mt7921_sniffer_interface_iter, dev);
+	mt792x_mutex_release(dev);
+}
+
 static void mt7921_roc_iter(void *priv, u8 *mac,
 			    struct ieee80211_vif *vif)
 {
@@ -603,9 +675,8 @@ static void
 mt7921_sniffer_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct mt792x_dev *dev = priv;
-	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct mt76_connac_pm *pm = &dev->pm;
-	bool monitor = !!(hw->conf.flags & IEEE80211_CONF_MONITOR);
+	bool monitor = mt792x_monitor_active(dev);
 
 	mt7921_mcu_set_sniffer(dev, vif, monitor);
 	pm->enable = pm->enable_user && !monitor;
@@ -621,7 +692,7 @@ void mt7921_set_runtime_pm(struct mt792x_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct mt76_connac_pm *pm = &dev->pm;
-	bool monitor = !!(hw->conf.flags & IEEE80211_CONF_MONITOR);
+	bool monitor = mt792x_monitor_active(dev);
 
 	pm->enable = pm->enable_user && !monitor;
 	ieee80211_iterate_active_interfaces(hw,
@@ -1051,6 +1122,9 @@ void mt7921_scan_work(struct work_struct *work)
 			};
 
 			ieee80211_scan_completed(phy->mt76->hw, &info);
+			mt792x_mutex_acquire(phy->dev);
+			mt7921_monitor_rearm(phy->dev);
+			mt792x_mutex_release(phy->dev);
 		}
 		dev_kfree_skb(skb);
 	}
@@ -1566,7 +1640,7 @@ const struct ieee80211_ops mt7921_ops = {
 	.start = mt7921_start,
 	.stop = mt7921_stop,
 	.add_interface = mt7921_add_interface,
-	.remove_interface = mt792x_remove_interface,
+	.remove_interface = mt7921_remove_interface,
 	.config = mt7921_config,
 	.conf_tx = mt792x_conf_tx,
 	.configure_filter = mt7921_configure_filter,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index a0caa77339ee..f0fa8b749c1d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -946,7 +946,7 @@ int mt7921_mcu_set_chan_info(struct mt792x_phy *phy, int cmd)
 		req.channel_band = chandef->chan->band;
 
 	if (cmd == MCU_EXT_CMD(SET_RX_PATH) ||
-	    (dev->mt76.hw->conf.flags & IEEE80211_CONF_MONITOR &&
+	    (mt792x_monitor_active(dev) &&
 	     !phy->mt76->offchannel))
 		req.switch_reason = CH_SWITCH_NORMAL;
 	else if (phy->mt76->offchannel)
@@ -1215,7 +1215,8 @@ int mt7921_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 int mt7921_mcu_config_sniffer(struct mt792x_vif *vif,
 			      struct ieee80211_chanctx_conf *ctx)
 {
-	struct cfg80211_chan_def *chandef = &ctx->def;
+	struct mt76_phy *mphy = vif->phy->mt76;
+	struct cfg80211_chan_def *chandef = ctx ? &ctx->def : &mphy->chandef;
 	int freq1 = chandef->center_freq1, freq2 = chandef->center_freq2;
 	static const u8 ch_band[] = {
 		[NL80211_BAND_2GHZ] = 1,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
index ce95b0db1428..7fd39538aeea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
@@ -121,7 +121,7 @@ int mt7921_testmode_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int err;
 
 	if (!test_bit(MT76_STATE_RUNNING, &mphy->state) ||
-	    !(hw->conf.flags & IEEE80211_CONF_MONITOR))
+	    !mt792x_monitor_active(phy->dev))
 		return -ENOTCONN;
 
 	err = nla_parse_deprecated(tb, MT76_TM_ATTR_MAX, data, len,
@@ -158,7 +158,7 @@ int mt7921_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *msg,
 	int err;
 
 	if (!test_bit(MT76_STATE_RUNNING, &mphy->state) ||
-	    !(hw->conf.flags & IEEE80211_CONF_MONITOR) ||
+	    !mt792x_monitor_active(phy->dev) ||
 	    !mt76_testmode_enabled(mphy))
 		return -ENOTCONN;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index a7d71e007da0..ac26c3f7c7e2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -324,6 +324,7 @@ struct mt792x_dev {
 
 	u8 fw_debug;
 	u8 fw_features;
+	u8 monitor_vifs;
 
 	struct mt76_connac_pm pm;
 	struct mt76_connac_coredump coredump;
@@ -455,6 +456,15 @@ mt792x_get_status_freq_info(struct mt76_rx_status *status, u8 chfreq)
 	status->freq = ieee80211_channel_to_frequency(chfreq, status->band);
 }
 
+/* A monitor that reaches the driver as its own vif does not set
+ * IEEE80211_CONF_MONITOR, so count those too.
+ */
+static inline bool mt792x_monitor_active(struct mt792x_dev *dev)
+{
+	return (mt76_hw(dev)->conf.flags & IEEE80211_CONF_MONITOR) ||
+	       dev->monitor_vifs;
+}
+
 static inline bool mt792x_dma_need_reinit(struct mt792x_dev *dev)
 {
 	return !mt76_get_field(dev, MT_WFDMA_DUMMY_CR, MT_WFDMA_NEED_REINIT);
-- 
2.56.0

