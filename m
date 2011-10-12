Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4982 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/22] brcm80211: rename variable in
 _brcmf_set_multicast_list()
Date: Wed, 12 Oct 2011 20:51:17 +0200
Message-ID: <1318445492-24207-8-git-send-email-arend@broadcom.com> (sfid-20111012_205227_224807_05225D78)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable allmulti was used to provision IFF_ALLMULTI to the
device as well as IFF_PROMISC. For clarity the variable has been
renamed.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   30 ++++++++++----------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 7f5003e..fb9f808 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -137,9 +137,9 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 {
 	struct net_device *ndev;
 	struct netdev_hw_addr *ha;
-	u32 allmulti, cnt;
+	u32 dcmd_value, cnt;
 	__le32 cnt_le;
-	__le32 allmulti_le;
+	__le32 dcmd_le_value;
 
 	struct brcmf_dcmd dcmd;
 	char *buf, *bufp;
@@ -153,7 +153,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	cnt = netdev_mc_count(ndev);
 
 	/* Determine initial value of allmulti flag */
-	allmulti = (ndev->flags & IFF_ALLMULTI) ? true : false;
+	dcmd_value = (ndev->flags & IFF_ALLMULTI) ? true : false;
 
 	/* Send down the multicast list first. */
 
@@ -187,7 +187,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set mcast_list failed, cnt %d\n",
 			  brcmf_ifname(&drvr_priv->pub, 0), cnt);
-		allmulti = cnt ? true : allmulti;
+		dcmd_value = cnt ? true : dcmd_value;
 	}
 
 	kfree(buf);
@@ -197,19 +197,19 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	 * were trying to set some addresses and dongle rejected it...
 	 */
 
-	buflen = sizeof("allmulti") + sizeof(allmulti);
+	buflen = sizeof("allmulti") + sizeof(dcmd_value);
 	buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!buf)
 		return;
 
-	allmulti_le = cpu_to_le32(allmulti);
+	dcmd_le_value = cpu_to_le32(dcmd_value);
 
 	if (!brcmu_mkiovar
-	    ("allmulti", (void *)&allmulti_le,
-	    sizeof(allmulti_le), buf, buflen)) {
+	    ("allmulti", (void *)&dcmd_le_value,
+	    sizeof(dcmd_le_value), buf, buflen)) {
 		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
 			  brcmf_ifname(&drvr_priv->pub, 0),
-			  (int)sizeof(allmulti), buflen);
+			  (int)sizeof(dcmd_value), buflen);
 		kfree(buf);
 		return;
 	}
@@ -224,7 +224,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set allmulti %d failed\n",
 			  brcmf_ifname(&drvr_priv->pub, 0),
-			  le32_to_cpu(allmulti_le));
+			  le32_to_cpu(dcmd_le_value));
 	}
 
 	kfree(buf);
@@ -232,20 +232,20 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	/* Finally, pick up the PROMISC flag as well, like the NIC
 		 driver does */
 
-	allmulti = (ndev->flags & IFF_PROMISC) ? true : false;
-	allmulti_le = cpu_to_le32(allmulti);
+	dcmd_value = (ndev->flags & IFF_PROMISC) ? true : false;
+	dcmd_le_value = cpu_to_le32(dcmd_value);
 
 	memset(&dcmd, 0, sizeof(dcmd));
 	dcmd.cmd = BRCMF_C_SET_PROMISC;
-	dcmd.buf = &allmulti_le;
-	dcmd.len = sizeof(allmulti_le);
+	dcmd.buf = &dcmd_le_value;
+	dcmd.len = sizeof(dcmd_le_value);
 	dcmd.set = true;
 
 	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set promisc %d failed\n",
 			  brcmf_ifname(&drvr_priv->pub, 0),
-			  le32_to_cpu(allmulti_le));
+			  le32_to_cpu(dcmd_le_value));
 	}
 }
 
-- 
1.7.4.1


