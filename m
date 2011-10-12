Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3025 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/22] brcm80211: fix annotations in TOE configuration
 functions
Date: Wed, 12 Oct 2011 20:51:18 +0200
Message-ID: <1318445492-24207-9-git-send-email-arend@broadcom.com> (sfid-20111012_205220_372017_17DF9A34)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The configuration function for the TCP offload engine were not
taking CPU endianess into account. Proper annotations and conversions
have been added.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index fb9f808..b05f177 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -560,6 +560,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 {
 	struct brcmf_dcmd dcmd;
+	__le32 toe_le;
 	char buf[32];
 	int ret;
 
@@ -585,7 +586,8 @@ static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 		return ret;
 	}
 
-	memcpy(toe_ol, buf, sizeof(u32));
+	memcpy(&toe_le, buf, sizeof(u32));
+	*toe_ol = le32_to_cpu(toe_le);
 	return 0;
 }
 
@@ -595,7 +597,8 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 {
 	struct brcmf_dcmd dcmd;
 	char buf[32];
-	int toe, ret;
+	int ret;
+	__le32 toe_le = cpu_to_le32(toe_ol);
 
 	memset(&dcmd, 0, sizeof(dcmd));
 
@@ -605,9 +608,8 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 	dcmd.set = true;
 
 	/* Set toe_ol as requested */
-
 	strcpy(buf, "toe_ol");
-	memcpy(&buf[sizeof("toe_ol")], &toe_ol, sizeof(u32));
+	memcpy(&buf[sizeof("toe_ol")], &toe_le, sizeof(u32));
 
 	ret = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, dcmd.len);
 	if (ret < 0) {
@@ -617,11 +619,10 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 	}
 
 	/* Enable toe globally only if any components are enabled. */
-
-	toe = (toe_ol != 0);
+	toe_le = cpu_to_le32(toe_ol != 0);
 
 	strcpy(buf, "toe");
-	memcpy(&buf[sizeof("toe")], &toe, sizeof(u32));
+	memcpy(&buf[sizeof("toe")], &toe_le, sizeof(u32));
 
 	ret = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, dcmd.len);
 	if (ret < 0) {
-- 
1.7.4.1


