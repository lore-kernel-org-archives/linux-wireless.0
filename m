Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43314 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab1CUXlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 19:41:09 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: fix adhoc wep issue: privacy disabled in capa info
Date: Mon, 21 Mar 2011 16:44:37 -0700
Message-Id: <1300751079-20535-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

priv->sec_info.wep_status flag was checked for setting privacy bit
while preparing adhoc_start command. This check was not right
because the flag was always false at that point of time. It will be
enabled later when cfg80211 stack calls add_key callback function
to update keys in driver's database.

Change the code to check priv->sec_info.encryption_mode for privacy
bit setting.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index fb189ba..d06f4c2 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -872,8 +872,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	tmp_cap |= WLAN_CAPABILITY_IBSS;
 
 	/* Set up privacy in bss_desc */
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
-			|| priv->sec_info.wpa_enabled) {
+	if (priv->sec_info.encryption_mode != MWIFIEX_ENCRYPTION_MODE_NONE) {
 		/* Ad-Hoc capability privacy on */
 		dev_dbg(adapter->dev,
 			"info: ADHOC_S_CMD: wep_status set privacy to WEP\n");
-- 
1.7.0.2

