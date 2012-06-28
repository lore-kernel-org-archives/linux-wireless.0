Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58815 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932236Ab2F1C7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 22:59:23 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: do not advertise custom regulatory domain capability
Date: Wed, 27 Jun 2012 19:57:58 -0700
Message-Id: <1340852279-24964-4-git-send-email-bzhao@marvell.com> (sfid-20120628_045929_678245_26AF2005)
In-Reply-To: <1340852279-24964-1-git-send-email-bzhao@marvell.com>
References: <1340852279-24964-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Since we don't support custom regulatory domains,
WIPHY_FLAG_CUSTOM_REGULATORY should not be enabled during wiphy
registration.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8f64b33..78fb959 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1743,7 +1743,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 
 	memcpy(wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
-	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME | WIPHY_FLAG_CUSTOM_REGULATORY;
+	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;
 
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
-- 
1.7.0.2

