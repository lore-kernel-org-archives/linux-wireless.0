Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4102 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab2K1Uoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:38 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/11] brcmfmac: fix bug in setting mgmt ie and parsing
 vndrs ie.
Date: Wed, 28 Nov 2012 21:44:13 +0100
Message-ID: <1354135454-7035-11-git-send-email-arend@broadcom.com> (sfid-20121128_214524_558356_843F1AFE)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Parsing vndrs ie was not taking len of tlv itself in account. Setting
mgmt ie was missing check for length indicating non configured ie and
wrongly checking available length.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   28 +++++++++++---------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5dea1b4..96bc349 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3293,11 +3293,12 @@ brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 		if (vndr_ies->count >= MAX_VNDR_IE_NUMBER)
 			break;
 next:
-		remaining_len -= ie->len;
-		if (remaining_len <= 2)
+		remaining_len -= (ie->len + TLV_HDR_LEN);
+		if (remaining_len <= TLV_HDR_LEN)
 			ie = NULL;
 		else
-			ie = (struct brcmf_tlv *)(((u8 *)ie) + ie->len);
+			ie = (struct brcmf_tlv *)(((u8 *)ie) + ie->len +
+				TLV_HDR_LEN);
 	}
 	return err;
 }
@@ -3396,11 +3397,11 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		}
 	}
 
-	if (mgmt_ie_buf != NULL) {
+	if (mgmt_ie_buf && *mgmt_ie_len) {
 		if (parsed_ie_buf_len && (parsed_ie_buf_len == *mgmt_ie_len) &&
 		    (memcmp(mgmt_ie_buf, curr_ie_buf,
 			    parsed_ie_buf_len) == 0)) {
-			WL_TRACE("Previous mgmt IE is equals to current IE");
+			WL_TRACE("Previous mgmt IE equals to current IE\n");
 			goto exit;
 		}
 
@@ -3438,6 +3439,16 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		for (i = 0; i < new_vndr_ies.count; i++) {
 			vndrie_info = &new_vndr_ies.ie_info[i];
 
+			/* verify remained buf size before copy data */
+			if (remained_buf_len < (vndrie_info->vndrie.len +
+							VNDR_IE_VSIE_OFFSET)) {
+				WL_ERR("no space in mgmt_ie_buf: len left %d",
+				       remained_buf_len);
+				break;
+			}
+			remained_buf_len -= (vndrie_info->ie_len +
+					     VNDR_IE_VSIE_OFFSET);
+
 			WL_TRACE("ADDED ID : %d, Len: %d, OUI:%02x:%02x:%02x\n",
 				 vndrie_info->vndrie.id,
 				 vndrie_info->vndrie.len,
@@ -3449,13 +3460,6 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 							   vndrie_info->ie_ptr,
 							   vndrie_info->ie_len,
 							   "add");
-			/* verify remained buf size before copy data */
-			remained_buf_len -= vndrie_info->ie_len;
-			if (remained_buf_len < 0) {
-				WL_ERR("no space in mgmt_ie_buf: len left %d",
-					remained_buf_len);
-				break;
-			}
 
 			/* save the parsed IE in wl struct */
 			memcpy(ptr + (*mgmt_ie_len), vndrie_info->ie_ptr,
-- 
1.7.10.4


