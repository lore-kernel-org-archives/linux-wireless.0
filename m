Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3452 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/19] staging: brcm80211: simplified
 brcmf_proto_ioctl()
Date: Fri, 16 Sep 2011 12:27:56 -0700
Message-ID: <1316201288-29635-8-git-send-email-frankyl@broadcom.com> (sfid-20110916_212839_470558_418D97C9)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Removed a function parameter since it was redundant.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c   |   12 ++++++------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   17 ++++++++---------
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h |    2 +-
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index f8731c8..0d8389e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -271,7 +271,7 @@ done:
 
 int
 brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
-		  void *buf, int len)
+		  int len)
 {
 	struct brcmf_proto *prot = drvr->prot;
 	int ret = -1;
@@ -293,7 +293,7 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 			  (unsigned long)prot->lastcmd);
 		if ((ioc->cmd == BRCMF_C_SET_VAR) ||
 		    (ioc->cmd == BRCMF_C_GET_VAR))
-			brcmf_dbg(TRACE, "iovar cmd=%s\n", (char *)buf);
+			brcmf_dbg(TRACE, "iovar cmd=%s\n", (char *)ioc->buf);
 
 		goto done;
 	}
@@ -302,10 +302,10 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 	prot->lastcmd = ioc->cmd;
 	if (ioc->set)
 		ret = brcmf_proto_cdc_set_ioctl(drvr, ifidx, ioc->cmd,
-						buf, len);
+						ioc->buf, len);
 	else {
 		ret = brcmf_proto_cdc_query_ioctl(drvr, ifidx, ioc->cmd,
-						  buf, len);
+						  ioc->buf, len);
 		if (ret > 0)
 			ioc->used = ret - sizeof(struct brcmf_proto_cdc_ioctl);
 	}
@@ -321,12 +321,12 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 
 	/* Intercept the wme_dp ioctl here */
 	if (!ret && ioc->cmd == BRCMF_C_SET_VAR &&
-	    !strcmp(buf, "wme_dp")) {
+	    !strcmp(ioc->buf, "wme_dp")) {
 		int slen, val = 0;
 
 		slen = strlen("wme_dp") + 1;
 		if (len >= (int)(slen + sizeof(int)))
-			memcpy(&val, (char *)buf + slen, sizeof(int));
+			memcpy(&val, (char *)ioc->buf + slen, sizeof(int));
 		drvr->wme_dp = (u8) le32_to_cpu(val);
 	}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 16f7216..ca42883 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -200,7 +200,7 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	ioc.len = buflen;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set mcast_list failed, cnt %d\n",
 			  brcmf_ifname(&drvr_priv->pub, ifidx), cnt);
@@ -238,7 +238,7 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	ioc.len = buflen;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set allmulti %d failed\n",
 			  brcmf_ifname(&drvr_priv->pub, ifidx),
@@ -259,7 +259,7 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	ioc.len = sizeof(allmulti);
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set promisc %d failed\n",
 			  brcmf_ifname(&drvr_priv->pub, ifidx),
@@ -286,7 +286,7 @@ _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
 	ioc.len = 32;
 	ioc.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
 	if (ret < 0)
 		brcmf_dbg(ERROR, "%s: set cur_etheraddr failed\n",
 			  brcmf_ifname(&drvr_priv->pub, ifidx));
@@ -718,7 +718,7 @@ static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 	ioc.set = false;
 
 	strcpy(buf, "toe_ol");
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
 	if (ret < 0) {
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
@@ -756,7 +756,7 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe_ol");
 	memcpy(&buf[sizeof("toe_ol")], &toe_ol, sizeof(u32));
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: could not set toe_ol: ret=%d\n",
 			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
@@ -770,7 +770,7 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe");
 	memcpy(&buf[sizeof("toe")], &toe, sizeof(u32));
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
+	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: could not set toe: ret=%d\n",
 			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
@@ -963,8 +963,7 @@ int brcmf_netdev_ioctl_priv(struct net_device *net, struct brcmf_ioctl *ioc)
 	if (is_set_key_cmd)
 		brcmf_netdev_wait_pend8021x(net);
 
-	bcmerror = brcmf_proto_ioctl(&drvr_priv->pub, ifidx,
-				     ioc, ioc->buf, buflen);
+	bcmerror = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, ioc, buflen);
 
 done:
 	if (bcmerror > 0)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index 6686f4c..24b0f99 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -50,7 +50,7 @@ extern int brcmf_proto_hdrpull(struct brcmf_pub *, int *ifidx,
 
 /* Use protocol to issue ioctl to dongle */
 extern int brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx,
-			     struct brcmf_ioctl *ioc, void *buf, int len);
+			     struct brcmf_ioctl *ioc, int len);
 
 /* Update local copy of dongle statistics */
 extern void brcmf_proto_dstats(struct brcmf_pub *drvr);
-- 
1.7.1


