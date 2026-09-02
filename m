Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3278037DEA2
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338780; cv=none; b=o3lQ7pwgjj9hs7KdisOuX9+RV298jla1Iq9GDTIgd8UxGIH3fWUUxlzPzXtlDNgBoGfsBOMkNbjVkmIs7S94ya1TzJHrbO4pM93ayNm3S2I1uzRYjDGU21ofiReSCj36M915tFVMurD2mf7PQ7fvGRhzvuNgF9bbarLI1cnmzbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338780; c=relaxed/simple;
	bh=FKuJ8rQrsVDLRuyzid675pPnP/xEQ5LF/krx9Le/TU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZenwFR2ObGZre1v+0z89KexoCu6i6slFk9kO3Wanxv8+d44GOlZSazNYab2QFp8sfdWFMRXNYI1Jv9sCOoVfLRtiL4t9CYaH8OAYCsxdIHc0nwXuWWGI2WtXWzQz4W1QCpmO+MSpZGNPDPDsyrJHEM2dQlZvp/7DQnOmfX9sE6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=MUSwV5MU; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="MUSwV5MU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=54AqRnUZ+uAwzAuBhlDDq4oCEQ/OX8L5xLgBrBpE0tY=; b=MUSwV5MUCZN33eOY0KxQ75icBk
	DhTJb+CIMJdZNNV+C1kjNPtk6xvk56SaPimPAFR/YV9/PPWhXOMNQcnXh2C7bkL+m9C3RL0Z0da6b
	pf7jzF6c3c4Fop4pJTD3GA4No88LpVG4ycec/CFFWpush+xEczVlzECrT/nkaUwRL3QY=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbo-00Cwkn-0Q;
	Wed, 02 Sep 2026 10:46:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 14/15] wifi: mac80211_hwsim: support SCS and MSCS
Date: Wed,  2 Sep 2026 10:46:09 +0200
Message-ID: <62323c7dc0c76277255059059df34e2960cbe779.1788338716.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
References: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let the stack be exercised without hardware. mac80211 does both services
in software, so the two extended feature flags are all a simulated device
needs.

It answers the traffic descriptions as well, because mac80211 declines
every descriptor carrying one when no driver does. Nothing here schedules
a stream, so the answer comes from debugfs: scs_status holds the status
code to give such a descriptor, and zero accepts it.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/virtual/mac80211_hwsim_i.h    |  3 ++-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 25 +++++++++++++++-
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_i.h b/drivers/net/wireless/virtual/mac80211_hwsim_i.h
index 0f0f2ac6d80e..f9316a24a639 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_i.h
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_i.h
@@ -137,6 +137,9 @@ struct mac80211_hwsim_data {
 	/* RSSI in rx status of the receiver */
 	int rx_rssi;
 
+	/* IEEE status code to answer a traffic description with, 0 accepts */
+	u16 scs_status;
+
 	/* only used when pmsr capability is supplied */
 	struct cfg80211_pmsr_capabilities pmsr_capa;
 	struct cfg80211_pmsr_request *pmsr_request;
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 02b6d81cccd1..ee9a78853211 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -4289,6 +4289,27 @@ static int mac80211_hwsim_set_radar_background(struct ieee80211_hw *hw,
 	return 0;
 }
 
+/*
+ * Nothing here serves a traffic description, so there is nothing to run out of
+ * and no reason of its own to refuse one. The answer comes from debugfs, so a
+ * test can drive what mac80211 does with either one.
+ */
+static int mac80211_hwsim_sta_set_scs(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta *sta,
+				      struct cfg80211_scs_desc * const *desc,
+				      struct cfg80211_scs_result *res, u8 n_desc)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	u8 i;
+
+	for (i = 0; i < n_desc; i++)
+		if (desc[i]->qos_char)
+			res[i].status = data->scs_status;
+
+	return 0;
+}
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 #define HWSIM_DEBUGFS_OPS					\
 	.link_add_debugfs = mac80211_hwsim_link_add_debugfs,
@@ -4313,6 +4334,7 @@ static int mac80211_hwsim_set_radar_background(struct ieee80211_hw *hw,
 	.link_sta_rc_update = mac80211_hwsim_sta_rc_update,	\
 	.conf_tx = mac80211_hwsim_conf_tx,			\
 	.get_survey = mac80211_hwsim_get_survey,		\
+	.sta_set_scs = mac80211_hwsim_sta_set_scs,		\
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)	\
 	.ampdu_action = mac80211_hwsim_ampdu_action,		\
 	.flush = mac80211_hwsim_flush,				\
@@ -5967,6 +5989,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			      NL80211_EXT_FEATURE_EXT_KEY_ID);
 	wiphy_ext_feature_set(hw->wiphy,
 			      NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_SCS);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_MSCS);
 
 	hw->wiphy->interface_modes = param->iftypes;
 
@@ -6156,6 +6180,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			    &hwsim_fops_group);
 	debugfs_create_file("rx_rssi", 0666, data->debugfs, data,
 			    &hwsim_fops_rx_rssi);
+	debugfs_create_u16("scs_status", 0600, data->debugfs, &data->scs_status);
 	if (!data->use_chanctx)
 		debugfs_create_file("dfs_simulate_radar", 0222,
 				    data->debugfs,
-- 
git-series 0.9.1
