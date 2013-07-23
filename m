Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:51034 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab3GWCSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 09/21] mwifiex: correct max IE length check for WPS IE
Date: Mon, 22 Jul 2013 19:17:46 -0700
Message-ID: <1374545878-15683-10-git-send-email-bzhao@marvell.com> (sfid-20130723_041902_395996_CB0950EB)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch is bug fix for an invalid boundry check for WPS IE.
We should check max IE length against defined macro; instead we were
checking it against size of pointer. Fix it.
Also move IE length check before allocation of memory.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 206c3e0..c071ce9 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -797,15 +797,16 @@ static int mwifiex_set_wps_ie(struct mwifiex_private *priv,
 			       u8 *ie_data_ptr, u16 ie_len)
 {
 	if (ie_len) {
-		priv->wps_ie = kzalloc(MWIFIEX_MAX_VSIE_LEN, GFP_KERNEL);
-		if (!priv->wps_ie)
-			return -ENOMEM;
-		if (ie_len > sizeof(priv->wps_ie)) {
+		if (ie_len > MWIFIEX_MAX_VSIE_LEN) {
 			dev_dbg(priv->adapter->dev,
 				"info: failed to copy WPS IE, too big\n");
-			kfree(priv->wps_ie);
 			return -1;
 		}
+
+		priv->wps_ie = kzalloc(MWIFIEX_MAX_VSIE_LEN, GFP_KERNEL);
+		if (!priv->wps_ie)
+			return -ENOMEM;
+
 		memcpy(priv->wps_ie, ie_data_ptr, ie_len);
 		priv->wps_ie_len = ie_len;
 		dev_dbg(priv->adapter->dev, "cmd: Set wps_ie_len=%d IE=%#x\n",
-- 
1.8.2.3

