Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:58763 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755824Ab2F2DbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 23:31:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/6] mwifiex: advertise WPS probe response offload support to cfg80211
Date: Thu, 28 Jun 2012 20:30:29 -0700
Message-Id: <1340940630-27172-6-git-send-email-bzhao@marvell.com> (sfid-20120629_053122_913408_A20FA6BA)
In-Reply-To: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
References: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Being a fullmac driver, mwifiex takes care of populating
beacon, probe response, association response WPS IEs to firmware.
And firmware is responsible for constructing these frames.
Advertise this to cfg80211.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1c5edc2..647ade3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1771,7 +1771,11 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 
 	memcpy(wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
-	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;
+	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
+			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+
+	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
 
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
-- 
1.7.0.2

