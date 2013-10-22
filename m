Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8016 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab3JVWZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 18:25:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/6] mwifiex: fix invalid memory access in mwifiex_update_autoindex_ies()
Date: Tue, 22 Oct 2013 15:24:46 -0700
Message-ID: <1382480687-12720-6-git-send-email-bzhao@marvell.com> (sfid-20131023_002524_451905_CE2EE87A)
In-Reply-To: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
References: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

While parsing TLVs, return failure if number of remaining bytes
are less than current tlv length. This avoids invalid memory
access.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ie.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 220af4f..81ac001 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -82,7 +82,7 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 			     struct mwifiex_ie_list *ie_list)
 {
 	u16 travel_len, index, mask;
-	s16 input_len;
+	s16 input_len, tlv_len;
 	struct mwifiex_ie *ie;
 	u8 *tmp;
 
@@ -91,11 +91,13 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 
 	ie_list->len = 0;
 
-	while (input_len > 0) {
+	while (input_len >= sizeof(struct mwifiex_ie_types_header)) {
 		ie = (struct mwifiex_ie *)(((u8 *)ie_list) + travel_len);
-		input_len -= le16_to_cpu(ie->ie_length) + MWIFIEX_IE_HDR_SIZE;
-		travel_len += le16_to_cpu(ie->ie_length) + MWIFIEX_IE_HDR_SIZE;
+		tlv_len = le16_to_cpu(ie->ie_length);
+		travel_len += tlv_len + MWIFIEX_IE_HDR_SIZE;
 
+		if (input_len < tlv_len + MWIFIEX_IE_HDR_SIZE)
+			return -1;
 		index = le16_to_cpu(ie->ie_index);
 		mask = le16_to_cpu(ie->mgmt_subtype_mask);
 
@@ -132,6 +134,7 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 		le16_add_cpu(&ie_list->len,
 			     le16_to_cpu(priv->mgmt_ie[index].ie_length) +
 			     MWIFIEX_IE_HDR_SIZE);
+		input_len -= tlv_len + MWIFIEX_IE_HDR_SIZE;
 	}
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
-- 
1.8.2.3

