Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2285 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/15] brmc80211: fmac: reworked next_bss()
Date: Tue, 18 Oct 2011 14:03:02 +0200
Message-ID: <1318939391-19495-7-git-send-email-arend@broadcom.com> (sfid-20111018_140346_293667_081937DA)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Moved function to where it is called and made it more readable.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   11 ++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    9 ---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 7f89bad..73be2c8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2057,6 +2057,15 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
 	return err;
 }
 
+static struct brcmf_bss_info_le *
+next_bss_le(struct brcmf_scan_results *list, struct brcmf_bss_info_le *bss)
+{
+	if (bss == NULL)
+		return list->bss_info_le;
+	return (struct brcmf_bss_info_le *)((unsigned long)bss +
+					    le32_to_cpu(bss->length));
+}
+
 static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_scan_results *bss_list;
@@ -2072,7 +2081,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 	}
 	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
 	for (i = 0; i < bss_list->count && i < WL_AP_MAX; i++) {
-		bi = next_bss(bss_list, bi);
+		bi = next_bss_le(bss_list, bi);
 		err = brcmf_inform_single_bss(cfg_priv, bi);
 		if (err)
 			break;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index bec30e3..a613b49 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -352,15 +352,6 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_priv *cfg)
 	return &cfg->conn_info;
 }
 
-static inline struct brcmf_bss_info_le *
-next_bss(struct brcmf_scan_results *list, struct brcmf_bss_info_le *bss)
-{
-	return bss = bss ?
-		(struct brcmf_bss_info_le *)((unsigned long)bss +
-				       le32_to_cpu(bss->length)) :
-		list->bss_info_le;
-}
-
 extern struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 							struct device *busdev,
 							void *data);
-- 
1.7.4.1


