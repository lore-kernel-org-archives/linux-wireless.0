Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.212
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131095;
	b=1Mc+mifNqiywiz1ZxfYxDO5JQ8eSd7zcU6MTBYtHVibamUXh98+hW2lf37lKOeOEeJNG
	 5XEBuz0Vc4FRo5C4g7is2pOFNFUPCR8ubZFXt85hw8fIliFfpSqowqcofGgWExKBIffL8
	 qZi6sdlB8R2WeQnGuBwTsqEicQOPbOy1hwcUPt1FKGtqZXbKEvBK3Y6LUhkGlbzTEUMfl
	 aHF3lenoVuc+S4KODc2SBlEy4PQtNRRvK93jVYvxMX/StYQdxxEaHeDpvYhapgJYaYjbY
	 h/bvN8010pXj71GJzjZhZZ5Yqu3bos1XaCunlzkp3hhTcBhmM7jAAd4QmZrbCiTScDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131095;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qsUG5Zk8v3IEuJJ7mJqMR6RGMVpVpKxo/Zjg1ORWck8=;
	b=GlVnjZ91TbeR4yF5kBwBxz0zP0wZnRIPAOqrfYapafNGxa13apn81qzpaAigzEpXPhUc
	 pAzIDHX/Z+hY6vwcSeT5yU/KMgZMkdQXQFlQmkRQobIaPQZIDVJJEwRgfGPuENYtd6DFC
	 XLubTQdzPE4Cq+voqk7orkPaBUtD1rauY2ky3AaQwPff/oiD5TTPdlI/tz1ZW4XwjAPu/
	 JKSLXnG+TvFFD9dqP5O9zneAbIL7ddhN/wec41bmxpDMQ4ZK8mO/r3zL+2aBPgCNzSaTn
	 R2Lu3dsQaRDotmR+Z8+Eq+1m9S0IXtu+o55CTa6SzcD4lphRC8JPpxMcxvbS1PptZoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=Po1Lp6Jo;
	arc=none smtp.remote-ip=91.218.175.212
Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFEB606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 19:58:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FFEB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=Po1Lp6Jo
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oh4D1sU69bhCa7Auc+0KWLfewoUg2Bhjc9taxw6+S+E=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793131092; v=1; x=1793735892;
 b=Po1Lp6JoQ9YgrH8xAOAXE7vzJMmiEYOq095ohNVaP88/cADnrNqCxu8DAIOgM4e/1CxWPv52
 xVBSOKslmXgyXooAJUEu6xfKntYB5+D9CWr7ev0fFusamRwiteAJ7uLtfzYm/Y6pMr5IV+pmliN
 UqFvZL0dKu+BQUkTkW2YuzsfgWH8giW6EOhnMeS/mIxaM6dSDbbcGsJ9cVl7dbCRFuRzud2UmMT
 6Ox5lYZSdRyDcLyVfosCAGbcbuiBvqyCaXIN992iFebfAtUgCuZ2M0es0AFh6dJuBIim4STYGYj
 +73cLErMAiAVhw+UJvbBUI7nvNj1AjHyl+WiOYEtZ5iFA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 67e5cb9483b3b829;
	Tue, 27 Oct 2026 19:58:12 +0000
X-Mizu-Trace-ID: 67e5cb9483b3b829
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
Subject: [PATCH wireless 2/4] wifi: mt76: mt7925: keep the sniffer on for real monitor vifs
Date: Tue, 27 Oct 2026 12:58:01 -0700
Message-ID: <20261027195803.711995-3-lucid_duck@justthetip.ca>
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
monitor that reaches the driver as its own vif, as every monitor on
MT7927 does, is not treated as one and goes deaf after a scan.

Count monitor vifs and treat one like the monitor flag. Start a new
monitor's sniffer on the radio's current channel, and set it up again
after a scan and when another interface goes down, where mac80211
would add the virtual monitor back.

Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 .../wireless/mediatek/mt76/mt7925/debugfs.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 70 ++++++++++++++++++-
 .../wireless/mediatek/mt76/mt7925/testmode.c  |  4 +-
 3 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index d01ff49de47a..038ace1f0369 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -228,7 +228,7 @@ mt7925_deep_sleep_set(void *data, u64 val)
 {
 	struct mt792x_dev *dev = data;
 	struct mt76_connac_pm *pm = &dev->pm;
-	bool monitor = !!(dev->mphy.hw->conf.flags & IEEE80211_CONF_MONITOR);
+	bool monitor = mt792x_monitor_active(dev);
 	bool enable = !!val;
 
 	if (mt76_is_usb(&dev->mt76))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 22cc5b49da0a..08d860f0ec70 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -451,6 +451,9 @@ static int mt7925_mac_link_bss_add(struct mt792x_dev *dev,
 	return ret;
 }
 
+static void
+mt7925_sniffer_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif);
+
 static int
 mt7925_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
@@ -471,6 +474,15 @@ mt7925_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	if (ret < 0)
 		goto out;
 
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		dev->monitor_vifs++;
+		mt7925_sniffer_interface_iter(dev, NULL, vif);
+		mt7925_mcu_config_sniffer(mvif, NULL);
+		ieee80211_iterate_active_interfaces_mtx(hw,
+							IEEE80211_IFACE_ITER_RESUME_ALL,
+							mt7925_sniffer_interface_iter, dev);
+	}
+
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 	if (phy->chip_cap & MT792x_CHIP_CAP_RSSI_NOTIFY_EVT_EN)
 		vif->driver_flags |= IEEE80211_VIF_SUPPORTS_CQM_RSSI;
@@ -486,6 +498,49 @@ mt7925_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	return ret;
 }
 
+static void
+mt7925_monitor_collect_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
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
+static void mt7925_monitor_rearm(struct mt792x_dev *dev)
+{
+	struct ieee80211_vif *mon[MT792x_MAX_INTERFACES] = {};
+	int i;
+
+	if (!dev->monitor_vifs)
+		return;
+
+	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+						   IEEE80211_IFACE_ITER_RESUME_ALL,
+						   mt7925_monitor_collect_iter, mon);
+	for (i = 0; i < MT792x_MAX_INTERFACES && mon[i]; i++) {
+		struct mt792x_vif *mvif = (struct mt792x_vif *)mon[i]->drv_priv;
+		struct ieee80211_chanctx_conf *ctx = mvif->bss_conf.mt76.ctx;
+
+		mt7925_mcu_set_sniffer(dev, mon[i], true);
+		if (ctx)
+			mt7925_mcu_config_sniffer(mvif, ctx);
+	}
+}
+
 static void
 mt7925_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
@@ -501,6 +556,13 @@ mt7925_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	mconf = mt792x_link_conf_to_mconf(&vif->bss_conf);
 	mt792x_mac_link_bss_remove(dev, mconf, &mvif->sta.deflink);
 
+	if (vif->type != NL80211_IFTYPE_MONITOR)
+		mt7925_monitor_rearm(dev);
+	else if (!--dev->monitor_vifs)
+		ieee80211_iterate_active_interfaces_mtx(hw,
+							IEEE80211_IFACE_ITER_RESUME_ALL,
+							mt7925_sniffer_interface_iter, dev);
+
 	mt792x_mutex_release(dev);
 }
 
@@ -798,9 +860,8 @@ static void
 mt7925_sniffer_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct mt792x_dev *dev = priv;
-	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct mt76_connac_pm *pm = &dev->pm;
-	bool monitor = !!(hw->conf.flags & IEEE80211_CONF_MONITOR);
+	bool monitor = mt792x_monitor_active(dev);
 
 	mt7925_mcu_set_sniffer(dev, vif, monitor);
 	pm->enable = pm->enable_user && !monitor;
@@ -816,7 +877,7 @@ void mt7925_set_runtime_pm(struct mt792x_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct mt76_connac_pm *pm = &dev->pm;
-	bool monitor = !!(hw->conf.flags & IEEE80211_CONF_MONITOR);
+	bool monitor = mt792x_monitor_active(dev);
 
 	pm->enable = pm->enable_user && !monitor;
 	ieee80211_iterate_active_interfaces(hw,
@@ -1593,6 +1654,9 @@ void mt7925_scan_work(struct work_struct *work)
 						.aborted = false,
 					};
 					ieee80211_scan_completed(phy->mt76->hw, &info);
+					mt792x_mutex_acquire(dev);
+					mt7925_monitor_rearm(dev);
+					mt792x_mutex_release(dev);
 				}
 				break;
 			case UNI_EVENT_SCAN_DONE_CHNLINFO:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
index 22a8f1ddc321..65bfcf8721fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
@@ -127,7 +127,7 @@ int mt7925_testmode_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int err;
 
 	if (!test_bit(MT76_STATE_RUNNING, &mphy->state) ||
-	    !(hw->conf.flags & IEEE80211_CONF_MONITOR))
+	    !mt792x_monitor_active(phy->dev))
 		return -ENOTCONN;
 
 	err = nla_parse_deprecated(tb, MT76_TM_ATTR_MAX, data, len,
@@ -164,7 +164,7 @@ int mt7925_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *msg,
 	int err;
 
 	if (!test_bit(MT76_STATE_RUNNING, &mphy->state) ||
-	    !(hw->conf.flags & IEEE80211_CONF_MONITOR) ||
+	    !mt792x_monitor_active(phy->dev) ||
 	    !mt76_testmode_enabled(mphy))
 		return -ENOTCONN;
 
-- 
2.56.0

