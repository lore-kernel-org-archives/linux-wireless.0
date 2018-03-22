Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52586 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751745AbeCVU2g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 16:28:36 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 05/12] brcmfmac: use wiphy debugfs dir entry
Date: Thu, 22 Mar 2018 21:28:24 +0100
Message-Id: <1521750511-12345-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180322_212909_872287_405FE8B6)
In-Reply-To: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver used to create a brcmfmac dir entry at the top level
debugfs mount point. This moves the debugfs entries into the
wiphy debugfs dir entry.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  6 ++++
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  5 ---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 11 +++---
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   | 42 ++--------------------
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   | 17 ---------
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  3 ++
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  7 ++++
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 11 +++---
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  8 +++--
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |  3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |  7 ++++
 12 files changed, 47 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 2d3a5dd..1068a2a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -445,6 +445,11 @@ static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
 	return 0;
 }
 
+static void brcmf_proto_bcdc_debugfs_create(struct brcmf_pub *drvr)
+{
+	brcmf_fws_debugfs_create(drvr);
+}
+
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc;
@@ -472,6 +477,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	drvr->proto->del_if = brcmf_proto_bcdc_del_if;
 	drvr->proto->reset_if = brcmf_proto_bcdc_reset_if;
 	drvr->proto->init_done = brcmf_proto_bcdc_init_done;
+	drvr->proto->debugfs_create = brcmf_proto_bcdc_debugfs_create;
 	drvr->proto->pd = bcdc;
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 23affb5..6c54cae 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -524,9 +524,6 @@ static int __init brcmfmac_module_init(void)
 {
 	int err;
 
-	/* Initialize debug system first */
-	brcmf_debugfs_init();
-
 	/* Get the platform data (if available) for our devices */
 	err = platform_driver_probe(&brcmf_pd, brcmf_common_pd_probe);
 	if (err == -ENODEV)
@@ -538,7 +535,6 @@ static int __init brcmfmac_module_init(void)
 	/* Continue the initialization by registering the different busses */
 	err = brcmf_core_init();
 	if (err) {
-		brcmf_debugfs_exit();
 		if (brcmfmac_pdata)
 			platform_driver_unregister(&brcmf_pd);
 	}
@@ -551,7 +547,6 @@ static void __exit brcmfmac_module_exit(void)
 	brcmf_core_exit();
 	if (brcmfmac_pdata)
 		platform_driver_unregister(&brcmf_pd);
-	brcmf_debugfs_exit();
 }
 
 module_init(brcmfmac_module_init);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 8039732..eb54785 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -972,8 +972,6 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 	if (ret < 0)
 		goto fail;
 
-	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
-
 	brcmf_feat_attach(drvr);
 
 	ret = brcmf_proto_init_done(drvr);
@@ -1016,6 +1014,11 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 #endif
 #endif /* CONFIG_INET */
 
+	/* populate debugfs */
+	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
+	brcmf_feat_debugfs_create(drvr);
+	brcmf_proto_debugfs_create(drvr);
+
 	return 0;
 
 fail:
@@ -1068,9 +1071,6 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 	drvr->bus_if->drvr = drvr;
 	drvr->settings = settings;
 
-	/* attach debug facilities */
-	brcmf_debug_attach(drvr);
-
 	/* Attach and link in the protocol */
 	ret = brcmf_proto_attach(drvr);
 	if (ret != 0) {
@@ -1160,7 +1160,6 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_proto_detach(drvr);
 
-	brcmf_debug_detach(drvr);
 	bus_if->drvr = NULL;
 	wiphy_free(drvr->wiphy);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index 2d3e5e2..5048320 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -25,8 +25,6 @@
 #include "fweh.h"
 #include "debug.h"
 
-static struct dentry *root_folder;
-
 int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 			       size_t len)
 {
@@ -54,44 +52,9 @@ int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 	return 0;
 }
 
-void brcmf_debugfs_init(void)
-{
-	root_folder = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (IS_ERR(root_folder))
-		root_folder = NULL;
-}
-
-void brcmf_debugfs_exit(void)
-{
-	if (!root_folder)
-		return;
-
-	debugfs_remove_recursive(root_folder);
-	root_folder = NULL;
-}
-
-int brcmf_debug_attach(struct brcmf_pub *drvr)
-{
-	struct device *dev = drvr->bus_if->dev;
-
-	if (!root_folder)
-		return -ENODEV;
-
-	drvr->dbgfs_dir = debugfs_create_dir(dev_name(dev), root_folder);
-	return PTR_ERR_OR_ZERO(drvr->dbgfs_dir);
-}
-
-void brcmf_debug_detach(struct brcmf_pub *drvr)
-{
-	brcmf_fweh_unregister(drvr, BRCMF_E_PSM_WATCHDOG);
-
-	if (!IS_ERR_OR_NULL(drvr->dbgfs_dir))
-		debugfs_remove_recursive(drvr->dbgfs_dir);
-}
-
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr)
 {
-	return drvr->dbgfs_dir;
+	return drvr->wiphy->debugfsdir;
 }
 
 int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
@@ -99,7 +62,8 @@ int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 {
 	struct dentry *e;
 
+	WARN(!drvr->wiphy->debugfsdir, "wiphy not (yet) registered\n");
 	e = debugfs_create_devm_seqfile(drvr->bus_if->dev, fn,
-					drvr->dbgfs_dir, read_fn);
+					drvr->wiphy->debugfsdir, read_fn);
 	return PTR_ERR_OR_ZERO(e);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 35919d9..cfed062 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -113,29 +113,12 @@
 struct brcmf_bus;
 struct brcmf_pub;
 #ifdef DEBUG
-void brcmf_debugfs_init(void);
-void brcmf_debugfs_exit(void);
-int brcmf_debug_attach(struct brcmf_pub *drvr);
-void brcmf_debug_detach(struct brcmf_pub *drvr);
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
 int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 			    int (*read_fn)(struct seq_file *seq, void *data));
 int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 			       size_t len);
 #else
-static inline void brcmf_debugfs_init(void)
-{
-}
-static inline void brcmf_debugfs_exit(void)
-{
-}
-static inline int brcmf_debug_attach(struct brcmf_pub *drvr)
-{
-	return 0;
-}
-static inline void brcmf_debug_detach(struct brcmf_pub *drvr)
-{
-}
 static inline
 int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 			    int (*read_fn)(struct seq_file *seq, void *data))
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 47de35a..6835bdc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -218,7 +218,10 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		/* no quirks */
 		break;
 	}
+}
 
+void brcmf_feat_debugfs_create(struct brcmf_pub *drvr)
+{
 	brcmf_debugfs_add_entry(drvr, "features", brcmf_feat_debugfs_read);
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 1ab4f161..d119382 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -90,6 +90,13 @@ enum brcmf_feat_quirk {
 void brcmf_feat_attach(struct brcmf_pub *drvr);
 
 /**
+ * brcmf_feat_debugfs_create() - create debugfs entries.
+ *
+ * @drvr: driver instance.
+ */
+void brcmf_feat_debugfs_create(struct brcmf_pub *drvr);
+
+/**
  * brcmf_feat_is_enabled() - query feature.
  *
  * @ifp: interface instance.
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index f59642b..f3cbf78 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2399,10 +2399,6 @@ struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr)
 	brcmu_pktq_init(&fws->desc.other.psq, BRCMF_FWS_PSQ_PREC_COUNT,
 			BRCMF_FWS_PSQ_LEN);
 
-	/* create debugfs file for statistics */
-	brcmf_debugfs_add_entry(drvr, "fws_stats",
-				brcmf_debugfs_fws_stats_read);
-
 	brcmf_dbg(INFO, "%s bdcv2 tlv signaling [%x]\n",
 		  fws->fw_signals ? "enabled" : "disabled", tlv);
 	return fws;
@@ -2429,6 +2425,13 @@ void brcmf_fws_detach(struct brcmf_fws_info *fws)
 	kfree(fws);
 }
 
+void brcmf_fws_debugfs_create(struct brcmf_pub *drvr)
+{
+	/* create debugfs file for statistics */
+	brcmf_debugfs_add_entry(drvr, "fws_stats",
+				brcmf_debugfs_fws_stats_read);
+}
+
 bool brcmf_fws_queue_skbs(struct brcmf_fws_info *fws)
 {
 	return !fws->avoid_queueing;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
index ba07bd9..4e68357 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -20,6 +20,7 @@
 
 struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr);
 void brcmf_fws_detach(struct brcmf_fws_info *fws);
+void brcmf_fws_debugfs_create(struct brcmf_pub *drvr);
 bool brcmf_fws_queue_skbs(struct brcmf_fws_info *fws);
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws);
 void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 siglen, struct sk_buff *skb);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index e212a79..49d37ad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1418,6 +1418,11 @@ static int brcmf_msgbuf_stats_read(struct seq_file *seq, void *data)
 }
 #endif
 
+static void brcmf_msgbuf_debugfs_create(struct brcmf_pub *drvr)
+{
+	brcmf_debugfs_add_entry(drvr, "msgbuf_stats", brcmf_msgbuf_stats_read);
+}
+
 int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bus_msgbuf *if_msgbuf;
@@ -1472,6 +1477,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	drvr->proto->delete_peer = brcmf_msgbuf_delete_peer;
 	drvr->proto->add_tdls_peer = brcmf_msgbuf_add_tdls_peer;
 	drvr->proto->rxreorder = brcmf_msgbuf_rxreorder;
+	drvr->proto->debugfs_create = brcmf_msgbuf_debugfs_create;
 	drvr->proto->pd = msgbuf;
 
 	init_waitqueue_head(&msgbuf->ioctl_resp_wait);
@@ -1525,8 +1531,6 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	spin_lock_init(&msgbuf->flowring_work_lock);
 	INIT_LIST_HEAD(&msgbuf->work_queue);
 
-	brcmf_debugfs_add_entry(drvr, "msgbuf_stats", brcmf_msgbuf_stats_read);
-
 	return 0;
 
 fail:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
index d26ff21..c5ff551 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
@@ -54,7 +54,8 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 	if (!proto->tx_queue_data || (proto->hdrpull == NULL) ||
 	    (proto->query_dcmd == NULL) || (proto->set_dcmd == NULL) ||
 	    (proto->configure_addr_mode == NULL) ||
-	    (proto->delete_peer == NULL) || (proto->add_tdls_peer == NULL)) {
+	    (proto->delete_peer == NULL) || (proto->add_tdls_peer == NULL) ||
+	    (proto->debugfs_create == NULL)) {
 		brcmf_err("Not all proto handlers have been installed\n");
 		goto fail;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index 8a8e08f..d3c3b9a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -48,6 +48,7 @@ struct brcmf_proto {
 	void (*del_if)(struct brcmf_if *ifp);
 	void (*reset_if)(struct brcmf_if *ifp);
 	int (*init_done)(struct brcmf_pub *drvr);
+	void (*debugfs_create)(struct brcmf_pub *drvr);
 	void *pd;
 };
 
@@ -156,4 +157,10 @@ static inline bool brcmf_proto_is_reorder_skb(struct sk_buff *skb)
 	return drvr->proto->init_done(drvr);
 }
 
+static inline void
+brcmf_proto_debugfs_create(struct brcmf_pub *drvr)
+{
+	drvr->proto->debugfs_create(drvr);
+}
+
 #endif /* BRCMFMAC_PROTO_H */
-- 
1.9.1
