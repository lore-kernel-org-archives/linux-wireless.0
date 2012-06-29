Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:60403 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754481Ab2F2DbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 23:31:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/6] mwifiex: overwrite earlier IE buffers for new set IE request
Date: Thu, 28 Jun 2012 20:30:27 -0700
Message-Id: <1340940630-27172-4-git-send-email-bzhao@marvell.com> (sfid-20120629_053119_242427_B366F658)
In-Reply-To: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
References: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

All IE buffers are freshly supplied. In such case, there is no need
to preserve earlier buffers with same management mask and index.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ie.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 018ae4a..1f2d4b9 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -51,8 +51,7 @@ mwifiex_ie_get_autoidx(struct mwifiex_private *priv, u16 subtype_mask,
 
 	for (i = 0; i < priv->adapter->max_mgmt_ie_index; i++) {
 		mask = le16_to_cpu(priv->mgmt_ie[i].mgmt_subtype_mask);
-		len = le16_to_cpu(priv->mgmt_ie[i].ie_length) +
-		      le16_to_cpu(ie->ie_length);
+		len = le16_to_cpu(ie->ie_length);
 
 		if (mask == MWIFIEX_AUTO_IDX_MASK)
 			continue;
@@ -108,10 +107,8 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 				return -1;
 
 			tmp = (u8 *)&priv->mgmt_ie[index].ie_buffer;
-			tmp += le16_to_cpu(priv->mgmt_ie[index].ie_length);
 			memcpy(tmp, &ie->ie_buffer, le16_to_cpu(ie->ie_length));
-			le16_add_cpu(&priv->mgmt_ie[index].ie_length,
-				     le16_to_cpu(ie->ie_length));
+			priv->mgmt_ie[index].ie_length = ie->ie_length;
 			priv->mgmt_ie[index].ie_index = cpu_to_le16(index);
 			priv->mgmt_ie[index].mgmt_subtype_mask =
 							cpu_to_le16(mask);
-- 
1.7.0.2

