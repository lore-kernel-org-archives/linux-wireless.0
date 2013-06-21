Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:50890
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1422896Ab3FUDDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 23:03:18 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next] cw1200:  Fix up a large pile of sparse warnings
Date: Thu, 20 Jun 2013 23:03:12 -0400
Message-Id: <1371783792-18755-1-git-send-email-pizza@shaftnet.org> (sfid-20130621_050323_245491_4AC74C7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of these relate to endianness problems, and are purely cosmetic.

But a couple of them were legit -- listen interval parsing and some of
the rate selection code would malfunction on BE systems.

There's still one cosmetic warning remaining, in the (admittedly) ugly
code in cw1200_spi.c.  It's there because the hardware needs 16-bit SPI
transfers, but many SPI controllers only operate 8 bits at a time.

If there's a cleaner way of handling this, I'm all ears.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200.h     |  2 +-
 drivers/net/wireless/cw1200/cw1200_spi.c | 32 ++++++++++++++---------
 drivers/net/wireless/cw1200/hwio.c       | 18 +++++++------
 drivers/net/wireless/cw1200/hwio.h       | 31 +++++++++++-----------
 drivers/net/wireless/cw1200/main.c       |  4 +--
 drivers/net/wireless/cw1200/queue.c      |  2 +-
 drivers/net/wireless/cw1200/sta.c        | 23 ++++++++--------
 drivers/net/wireless/cw1200/txrx.c       |  9 +++----
 drivers/net/wireless/cw1200/wsm.c        | 33 ++++++++++++-----------
 drivers/net/wireless/cw1200/wsm.h        | 45 +++++++++++++++-----------------
 10 files changed, 102 insertions(+), 97 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200.h b/drivers/net/wireless/cw1200/cw1200.h
index 243e963..1ad7d36 100644
--- a/drivers/net/wireless/cw1200/cw1200.h
+++ b/drivers/net/wireless/cw1200/cw1200.h
@@ -267,7 +267,7 @@ struct cw1200_common {
 	struct delayed_work	bss_loss_work;
 	spinlock_t		bss_loss_lock; /* Protect BSS loss state */
 	int                     bss_loss_state;
-	int                     bss_loss_confirm_id;
+	u32                     bss_loss_confirm_id;
 	int			delayed_link_loss;
 	struct work_struct	bss_params_work;
 
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 953bd19..b62befb 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -61,7 +61,7 @@ static int cw1200_spi_memcpy_fromio(struct hwbus_priv *self,
 				     void *dst, int count)
 {
 	int ret, i;
-	uint16_t regaddr;
+	u16 regaddr;
 	struct spi_message      m;
 
 	struct spi_transfer     t_addr = {
@@ -76,15 +76,18 @@ static int cw1200_spi_memcpy_fromio(struct hwbus_priv *self,
 	regaddr = (SDIO_TO_SPI_ADDR(addr))<<12;
 	regaddr |= SET_READ;
 	regaddr |= (count>>1);
-	regaddr = cpu_to_le16(regaddr);
 
 #ifdef SPI_DEBUG
-	pr_info("READ : %04d from 0x%02x (%04x)\n", count, addr,
-		le16_to_cpu(regaddr));
+	pr_info("READ : %04d from 0x%02x (%04x)\n", count, addr, regaddr);
 #endif
 
+	/* Header is LE16 */
+	regaddr = cpu_to_le16(regaddr);
+
+	/* We have to byteswap if the SPI bus is limited to 8b operation
+	   or we are running on a Big Endian system
+	*/
 #if defined(__LITTLE_ENDIAN)
-	/* We have to byteswap if the SPI bus is limited to 8b operation */
 	if (self->func->bits_per_word == 8)
 #endif
 		regaddr = swab16(regaddr);
@@ -104,8 +107,10 @@ static int cw1200_spi_memcpy_fromio(struct hwbus_priv *self,
 	printk("\n");
 #endif
 
+	/* We have to byteswap if the SPI bus is limited to 8b operation
+	   or we are running on a Big Endian system 
+	*/
 #if defined(__LITTLE_ENDIAN)
-	/* We have to byteswap if the SPI bus is limited to 8b operation */
 	if (self->func->bits_per_word == 8)
 #endif
 	{
@@ -122,7 +127,7 @@ static int cw1200_spi_memcpy_toio(struct hwbus_priv *self,
 				   const void *src, int count)
 {
 	int rval, i;
-	uint16_t regaddr;
+	u16 regaddr;
 	struct spi_transfer     t_addr = {
 		.tx_buf         = &regaddr,
 		.len            = sizeof(regaddr),
@@ -136,20 +141,23 @@ static int cw1200_spi_memcpy_toio(struct hwbus_priv *self,
 	regaddr = (SDIO_TO_SPI_ADDR(addr))<<12;
 	regaddr &= SET_WRITE;
 	regaddr |= (count>>1);
-	regaddr = cpu_to_le16(regaddr);
 
 #ifdef SPI_DEBUG
-	pr_info("WRITE: %04d  to  0x%02x (%04x)\n", count, addr,
-		le16_to_cpu(regaddr));
+	pr_info("WRITE: %04d  to  0x%02x (%04x)\n", count, addr, regaddr);
 #endif
 
+	/* Header is LE16 */
+	regaddr = cpu_to_le16(regaddr);
+
+	/* We have to byteswap if the SPI bus is limited to 8b operation
+	   or we are running on a Big Endian system
+	*/
 #if defined(__LITTLE_ENDIAN)
-	/* We have to byteswap if the SPI bus is limited to 8b operation */
 	if (self->func->bits_per_word == 8)
 #endif
 	{
 		uint16_t *buf = (uint16_t *)src;
-		regaddr = swab16(regaddr);
+	        regaddr = swab16(regaddr);
 		for (i = 0; i < ((count + 1) >> 1); i++)
 			buf[i] = swab16(buf[i]);
 	}
diff --git a/drivers/net/wireless/cw1200/hwio.c b/drivers/net/wireless/cw1200/hwio.c
index dad3fb3..ff230b7 100644
--- a/drivers/net/wireless/cw1200/hwio.c
+++ b/drivers/net/wireless/cw1200/hwio.c
@@ -69,31 +69,33 @@ static int __cw1200_reg_write(struct cw1200_common *priv, u16 addr,
 static inline int __cw1200_reg_read_32(struct cw1200_common *priv,
 					u16 addr, u32 *val)
 {
-	int i = __cw1200_reg_read(priv, addr, val, sizeof(*val), 0);
-	*val = le32_to_cpu(*val);
+	__le32 tmp;
+	int i = __cw1200_reg_read(priv, addr, &tmp, sizeof(tmp), 0);
+	*val = le32_to_cpu(tmp);
 	return i;
 }
 
 static inline int __cw1200_reg_write_32(struct cw1200_common *priv,
 					u16 addr, u32 val)
 {
-	val = cpu_to_le32(val);
-	return __cw1200_reg_write(priv, addr, &val, sizeof(val), 0);
+	__le32 tmp = cpu_to_le32(val);
+	return __cw1200_reg_write(priv, addr, &tmp, sizeof(tmp), 0);
 }
 
 static inline int __cw1200_reg_read_16(struct cw1200_common *priv,
 					u16 addr, u16 *val)
 {
-	int i = __cw1200_reg_read(priv, addr, val, sizeof(*val), 0);
-	*val = le16_to_cpu(*val);
+	__le16 tmp;
+	int i = __cw1200_reg_read(priv, addr, &tmp, sizeof(tmp), 0);
+	*val = le16_to_cpu(tmp);
 	return i;
 }
 
 static inline int __cw1200_reg_write_16(struct cw1200_common *priv,
 					u16 addr, u16 val)
 {
-	val = cpu_to_le16(val);
-	return __cw1200_reg_write(priv, addr, &val, sizeof(val), 0);
+	__le16 tmp = cpu_to_le16(val);
+	return __cw1200_reg_write(priv, addr, &tmp, sizeof(tmp), 0);
 }
 
 int cw1200_reg_read(struct cw1200_common *priv, u16 addr, void *buf,
diff --git a/drivers/net/wireless/cw1200/hwio.h b/drivers/net/wireless/cw1200/hwio.h
index 563329c..ddf5266 100644
--- a/drivers/net/wireless/cw1200/hwio.h
+++ b/drivers/net/wireless/cw1200/hwio.h
@@ -169,35 +169,34 @@ int cw1200_reg_write(struct cw1200_common *priv, u16 addr,
 static inline int cw1200_reg_read_16(struct cw1200_common *priv,
 				     u16 addr, u16 *val)
 {
-	u32 tmp;
+	__le32 tmp;
 	int i;
 	i = cw1200_reg_read(priv, addr, &tmp, sizeof(tmp));
-	tmp = le32_to_cpu(tmp);
-	*val = tmp & 0xffff;
+	*val = le32_to_cpu(tmp) & 0xfffff;
 	return i;
 }
 
 static inline int cw1200_reg_write_16(struct cw1200_common *priv,
 				      u16 addr, u16 val)
 {
-	u32 tmp = val;
-	tmp = cpu_to_le32(tmp);
+	__le32 tmp = cpu_to_le32((u32)val);
 	return cw1200_reg_write(priv, addr, &tmp, sizeof(tmp));
 }
 
 static inline int cw1200_reg_read_32(struct cw1200_common *priv,
 				     u16 addr, u32 *val)
 {
-	int i = cw1200_reg_read(priv, addr, val, sizeof(*val));
-	*val = le32_to_cpu(*val);
+	__le32 tmp;
+	int i = cw1200_reg_read(priv, addr, &tmp, sizeof(tmp));
+	*val = le32_to_cpu(tmp);
 	return i;
 }
 
 static inline int cw1200_reg_write_32(struct cw1200_common *priv,
 				      u16 addr, u32 val)
 {
-	val = cpu_to_le32(val);
-	return cw1200_reg_write(priv, addr, &val, sizeof(val));
+	__le32 tmp = cpu_to_le32(val);
+	return cw1200_reg_write(priv, addr, &tmp, sizeof(val));
 }
 
 int cw1200_indirect_read(struct cw1200_common *priv, u32 addr, void *buf,
@@ -224,22 +223,24 @@ static inline int cw1200_ahb_read(struct cw1200_common *priv, u32 addr,
 static inline int cw1200_apb_read_32(struct cw1200_common *priv,
 				     u32 addr, u32 *val)
 {
-	int i = cw1200_apb_read(priv, addr, val, sizeof(*val));
-	*val = le32_to_cpu(*val);
+	__le32 tmp;
+	int i = cw1200_apb_read(priv, addr, &tmp, sizeof(tmp));
+	*val = le32_to_cpu(tmp);
 	return i;
 }
 
 static inline int cw1200_apb_write_32(struct cw1200_common *priv,
 				      u32 addr, u32 val)
 {
-	val = cpu_to_le32(val);
-	return cw1200_apb_write(priv, addr, &val, sizeof(val));
+	__le32 tmp = cpu_to_le32(val);
+	return cw1200_apb_write(priv, addr, &tmp, sizeof(val));
 }
 static inline int cw1200_ahb_read_32(struct cw1200_common *priv,
 				     u32 addr, u32 *val)
 {
-	int i = cw1200_ahb_read(priv, addr, val, sizeof(*val));
-	*val = le32_to_cpu(*val);
+	__le32 tmp;
+	int i = cw1200_ahb_read(priv, addr, &tmp, sizeof(tmp));
+	*val = le32_to_cpu(tmp);
 	return i;
 }
 
diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index da88503..3724e73 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -238,8 +238,8 @@ static const struct ieee80211_ops cw1200_ops = {
 	/*.cancel_remain_on_channel = cw1200_cancel_remain_on_channel,	*/
 };
 
-int cw1200_ba_rx_tids = -1;
-int cw1200_ba_tx_tids = -1;
+static int cw1200_ba_rx_tids = -1;
+static int cw1200_ba_tx_tids = -1;
 module_param(cw1200_ba_rx_tids, int, 0644);
 module_param(cw1200_ba_tx_tids, int, 0644);
 MODULE_PARM_DESC(cw1200_ba_rx_tids, "Block ACK RX TIDs");
diff --git a/drivers/net/wireless/cw1200/queue.c b/drivers/net/wireless/cw1200/queue.c
index 8510454..9c3925f 100644
--- a/drivers/net/wireless/cw1200/queue.c
+++ b/drivers/net/wireless/cw1200/queue.c
@@ -355,7 +355,7 @@ int cw1200_queue_get(struct cw1200_queue *queue,
 		*tx = (struct wsm_tx *)item->skb->data;
 		*tx_info = IEEE80211_SKB_CB(item->skb);
 		*txpriv = &item->txpriv;
-		(*tx)->packet_id = __cpu_to_le32(item->packet_id);
+		(*tx)->packet_id = item->packet_id;
 		list_move_tail(&item->head, &queue->pending);
 		++queue->num_pending;
 		--queue->link_map_cache[item->txpriv.link_id];
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 4cd0352..7365674 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -621,7 +621,7 @@ int cw1200_conf_tx(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 	mutex_lock(&priv->conf_mutex);
 
 	if (queue < dev->queues) {
-		old_uapsd_flags = priv->uapsd_info.uapsd_flags;
+		old_uapsd_flags = le16_to_cpu(priv->uapsd_info.uapsd_flags);
 
 		WSM_TX_QUEUE_SET(&priv->tx_queue_params, queue, 0, 0, 0);
 		ret = wsm_set_tx_queue_params(priv,
@@ -645,7 +645,7 @@ int cw1200_conf_tx(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 			ret = cw1200_set_uapsd_param(priv, &priv->edca);
 			if (!ret && priv->setbssparams_done &&
 			    (priv->join_status == CW1200_JOIN_STATUS_STA) &&
-			    (old_uapsd_flags != priv->uapsd_info.uapsd_flags))
+			    (old_uapsd_flags != le16_to_cpu(priv->uapsd_info.uapsd_flags)))
 				ret = cw1200_set_pm(priv, &priv->powersave_mode);
 		}
 	} else {
@@ -1089,18 +1089,18 @@ static int cw1200_parse_sdd_file(struct cw1200_common *priv)
 				ret = -1;
 				break;
 			}
-			v = le16_to_cpu(*((u16 *)(p + 2)));
+			v = le16_to_cpu(*((__le16 *)(p + 2)));
 			if (!v)  /* non-zero means this is enabled */
 				break;
 
-			v = le16_to_cpu(*((u16 *)(p + 4)));
+			v = le16_to_cpu(*((__le16 *)(p + 4)));
 			priv->conf_listen_interval = (v >> 7) & 0x1F;
 			pr_debug("PTA found; Listen Interval %d\n",
 				 priv->conf_listen_interval);
 			break;
 		}
 		case SDD_REFERENCE_FREQUENCY_ELT_ID: {
-			u16 clk = le16_to_cpu(*((u16 *)(p + 2)));
+			u16 clk = le16_to_cpu(*((__le16 *)(p + 2)));
 			if (clk != priv->hw_refclk)
 				pr_warn("SDD file doesn't match configured refclk (%d vs %d)\n",
 					clk, priv->hw_refclk);
@@ -1785,9 +1785,9 @@ static int cw1200_set_btcoexinfo(struct cw1200_common *priv)
 		} else {
 			pr_debug("[STA] STA has non ERP rates\n");
 			/* B only mode */
-			arg.internalTxRate = (__ffs(priv->association_mode.basic_rate_set));
+			arg.internalTxRate = (__ffs(le32_to_cpu(priv->association_mode.basic_rate_set)));
 		}
-		arg.nonErpInternalTxRate = (__ffs(priv->association_mode.basic_rate_set));
+		arg.nonErpInternalTxRate = (__ffs(le32_to_cpu(priv->association_mode.basic_rate_set)));
 	} else {
 		/* P2P mode */
 		arg.internalTxRate = (__ffs(priv->bss_params.operational_rate_set & ~0xF));
@@ -1908,7 +1908,7 @@ void cw1200_bss_info_changed(struct ieee80211_hw *dev,
 
 		if (info->assoc || info->ibss_joined) {
 			struct ieee80211_sta *sta = NULL;
-			u32 val = 0;
+			__le32 htprot = 0;
 
 			if (info->dtim_period)
 				priv->join_dtim_period = info->dtim_period;
@@ -1935,19 +1935,18 @@ void cw1200_bss_info_changed(struct ieee80211_hw *dev,
 			/* Non Greenfield stations present */
 			if (priv->ht_info.operation_mode &
 			    IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT)
-				val |= WSM_NON_GREENFIELD_STA_PRESENT;
+				htprot |= cpu_to_le32(WSM_NON_GREENFIELD_STA_PRESENT);
 
 			/* Set HT protection method */
-			val |= (priv->ht_info.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION) << 2;
+			htprot |= cpu_to_le32((priv->ht_info.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION) << 2);
 
 			/* TODO:
 			 * STBC_param.dual_cts
 			 *  STBC_param.LSIG_TXOP_FILL
 			 */
 
-			val = cpu_to_le32(val);
 			wsm_write_mib(priv, WSM_MIB_ID_SET_HT_PROTECTION,
-				      &val, sizeof(val));
+				      &htprot, sizeof(htprot));
 
 			priv->association_mode.greenfield =
 				cw1200_ht_greenfield(&priv->ht_info);
diff --git a/drivers/net/wireless/cw1200/txrx.c b/drivers/net/wireless/cw1200/txrx.c
index 44ca10c..5862c37 100644
--- a/drivers/net/wireless/cw1200/txrx.c
+++ b/drivers/net/wireless/cw1200/txrx.c
@@ -599,15 +599,15 @@ cw1200_tx_h_bt(struct cw1200_common *priv,
 	} else if (ieee80211_is_data(t->hdr->frame_control)) {
 		/* Skip LLC SNAP header (+6) */
 		u8 *payload = &t->skb->data[t->hdrlen];
-		u16 *ethertype = (u16 *)&payload[6];
-		if (*ethertype == __be16_to_cpu(ETH_P_PAE))
+		__be16 *ethertype = (__be16 *)&payload[6];
+		if (be16_to_cpu(*ethertype) == ETH_P_PAE)
 			priority = WSM_EPTA_PRIORITY_EAPOL;
 	} else if (ieee80211_is_assoc_req(t->hdr->frame_control) ||
 		ieee80211_is_reassoc_req(t->hdr->frame_control)) {
 		struct ieee80211_mgmt *mgt_frame =
 				(struct ieee80211_mgmt *)t->hdr;
 
-		if (mgt_frame->u.assoc_req.listen_interval <
+		if (le16_to_cpu(mgt_frame->u.assoc_req.listen_interval) <
 						priv->listen_interval) {
 			pr_debug("Modified Listen Interval to %d from %d\n",
 				 priv->listen_interval,
@@ -615,8 +615,7 @@ cw1200_tx_h_bt(struct cw1200_common *priv,
 			/* Replace listen interval derieved from
 			 * the one read from SDD
 			 */
-			mgt_frame->u.assoc_req.listen_interval =
-				priv->listen_interval;
+			mgt_frame->u.assoc_req.listen_interval = cpu_to_le16(priv->listen_interval);
 		}
 	}
 
diff --git a/drivers/net/wireless/cw1200/wsm.c b/drivers/net/wireless/cw1200/wsm.c
index d95094f..cbb74d7 100644
--- a/drivers/net/wireless/cw1200/wsm.c
+++ b/drivers/net/wireless/cw1200/wsm.c
@@ -42,19 +42,19 @@
 		(buf)->data += size;					\
 	} while (0)
 
-#define __WSM_GET(buf, type, cvt)					\
+#define __WSM_GET(buf, type, type2, cvt)				\
 	({								\
 		type val;						\
 		if ((buf)->data + sizeof(type) > (buf)->end)		\
 			goto underflow;					\
-		val = cvt(*(type *)(buf)->data);			\
+		val = cvt(*(type2 *)(buf)->data);			\
 		(buf)->data += sizeof(type);				\
 		val;							\
 	})
 
-#define WSM_GET8(buf)  __WSM_GET(buf, u8, (u8))
-#define WSM_GET16(buf) __WSM_GET(buf, u16, __le16_to_cpu)
-#define WSM_GET32(buf) __WSM_GET(buf, u32, __le32_to_cpu)
+#define WSM_GET8(buf)  __WSM_GET(buf, u8, u8, (u8))
+#define WSM_GET16(buf) __WSM_GET(buf, u16, __le16, __le16_to_cpu)
+#define WSM_GET32(buf) __WSM_GET(buf, u32, __le32, __le32_to_cpu)
 
 #define WSM_PUT(buf, ptr, size)						\
 	do {								\
@@ -65,18 +65,18 @@
 		(buf)->data += size;					\
 	} while (0)
 
-#define __WSM_PUT(buf, val, type, cvt)					\
+#define __WSM_PUT(buf, val, type, type2, cvt)				\
 	do {								\
 		if ((buf)->data + sizeof(type) > (buf)->end)		\
 			if (wsm_buf_reserve((buf), sizeof(type))) \
 				goto nomem;				\
-		*(type *)(buf)->data = cvt(val);			\
+		*(type2 *)(buf)->data = cvt(val);			\
 		(buf)->data += sizeof(type);				\
 	} while (0)
 
-#define WSM_PUT8(buf, val)  __WSM_PUT(buf, val, u8, (u8))
-#define WSM_PUT16(buf, val) __WSM_PUT(buf, val, u16, __cpu_to_le16)
-#define WSM_PUT32(buf, val) __WSM_PUT(buf, val, u32, __cpu_to_le32)
+#define WSM_PUT8(buf, val)  __WSM_PUT(buf, val, u8, u8, (u8))
+#define WSM_PUT16(buf, val) __WSM_PUT(buf, val, u16, __le16, __cpu_to_le16)
+#define WSM_PUT32(buf, val) __WSM_PUT(buf, val, u32, __le32, __cpu_to_le32)
 
 static void wsm_buf_reset(struct wsm_buf *buf);
 static int wsm_buf_reserve(struct wsm_buf *buf, size_t extra_size);
@@ -931,8 +931,8 @@ static int wsm_event_indication(struct cw1200_common *priv, struct wsm_buf *buf)
 	if (!event)
 		return -ENOMEM;
 
-	event->evt.id = __le32_to_cpu(WSM_GET32(buf));
-	event->evt.data = __le32_to_cpu(WSM_GET32(buf));
+	event->evt.id = WSM_GET32(buf);
+	event->evt.data = WSM_GET32(buf);
 
 	pr_debug("[WSM] Event: %d(%d)\n",
 		 event->evt.id, event->evt.data);
@@ -1311,7 +1311,7 @@ int wsm_handle_rx(struct cw1200_common *priv, u16 id,
 
 	wsm_buf.begin = (u8 *)&wsm[0];
 	wsm_buf.data = (u8 *)&wsm[1];
-	wsm_buf.end = &wsm_buf.begin[__le32_to_cpu(wsm->len)];
+	wsm_buf.end = &wsm_buf.begin[__le16_to_cpu(wsm->len)];
 
 	pr_debug("[WSM] <<< 0x%.4X (%td)\n", id,
 		 wsm_buf.end - wsm_buf.begin);
@@ -1550,7 +1550,7 @@ static bool wsm_handle_tx_data(struct cw1200_common *priv,
 		 */
 		pr_debug("[WSM] Convert probe request to scan.\n");
 		wsm_lock_tx_async(priv);
-		priv->pending_frame_id = __le32_to_cpu(wsm->packet_id);
+		priv->pending_frame_id = wsm->packet_id;
 		if (queue_delayed_work(priv->workqueue,
 				       &priv->scan.probe_work, 0) <= 0)
 			wsm_unlock_tx(priv);
@@ -1558,15 +1558,14 @@ static bool wsm_handle_tx_data(struct cw1200_common *priv,
 		break;
 	case do_drop:
 		pr_debug("[WSM] Drop frame (0x%.4X).\n", fctl);
-		BUG_ON(cw1200_queue_remove(queue,
-					   __le32_to_cpu(wsm->packet_id)));
+		BUG_ON(cw1200_queue_remove(queue, wsm->packet_id));
 		handled = true;
 		break;
 	case do_wep:
 		pr_debug("[WSM] Issue set_default_wep_key.\n");
 		wsm_lock_tx_async(priv);
 		priv->wep_default_key_id = tx_info->control.hw_key->keyidx;
-		priv->pending_frame_id = __le32_to_cpu(wsm->packet_id);
+		priv->pending_frame_id = wsm->packet_id;
 		if (queue_work(priv->workqueue, &priv->wep_key_work) <= 0)
 			wsm_unlock_tx(priv);
 		handled = true;
diff --git a/drivers/net/wireless/cw1200/wsm.h b/drivers/net/wireless/cw1200/wsm.h
index 2816171..7afc613 100644
--- a/drivers/net/wireless/cw1200/wsm.h
+++ b/drivers/net/wireless/cw1200/wsm.h
@@ -806,7 +806,7 @@ struct wsm_tx {
 	struct wsm_hdr hdr;
 
 	/* Packet identifier that meant to be used in completion. */
-	__le32 packet_id;
+	u32 packet_id;  /* Note this is actually a cookie */
 
 	/* WSM_TRANSMIT_RATE_... */
 	u8 max_tx_rate;
@@ -825,18 +825,18 @@ struct wsm_tx {
 	u8 flags;
 
 	/* Should be 0. */
-	__le32 reserved;
+	u32 reserved;
 
 	/* The elapsed time in TUs, after the initial transmission */
 	/* of an MSDU, after which further attempts to transmit */
 	/* the MSDU shall be terminated. Overrides the global */
 	/* dot11MaxTransmitMsduLifeTime setting [optional] */
 	/* Device will set the default value if this is 0. */
-	__le32 expire_time;
+	u32 expire_time;
 
 	/* WSM_HT_TX_... */
 	__le32 ht_tx_parameters;
-};
+} __packed;
 
 /* = sizeof(generic hi hdr) + sizeof(wsm hdr) + sizeof(alignment) */
 #define WSM_TX_EXTRA_HEADROOM (28)
@@ -846,10 +846,10 @@ struct wsm_tx {
 
 struct wsm_rx {
 	/* WSM_STATUS_... */
-	__le32 status;
+	u32 status;
 
 	/* Specifies the channel of the received packet. */
-	__le16 channel_number;
+	u16 channel_number;
 
 	/* WSM_TRANSMIT_RATE_... */
 	u8 rx_rate;
@@ -859,11 +859,8 @@ struct wsm_rx {
 	u8 rcpi_rssi;
 
 	/* WSM_RX_STATUS_... */
-	__le32 flags;
-
-	/* Payload */
-	u8 data[0];
-} __packed;
+	u32 flags;
+};
 
 /* = sizeof(generic hi hdr) + sizeof(wsm hdr) */
 #define WSM_RX_EXTRA_HEADROOM (16)
@@ -1119,22 +1116,22 @@ int wsm_set_tx_queue_params(struct cw1200_common *priv,
 #define WSM_EDCA_PARAMS_RESP_ID 0x0413
 struct wsm_edca_queue_params {
 	/* CWmin (in slots) for the access class. */
-	__le16 cwmin;
+	u16 cwmin;
 
 	/* CWmax (in slots) for the access class. */
-	__le16 cwmax;
+	u16 cwmax;
 
 	/* AIFS (in slots) for the access class. */
-	__le16 aifns;
+	u16 aifns;
 
 	/* TX OP Limit (in microseconds) for the access class. */
-	__le16 txop_limit;
+	u16 txop_limit;
 
 	/* dot11MaxReceiveLifetime to be used for the specified */
 	/* the access class. Overrides the global */
 	/* dot11MaxReceiveLifetime value */
-	__le32 max_rx_lifetime;
-} __packed;
+	u32 max_rx_lifetime;
+};
 
 struct wsm_edca_params {
 	/* NOTE: index is a linux queue id. */
@@ -1147,12 +1144,12 @@ struct wsm_edca_params {
 		     __uapsd) \
 	do {							\
 		struct wsm_edca_queue_params *p = &(__edca)->params[__queue]; \
-		p->cwmin = (__cw_min);				\
-		p->cwmax = (__cw_max);				\
-		p->aifns = (__aifs);				\
-		p->txop_limit = ((__txop) * TXOP_UNIT);		\
-		p->max_rx_lifetime = (__lifetime);		\
-		(__edca)->uapsd_enable[__queue] = (__uapsd);	\
+		p->cwmin = __cw_min;					\
+		p->cwmax = __cw_max;					\
+		p->aifns = __aifs;					\
+		p->txop_limit = ((__txop) * TXOP_UNIT);			\
+		p->max_rx_lifetime = __lifetime;			\
+		(__edca)->uapsd_enable[__queue] = (__uapsd);		\
 	} while (0)
 
 int wsm_set_edca_params(struct cw1200_common *priv,
@@ -1475,7 +1472,7 @@ static inline int wsm_set_template_frame(struct cw1200_common *priv,
 	u8 *p = skb_push(arg->skb, 4);
 	p[0] = arg->frame_type;
 	p[1] = arg->rate;
-	((u16 *)p)[1] = __cpu_to_le16(arg->skb->len - 4);
+	((__le16 *)p)[1] = __cpu_to_le16(arg->skb->len - 4);
 	ret = wsm_write_mib(priv, WSM_MIB_ID_TEMPLATE_FRAME, p, arg->skb->len);
 	skb_pull(arg->skb, 4);
 	return ret;
-- 
1.8.2.1

