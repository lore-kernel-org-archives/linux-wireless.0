Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16C4531AE0
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072035; cv=none; b=Xdo/QyMRFwQ+Ju+Myf611+im8I9V4hYajF+ziViet7C7P3N9N4xF2bKYwARlQdGqxFe0BYx8NVQMSbQ3mrQEqbU7G9IQOOPiKx2f73wzdKz63818BnojHymdLyDr4+fRN2yvRzsl8edEM0Xhl0icKJ21mjn6MpL40q+fHjWYCjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072035; c=relaxed/simple;
	bh=B6qAa4Z4cDT2+9QZAw0REyhLgS6zE3iIUG1kfA5WjNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpsgkmljNcpJN1b7bvyjFLEibSb6MHInLx36uZ9IHUM3YpcpgQB9PLugTNY5oXZJVICX+C+iKUj1rMnqGLwfLpzF5uaJSNBw4bSFR1wLxQE+iBSt/0xeitLM3pgsSlF2Ilmo3YK+RPqH1ySL/LOSEv5I3VzHL0Yv40Bpm8hmjj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=EJHizOl0; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EJHizOl0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JviIOKxKjPk2vScqPWUvT3g2NtQpnAH8lnh7Gi4wMFw=; b=EJHizOl0RNSm30CC4A5GMl3o3W
	RBSH9eLkRqfJk3XMrnNtm0QYtBFUDgQgP9NNGN4ArPLIH+0LyX32jWcCn/uO6ZZTfmRewRgYEVdsO
	Mln411g1xrzSxrtmTYMLtr9hEqK1bPikgIO5EV5K+WQX0SO3bUdySSxiR+IG2L7o12Ag=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVW-00807z-0n;
	Tue, 22 Sep 2026 12:13:50 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 15/16] wifi: mac80211_hwsim: support SCS and MSCS
Date: Tue, 22 Sep 2026 12:13:42 +0200
Message-ID: <a8b26796ff8da59b8bda01322c4bd0fac4587b78.1790071773.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
References: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise both services, so that the stack can be tested without
hardware. mac80211 implements them in software, so the two extended
feature flags are all a simulated device needs for classification.

Also implement sta_set_scs, since mac80211 declines every descriptor
with a traffic description when no driver answers it. Nothing here
schedules a stream, so the answer comes from debugfs: the scs_status
file holds the status code for such descriptors, and zero accepts them.
This lets a test cover both outcomes.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/virtual/mac80211_hwsim_i.h    |  3 ++-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 23 +++++++++++++++-
 2 files changed, 26 insertions(+)

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
index d567ed8d45a4..828dde53747a 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -4294,6 +4294,24 @@ static int mac80211_hwsim_set_radar_background(struct ieee80211_hw *hw,
 	return 0;
 }
 
+/* The status code for a traffic description is set via debugfs for testing */
+static int mac80211_hwsim_sta_set_scs(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta *sta,
+				      struct cfg80211_scs_desc * const *desc,
+				      struct cfg80211_scs_result *res,
+				      u8 n_desc)
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
@@ -4318,6 +4336,7 @@ static int mac80211_hwsim_set_radar_background(struct ieee80211_hw *hw,
 	.link_sta_rc_update = mac80211_hwsim_sta_rc_update,	\
 	.conf_tx = mac80211_hwsim_conf_tx,			\
 	.get_survey = mac80211_hwsim_get_survey,		\
+	.sta_set_scs = mac80211_hwsim_sta_set_scs,		\
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)	\
 	.ampdu_action = mac80211_hwsim_ampdu_action,		\
 	.flush = mac80211_hwsim_flush,				\
@@ -5973,6 +5992,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			      NL80211_EXT_FEATURE_EXT_KEY_ID);
 	wiphy_ext_feature_set(hw->wiphy,
 			      NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_SCS);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_MSCS);
 
 	hw->wiphy->interface_modes = param->iftypes;
 
@@ -6162,6 +6183,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
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
