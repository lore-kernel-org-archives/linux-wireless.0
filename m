Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723049;
	b=UH+rX1fL8VM7mbOohyWQmYSrRlKTMj1zewuxfmFKUCt3QVTup4Jt4mns2mQfOCtIJJkw
	 mnmZGwKyQf+Ycu3Ur9uhJux/XzDo/kXvos8aLRttiEA/ctiRcW/3UCAgiT+5PP/yUUQJh
	 M6AqkwlsEWSld7RR0N1XXaiDFbQGFf98U3nfltv/vOvl7sVE9Zpi34lwND4sob8DXDn5w
	 2ZZYJPyPQ8B1y+yJhzjoYU40JlBHiJFNfsTbPrxrLxGac/x0jhp9zoCD3YJqCj/Ow8nKg
	 1JmFBdo/i9kuDRfJu+s82ftMHmGzITYFmAcVqDaHF/IumDmjjISFhtwJMx0ifr/DL8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723049;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sS22udo1eakvYmqnhaHaM9ulqzjh/cAd6Ww1ETE4S1U=;
	b=KNP6/GXlqYCFT8TjwkfpMywDXnt22QPF+yKXCYm7s3TbD7+n9X89/wIjadFwiuNkYqnN
	 riOTZ7lM+8di78T2lY5gQw74Qc8iL+21MCiNXIxM2sBpbWsv6gwMklCgIfCOzorcoKA++
	 pjUfwsnSn2pH5O7KvFk2c9RzMGrpsdIyeUwQIvn5oQOgRJNPUTd4B58Rll0EYj5maz/rb
	 KcO73qBJxPQePOn6YglTKohsOEi4PduzsT3HBHd/oE3SElLXEWuWOX6aFGDaVRU7fTfAj
	 VOyoe3NlKjFZYzMCOxhjTB1XueTQtg7GAgLNd6zSwzK1J+zG3f3YhXAbw8bwqq7f++g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=dNHDaU1b;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222B0606D834
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 222B0606D834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=dNHDaU1b
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sS22udo1eakvYmqnhaHaM9ulqzjh/cAd6Ww1ETE4S1U=; b=dNHDaU1bmBA0Y+zUbqdW53z68o
	f7ZnISzmORC4N6807NpnATj2cSAz4roZ71EiJHXoePCiQDB1LOIlNq3zHz2Ol3EF5WUmXaYgNK8vO
	0l1cosustvVJWiW4FwbyxnvFqrDrlqLMyRMjA9rUGznAJdyhbdpE9pvbL8fZKupDIFJg=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIn-00FDFp-2V;
	Tue, 03 Nov 2026 17:24:01 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 15/18] wifi: mac80211_hwsim: support SCS and MSCS
Date: Tue,  3 Nov 2026 17:23:48 +0100
Message-ID: <4a4130488e22f15e3d666025a6d75c0fbc95a366.1793722802.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
References: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
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

Advertise both services, so that the stack can be tested without
hardware. mac80211 implements them in software, so the two extended
feature flags are all a simulated device needs for classification.

Also implement sta_set_scs, since mac80211 declines every descriptor
with a traffic description when no driver answers it. Nothing here
schedules a stream, so the answer comes from debugfs, which lets a test
cover both outcomes.

Set the SCS Traffic Description Support subfield of the EHT MAC
Capabilities for AP interfaces on every band. Without it, a non-AP EHT
STA sends no QoS Characteristics element to a simulated AP.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/virtual/mac80211_hwsim_i.h    |  3 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 31 +++++++++++++--
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_i.h b/drivers/net/wireless/virtual/mac80211_hwsim_i.h
index 0f0f2ac6d80e..7f1c85ea6813 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_i.h
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_i.h
@@ -137,6 +137,9 @@ struct mac80211_hwsim_data {
 	/* RSSI in rx status of the receiver */
 	int rx_rssi;
 
+	/* Status code for a traffic description, 0 accepts */
+	u16 scs_status;
+
 	/* only used when pmsr capability is supplied */
 	struct cfg80211_pmsr_capabilities pmsr_capa;
 	struct cfg80211_pmsr_request *pmsr_request;
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index e53714b81ec2..f9304a32183b 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -4301,6 +4301,23 @@ static int mac80211_hwsim_set_radar_background(struct ieee80211_hw *hw,
 	return 0;
 }
 
+/* The status code for a traffic description is set via debugfs for testing */
+static int mac80211_hwsim_sta_set_scs(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta *sta,
+				      struct cfg80211_scs_desc * const *desc,
+				      u16 *status, u8 n_desc)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	u8 i;
+
+	for (i = 0; i < n_desc; i++)
+		if (desc[i]->qos_char)
+			status[i] = data->scs_status;
+
+	return 0;
+}
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 #define HWSIM_DEBUGFS_OPS					\
 	.link_add_debugfs = mac80211_hwsim_link_add_debugfs,
@@ -4325,6 +4342,7 @@ static int mac80211_hwsim_set_radar_background(struct ieee80211_hw *hw,
 	.link_sta_rc_update = mac80211_hwsim_sta_rc_update,	\
 	.conf_tx = mac80211_hwsim_conf_tx,			\
 	.get_survey = mac80211_hwsim_get_survey,		\
+	.sta_set_scs = mac80211_hwsim_sta_set_scs,		\
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)	\
 	.ampdu_action = mac80211_hwsim_ampdu_action,		\
 	.flush = mac80211_hwsim_flush,				\
@@ -4698,7 +4716,8 @@ static const struct ieee80211_sband_iftype_data sband_capa_2ghz[] = {
 				.mac_cap_info[0] =
 					IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 					IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
-					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1,
+					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
+					IEEE80211_EHT_MAC_CAP0_SCS_TRAFFIC_DESC,
 				.phy_cap_info[0] =
 					IEEE80211_EHT_PHY_CAP0_242_TONE_RU_GT20MHZ |
 					IEEE80211_EHT_PHY_CAP0_NDP_4_EHT_LFT_32_GI |
@@ -4994,7 +5013,8 @@ static const struct ieee80211_sband_iftype_data sband_capa_5ghz[] = {
 				.mac_cap_info[0] =
 					IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 					IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
-					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1,
+					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
+					IEEE80211_EHT_MAC_CAP0_SCS_TRAFFIC_DESC,
 				.phy_cap_info[0] =
 					IEEE80211_EHT_PHY_CAP0_242_TONE_RU_GT20MHZ |
 					IEEE80211_EHT_PHY_CAP0_NDP_4_EHT_LFT_32_GI |
@@ -5337,7 +5357,8 @@ static const struct ieee80211_sband_iftype_data sband_capa_6ghz[] = {
 				.mac_cap_info[0] =
 					IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 					IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
-					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1,
+					IEEE80211_EHT_MAC_CAP0_TRIG_TXOP_SHARING_MODE1 |
+					IEEE80211_EHT_MAC_CAP0_SCS_TRAFFIC_DESC,
 				.phy_cap_info[0] =
 					IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ |
 					IEEE80211_EHT_PHY_CAP0_242_TONE_RU_GT20MHZ |
@@ -6015,6 +6036,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	wiphy_ext_feature_set(hw->wiphy,
 			      NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION);
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_UPDATE_BEACON);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_SCS);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_MSCS);
 
 	hw->wiphy->interface_modes = param->iftypes;
 
@@ -6204,6 +6227,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			    &hwsim_fops_group);
 	debugfs_create_file("rx_rssi", 0666, data->debugfs, data,
 			    &hwsim_fops_rx_rssi);
+	debugfs_create_u16("scs_status", 0600, data->debugfs,
+			   &data->scs_status);
 	if (!data->use_chanctx)
 		debugfs_create_file("dfs_simulate_radar", 0222,
 				    data->debugfs,
-- 
git-series 0.9.1
