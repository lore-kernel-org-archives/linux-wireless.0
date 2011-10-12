Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3032 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/22] brcm80211: use endian annotations for assoc ie
 length request
Date: Wed, 12 Oct 2011 20:51:21 +0200
Message-ID: <1318445492-24207-12-git-send-email-arend@broadcom.com> (sfid-20111012_205224_777917_1DD4C6D7)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver requests the device for number of ie's in assoc request
and response. This needed to be endian annotated.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    9 +++++----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    6 +++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 9e69cd7..8e20753 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2767,7 +2767,7 @@ static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct net_device *ndev = cfg_to_ndev(cfg_priv);
-	struct brcmf_cfg80211_assoc_ielen *assoc_info;
+	struct brcmf_cfg80211_assoc_ielen_le *assoc_info;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 	u32 req_len;
 	u32 resp_len;
@@ -2781,9 +2781,10 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 		WL_ERR("could not get assoc info (%d)\n", err);
 		return err;
 	}
-	assoc_info = (struct brcmf_cfg80211_assoc_ielen *)cfg_priv->extra_buf;
-	req_len = assoc_info->req_len;
-	resp_len = assoc_info->resp_len;
+	assoc_info =
+		(struct brcmf_cfg80211_assoc_ielen_le *)cfg_priv->extra_buf;
+	req_len = le32_to_cpu(assoc_info->req_len);
+	resp_len = le32_to_cpu(assoc_info->resp_len);
 	if (req_len) {
 		err = brcmf_dev_bufvar_get(ndev, "assoc_req_ies",
 					   cfg_priv->extra_buf,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index e69f4f6..62dc461 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -264,9 +264,9 @@ struct brcmf_cfg80211_connect_info {
 };
 
 /* assoc ie length */
-struct brcmf_cfg80211_assoc_ielen {
-	u32 req_len;
-	u32 resp_len;
+struct brcmf_cfg80211_assoc_ielen_le {
+	__le32 req_len;
+	__le32 resp_len;
 };
 
 /* wpa2 pmk list */
-- 
1.7.4.1


