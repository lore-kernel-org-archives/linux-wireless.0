Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB404A9D6C
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367969; cv=none; b=s75ETRw43ap2WzG/08PD+5tjb9x0dGKkmjbqASuD+g/R6WPA7e5iIc8cGd1+LfVVAmpiMJ5gTXeXCpN1+dEj7UN48KZ/6gEV3CJ0DXj/m3uybgTGrUE1sy8NOkxbz1ZjfWwVfHyQYinnU10QacjKaMD/GWxjTX8v1w2ahOvQl/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367969; c=relaxed/simple;
	bh=l5+mlkDXriXJoBxnCK5XJs12SsX41hjI9P9yamlIMpo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KGeBVRluu/cQibHJ4MJHDPU/msqcC9QCIzB+KWYwVNhbt836t4ph/HT+bEQB8NM+NDIwQ+GPaIXwyduKq+Z4L8sQ8yfUrw49Z6HjkbW/HUs4xabMWNym7hg8OlOz7i3s0i687EaKXHv4hZZH2wJNxZJ/hLPccJXvdQCaJhW/r2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=ZxZDjGzy; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="ZxZDjGzy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788367967; x=1819903967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l5+mlkDXriXJoBxnCK5XJs12SsX41hjI9P9yamlIMpo=;
  b=ZxZDjGzysrSiXxyHzabiwRohCSbm/HS6f3PamCfP6z3+7BLai+oXhnGd
   /fCJi+I4U7ggqTL4Yq/hectaRShJu/Y3icd9H15qo5k9tWzK/5FY1wPKM
   uzu+rMQvpevWg5X4luPZxlkR5hwhLjfZaUfYWFlaW6//RMYCjpYr2gvEU
   g=;
X-CSE-ConnectionGUID: EA16uc9LSL2RoFAE7jM7ag==
X-CSE-MsgGUID: rSvDn3ipSdOHhTTDugjh1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="145161140"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="145161140"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE805.infineon.com) ([172.23.29.31])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:52:44 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:52:44 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:52:42 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 07/25] wifi: inffmac: add icdc.c/h
Date: Wed, 2 Sep 2026 16:50:38 +0000
Message-ID: <20260902165057.456447-8-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
 MUCSE827.infineon.com (172.23.29.20)

Driver implementation of the ICDC protocol used for the Control and Data
communication with Infineon's Chipsets that have the Connectivity processor
(CP) architecture like the CYW5591x sub-family of chipsets, using SDIO.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 drivers/net/wireless/infineon/inffmac/icdc.c | 346 +++++++++++++++++++
 drivers/net/wireless/infineon/inffmac/icdc.h |  29 ++
 2 files changed, 375 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/icdc.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/icdc.h

diff --git a/drivers/net/wireless/infineon/inffmac/icdc.c b/drivers/net/wireless/infineon/inffmac/icdc.c
new file mode 100644
index 000000000000..eb4eec880146
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/icdc.c
@@ -0,0 +1,346 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+/*******************************************************************************
+ * Communicates with the dongle by using dcmd (CP and FW) codes.
+ * For certain dcmd codes, the dongle interprets string data from the host.
+ ******************************************************************************/
+
+#include <linux/types.h>
+#include <linux/netdevice.h>
+
+#include "main.h"
+#include "chip_cyw5591x.h"
+#include "net.h"
+#include "utils.h"
+#include "fwsignal.h"
+#include "debug.h"
+#include "bus_proto.h"
+#include "icdc.h"
+
+struct inff_proto_icdc_dcmd {
+	__le32 cmd;	/* dongle command value */
+	__le32 len;	/* lower 16: output buflen;
+			 * upper 16: input buflen (excludes header)
+			 */
+	__le32 flags;	/* flag defns given below */
+	__le32 status;	/* status code returned from the device */
+	unsigned char ioc_key[ICDC_GCM_KEY_SIZE_BYTES];	/* key used for ioc enc */
+	unsigned char ioc_iv[ICDC_GCM_IV_SIZE];	/* enc field */
+	unsigned char padding[4]; /* pad to match CP firmware dcmd header layout */
+};
+
+/* ICDC flag definitions */
+#define ICDC_DCMD_ERROR		0x01		/* 1=cmd failed */
+#define ICDC_DCMD_SET		0x02		/* 0=get, 1=set cmd */
+#define ICDC_DCMD_IF_MASK	0xF000		/* I/F index */
+#define ICDC_DCMD_IF_SHIFT	12
+#define ICDC_DCMD_ID_MASK	0xFFFF0000	/* id an cmd pairing */
+#define ICDC_DCMD_ID_SHIFT	16		/* ID Mask shift bits */
+#define ICDC_DCMD_ID(flags)	\
+	(((flags) & ICDC_DCMD_ID_MASK) >> ICDC_DCMD_ID_SHIFT)
+
+/*
+ * ICDC header - Infineon specific extension of CDC.
+ * Used on data packets to convey priority.
+ */
+#define	ICDC_HEADER_LEN		4
+#define ICDC_HEADER_LEN_RSV	8
+#define ICDC_PROTO_VER		2	/* Protocol version */
+#define ICDC_FLAG_VER_SHIFT	4	/* Protocol version shift */
+
+#define RETRIES 2 /* # of retries to retrieve matching dcmd response */
+#define BUS_HEADER_LEN	(16 + 64)	/* Must be at least SDPCM_RESERVE
+					 * (amount of header tha might be added)
+					 * plus any space that might be needed
+					 * for bus alignment padding.
+					 */
+#define ROUND_UP_MARGIN 2048
+
+struct inff_icdc {
+	u16 reqid;
+	u8 bus_header[BUS_HEADER_LEN];
+	struct inff_proto_icdc_dcmd msg;
+	unsigned char buf[INFF_DCMD_MAXLEN];
+};
+
+static int
+inff_proto_icdc_msg(struct inff_pub *drvr, int ifidx, uint cmd, void *buf,
+		    uint len, bool set)
+{
+	struct inff_icdc *icdc = (struct inff_icdc *)drvr->proto->pd;
+	struct inff_proto_icdc_dcmd *msg = &icdc->msg;
+	u32 flags;
+
+	memset(msg, 0, sizeof(struct inff_proto_icdc_dcmd));
+
+	msg->cmd = cpu_to_le32(cmd);
+	msg->len = cpu_to_le32(len);
+	flags = (++icdc->reqid << ICDC_DCMD_ID_SHIFT);
+
+	flags = (ICDC_PROTO_VER << ICDC_FLAG_VER_SHIFT);
+	flags |= (++icdc->reqid << ICDC_DCMD_ID_SHIFT);
+
+	if (set)
+		flags |= ICDC_DCMD_SET;
+	flags = (flags & ~ICDC_DCMD_IF_MASK) |
+		(ifidx << ICDC_DCMD_IF_SHIFT);
+	msg->flags = cpu_to_le32(flags);
+
+	if (buf)
+		memcpy(icdc->buf, buf, len);
+
+	len += sizeof(*msg);
+	if (len > INFF_TX_IOCTL_MAX_MSG_SIZE)
+		len = INFF_TX_IOCTL_MAX_MSG_SIZE;
+
+	/* wait for 50ms when the payload spans more than one SDIO block. */
+	if ((len / SDIO_INF55900_FUNC2_BLOCKSIZE) > 1)
+		msleep(50);
+
+	/* Send request */
+	return inff_bus_txctl(drvr->bus_if, (unsigned char *)&icdc->msg, len);
+}
+
+static int
+inff_proto_icdc_cmplt(struct inff_pub *drvr, u32 id, u32 len)
+{
+	int ret;
+	struct inff_icdc *icdc = (struct inff_icdc *)drvr->proto->pd;
+
+	len += sizeof(struct inff_proto_icdc_dcmd);
+	do {
+		ret = inff_bus_rxctl(drvr->bus_if, (unsigned char *)&icdc->msg,
+				     len);
+		if (ret < 0)
+			break;
+	} while (ICDC_DCMD_ID(le32_to_cpu(icdc->msg.flags)) != id);
+
+	return ret;
+}
+
+static int
+inff_proto_icdc_query_dcmd(struct inff_pub *drvr, int ifidx, uint cmd,
+			   void *buf, uint len, int *err)
+{
+	struct inff_icdc *icdc = (struct inff_icdc *)drvr->proto->pd;
+	struct inff_proto_icdc_dcmd *msg = &icdc->msg;
+	void *info;
+	int ret = 0, retries = 0;
+	u32 id, flags;
+
+	*err = 0;
+	ret = inff_proto_icdc_msg(drvr, ifidx, cmd, buf, len, false);
+	if (ret < 0) {
+		iphy_err(drvr, "inff_proto_icdc_msg failed w/status %d\n",
+			 ret);
+		goto done;
+	}
+
+retry:
+	/* wait for interrupt and get first fragment */
+	ret = inff_proto_icdc_cmplt(drvr, icdc->reqid, len);
+	if (ret < 0)
+		goto done;
+
+	flags = le32_to_cpu(msg->flags);
+	id = (flags & ICDC_DCMD_ID_MASK) >> ICDC_DCMD_ID_SHIFT;
+
+	if (id < icdc->reqid && (++retries < RETRIES))
+		goto retry;
+	if (id != icdc->reqid) {
+		iphy_err(drvr, "%s: unexpected request id %d (expected %d)\n",
+			 inff_ifname(inff_get_ifp(drvr, ifidx)), id,
+			 icdc->reqid);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/* Check info buffer */
+	info = (void *)&icdc->buf[0];
+
+	/* Copy info buffer */
+	if (buf) {
+		if (ret < (int)len)
+			len = ret;
+		memcpy(buf, info, len);
+	}
+
+	ret = 0;
+
+	/* Check the ERROR flag */
+	if (flags & ICDC_DCMD_ERROR)
+		*err = le32_to_cpu(msg->status);
+done:
+	return ret;
+}
+
+static int
+inff_proto_icdc_query_cpcmd(struct inff_pub *drvr, int ifidx, uint cmd,
+			    void *buf, uint len, int *cperr)
+{
+	inff_dbg(ICDC, "cmd %d len %d\n", cmd, len);
+
+	cmd = (CMD_TYPE_CP << CMD_TYPE_SHIFT) | cmd;
+
+	return inff_proto_icdc_query_dcmd(drvr, ifidx, cmd,
+					  buf, len, cperr);
+}
+
+static int
+inff_proto_icdc_query_fwcmd(struct inff_pub *drvr, int ifidx, uint cmd,
+			    void *buf, uint len, int *fwerr)
+{
+	inff_dbg(ICDC, "cmd %d len %d\n", cmd, len);
+
+	cmd = (CMD_TYPE_WL << CMD_TYPE_SHIFT) | cmd;
+
+	return inff_proto_icdc_query_dcmd(drvr, ifidx, cmd,
+					  buf, len, fwerr);
+}
+
+static int
+inff_proto_icdc_set_dcmd(struct inff_pub *drvr, int ifidx, uint cmd,
+			 void *buf, uint len, int *err)
+{
+	struct inff_icdc *icdc = (struct inff_icdc *)drvr->proto->pd;
+	struct inff_proto_icdc_dcmd *msg = &icdc->msg;
+	int ret;
+	u32 flags, id;
+
+	inff_dbg(ICDC, "cmd %d len %d\n", cmd, len);
+
+	*err = 0;
+	ret = inff_proto_icdc_msg(drvr, ifidx, cmd, buf, len, true);
+	if (ret < 0)
+		goto done;
+
+	ret = inff_proto_icdc_cmplt(drvr, icdc->reqid, len);
+	if (ret < 0)
+		goto done;
+
+	flags = le32_to_cpu(msg->flags);
+	id = (flags & ICDC_DCMD_ID_MASK) >> ICDC_DCMD_ID_SHIFT;
+
+	if (id != icdc->reqid) {
+		iphy_err(drvr, "%s: unexpected request id %d (expected %d)\n",
+			 inff_ifname(inff_get_ifp(drvr, ifidx)), id,
+			 icdc->reqid);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	ret = 0;
+
+	/* Check the ERROR flag */
+	if (flags & ICDC_DCMD_ERROR)
+		*err = le32_to_cpu(msg->status);
+
+done:
+	return ret;
+}
+
+static int
+inff_proto_icdc_set_cpcmd(struct inff_pub *drvr, int ifidx, uint cmd,
+			  void *buf, uint len, int *cperr)
+{
+	inff_dbg(ICDC, "cmd %d len %d\n", cmd, len);
+
+	cmd = (CMD_TYPE_CP << CMD_TYPE_SHIFT) | cmd;
+
+	return inff_proto_icdc_set_dcmd(drvr, ifidx, cmd,
+					buf, len, cperr);
+}
+
+static int
+inff_proto_icdc_set_fwcmd(struct inff_pub *drvr, int ifidx, uint cmd,
+			  void *buf, uint len, int *fwerr)
+{
+	inff_dbg(ICDC, "cmd %d len %d\n", cmd, len);
+
+	cmd = (CMD_TYPE_WL << CMD_TYPE_SHIFT) | cmd;
+
+	return inff_proto_icdc_set_dcmd(drvr, ifidx, cmd,
+					buf, len, fwerr);
+}
+
+static int
+inff_proto_icdc_tx_queue_data(struct inff_pub *drvr, int ifidx,
+			      struct sk_buff *skb)
+{
+	return inff_proto_txdata(drvr, ifidx, 0, skb);
+}
+
+static int
+inff_proto_icdc_txdata(struct inff_pub *drvr, int ifidx, u8 offset,
+		       struct sk_buff *pktbuf)
+{
+	return inff_bus_txdata(drvr->bus_if, pktbuf);
+}
+
+static void
+inff_proto_icdc_configure_addr_mode(struct inff_pub *drvr, int ifidx,
+				    enum proto_addr_mode addr_mode)
+{
+}
+
+static void
+inff_proto_icdc_delete_peer(struct inff_pub *drvr, int ifidx,
+			    u8 peer[ETH_ALEN])
+{
+}
+
+static void
+inff_proto_icdc_debugfs_create(struct inff_pub *drvr)
+{
+}
+
+int
+inff_proto_icdc_attach(struct inff_pub *drvr)
+{
+	struct inff_icdc *icdc;
+
+	icdc = kzalloc_obj(*icdc, GFP_ATOMIC);
+	if (!icdc)
+		goto fail;
+
+	/* ensure that the msg buf directly follows the cdc msg struct */
+	if ((unsigned long)(&icdc->msg + 1) != (unsigned long)icdc->buf) {
+		iphy_err(drvr, "struct inff_proto_icdc is not correctly defined\n");
+		goto fail;
+	}
+
+	drvr->proto->query_cpcmd = inff_proto_icdc_query_cpcmd;
+	drvr->proto->set_cpcmd = inff_proto_icdc_set_cpcmd;
+	drvr->proto->query_fwcmd = inff_proto_icdc_query_fwcmd;
+	drvr->proto->set_fwcmd = inff_proto_icdc_set_fwcmd;
+	drvr->proto->tx_queue_data = inff_proto_icdc_tx_queue_data;
+	drvr->proto->txdata = inff_proto_icdc_txdata;
+	drvr->proto->configure_addr_mode = inff_proto_icdc_configure_addr_mode;
+	drvr->proto->delete_peer = inff_proto_icdc_delete_peer;
+	drvr->proto->debugfs_create = inff_proto_icdc_debugfs_create;
+	drvr->proto->pd = icdc;
+
+	drvr->hdrlen += ICDC_HEADER_LEN + ICDC_HEADER_LEN_RSV;
+	drvr->bus_if->maxctl = INFF_DCMD_MAXLEN +
+			sizeof(struct inff_proto_icdc_dcmd) + ROUND_UP_MARGIN;
+	return 0;
+
+fail:
+	kfree(icdc);
+	return -ENOMEM;
+}
+
+void
+inff_proto_icdc_detach(struct inff_pub *drvr)
+{
+	struct inff_icdc *icdc = drvr->proto->pd;
+
+	drvr->proto->pd = NULL;
+	kfree(icdc);
+}
diff --git a/drivers/net/wireless/infineon/inffmac/icdc.h b/drivers/net/wireless/infineon/inffmac/icdc.h
new file mode 100644
index 000000000000..df870e52a99b
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/icdc.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_ICDC_H
+#define INFF_ICDC_H
+
+#define ICDC_PROTO_ENC             (0x01)
+#define ICDC_IOC_ENC_MASK          (0x200)
+#define ICDC_IOC_ENC_SHIFT         (0x09)
+
+#define ICDC_DAT_ENC_MASK          (0x20)
+#define ICDC_DAT_ENC_SHIFT         (0x05)
+
+#define ICDC_GCM_KEY_SIZE_BYTES    (16)
+#define ICDC_GCM_IV_SIZE           (12)
+
+int inff_proto_icdc_attach(struct inff_pub *drvr);
+void inff_proto_icdc_detach(struct inff_pub *drvr);
+void inff_proto_icdc_txflowblock(struct device *dev, bool state);
+void inff_icdc_process_event(struct device *dev, struct sk_buff *skb);
+struct sk_buff *inff_icdc_rx(struct device *dev, struct sk_buff *skb,
+			     bool handle_event, bool inirq);
+
+#endif /* INFF_ICDC_H */
-- 
2.43.0

