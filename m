Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=i8d6gtxRI+3VYJG1VGlA0g/7f6G5ehHDiqlzJr/iZAJXZQBWrJ1ZIeGpNSBoQGjhG6Hz
	 o/aH5oKCwdNvp0JqTc7IGb/KneB1W+9vpetJKrOHkHcNyr4W1/ZOfVTAkgXfhAVmyZzgz
	 wNB0pRhz7eN1+Xlng/l3sha8ZtlS1D18OREwultf6AaDOOzS5KQ/6wnlonCRQ2aFQpZnP
	 6hti1m5G2VKtT3MAZXKQ4/ClDgABDvW9NAu9u3zT3DYt/cYReiatpGcum75SVPzZOIny1
	 FhigPkZdyArEYXGfXjpfX0+lGU3qhmWj6KShuEeVkYdgAxj9f3P/O1aAa+zGchartyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=o97STPSSmzIvV2EiVjNpwP8Fl4zZUPEdm2DF4pfaczs=;
	b=rSeIRCSdTGCveHsbvZhSDCkowWYbkSFaaycjbKGo6sAtgK6OC0ARgfyZGhrjBN0J+FiU
	 kq/w1efA4sCt0q4qbUDaRQ8rhVuSaGWhH1nsYKIqDN6jieiW4PnYZuei0YzVakijFUkOr
	 LNCsCBdoJCF++RlL0gZq9vrzYMRjje4eRvvsyqryyWu9W7Ptc/u5C8ay48xRCi3QVFh2X
	 Fun25f4f1yjycPKOkGqpYY2F+FcHyHLJsbrDsUAXCXI6WB4Iy8p9myfdPquEetkUtK8ph
	 iVnJOn1pjl160aATlfFUuD3hWI6zVFnPsA+rmbc82tD9mkw1tsyG1AwbrcvGpCuBOUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=qF9A9CzR;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6AC606A331
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C6AC606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=qF9A9CzR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o97STPSSmzIvV2EiVjNpwP8Fl4zZUPEdm2DF4pfaczs=; b=qF9A9CzRmnsTrW/+ieYnSIzfkJ
	m9ReA6BgGkQTfHhArfclq6d9Q9b1mUnR4KKAKslb/rqPYdGrH6qslfaV+HoZ15dFYIbKQNX6Qc9xQ
	gK6pOSM9yjRjNmbZAYAGDHBt8VtslzDnC6TlqrAm3zsy/jfyKGz+xfivph91RIaktv80=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hK-00C8Bw-1M;
	Wed, 28 Oct 2026 13:24:06 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Subject: [PATCH mt76-next 02/25] wifi: mt76: mt7996: do not update beacons while CSA is active
Date: Wed, 28 Oct 2026 13:23:40 +0100
Message-ID: <20261028122403.796394-2-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
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

Each upload of the CSA beacon makes the firmware restart the countdown
from the template, but the driver uploads it more than once. At the
start of a CSA, mt7996_link_info_changed() and
mt7996_channel_switch_beacon() both upload it. mt7996_set_channel()
uploads it once more for the channel switch that
__ieee80211_csa_finalize() performs while csa_active is still set.

Upload the CSA beacon of a link only while the firmware does not hold
it: at the start of the CSA, after offchannel operation and after a
hardware restart. Do this, and the beacon reset for a CSA during CAC,
in mt7996_link_info_changed(), which knows the link of the CSA. Drop
mt7996_channel_switch_beacon(), which selects the link by the band of
the new channel; that band can belong to another radio.

In mt7996_set_channel(), restore only the beacons that were disabled
for offchannel operation. Other beacon updates during CSA are dropped
as well, since mac80211 rejects beacon changes from user space during
CSA and sets the post-CSA beacon right after the switch. A beacon
disable during CSA still goes to the firmware.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: f30906c55a40 ("wifi: mt76: mt7996: disable beacons when going offchannel")
Co-developed-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  1 +
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 68 ++++++++-----------
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 13 +++-
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  2 +
 4 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index edff4e5a5dff..2e1b67ac2d11 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2251,6 +2251,7 @@ void mt7996_mac_update_beacons(struct mt7996_phy *phy)
 	ieee80211_iterate_active_interfaces(phy->mt76->hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
 					    mt7996_update_vif_beacon, phy);
+	phy->offchan_bcn_stopped = phy->mt76->offchannel;
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 9f1927cad5c4..a2655784a13d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -349,6 +349,7 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		return -ENOSPC;
 
 	link->mld_idx = mld_idx;
+	link->csa_bcn_uploaded = false;
 	eth_zero_addr(link->bmc_bssid);
 	mlink->omac_idx = idx;
 	mlink->band_idx = band_idx;
@@ -703,7 +704,7 @@ int mt7996_set_channel(struct mt76_phy *mphy)
 
 	mt7996_mac_reset_counters(phy);
 	phy->noise = 0;
-	if (!mphy->offchannel)
+	if (!mphy->offchannel && phy->offchan_bcn_stopped)
 		mt7996_mac_update_beacons(phy);
 
 out:
@@ -995,6 +996,30 @@ mt7996_vif_cfg_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
+static void
+mt7996_link_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_bss_conf *link_conf,
+			  struct mt7996_vif_link *link, struct mt7996_phy *phy)
+{
+	if (!link_conf->enable_beacon || !link_conf->csa_active) {
+		mt7996_mcu_add_beacon(hw, vif, link_conf,
+				      link_conf->enable_beacon);
+		return;
+	}
+
+	/* each upload of the CSA beacon restarts the firmware countdown */
+	if (link->csa_bcn_uploaded)
+		return;
+
+	/* Reset beacon when channel switch triggered during CAC to let
+	 * FW correctly perform CSA countdown
+	 */
+	if (!cfg80211_reg_can_beacon(hw->wiphy, &phy->mt76->chandef, vif->type))
+		mt7996_mcu_add_beacon(hw, vif, link_conf, false);
+
+	mt7996_mcu_add_beacon(hw, vif, link_conf, true);
+}
+
 static void
 mt7996_link_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_bss_conf *info, u64 changed)
@@ -1067,7 +1092,7 @@ mt7996_link_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		link->mt76.beacon_rates_idx =
 			mt7996_get_rates_table(phy, info, true, false);
 
-		mt7996_mcu_add_beacon(hw, vif, info, info->enable_beacon);
+		mt7996_link_beacon_update(hw, vif, info, link, phy);
 	}
 
 	if (changed & (BSS_CHANGED_UNSOL_BCAST_PROBE_RESP |
@@ -1087,44 +1112,6 @@ mt7996_link_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
-static void
-mt7996_channel_switch_beacon(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     struct cfg80211_chan_def *chandef)
-{
-	struct mt7996_dev *dev = mt7996_hw_dev(hw);
-	struct mt7996_phy *phy = mt7996_band_phy(dev, chandef->chan->band);
-	struct ieee80211_bss_conf *link_conf;
-	unsigned int link_id;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	for_each_vif_active_link(vif, link_conf, link_id) {
-		struct mt7996_vif_link *link;
-		struct mt7996_phy *link_phy;
-
-		link = mt7996_vif_link(dev, vif, link_id);
-		if (!link)
-			continue;
-
-		link_phy = mt7996_vif_link_phy(link);
-		if (link_phy != phy)
-			continue;
-
-		/* Reset beacon when channel switch triggered during CAC to let
-		 * FW correctly perform CSA countdown
-		 */
-		if (!cfg80211_reg_can_beacon(hw->wiphy, &phy->mt76->chandef,
-					     vif->type))
-			mt7996_mcu_add_beacon(hw, vif, link_conf, false);
-
-		mt7996_mcu_add_beacon(hw, vif, link_conf, true);
-		break;
-	}
-
-	mutex_unlock(&dev->mt76.mutex);
-}
-
 static int
 mt7996_post_channel_switch(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct ieee80211_bss_conf *link_conf)
@@ -3093,7 +3080,6 @@ const struct ieee80211_ops mt7996_ops = {
 	.cancel_remain_on_channel = mt76_cancel_remain_on_channel,
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.get_txpower = mt7996_get_txpower,
-	.channel_switch_beacon = mt7996_channel_switch_beacon,
 	.post_channel_switch = mt7996_post_channel_switch,
 	.get_stats = mt7996_get_stats,
 	.get_et_sset_count = mt7996_get_et_sset_count,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index e3420ac523ab..7e72174bd6b1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3254,7 +3254,7 @@ int mt7996_mcu_add_beacon(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct sk_buff *skb, *rskb;
 	struct tlv *tlv;
 	struct bss_bcn_content_tlv *bcn;
-	int len, extra_len = 0;
+	int len, extra_len = 0, ret;
 
 	if (link_conf->nontransmitted)
 		return 0;
@@ -3262,6 +3262,10 @@ int mt7996_mcu_add_beacon(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (!mlink)
 		return -EINVAL;
 
+	/* a later CSA needs a new template, also after a failed upload */
+	if (!link_conf->csa_active)
+		link->csa_bcn_uploaded = false;
+
 	if (mphy && mphy->offchannel)
 		enabled = false;
 
@@ -3303,8 +3307,11 @@ int mt7996_mcu_add_beacon(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mt7996_mcu_beacon_cntdwn(rskb, skb, &offs, link_conf->csa_active);
 out:
 	dev_kfree_skb(skb);
-	return mt76_mcu_skb_send_msg(&dev->mt76, rskb,
-				     MCU_WMWA_UNI_CMD(BSS_INFO_UPDATE), true);
+	ret = mt76_mcu_skb_send_msg(&dev->mt76, rskb,
+				    MCU_WMWA_UNI_CMD(BSS_INFO_UPDATE), true);
+	link->csa_bcn_uploaded = !ret && enabled && link_conf->csa_active;
+
+	return ret;
 }
 
 int mt7996_mcu_beacon_inband_discov(struct mt7996_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index da9958647b54..84edb905fe06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -295,6 +295,7 @@ struct mt7996_vif_link {
 
 	u8 mld_idx;
 	u8 bmc_bssid[ETH_ALEN];
+	bool csa_bcn_uploaded;
 };
 
 struct mt7996_vif_link_info {
@@ -416,6 +417,7 @@ struct mt7996_phy {
 	bool has_aux_rx;
 	bool counter_reset;
 	bool rdd_tx_paused;
+	bool offchan_bcn_stopped;
 };
 
 struct mt7996_dev {
-- 
2.47.3

