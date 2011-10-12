Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3023 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/22] brcm80211: remove sparse warning in fullmac debug
 function
Date: Wed, 12 Oct 2011 20:51:14 +0200
Message-ID: <1318445492-24207-5-git-send-email-arend@broadcom.com> (sfid-20111012_205222_494709_F83DAAC0)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debug function did a write operation which required a different
pointer type resulting in a sparse warning.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 3ec7477..f58c0eb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -720,7 +720,7 @@ extern int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 extern int brcmf_os_proto_block(struct brcmf_pub *drvr);
 extern int brcmf_os_proto_unblock(struct brcmf_pub *drvr);
 #ifdef BCMDBG
-extern int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size);
+extern int brcmf_write_to_file(struct brcmf_pub *drvr, const u8 *buf, int size);
 #endif				/* BCMDBG */
 
 extern int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 1adc3be..7f5003e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1319,7 +1319,7 @@ int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 }
 
 #ifdef BCMDBG
-int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size)
+int brcmf_write_to_file(struct brcmf_pub *drvr, const u8 *buf, int size)
 {
 	int ret = 0;
 	struct file *fp;
@@ -1339,7 +1339,7 @@ int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size)
 	}
 
 	/* Write buf to file */
-	fp->f_op->write(fp, buf, size, &pos);
+	fp->f_op->write(fp, (char __user *)buf, size, &pos);
 
 exit:
 	/* free buf before return */
-- 
1.7.4.1


