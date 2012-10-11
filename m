Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36061 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2JKQXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 12:23:35 -0400
Received: from bob.linux.org.uk (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q9BGtjOW020624
	for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2012 17:55:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] brcm80211: remove some truely barftastic code
To: linux-wireless@vger.kernel.org
Date: Thu, 11 Oct 2012 17:25:14 +0100
Message-ID: <20121011162505.2643.87138.stgit@bob.linux.org.uk> (sfid-20121011_182338_459047_85F37C0B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

It's not used or called but please make it go away before someone copies or
uses it

Signed-off-by: Alan "minus lunch" Cox <alan@linux.intel.com>
---

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 --
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   36 --------------------
 2 files changed, 40 deletions(-)


diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 17e7ae7..0510960 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -702,10 +702,6 @@ extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 extern int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 				       uint cmd, void *buf, uint len);
 
-#ifdef DEBUG
-extern int brcmf_write_to_file(struct brcmf_pub *drvr, const u8 *buf, int size);
-#endif				/* DEBUG */
-
 extern int brcmf_ifname2idx(struct brcmf_pub *drvr, char *name);
 extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
 			      void *pktdata, struct brcmf_event_msg *,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index d7c76ce..c462263 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1163,42 +1163,6 @@ int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 	return pend;
 }
 
-#ifdef DEBUG
-int brcmf_write_to_file(struct brcmf_pub *drvr, const u8 *buf, int size)
-{
-	int ret = 0;
-	struct file *fp;
-	mm_segment_t old_fs;
-	loff_t pos = 0;
-
-	/* change to KERNEL_DS address limit */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
-	/* open file to write */
-	fp = filp_open("/tmp/mem_dump", O_WRONLY | O_CREAT, 0640);
-	if (!fp) {
-		brcmf_dbg(ERROR, "open file error\n");
-		ret = -1;
-		goto exit;
-	}
-
-	/* Write buf to file */
-	fp->f_op->write(fp, (char __user *)buf, size, &pos);
-
-exit:
-	/* free buf before return */
-	kfree(buf);
-	/* close file before return */
-	if (fp)
-		filp_close(fp, NULL);
-	/* restore previous address limit */
-	set_fs(old_fs);
-
-	return ret;
-}
-#endif				/* DEBUG */
-
 static void brcmf_driver_init(struct work_struct *work)
 {
 	brcmf_debugfs_init();

