Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25521 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaGLGtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:49:47 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/9] brcmfmac: rework debugfs functions in the driver
Date: Sat, 12 Jul 2014 08:49:36 +0200
Message-ID: <1405147782-12768-4-git-send-email-arend@broadcom.com> (sfid-20140712_085004_388683_BB4B69B3)
In-Reply-To: <1405147782-12768-1-git-send-email-arend@broadcom.com>
References: <1405147782-12768-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reworked the debugfs functions in the driver making it easier for
other driver parts to add a debugfs entry and keeping the information
they want to expose in debugfs private, ie. not in a header.

This is accomplished by providing the function brcmf_debugfs_add_entry()
in which the caller provides a read function in which they provide the
content. The debugfs function will take care of creating the debugfs
entry and cleaning up upon removal.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  | 180 ++++-----------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |  74 +--------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  89 ++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 100 +++++++++++-
 4 files changed, 208 insertions(+), 235 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index e1ac932..a73a1e7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -43,37 +43,13 @@ void brcmf_debugfs_exit(void)
 
 static int brcmf_debugfs_chipinfo_read(struct seq_file *seq, void *data)
 {
-	struct brcmf_pub *drvr = seq->private;
-	struct brcmf_bus *bus = drvr->bus_if;
+	struct brcmf_bus *bus = dev_get_drvdata(seq->private);
 
 	seq_printf(seq, "chip: %x(%u) rev %u\n",
 		   bus->chip, bus->chip, bus->chiprev);
 	return 0;
 }
 
-static int brcmf_debugfs_chipinfo_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, brcmf_debugfs_chipinfo_read, inode->i_private);
-}
-
-static const struct file_operations brcmf_debugfs_chipinfo_ops = {
-	.owner = THIS_MODULE,
-	.open = brcmf_debugfs_chipinfo_open,
-	.release = single_release,
-	.read = seq_read,
-	.llseek = seq_lseek
-};
-
-static int brcmf_debugfs_create_chipinfo(struct brcmf_pub *drvr)
-{
-	struct dentry *dentry =  drvr->dbgfs_dir;
-
-	if (!IS_ERR_OR_NULL(dentry))
-		debugfs_create_file("chipinfo", S_IRUGO, dentry, drvr,
-				    &brcmf_debugfs_chipinfo_ops);
-	return 0;
-}
-
 int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 {
 	struct device *dev = drvr->bus_if->dev;
@@ -82,7 +58,8 @@ int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 		return -ENODEV;
 
 	drvr->dbgfs_dir = debugfs_create_dir(dev_name(dev), root_folder);
-	brcmf_debugfs_create_chipinfo(drvr);
+	brcmf_debugfs_add_entry(drvr, "chipinfo", brcmf_debugfs_chipinfo_read);
+
 	return PTR_ERR_OR_ZERO(drvr->dbgfs_dir);
 }
 
@@ -97,146 +74,45 @@ struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr)
 	return drvr->dbgfs_dir;
 }
 
-static int brcmf_debugfs_sdio_count_read(struct seq_file *seq, void *data)
-{
-	struct brcmf_sdio_count *sdcnt = seq->private;
-
-	seq_printf(seq,
-		   "intrcount:    %u\nlastintrs:    %u\n"
-		   "pollcnt:      %u\nregfails:     %u\n"
-		   "tx_sderrs:    %u\nfcqueued:     %u\n"
-		   "rxrtx:        %u\nrx_toolong:   %u\n"
-		   "rxc_errors:   %u\nrx_hdrfail:   %u\n"
-		   "rx_badhdr:    %u\nrx_badseq:    %u\n"
-		   "fc_rcvd:      %u\nfc_xoff:      %u\n"
-		   "fc_xon:       %u\nrxglomfail:   %u\n"
-		   "rxglomframes: %u\nrxglompkts:   %u\n"
-		   "f2rxhdrs:     %u\nf2rxdata:     %u\n"
-		   "f2txdata:     %u\nf1regdata:    %u\n"
-		   "tickcnt:      %u\ntx_ctlerrs:   %lu\n"
-		   "tx_ctlpkts:   %lu\nrx_ctlerrs:   %lu\n"
-		   "rx_ctlpkts:   %lu\nrx_readahead: %lu\n",
-		   sdcnt->intrcount, sdcnt->lastintrs,
-		   sdcnt->pollcnt, sdcnt->regfails,
-		   sdcnt->tx_sderrs, sdcnt->fcqueued,
-		   sdcnt->rxrtx, sdcnt->rx_toolong,
-		   sdcnt->rxc_errors, sdcnt->rx_hdrfail,
-		   sdcnt->rx_badhdr, sdcnt->rx_badseq,
-		   sdcnt->fc_rcvd, sdcnt->fc_xoff,
-		   sdcnt->fc_xon, sdcnt->rxglomfail,
-		   sdcnt->rxglomframes, sdcnt->rxglompkts,
-		   sdcnt->f2rxhdrs, sdcnt->f2rxdata,
-		   sdcnt->f2txdata, sdcnt->f1regdata,
-		   sdcnt->tickcnt, sdcnt->tx_ctlerrs,
-		   sdcnt->tx_ctlpkts, sdcnt->rx_ctlerrs,
-		   sdcnt->rx_ctlpkts, sdcnt->rx_readahead_cnt);
-
-	return 0;
-}
+struct brcmf_debugfs_entry {
+	int (*read)(struct seq_file *seq, void *data);
+	struct brcmf_pub *drvr;
+};
 
-static int brcmf_debugfs_sdio_count_open(struct inode *inode, struct file *f)
+static int brcmf_debugfs_entry_open(struct inode *inode, struct file *f)
 {
-	return single_open(f, brcmf_debugfs_sdio_count_read, inode->i_private);
+	struct brcmf_debugfs_entry *entry = inode->i_private;
+
+	return single_open(f, entry->read, entry->drvr->bus_if->dev);
 }
 
-static const struct file_operations brcmf_debugfs_sdio_counter_ops = {
+static const struct file_operations brcmf_debugfs_def_ops = {
 	.owner = THIS_MODULE,
-	.open = brcmf_debugfs_sdio_count_open,
+	.open = brcmf_debugfs_entry_open,
 	.release = single_release,
 	.read = seq_read,
 	.llseek = seq_lseek
 };
 
-void brcmf_debugfs_create_sdio_count(struct brcmf_pub *drvr,
-				     struct brcmf_sdio_count *sdcnt)
+int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
+			    int (*read_fn)(struct seq_file *seq, void *data))
 {
-	struct dentry *dentry = drvr->dbgfs_dir;
+	struct dentry *dentry =  drvr->dbgfs_dir;
+	struct brcmf_debugfs_entry *entry;
 
-	if (!IS_ERR_OR_NULL(dentry))
-		debugfs_create_file("counters", S_IRUGO, dentry,
-				    sdcnt, &brcmf_debugfs_sdio_counter_ops);
-}
+	if (IS_ERR_OR_NULL(dentry))
+		return -ENOENT;
 
-static int brcmf_debugfs_fws_stats_read(struct seq_file *seq, void *data)
-{
-	struct brcmf_fws_stats *fwstats = seq->private;
-
-	seq_printf(seq,
-		   "header_pulls:      %u\n"
-		   "header_only_pkt:   %u\n"
-		   "tlv_parse_failed:  %u\n"
-		   "tlv_invalid_type:  %u\n"
-		   "mac_update_fails:  %u\n"
-		   "ps_update_fails:   %u\n"
-		   "if_update_fails:   %u\n"
-		   "pkt2bus:           %u\n"
-		   "generic_error:     %u\n"
-		   "rollback_success:  %u\n"
-		   "rollback_failed:   %u\n"
-		   "delayq_full:       %u\n"
-		   "supprq_full:       %u\n"
-		   "txs_indicate:      %u\n"
-		   "txs_discard:       %u\n"
-		   "txs_suppr_core:    %u\n"
-		   "txs_suppr_ps:      %u\n"
-		   "txs_tossed:        %u\n"
-		   "txs_host_tossed:   %u\n"
-		   "bus_flow_block:    %u\n"
-		   "fws_flow_block:    %u\n"
-		   "send_pkts:         BK:%u BE:%u VO:%u VI:%u BCMC:%u\n"
-		   "requested_sent:    BK:%u BE:%u VO:%u VI:%u BCMC:%u\n",
-		   fwstats->header_pulls,
-		   fwstats->header_only_pkt,
-		   fwstats->tlv_parse_failed,
-		   fwstats->tlv_invalid_type,
-		   fwstats->mac_update_failed,
-		   fwstats->mac_ps_update_failed,
-		   fwstats->if_update_failed,
-		   fwstats->pkt2bus,
-		   fwstats->generic_error,
-		   fwstats->rollback_success,
-		   fwstats->rollback_failed,
-		   fwstats->delayq_full_error,
-		   fwstats->supprq_full_error,
-		   fwstats->txs_indicate,
-		   fwstats->txs_discard,
-		   fwstats->txs_supp_core,
-		   fwstats->txs_supp_ps,
-		   fwstats->txs_tossed,
-		   fwstats->txs_host_tossed,
-		   fwstats->bus_flow_block,
-		   fwstats->fws_flow_block,
-		   fwstats->send_pkts[0], fwstats->send_pkts[1],
-		   fwstats->send_pkts[2], fwstats->send_pkts[3],
-		   fwstats->send_pkts[4],
-		   fwstats->requested_sent[0],
-		   fwstats->requested_sent[1],
-		   fwstats->requested_sent[2],
-		   fwstats->requested_sent[3],
-		   fwstats->requested_sent[4]);
+	entry = devm_kzalloc(drvr->bus_if->dev, sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
 
-	return 0;
-}
+	entry->read = read_fn;
+	entry->drvr = drvr;
 
-static int brcmf_debugfs_fws_stats_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, brcmf_debugfs_fws_stats_read, inode->i_private);
-}
+	dentry = debugfs_create_file(fn, S_IRUGO, dentry, entry,
+				     &brcmf_debugfs_def_ops);
 
-static const struct file_operations brcmf_debugfs_fws_stats_ops = {
-	.owner = THIS_MODULE,
-	.open = brcmf_debugfs_fws_stats_open,
-	.release = single_release,
-	.read = seq_read,
-	.llseek = seq_lseek
-};
-
-void brcmf_debugfs_create_fws_stats(struct brcmf_pub *drvr,
-				    struct brcmf_fws_stats *stats)
-{
-	struct dentry *dentry =  drvr->dbgfs_dir;
-
-	if (!IS_ERR_OR_NULL(dentry))
-		debugfs_create_file("fws_stats", S_IRUGO, dentry,
-				    stats, &brcmf_debugfs_fws_stats_ops);
+	return PTR_ERR_OR_ZERO(dentry);
 }
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index ef52ed7..6eade7c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -100,68 +100,6 @@ do {									\
 
 extern int brcmf_msg_level;
 
-/*
- * hold counter variables used in brcmfmac sdio driver.
- */
-struct brcmf_sdio_count {
-	uint intrcount;		/* Count of device interrupt callbacks */
-	uint lastintrs;		/* Count as of last watchdog timer */
-	uint pollcnt;		/* Count of active polls */
-	uint regfails;		/* Count of R_REG failures */
-	uint tx_sderrs;		/* Count of tx attempts with sd errors */
-	uint fcqueued;		/* Tx packets that got queued */
-	uint rxrtx;		/* Count of rtx requests (NAK to dongle) */
-	uint rx_toolong;	/* Receive frames too long to receive */
-	uint rxc_errors;	/* SDIO errors when reading control frames */
-	uint rx_hdrfail;	/* SDIO errors on header reads */
-	uint rx_badhdr;		/* Bad received headers (roosync?) */
-	uint rx_badseq;		/* Mismatched rx sequence number */
-	uint fc_rcvd;		/* Number of flow-control events received */
-	uint fc_xoff;		/* Number which turned on flow-control */
-	uint fc_xon;		/* Number which turned off flow-control */
-	uint rxglomfail;	/* Failed deglom attempts */
-	uint rxglomframes;	/* Number of glom frames (superframes) */
-	uint rxglompkts;	/* Number of packets from glom frames */
-	uint f2rxhdrs;		/* Number of header reads */
-	uint f2rxdata;		/* Number of frame data reads */
-	uint f2txdata;		/* Number of f2 frame writes */
-	uint f1regdata;		/* Number of f1 register accesses */
-	uint tickcnt;		/* Number of watchdog been schedule */
-	ulong tx_ctlerrs;	/* Err of sending ctrl frames */
-	ulong tx_ctlpkts;	/* Ctrl frames sent to dongle */
-	ulong rx_ctlerrs;	/* Err of processing rx ctrl frames */
-	ulong rx_ctlpkts;	/* Ctrl frames processed from dongle */
-	ulong rx_readahead_cnt;	/* packets where header read-ahead was used */
-};
-
-struct brcmf_fws_stats {
-	u32 tlv_parse_failed;
-	u32 tlv_invalid_type;
-	u32 header_only_pkt;
-	u32 header_pulls;
-	u32 pkt2bus;
-	u32 send_pkts[5];
-	u32 requested_sent[5];
-	u32 generic_error;
-	u32 mac_update_failed;
-	u32 mac_ps_update_failed;
-	u32 if_update_failed;
-	u32 packet_request_failed;
-	u32 credit_request_failed;
-	u32 rollback_success;
-	u32 rollback_failed;
-	u32 delayq_full_error;
-	u32 supprq_full_error;
-	u32 txs_indicate;
-	u32 txs_discard;
-	u32 txs_supp_core;
-	u32 txs_supp_ps;
-	u32 txs_tossed;
-	u32 txs_host_tossed;
-	u32 bus_flow_block;
-	u32 fws_flow_block;
-};
-
 struct brcmf_pub;
 #ifdef DEBUG
 void brcmf_debugfs_init(void);
@@ -169,10 +107,8 @@ void brcmf_debugfs_exit(void);
 int brcmf_debugfs_attach(struct brcmf_pub *drvr);
 void brcmf_debugfs_detach(struct brcmf_pub *drvr);
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
-void brcmf_debugfs_create_sdio_count(struct brcmf_pub *drvr,
-				     struct brcmf_sdio_count *sdcnt);
-void brcmf_debugfs_create_fws_stats(struct brcmf_pub *drvr,
-				    struct brcmf_fws_stats *stats);
+int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
+			    int (*read_fn)(struct seq_file *seq, void *data));
 #else
 static inline void brcmf_debugfs_init(void)
 {
@@ -187,9 +123,11 @@ static inline int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 static inline void brcmf_debugfs_detach(struct brcmf_pub *drvr)
 {
 }
-static inline void brcmf_debugfs_create_fws_stats(struct brcmf_pub *drvr,
-						  struct brcmf_fws_stats *stats)
+static inline
+int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
+			    int (*read_fn)(struct seq_file *seq, void *data))
 {
+	return 0;
 }
 #endif
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 0c98a79..c048632 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -391,6 +391,40 @@ struct brcmf_sdio_hdrinfo {
 	u16 tail_pad;
 };
 
+/*
+ * hold counter variables
+ */
+struct brcmf_sdio_count {
+	uint intrcount;		/* Count of device interrupt callbacks */
+	uint lastintrs;		/* Count as of last watchdog timer */
+	uint pollcnt;		/* Count of active polls */
+	uint regfails;		/* Count of R_REG failures */
+	uint tx_sderrs;		/* Count of tx attempts with sd errors */
+	uint fcqueued;		/* Tx packets that got queued */
+	uint rxrtx;		/* Count of rtx requests (NAK to dongle) */
+	uint rx_toolong;	/* Receive frames too long to receive */
+	uint rxc_errors;	/* SDIO errors when reading control frames */
+	uint rx_hdrfail;	/* SDIO errors on header reads */
+	uint rx_badhdr;		/* Bad received headers (roosync?) */
+	uint rx_badseq;		/* Mismatched rx sequence number */
+	uint fc_rcvd;		/* Number of flow-control events received */
+	uint fc_xoff;		/* Number which turned on flow-control */
+	uint fc_xon;		/* Number which turned off flow-control */
+	uint rxglomfail;	/* Failed deglom attempts */
+	uint rxglomframes;	/* Number of glom frames (superframes) */
+	uint rxglompkts;	/* Number of packets from glom frames */
+	uint f2rxhdrs;		/* Number of header reads */
+	uint f2rxdata;		/* Number of frame data reads */
+	uint f2txdata;		/* Number of f2 frame writes */
+	uint f1regdata;		/* Number of f1 register accesses */
+	uint tickcnt;		/* Number of watchdog been schedule */
+	ulong tx_ctlerrs;	/* Err of sending ctrl frames */
+	ulong tx_ctlpkts;	/* Ctrl frames sent to dongle */
+	ulong rx_ctlerrs;	/* Err of processing rx ctrl frames */
+	ulong rx_ctlpkts;	/* Ctrl frames processed from dongle */
+	ulong rx_readahead_cnt;	/* packets where header read-ahead was used */
+};
+
 /* misc chip info needed by some of the routines */
 /* Private data for SDIO bus interaction */
 struct brcmf_sdio {
@@ -3070,23 +3104,50 @@ done:
 
 static int brcmf_sdio_forensic_read(struct seq_file *seq, void *data)
 {
-	struct brcmf_sdio *bus = seq->private;
+	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
+	struct brcmf_sdio *bus = bus_if->bus_priv.sdio->bus;
 
 	return brcmf_sdio_died_dump(seq, bus);
 }
 
-static int brcmf_sdio_forensic_open(struct inode *inode, struct file *f)
+static int brcmf_debugfs_sdio_count_read(struct seq_file *seq, void *data)
 {
-	return single_open(f, brcmf_sdio_forensic_read, inode->i_private);
-}
+	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio_count *sdcnt = &sdiodev->bus->sdcnt;
 
-static const struct file_operations brcmf_sdio_forensic_ops = {
-	.owner = THIS_MODULE,
-	.open = brcmf_sdio_forensic_open,
-	.release = single_release,
-	.read = seq_read,
-	.llseek = seq_lseek
-};
+	seq_printf(seq,
+		   "intrcount:    %u\nlastintrs:    %u\n"
+		   "pollcnt:      %u\nregfails:     %u\n"
+		   "tx_sderrs:    %u\nfcqueued:     %u\n"
+		   "rxrtx:        %u\nrx_toolong:   %u\n"
+		   "rxc_errors:   %u\nrx_hdrfail:   %u\n"
+		   "rx_badhdr:    %u\nrx_badseq:    %u\n"
+		   "fc_rcvd:      %u\nfc_xoff:      %u\n"
+		   "fc_xon:       %u\nrxglomfail:   %u\n"
+		   "rxglomframes: %u\nrxglompkts:   %u\n"
+		   "f2rxhdrs:     %u\nf2rxdata:     %u\n"
+		   "f2txdata:     %u\nf1regdata:    %u\n"
+		   "tickcnt:      %u\ntx_ctlerrs:   %lu\n"
+		   "tx_ctlpkts:   %lu\nrx_ctlerrs:   %lu\n"
+		   "rx_ctlpkts:   %lu\nrx_readahead: %lu\n",
+		   sdcnt->intrcount, sdcnt->lastintrs,
+		   sdcnt->pollcnt, sdcnt->regfails,
+		   sdcnt->tx_sderrs, sdcnt->fcqueued,
+		   sdcnt->rxrtx, sdcnt->rx_toolong,
+		   sdcnt->rxc_errors, sdcnt->rx_hdrfail,
+		   sdcnt->rx_badhdr, sdcnt->rx_badseq,
+		   sdcnt->fc_rcvd, sdcnt->fc_xoff,
+		   sdcnt->fc_xon, sdcnt->rxglomfail,
+		   sdcnt->rxglomframes, sdcnt->rxglompkts,
+		   sdcnt->f2rxhdrs, sdcnt->f2rxdata,
+		   sdcnt->f2txdata, sdcnt->f1regdata,
+		   sdcnt->tickcnt, sdcnt->tx_ctlerrs,
+		   sdcnt->tx_ctlpkts, sdcnt->rx_ctlerrs,
+		   sdcnt->rx_ctlpkts, sdcnt->rx_readahead_cnt);
+
+	return 0;
+}
 
 static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
 {
@@ -3096,9 +3157,9 @@ static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
 	if (IS_ERR_OR_NULL(dentry))
 		return;
 
-	debugfs_create_file("forensics", S_IRUGO, dentry, bus,
-			    &brcmf_sdio_forensic_ops);
-	brcmf_debugfs_create_sdio_count(drvr, &bus->sdcnt);
+	brcmf_debugfs_add_entry(drvr, "forensics", brcmf_sdio_forensic_read);
+	brcmf_debugfs_add_entry(drvr, "counters",
+				brcmf_debugfs_sdio_count_read);
 	debugfs_create_u32("console_interval", 0644, dentry,
 			   &bus->console_interval);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 699908d..d42f7d0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -454,6 +454,34 @@ struct brcmf_fws_macdesc_table {
 	struct brcmf_fws_mac_descriptor other;
 };
 
+struct brcmf_fws_stats {
+	u32 tlv_parse_failed;
+	u32 tlv_invalid_type;
+	u32 header_only_pkt;
+	u32 header_pulls;
+	u32 pkt2bus;
+	u32 send_pkts[5];
+	u32 requested_sent[5];
+	u32 generic_error;
+	u32 mac_update_failed;
+	u32 mac_ps_update_failed;
+	u32 if_update_failed;
+	u32 packet_request_failed;
+	u32 credit_request_failed;
+	u32 rollback_success;
+	u32 rollback_failed;
+	u32 delayq_full_error;
+	u32 supprq_full_error;
+	u32 txs_indicate;
+	u32 txs_discard;
+	u32 txs_supp_core;
+	u32 txs_supp_ps;
+	u32 txs_tossed;
+	u32 txs_host_tossed;
+	u32 bus_flow_block;
+	u32 fws_flow_block;
+};
+
 struct brcmf_fws_info {
 	struct brcmf_pub *drvr;
 	spinlock_t spinlock;
@@ -2017,6 +2045,75 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 	brcmf_fws_unlock(fws);
 }
 
+#ifdef DEBUG
+static int brcmf_debugfs_fws_stats_read(struct seq_file *seq, void *data)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
+	struct brcmf_fws_stats *fwstats = &bus_if->drvr->fws->stats;
+
+	seq_printf(seq,
+		   "header_pulls:      %u\n"
+		   "header_only_pkt:   %u\n"
+		   "tlv_parse_failed:  %u\n"
+		   "tlv_invalid_type:  %u\n"
+		   "mac_update_fails:  %u\n"
+		   "ps_update_fails:   %u\n"
+		   "if_update_fails:   %u\n"
+		   "pkt2bus:           %u\n"
+		   "generic_error:     %u\n"
+		   "rollback_success:  %u\n"
+		   "rollback_failed:   %u\n"
+		   "delayq_full:       %u\n"
+		   "supprq_full:       %u\n"
+		   "txs_indicate:      %u\n"
+		   "txs_discard:       %u\n"
+		   "txs_suppr_core:    %u\n"
+		   "txs_suppr_ps:      %u\n"
+		   "txs_tossed:        %u\n"
+		   "txs_host_tossed:   %u\n"
+		   "bus_flow_block:    %u\n"
+		   "fws_flow_block:    %u\n"
+		   "send_pkts:         BK:%u BE:%u VO:%u VI:%u BCMC:%u\n"
+		   "requested_sent:    BK:%u BE:%u VO:%u VI:%u BCMC:%u\n",
+		   fwstats->header_pulls,
+		   fwstats->header_only_pkt,
+		   fwstats->tlv_parse_failed,
+		   fwstats->tlv_invalid_type,
+		   fwstats->mac_update_failed,
+		   fwstats->mac_ps_update_failed,
+		   fwstats->if_update_failed,
+		   fwstats->pkt2bus,
+		   fwstats->generic_error,
+		   fwstats->rollback_success,
+		   fwstats->rollback_failed,
+		   fwstats->delayq_full_error,
+		   fwstats->supprq_full_error,
+		   fwstats->txs_indicate,
+		   fwstats->txs_discard,
+		   fwstats->txs_supp_core,
+		   fwstats->txs_supp_ps,
+		   fwstats->txs_tossed,
+		   fwstats->txs_host_tossed,
+		   fwstats->bus_flow_block,
+		   fwstats->fws_flow_block,
+		   fwstats->send_pkts[0], fwstats->send_pkts[1],
+		   fwstats->send_pkts[2], fwstats->send_pkts[3],
+		   fwstats->send_pkts[4],
+		   fwstats->requested_sent[0],
+		   fwstats->requested_sent[1],
+		   fwstats->requested_sent[2],
+		   fwstats->requested_sent[3],
+		   fwstats->requested_sent[4]);
+
+	return 0;
+}
+#else
+static int brcmf_debugfs_fws_stats_read(struct seq_file *seq, void *data)
+{
+	return 0;
+}
+#endif
+
 int brcmf_fws_init(struct brcmf_pub *drvr)
 {
 	struct brcmf_fws_info *fws;
@@ -2107,7 +2204,8 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 			BRCMF_FWS_PSQ_LEN);
 
 	/* create debugfs file for statistics */
-	brcmf_debugfs_create_fws_stats(drvr, &fws->stats);
+	brcmf_debugfs_add_entry(drvr, "fws_stats",
+				brcmf_debugfs_fws_stats_read);
 
 	brcmf_dbg(INFO, "%s bdcv2 tlv signaling [%x]\n",
 		  fws->fw_signals ? "enabled" : "disabled", tlv);
-- 
1.9.1

