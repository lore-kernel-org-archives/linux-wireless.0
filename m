Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB134A4405;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343824; cv=none; b=SEdZkoSoIJ9DIppMO0mUOC7y6gw06ZPDgNjiZCzn0S5/2+TTcwl7WSnyAXHbJacaZXiSEIxDZykvr58AQs0yDKg4EgXii6Js1Mj6RX3H3IVIBIpjJAzG0m6cb1a08KDuAg5mBqbm6/d1XfF34B4oQ03Nb3T2regRPp2w+hfTMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343824; c=relaxed/simple;
	bh=EACSzqpchk5UQkiLJZNHF5JvMOwAbMSQbN3eANIx5to=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h39knuhih5T0/aVTZRXiQFWLjy16rkFfaTCW4fJRQ7NfcqV7sg3ynwov1xMFv4kPBVn62stDvGVfIjHW1G15b226Q0ufaT0ExWog0Q2QbvNzVp44xnSPy8k+6+CFBfFgq2f8oduW8ZjO1SdKUsi+YVcwh2uhdONsc7L9avK0KZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9eY5cFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9eY5cFI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59EF6C2BD01;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790343824;
	bh=EACSzqpchk5UQkiLJZNHF5JvMOwAbMSQbN3eANIx5to=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=S9eY5cFIIv25987yMoffdOnD+rTymbx27FqT+IZpk/KXJ0eJIXdQIk4ZlvYTczUn+
	 kPgThlqwMMUouM3aUP4KGBWBbO7O8uE13EQLifO4v5OYzuvyHiF+qvf3v55Y52Epxw
	 g0Xtse5mVI6JiFsplA0Xt4IBhJGrsfnWUFl/Q45hZtjEPoSLYbvawWNyPXi73nu8Wu
	 qZk5Ko0yWCAmx01fpwDX/I2/c7ymZiJRvPiCx82glsR/grAsX4ci2CfB2b2O4/4bTq
	 +Yl9MpHtY0eBl+U8dohGcJLsdi4HrbduiClt5fJzMAPfNlHfzHLHT/WVlb5maMbGW7
	 j5iZ1hX0ZBrxw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4831FC98321;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Fri, 25 Sep 2026 23:43:40 +1000
Subject: [PATCH 05/13] wifi: brcmfmac: Negotiate PCIe mailbox transport
 with firmware
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-brcm4388-submit-v1-5-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
In-Reply-To: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>, 
 Pieter-Paul Giesberts <pieterpg@broadcom.com>, 
 "Franky Lin (Zhenhui)" <frankyl@broadcom.com>, 
 Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
 brcm80211-dev-list.pdl@broadcom.com, asahi@lists.linux.dev, 
 Hector Martin <marcan@marcan.st>, Daniel Berlin <dberlin@dberlin.org>, 
 Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org, 
 Hante Meuleman <meuleman@broadcom.com>, linux-hardening@vger.kernel.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790343821; l=11852;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=z12uZXAdpCm7fB14uNoxBi8KMK8oCUp0FM3husdGKRw=;
 b=ZI5mPY0E4uj1xvpPSiaj6e+1rfOZalvNvZx/8Y4VfGIc61mwIIMBKya9wJIX0MbZb3iWasZId
 lp3E67RBufcAl+8OV6CcfKUce5scxDTfKoRQZOjih3ECJnJ/bCaSYtb
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Hector Martin <marcan@marcan.st>

Shared protocol version 6 and later allows mailbox messages over the
control ring as an alternative to the shared-memory mailbox.

Advertise host capabilities using the negotiated shared protocol
version. Select the control-ring transport when firmware does not set
BRCMF_PCIE_SHARED_USE_MAILBOX, and dispatch received mailbox data
through bus operations.

Signed-off-by: Hector Martin <marcan@marcan.st>
Co-developed-by: Michael Reeves <michael.reeves077@gmail.com>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  9 +++
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 57 +++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |  5 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 83 ++++++++++++++++++----
 4 files changed, 139 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 9371c14899..421039759b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -86,6 +86,8 @@ struct brcmf_bus_dcmd {
  * @get_ramsize: obtain size of device memory.
  * @get_memdump: obtain device memory dump in provided buffer.
  * @get_blob: obtain a firmware blob.
+ * @d2h_mb_rx: handle device-to-host mailbox data received through a transport
+ *	specific side channel.
  * @remove: initiate unbind of the device.
  *
  * This structure provides an abstract interface towards the
@@ -108,6 +110,7 @@ struct brcmf_bus_ops {
 	void (*debugfs_create)(struct device *dev);
 	int (*reset)(struct device *dev);
 	void (*remove)(struct device *dev);
+	void (*d2h_mb_rx)(struct device *dev, u32 data);
 };
 
 
@@ -292,6 +295,12 @@ static inline void brcmf_bus_remove(struct brcmf_bus *bus)
 	bus->ops->remove(bus->dev);
 }
 
+static inline void brcmf_bus_d2h_mb_rx(struct brcmf_bus *bus, u32 data)
+{
+	if (bus->ops->d2h_mb_rx)
+		bus->ops->d2h_mb_rx(bus->dev, data);
+}
+
 /*
  * interface functions from common layer
  */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 069ba70166..8e5c697e7f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -47,6 +47,8 @@
 #define MSGBUF_TYPE_RX_CMPLT			0x12
 #define MSGBUF_TYPE_LPBK_DMAXFER		0x13
 #define MSGBUF_TYPE_LPBK_DMAXFER_CMPLT		0x14
+#define MSGBUF_TYPE_H2D_MAILBOX_DATA		0x23
+#define MSGBUF_TYPE_D2H_MAILBOX_DATA		0x24
 
 #define NR_TX_PKTIDS				2048
 #define NR_RX_PKTIDS				1024
@@ -218,6 +220,19 @@ struct msgbuf_flowring_flush_resp {
 	__le32				rsvd0[3];
 };
 
+struct msgbuf_h2d_mailbox_data {
+	struct msgbuf_common_hdr	msg;
+	__le32				data;
+	__le32				rsvd0[7];
+};
+
+struct msgbuf_d2h_mailbox_data {
+	struct msgbuf_common_hdr	msg;
+	struct msgbuf_completion_hdr	compl_hdr;
+	__le32				data;
+	__le32				rsvd0[2];
+};
+
 struct brcmf_msgbuf_work_item {
 	struct list_head queue;
 	u32 flowid;
@@ -1319,6 +1334,15 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 	brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 }
 
+static void brcmf_msgbuf_process_d2h_mailbox_data(struct brcmf_msgbuf *msgbuf,
+						  void *buf)
+{
+	struct msgbuf_d2h_mailbox_data *d2h_mb_data = buf;
+
+	brcmf_bus_d2h_mb_rx(msgbuf->drvr->bus_if,
+			    le32_to_cpu(d2h_mb_data->data));
+}
+
 
 static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 {
@@ -1362,6 +1386,10 @@ static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_RX_CMPLT\n");
 		brcmf_msgbuf_process_rx_complete(msgbuf, buf);
 		break;
+	case MSGBUF_TYPE_D2H_MAILBOX_DATA:
+		brcmf_dbg(MSGBUF, "MSGBUF_TYPE_D2H_MAILBOX_DATA\n");
+		brcmf_msgbuf_process_d2h_mailbox_data(msgbuf, buf);
+		break;
 	default:
 		bphy_err(drvr, "Unsupported msgtype %d\n", msg->msgtype);
 		break;
@@ -1500,6 +1528,35 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	}
 }
 
+int brcmf_msgbuf_h2d_mb_write(struct brcmf_pub *drvr, u32 data)
+{
+	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
+	struct brcmf_commonring *commonring;
+	struct msgbuf_h2d_mailbox_data *request;
+	void *ret_ptr;
+	int err;
+
+	commonring = msgbuf->commonrings[BRCMF_H2D_MSGRING_CONTROL_SUBMIT];
+	brcmf_commonring_lock(commonring);
+	ret_ptr = brcmf_commonring_reserve_for_write(commonring);
+	if (!ret_ptr) {
+		bphy_err(drvr, "Failed to reserve space in commonring\n");
+		brcmf_commonring_unlock(commonring);
+		return -ENOMEM;
+	}
+
+	request = (struct msgbuf_h2d_mailbox_data *)ret_ptr;
+	memset(request, 0, sizeof(*request));
+	request->msg.msgtype = MSGBUF_TYPE_H2D_MAILBOX_DATA;
+	request->msg.ifidx = 0xff;
+	request->data = cpu_to_le32(data);
+
+	err = brcmf_commonring_write_complete(commonring);
+	brcmf_commonring_unlock(commonring);
+
+	return err;
+}
+
 #ifdef DEBUG
 static int brcmf_msgbuf_stats_read(struct seq_file *seq, void *data)
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
index 6a849f4a94..18b56d0789 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
@@ -32,12 +32,17 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev);
 void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid);
 int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr);
 void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr);
+int brcmf_msgbuf_h2d_mb_write(struct brcmf_pub *drvr, u32 data);
 #else
 static inline int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 {
 	return 0;
 }
 static inline void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr) {}
+static inline int brcmf_msgbuf_h2d_mb_write(struct brcmf_pub *drvr, u32 data)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif /* BRCMFMAC_MSGBUF_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 5917ee5fd7..ad8567e2b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -219,9 +219,13 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define BRCMF_PCIE_SHARED_VERSION_MASK		0x00FF
 #define BRCMF_PCIE_SHARED_DMA_INDEX		0x10000
 #define BRCMF_PCIE_SHARED_DMA_2B_IDX		0x100000
+#define BRCMF_PCIE_SHARED_USE_MAILBOX		0x2000000
 #define BRCMF_PCIE_SHARED_HOSTRDY_DB1		0x10000000
 #define BRCMF_PCIE_SHARED_DAR			0x80000000
 
+#define BRCMF_HOSTCAP_H2D_ENABLE_HOSTRDY	0x400
+#define BRCMF_HOSTCAP_DS_NO_OOB_DW		0x1000
+#define BRCMF_HOSTCAP_H2D_DAR			0x10000
 
 #define BRCMF_PCIE_FLAGS_HTOD_SPLIT		0x4000
 #define BRCMF_PCIE_FLAGS_DTOH_SPLIT		0x8000
@@ -237,6 +241,8 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define BRCMF_SHARED_DMA_SCRATCH_ADDR_OFFSET	56
 #define BRCMF_SHARED_DMA_RINGUPD_LEN_OFFSET	64
 #define BRCMF_SHARED_DMA_RINGUPD_ADDR_OFFSET	68
+#define BRCMF_SHARED_HOST_CAP_OFFSET		84
+#define BRCMF_SHARED_HOST_CAP2_OFFSET		112
 
 #define BRCMF_RING_H2D_RING_COUNT_OFFSET	0
 #define BRCMF_RING_D2H_RING_COUNT_OFFSET	1
@@ -318,6 +324,7 @@ struct brcmf_pcie_shared_info {
 	void *ringupd;
 	dma_addr_t ringupd_dmahandle;
 	u8 version;
+	bool mb_via_ctl;
 };
 
 #define BRCMF_OTP_MAX_PARAM_LEN 16
@@ -843,6 +850,18 @@ brcmf_pcie_send_mb_data(struct brcmf_pciedev_info *devinfo, u32 htod_mb_data)
 	u32 i;
 
 	shared = &devinfo->shared;
+	if (shared->mb_via_ctl) {
+		struct pci_dev *pdev = devinfo->pdev;
+		struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
+		int ret;
+
+		ret = brcmf_msgbuf_h2d_mb_write(bus->drvr, htod_mb_data);
+		if (ret < 0)
+			brcmf_err(bus, "Failed to send H2D mailbox data (%d)\n",
+				  ret);
+		return ret;
+	}
+
 	addr = shared->htod_mb_data_addr;
 	cur_htod_mb_data = brcmf_pcie_read_tcm32(devinfo, addr);
 
@@ -871,21 +890,9 @@ brcmf_pcie_send_mb_data(struct brcmf_pciedev_info *devinfo, u32 htod_mb_data)
 }
 
 
-static void brcmf_pcie_handle_mb_data(struct brcmf_pciedev_info *devinfo)
+static void brcmf_pcie_handle_mb_data(struct brcmf_pciedev_info *devinfo,
+				      u32 dtoh_mb_data)
 {
-	struct brcmf_pcie_shared_info *shared;
-	u32 addr;
-	u32 dtoh_mb_data;
-
-	shared = &devinfo->shared;
-	addr = shared->dtoh_mb_data_addr;
-	dtoh_mb_data = brcmf_pcie_read_tcm32(devinfo, addr);
-
-	if (!dtoh_mb_data)
-		return;
-
-	brcmf_pcie_write_tcm32(devinfo, addr, 0);
-
 	brcmf_dbg(PCIE, "D2H_MB_DATA: 0x%04x\n", dtoh_mb_data);
 	if (dtoh_mb_data & BRCMF_D2H_DEV_DS_ENTER_REQ)  {
 		brcmf_dbg(PCIE, "D2H_MB_DATA: DEEP SLEEP REQ\n");
@@ -906,6 +913,32 @@ static void brcmf_pcie_handle_mb_data(struct brcmf_pciedev_info *devinfo)
 }
 
 
+static void brcmf_pcie_poll_mb_data(struct brcmf_pciedev_info *devinfo)
+{
+	struct brcmf_pcie_shared_info *shared;
+	u32 addr;
+	u32 dtoh_mb_data;
+
+	shared = &devinfo->shared;
+	addr = shared->dtoh_mb_data_addr;
+	dtoh_mb_data = brcmf_pcie_read_tcm32(devinfo, addr);
+
+	if (!dtoh_mb_data)
+		return;
+
+	brcmf_pcie_write_tcm32(devinfo, addr, 0);
+
+	brcmf_pcie_handle_mb_data(devinfo, dtoh_mb_data);
+}
+
+static void brcmf_pcie_d2h_mb_rx(struct device *dev, u32 data)
+{
+	struct brcmf_bus *bus = dev_get_drvdata(dev);
+	struct brcmf_pciedev *buspub = bus->bus_priv.pcie;
+
+	brcmf_pcie_handle_mb_data(buspub->devinfo, data);
+}
+
 static void brcmf_pcie_bus_console_init(struct brcmf_pciedev_info *devinfo)
 {
 	struct brcmf_pcie_shared_info *shared;
@@ -1042,7 +1075,7 @@ static irqreturn_t brcmf_pcie_isr_thread(int irq, void *arg)
 	if (status) {
 		brcmf_pcie_write_pcie32(devinfo, devinfo->reginfo->mailboxint, status);
 		if (status & devinfo->reginfo->int_fn0)
-			brcmf_pcie_handle_mb_data(devinfo);
+			brcmf_pcie_poll_mb_data(devinfo);
 	}
 	if (devinfo->have_msi || status & devinfo->reginfo->int_d2h_db) {
 		if (devinfo->state == BRCMFMAC_PCIE_STATE_UP)
@@ -1695,6 +1728,7 @@ static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
 	.get_blob = brcmf_pcie_get_blob,
 	.reset = brcmf_pcie_reset,
 	.debugfs_create = brcmf_pcie_debugfs_create,
+	.d2h_mb_rx = brcmf_pcie_d2h_mb_rx,
 };
 
 
@@ -1726,6 +1760,7 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 {
 	struct brcmf_bus *bus = dev_get_drvdata(&devinfo->pdev->dev);
 	struct brcmf_pcie_shared_info *shared;
+	u32 host_cap;
 	u32 addr;
 
 	shared = &devinfo->shared;
@@ -1766,6 +1801,24 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 	addr = sharedram_addr + BRCMF_SHARED_RING_INFO_ADDR_OFFSET;
 	shared->ring_info_addr = brcmf_pcie_read_tcm32(devinfo, addr);
 
+	if (shared->version >= 6) {
+		shared->mb_via_ctl =
+			!(shared->flags & BRCMF_PCIE_SHARED_USE_MAILBOX);
+
+		host_cap = shared->version;
+		if (shared->flags & BRCMF_PCIE_SHARED_HOSTRDY_DB1)
+			host_cap |= BRCMF_HOSTCAP_H2D_ENABLE_HOSTRDY;
+		if (shared->flags & BRCMF_PCIE_SHARED_DAR)
+			host_cap |= BRCMF_HOSTCAP_H2D_DAR;
+		host_cap |= BRCMF_HOSTCAP_DS_NO_OOB_DW;
+
+		brcmf_pcie_write_tcm32(devinfo, sharedram_addr +
+				       BRCMF_SHARED_HOST_CAP_OFFSET,
+				       host_cap);
+		brcmf_pcie_write_tcm32(devinfo, sharedram_addr +
+				       BRCMF_SHARED_HOST_CAP2_OFFSET, 0);
+	}
+
 	brcmf_dbg(PCIE, "max rx buf post %d, rx dataoffset %d\n",
 		  shared->max_rxbufpost, shared->rx_dataoffset);
 

-- 
2.55.0


