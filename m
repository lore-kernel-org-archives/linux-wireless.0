Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28111 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933042AbbFVIHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:07:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M80NBJ000563
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:40 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pduf2m-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:40 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 10/17] mwifiex: update domain_info upon band change in start_ap
Date: Mon, 22 Jun 2015 19:06:16 +0530
Message-ID: <1434980183-2901-11-git-send-email-patila@marvell.com> (sfid-20150622_103355_305002_3B294962)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was observed that AP beacons would not reflect correct regulatory
information upon starting AP in A band. This was because of missing
AP config band update in set_channel of start_ap. Also we configure 11D
settings info FW only for specific band. So we need to download domain
info to FW even if domain remains unchanged but band is changed.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 +-
 drivers/net/wireless/mwifiex/main.h     | 2 ++
 drivers/net/wireless/mwifiex/uap_cmd.c  | 7 ++++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ecc8278..1d445cb 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -442,7 +442,7 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
  *      - Country codes
  *      - Sub bands (first channel, number of channels, maximum Tx power)
  */
-static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
+int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 {
 	u8 no_of_triplet = 0;
 	struct ieee80211_country_ie_triplet *t;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 0e6ebc9..d74ef2d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1550,6 +1550,8 @@ void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
 void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
 void mwifiex_coex_ampdu_rxwinsize(struct mwifiex_adapter *adapter);
 void mwifiex_11n_delba(struct mwifiex_private *priv, int tid);
+int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index b749300..4d5a6e3 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -808,7 +808,7 @@ void mwifiex_uap_set_channel(struct mwifiex_private *priv,
 			     struct mwifiex_uap_bss_param *bss_cfg,
 			     struct cfg80211_chan_def chandef)
 {
-	u8 config_bands = 0;
+	u8 config_bands = 0, old_bands = priv->adapter->config_bands;
 
 	priv->bss_chandef = chandef;
 
@@ -834,6 +834,11 @@ void mwifiex_uap_set_channel(struct mwifiex_private *priv,
 	}
 
 	priv->adapter->config_bands = config_bands;
+
+	if (old_bands != config_bands) {
+		mwifiex_send_domain_info_cmd_fw(priv->adapter->wiphy);
+		mwifiex_dnld_txpwr_table(priv);
+	}
 }
 
 int mwifiex_config_start_uap(struct mwifiex_private *priv,
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
