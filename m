Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48926 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1GHA1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 20:27:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix regression in WEP security mode
Date: Thu,  7 Jul 2011 17:33:19 -0700
Message-Id: <1310085200-18865-1-git-send-email-bzhao@marvell.com> (sfid-20110708_022758_743684_3E87248E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Htcapinfo is unnecessarily sent in assoc request in WEP security due
to a regression introduced by commit 2be50b8df53 (mwifiex: remove
redundant encryption_mode mapping).
The issue is fixed in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 687c1f2..4487d93 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -960,7 +960,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		ret = mwifiex_set_gen_ie(priv, sme->ie, sme->ie_len);
 
 	if (sme->key) {
-		if (mwifiex_is_alg_wep(0) | mwifiex_is_alg_wep(0)) {
+		if (mwifiex_is_alg_wep(priv->sec_info.encryption_mode)) {
 			dev_dbg(priv->adapter->dev,
 				"info: setting wep encryption"
 				" with key len %d\n", sme->key_len);
-- 
1.7.0.2

