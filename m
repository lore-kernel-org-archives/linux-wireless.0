Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56422 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964995AbbA1EnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:43:18 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4hIVQ031531
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:43:18 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1s49ry0gqy-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:43:18 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 4/8] mwifiex: store permanant mac address in adapter structure
Date: Wed, 28 Jan 2015 15:42:01 +0530
Message-ID: <1422439925-25666-5-git-send-email-patila@marvell.com> (sfid-20150128_054327_642985_6E93D0E9)
In-Reply-To: <1422439925-25666-1-git-send-email-patila@marvell.com>
References: <1422439925-25666-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This would be used to set mac address while changing virtual
interface to different types.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 +-
 drivers/net/wireless/mwifiex/cmdevt.c   | 4 +---
 drivers/net/wireless/mwifiex/init.c     | 1 +
 drivers/net/wireless/mwifiex/main.c     | 1 +
 drivers/net/wireless/mwifiex/main.h     | 1 +
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9710b23..85f5019 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2974,7 +2974,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->cipher_suites = mwifiex_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
 
-	memcpy(wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
+	ether_addr_copy(wiphy->perm_addr, adapter->perm_addr);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 946a2f7..00586b2 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1582,9 +1582,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		le16_to_cpu(hw_spec->hw_if_version),
 		le16_to_cpu(hw_spec->version));
 
-	if (priv->curr_addr[0] == 0xff)
-		memmove(priv->curr_addr, hw_spec->permanent_addr, ETH_ALEN);
-
+	ether_addr_copy(priv->adapter->perm_addr, hw_spec->permanent_addr);
 	adapter->region_code = le16_to_cpu(hw_spec->region_code);
 
 	for (i = 0; i < MWIFIEX_MAX_REGION_CODE; i++)
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 8004d14..44babc3 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -297,6 +297,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->ext_scan = false;
 	adapter->key_api_major_ver = 0;
 	adapter->key_api_minor_ver = 0;
+	memset(adapter->perm_addr, 0xff, ETH_ALEN);
 
 	setup_timer(&adapter->wakeup_timer, wakeup_timer_fn,
 		    (unsigned long)adapter);
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 49dec6b..cb9cab2 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -975,6 +975,7 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	priv->assocresp_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->rsn_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->num_tx_timeout = 0;
+	ether_addr_copy(priv->curr_addr, priv->adapter->perm_addr);
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a560179..45b40af 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -737,6 +737,7 @@ struct mwifiex_adapter {
 	int winner;
 	struct device *dev;
 	struct wiphy *wiphy;
+	u8 perm_addr[ETH_ALEN];
 	bool surprise_removed;
 	u32 fw_release_number;
 	u16 init_wait_q_woken;
-- 
1.8.1.4

