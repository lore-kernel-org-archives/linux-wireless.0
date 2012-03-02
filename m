Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:41983 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932349Ab2CBBlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 20:41:53 -0500
Received: from zeta.dmz-us.st.com (ns4.st.com [167.4.16.71])
	by beta.dmz-us.st.com (STMicroelectronics) with ESMTP id 7850064
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:31 +0000 (GMT)
Received: from relay2.stm.gmessaging.net (unknown [10.230.100.18])
	by zeta.dmz-us.st.com (STMicroelectronics) with ESMTP id 3400657
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 00:12:54 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay2.stm.gmessaging.net (Postfix) with ESMTPS id 318F3A8065
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 02:41:41 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 08/21] cw1200: wsm.*, implementation of device high-level interface.
Date: Fri, 2 Mar 2012 02:41:22 +0100
Message-ID: <1330652495-25837-9-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024221_236578_27353535)
In-Reply-To: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WSM is a message interface between the host and the device.
The patch defines and implements WSM abstraction layer.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/staging/cw1200/wsm.c | 1834 ++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/wsm.h | 1833 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 3667 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/cw1200/wsm.c
 create mode 100644 drivers/staging/cw1200/wsm.h

diff --git a/drivers/staging/cw1200/wsm.c b/drivers/staging/cw1200/wsm.c
new file mode 100644
index 0000000..e21bcc3
--- /dev/null
+++ b/drivers/staging/cw1200/wsm.c
@@ -0,0 +1,1834 @@
+/*
+ * WSM host interface (HI) implementation for
+ * ST-Ericsson CW1200 mac80211 drivers.
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/skbuff.h>
+#include <linux/wait.h>
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/random.h>
+
+#include "cw1200.h"
+#include "wsm.h"
+#include "bh.h"
+#include "debug.h"
+#include "itp.h"
+
+#if defined(CONFIG_CW1200_WSM_DEBUG)
+#define wsm_printk(...) printk(__VA_ARGS__)
+#else
+#define wsm_printk(...)
+#endif
+
+#define WSM_CMD_TIMEOUT		(2 * HZ) /* With respect to interrupt loss */
+#define WSM_CMD_JOIN_TIMEOUT	(7 * HZ) /* Join timeout is 5 sec. in FW   */
+#define WSM_CMD_START_TIMEOUT	(7 * HZ)
+#define WSM_CMD_RESET_TIMEOUT	(3 * HZ) /* 2 sec. timeout was observed.   */
+
+#define WSM_SKIP(buf, size)						\
+	do {								\
+		if (unlikely((buf)->data + size > (buf)->end))		\
+			goto underflow;					\
+		(buf)->data += size;					\
+	} while (0)
+
+#define WSM_GET(buf, ptr, size)						\
+	do {								\
+		if (unlikely((buf)->data + size > (buf)->end))		\
+			goto underflow;					\
+		memcpy(ptr, (buf)->data, size);				\
+		(buf)->data += size;					\
+	} while (0)
+
+#define __WSM_GET(buf, type, cvt)					\
+	({								\
+		type val;						\
+		if (unlikely((buf)->data + sizeof(type) > (buf)->end))	\
+			goto underflow;					\
+		val = cvt(*(type *)(buf)->data);			\
+		(buf)->data += sizeof(type);				\
+		val;							\
+	})
+
+#define WSM_GET8(buf)  __WSM_GET(buf, u8, (u8))
+#define WSM_GET16(buf) __WSM_GET(buf, u16, __le16_to_cpu)
+#define WSM_GET32(buf) __WSM_GET(buf, u32, __le32_to_cpu)
+
+#define WSM_PUT(buf, ptr, size)						\
+	do {								\
+		if (unlikely((buf)->data + size > (buf)->end))		\
+			if (unlikely(wsm_buf_reserve((buf), size)))	\
+				goto nomem;				\
+		memcpy((buf)->data, ptr, size);				\
+		(buf)->data += size;					\
+	} while (0)
+
+#define __WSM_PUT(buf, val, type, cvt)					\
+	do {								\
+		if (unlikely((buf)->data + sizeof(type) > (buf)->end))	\
+			if (unlikely(wsm_buf_reserve((buf), sizeof(type)))) \
+				goto nomem;				\
+		*(type *)(buf)->data = cvt(val);			\
+		(buf)->data += sizeof(type);				\
+	} while (0)
+
+#define WSM_PUT8(buf, val)  __WSM_PUT(buf, val, u8, (u8))
+#define WSM_PUT16(buf, val) __WSM_PUT(buf, val, u16, __cpu_to_le16)
+#define WSM_PUT32(buf, val) __WSM_PUT(buf, val, u32, __cpu_to_le32)
+
+static void wsm_buf_reset(struct wsm_buf *buf);
+static int wsm_buf_reserve(struct wsm_buf *buf, size_t extra_size);
+
+static int wsm_cmd_send(struct cw1200_common *priv,
+			struct wsm_buf *buf,
+			void *arg, u16 cmd, long tmo);
+
+static inline void wsm_cmd_lock(struct cw1200_common *priv)
+{
+	mutex_lock(&priv->wsm_cmd_mux);
+}
+
+static inline void wsm_cmd_unlock(struct cw1200_common *priv)
+{
+	mutex_unlock(&priv->wsm_cmd_mux);
+}
+
+/* ******************************************************************** */
+/* WSM API implementation						*/
+
+static int wsm_generic_confirm(struct cw1200_common *priv,
+			     void *arg,
+			     struct wsm_buf *buf)
+{
+	u32 status = WSM_GET32(buf);
+	if (status != WSM_STATUS_SUCCESS)
+		return -EINVAL;
+	return 0;
+
+underflow:
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+int wsm_configuration(struct cw1200_common *priv, struct wsm_configuration *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT32(buf, arg->dot11MaxTransmitMsduLifeTime);
+	WSM_PUT32(buf, arg->dot11MaxReceiveLifeTime);
+	WSM_PUT32(buf, arg->dot11RtsThreshold);
+
+	/* DPD block. */
+	WSM_PUT16(buf, arg->dpdData_size + 12);
+	WSM_PUT16(buf, 1); /* DPD version */
+	WSM_PUT(buf, arg->dot11StationId, ETH_ALEN);
+	WSM_PUT16(buf, 5); /* DPD flags */
+	WSM_PUT(buf, arg->dpdData, arg->dpdData_size);
+
+	ret = wsm_cmd_send(priv, buf, arg, 0x0009, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+static int wsm_configuration_confirm(struct cw1200_common *priv,
+				     struct wsm_configuration *arg,
+				     struct wsm_buf *buf)
+{
+	int i;
+	int status;
+
+	status = WSM_GET32(buf);
+	if (WARN_ON(status != WSM_STATUS_SUCCESS))
+		return -EINVAL;
+
+	WSM_GET(buf, arg->dot11StationId, ETH_ALEN);
+	arg->dot11FrequencyBandsSupported = WSM_GET8(buf);
+	WSM_SKIP(buf, 1);
+	arg->supportedRateMask = WSM_GET32(buf);
+	for (i = 0; i < 2; ++i) {
+		arg->txPowerRange[i].min_power_level = WSM_GET32(buf);
+		arg->txPowerRange[i].max_power_level = WSM_GET32(buf);
+		arg->txPowerRange[i].stepping = WSM_GET32(buf);
+	}
+	return 0;
+
+underflow:
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+/* ******************************************************************** */
+
+int wsm_reset(struct cw1200_common *priv, const struct wsm_reset *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+	u16 cmd = 0x000A | WSM_TX_LINK_ID(arg->link_id);
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT32(buf, arg->reset_statistics ? 0 : 1);
+	ret = wsm_cmd_send(priv, buf, NULL, cmd, WSM_CMD_RESET_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+struct wsm_mib {
+	u16 mibId;
+	void *buf;
+	size_t buf_size;
+};
+
+int wsm_read_mib(struct cw1200_common *priv, u16 mibId, void *_buf,
+			size_t buf_size)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+	struct wsm_mib mib_buf = {
+		.mibId = mibId,
+		.buf = _buf,
+		.buf_size = buf_size,
+	};
+	wsm_cmd_lock(priv);
+
+	WSM_PUT16(buf, mibId);
+	WSM_PUT16(buf, 0);
+
+	ret = wsm_cmd_send(priv, buf, &mib_buf, 0x0005, WSM_CMD_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+static int wsm_read_mib_confirm(struct cw1200_common *priv,
+				struct wsm_mib *arg,
+				struct wsm_buf *buf)
+{
+	u16 size;
+	if (WARN_ON(WSM_GET32(buf) != WSM_STATUS_SUCCESS))
+		return -EINVAL;
+
+	if (WARN_ON(WSM_GET16(buf) != arg->mibId))
+		return -EINVAL;
+
+	size = WSM_GET16(buf);
+	if (size > arg->buf_size)
+		size = arg->buf_size;
+
+	WSM_GET(buf, arg->buf, size);
+	arg->buf_size = size;
+	return 0;
+
+underflow:
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+/* ******************************************************************** */
+
+int wsm_write_mib(struct cw1200_common *priv, u16 mibId, void *_buf,
+			size_t buf_size)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+	struct wsm_mib mib_buf = {
+		.mibId = mibId,
+		.buf = _buf,
+		.buf_size = buf_size,
+	};
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT16(buf, mibId);
+	WSM_PUT16(buf, buf_size);
+	WSM_PUT(buf, _buf, buf_size);
+
+	ret = wsm_cmd_send(priv, buf, &mib_buf, 0x0006, WSM_CMD_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+static int wsm_write_mib_confirm(struct cw1200_common *priv,
+				struct wsm_mib *arg,
+				struct wsm_buf *buf)
+{
+	int ret;
+
+	ret = wsm_generic_confirm(priv, arg, buf);
+	if (ret)
+		return ret;
+
+	if (arg->mibId == 0x1006) {
+		/* OperationalMode: update PM status. */
+		const char *p = arg->buf;
+		cw1200_enable_powersave(priv,
+				(p[0] & 0x0F) ? true : false);
+	}
+	return 0;
+}
+
+/* ******************************************************************** */
+
+int wsm_scan(struct cw1200_common *priv, const struct wsm_scan *arg)
+{
+	int i;
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	if (unlikely(arg->numOfChannels > 48))
+		return -EINVAL;
+
+	if (unlikely(arg->numOfSSIDs > 2))
+		return -EINVAL;
+
+	if (unlikely(arg->band > 1))
+		return -EINVAL;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT8(buf, arg->band);
+	WSM_PUT8(buf, arg->scanType);
+	WSM_PUT8(buf, arg->scanFlags);
+	WSM_PUT8(buf, arg->maxTransmitRate);
+	WSM_PUT32(buf, arg->autoScanInterval);
+	WSM_PUT8(buf, arg->numOfProbeRequests);
+	WSM_PUT8(buf, arg->numOfChannels);
+	WSM_PUT8(buf, arg->numOfSSIDs);
+	WSM_PUT8(buf, arg->probeDelay);
+
+	for (i = 0; i < arg->numOfChannels; ++i) {
+		WSM_PUT16(buf, arg->ch[i].number);
+		WSM_PUT16(buf, 0);
+		WSM_PUT32(buf, arg->ch[i].minChannelTime);
+		WSM_PUT32(buf, arg->ch[i].maxChannelTime);
+		WSM_PUT32(buf, 0);
+	}
+
+	for (i = 0; i < arg->numOfSSIDs; ++i) {
+		WSM_PUT32(buf, arg->ssids[i].length);
+		WSM_PUT(buf, &arg->ssids[i].ssid[0],
+				sizeof(arg->ssids[i].ssid));
+	}
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0007, WSM_CMD_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_stop_scan(struct cw1200_common *priv)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+	wsm_cmd_lock(priv);
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0008, WSM_CMD_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+}
+
+
+static int wsm_tx_confirm(struct cw1200_common *priv,
+			  struct wsm_buf *buf,
+			  int link_id)
+{
+	struct wsm_tx_confirm tx_confirm;
+
+	tx_confirm.packetID = WSM_GET32(buf);
+	tx_confirm.status = WSM_GET32(buf);
+	tx_confirm.txedRate = WSM_GET8(buf);
+	tx_confirm.ackFailures = WSM_GET8(buf);
+	tx_confirm.flags = WSM_GET16(buf);
+	tx_confirm.mediaDelay = WSM_GET32(buf);
+	tx_confirm.txQueueDelay = WSM_GET32(buf);
+	tx_confirm.link_id = link_id;
+
+	if (priv->wsm_cbc.tx_confirm)
+		priv->wsm_cbc.tx_confirm(priv, &tx_confirm);
+	return 0;
+
+underflow:
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static int wsm_multi_tx_confirm(struct cw1200_common *priv,
+				struct wsm_buf *buf, int link_id)
+{
+	int ret;
+	int count;
+	int i;
+
+	count = WSM_GET32(buf);
+	if (WARN_ON(count <= 0))
+		return -EINVAL;
+	else if (count > 1) {
+		ret = wsm_release_tx_buffer(priv, count - 1);
+		if (ret < 0)
+			return ret;
+		else if (ret > 0)
+			cw1200_bh_wakeup(priv);
+	}
+
+	cw1200_debug_txed_multi(priv, count);
+	for (i = 0; i < count; ++i) {
+		ret = wsm_tx_confirm(priv, buf, link_id);
+		if (ret)
+			return ret;
+	}
+	return ret;
+
+underflow:
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+/* ******************************************************************** */
+
+static int wsm_join_confirm(struct cw1200_common *priv,
+			    struct wsm_join *arg,
+			    struct wsm_buf *buf)
+{
+	if (WARN_ON(WSM_GET32(buf) != WSM_STATUS_SUCCESS))
+		return -EINVAL;
+
+	arg->minPowerLevel = WSM_GET32(buf);
+	arg->maxPowerLevel = WSM_GET32(buf);
+
+	return 0;
+
+underflow:
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+int wsm_join(struct cw1200_common *priv, struct wsm_join *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+	wsm_cmd_lock(priv);
+
+	WSM_PUT8(buf, arg->mode);
+	WSM_PUT8(buf, arg->band);
+	WSM_PUT16(buf, arg->channelNumber);
+	WSM_PUT(buf, &arg->bssid[0], sizeof(arg->bssid));
+	WSM_PUT16(buf, arg->atimWindow);
+	WSM_PUT8(buf, arg->preambleType);
+	WSM_PUT8(buf, arg->probeForJoin);
+	WSM_PUT8(buf, arg->dtimPeriod);
+	WSM_PUT8(buf, arg->flags);
+	WSM_PUT32(buf, arg->ssidLength);
+	WSM_PUT(buf, &arg->ssid[0], sizeof(arg->ssid));
+	WSM_PUT32(buf, arg->beaconInterval);
+	WSM_PUT32(buf, arg->basicRateSet);
+
+	priv->tx_burst_idx = -1;
+	ret = wsm_cmd_send(priv, buf, arg, 0x000B, WSM_CMD_JOIN_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_set_bss_params(struct cw1200_common *priv,
+			const struct wsm_set_bss_params *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT8(buf, 0);
+	WSM_PUT8(buf, arg->beaconLostCount);
+	WSM_PUT16(buf, arg->aid);
+	WSM_PUT32(buf, arg->operationalRateSet);
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0011, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_add_key(struct cw1200_common *priv, const struct wsm_add_key *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT(buf, arg, sizeof(*arg));
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x000C, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_remove_key(struct cw1200_common *priv, const struct wsm_remove_key *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT8(buf, arg->entryIndex);
+	WSM_PUT8(buf, 0);
+	WSM_PUT16(buf, 0);
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x000D, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_set_tx_queue_params(struct cw1200_common *priv,
+		const struct wsm_set_tx_queue_params *arg, u8 id)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+	u8 queue_id_to_wmm_aci[] = {3, 2, 0, 1};
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT8(buf, queue_id_to_wmm_aci[id]);
+	WSM_PUT8(buf, 0);
+	WSM_PUT8(buf, arg->ackPolicy);
+	WSM_PUT8(buf, 0);
+	WSM_PUT32(buf, arg->maxTransmitLifetime);
+	WSM_PUT16(buf, arg->allowedMediumTime);
+	WSM_PUT16(buf, 0);
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0012, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_set_edca_params(struct cw1200_common *priv,
+				const struct wsm_edca_params *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	/* Implemented according to specification. */
+
+	WSM_PUT16(buf, arg->params[3].cwMin);
+	WSM_PUT16(buf, arg->params[2].cwMin);
+	WSM_PUT16(buf, arg->params[1].cwMin);
+	WSM_PUT16(buf, arg->params[0].cwMin);
+
+	WSM_PUT16(buf, arg->params[3].cwMax);
+	WSM_PUT16(buf, arg->params[2].cwMax);
+	WSM_PUT16(buf, arg->params[1].cwMax);
+	WSM_PUT16(buf, arg->params[0].cwMax);
+
+	WSM_PUT8(buf, arg->params[3].aifns);
+	WSM_PUT8(buf, arg->params[2].aifns);
+	WSM_PUT8(buf, arg->params[1].aifns);
+	WSM_PUT8(buf, arg->params[0].aifns);
+
+	WSM_PUT16(buf, arg->params[3].txOpLimit);
+	WSM_PUT16(buf, arg->params[2].txOpLimit);
+	WSM_PUT16(buf, arg->params[1].txOpLimit);
+	WSM_PUT16(buf, arg->params[0].txOpLimit);
+
+	WSM_PUT32(buf, arg->params[3].maxReceiveLifetime);
+	WSM_PUT32(buf, arg->params[2].maxReceiveLifetime);
+	WSM_PUT32(buf, arg->params[1].maxReceiveLifetime);
+	WSM_PUT32(buf, arg->params[0].maxReceiveLifetime);
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0013, WSM_CMD_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_switch_channel(struct cw1200_common *priv,
+			const struct wsm_switch_channel *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_lock_tx(priv);
+	wsm_cmd_lock(priv);
+
+	WSM_PUT8(buf, arg->channelMode);
+	WSM_PUT8(buf, arg->channelSwitchCount);
+	WSM_PUT16(buf, arg->newChannelNumber);
+
+	priv->channel_switch_in_progress = 1;
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0016, WSM_CMD_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	if (ret) {
+		wsm_unlock_tx(priv);
+		priv->channel_switch_in_progress = 0;
+	}
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	wsm_unlock_tx(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_set_pm(struct cw1200_common *priv, const struct wsm_set_pm *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT8(buf, arg->pmMode);
+	WSM_PUT8(buf, arg->fastPsmIdlePeriod);
+	WSM_PUT8(buf, arg->apPsmChangePeriod);
+	WSM_PUT8(buf, arg->minAutoPsPollPeriod);
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0010, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_start(struct cw1200_common *priv, const struct wsm_start *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT8(buf, arg->mode);
+	WSM_PUT8(buf, arg->band);
+	WSM_PUT16(buf, arg->channelNumber);
+	WSM_PUT32(buf, arg->CTWindow);
+	WSM_PUT32(buf, arg->beaconInterval);
+	WSM_PUT8(buf, arg->DTIMPeriod);
+	WSM_PUT8(buf, arg->preambleType);
+	WSM_PUT8(buf, arg->probeDelay);
+	WSM_PUT8(buf, arg->ssidLength);
+	WSM_PUT(buf, arg->ssid, sizeof(arg->ssid));
+	WSM_PUT32(buf, arg->basicRateSet);
+
+	priv->tx_burst_idx = -1;
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0017, WSM_CMD_START_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_beacon_transmit(struct cw1200_common *priv,
+			const struct wsm_beacon_transmit *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT32(buf, arg->enableBeaconing ? 1 : 0);
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0018, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_start_find(struct cw1200_common *priv)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+	ret = wsm_cmd_send(priv, buf, NULL, 0x0019, WSM_CMD_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+}
+
+/* ******************************************************************** */
+
+int wsm_stop_find(struct cw1200_common *priv)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+	ret = wsm_cmd_send(priv, buf, NULL, 0x001A, WSM_CMD_TIMEOUT);
+	wsm_cmd_unlock(priv);
+	return ret;
+}
+
+/* ******************************************************************** */
+
+int wsm_map_link(struct cw1200_common *priv, const struct wsm_map_link *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+	u16 cmd = 0x001C | WSM_TX_LINK_ID(arg->link_id);
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT(buf, &arg->mac_addr[0], sizeof(arg->mac_addr));
+	WSM_PUT16(buf, 0);
+
+	ret = wsm_cmd_send(priv, buf, NULL, cmd, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+}
+
+/* ******************************************************************** */
+
+int wsm_update_ie(struct cw1200_common *priv,
+		  const struct wsm_update_ie *arg)
+{
+	int ret;
+	struct wsm_buf *buf = &priv->wsm_cmd_buf;
+
+	wsm_cmd_lock(priv);
+
+	WSM_PUT16(buf, arg->what);
+	WSM_PUT16(buf, arg->count);
+	WSM_PUT(buf, arg->ies, arg->length);
+
+	ret = wsm_cmd_send(priv, buf, NULL, 0x001B, WSM_CMD_TIMEOUT);
+
+	wsm_cmd_unlock(priv);
+	return ret;
+
+nomem:
+	wsm_cmd_unlock(priv);
+	return -ENOMEM;
+
+}
+
+/* ******************************************************************** */
+/* WSM indication events implementation					*/
+
+static int wsm_startup_indication(struct cw1200_common *priv,
+					struct wsm_buf *buf)
+{
+	u16 status;
+	char fw_label[129];
+	static const char * const fw_types[] = {
+		"ETF",
+		"WFM",
+		"WSM",
+		"HI test",
+		"Platform test"
+	};
+
+	priv->wsm_caps.numInpChBufs	= WSM_GET16(buf);
+	priv->wsm_caps.sizeInpChBuf	= WSM_GET16(buf);
+	priv->wsm_caps.hardwareId	= WSM_GET16(buf);
+	priv->wsm_caps.hardwareSubId	= WSM_GET16(buf);
+	status				= WSM_GET16(buf);
+	priv->wsm_caps.firmwareCap	= WSM_GET16(buf);
+	priv->wsm_caps.firmwareType	= WSM_GET16(buf);
+	priv->wsm_caps.firmwareApiVer	= WSM_GET16(buf);
+	priv->wsm_caps.firmwareBuildNumber = WSM_GET16(buf);
+	priv->wsm_caps.firmwareVersion	= WSM_GET16(buf);
+	WSM_GET(buf, &fw_label[0], sizeof(fw_label) - 1);
+	fw_label[sizeof(fw_label) - 1] = 0; /* Do not trust FW too much. */
+
+	if (WARN_ON(status))
+		return -EINVAL;
+
+	if (WARN_ON(priv->wsm_caps.firmwareType > 4))
+		return -EINVAL;
+
+	printk(KERN_INFO "CW1200 WSM init done.\n"
+		"   Input buffers: %d x %d bytes\n"
+		"   Hardware: %d.%d\n"
+		"   %s firmware [%s], ver: %d, build: %d,"
+		    " api: %d, cap: 0x%.4X\n",
+		priv->wsm_caps.numInpChBufs, priv->wsm_caps.sizeInpChBuf,
+		priv->wsm_caps.hardwareId, priv->wsm_caps.hardwareSubId,
+		fw_types[priv->wsm_caps.firmwareType],
+		&fw_label[0], priv->wsm_caps.firmwareVersion,
+		priv->wsm_caps.firmwareBuildNumber,
+		priv->wsm_caps.firmwareApiVer, priv->wsm_caps.firmwareCap);
+
+	priv->wsm_caps.firmwareReady = 1;
+
+	wake_up(&priv->wsm_startup_done);
+	return 0;
+
+underflow:
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static int wsm_receive_indication(struct cw1200_common *priv,
+					int link_id,
+					struct wsm_buf *buf,
+					struct sk_buff **skb_p)
+{
+	priv->rx_timestamp = jiffies;
+	if (priv->wsm_cbc.rx) {
+		struct wsm_rx rx;
+		struct ieee80211_hdr *hdr;
+		size_t hdr_len;
+		__le16 fctl;
+
+		rx.status = WSM_GET32(buf);
+		rx.channelNumber = WSM_GET16(buf);
+		rx.rxedRate = WSM_GET8(buf);
+		rx.rcpiRssi = WSM_GET8(buf);
+		rx.flags = WSM_GET32(buf);
+
+		/* FW Workaround: Drop probe resp or
+		beacon when RSSI is 0 */
+		hdr = (struct ieee80211_hdr *) (*skb_p)->data;
+
+		if (!rx.rcpiRssi &&
+		    (ieee80211_is_probe_resp(hdr->frame_control) ||
+		    ieee80211_is_beacon(hdr->frame_control)))
+			return 0;
+
+		/* If no RSSI subscription has been made,
+		* convert RCPI to RSSI here */
+		if (!priv->cqm_use_rssi)
+			rx.rcpiRssi = rx.rcpiRssi / 2 - 110;
+
+		rx.link_id = link_id;
+		fctl = *(__le16 *)buf->data;
+		hdr_len = buf->data - buf->begin;
+		skb_pull(*skb_p, hdr_len);
+		if (!rx.status && unlikely(ieee80211_is_deauth(fctl))) {
+			if (priv->join_status == CW1200_JOIN_STATUS_STA) {
+				/* Shedule unjoin work */
+				wsm_printk(KERN_DEBUG \
+					"[WSM] Issue unjoin command (RX).\n");
+				wsm_lock_tx_async(priv);
+				if (queue_work(priv->workqueue,
+						&priv->unjoin_work) <= 0)
+					wsm_unlock_tx(priv);
+			}
+		}
+		priv->wsm_cbc.rx(priv, &rx, skb_p);
+		if (*skb_p)
+			skb_push(*skb_p, hdr_len);
+	}
+	return 0;
+
+underflow:
+	return -EINVAL;
+}
+
+static int wsm_event_indication(struct cw1200_common *priv, struct wsm_buf *buf)
+{
+	int first;
+	struct cw1200_wsm_event *event;
+
+	if (unlikely(priv->mode == NL80211_IFTYPE_UNSPECIFIED)) {
+		/* STA is stopped. */
+		return 0;
+	}
+
+	event = kzalloc(sizeof(struct cw1200_wsm_event), GFP_KERNEL);
+
+	event->evt.eventId = __le32_to_cpu(WSM_GET32(buf));
+	event->evt.eventData = __le32_to_cpu(WSM_GET32(buf));
+
+	wsm_printk(KERN_DEBUG "[WSM] Event: %d(%d)\n",
+		event->evt.eventId, event->evt.eventData);
+
+	spin_lock(&priv->event_queue_lock);
+	first = list_empty(&priv->event_queue);
+	list_add_tail(&event->link, &priv->event_queue);
+	spin_unlock(&priv->event_queue_lock);
+
+	if (first)
+		queue_work(priv->workqueue, &priv->event_handler);
+
+	return 0;
+
+underflow:
+	kfree(event);
+	return -EINVAL;
+}
+
+static int wsm_channel_switch_indication(struct cw1200_common *priv,
+						struct wsm_buf *buf)
+{
+	wsm_unlock_tx(priv); /* Re-enable datapath */
+	WARN_ON(WSM_GET32(buf));
+
+	priv->channel_switch_in_progress = 0;
+	wake_up(&priv->channel_switch_done);
+
+	if (priv->wsm_cbc.channel_switch)
+		priv->wsm_cbc.channel_switch(priv);
+	return 0;
+
+underflow:
+	return -EINVAL;
+}
+
+static int wsm_set_pm_indication(struct cw1200_common *priv,
+					struct wsm_buf *buf)
+{
+	return 0;
+}
+
+static int wsm_scan_complete_indication(struct cw1200_common *priv,
+					struct wsm_buf *buf)
+{
+	if (priv->wsm_cbc.scan_complete) {
+		struct wsm_scan_complete arg;
+		arg.status = WSM_GET32(buf);
+		arg.psm = WSM_GET8(buf);
+		arg.numChannels = WSM_GET8(buf);
+		priv->wsm_cbc.scan_complete(priv, &arg);
+	}
+	return 0;
+
+underflow:
+	return -EINVAL;
+}
+
+static int wsm_find_complete_indication(struct cw1200_common *priv,
+					struct wsm_buf *buf)
+{
+	/* TODO: Implement me. */
+	STUB();
+	return 0;
+}
+
+static int wsm_suspend_resume_indication(struct cw1200_common *priv,
+					 int link_id, struct wsm_buf *buf)
+{
+	if (priv->wsm_cbc.suspend_resume) {
+		u32 flags;
+		struct wsm_suspend_resume arg;
+
+		flags = WSM_GET32(buf);
+		arg.link_id = link_id;
+		arg.stop = !(flags & 1);
+		arg.multicast = !!(flags & 8);
+		arg.queue = (flags >> 1) & 3;
+
+		priv->wsm_cbc.suspend_resume(priv, &arg);
+	}
+	return 0;
+
+underflow:
+	return -EINVAL;
+}
+
+
+/* ******************************************************************** */
+/* WSM TX								*/
+
+int wsm_cmd_send(struct cw1200_common *priv,
+		 struct wsm_buf *buf,
+		 void *arg, u16 cmd, long tmo)
+{
+	size_t buf_len = buf->data - buf->begin;
+	int ret;
+
+	if (cmd == 0x0006) /* Write MIB */
+		wsm_printk(KERN_DEBUG "[WSM] >>> 0x%.4X [MIB: 0x%.4X] (%ld)\n",
+			cmd, __le16_to_cpu(((__le16 *)buf->begin)[2]),
+			buf_len);
+	else
+		wsm_printk(KERN_DEBUG "[WSM] >>> 0x%.4X (%ld)\n", cmd, buf_len);
+
+	/* Fill HI message header */
+	/* BH will add sequence number */
+	((__le16 *)buf->begin)[0] = __cpu_to_le16(buf_len);
+	((__le16 *)buf->begin)[1] = __cpu_to_le16(cmd);
+
+	spin_lock(&priv->wsm_cmd.lock);
+	BUG_ON(priv->wsm_cmd.ptr);
+	priv->wsm_cmd.done = 0;
+	priv->wsm_cmd.ptr = buf->begin;
+	priv->wsm_cmd.len = buf_len;
+	priv->wsm_cmd.arg = arg;
+	priv->wsm_cmd.cmd = cmd;
+	spin_unlock(&priv->wsm_cmd.lock);
+
+	cw1200_bh_wakeup(priv);
+
+	if (unlikely(priv->bh_error)) {
+		/* Do not wait for timeout if BH is dead. Exit immediately. */
+		ret = 0;
+	} else {
+		long rx_timestamp;
+		/* Firmware prioritizes data traffic over control confirm.
+		 * Loop below checks if data was RXed and increases timeout
+		 * accordingly. */
+		do {
+			/* It's safe to use unprotected access to
+			 * wsm_cmd.done here */
+			ret = wait_event_timeout(
+					priv->wsm_cmd_wq,
+					priv->wsm_cmd.done, tmo);
+			rx_timestamp = jiffies - priv->rx_timestamp;
+			if (unlikely(rx_timestamp < 0))
+				rx_timestamp = tmo + 1;
+		} while (!ret && rx_timestamp <= tmo);
+	}
+
+	if (unlikely(ret == 0)) {
+		u16 raceCheck;
+
+		spin_lock(&priv->wsm_cmd.lock);
+		raceCheck = priv->wsm_cmd.cmd;
+		priv->wsm_cmd.arg = NULL;
+		priv->wsm_cmd.ptr = NULL;
+		spin_unlock(&priv->wsm_cmd.lock);
+
+		/* Race condition check to make sure _confirm is not called
+		 * after exit of _send */
+		if (raceCheck == 0xFFFF) {
+			/* If wsm_handle_rx got stuck in _confirm we will hang
+			 * system there. It's better than silently currupt
+			 * stack or heap, isn't it? */
+			BUG_ON(wait_event_timeout(
+					priv->wsm_cmd_wq, priv->wsm_cmd.done,
+					WSM_CMD_LAST_CHANCE_TIMEOUT) <= 0);
+		}
+
+		/* Kill BH thread to report the error to the top layer. */
+		priv->bh_error = 1;
+		wake_up(&priv->bh_wq);
+		ret = -ETIMEDOUT;
+	} else {
+		spin_lock(&priv->wsm_cmd.lock);
+		BUG_ON(!priv->wsm_cmd.done);
+		ret = priv->wsm_cmd.ret;
+		spin_unlock(&priv->wsm_cmd.lock);
+	}
+	wsm_buf_reset(buf);
+	return ret;
+}
+
+/* ******************************************************************** */
+/* WSM TX port control							*/
+
+void wsm_lock_tx(struct cw1200_common *priv)
+{
+	wsm_cmd_lock(priv);
+	if (atomic_add_return(1, &priv->tx_lock) == 1) {
+		if (wsm_flush_tx(priv))
+			wsm_printk(KERN_DEBUG "[WSM] TX is locked.\n");
+	}
+	wsm_cmd_unlock(priv);
+}
+
+void wsm_lock_tx_async(struct cw1200_common *priv)
+{
+	if (atomic_add_return(1, &priv->tx_lock) == 1)
+		wsm_printk(KERN_DEBUG "[WSM] TX is locked (async).\n");
+}
+
+bool wsm_flush_tx(struct cw1200_common *priv)
+{
+	unsigned long timestamp = jiffies;
+	bool pending = false;
+	long timeout;
+	int i;
+
+	/* Flush must be called with TX lock held. */
+	BUG_ON(!atomic_read(&priv->tx_lock));
+
+	/* First check if we really need to do something.
+	 * It is safe to use unprotected access, as hw_bufs_used
+	 * can only decrements. */
+	if (!priv->hw_bufs_used)
+		return true;
+
+	if (priv->bh_error) {
+		/* In case of failure do not wait for magic. */
+		wsm_printk(KERN_ERR "[WSM] Fatal error occured, "
+				"will not flush TX.\n");
+		return false;
+	} else {
+		/* Get a timestamp of "oldest" frame */
+		for (i = 0; i < 4; ++i)
+			pending |= cw1200_queue_get_xmit_timestamp(
+					&priv->tx_queue[i],
+					&timestamp);
+		/* It is allowed to lock TX with only a command in the pipe. */
+		if (!pending)
+			return true;
+
+		timeout = timestamp + WSM_CMD_LAST_CHANCE_TIMEOUT - jiffies;
+		if (timeout < 0 || wait_event_timeout(priv->bh_evt_wq,
+				!priv->hw_bufs_used,
+				timeout) <= 0) {
+			/* Hmmm... Not good. Frame had stuck in firmware. */
+			priv->bh_error = 1;
+			wake_up(&priv->bh_wq);
+			return false;
+		}
+
+		/* Ok, everything is flushed. */
+		return true;
+	}
+}
+
+void wsm_unlock_tx(struct cw1200_common *priv)
+{
+	int tx_lock;
+	if (priv->bh_error)
+		wsm_printk(KERN_ERR "fatal error occured, unlock is unsafe\n");
+	else {
+		tx_lock = atomic_sub_return(1, &priv->tx_lock);
+		if (tx_lock < 0) {
+			BUG_ON(1);
+		} else if (tx_lock == 0) {
+			cw1200_bh_wakeup(priv);
+			wsm_printk(KERN_DEBUG "[WSM] TX is unlocked.\n");
+		}
+	}
+}
+
+/* ******************************************************************** */
+/* WSM RX								*/
+
+int wsm_handle_exception(struct cw1200_common *priv, u8 *data, size_t len)
+{
+	struct wsm_buf buf;
+	u32 reason;
+	u32 reg[18];
+	char fname[48];
+	size_t i;
+
+	static const char * const reason_str[] = {
+		"undefined instruction",
+		"prefetch abort",
+		"data abort",
+		"unknown error",
+	};
+
+#if defined(CONFIG_CW1200_USE_STE_EXTENSIONS)
+	/* Send the event upwards on the FW exception */
+	cw1200_pm_stay_awake(&priv->pm_state, 3*HZ);
+	ieee80211_driver_hang_notify(priv->vif, GFP_KERNEL);
+#endif
+
+	buf.begin = buf.data = data;
+	buf.end = &buf.begin[len];
+
+	reason = WSM_GET32(&buf);
+	for (i = 0; i < ARRAY_SIZE(reg); ++i)
+		reg[i] = WSM_GET32(&buf);
+	WSM_GET(&buf, fname, sizeof(fname));
+
+	if (reason < 4)
+		wiphy_err(priv->hw->wiphy,
+			"Firmware exception: %s.\n",
+			reason_str[reason]);
+	else
+		wiphy_err(priv->hw->wiphy,
+			"Firmware assert at %.*s, line %d\n",
+			(int)sizeof(fname), fname, reg[1]);
+
+	for (i = 0; i < 12; i += 4)
+		wiphy_err(priv->hw->wiphy,
+			"R%ld: 0x%.8X, R%ld: 0x%.8X, R%ld: 0x%.8X, R%ld: 0x%.8X,\n",
+			i + 0, reg[i + 0], i + 1, reg[i + 1],
+			i + 2, reg[i + 2], i + 3, reg[i + 3]);
+	wiphy_err(priv->hw->wiphy,
+		"R12: 0x%.8X, SP: 0x%.8X, LR: 0x%.8X, PC: 0x%.8X,\n",
+		reg[i + 0], reg[i + 1], reg[i + 2], reg[i + 3]);
+	i += 4;
+	wiphy_err(priv->hw->wiphy,
+		"CPSR: 0x%.8X, SPSR: 0x%.8X\n",
+		reg[i + 0], reg[i + 1]);
+
+	print_hex_dump_bytes("R1: ", DUMP_PREFIX_NONE,
+		fname, sizeof(fname));
+	return 0;
+
+underflow:
+	wiphy_err(priv->hw->wiphy,
+		"Firmware exception.\n");
+	print_hex_dump_bytes("Exception: ", DUMP_PREFIX_NONE,
+		data, len);
+	return -EINVAL;
+}
+
+int wsm_handle_rx(struct cw1200_common *priv, int id,
+		  struct wsm_hdr *wsm, struct sk_buff **skb_p)
+{
+	int ret = 0;
+	struct wsm_buf wsm_buf;
+	int link_id = (id >> 6) & 0x0F;
+
+	/* Strip link id. */
+	id &= ~WSM_TX_LINK_ID(WSM_TX_LINK_ID_MAX);
+
+	wsm_buf.begin = (u8 *)&wsm[0];
+	wsm_buf.data = (u8 *)&wsm[1];
+	wsm_buf.end = &wsm_buf.begin[__le32_to_cpu(wsm->len)];
+
+	wsm_printk(KERN_DEBUG "[WSM] <<< 0x%.4X (%ld)\n", id,
+			wsm_buf.end - wsm_buf.begin);
+
+	if (id == 0x404) {
+		ret = wsm_tx_confirm(priv, &wsm_buf, link_id);
+	} else if (id == 0x41E) {
+		ret = wsm_multi_tx_confirm(priv, &wsm_buf, link_id);
+	} else if (id & 0x0400) {
+		void *wsm_arg;
+		u16 wsm_cmd;
+
+		/* Do not trust FW too much. Protection against repeated
+		 * response and race condition removal (see above). */
+		spin_lock(&priv->wsm_cmd.lock);
+		wsm_arg = priv->wsm_cmd.arg;
+		wsm_cmd = priv->wsm_cmd.cmd &
+				~WSM_TX_LINK_ID(WSM_TX_LINK_ID_MAX);
+		priv->wsm_cmd.cmd = 0xFFFF;
+		spin_unlock(&priv->wsm_cmd.lock);
+
+		if (WARN_ON((id & ~0x0400) != wsm_cmd)) {
+			/* Note that any non-zero is a fatal retcode. */
+			ret = -EINVAL;
+			goto out;
+		}
+
+		switch (id) {
+		case 0x0409:
+			/* Note that wsm_arg can be NULL in case of timeout in
+			 * wsm_cmd_send(). */
+			if (likely(wsm_arg))
+				ret = wsm_configuration_confirm(priv, wsm_arg,
+								&wsm_buf);
+			break;
+		case 0x0405:
+			if (likely(wsm_arg))
+				ret = wsm_read_mib_confirm(priv, wsm_arg,
+								&wsm_buf);
+			break;
+		case 0x0406:
+			if (likely(wsm_arg))
+				ret = wsm_write_mib_confirm(priv, wsm_arg,
+								&wsm_buf);
+			break;
+		case 0x040B:
+			if (likely(wsm_arg))
+				ret = wsm_join_confirm(priv, wsm_arg, &wsm_buf);
+			break;
+		case 0x0407: /* start-scan */
+		case 0x0408: /* stop-scan */
+		case 0x040A: /* wsm_reset */
+		case 0x040C: /* add_key */
+		case 0x040D: /* remove_key */
+		case 0x0410: /* wsm_set_pm */
+		case 0x0411: /* set_bss_params */
+		case 0x0412: /* set_tx_queue_params */
+		case 0x0413: /* set_edca_params */
+		case 0x0416: /* switch_channel */
+		case 0x0417: /* start */
+		case 0x0418: /* beacon_transmit */
+		case 0x0419: /* start_find */
+		case 0x041A: /* stop_find */
+		case 0x041B: /* update_ie */
+		case 0x041C: /* map_link */
+			WARN_ON(wsm_arg != NULL);
+			ret = wsm_generic_confirm(priv, wsm_arg, &wsm_buf);
+			if (ret)
+				wiphy_warn(priv->hw->wiphy,
+					"wsm_generic_confirm "
+					"failed for request 0x%.4X.\n",
+					id & ~0x0400);
+			break;
+		default:
+			BUG_ON(1);
+		}
+
+		spin_lock(&priv->wsm_cmd.lock);
+		priv->wsm_cmd.ret = ret;
+		priv->wsm_cmd.done = 1;
+		spin_unlock(&priv->wsm_cmd.lock);
+		ret = 0; /* Error response from device should ne stop BH. */
+
+		wake_up(&priv->wsm_cmd_wq);
+	} else if (id & 0x0800) {
+		switch (id) {
+		case 0x0801:
+			ret = wsm_startup_indication(priv, &wsm_buf);
+			break;
+		case 0x0804:
+			ret = wsm_receive_indication(priv, link_id,
+					&wsm_buf, skb_p);
+			break;
+		case 0x0805:
+			ret = wsm_event_indication(priv, &wsm_buf);
+			break;
+		case 0x080A:
+			ret = wsm_channel_switch_indication(priv, &wsm_buf);
+			break;
+		case 0x0809:
+			ret = wsm_set_pm_indication(priv, &wsm_buf);
+			break;
+		case 0x0806:
+			ret = wsm_scan_complete_indication(priv, &wsm_buf);
+			break;
+		case 0x080B:
+			ret = wsm_find_complete_indication(priv, &wsm_buf);
+			break;
+		case 0x080C:
+			ret = wsm_suspend_resume_indication(priv,
+					link_id, &wsm_buf);
+			break;
+		default:
+			STUB();
+		}
+	} else {
+		WARN_ON(1);
+		ret = -EINVAL;
+	}
+out:
+	return ret;
+}
+
+static bool wsm_handle_tx_data(struct cw1200_common *priv,
+			       const struct wsm_tx *wsm,
+			       const struct ieee80211_tx_info *tx_info,
+			       const struct cw1200_txpriv *txpriv,
+			       struct cw1200_queue *queue)
+{
+	bool handled = false;
+	const struct ieee80211_hdr *frame =
+		(struct ieee80211_hdr *) &((u8 *)wsm)[txpriv->offset];
+	__le16 fctl = frame->frame_control;
+	enum {
+		doProbe,
+		doDrop,
+		doJoin,
+		doOffchannel,
+		doWep,
+		doTx,
+	} action = doTx;
+
+	switch (priv->mode) {
+	case NL80211_IFTYPE_STATION:
+		if (unlikely((priv->join_status == CW1200_JOIN_STATUS_STA) &&
+			ieee80211_is_nullfunc(fctl))) {
+			spin_lock(&priv->bss_loss_lock);
+			if (priv->bss_loss_status == CW1200_BSS_LOSS_CHECKING) {
+				priv->bss_loss_status =
+						CW1200_BSS_LOSS_CONFIRMING;
+				priv->bss_loss_confirm_id = wsm->packetID;
+			}
+			spin_unlock(&priv->bss_loss_lock);
+		} else if (unlikely(
+			(priv->join_status <= CW1200_JOIN_STATUS_MONITOR) ||
+			memcmp(frame->addr1, priv->join_bssid,
+				sizeof(priv->join_bssid)))) {
+			if (ieee80211_is_auth(fctl))
+				action = doJoin;
+			else if (ieee80211_is_probe_req(fctl))
+				action = doTx;
+			else if (priv->join_status >=
+					CW1200_JOIN_STATUS_MONITOR)
+				action = doTx;
+			else
+				action = doOffchannel;
+		}
+		break;
+	case NL80211_IFTYPE_AP:
+		if (unlikely(!priv->join_status))
+			action = doDrop;
+		else if (unlikely(!(BIT(txpriv->raw_link_id) &
+				(BIT(0) | priv->link_id_map)))) {
+			wiphy_warn(priv->hw->wiphy,
+					"A frame with expired link id "
+					"is dropped.\n");
+			action = doDrop;
+		}
+		if (cw1200_queue_get_generation(wsm->packetID) >
+				CW1200_MAX_REQUEUE_ATTEMPTS) {
+			/* HACK!!! WSM324 firmware has tendency to requeue
+			 * multicast frames in a loop, causing performance
+			 * drop and high power consumption of the driver.
+			 * In this situation it is better just to drop
+			 * the problematic frame. */
+			wiphy_warn(priv->hw->wiphy,
+					"Too many attempts "
+					"to requeue a frame. "
+					"Frame is dropped.\n");
+			action = doDrop;
+		}
+		break;
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		STUB();
+	case NL80211_IFTYPE_MONITOR:
+	default:
+		action = doDrop;
+		break;
+	}
+
+	if (action == doTx) {
+		if (unlikely(ieee80211_is_probe_req(fctl)))
+			action = doProbe;
+		else if ((fctl & __cpu_to_le32(IEEE80211_FCTL_PROTECTED)) &&
+			tx_info->control.hw_key &&
+			unlikely(tx_info->control.hw_key->keyidx !=
+					priv->wep_default_key_id) &&
+			(tx_info->control.hw_key->cipher ==
+					WLAN_CIPHER_SUITE_WEP40 ||
+			 tx_info->control.hw_key->cipher ==
+					WLAN_CIPHER_SUITE_WEP104))
+			action = doWep;
+	}
+
+	switch (action) {
+	case doProbe:
+	{
+		/* An interesting FW "feature". Device filters
+		 * probe responses.
+		 * The easiest way to get it back is to convert
+		 * probe request into WSM start_scan command. */
+		wsm_printk(KERN_DEBUG \
+			"[WSM] Convert probe request to scan.\n");
+		wsm_lock_tx_async(priv);
+		priv->pending_frame_id = __le32_to_cpu(wsm->packetID);
+		queue_delayed_work(priv->workqueue,
+				&priv->scan.probe_work, 0);
+		handled = true;
+	}
+	break;
+	case doDrop:
+	{
+		/* See detailed description of "join" below.
+		 * We are dropping everything except AUTH in non-joined mode. */
+		wsm_printk(KERN_DEBUG "[WSM] Drop frame (0x%.4X).\n", fctl);
+		BUG_ON(cw1200_queue_remove(queue,
+			__le32_to_cpu(wsm->packetID)));
+		handled = true;
+	}
+	break;
+	case doJoin:
+	{
+		/* There is one more interesting "feature"
+		 * in FW: it can't do RX/TX before "join".
+		 * "Join" here is not an association,
+		 * but just a syncronization between AP and STA.
+		 * priv->join_status is used only in bh thread and does
+		 * not require protection */
+		wsm_printk(KERN_DEBUG "[WSM] Issue join command.\n");
+		wsm_lock_tx_async(priv);
+		priv->pending_frame_id = __le32_to_cpu(wsm->packetID);
+		if (queue_work(priv->workqueue, &priv->join_work) <= 0)
+			wsm_unlock_tx(priv);
+		handled = true;
+	}
+	break;
+	case doOffchannel:
+	{
+		wsm_printk(KERN_DEBUG "[WSM] Offchannel TX request.\n");
+		wsm_lock_tx_async(priv);
+		priv->pending_frame_id = __le32_to_cpu(wsm->packetID);
+		if (queue_work(priv->workqueue, &priv->offchannel_work) <= 0)
+			wsm_unlock_tx(priv);
+		handled = true;
+	}
+	break;
+	case doWep:
+	{
+		wsm_printk(KERN_DEBUG "[WSM] Issue set_default_wep_key.\n");
+		wsm_lock_tx_async(priv);
+		priv->wep_default_key_id = tx_info->control.hw_key->keyidx;
+		priv->pending_frame_id = __le32_to_cpu(wsm->packetID);
+		if (queue_work(priv->workqueue, &priv->wep_key_work) <= 0)
+			wsm_unlock_tx(priv);
+		handled = true;
+	}
+	break;
+	case doTx:
+	{
+#if 0
+		/* Kept for history. If you want to implement wsm->more,
+		 * make sure you are able to send a frame after that. */
+		wsm->more = (count > 1) ? 1 : 0;
+		if (wsm->more) {
+			/* HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
+			 * It's undocumented in WSM spec, but CW1200 hangs
+			 * if 'more' is set and no TX is performed due to TX
+			 * buffers limitation. */
+			if (priv->hw_bufs_used + 1 ==
+					priv->wsm_caps.numInpChBufs)
+				wsm->more = 0;
+		}
+
+		/* BUG!!! FIXME: we can't use 'more' at all: we don't know
+		 * future. It could be a request from upper layer with TX lock
+		 * requirements (scan, for example). If "more" is set device
+		 * will not send data and wsm_tx_lock() will fail...
+		 * It's not obvious how to fix this deadlock. Any ideas?
+		 * As a workaround more is set to 0. */
+		wsm->more = 0;
+#endif /* 0 */
+
+		if (ieee80211_is_deauth(fctl) &&
+				priv->mode != NL80211_IFTYPE_AP) {
+			/* Shedule unjoin work */
+			wsm_printk(KERN_DEBUG "[WSM] Issue unjoin command"
+				" (TX).\n");
+#if 0
+			wsm->more = 0;
+#endif /* 0 */
+			wsm_lock_tx_async(priv);
+			if (queue_work(priv->workqueue,
+					&priv->unjoin_work) <= 0)
+				wsm_unlock_tx(priv);
+		}
+	}
+	break;
+	}
+	return handled;
+}
+
+static int cw1200_get_prio_queue(struct cw1200_common *priv,
+				 u32 link_id_map, int *total)
+{
+	static const int urgent = BIT(CW1200_LINK_ID_AFTER_DTIM) |
+		BIT(CW1200_LINK_ID_UAPSD);
+	struct wsm_edca_queue_params *edca;
+	unsigned score, best = -1;
+	int winner = -1;
+	int queued;
+	int i;
+
+	/* search for a winner using edca params */
+	for (i = 0; i < 4; ++i) {
+		queued = cw1200_queue_get_num_queued(&priv->tx_queue[i],
+				link_id_map);
+		if (!queued)
+			continue;
+		*total += queued;
+		edca = &priv->edca.params[i];
+		score = ((edca->aifns + edca->cwMin) << 16) +
+				(edca->cwMax - edca->cwMin) *
+				(random32() & 0xFFFF);
+		if (score < best && (winner < 0 || i != 3)) {
+			best = score;
+			winner = i;
+		}
+	}
+
+	/* override winner if bursting */
+	if (winner >= 0 && priv->tx_burst_idx >= 0 &&
+			winner != priv->tx_burst_idx &&
+			!cw1200_queue_get_num_queued(
+				&priv->tx_queue[winner],
+				link_id_map & urgent) &&
+			cw1200_queue_get_num_queued(
+				&priv->tx_queue[priv->tx_burst_idx],
+				link_id_map))
+		winner = priv->tx_burst_idx;
+
+	return winner;
+}
+
+static int wsm_get_tx_queue_and_mask(struct cw1200_common *priv,
+				     struct cw1200_queue **queue_p,
+				     u32 *tx_allowed_mask_p,
+				     bool *more)
+{
+	int idx;
+	u32 tx_allowed_mask;
+	int total = 0;
+
+	/* Search for a queue with multicast frames buffered */
+	if (priv->tx_multicast) {
+		tx_allowed_mask = BIT(CW1200_LINK_ID_AFTER_DTIM);
+		idx = cw1200_get_prio_queue(priv,
+				tx_allowed_mask, &total);
+		if (idx >= 0) {
+			*more = total > 1;
+			goto found;
+		}
+	}
+
+	/* Search for unicast traffic */
+	tx_allowed_mask = ~priv->sta_asleep_mask;
+	tx_allowed_mask |= BIT(CW1200_LINK_ID_UAPSD);
+	if (priv->sta_asleep_mask) {
+		tx_allowed_mask |= priv->pspoll_mask;
+		tx_allowed_mask &= ~BIT(CW1200_LINK_ID_AFTER_DTIM);
+	} else {
+		tx_allowed_mask |= BIT(CW1200_LINK_ID_AFTER_DTIM);
+	}
+	idx = cw1200_get_prio_queue(priv,
+			tx_allowed_mask, &total);
+	if (idx < 0)
+		return -ENOENT;
+
+found:
+	*queue_p = &priv->tx_queue[idx];
+	*tx_allowed_mask_p = tx_allowed_mask;
+	return 0;
+}
+
+int wsm_get_tx(struct cw1200_common *priv, u8 **data,
+	       size_t *tx_len, int *burst)
+{
+	struct wsm_tx *wsm = NULL;
+	struct ieee80211_tx_info *tx_info;
+	struct cw1200_queue *queue = NULL;
+	int queue_num;
+	u32 tx_allowed_mask = 0;
+	const struct cw1200_txpriv *txpriv = NULL;
+	/*
+	 * Count was intended as an input for wsm->more flag.
+	 * During implementation it was found that wsm->more
+	 * is not usable, see details above. It is kept just
+	 * in case you would like to try to implement it again.
+	 */
+	int count = 0;
+
+	/* More is used only for broadcasts. */
+	bool more = false;
+
+	count = cw1200_itp_get_tx(priv, data, tx_len, burst);
+	if (count)
+		return count;
+
+	if (priv->wsm_cmd.ptr) {
+		++count;
+		spin_lock(&priv->wsm_cmd.lock);
+		BUG_ON(!priv->wsm_cmd.ptr);
+		*data = priv->wsm_cmd.ptr;
+		*tx_len = priv->wsm_cmd.len;
+		*burst = 1;
+		spin_unlock(&priv->wsm_cmd.lock);
+	} else {
+		for (;;) {
+			int ret;
+
+			if (atomic_add_return(0, &priv->tx_lock))
+				break;
+
+			spin_lock_bh(&priv->ps_state_lock);
+
+			ret = wsm_get_tx_queue_and_mask(priv, &queue,
+					&tx_allowed_mask, &more);
+			queue_num = queue - priv->tx_queue;
+
+			if (priv->buffered_multicasts &&
+					(ret || !more) &&
+					(priv->tx_multicast ||
+					 !priv->sta_asleep_mask)) {
+				priv->buffered_multicasts = false;
+				if (priv->tx_multicast) {
+					priv->tx_multicast = false;
+					queue_work(priv->workqueue,
+						&priv->multicast_stop_work);
+				}
+			}
+
+			spin_unlock_bh(&priv->ps_state_lock);
+
+			if (ret)
+				break;
+
+			if (cw1200_queue_get(queue,
+					tx_allowed_mask,
+					&wsm, &tx_info, &txpriv))
+				continue;
+
+			if (wsm_handle_tx_data(priv, wsm,
+					tx_info, txpriv, queue))
+				continue;  /* Handled by WSM */
+
+			wsm->hdr.id &= __cpu_to_le16(
+				~WSM_TX_LINK_ID(WSM_TX_LINK_ID_MAX));
+			wsm->hdr.id |= cpu_to_le16(
+				WSM_TX_LINK_ID(txpriv->raw_link_id));
+			priv->pspoll_mask &= ~BIT(txpriv->raw_link_id);
+
+			*data = (u8 *)wsm;
+			*tx_len = __le16_to_cpu(wsm->hdr.len);
+
+			/* allow bursting if txop is set */
+			if (priv->edca.params[queue_num].txOpLimit)
+				*burst = min(*burst,
+					(int)cw1200_queue_get_num_queued(
+						queue, tx_allowed_mask) + 1);
+			else
+				*burst = 1;
+
+			/* store index of bursting queue */
+			if (*burst > 1)
+				priv->tx_burst_idx = queue_num;
+			else
+				priv->tx_burst_idx = -1;
+
+			if (more) {
+				struct ieee80211_hdr *hdr =
+					(struct ieee80211_hdr *)
+					&((u8 *)wsm)[txpriv->offset];
+				/* more buffered multicast/broadcast frames
+				 *  ==> set MoreData flag in IEEE 802.11 header
+				 *  to inform PS STAs */
+				hdr->frame_control |=
+					cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+			}
+
+			wsm_printk(KERN_DEBUG "[WSM] >>> 0x%.4X (%ld) %p %c\n",
+				0x0004, *tx_len, *data,
+				wsm->more ? 'M' : ' ');
+			++count;
+			break;
+		}
+	}
+
+	return count;
+}
+
+void wsm_txed(struct cw1200_common *priv, u8 *data)
+{
+	if (data == priv->wsm_cmd.ptr) {
+		spin_lock(&priv->wsm_cmd.lock);
+		priv->wsm_cmd.ptr = NULL;
+		spin_unlock(&priv->wsm_cmd.lock);
+	}
+}
+
+/* ******************************************************************** */
+/* WSM buffer								*/
+
+void wsm_buf_init(struct wsm_buf *buf)
+{
+	BUG_ON(buf->begin);
+	buf->begin = kmalloc(SDIO_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
+	buf->end = buf->begin ? &buf->begin[SDIO_BLOCK_SIZE] : buf->begin;
+	wsm_buf_reset(buf);
+}
+
+void wsm_buf_deinit(struct wsm_buf *buf)
+{
+	kfree(buf->begin);
+	buf->begin = buf->data = buf->end = NULL;
+}
+
+static void wsm_buf_reset(struct wsm_buf *buf)
+{
+	if (buf->begin) {
+		buf->data = &buf->begin[4];
+		*(u32 *)buf->begin = 0;
+	} else
+		buf->data = buf->begin;
+}
+
+static int wsm_buf_reserve(struct wsm_buf *buf, size_t extra_size)
+{
+	size_t pos = buf->data - buf->begin;
+	size_t size = pos + extra_size;
+
+
+	if (size & (SDIO_BLOCK_SIZE - 1)) {
+		size &= SDIO_BLOCK_SIZE;
+		size += SDIO_BLOCK_SIZE;
+	}
+
+	buf->begin = krealloc(buf->begin, size, GFP_KERNEL | GFP_DMA);
+	if (buf->begin) {
+		buf->data = &buf->begin[pos];
+		buf->end = &buf->begin[size];
+		return 0;
+	} else {
+		buf->end = buf->data = buf->begin;
+		return -ENOMEM;
+	}
+}
diff --git a/drivers/staging/cw1200/wsm.h b/drivers/staging/cw1200/wsm.h
new file mode 100644
index 0000000..c3bd002
--- /dev/null
+++ b/drivers/staging/cw1200/wsm.h
@@ -0,0 +1,1833 @@
+/*
+ * WSM host interface (HI) interface for ST-Ericsson CW1200 mac80211 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * Based on CW1200 UMAC WSM API, which is
+ * Copyright (C) ST-Ericsson SA 2010
+ * Author: Stewart Mathers <stewart.mathers@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CW1200_WSM_H_INCLUDED
+#define CW1200_WSM_H_INCLUDED
+
+#include <linux/spinlock.h>
+
+struct cw1200_common;
+
+/* Bands */
+/* Radio band 2.412 -2.484 GHz. */
+#define WSM_PHY_BAND_2_4G		(0)
+
+/* Radio band 4.9375-5.8250 GHz. */
+#define WSM_PHY_BAND_5G			(1)
+
+/* Transmit rates */
+/* 1   Mbps            ERP-DSSS */
+#define WSM_TRANSMIT_RATE_1		(0)
+
+/* 2   Mbps            ERP-DSSS */
+#define WSM_TRANSMIT_RATE_2		(1)
+
+/* 5.5 Mbps            ERP-CCK, ERP-PBCC (Not supported) */
+/* #define WSM_TRANSMIT_RATE_5		(2) */
+
+/* 11  Mbps            ERP-CCK, ERP-PBCC (Not supported) */
+/* #define WSM_TRANSMIT_RATE_11		(3) */
+
+/* 22  Mbps            ERP-PBCC (Not supported) */
+/* #define WSM_TRANSMIT_RATE_22		(4) */
+
+/* 33  Mbps            ERP-PBCC (Not supported) */
+/* #define WSM_TRANSMIT_RATE_33		(5) */
+
+/* 6   Mbps   (3 Mbps) ERP-OFDM, BPSK coding rate 1/2 */
+#define WSM_TRANSMIT_RATE_6		(6)
+
+/* 9   Mbps (4.5 Mbps) ERP-OFDM, BPSK coding rate 3/4 */
+#define WSM_TRANSMIT_RATE_9		(7)
+
+/* 12  Mbps  (6 Mbps)  ERP-OFDM, QPSK coding rate 1/2 */
+#define WSM_TRANSMIT_RATE_12		(8)
+
+/* 18  Mbps  (9 Mbps)  ERP-OFDM, QPSK coding rate 3/4 */
+#define WSM_TRANSMIT_RATE_18		(9)
+
+/* 24  Mbps (12 Mbps)  ERP-OFDM, 16QAM coding rate 1/2 */
+#define WSM_TRANSMIT_RATE_24		(10)
+
+/* 36  Mbps (18 Mbps)  ERP-OFDM, 16QAM coding rate 3/4 */
+#define WSM_TRANSMIT_RATE_36		(11)
+
+/* 48  Mbps (24 Mbps)  ERP-OFDM, 64QAM coding rate 1/2 */
+#define WSM_TRANSMIT_RATE_48		(12)
+
+/* 54  Mbps (27 Mbps)  ERP-OFDM, 64QAM coding rate 3/4 */
+#define WSM_TRANSMIT_RATE_54		(13)
+
+/* 6.5 Mbps            HT-OFDM, BPSK coding rate 1/2 */
+#define WSM_TRANSMIT_RATE_HT_6		(14)
+
+/* 13  Mbps            HT-OFDM, QPSK coding rate 1/2 */
+#define WSM_TRANSMIT_RATE_HT_13		(15)
+
+/* 19.5 Mbps           HT-OFDM, QPSK coding rate 3/4 */
+#define WSM_TRANSMIT_RATE_HT_19		(16)
+
+/* 26  Mbps            HT-OFDM, 16QAM coding rate 1/2 */
+#define WSM_TRANSMIT_RATE_HT_26		(17)
+
+/* 39  Mbps            HT-OFDM, 16QAM coding rate 3/4 */
+#define WSM_TRANSMIT_RATE_HT_39		(18)
+
+/* 52  Mbps            HT-OFDM, 64QAM coding rate 2/3 */
+#define WSM_TRANSMIT_RATE_HT_52		(19)
+
+/* 58.5 Mbps           HT-OFDM, 64QAM coding rate 3/4 */
+#define WSM_TRANSMIT_RATE_HT_58		(20)
+
+/* 65  Mbps            HT-OFDM, 64QAM coding rate 5/6 */
+#define WSM_TRANSMIT_RATE_HT_65		(21)
+
+/* Scan types */
+/* Foreground scan */
+#define WSM_SCAN_TYPE_FOREGROUND	(0)
+
+/* Background scan */
+#define WSM_SCAN_TYPE_BACKGROUND	(1)
+
+/* Auto scan */
+#define WSM_SCAN_TYPE_AUTO		(2)
+
+/* Scan flags */
+/* Forced background scan means if the station cannot */
+/* enter the power-save mode, it shall force to perform a */
+/* background scan. Only valid when ScanType is */
+/* background scan. */
+#define WSM_SCAN_FLAG_FORCE_BACKGROUND	(BIT(0))
+
+/* The WLAN device scans one channel at a time so */
+/* that disturbance to the data traffic is minimized. */
+#define WSM_SCAN_FLAG_SPLIT_METHOD	(BIT(1))
+
+/* Preamble Type. Long if not set. */
+#define WSM_SCAN_FLAG_SHORT_PREAMBLE	(BIT(2))
+
+/* 11n Tx Mode. Mixed if not set. */
+#define WSM_SCAN_FLAG_11N_GREENFIELD	(BIT(3))
+
+/* Scan constraints */
+/* Maximum number of channels to be scanned. */
+#define WSM_SCAN_MAX_NUM_OF_CHANNELS	(48)
+
+/* The maximum number of SSIDs that the device can scan for. */
+#define WSM_SCAN_MAX_NUM_OF_SSIDS	(2)
+
+/* Power management modes */
+/* 802.11 Active mode */
+#define WSM_PSM_ACTIVE			(0)
+
+/* 802.11 PS mode */
+#define WSM_PSM_PS			BIT(0)
+
+/* Fast Power Save bit */
+#define WSM_PSM_FAST_PS_FLAG		BIT(7)
+
+/* Dynamic aka Fast power save */
+#define WSM_PSM_FAST_PS			(BIT(0) | BIT(7))
+
+/* Undetermined */
+/* Note : Undetermined status is reported when the */
+/* NULL data frame used to advertise the PM mode to */
+/* the AP at Pre or Post Background Scan is not Acknowledged */
+#define WSM_PSM_UNKNOWN			BIT(1)
+
+/* Queue IDs */
+/* best effort/legacy */
+#define WSM_QUEUE_BEST_EFFORT		(0)
+
+/* background */
+#define WSM_QUEUE_BACKGROUND		(1)
+
+/* video */
+#define WSM_QUEUE_VIDEO			(2)
+
+/* voice */
+#define WSM_QUEUE_VOICE			(3)
+
+/* HT TX parameters */
+/* Non-HT */
+#define WSM_HT_TX_NON_HT		(0)
+
+/* Mixed format */
+#define WSM_HT_TX_MIXED			(1)
+
+/* Greenfield format */
+#define WSM_HT_TX_GREENFIELD		(2)
+
+/* STBC allowed */
+#define WSM_HT_TX_STBC			(BIT(7))
+
+/* EPTA prioirty flags for BT Coex */
+/* default epta priority */
+#define WSM_EPTA_PRIORITY_DEFAULT	4
+/* use for normal data */
+#define WSM_EPTA_PRIORITY_DATA		4
+/* use for connect/disconnect/roaming*/
+#define WSM_EPTA_PRIORITY_MGT		5
+/* use for action frames */
+#define WSM_EPTA_PRIORITY_ACTION	5
+/* use for AC_VI data */
+#define WSM_EPTA_PRIORITY_VIDEO		5
+/* use for AC_VO data */
+#define WSM_EPTA_PRIORITY_VOICE		6
+/* use for EAPOL exchange */
+#define WSM_EPTA_PRIORITY_EAPOL		7
+
+/* TX status */
+/* Frame was sent aggregated */
+/* Only valid for WSM_SUCCESS status. */
+#define WSM_TX_STATUS_AGGREGATION	(BIT(0))
+
+/* Host should requeue this frame later. */
+/* Valid only when status is WSM_REQUEUE. */
+#define WSM_TX_STATUS_REQUEUE		(BIT(1))
+
+/* Normal Ack */
+#define WSM_TX_STATUS_NORMAL_ACK	(0<<2)
+
+/* No Ack */
+#define WSM_TX_STATUS_NO_ACK		(1<<2)
+
+/* No explicit acknowledgement */
+#define WSM_TX_STATUS_NO_EXPLICIT_ACK	(2<<2)
+
+/* Block Ack */
+/* Only valid for WSM_SUCCESS status. */
+#define WSM_TX_STATUS_BLOCK_ACK		(3<<2)
+
+/* RX status */
+/* Unencrypted */
+#define WSM_RX_STATUS_UNENCRYPTED	(0<<0)
+
+/* WEP */
+#define WSM_RX_STATUS_WEP		(1<<0)
+
+/* TKIP */
+#define WSM_RX_STATUS_TKIP		(2<<0)
+
+/* AES */
+#define WSM_RX_STATUS_AES		(3<<0)
+
+/* WAPI */
+#define WSM_RX_STATUS_WAPI		(4<<0)
+
+/* Macro to fetch encryption subfield. */
+#define WSM_RX_STATUS_ENCRYPTION(status) ((status) & 0x07)
+
+/* Frame was part of an aggregation */
+#define WSM_RX_STATUS_AGGREGATE		(BIT(3))
+
+/* Frame was first in the aggregation */
+#define WSM_RX_STATUS_AGGREGATE_FIRST	(BIT(4))
+
+/* Frame was last in the aggregation */
+#define WSM_RX_STATUS_AGGREGATE_LAST	(BIT(5))
+
+/* Indicates a defragmented frame */
+#define WSM_RX_STATUS_DEFRAGMENTED	(BIT(6))
+
+/* Indicates a Beacon frame */
+#define WSM_RX_STATUS_BEACON		(BIT(7))
+
+/* Indicates STA bit beacon TIM field */
+#define WSM_RX_STATUS_TIM		(BIT(8))
+
+/* Indicates Beacon frame's virtual bitmap contains multicast bit */
+#define WSM_RX_STATUS_MULTICAST		(BIT(9))
+
+/* Indicates frame contains a matching SSID */
+#define WSM_RX_STATUS_MATCHING_SSID	(BIT(10))
+
+/* Indicates frame contains a matching BSSI */
+#define WSM_RX_STATUS_MATCHING_BSSI	(BIT(11))
+
+/* Indicates More bit set in Framectl field */
+#define WSM_RX_STATUS_MORE_DATA		(BIT(12))
+
+/* Indicates frame received during a measurement process */
+#define WSM_RX_STATUS_MEASUREMENT	(BIT(13))
+
+/* Indicates frame received as an HT packet */
+#define WSM_RX_STATUS_HT		(BIT(14))
+
+/* Indicates frame received with STBC */
+#define WSM_RX_STATUS_STBC		(BIT(15))
+
+/* Indicates Address 1 field matches dot11StationId */
+#define WSM_RX_STATUS_ADDRESS1		(BIT(16))
+
+/* Indicates Group address present in the Address 1 field */
+#define WSM_RX_STATUS_GROUP		(BIT(17))
+
+/* Indicates Broadcast address present in the Address 1 field */
+#define WSM_RX_STATUS_BROADCAST		(BIT(18))
+
+/* Indicates group key used with encrypted frames */
+#define WSM_RX_STATUS_GROUP_KEY		(BIT(19))
+
+/* Macro to fetch encryption key index. */
+#define WSM_RX_STATUS_KEY_IDX(status)	(((status >> 20)) & 0x0F)
+
+/* Frame Control field starts at Frame offset + 2 */
+#define WSM_TX_2BYTES_SHIFT		(BIT(7))
+
+/* Join mode */
+/* IBSS */
+#define WSM_JOIN_MODE_IBSS		(0)
+
+/* BSS */
+#define WSM_JOIN_MODE_BSS		(1)
+
+/* PLCP preamble type */
+/* For long preamble */
+#define WSM_JOIN_PREAMBLE_LONG		(0)
+
+/* For short preamble (Long for 1Mbps) */
+#define WSM_JOIN_PREAMBLE_SHORT		(1)
+
+/* For short preamble (Long for 1 and 2Mbps) */
+#define WSM_JOIN_PREAMBLE_SHORT_2	(2)
+
+/* Join flags */
+/* Unsynchronized */
+#define WSM_JOIN_FLAGS_UNSYNCRONIZED	BIT(0)
+/* The BSS owner is a P2P GO */
+#define WSM_JOIN_FLAGS_P2P_GO		BIT(1)
+/* Force to join BSS with the BSSID and the
+ * SSID specified without waiting for beacons. The
+ * ProbeForJoin parameter is ignored. */
+#define WSM_JOIN_FLAGS_FORCE		BIT(2)
+/* Give probe request/response higher
+ * priority over the BT traffic */
+#define WSM_JOIN_FLAGS_PRIO		BIT(3)
+
+/* Key types */
+#define WSM_KEY_TYPE_WEP_DEFAULT	(0)
+#define WSM_KEY_TYPE_WEP_PAIRWISE	(1)
+#define WSM_KEY_TYPE_TKIP_GROUP		(2)
+#define WSM_KEY_TYPE_TKIP_PAIRWISE	(3)
+#define WSM_KEY_TYPE_AES_GROUP		(4)
+#define WSM_KEY_TYPE_AES_PAIRWISE	(5)
+#define WSM_KEY_TYPE_WAPI_GROUP		(6)
+#define WSM_KEY_TYPE_WAPI_PAIRWISE	(7)
+
+/* Key indexes */
+#define WSM_KEY_MAX_INDEX		(10)
+
+/* ACK policy */
+#define WSM_ACK_POLICY_NORMAL		(0)
+#define WSM_ACK_POLICY_NO_ACK		(1)
+
+/* Start modes */
+#define WSM_START_MODE_AP		(0)	/* Mini AP */
+#define WSM_START_MODE_P2P_GO		(1)	/* P2P GO */
+#define WSM_START_MODE_P2P_DEV		(2)	/* P2P device */
+
+/* SetAssociationMode MIB flags */
+#define WSM_ASSOCIATION_MODE_USE_PREAMBLE_TYPE		(BIT(0))
+#define WSM_ASSOCIATION_MODE_USE_HT_MODE		(BIT(1))
+#define WSM_ASSOCIATION_MODE_USE_BASIC_RATE_SET		(BIT(2))
+#define WSM_ASSOCIATION_MODE_USE_MPDU_START_SPACING	(BIT(3))
+#define WSM_ASSOCIATION_MODE_SNOOP_ASSOC_FRAMES		(BIT(4))
+
+/* RcpiRssiThreshold MIB flags */
+#define WSM_RCPI_RSSI_THRESHOLD_ENABLE	(BIT(0))
+#define WSM_RCPI_RSSI_USE_RSSI		(BIT(1))
+#define WSM_RCPI_RSSI_DONT_USE_UPPER	(BIT(2))
+#define WSM_RCPI_RSSI_DONT_USE_LOWER	(BIT(3))
+
+/* Update-ie constants */
+#define WSM_UPDATE_IE_BEACON		(BIT(0))
+#define WSM_UPDATE_IE_PROBE_RESP	(BIT(1))
+#define WSM_UPDATE_IE_PROBE_REQ		(BIT(2))
+
+/* WSM events */
+/* Error */
+#define WSM_EVENT_ERROR			(0)
+
+/* BSS lost */
+#define WSM_EVENT_BSS_LOST		(1)
+
+/* BSS regained */
+#define WSM_EVENT_BSS_REGAINED		(2)
+
+/* Radar detected */
+#define WSM_EVENT_RADAR_DETECTED	(3)
+
+/* RCPI or RSSI threshold triggered */
+#define WSM_EVENT_RCPI_RSSI		(4)
+
+/* BT inactive */
+#define WSM_EVENT_BT_INACTIVE		(5)
+
+/* BT active */
+#define WSM_EVENT_BT_ACTIVE		(6)
+
+/* MIB IDs */
+/* 4.1  dot11StationId */
+#define WSM_MIB_ID_DOT11_STATION_ID		0x0000
+
+/* 4.2  dot11MaxtransmitMsduLifeTime */
+#define WSM_MIB_ID_DOT11_MAX_TRANSMIT_LIFTIME	0x0001
+
+/* 4.3  dot11MaxReceiveLifeTime */
+#define WSM_MIB_ID_DOT11_MAX_RECEIVE_LIFETIME	0x0002
+
+/* 4.4  dot11SlotTime */
+#define WSM_MIB_ID_DOT11_SLOT_TIME		0x0003
+
+/* 4.5  dot11GroupAddressesTable */
+#define WSM_MIB_ID_DOT11_GROUP_ADDRESSES_TABLE	0x0004
+#define WSM_MAX_GRP_ADDRTABLE_ENTRIES		8
+
+/* 4.6  dot11WepDefaultKeyId */
+#define WSM_MIB_ID_DOT11_WEP_DEFAULT_KEY_ID	0x0005
+
+/* 4.7  dot11CurrentTxPowerLevel */
+#define WSM_MIB_ID_DOT11_CURRENT_TX_POWER_LEVEL	0x0006
+
+/* 4.8  dot11RTSThreshold */
+#define WSM_MIB_ID_DOT11_RTS_THRESHOLD		0x0007
+
+/* 4.9  NonErpProtection */
+#define WSM_MIB_ID_NON_ERP_PROTECTION		0x1000
+
+/* 4.10 ArpIpAddressesTable */
+#define WSM_MIB_ID_ARP_IP_ADDRESSES_TABLE	0x1001
+#define WSM_MAX_ARP_IP_ADDRTABLE_ENTRIES	1
+
+/* 4.11 TemplateFrame */
+#define WSM_MIB_ID_TEMPLATE_FRAME		0x1002
+
+/* 4.12 RxFilter */
+#define WSM_MIB_ID_RX_FILTER			0x1003
+
+/* 4.13 BeaconFilterTable */
+#define WSM_MIB_ID_BEACON_FILTER_TABLE		0x1004
+
+/* 4.14 BeaconFilterEnable */
+#define WSM_MIB_ID_BEACON_FILTER_ENABLE		0x1005
+
+/* 4.15 OperationalPowerMode */
+#define WSM_MIB_ID_OPERATIONAL_POWER_MODE	0x1006
+
+/* 4.16 BeaconWakeUpPeriod */
+#define WSM_MIB_ID_BEACON_WAKEUP_PERIOD		0x1007
+
+/* 4.17 RcpiRssiThreshold */
+#define WSM_MIB_ID_RCPI_RSSI_THRESHOLD		0x1009
+
+/* 4.18 StatisticsTable */
+#define WSM_MIB_ID_STATISTICS_TABLE		0x100A
+
+/* 4.19 IbssPsConfig */
+#define WSM_MIB_ID_IBSS_PS_CONFIG		0x100B
+
+/* 4.20 CountersTable */
+#define WSM_MIB_ID_COUNTERS_TABLE		0x100C
+
+/* 4.21 BlockAckPolicy */
+#define WSM_MIB_ID_BLOCK_ACK_POLICY		0x100E
+
+/* 4.22 OverrideInternalTxRate */
+#define WSM_MIB_ID_OVERRIDE_INTERNAL_TX_RATE	0x100F
+
+/* 4.23 SetAssociationMode */
+#define WSM_MIB_ID_SET_ASSOCIATION_MODE		0x1010
+
+/* 4.24 UpdateEptaConfigData */
+#define WSM_MIB_ID_UPDATE_EPTA_CONFIG_DATA	0x1011
+
+/* 4.25 SelectCcaMethod */
+#define WSM_MIB_ID_SELECT_CCA_METHOD		0x1012
+
+/* 4.26 SetUpasdInformation */
+#define WSM_MIB_ID_SET_UAPSD_INFORMATION	0x1013
+
+/* 4.27 SetAutoCalibrationMode  WBF00004073 */
+#define WSM_MIB_ID_SET_AUTO_CALIBRATION_MODE	0x1015
+
+/* 4.28 SetTxRateRetryPolicy */
+#define WSM_MIB_ID_SET_TX_RATE_RETRY_POLICY	0x1016
+
+/* 4.29 SetHostMessageTypeFilter */
+#define WSM_MIB_ID_SET_HOST_MSG_TYPE_FILTER	0x1017
+
+/* 4.30 P2PFindInfo */
+#define WSM_MIB_ID_P2P_FIND_INFO		0x1018
+
+/* 4.31 P2PPsModeInfo */
+#define WSM_MIB_ID_P2P_PS_MODE_INFO		0x1019
+
+/* 4.32 SetEtherTypeDataFrameFilter */
+#define WSM_MIB_ID_SET_ETHERTYPE_DATAFRAME_FILTER 0x101A
+
+/* 4.33 SetUDPPortDataFrameFilter */
+#define WSM_MIB_ID_SET_UDPPORT_DATAFRAME_FILTER	0x101B
+
+/* 4.34 SetMagicDataFrameFilter */
+#define WSM_MIB_ID_SET_MAGIC_DATAFRAME_FILTER	0x101C
+
+/* This is the end of specification. */
+
+/* 4.35 P2PDeviceInfo */
+#define WSM_MIB_ID_P2P_DEVICE_INFO		0x101D
+
+/* 4.36 SetWCDMABand */
+#define WSM_MIB_ID_SET_WCDMA_BAND		0x101E
+
+/* 4.37 GroupTxSequenceCounter */
+#define WSM_MIB_ID_GRP_SEQ_COUNTER		0x101F
+
+/* 4.38 ProtectedMgmtPolicy */
+#define WSM_MIB_ID_PROTECTED_MGMT_POLICY	0x1020
+
+/* 4.39 SetHtProtection */
+#define WSM_MID_ID_SET_HT_PROTECTION		0x1021
+
+/* 4.40 GPIO Command */
+#define WSM_MIB_ID_GPIO_COMMAND			0x1022
+
+/* 4.41 TSF Counter Value */
+#define WSM_MIB_ID_TSF_COUNTER			0x1023
+
+/* Test Purposes Only */
+#define WSM_MIB_ID_BLOCK_ACK_INFO		0x100D
+
+/* 4.42 UseMultiTxConfMessage */
+#define WSM_MIB_USE_MULTI_TX_CONF		0x1024
+
+/* 4.43 Keep-alive period */
+#define WSM_MIB_ID_KEEP_ALIVE_PERIOD		0x1025
+
+/* 4.44 Disable BSSID filter */
+#define WSM_MIB_ID_DISABLE_BSSID_FILTER		0x1026
+
+/* Frame template types */
+#define WSM_FRAME_TYPE_PROBE_REQUEST	(0)
+#define WSM_FRAME_TYPE_BEACON		(1)
+#define WSM_FRAME_TYPE_NULL		(2)
+#define WSM_FRAME_TYPE_QOS_NULL		(3)
+#define WSM_FRAME_TYPE_PS_POLL		(4)
+#define WSM_FRAME_TYPE_PROBE_RESPONSE	(5)
+
+#define WSM_FRAME_GREENFIELD		(0x80)	/* See 4.11 */
+
+/* Status */
+/* The WSM firmware has completed a request */
+/* successfully. */
+#define WSM_STATUS_SUCCESS              (0)
+
+/* This is a generic failure code if other error codes do */
+/* not apply. */
+#define WSM_STATUS_FAILURE              (1)
+
+/* A request contains one or more invalid parameters. */
+#define WSM_INVALID_PARAMETER           (2)
+
+/* The request cannot perform because the device is in */
+/* an inappropriate mode. */
+#define WSM_ACCESS_DENIED               (3)
+
+/* The frame received includes a decryption error. */
+#define WSM_STATUS_DECRYPTFAILURE       (4)
+
+/* A MIC failure is detected in the received packets. */
+#define WSM_STATUS_MICFAILURE           (5)
+
+/* The transmit request failed due to retry limit being */
+/* exceeded. */
+#define WSM_STATUS_RETRY_EXCEEDED       (6)
+
+/* The transmit request failed due to MSDU life time */
+/* being exceeded. */
+#define WSM_STATUS_TX_LIFETIME_EXCEEDED (7)
+
+/* The link to the AP is lost. */
+#define WSM_STATUS_LINK_LOST            (8)
+
+/* No key was found for the encrypted frame */
+#define WSM_STATUS_NO_KEY_FOUND         (9)
+
+/* Jammer was detected when transmitting this frame */
+#define WSM_STATUS_JAMMER_DETECTED      (10)
+
+/* The message should be requeued later. */
+/* This is applicable only to Transmit */
+#define WSM_REQUEUE                     (11)
+
+/* Advanced filtering options */
+#define WSM_MAX_FILTER_ELEMENTS		(4)
+
+#define WSM_FILTER_ACTION_IGNORE	(0)
+#define WSM_FILTER_ACTION_FILTER_IN	(1)
+#define WSM_FILTER_ACTION_FILTER_OUT	(2)
+
+#define WSM_FILTER_PORT_TYPE_DST	(0)
+#define WSM_FILTER_PORT_TYPE_SRC	(1)
+
+
+
+struct wsm_hdr {
+	__le16 len;
+	__le16 id;
+};
+
+#define WSM_TX_SEQ_MAX			(7)
+#define WSM_TX_SEQ(seq)			\
+		((seq & WSM_TX_SEQ_MAX) << 13)
+#define WSM_TX_LINK_ID_MAX		(0x0F)
+#define WSM_TX_LINK_ID(link_id)		\
+		((link_id & WSM_TX_LINK_ID_MAX) << 6)
+
+#define MAX_BEACON_SKIP_TIME_MS 1000
+
+#define WSM_CMD_LAST_CHANCE_TIMEOUT (HZ * 3 / 2)
+
+/* ******************************************************************** */
+/* WSM capcbility							*/
+
+struct wsm_caps {
+	u16 numInpChBufs;
+	u16 sizeInpChBuf;
+	u16 hardwareId;
+	u16 hardwareSubId;
+	u16 firmwareCap;
+	u16 firmwareType;
+	u16 firmwareApiVer;
+	u16 firmwareBuildNumber;
+	u16 firmwareVersion;
+	int firmwareReady;
+};
+
+/* ******************************************************************** */
+/* WSM commands								*/
+
+struct wsm_tx_power_range {
+	int min_power_level;
+	int max_power_level;
+	u32 stepping;
+};
+
+/* 3.1 */
+struct wsm_configuration {
+	/* [in] */ u32 dot11MaxTransmitMsduLifeTime;
+	/* [in] */ u32 dot11MaxReceiveLifeTime;
+	/* [in] */ u32 dot11RtsThreshold;
+	/* [in, out] */ u8 *dot11StationId;
+	/* [in] */ const void *dpdData;
+	/* [in] */ size_t dpdData_size;
+	/* [out] */ u8 dot11FrequencyBandsSupported;
+	/* [out] */ u32 supportedRateMask;
+	/* [out] */ struct wsm_tx_power_range txPowerRange[2];
+};
+
+int wsm_configuration(struct cw1200_common *priv,
+		      struct wsm_configuration *arg);
+
+/* 3.3 */
+struct wsm_reset {
+	/* [in] */ int link_id;
+	/* [in] */ bool reset_statistics;
+};
+
+int wsm_reset(struct cw1200_common *priv, const struct wsm_reset *arg);
+
+/* 3.5 */
+int wsm_read_mib(struct cw1200_common *priv, u16 mibId, void *buf,
+		 size_t buf_size);
+
+/* 3.7 */
+int wsm_write_mib(struct cw1200_common *priv, u16 mibId, void *buf,
+		  size_t buf_size);
+
+/* 3.9 */
+struct wsm_ssid {
+	u8 ssid[32];
+	u32 length;
+};
+
+struct wsm_scan_ch {
+	u16 number;
+	u32 minChannelTime;
+	u32 maxChannelTime;
+	u32 txPowerLevel;
+};
+
+/* 3.13 */
+struct wsm_scan_complete {
+	/* WSM_STATUS_... */
+	u32 status;
+
+	/* WSM_PSM_... */
+	u8 psm;
+
+	/* Number of channels that the scan operation completed. */
+	u8 numChannels;
+};
+
+typedef void (*wsm_scan_complete_cb) (struct cw1200_common *priv,
+				      struct wsm_scan_complete *arg);
+
+/* 3.9 */
+struct wsm_scan {
+	/* WSM_PHY_BAND_... */
+	/* [in] */ u8 band;
+
+	/* WSM_SCAN_TYPE_... */
+	/* [in] */ u8 scanType;
+
+	/* WSM_SCAN_FLAG_... */
+	/* [in] */ u8 scanFlags;
+
+	/* WSM_TRANSMIT_RATE_... */
+	/* [in] */ u8 maxTransmitRate;
+
+	/* Interval period in TUs that the device shall the re- */
+	/* execute the requested scan. Max value supported by the device */
+	/* is 256s. */
+	/* [in] */ u32 autoScanInterval;
+
+	/* Number of probe requests (per SSID) sent to one (1) */
+	/* channel. Zero (0) means that none is send, which */
+	/* means that a passive scan is to be done. Value */
+	/* greater than zero (0) means that an active scan is to */
+	/* be done. */
+	/* [in] */ u32 numOfProbeRequests;
+
+	/* Number of channels to be scanned. */
+	/* Maximum value is WSM_SCAN_MAX_NUM_OF_CHANNELS. */
+	/* [in] */ u8 numOfChannels;
+
+	/* Number of SSID provided in the scan command (this */
+	/* is zero (0) in broadcast scan) */
+	/* The maximum number of SSIDs is WSM_SCAN_MAX_NUM_OF_SSIDS. */
+	/* [in] */ u8 numOfSSIDs;
+
+	/* The delay time (in microseconds) period */
+	/* before sending a probe-request. */
+	/* [in] */ u8 probeDelay;
+
+	/* SSIDs to be scanned [numOfSSIDs]; */
+	/* [in] */ struct wsm_ssid *ssids;
+
+	/* Channels to be scanned [numOfChannels]; */
+	/* [in] */ struct wsm_scan_ch *ch;
+};
+
+int wsm_scan(struct cw1200_common *priv, const struct wsm_scan *arg);
+
+/* 3.11 */
+int wsm_stop_scan(struct cw1200_common *priv);
+
+/* 3.14 */
+struct wsm_tx_confirm {
+	/* Packet identifier used in wsm_tx. */
+	/* [out] */ u32 packetID;
+
+	/* WSM_STATUS_... */
+	/* [out] */ u32 status;
+
+	/* WSM_TRANSMIT_RATE_... */
+	/* [out] */ u8 txedRate;
+
+	/* The number of times the frame was transmitted */
+	/* without receiving an acknowledgement. */
+	/* [out] */ u8 ackFailures;
+
+	/* WSM_TX_STATUS_... */
+	/* [out] */ u16 flags;
+
+	/* The total time in microseconds that the frame spent in */
+	/* the WLAN device before transmission as completed. */
+	/* [out] */ u32 mediaDelay;
+
+	/* The total time in microseconds that the frame spent in */
+	/* the WLAN device before transmission was started. */
+	/* [out] */ u32 txQueueDelay;
+
+	/* [out]*/ u32 link_id;
+};
+
+/* 3.15 */
+typedef void (*wsm_tx_confirm_cb) (struct cw1200_common *priv,
+				   struct wsm_tx_confirm *arg);
+
+/* Note that ideology of wsm_tx struct is different against the rest of
+ * WSM API. wsm_hdr is /not/ a caller-adapted struct to be used as an input
+ * argument for WSM call, but a prepared bytestream to be sent to firmware.
+ * It is filled partly in cw1200_tx, partly in low-level WSM code.
+ * Please pay attention once again: ideology is different.
+ *
+ * Legend:
+ * - [in]: cw1200_tx must fill this field.
+ * - [wsm]: the field is filled by low-level WSM.
+ */
+struct wsm_tx {
+	/* common WSM header */
+	/* [in/wsm] */ struct wsm_hdr hdr;
+
+	/* Packet identifier that meant to be used in completion. */
+	/* [in] */ __le32 packetID;
+
+	/* WSM_TRANSMIT_RATE_... */
+	/* [in] */ u8 maxTxRate;
+
+	/* WSM_QUEUE_... */
+	/* [in] */ u8 queueId;
+
+	/* True: another packet is pending on the host for transmission. */
+	/* [wsm] */ u8 more;
+
+	/* Bit 0 = 0 - Start expiry time from first Tx attempt (default) */
+	/* Bit 0 = 1 - Start expiry time from receipt of Tx Request */
+	/* Bits 3:1  - PTA Priority */
+	/* Bits 6:4  - Tx Rate Retry Policy */
+	/* Bit 7 - Reserved */
+	/* [in] */ u8 flags;
+
+	/* Should be 0. */
+	/* [in] */ __le32 reserved;
+
+	/* The elapsed time in TUs, after the initial transmission */
+	/* of an MSDU, after which further attempts to transmit */
+	/* the MSDU shall be terminated. Overrides the global */
+	/* dot11MaxTransmitMsduLifeTime setting [optional] */
+	/* Device will set the default value if this is 0. */
+	/* [wsm] */ __le32 expireTime;
+
+	/* WSM_HT_TX_... */
+	/* [in] */ __le32 htTxParameters;
+};
+
+/* = sizeof(generic hi hdr) + sizeof(wsm hdr) + sizeof(alignment) */
+#define WSM_TX_EXTRA_HEADROOM (28)
+
+/* 3.16 */
+struct wsm_rx {
+	/* WSM_STATUS_... */
+	/* [out] */ u32 status;
+
+	/* Specifies the channel of the received packet. */
+	/* [out] */ u16 channelNumber;
+
+	/* WSM_TRANSMIT_RATE_... */
+	/* [out] */ u8 rxedRate;
+
+	/* This value is expressed in signed Q8.0 format for */
+	/* RSSI and unsigned Q7.1 format for RCPI. */
+	/* [out] */ u8 rcpiRssi;
+
+	/* WSM_RX_STATUS_... */
+	/* [out] */ u32 flags;
+
+	/* An 802.11 frame. */
+	/* [out] */ void *frame;
+
+	/* Size of the frame */
+	/* [out] */ size_t frame_size;
+
+	/* Link ID */
+	/* [out] */ int link_id;
+};
+
+/* = sizeof(generic hi hdr) + sizeof(wsm hdr) */
+#define WSM_RX_EXTRA_HEADROOM (16)
+
+typedef void (*wsm_rx_cb) (struct cw1200_common *priv, struct wsm_rx *arg,
+			   struct sk_buff **skb_p);
+
+/* 3.17 */
+struct wsm_event {
+	/* WSM_STATUS_... */
+	/* [out] */ u32 eventId;
+
+	/* Indication parameters. */
+	/* For error indication, this shall be a 32-bit WSM status. */
+	/* For RCPI or RSSI indication, this should be an 8-bit */
+	/* RCPI or RSSI value. */
+	/* [out] */ u32 eventData;
+};
+
+struct cw1200_wsm_event {
+	struct list_head link;
+	struct wsm_event evt;
+};
+
+/* 3.18 - 3.22 */
+/* Measurement. Skipped for now. Irrelevent. */
+
+typedef void (*wsm_event_cb) (struct cw1200_common *priv,
+			      struct wsm_event *arg);
+
+/* 3.23 */
+struct wsm_join {
+	/* WSM_JOIN_MODE_... */
+	/* [in] */ u8 mode;
+
+	/* WSM_PHY_BAND_... */
+	/* [in] */ u8 band;
+
+	/* Specifies the channel number to join. The channel */
+	/* number will be mapped to an actual frequency */
+	/* according to the band */
+	/* [in] */ u16 channelNumber;
+
+	/* Specifies the BSSID of the BSS or IBSS to be joined */
+	/* or the IBSS to be started. */
+	/* [in] */ u8 bssid[6];
+
+	/* ATIM window of IBSS */
+	/* When ATIM window is zero the initiated IBSS does */
+	/* not support power saving. */
+	/* [in] */ u16 atimWindow;
+
+	/* WSM_JOIN_PREAMBLE_... */
+	/* [in] */ u8 preambleType;
+
+	/* Specifies if a probe request should be send with the */
+	/* specified SSID when joining to the network. */
+	/* [in] */ u8 probeForJoin;
+
+	/* DTIM Period (In multiples of beacon interval) */
+	/* [in] */ u8 dtimPeriod;
+
+	/* WSM_JOIN_FLAGS_... */
+	/* [in] */ u8 flags;
+
+	/* Length of the SSID */
+	/* [in] */ u32 ssidLength;
+
+	/* Specifies the SSID of the IBSS to join or start */
+	/* [in] */ u8 ssid[32];
+
+	/* Specifies the time between TBTTs in TUs */
+	/* [in] */ u32 beaconInterval;
+
+	/* A bit mask that defines the BSS basic rate set. */
+	/* [in] */ u32 basicRateSet;
+
+	/* Minimum transmission power level in units of 0.1dBm */
+	/* [out] */ int minPowerLevel;
+
+	/* Maximum transmission power level in units of 0.1dBm */
+	/* [out] */ int maxPowerLevel;
+};
+
+int wsm_join(struct cw1200_common *priv, struct wsm_join *arg);
+
+/* 3.25 */
+struct wsm_set_pm {
+	/* WSM_PSM_... */
+	/* [in] */ u8 pmMode;
+
+	/* in unit of 500us; 0 to use default */
+	/* [in] */ u8 fastPsmIdlePeriod;
+
+	/* in unit of 500us; 0 to use default */
+	/* [in] */ u8 apPsmChangePeriod;
+
+	/* in unit of 500us; 0 to disable auto-pspoll */
+	/* [in] */ u8 minAutoPsPollPeriod;
+};
+
+int wsm_set_pm(struct cw1200_common *priv, const struct wsm_set_pm *arg);
+
+/* 3.27 */
+struct wsm_set_pm_complete {
+	u8 psm;			/* WSM_PSM_... */
+};
+
+typedef void (*wsm_set_pm_complete_cb) (struct cw1200_common *priv,
+					struct wsm_set_pm_complete *arg);
+
+/* 3.28 */
+struct wsm_set_bss_params {
+	/* The number of lost consecutive beacons after which */
+	/* the WLAN device should indicate the BSS-Lost event */
+	/* to the WLAN host driver. */
+	u8 beaconLostCount;
+
+	/* The AID received during the association process. */
+	u16 aid;
+
+	/* The operational rate set mask */
+	u32 operationalRateSet;
+};
+
+int wsm_set_bss_params(struct cw1200_common *priv,
+		       const struct wsm_set_bss_params *arg);
+
+/* 3.30 */
+struct wsm_add_key {
+	u8 type;		/* WSM_KEY_TYPE_... */
+	u8 entryIndex;		/* Key entry index: 0 -- WSM_KEY_MAX_INDEX */
+	u16 reserved;
+	union {
+		struct {
+			u8 peerAddress[6];	/* MAC address of the
+						 * peer station */
+			u8 reserved;
+			u8 keyLength;		/* Key length in bytes */
+			u8 keyData[16];		/* Key data */
+		} __packed wepPairwiseKey;
+		struct {
+			u8 keyId;		/* Unique per key identifier
+						 * (0..3) */
+			u8 keyLength;		/* Key length in bytes */
+			u16 reserved;
+			u8 keyData[16];		/* Key data */
+		} __packed wepGroupKey;
+		struct {
+			u8 peerAddress[6];	/* MAC address of the
+						 * peer station */
+			u8 reserved[2];
+			u8 tkipKeyData[16];	/* TKIP key data */
+			u8 rxMicKey[8];		/* Rx MIC key */
+			u8 txMicKey[8];		/* Tx MIC key */
+		} __packed tkipPairwiseKey;
+		struct {
+			u8 tkipKeyData[16];	/* TKIP key data */
+			u8 rxMicKey[8];		/* Rx MIC key */
+			u8 keyId;		/* Key ID */
+			u8 reserved[3];
+			u8 rxSeqCounter[8];	/* Receive Sequence Counter */
+		} __packed tkipGroupKey;
+		struct {
+			u8 peerAddress[6];	/* MAC address of the
+						 * peer station */
+			u16 reserved;
+			u8 aesKeyData[16];	/* AES key data */
+		} __packed aesPairwiseKey;
+		struct {
+			u8 aesKeyData[16];	/* AES key data */
+			u8 keyId;		/* Key ID */
+			u8 reserved[3];
+			u8 rxSeqCounter[8];	/* Receive Sequence Counter */
+		} __packed aesGroupKey;
+		struct {
+			u8 peerAddress[6];	/* MAC address of the
+						 * peer station */
+			u8 keyId;		/* Key ID */
+			u8 reserved;
+			u8 wapiKeyData[16];	/* WAPI key data */
+			u8 micKeyData[16];	/* MIC key data */
+		} __packed wapiPairwiseKey;
+		struct {
+			u8 wapiKeyData[16];	/* WAPI key data */
+			u8 micKeyData[16];	/* MIC key data */
+			u8 keyId;		/* Key ID */
+			u8 reserved[3];
+		} __packed wapiGroupKey;
+	} __packed;
+} __packed;
+
+int wsm_add_key(struct cw1200_common *priv, const struct wsm_add_key *arg);
+
+/* 3.32 */
+struct wsm_remove_key {
+	/* Key entry index : 0-10 */
+	u8 entryIndex;
+};
+
+int wsm_remove_key(struct cw1200_common *priv,
+		   const struct wsm_remove_key *arg);
+
+/* 3.34 */
+struct wsm_set_tx_queue_params {
+	/* WSM_ACK_POLICY_... */
+	u8 ackPolicy;
+
+	/* Medium Time of TSPEC (in 32us units) allowed per */
+	/* One Second Averaging Period for this queue. */
+	u16 allowedMediumTime;
+
+	/* dot11MaxTransmitMsduLifetime to be used for the */
+	/* specified queue. */
+	u32 maxTransmitLifetime;
+};
+
+struct wsm_tx_queue_params {
+	/* NOTE: index is a linux queue id. */
+	struct wsm_set_tx_queue_params params[4];
+};
+
+
+#define WSM_TX_QUEUE_SET(queue_params, queue, ack_policy, allowed_time,\
+		max_life_time)	\
+do {							\
+	struct wsm_set_tx_queue_params *p = &(queue_params)->params[queue]; \
+	p->ackPolicy = (ack_policy);				\
+	p->allowedMediumTime = (allowed_time);				\
+	p->maxTransmitLifetime = (max_life_time);			\
+} while (0)
+
+int wsm_set_tx_queue_params(struct cw1200_common *priv,
+			    const struct wsm_set_tx_queue_params *arg, u8 id);
+
+/* 3.36 */
+struct wsm_edca_queue_params {
+	/* CWmin (in slots) for the access class. */
+	/* [in] */ u16 cwMin;
+
+	/* CWmax (in slots) for the access class. */
+	/* [in] */ u16 cwMax;
+
+	/* AIFS (in slots) for the access class. */
+	/* [in] */ u8 aifns;
+
+	/* TX OP Limit (in microseconds) for the access class. */
+	/* [in] */ u16 txOpLimit;
+
+	/* dot11MaxReceiveLifetime to be used for the specified */
+	/* the access class. Overrides the global */
+	/* dot11MaxReceiveLifetime value */
+	/* [in] */ u32 maxReceiveLifetime;
+
+	/* UAPSD trigger support for the access class. */
+	/* [in] */ bool uapsdEnable;
+};
+
+struct wsm_edca_params {
+	/* NOTE: index is a linux queue id. */
+	struct wsm_edca_queue_params params[4];
+};
+
+#define TXOP_UNIT 32
+#define WSM_EDCA_SET(edca, queue, aifs, cw_min, cw_max, txop, life_time,\
+		uapsd)	\
+	do {							\
+		struct wsm_edca_queue_params *p = &(edca)->params[queue]; \
+		p->cwMin = (cw_min);				\
+		p->cwMax = (cw_max);				\
+		p->aifns = (aifs);				\
+		p->txOpLimit = ((txop) * TXOP_UNIT);		\
+		p->maxReceiveLifetime = (life_time);		\
+		p->uapsdEnable = (uapsd);			\
+	} while (0)
+
+int wsm_set_edca_params(struct cw1200_common *priv,
+			const struct wsm_edca_params *arg);
+
+int wsm_set_uapsd_param(struct cw1200_common *priv,
+			const struct wsm_edca_params *arg);
+
+/* 3.38 */
+/* Set-System info. Skipped for now. Irrelevent. */
+
+/* 3.40 */
+struct wsm_switch_channel {
+	/* 1 - means the STA shall not transmit any further */
+	/* frames until the channel switch has completed */
+	/* [in] */ u8 channelMode;
+
+	/* Number of TBTTs until channel switch occurs. */
+	/* 0 - indicates switch shall occur at any time */
+	/* 1 - occurs immediately before the next TBTT */
+	/* [in] */ u8 channelSwitchCount;
+
+	/* The new channel number to switch to. */
+	/* Note this is defined as per section 2.7. */
+	/* [in] */ u16 newChannelNumber;
+};
+
+int wsm_switch_channel(struct cw1200_common *priv,
+		       const struct wsm_switch_channel *arg);
+
+typedef void (*wsm_channel_switch_cb) (struct cw1200_common *priv);
+
+struct wsm_start {
+	/* WSM_START_MODE_... */
+	/* [in] */ u8 mode;
+
+	/* WSM_PHY_BAND_... */
+	/* [in] */ u8 band;
+
+	/* Channel number */
+	/* [in] */ u16 channelNumber;
+
+	/* Client Traffic window in units of TU */
+	/* Valid only when mode == ..._P2P */
+	/* [in] */ u32 CTWindow;
+
+	/* Interval between two consecutive */
+	/* beacon transmissions in TU. */
+	/* [in] */ u32 beaconInterval;
+
+	/* DTIM period in terms of beacon intervals */
+	/* [in] */ u8 DTIMPeriod;
+
+	/* WSM_JOIN_PREAMBLE_... */
+	/* [in] */ u8 preambleType;
+
+	/* The delay time (in microseconds) period */
+	/* before sending a probe-request. */
+	/* [in] */ u8 probeDelay;
+
+	/* Length of the SSID */
+	/* [in] */ u8 ssidLength;
+
+	/* SSID of the BSS or P2P_GO to be started now. */
+	/* [in] */ u8 ssid[32];
+
+	/* The basic supported rates for the MiniAP. */
+	/* [in] */ u32 basicRateSet;
+};
+
+int wsm_start(struct cw1200_common *priv, const struct wsm_start *arg);
+
+struct wsm_beacon_transmit {
+	/* 1: enable; 0: disable */
+	/* [in] */ u8 enableBeaconing;
+};
+
+int wsm_beacon_transmit(struct cw1200_common *priv,
+			const struct wsm_beacon_transmit *arg);
+
+int wsm_start_find(struct cw1200_common *priv);
+
+int wsm_stop_find(struct cw1200_common *priv);
+
+typedef void (*wsm_find_complete_cb) (struct cw1200_common *priv, u32 status);
+
+struct wsm_suspend_resume {
+	/* See 3.52 */
+	/* Link ID */
+	/* [out] */ int link_id;
+	/* Stop sending further Tx requests down to device for this link */
+	/* [out] */ bool stop;
+	/* Transmit multicast Frames */
+	/* [out] */ bool multicast;
+	/* The AC on which Tx to be suspended /resumed. */
+	/* This is applicable only for U-APSD */
+	/* WSM_QUEUE_... */
+	/* [out] */ int queue;
+};
+
+typedef void (*wsm_suspend_resume_cb) (struct cw1200_common *priv,
+				       struct wsm_suspend_resume *arg);
+
+/* 3.54 Update-IE request. */
+struct wsm_update_ie {
+	/* WSM_UPDATE_IE_... */
+	/* [in] */ u16 what;
+	/* [in] */ u16 count;
+	/* [in] */ u8 *ies;
+	/* [in] */ size_t length;
+};
+
+int wsm_update_ie(struct cw1200_common *priv,
+		  const struct wsm_update_ie *arg);
+
+/* 3.56 */
+struct wsm_map_link {
+	/* MAC address of the remote device */
+	/* [in] */ u8 mac_addr[6];
+	/* [in] */ u8 link_id;
+};
+
+int wsm_map_link(struct cw1200_common *priv, const struct wsm_map_link *arg);
+
+struct wsm_cbc {
+	wsm_scan_complete_cb scan_complete;
+	wsm_tx_confirm_cb tx_confirm;
+	wsm_rx_cb rx;
+	wsm_event_cb event;
+	wsm_set_pm_complete_cb set_pm_complete;
+	wsm_channel_switch_cb channel_switch;
+	wsm_find_complete_cb find_complete;
+	wsm_suspend_resume_cb suspend_resume;
+};
+
+/* ******************************************************************** */
+/* MIB shortcats							*/
+
+static inline int wsm_set_output_power(struct cw1200_common *priv,
+				       int power_level)
+{
+	__le32 val = __cpu_to_le32(power_level);
+	return wsm_write_mib(priv, WSM_MIB_ID_DOT11_CURRENT_TX_POWER_LEVEL,
+			     &val, sizeof(val));
+}
+
+static inline int wsm_set_beacon_wakeup_period(struct cw1200_common *priv,
+					       unsigned dtim_interval,
+					       unsigned listen_interval)
+{
+	struct {
+		u8 numBeaconPeriods;
+		u8 reserved;
+		__le16 listenInterval;
+	} val = {
+	dtim_interval, 0, __cpu_to_le16(listen_interval)};
+	if (dtim_interval > 0xFF || listen_interval > 0xFFFF)
+		return -EINVAL;
+	else
+		return wsm_write_mib(priv, WSM_MIB_ID_BEACON_WAKEUP_PERIOD,
+				     &val, sizeof(val));
+}
+
+struct wsm_rcpi_rssi_threshold {
+	u8 rssiRcpiMode;	/* WSM_RCPI_RSSI_... */
+	u8 lowerThreshold;
+	u8 upperThreshold;
+	u8 rollingAverageCount;
+};
+
+static inline int wsm_set_rcpi_rssi_threshold(struct cw1200_common *priv,
+					struct wsm_rcpi_rssi_threshold *arg)
+{
+	return wsm_write_mib(priv, WSM_MIB_ID_RCPI_RSSI_THRESHOLD, arg,
+			     sizeof(*arg));
+}
+
+struct wsm_counters_table {
+	__le32 countPlcpErrors;
+	__le32 countFcsErrors;
+	__le32 countTxPackets;
+	__le32 countRxPackets;
+	__le32 countRxPacketErrors;
+	__le32 countRxDecryptionFailures;
+	__le32 countRxMicFailures;
+	__le32 countRxNoKeyFailures;
+	__le32 countTxMulticastFrames;
+	__le32 countTxFramesSuccess;
+	__le32 countTxFrameFailures;
+	__le32 countTxFramesRetried;
+	__le32 countTxFramesMultiRetried;
+	__le32 countRxFrameDuplicates;
+	__le32 countRtsSuccess;
+	__le32 countRtsFailures;
+	__le32 countAckFailures;
+	__le32 countRxMulticastFrames;
+	__le32 countRxFramesSuccess;
+	__le32 countRxCMACICVErrors;
+	__le32 countRxCMACReplays;
+	__le32 countRxMgmtCCMPReplays;
+};
+
+static inline int wsm_get_counters_table(struct cw1200_common *priv,
+					 struct wsm_counters_table *arg)
+{
+	return wsm_read_mib(priv, WSM_MIB_ID_COUNTERS_TABLE,
+			arg, sizeof(*arg));
+}
+
+static inline int wsm_get_station_id(struct cw1200_common *priv, u8 *mac)
+{
+	return wsm_read_mib(priv, WSM_MIB_ID_DOT11_STATION_ID, mac, ETH_ALEN);
+}
+
+struct wsm_rx_filter {
+	bool promiscuous;
+	bool bssid;
+	bool fcs;
+};
+
+static inline int wsm_set_rx_filter(struct cw1200_common *priv,
+				    const struct wsm_rx_filter *arg)
+{
+	__le32 val = 0;
+	if (arg->promiscuous)
+		val |= __cpu_to_le32(BIT(0));
+	if (arg->bssid)
+		val |= __cpu_to_le32(BIT(1));
+	if (arg->fcs)
+		val |= __cpu_to_le32(BIT(2));
+	return wsm_write_mib(priv, WSM_MIB_ID_RX_FILTER, &val, sizeof(val));
+}
+
+#define WSM_BEACON_FILTER_IE_HAS_CHANGED	BIT(0)
+#define WSM_BEACON_FILTER_IE_NO_LONGER_PRESENT	BIT(1)
+#define WSM_BEACON_FILTER_IE_HAS_APPEARED	BIT(2)
+
+struct wsm_beacon_filter_table_entry {
+	u8	ieId;
+	u8	actionFlags;
+	u8	oui[3];
+	u8	matchData[3];
+} __packed;
+
+struct wsm_beacon_filter_table {
+	__le32 numOfIEs;
+	struct wsm_beacon_filter_table_entry entry[10];
+} __packed;
+
+static inline int wsm_set_beacon_filter_table(struct cw1200_common *priv,
+					struct wsm_beacon_filter_table *ft)
+{
+	size_t size = __le32_to_cpu(ft->numOfIEs) *
+		     sizeof(struct wsm_beacon_filter_table_entry) +
+		     sizeof(__le32);
+
+	return wsm_write_mib(priv, WSM_MIB_ID_BEACON_FILTER_TABLE, ft, size);
+}
+
+struct wsm_beacon_filter_control {
+	int enabled;
+	int bcn_count;
+};
+
+static inline int wsm_beacon_filter_control(struct cw1200_common *priv,
+					struct wsm_beacon_filter_control *arg)
+{
+	struct {
+		__le32 enabled;
+		__le32 bcn_count;
+	} val;
+	val.enabled = __cpu_to_le32(arg->enabled);
+	val.bcn_count = __cpu_to_le32(arg->bcn_count);
+	return wsm_write_mib(priv, WSM_MIB_ID_BEACON_FILTER_ENABLE, &val,
+			     sizeof(val));
+}
+
+enum wsm_power_mode {
+	wsm_power_mode_active = 0,
+	wsm_power_mode_doze = 1,
+	wsm_power_mode_quiescent = 2,
+};
+
+struct wsm_operational_mode {
+	enum wsm_power_mode power_mode;
+	int disableMoreFlagUsage;
+	int performAntDiversity;
+};
+
+static inline int wsm_set_operational_mode(struct cw1200_common *priv,
+					const struct wsm_operational_mode *arg)
+{
+	u8 val = arg->power_mode;
+	if (arg->disableMoreFlagUsage)
+		val |= BIT(4);
+	if (arg->performAntDiversity)
+		val |= BIT(5);
+	return wsm_write_mib(priv, WSM_MIB_ID_OPERATIONAL_POWER_MODE, &val,
+			     sizeof(val));
+}
+
+struct wsm_template_frame {
+	u8 frame_type;
+	u8 rate;
+	bool disable;
+	struct sk_buff *skb;
+};
+
+static inline int wsm_set_template_frame(struct cw1200_common *priv,
+					 struct wsm_template_frame *arg)
+{
+	int ret;
+	u8 *p = skb_push(arg->skb, 4);
+	p[0] = arg->frame_type;
+	p[1] = arg->rate;
+	if (arg->disable)
+		((u16 *) p)[1] = 0;
+	else
+		((u16 *) p)[1] = __cpu_to_le16(arg->skb->len - 4);
+	ret = wsm_write_mib(priv, WSM_MIB_ID_TEMPLATE_FRAME, p, arg->skb->len);
+	skb_pull(arg->skb, 4);
+	return ret;
+}
+
+
+struct wsm_protected_mgmt_policy {
+	bool protectedMgmtEnable;
+	bool unprotectedMgmtFramesAllowed;
+	bool encryptionForAuthFrame;
+};
+
+static inline int wsm_set_protected_mgmt_policy(struct cw1200_common *priv,
+		struct wsm_protected_mgmt_policy *arg)
+{
+	__le32 val = 0;
+	int ret;
+	if (arg->protectedMgmtEnable)
+		val |= __cpu_to_le32(BIT(0));
+	if (arg->unprotectedMgmtFramesAllowed)
+		val |= __cpu_to_le32(BIT(1));
+	if (arg->encryptionForAuthFrame)
+		val |= __cpu_to_le32(BIT(2));
+	ret = wsm_write_mib(priv, WSM_MIB_ID_PROTECTED_MGMT_POLICY,
+			&val, sizeof(val));
+	return ret;
+}
+
+static inline int wsm_set_block_ack_policy(struct cw1200_common *priv,
+					   u8 blockAckTxTidPolicy,
+					   u8 blockAckRxTidPolicy)
+{
+	struct {
+		u8 blockAckTxTidPolicy;
+		u8 reserved1;
+		u8 blockAckRxTidPolicy;
+		u8 reserved2;
+	} val = {
+		.blockAckTxTidPolicy = blockAckTxTidPolicy,
+		.blockAckRxTidPolicy = blockAckRxTidPolicy,
+	};
+	return wsm_write_mib(priv, WSM_MIB_ID_BLOCK_ACK_POLICY, &val,
+			     sizeof(val));
+}
+
+struct wsm_association_mode {
+	u8 flags;		/* WSM_ASSOCIATION_MODE_... */
+	u8 preambleType;	/* WSM_JOIN_PREAMBLE_... */
+	u8 greenfieldMode;	/* 1 for greenfield */
+	u8 mpduStartSpacing;
+	__le32 basicRateSet;
+};
+
+static inline int wsm_set_association_mode(struct cw1200_common *priv,
+					   struct wsm_association_mode *arg)
+{
+	return wsm_write_mib(priv, WSM_MIB_ID_SET_ASSOCIATION_MODE, arg,
+			     sizeof(*arg));
+}
+
+struct wsm_set_tx_rate_retry_policy_header {
+	u8 numTxRatePolicies;
+	u8 reserved[3];
+} __packed;
+
+struct wsm_set_tx_rate_retry_policy_policy {
+	u8 policyIndex;
+	u8 shortRetryCount;
+	u8 longRetryCount;
+	u8 policyFlags;
+	u8 rateRecoveryCount;
+	u8 reserved[3];
+	__le32 rateCountIndices[3];
+} __packed;
+
+struct wsm_set_tx_rate_retry_policy {
+	struct wsm_set_tx_rate_retry_policy_header hdr;
+	struct wsm_set_tx_rate_retry_policy_policy tbl[8];
+} __packed;
+
+static inline int wsm_set_tx_rate_retry_policy(struct cw1200_common *priv,
+				struct wsm_set_tx_rate_retry_policy *arg)
+{
+	size_t size = sizeof(struct wsm_set_tx_rate_retry_policy_header) +
+	    arg->hdr.numTxRatePolicies *
+	    sizeof(struct wsm_set_tx_rate_retry_policy_policy);
+	return wsm_write_mib(priv, WSM_MIB_ID_SET_TX_RATE_RETRY_POLICY, arg,
+			     size);
+}
+
+/* 4.32 SetEtherTypeDataFrameFilter */
+struct wsm_ether_type_filter_hdr {
+	u8 nrFilters;		/* Up to WSM_MAX_FILTER_ELEMENTS */
+	u8 reserved[3];
+} __packed;
+
+struct wsm_ether_type_filter {
+	u8 filterAction;	/* WSM_FILTER_ACTION_XXX */
+	u8 reserved;
+	__le16 etherType;	/* Type of ethernet frame */
+} __packed;
+
+static inline int wsm_set_ether_type_filter(struct cw1200_common *priv,
+				struct wsm_ether_type_filter_hdr *arg)
+{
+	size_t size = sizeof(struct wsm_ether_type_filter_hdr) +
+		arg->nrFilters * sizeof(struct wsm_ether_type_filter);
+	return wsm_write_mib(priv, WSM_MIB_ID_SET_ETHERTYPE_DATAFRAME_FILTER,
+		arg, size);
+}
+
+
+/* 4.33 SetUDPPortDataFrameFilter */
+struct wsm_udp_port_filter_hdr {
+	u8 nrFilters;		/* Up to WSM_MAX_FILTER_ELEMENTS */
+	u8 reserved[3];
+} __packed;
+
+struct wsm_udp_port_filter {
+	u8 filterAction;	/* WSM_FILTER_ACTION_XXX */
+	u8 portType;		/* WSM_FILTER_PORT_TYPE_XXX */
+	__le16 udpPort;		/* Port number */
+} __packed;
+
+static inline int wsm_set_udp_port_filter(struct cw1200_common *priv,
+				struct wsm_udp_port_filter_hdr *arg)
+{
+	size_t size = sizeof(struct wsm_udp_port_filter_hdr) +
+		arg->nrFilters * sizeof(struct wsm_udp_port_filter);
+	return wsm_write_mib(priv, WSM_MIB_ID_SET_UDPPORT_DATAFRAME_FILTER,
+		arg, size);
+}
+
+/* Undocumented MIBs: */
+/* 4.35 P2PDeviceInfo */
+#define D11_MAX_SSID_LEN		(32)
+
+struct wsm_p2p_device_type {
+	__le16 categoryId;
+	u8 oui[4];
+	__le16 subCategoryId;
+} __packed;
+
+struct wsm_p2p_device_info {
+	struct wsm_p2p_device_type primaryDevice;
+	u8 reserved1[3];
+	u8 devNameSize;
+	u8 localDevName[D11_MAX_SSID_LEN];
+	u8 reserved2[3];
+	u8 numSecDevSupported;
+	struct wsm_p2p_device_type secondaryDevices[0];
+} __packed;
+
+/* 4.36 SetWCDMABand - WO */
+struct wsm_cdma_band {
+	u8 WCDMA_Band;
+	u8 reserved[3];
+} __packed;
+
+/* 4.37 GroupTxSequenceCounter - RO */
+struct wsm_group_tx_seq {
+	__le32 bits_47_16;
+	__le16 bits_15_00;
+	__le16 reserved;
+} __packed;
+
+/* 4.39 SetHtProtection - WO */
+#define WSM_DUAL_CTS_PROT_ENB		(1 << 0)
+#define WSM_NON_GREENFIELD_STA		PRESENT(1 << 1)
+#define WSM_HT_PROT_MODE__NO_PROT	(0 << 2)
+#define WSM_HT_PROT_MODE__NON_MEMBER	(1 << 2)
+#define WSM_HT_PROT_MODE__20_MHZ	(2 << 2)
+#define WSM_HT_PROT_MODE__NON_HT_MIXED	(3 << 2)
+#define WSM_LSIG_TXOP_PROT_FULL		(1 << 4)
+#define WSM_LARGE_L_LENGTH_PROT		(1 << 5)
+
+struct wsm_ht_protection {
+	__le32 flags;
+} __packed;
+
+/* 4.40 GPIO Command - R/W */
+#define WSM_GPIO_COMMAND_SETUP	0
+#define WSM_GPIO_COMMAND_READ	1
+#define WSM_GPIO_COMMAND_WRITE	2
+#define WSM_GPIO_COMMAND_RESET	3
+#define WSM_GPIO_ALL_PINS	0xFF
+
+struct wsm_gpio_command {
+	u8 GPIO_Command;
+	u8 pin;
+	__le16 config;
+} __packed;
+
+/* 4.41 TSFCounter - RO */
+struct wsm_tsf_counter {
+	__le64 TSF_Counter;
+} __packed;
+
+/* 4.43 Keep alive period */
+struct wsm_keep_alive_period {
+	__le16 keepAlivePeriod;
+	u8 reserved[2];
+} __packed;
+
+static inline int wsm_keep_alive_period(struct cw1200_common *priv,
+					int period)
+{
+	struct wsm_keep_alive_period arg = {
+		.keepAlivePeriod = __cpu_to_le16(period),
+	};
+	return wsm_write_mib(priv, WSM_MIB_ID_KEEP_ALIVE_PERIOD,
+			&arg, sizeof(arg));
+};
+
+/* BSSID filtering */
+struct wsm_set_bssid_filtering {
+	u8 filter;
+	u8 reserved[3];
+} __packed;
+
+static inline int wsm_set_bssid_filtering(struct cw1200_common *priv,
+					  bool enabled)
+{
+	struct wsm_set_bssid_filtering arg = {
+		.filter = !enabled,
+	};
+	return wsm_write_mib(priv, WSM_MIB_ID_DISABLE_BSSID_FILTER,
+			&arg, sizeof(arg));
+}
+
+/* Multicat filtering - 4.5 */
+struct wsm_multicast_filter {
+	__le32 enable;
+	__le32 numOfAddresses;
+	u8 macAddress[WSM_MAX_GRP_ADDRTABLE_ENTRIES][ETH_ALEN];
+} __packed;
+
+static inline int wsm_set_multicast_filter(struct cw1200_common *priv,
+					   struct wsm_multicast_filter *fp)
+{
+	return wsm_write_mib(priv, WSM_MIB_ID_DOT11_GROUP_ADDRESSES_TABLE,
+			     fp, sizeof(*fp));
+}
+
+/* ARP IPv4 filtering - 4.10 */
+struct wsm_arp_ipv4_filter {
+	__le32 enable;
+	__be32 ipv4Address[WSM_MAX_ARP_IP_ADDRTABLE_ENTRIES];
+} __packed;
+
+static inline int wsm_set_arp_ipv4_filter(struct cw1200_common *priv,
+					  struct wsm_arp_ipv4_filter *fp)
+{
+	return wsm_write_mib(priv, WSM_MIB_ID_ARP_IP_ADDRESSES_TABLE,
+			    fp, sizeof(*fp));
+}
+
+/* P2P Power Save Mode Info - 4.31 */
+struct wsm_p2p_ps_modeinfo {
+	u8	oppPsCTWindow;
+	u8	count;
+	u8	reserved;
+	u8	dtimCount;
+	__le32	duration;
+	__le32	interval;
+	__le32	startTime;
+} __packed;
+
+static inline int wsm_set_p2p_ps_modeinfo(struct cw1200_common *priv,
+					  struct wsm_p2p_ps_modeinfo *mi)
+{
+	return wsm_write_mib(priv, WSM_MIB_ID_P2P_PS_MODE_INFO,
+			     mi, sizeof(*mi));
+}
+
+static inline int wsm_get_p2p_ps_modeinfo(struct cw1200_common *priv,
+					  struct wsm_p2p_ps_modeinfo *mi)
+{
+	return wsm_read_mib(priv, WSM_MIB_ID_P2P_PS_MODE_INFO,
+			    mi, sizeof(*mi));
+}
+
+/* UseMultiTxConfMessage */
+
+static inline int wsm_use_multi_tx_conf(struct cw1200_common *priv,
+					bool enabled)
+{
+	__le32 arg = enabled ? __cpu_to_le32(1) : 0;
+
+	return wsm_write_mib(priv, WSM_MIB_USE_MULTI_TX_CONF,
+			&arg, sizeof(arg));
+}
+
+
+/* 4.26 SetUpasdInformation */
+struct wsm_uapsd_info {
+	__le16 uapsdFlags;
+	__le16 minAutoTriggerInterval;
+	__le16 maxAutoTriggerInterval;
+	__le16 autoTriggerStep;
+};
+
+static inline int wsm_set_uapsd_info(struct cw1200_common *priv,
+				     struct wsm_uapsd_info *arg)
+{
+	return wsm_write_mib(priv, WSM_MIB_ID_SET_UAPSD_INFORMATION,
+				arg, sizeof(*arg));
+}
+
+/* 4.22 OverrideInternalTxRate */
+struct wsm_override_internal_txrate {
+	u8 internalTxRate;
+	u8 nonErpInternalTxRate;
+	u8 reserved[2];
+} __packed;
+
+static inline int wsm_set_override_internal_txrate(struct cw1200_common *priv,
+				     struct wsm_override_internal_txrate *arg)
+{
+	return wsm_write_mib(priv, WSM_MIB_ID_OVERRIDE_INTERNAL_TX_RATE,
+				arg, sizeof(*arg));
+}
+
+/* ******************************************************************** */
+/* WSM TX port control							*/
+
+void wsm_lock_tx(struct cw1200_common *priv);
+void wsm_lock_tx_async(struct cw1200_common *priv);
+bool wsm_flush_tx(struct cw1200_common *priv);
+void wsm_unlock_tx(struct cw1200_common *priv);
+
+/* ******************************************************************** */
+/* WSM / BH API								*/
+
+int wsm_handle_exception(struct cw1200_common *priv, u8 *data, size_t len);
+int wsm_handle_rx(struct cw1200_common *priv, int id, struct wsm_hdr *wsm,
+		  struct sk_buff **skb_p);
+
+/* ******************************************************************** */
+/* wsm_buf API								*/
+
+struct wsm_buf {
+	u8 *begin;
+	u8 *data;
+	u8 *end;
+};
+
+void wsm_buf_init(struct wsm_buf *buf);
+void wsm_buf_deinit(struct wsm_buf *buf);
+
+/* ******************************************************************** */
+/* wsm_cmd API								*/
+
+struct wsm_cmd {
+	spinlock_t lock;
+	int done;
+	u8 *ptr;
+	size_t len;
+	void *arg;
+	int ret;
+	u16 cmd;
+};
+
+/* ******************************************************************** */
+/* WSM TX buffer access							*/
+
+int wsm_get_tx(struct cw1200_common *priv, u8 **data,
+	       size_t *tx_len, int *burst);
+void wsm_txed(struct cw1200_common *priv, u8 *data);
+
+/* ******************************************************************** */
+/* Queue mapping: WSM <---> linux					*/
+/* Linux: VO VI BE BK							*/
+/* WSM:   BE BK VI VO							*/
+
+static inline u8 wsm_queue_id_to_linux(u8 queueId)
+{
+	static const u8 queue_mapping[] = {
+		2, 3, 1, 0
+	};
+	return queue_mapping[queueId];
+}
+
+static inline u8 wsm_queue_id_to_wsm(u8 queueId)
+{
+	static const u8 queue_mapping[] = {
+		3, 2, 0, 1
+	};
+	return queue_mapping[queueId];
+}
+
+#endif /* CW1200_HWIO_H_INCLUDED */
-- 
1.7.9

