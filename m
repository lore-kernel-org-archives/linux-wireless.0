Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60663 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036AbaGLD5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 23:57:43 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/7] mwifiex: declare sta_ptr in smaller scope
Date: Fri, 11 Jul 2014 20:57:14 -0700
Message-ID: <1405137435-14045-3-git-send-email-bzhao@marvell.com> (sfid-20140712_055746_917238_5EEF822F)
In-Reply-To: <1405137435-14045-1-git-send-email-bzhao@marvell.com>
References: <1405137435-14045-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta_ptr is used only in an 'if' branch in this function.
Move it to the smaller scope where it is used.

Reported-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 9d6d8d9..62f5dbe 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -541,7 +541,6 @@ void mwifiex_create_ba_tbl(struct mwifiex_private *priv, u8 *ra, int tid,
 int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 {
 	struct host_cmd_ds_11n_addba_req add_ba_req;
-	struct mwifiex_sta_node *sta_ptr;
 	u32 tx_win_size = priv->add_ba_param.tx_win_size;
 	static u8 dialog_tok;
 	int ret;
@@ -553,6 +552,8 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
 	    priv->adapter->is_hw_11ac_capable &&
 	    memcmp(priv->cfg_bssid, peer_mac, ETH_ALEN)) {
+		struct mwifiex_sta_node *sta_ptr;
+
 		sta_ptr = mwifiex_get_sta_entry(priv, peer_mac);
 		if (!sta_ptr) {
 			dev_warn(priv->adapter->dev,
-- 
1.8.2.3

