Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:23250 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab1GMPT7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 11:19:59 -0400
Subject: [PATCH] orinoco: minor fixes for problems found by checkpatch.pl
To: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 13 Jul 2011 11:19:57 -0400
Message-ID: <20110713151957.17868.83818.stgit@mj.roinet.com> (sfid-20110713_172006_370901_8203F55B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eliminate spaces before tabs.  Eliminate typedefs.  Add spaces around
operators.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/orinoco/airport.c        |    9 ++---
 drivers/net/wireless/orinoco/cfg.c            |    6 ++-
 drivers/net/wireless/orinoco/fw.c             |    7 ++--
 drivers/net/wireless/orinoco/fw.h             |    2 +
 drivers/net/wireless/orinoco/hermes.c         |   40 +++++++++++----------
 drivers/net/wireless/orinoco/hermes.h         |   37 ++++++++++---------
 drivers/net/wireless/orinoco/hermes_dld.c     |    8 ++--
 drivers/net/wireless/orinoco/hermes_dld.h     |   12 +++---
 drivers/net/wireless/orinoco/hw.c             |   48 +++++++++++++------------
 drivers/net/wireless/orinoco/hw.h             |    2 +
 drivers/net/wireless/orinoco/main.c           |   46 ++++++++++++------------
 drivers/net/wireless/orinoco/mic.c            |    8 ++--
 drivers/net/wireless/orinoco/orinoco.h        |   16 ++++----
 drivers/net/wireless/orinoco/orinoco_cs.c     |    6 ++-
 drivers/net/wireless/orinoco/orinoco_nortel.c |    3 +-
 drivers/net/wireless/orinoco/orinoco_pci.c    |    4 +-
 drivers/net/wireless/orinoco/orinoco_plx.c    |    6 ++-
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    2 +
 drivers/net/wireless/orinoco/orinoco_usb.c    |   23 ++++++------
 drivers/net/wireless/orinoco/spectrum_cs.c    |   10 +++--
 drivers/net/wireless/orinoco/wext.c           |   14 ++++---
 21 files changed, 155 insertions(+), 154 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index 4a0a0e5..0ca8b14 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -150,7 +150,7 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	struct orinoco_private *priv;
 	struct airport *card;
 	unsigned long phys_addr;
-	hermes_t *hw;
+	struct hermes *hw;
 
 	if (macio_resource_count(mdev) < 1 || macio_irq_count(mdev) < 1) {
 		printk(KERN_ERR PFX "Wrong interrupt/addresses in OF tree\n");
@@ -228,10 +228,9 @@ MODULE_AUTHOR("Benjamin Herrenschmidt <benh@kernel.crashing.org>");
 MODULE_DESCRIPTION("Driver for the Apple Airport wireless card.");
 MODULE_LICENSE("Dual MPL/GPL");
 
-static struct of_device_id airport_match[] =
-{
+static struct of_device_id airport_match[] = {
 	{
-	.name 		= "radio",
+	.name		= "radio",
 	},
 	{},
 };
@@ -240,7 +239,7 @@ MODULE_DEVICE_TABLE(of, airport_match);
 
 static struct macio_driver airport_driver = {
 	.driver = {
-		.name 		= DRIVER_NAME,
+		.name		= DRIVER_NAME,
 		.owner		= THIS_MODULE,
 		.of_match_table	= airport_match,
 	},
diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 736bbb9..f7b15b8 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -59,7 +59,7 @@ int orinoco_wiphy_register(struct wiphy *wiphy)
 	for (i = 0; i < NUM_CHANNELS; i++) {
 		if (priv->channel_mask & (1 << i)) {
 			priv->channels[i].center_freq =
-				ieee80211_dsss_chan_to_freq(i+1);
+				ieee80211_dsss_chan_to_freq(i + 1);
 			channels++;
 		}
 	}
@@ -182,7 +182,7 @@ static int orinoco_set_channel(struct wiphy *wiphy,
 	channel = ieee80211_freq_to_dsss_chan(chan->center_freq);
 
 	if ((channel < 1) || (channel > NUM_CHANNELS) ||
-	     !(priv->channel_mask & (1 << (channel-1))))
+	     !(priv->channel_mask & (1 << (channel - 1))))
 		return -EINVAL;
 
 	if (orinoco_lock(priv, &flags) != 0)
@@ -191,7 +191,7 @@ static int orinoco_set_channel(struct wiphy *wiphy,
 	priv->channel = channel;
 	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		/* Fast channel change - no commit if successful */
-		hermes_t *hw = &priv->hw;
+		struct hermes *hw = &priv->hw;
 		err = hw->ops->cmd_wait(hw, HERMES_CMD_TEST |
 					    HERMES_TEST_SET_CHANNEL,
 					channel, NULL);
diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 259d758..527cf53 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -100,7 +100,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	/* Plug Data Area (PDA) */
 	__le16 *pda;
 
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	const struct firmware *fw_entry;
 	const struct orinoco_fw_header *hdr;
 	const unsigned char *first_block;
@@ -205,7 +205,7 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
 		const unsigned char *image, const void *end,
 		int secondary)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int ret = 0;
 	const unsigned char *ptr;
 	const unsigned char *first_block;
@@ -322,9 +322,8 @@ symbol_dl_firmware(struct orinoco_private *priv,
 			      fw_entry->data + fw_entry->size, 1);
 	if (!orinoco_cached_fw_get(priv, false))
 		release_firmware(fw_entry);
-	if (ret) {
+	if (ret)
 		dev_err(dev, "Secondary firmware download failed\n");
-	}
 
 	return ret;
 }
diff --git a/drivers/net/wireless/orinoco/fw.h b/drivers/net/wireless/orinoco/fw.h
index 89fc26d..aca63e3 100644
--- a/drivers/net/wireless/orinoco/fw.h
+++ b/drivers/net/wireless/orinoco/fw.h
@@ -14,7 +14,7 @@ int orinoco_download(struct orinoco_private *priv);
 void orinoco_cache_fw(struct orinoco_private *priv, int ap);
 void orinoco_uncache_fw(struct orinoco_private *priv);
 #else
-#define orinoco_cache_fw(priv, ap) do { } while(0)
+#define orinoco_cache_fw(priv, ap) do { } while (0)
 #define orinoco_uncache_fw(priv) do { } while (0)
 #endif
 
diff --git a/drivers/net/wireless/orinoco/hermes.c b/drivers/net/wireless/orinoco/hermes.c
index 6c6a23e..75c15bc 100644
--- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -103,7 +103,7 @@ static const struct hermes_ops hermes_ops_local;
 
    Callable from any context.
 */
-static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0,
+static int hermes_issue_cmd(struct hermes *hw, u16 cmd, u16 param0,
 			    u16 param1, u16 param2)
 {
 	int k = CMD_BUSY_TIMEOUT;
@@ -132,7 +132,7 @@ static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0,
  */
 
 /* For doing cmds that wipe the magic constant in SWSUPPORT0 */
-static int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
+static int hermes_doicmd_wait(struct hermes *hw, u16 cmd,
 			      u16 parm0, u16 parm1, u16 parm2,
 			      struct hermes_response *resp)
 {
@@ -185,7 +185,8 @@ out:
 	return err;
 }
 
-void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
+void hermes_struct_init(struct hermes *hw, void __iomem *address,
+			int reg_spacing)
 {
 	hw->iobase = address;
 	hw->reg_spacing = reg_spacing;
@@ -195,7 +196,7 @@ void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
 }
 EXPORT_SYMBOL(hermes_struct_init);
 
-static int hermes_init(hermes_t *hw)
+static int hermes_init(struct hermes *hw)
 {
 	u16 reg;
 	int err = 0;
@@ -249,7 +250,7 @@ static int hermes_init(hermes_t *hw)
  *     > 0 on error returned by the firmware
  *
  * Callable from any context, but locking is your problem. */
-static int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
+static int hermes_docmd_wait(struct hermes *hw, u16 cmd, u16 parm0,
 			     struct hermes_response *resp)
 {
 	int err;
@@ -313,7 +314,7 @@ static int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
 	return err;
 }
 
-static int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
+static int hermes_allocate(struct hermes *hw, u16 size, u16 *fid)
 {
 	int err = 0;
 	int k;
@@ -363,7 +364,7 @@ static int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
  * from firmware
  *
  * Callable from any context */
-static int hermes_bap_seek(hermes_t *hw, int bap, u16 id, u16 offset)
+static int hermes_bap_seek(struct hermes *hw, int bap, u16 id, u16 offset)
 {
 	int sreg = bap ? HERMES_SELECT1 : HERMES_SELECT0;
 	int oreg = bap ? HERMES_OFFSET1 : HERMES_OFFSET0;
@@ -422,7 +423,7 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16 id, u16 offset)
  *       0 on success
  *     > 0 on error from firmware
  */
-static int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
+static int hermes_bap_pread(struct hermes *hw, int bap, void *buf, int len,
 			    u16 id, u16 offset)
 {
 	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
@@ -436,7 +437,7 @@ static int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
 		goto out;
 
 	/* Actually do the transfer */
-	hermes_read_words(hw, dreg, buf, len/2);
+	hermes_read_words(hw, dreg, buf, len / 2);
 
  out:
 	return err;
@@ -450,8 +451,8 @@ static int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
  *       0 on success
  *     > 0 on error from firmware
  */
-static int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
-			     u16 id, u16 offset)
+static int hermes_bap_pwrite(struct hermes *hw, int bap, const void *buf,
+			     int len, u16 id, u16 offset)
 {
 	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
 	int err = 0;
@@ -478,8 +479,8 @@ static int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
  * practice.
  *
  * Callable from user or bh context.  */
-static int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
-			   u16 *length, void *buf)
+static int hermes_read_ltv(struct hermes *hw, int bap, u16 rid,
+			   unsigned bufsize, u16 *length, void *buf)
 {
 	int err = 0;
 	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
@@ -523,7 +524,7 @@ static int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
 	return 0;
 }
 
-static int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
+static int hermes_write_ltv(struct hermes *hw, int bap, u16 rid,
 			    u16 length, const void *value)
 {
 	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
@@ -553,14 +554,14 @@ static int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 /*** Hermes AUX control ***/
 
 static inline void
-hermes_aux_setaddr(hermes_t *hw, u32 addr)
+hermes_aux_setaddr(struct hermes *hw, u32 addr)
 {
 	hermes_write_reg(hw, HERMES_AUXPAGE, (u16) (addr >> 7));
 	hermes_write_reg(hw, HERMES_AUXOFFSET, (u16) (addr & 0x7F));
 }
 
 static inline int
-hermes_aux_control(hermes_t *hw, int enabled)
+hermes_aux_control(struct hermes *hw, int enabled)
 {
 	int desired_state = enabled ? HERMES_AUX_ENABLED : HERMES_AUX_DISABLED;
 	int action = enabled ? HERMES_AUX_ENABLE : HERMES_AUX_DISABLE;
@@ -594,7 +595,7 @@ hermes_aux_control(hermes_t *hw, int enabled)
  * wl_lkm Agere fw does
  * Don't know about intersil
  */
-static int hermesi_program_init(hermes_t *hw, u32 offset)
+static int hermesi_program_init(struct hermes *hw, u32 offset)
 {
 	int err;
 
@@ -643,7 +644,7 @@ static int hermesi_program_init(hermes_t *hw, u32 offset)
  * wl_lkm Agere fw does
  * Don't know about intersil
  */
-static int hermesi_program_end(hermes_t *hw)
+static int hermesi_program_end(struct hermes *hw)
 {
 	struct hermes_response resp;
 	int rc = 0;
@@ -684,7 +685,8 @@ static int hermes_program_bytes(struct hermes *hw, const char *data,
 }
 
 /* Read PDA from the adapter */
-static int hermes_read_pda(hermes_t *hw, __le16 *pda, u32 pda_addr, u16 pda_len)
+static int hermes_read_pda(struct hermes *hw, __le16 *pda, u32 pda_addr,
+			   u16 pda_len)
 {
 	int ret;
 	u16 pda_size;
diff --git a/drivers/net/wireless/orinoco/hermes.h b/drivers/net/wireless/orinoco/hermes.h
index d9f18c1..28a4244 100644
--- a/drivers/net/wireless/orinoco/hermes.h
+++ b/drivers/net/wireless/orinoco/hermes.h
@@ -28,7 +28,7 @@
  *
  * As a module of low level hardware access routines, there is no
  * locking. Users of this module should ensure that they serialize
- * access to the hermes_t structure, and to the hardware
+ * access to the hermes structure, and to the hardware
 */
 
 #include <linux/if_ether.h>
@@ -43,7 +43,7 @@
 #define		HERMES_BAP_DATALEN_MAX		(4096)
 #define		HERMES_BAP_OFFSET_MAX		(4096)
 #define		HERMES_PORTID_MAX		(7)
-#define		HERMES_NUMPORTS_MAX		(HERMES_PORTID_MAX+1)
+#define		HERMES_NUMPORTS_MAX		(HERMES_PORTID_MAX + 1)
 #define		HERMES_PDR_LEN_MAX		(260)	/* in bytes, from EK */
 #define		HERMES_PDA_RECS_MAX		(200)	/* a guess */
 #define		HERMES_PDA_LEN_MAX		(1024)	/* in bytes, from EK */
@@ -148,7 +148,7 @@
 #define		HERMES_CMD_WRITEMIF		(0x0031)
 
 /*--- Debugging Commands -----------------------------*/
-#define 	HERMES_CMD_TEST			(0x0038)
+#define		HERMES_CMD_TEST			(0x0038)
 
 
 /* Test command arguments */
@@ -178,8 +178,8 @@
 
 #define HERMES_DESCRIPTOR_OFFSET	0
 #define HERMES_802_11_OFFSET		(14)
-#define HERMES_802_3_OFFSET		(14+32)
-#define HERMES_802_2_OFFSET		(14+32+14)
+#define HERMES_802_3_OFFSET		(14 + 32)
+#define HERMES_802_2_OFFSET		(14 + 32 + 14)
 #define HERMES_TXCNTL2_OFFSET		(HERMES_802_3_OFFSET - 2)
 
 #define HERMES_RXSTAT_ERR		(0x0003)
@@ -406,7 +406,7 @@ struct hermes_ops {
 };
 
 /* Basic control structure */
-typedef struct hermes {
+struct hermes {
 	void __iomem *iobase;
 	int reg_spacing;
 #define HERMES_16BIT_REGSPACING	0
@@ -415,7 +415,7 @@ typedef struct hermes {
 	bool eeprom_pda;
 	const struct hermes_ops *ops;
 	void *priv;
-} hermes_t;
+};
 
 /* Register access convenience macros */
 #define hermes_read_reg(hw, off) \
@@ -427,28 +427,29 @@ typedef struct hermes {
 	hermes_write_reg((hw), HERMES_##name, (val))
 
 /* Function prototypes */
-void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing);
+void hermes_struct_init(struct hermes *hw, void __iomem *address,
+			int reg_spacing);
 
 /* Inline functions */
 
-static inline int hermes_present(hermes_t *hw)
+static inline int hermes_present(struct hermes *hw)
 {
 	return hermes_read_regn(hw, SWSUPPORT0) == HERMES_MAGIC;
 }
 
-static inline void hermes_set_irqmask(hermes_t *hw, u16 events)
+static inline void hermes_set_irqmask(struct hermes *hw, u16 events)
 {
 	hw->inten = events;
 	hermes_write_regn(hw, INTEN, events);
 }
 
-static inline int hermes_enable_port(hermes_t *hw, int port)
+static inline int hermes_enable_port(struct hermes *hw, int port)
 {
 	return hw->ops->cmd_wait(hw, HERMES_CMD_ENABLE | (port << 8),
 				 0, NULL);
 }
 
-static inline int hermes_disable_port(hermes_t *hw, int port)
+static inline int hermes_disable_port(struct hermes *hw, int port)
 {
 	return hw->ops->cmd_wait(hw, HERMES_CMD_DISABLE | (port << 8),
 				 0, NULL);
@@ -456,13 +457,13 @@ static inline int hermes_disable_port(hermes_t *hw, int port)
 
 /* Initiate an INQUIRE command (tallies or scan).  The result will come as an
  * information frame in __orinoco_ev_info() */
-static inline int hermes_inquire(hermes_t *hw, u16 rid)
+static inline int hermes_inquire(struct hermes *hw, u16 rid)
 {
 	return hw->ops->cmd_wait(hw, HERMES_CMD_INQUIRE, rid, NULL);
 }
 
-#define HERMES_BYTES_TO_RECLEN(n) ((((n)+1)/2) + 1)
-#define HERMES_RECLEN_TO_BYTES(n) (((n)-1) * 2)
+#define HERMES_BYTES_TO_RECLEN(n) ((((n) + 1) / 2) + 1)
+#define HERMES_RECLEN_TO_BYTES(n) (((n) - 1) * 2)
 
 /* Note that for the next two, the count is in 16-bit words, not bytes */
 static inline void hermes_read_words(struct hermes *hw, int off,
@@ -498,7 +499,8 @@ static inline void hermes_clear_words(struct hermes *hw, int off,
 	(hw->ops->write_ltv((hw), (bap), (rid), \
 			    HERMES_BYTES_TO_RECLEN(sizeof(*buf)), (buf)))
 
-static inline int hermes_read_wordrec(hermes_t *hw, int bap, u16 rid, u16 *word)
+static inline int hermes_read_wordrec(struct hermes *hw, int bap, u16 rid,
+				      u16 *word)
 {
 	__le16 rec;
 	int err;
@@ -508,7 +510,8 @@ static inline int hermes_read_wordrec(hermes_t *hw, int bap, u16 rid, u16 *word)
 	return err;
 }
 
-static inline int hermes_write_wordrec(hermes_t *hw, int bap, u16 rid, u16 word)
+static inline int hermes_write_wordrec(struct hermes *hw, int bap, u16 rid,
+				       u16 word)
 {
 	__le16 rec = cpu_to_le16(word);
 	return HERMES_WRITE_RECORD(hw, bap, rid, &rec);
diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index 2b2b9a1..4a10b7a 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -193,7 +193,7 @@ hermes_find_pdi(const struct pdi *first_pdi, u32 record_id, const void *end)
 
 /* Process one Plug Data Item - find corresponding PDR and plug it */
 static int
-hermes_plug_pdi(hermes_t *hw, const struct pdr *first_pdr,
+hermes_plug_pdi(struct hermes *hw, const struct pdr *first_pdr,
 		const struct pdi *pdi, const void *pdr_end)
 {
 	const struct pdr *pdr;
@@ -220,7 +220,7 @@ hermes_plug_pdi(hermes_t *hw, const struct pdr *first_pdr,
  * Attempt to write every records that is in the specified pda
  * which also has a valid production data record for the firmware.
  */
-int hermes_apply_pda(hermes_t *hw,
+int hermes_apply_pda(struct hermes *hw,
 		     const char *first_pdr,
 		     const void *pdr_end,
 		     const __le16 *pda,
@@ -274,7 +274,7 @@ hermes_blocks_length(const char *first_block, const void *end)
 /*** Hermes programming ***/
 
 /* Program the data blocks */
-int hermes_program(hermes_t *hw, const char *first_block, const void *end)
+int hermes_program(struct hermes *hw, const char *first_block, const void *end)
 {
 	const struct dblock *blk;
 	u32 blkaddr;
@@ -387,7 +387,7 @@ DEFINE_DEFAULT_PDR(0x0161, 256,
  *
  * For certain records, use defaults if they are not found in pda.
  */
-int hermes_apply_pda_with_defaults(hermes_t *hw,
+int hermes_apply_pda_with_defaults(struct hermes *hw,
 				   const char *first_pdr,
 				   const void *pdr_end,
 				   const __le16 *pda,
diff --git a/drivers/net/wireless/orinoco/hermes_dld.h b/drivers/net/wireless/orinoco/hermes_dld.h
index 583a5bc..b5377e2 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.h
+++ b/drivers/net/wireless/orinoco/hermes_dld.h
@@ -27,21 +27,21 @@
 
 #include "hermes.h"
 
-int hermesi_program_init(hermes_t *hw, u32 offset);
-int hermesi_program_end(hermes_t *hw);
-int hermes_program(hermes_t *hw, const char *first_block, const void *end);
+int hermesi_program_init(struct hermes *hw, u32 offset);
+int hermesi_program_end(struct hermes *hw);
+int hermes_program(struct hermes *hw, const char *first_block, const void *end);
 
-int hermes_read_pda(hermes_t *hw,
+int hermes_read_pda(struct hermes *hw,
 		    __le16 *pda,
 		    u32 pda_addr,
 		    u16 pda_len,
 		    int use_eeprom);
-int hermes_apply_pda(hermes_t *hw,
+int hermes_apply_pda(struct hermes *hw,
 		     const char *first_pdr,
 		     const void *pdr_end,
 		     const __le16 *pda,
 		     const void *pda_end);
-int hermes_apply_pda_with_defaults(hermes_t *hw,
+int hermes_apply_pda_with_defaults(struct hermes *hw,
 				   const char *first_pdr,
 				   const void *pdr_end,
 				   const __le16 *pda,
diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 3c7877a..c09c843 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -47,7 +47,7 @@ struct comp_id {
 	u16 id, variant, major, minor;
 } __packed;
 
-static inline fwtype_t determine_firmware_type(struct comp_id *nic_id)
+static inline enum fwtype determine_firmware_type(struct comp_id *nic_id)
 {
 	if (nic_id->id < 0x8000)
 		return FIRMWARE_TYPE_AGERE;
@@ -71,11 +71,11 @@ int determine_fw_capabilities(struct orinoco_private *priv,
 			      u32 *hw_ver)
 {
 	struct device *dev = priv->dev;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err;
 	struct comp_id nic_id, sta_id;
 	unsigned int firmver;
-	char tmp[SYMBOL_MAX_VER_LEN+1] __attribute__((aligned(2)));
+	char tmp[SYMBOL_MAX_VER_LEN + 1] __attribute__((aligned(2)));
 
 	/* Get the hardware version */
 	err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_NICID, &nic_id);
@@ -280,7 +280,7 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 {
 	struct device *dev = priv->dev;
 	struct hermes_idstring nickbuf;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int len;
 	int err;
 	u16 reclen;
@@ -458,7 +458,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 {
 	struct net_device *dev = priv->ndev;
 	struct wireless_dev *wdev = netdev_priv(dev);
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err;
 	struct hermes_idstring idbuf;
 
@@ -529,7 +529,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 	memcpy(&idbuf.val, priv->desired_essid, sizeof(idbuf.val));
 	/* WinXP wants partner to configure OWNSSID even in IBSS mode. (jimc) */
 	err = hw->ops->write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNSSID,
-			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
+			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid) + 2),
 			&idbuf);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d setting OWNSSID\n",
@@ -537,7 +537,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 		return err;
 	}
 	err = hw->ops->write_ltv(hw, USER_BAP, HERMES_RID_CNFDESIREDSSID,
-			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
+			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid) + 2),
 			&idbuf);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d setting DESIREDSSID\n",
@@ -549,7 +549,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 	idbuf.len = cpu_to_le16(strlen(priv->nick));
 	memcpy(&idbuf.val, priv->nick, sizeof(idbuf.val));
 	err = hw->ops->write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
-				 HERMES_BYTES_TO_RECLEN(strlen(priv->nick)+2),
+				 HERMES_BYTES_TO_RECLEN(strlen(priv->nick) + 2),
 				 &idbuf);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d setting nickname\n",
@@ -689,7 +689,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 /* Get tsc from the firmware */
 int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key, u8 *tsc)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 	u8 tsc_arr[4][ORINOCO_SEQ_LEN];
 
@@ -706,7 +706,7 @@ int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key, u8 *tsc)
 
 int __orinoco_hw_set_bitrate(struct orinoco_private *priv)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int ratemode = priv->bitratemode;
 	int err = 0;
 
@@ -737,7 +737,7 @@ int __orinoco_hw_set_bitrate(struct orinoco_private *priv)
 
 int orinoco_hw_get_act_bitrate(struct orinoco_private *priv, int *bitrate)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int i;
 	int err = 0;
 	u16 val;
@@ -786,7 +786,7 @@ int __orinoco_hw_set_wap(struct orinoco_private *priv)
 {
 	int roaming_flag;
 	int err = 0;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 
 	switch (priv->firmware_type) {
 	case FIRMWARE_TYPE_AGERE:
@@ -818,7 +818,7 @@ int __orinoco_hw_set_wap(struct orinoco_private *priv)
  * which is needed for 802.1x implementations. */
 int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 	int i;
 
@@ -902,7 +902,7 @@ int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
 
 int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 	int master_wep_flag;
 	int auth_flag;
@@ -999,7 +999,7 @@ int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
 		u8 rx_mic[MIC_KEYLEN];
 		u8 tsc[ORINOCO_SEQ_LEN];
 	} __packed buf;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int ret;
 	int err;
 	int k;
@@ -1052,7 +1052,7 @@ int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
 
 int orinoco_clear_tkip_key(struct orinoco_private *priv, int key_idx)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err;
 
 	err = hermes_write_wordrec(hw, USER_BAP,
@@ -1068,7 +1068,7 @@ int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
 				    struct net_device *dev,
 				    int mc_count, int promisc)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 
 	if (promisc != priv->promiscuous) {
@@ -1111,9 +1111,9 @@ int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
 
 /* Return : < 0 -> error code ; >= 0 -> length */
 int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
-			 char buf[IW_ESSID_MAX_SIZE+1])
+			 char buf[IW_ESSID_MAX_SIZE + 1])
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 	struct hermes_idstring essidbuf;
 	char *p = (char *)(&essidbuf.val);
@@ -1166,7 +1166,7 @@ int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
 
 int orinoco_hw_get_freq(struct orinoco_private *priv)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 	u16 channel;
 	int freq = 0;
@@ -1206,7 +1206,7 @@ int orinoco_hw_get_freq(struct orinoco_private *priv)
 int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
 			       int *numrates, s32 *rates, int max)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	struct hermes_idstring list;
 	unsigned char *p = (unsigned char *)&list.val;
 	int err = 0;
@@ -1238,7 +1238,7 @@ int orinoco_hw_trigger_scan(struct orinoco_private *priv,
 			    const struct cfg80211_ssid *ssid)
 {
 	struct net_device *dev = priv->ndev;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	unsigned long flags;
 	int err = 0;
 
@@ -1323,7 +1323,7 @@ int orinoco_hw_trigger_scan(struct orinoco_private *priv,
 int orinoco_hw_disassociate(struct orinoco_private *priv,
 			    u8 *addr, u16 reason_code)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err;
 
 	struct {
@@ -1346,7 +1346,7 @@ int orinoco_hw_disassociate(struct orinoco_private *priv,
 int orinoco_hw_get_current_bssid(struct orinoco_private *priv,
 				 u8 *addr)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err;
 
 	err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 97af71e..8f6831f 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -45,7 +45,7 @@ int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
 				    struct net_device *dev,
 				    int mc_count, int promisc);
 int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
-			 char buf[IW_ESSID_MAX_SIZE+1]);
+			 char buf[IW_ESSID_MAX_SIZE + 1]);
 int orinoco_hw_get_freq(struct orinoco_private *priv);
 int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
 			       int *numrates, s32 *rates, int max);
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 62c6b2b..a822422 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -4,7 +4,7 @@
  * adaptors, with Lucent/Agere, Intersil or Symbol firmware.
  *
  * Current maintainers (as of 29 September 2003) are:
- * 	Pavel Roskin <proski AT gnu.org>
+ *	Pavel Roskin <proski AT gnu.org>
  * and	David Gibson <hermes AT gibson.dropbear.id.au>
  *
  * (C) Copyright David Gibson, IBM Corporation 2001-2003.
@@ -146,10 +146,10 @@ static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 #define ORINOCO_MAX_MTU		(IEEE80211_MAX_DATA_LEN - ENCAPS_OVERHEAD)
 
 #define MAX_IRQLOOPS_PER_IRQ	10
-#define MAX_IRQLOOPS_PER_JIFFY	(20000/HZ) /* Based on a guestimate of
-					    * how many events the
-					    * device could
-					    * legitimately generate */
+#define MAX_IRQLOOPS_PER_JIFFY	(20000 / HZ)	/* Based on a guestimate of
+						 * how many events the
+						 * device could
+						 * legitimately generate */
 
 #define DUMMY_FID		0xFFFF
 
@@ -157,7 +157,7 @@ static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
   HERMES_MAX_MULTICAST : 0)*/
 #define MAX_MULTICAST(priv)	(HERMES_MAX_MULTICAST)
 
-#define ORINOCO_INTEN	 	(HERMES_EV_RX | HERMES_EV_ALLOC \
+#define ORINOCO_INTEN		(HERMES_EV_RX | HERMES_EV_ALLOC \
 				 | HERMES_EV_TX | HERMES_EV_TXEXC \
 				 | HERMES_EV_WTERR | HERMES_EV_INFO \
 				 | HERMES_EV_INFDROP)
@@ -437,12 +437,12 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 	u16 txfid = priv->txfid;
 	int tx_control;
 	unsigned long flags;
-	u8 mic_buf[MICHAEL_MIC_LEN+1];
+	u8 mic_buf[MICHAEL_MIC_LEN + 1];
 
 	if (!netif_running(dev)) {
 		printk(KERN_ERR "%s: Tx on stopped device!\n",
@@ -579,7 +579,7 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_BUSY;
 }
 
-static void __orinoco_ev_alloc(struct net_device *dev, hermes_t *hw)
+static void __orinoco_ev_alloc(struct net_device *dev, struct hermes *hw)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	u16 fid = hermes_read_regn(hw, ALLOCFID);
@@ -594,7 +594,7 @@ static void __orinoco_ev_alloc(struct net_device *dev, hermes_t *hw)
 	hermes_write_regn(hw, ALLOCFID, DUMMY_FID);
 }
 
-static void __orinoco_ev_tx(struct net_device *dev, hermes_t *hw)
+static void __orinoco_ev_tx(struct net_device *dev, struct hermes *hw)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
@@ -606,7 +606,7 @@ static void __orinoco_ev_tx(struct net_device *dev, hermes_t *hw)
 	hermes_write_regn(hw, TXCOMPLFID, DUMMY_FID);
 }
 
-static void __orinoco_ev_txexc(struct net_device *dev, hermes_t *hw)
+static void __orinoco_ev_txexc(struct net_device *dev, struct hermes *hw)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
@@ -753,7 +753,7 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	struct sk_buff *skb;
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 
 	len = le16_to_cpu(desc->data_len);
 
@@ -840,7 +840,7 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	stats->rx_dropped++;
 }
 
-void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
+void __orinoco_ev_rx(struct net_device *dev, struct hermes *hw)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
@@ -918,7 +918,7 @@ void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 	   32bit boundary, plus 1 byte so we can read in odd length
 	   packets from the card, which has an IO granularity of 16
 	   bits */
-	skb = dev_alloc_skb(length+ETH_HLEN+2+1);
+	skb = dev_alloc_skb(length + ETH_HLEN + 2 + 1);
 	if (!skb) {
 		printk(KERN_WARNING "%s: Can't allocate skb for Rx\n",
 		       dev->name);
@@ -1402,7 +1402,7 @@ static void orinoco_process_scan_results(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->scan_lock, flags);
 }
 
-void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
+void __orinoco_ev_info(struct net_device *dev, struct hermes *hw)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
 	u16 infofid;
@@ -1620,7 +1620,7 @@ void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 }
 EXPORT_SYMBOL(__orinoco_ev_info);
 
-static void __orinoco_ev_infdrop(struct net_device *dev, hermes_t *hw)
+static void __orinoco_ev_infdrop(struct net_device *dev, struct hermes *hw)
 {
 	if (net_ratelimit())
 		printk(KERN_DEBUG "%s: Information frame lost.\n", dev->name);
@@ -1831,7 +1831,7 @@ static int __orinoco_commit(struct orinoco_private *priv)
 int orinoco_commit(struct orinoco_private *priv)
 {
 	struct net_device *dev = priv->ndev;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err;
 
 	if (priv->broken_disableport) {
@@ -1874,12 +1874,12 @@ int orinoco_commit(struct orinoco_private *priv)
 /* Interrupt handler                                                */
 /********************************************************************/
 
-static void __orinoco_ev_tick(struct net_device *dev, hermes_t *hw)
+static void __orinoco_ev_tick(struct net_device *dev, struct hermes *hw)
 {
 	printk(KERN_DEBUG "%s: TICK\n", dev->name);
 }
 
-static void __orinoco_ev_wterr(struct net_device *dev, hermes_t *hw)
+static void __orinoco_ev_wterr(struct net_device *dev, struct hermes *hw)
 {
 	/* This seems to happen a fair bit under load, but ignoring it
 	   seems to work fine...*/
@@ -1891,7 +1891,7 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 {
 	struct orinoco_private *priv = dev_id;
 	struct net_device *dev = priv->ndev;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int count = MAX_IRQLOOPS_PER_IRQ;
 	u16 evstat, events;
 	/* These are used to detect a runaway interrupt situation.
@@ -2017,8 +2017,8 @@ static void orinoco_unregister_pm_notifier(struct orinoco_private *priv)
 	unregister_pm_notifier(&priv->pm_notifier);
 }
 #else /* !PM_SLEEP || HERMES_CACHE_FW_ON_INIT */
-#define orinoco_register_pm_notifier(priv) do { } while(0)
-#define orinoco_unregister_pm_notifier(priv) do { } while(0)
+#define orinoco_register_pm_notifier(priv) do { } while (0)
+#define orinoco_unregister_pm_notifier(priv) do { } while (0)
 #endif
 
 /********************************************************************/
@@ -2029,7 +2029,7 @@ int orinoco_init(struct orinoco_private *priv)
 {
 	struct device *dev = priv->dev;
 	struct wiphy *wiphy = priv_to_wiphy(priv);
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 
 	/* No need to lock, the hw_unavailable flag is already set in
diff --git a/drivers/net/wireless/orinoco/mic.c b/drivers/net/wireless/orinoco/mic.c
index c03e7f5..fce4a84 100644
--- a/drivers/net/wireless/orinoco/mic.c
+++ b/drivers/net/wireless/orinoco/mic.c
@@ -59,10 +59,10 @@ int orinoco_mic(struct crypto_hash *tfm_michael, u8 *key,
 	/* Copy header into buffer. We need the padding on the end zeroed */
 	memcpy(&hdr[0], da, ETH_ALEN);
 	memcpy(&hdr[ETH_ALEN], sa, ETH_ALEN);
-	hdr[ETH_ALEN*2] = priority;
-	hdr[ETH_ALEN*2+1] = 0;
-	hdr[ETH_ALEN*2+2] = 0;
-	hdr[ETH_ALEN*2+3] = 0;
+	hdr[ETH_ALEN * 2] = priority;
+	hdr[ETH_ALEN * 2 + 1] = 0;
+	hdr[ETH_ALEN * 2 + 2] = 0;
+	hdr[ETH_ALEN * 2 + 3] = 0;
 
 	/* Use scatter gather to MIC header and data in one go */
 	sg_init_table(sg, 2);
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 255710e..3bb936b 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -49,11 +49,11 @@ enum orinoco_alg {
 	ORINOCO_ALG_TKIP
 };
 
-typedef enum {
+enum fwtype {
 	FIRMWARE_TYPE_AGERE,
 	FIRMWARE_TYPE_INTERSIL,
 	FIRMWARE_TYPE_SYMBOL
-} fwtype_t;
+};
 
 struct firmware;
 
@@ -88,11 +88,11 @@ struct orinoco_private {
 	struct iw_statistics wstats;
 
 	/* Hardware control variables */
-	hermes_t hw;
+	struct hermes hw;
 	u16 txfid;
 
 	/* Capabilities of the hardware/firmware */
-	fwtype_t firmware_type;
+	enum fwtype firmware_type;
 	int ibss_port;
 	int nicbuf_size;
 	u16 channel_mask;
@@ -122,8 +122,8 @@ struct orinoco_private {
 	struct key_params keys[ORINOCO_MAX_KEYS];
 
 	int bitratemode;
-	char nick[IW_ESSID_MAX_SIZE+1];
-	char desired_essid[IW_ESSID_MAX_SIZE+1];
+	char nick[IW_ESSID_MAX_SIZE + 1];
+	char desired_essid[IW_ESSID_MAX_SIZE + 1];
 	char desired_bssid[ETH_ALEN];
 	int bssid_fixed;
 	u16 frag_thresh, mwo_robust;
@@ -197,8 +197,8 @@ extern int orinoco_up(struct orinoco_private *priv);
 extern void orinoco_down(struct orinoco_private *priv);
 extern irqreturn_t orinoco_interrupt(int irq, void *dev_id);
 
-extern void __orinoco_ev_info(struct net_device *dev, hermes_t *hw);
-extern void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw);
+extern void __orinoco_ev_info(struct net_device *dev, struct hermes *hw);
+extern void __orinoco_ev_rx(struct net_device *dev, struct hermes *hw);
 
 int orinoco_process_xmit_skb(struct sk_buff *skb,
 			     struct net_device *dev,
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 88e3c0e..3f7fc4a 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -65,7 +65,7 @@ static void orinoco_cs_release(struct pcmcia_device *link);
 static void orinoco_cs_detach(struct pcmcia_device *p_dev);
 
 /********************************************************************/
-/* Device methods     						    */
+/* Device methods						    */
 /********************************************************************/
 
 static int
@@ -89,7 +89,7 @@ orinoco_cs_hard_reset(struct orinoco_private *priv)
 }
 
 /********************************************************************/
-/* PCMCIA stuff     						    */
+/* PCMCIA stuff							    */
 /********************************************************************/
 
 static int
@@ -134,7 +134,7 @@ static int
 orinoco_cs_config(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int ret;
 	void __iomem *mem;
 
diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
index bc3ea0b..326396b 100644
--- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -296,8 +296,7 @@ static struct pci_driver orinoco_nortel_driver = {
 static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
 	" (Tobias Hoffmann & Christoph Jungegger <disdos@traum404.de>)";
 MODULE_AUTHOR("Christoph Jungegger <disdos@traum404.de>");
-MODULE_DESCRIPTION
-    ("Driver for wireless LAN cards using the Nortel PCI bridge");
+MODULE_DESCRIPTION("Driver for wireless LAN cards using the Nortel PCI bridge");
 MODULE_LICENSE("Dual MPL/GPL");
 
 static int __init orinoco_nortel_init(void)
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
index 468197f..6058c66 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -6,7 +6,7 @@
  * hermes registers, as well as the COR register.
  *
  * Current maintainers are:
- * 	Pavel Roskin <proski AT gnu.org>
+ *	Pavel Roskin <proski AT gnu.org>
  * and	David Gibson <hermes AT gibson.dropbear.id.au>
  *
  * Some of this code is borrowed from orinoco_plx.c
@@ -81,7 +81,7 @@
  */
 static int orinoco_pci_cor_reset(struct orinoco_private *priv)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	unsigned long timeout;
 	u16 reg;
 
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
index 9358f4d..2bac824 100644
--- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -4,7 +4,7 @@
  * but are connected to the PCI bus by a PLX9052.
  *
  * Current maintainers are:
- * 	Pavel Roskin <proski AT gnu.org>
+ *	Pavel Roskin <proski AT gnu.org>
  * and	David Gibson <hermes AT gibson.dropbear.id.au>
  *
  * (C) Copyright David Gibson, IBM Corp. 2001-2003.
@@ -102,14 +102,14 @@
 #define PLX_RESET_TIME	(500)	/* milliseconds */
 
 #define PLX_INTCSR		0x4c /* Interrupt Control & Status Register */
-#define PLX_INTCSR_INTEN	(1<<6) /* Interrupt Enable bit */
+#define PLX_INTCSR_INTEN	(1 << 6) /* Interrupt Enable bit */
 
 /*
  * Do a soft reset of the card using the Configuration Option Register
  */
 static int orinoco_plx_cor_reset(struct orinoco_private *priv)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	struct orinoco_pci_card *card = priv->card;
 	unsigned long timeout;
 	u16 reg;
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
index 784605f..93159d6 100644
--- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -59,7 +59,7 @@
  */
 static int orinoco_tmd_cor_reset(struct orinoco_private *priv)
 {
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	struct orinoco_pci_card *card = priv->card;
 	unsigned long timeout;
 	u16 reg;
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index b9aedf1..811e87f 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -199,7 +199,7 @@ MODULE_FIRMWARE("orinoco_ezusb_fw");
 #define EZUSB_FRAME_DATA		1
 #define EZUSB_FRAME_CONTROL		2
 
-#define DEF_TIMEOUT			(3*HZ)
+#define DEF_TIMEOUT			(3 * HZ)
 
 #define BULK_BUF_SIZE			2048
 
@@ -959,7 +959,7 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 	return retval;
 }
 
-static int ezusb_write_ltv(hermes_t *hw, int bap, u16 rid,
+static int ezusb_write_ltv(struct hermes *hw, int bap, u16 rid,
 			   u16 length, const void *data)
 {
 	struct ezusb_priv *upriv = hw->priv;
@@ -989,7 +989,7 @@ static int ezusb_write_ltv(hermes_t *hw, int bap, u16 rid,
 				NULL, 0, NULL);
 }
 
-static int ezusb_read_ltv(hermes_t *hw, int bap, u16 rid,
+static int ezusb_read_ltv(struct hermes *hw, int bap, u16 rid,
 			  unsigned bufsize, u16 *length, void *buf)
 {
 	struct ezusb_priv *upriv = hw->priv;
@@ -1006,7 +1006,7 @@ static int ezusb_read_ltv(hermes_t *hw, int bap, u16 rid,
 				buf, bufsize, length);
 }
 
-static int ezusb_doicmd_wait(hermes_t *hw, u16 cmd, u16 parm0, u16 parm1,
+static int ezusb_doicmd_wait(struct hermes *hw, u16 cmd, u16 parm0, u16 parm1,
 			     u16 parm2, struct hermes_response *resp)
 {
 	struct ezusb_priv *upriv = hw->priv;
@@ -1028,7 +1028,7 @@ static int ezusb_doicmd_wait(hermes_t *hw, u16 cmd, u16 parm0, u16 parm1,
 				EZUSB_FRAME_CONTROL, NULL, 0, NULL);
 }
 
-static int ezusb_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
+static int ezusb_docmd_wait(struct hermes *hw, u16 cmd, u16 parm0,
 			    struct hermes_response *resp)
 {
 	struct ezusb_priv *upriv = hw->priv;
@@ -1196,7 +1196,7 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	struct ezusb_priv *upriv = priv->card;
-	u8 mic[MICHAEL_MIC_LEN+1];
+	u8 mic[MICHAEL_MIC_LEN + 1];
 	int err = 0;
 	int tx_control;
 	unsigned long flags;
@@ -1356,7 +1356,7 @@ static int ezusb_hard_reset(struct orinoco_private *priv)
 }
 
 
-static int ezusb_init(hermes_t *hw)
+static int ezusb_init(struct hermes *hw)
 {
 	struct ezusb_priv *upriv = hw->priv;
 	int retval;
@@ -1438,7 +1438,7 @@ static void ezusb_bulk_in_callback(struct urb *urb)
 	} else if (upriv->dev) {
 		struct net_device *dev = upriv->dev;
 		struct orinoco_private *priv = ndev_priv(dev);
-		hermes_t *hw = &priv->hw;
+		struct hermes *hw = &priv->hw;
 
 		if (hermes_rid == EZUSB_RID_RX) {
 			__orinoco_ev_rx(dev, hw);
@@ -1575,7 +1575,7 @@ static int ezusb_probe(struct usb_interface *interface,
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
 	struct orinoco_private *priv;
-	hermes_t *hw;
+	struct hermes *hw;
 	struct ezusb_priv *upriv = NULL;
 	struct usb_interface_descriptor *iface_desc;
 	struct usb_endpoint_descriptor *ep;
@@ -1757,7 +1757,7 @@ static struct usb_driver orinoco_driver = {
 /* Can't be declared "const" or the whole __initdata section will
  * become const */
 static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
-    " (Manuel Estrada Sainz)";
+	" (Manuel Estrada Sainz)";
 
 static int __init ezusb_module_init(void)
 {
@@ -1787,6 +1787,5 @@ module_init(ezusb_module_init);
 module_exit(ezusb_module_exit);
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
-MODULE_DESCRIPTION
-    ("Driver for Orinoco wireless LAN cards using EZUSB bridge");
+MODULE_DESCRIPTION("Driver for Orinoco wireless LAN cards using EZUSB bridge");
 MODULE_LICENSE("Dual MPL/GPL");
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 81f3673..6e28ee4 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -11,9 +11,9 @@
  *
  * Copyright (C) 2002-2005 Pavel Roskin <proski@gnu.org>
  * Portions based on orinoco_cs.c:
- * 	Copyright (C) David Gibson, Linuxcare Australia
+ *	Copyright (C) David Gibson, Linuxcare Australia
  * Portions based on Spectrum24tDnld.c from original spectrum24 driver:
- * 	Copyright (C) Symbol Technologies.
+ *	Copyright (C) Symbol Technologies.
  *
  * See copyright notice in file main.c.
  */
@@ -125,7 +125,7 @@ failed:
 }
 
 /********************************************************************/
-/* Device methods     						    */
+/* Device methods						    */
 /********************************************************************/
 
 static int
@@ -150,7 +150,7 @@ spectrum_cs_stop_firmware(struct orinoco_private *priv, int idle)
 }
 
 /********************************************************************/
-/* PCMCIA stuff     						    */
+/* PCMCIA stuff							    */
 /********************************************************************/
 
 static int
@@ -197,7 +197,7 @@ static int
 spectrum_cs_config(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int ret;
 	void __iomem *mem;
 
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index e793679..bbb9beb 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -87,7 +87,7 @@ nomem:
 static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	struct iw_statistics *wstats = &priv->wstats;
 	int err;
 	unsigned long flags;
@@ -448,7 +448,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 	}
 
 	if ((chan < 1) || (chan > NUM_CHANNELS) ||
-	     !(priv->channel_mask & (1 << (chan-1))))
+	     !(priv->channel_mask & (1 << (chan - 1))))
 		return -EINVAL;
 
 	if (orinoco_lock(priv, &flags) != 0)
@@ -457,7 +457,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 	priv->channel = chan;
 	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		/* Fast channel change - no commit if successful */
-		hermes_t *hw = &priv->hw;
+		struct hermes *hw = &priv->hw;
 		err = hw->ops->cmd_wait(hw, HERMES_CMD_TEST |
 					    HERMES_TEST_SET_CHANNEL,
 					chan, NULL);
@@ -492,7 +492,7 @@ static int orinoco_ioctl_getsens(struct net_device *dev,
 				 char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	u16 val;
 	int err;
 	unsigned long flags;
@@ -668,7 +668,7 @@ static int orinoco_ioctl_getpower(struct net_device *dev,
 				  char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int err = 0;
 	u16 enable, period, timeout, mcast;
 	unsigned long flags;
@@ -873,7 +873,7 @@ static int orinoco_ioctl_set_auth(struct net_device *dev,
 				  union iwreq_data *wrqu, char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	struct iw_param *param = &wrqu->param;
 	unsigned long flags;
 	int ret = -EINPROGRESS;
@@ -1269,7 +1269,7 @@ static int orinoco_ioctl_getrid(struct net_device *dev,
 				char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
+	struct hermes *hw = &priv->hw;
 	int rid = data->flags;
 	u16 length;
 	int err;
