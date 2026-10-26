Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993055;
	b=AZD1qAwG+EMT0p8czVN646EB7TGY+fJXdBr70k4i3IPZTPv7kNi8vRo9wWu5FyRSTaGA
	 PbuP/R1Wlpq0iYtK87JDOLRHjnBMINiZXqVi930XjuK7W6zPVMckCOwk+4X3EVIH9Ezos
	 GkFitTOsjS2IxSpGt0Vda8H0WONXVXAvs+EAoW0DOz4ECClh6TskpkU/Q7oJEKpdtKXBQ
	 k1/0wF01w+GkoYrv1sTIl+xQAUSIsFGsmj2AtJI7kMAamL8Qo6PGM33NU6bb8L7X2qynP
	 RXSWvLlZAIJr+OWdnnua+F9WD+woPIDuhKut5bikfslNIWuwzpSkMJZjOcgz5zVNYow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993055;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qov8lUf31PcYBvnZm5x9lod028QGCejgTq+LtVJaKag=;
	b=iY/PwbPaIQfkVETx2tMIlymY7rEZvpvWDEaAKl2vQDibwOCM4y4UW9+5WXwGQjVtZNyS
	 l8ywZ1U7hq2c4mIrJrMwYmrFnQEGhXWyQWUUOczZ8MbyUOfPDWRkhixMiScFlQXAC6DHQ
	 4MCFDu/N7PWOmTC5Cg1AEs3dNk2IuSXt9vc0I/tgO3CMUVAxQq/7W3laXC9gi8y7sMVaH
	 n78UD7wyCTity/QDEQE9z+5fQ0/U1X5QzOcCsp3yd/zpulDoGKcNnYNO4DbR36f2T8r9p
	 0ZW2kjSJbWnhEn+tLRdUsCVlyfxr3dqLFZgqbqklNZivtiAg720rwgUTI9NCOKYCiKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Nt3Ch+Ky;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DF360A2614
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93DF360A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Nt3Ch+Ky
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a01cac8733so1898869b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993054; x=1793597854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qov8lUf31PcYBvnZm5x9lod028QGCejgTq+LtVJaKag=;
        b=Nt3Ch+KyNhPTeirgDKpiXpMtje4l6dITPvFmd197GIZEYGyAGmTvvFLlbbYdmYz265
         ZT6tmO248kztiG/IvjqXWVPP9rmwfD2IJ+qqyRFLwmjD4KN6PP1a1iMC/eEnJV3Mq9ux
         MWQ6Hw0oRRVQMrPv44bcqmjvS9DMzgsH4FBe0O5+5KvHzsuBL1kStZjEalU5fKRdtPM4
         b19cAsZdbffLYeZvODUCvtFu5gP/fCXMWVqsZPTgFYkmHNifl4qa+M0gNYvLc1ghC+e1
         /Xzur52qq1VZeja5kfagZTbH1c6fOIIzSDIy1+MjbZCr6wbnnyDTTXb0g4dvAF9/M6n2
         PwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993054; x=1793597854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qov8lUf31PcYBvnZm5x9lod028QGCejgTq+LtVJaKag=;
        b=HnRwA89LO/WBswiHqKn1owB4fibRa6FYtfDDqiD8zdKIwGa82oQAx5FfKywmeVSEkd
         ru51WDhsZhg1UzF4tmgIAMgAmsJ+I68ROlXtUlyE1yyJgOwxyseKkMFU+imSKCoYRCz2
         rsQQ/O71fcUGGTBqT2KXz5Yeibwjx3zYjZ5eYQc8g4/6ZxWftmqqhTqX8ESKMf/Mc8sK
         wwwvUySGF5tFOWmRvcRdPryZA1mpeJE8eRVBgHZgNo2NJnJYYm9RhhOUwEb6Wzbo9ULO
         P6+efPrTkuM6WdSqDxmiO0bnrdm48/mBakcDQXFA7r2twOM3VyTikAD4Hx0ltXxXs5Ez
         dXbw==
X-Gm-Message-State: AFq9FYJxyD6/EPr9oNVEND6vpOPE/WZXhJEZA6o0z42iNZlSdDLWjvx9
	p0pfxGr49gXW8/4vs+he3R8RwwQzQLZRKjPAGAQ+KXqfV0XsuDRNbWV076WdCXNhjsbnvQ==
X-Gm-Gg: AYBFou2l0ZOwj/Wy371zbV+/lJj9pXbZmy3xv1LpLnFAvWFLcjTzkCCWxU3bz9u7Nl4
	1v88nZaXEDJTwi4yXPx54DyfU/LBUxY9niXbyPz/Ek51QajNyDF2WNAzRYltaoneg9GZDag5v6d
	sz9CGc1743eN3S2IsTaeYc2OPJ0EoVB57w0pPqsFTeel+I6rJ9iiYdSI62fbXTuGtdl849cRK7a
	dBwk6FRoaZ5ybAFBkNRyNpZfKScrNYhhjoPxLzkLHIoQOC/Wfrc25J9xR/07fY44uXY9DcGETAF
	vI+MF0Ykkq9MZ7azm9/hJRroOBPiQCxQTiwEBjfUnK7BmMSpFxUSbMfMRxuFpZN/BiKUrMEtu9p
	KpLqDZrRjidpACQSs6jZvoKUacSi9S3FbDkB+4l7Hg1EjTBTKoVjDMoPis30bvoCjsdvhyzr206
	/cu3bm/wT7Yyzw0o00cJn7L0FFW3esoraDG/MTNxZJRuFu0J46wj7QdSTIKvVQozrUd++phH0lb
	4CRRV3CTMcUlGwNTRtS/2REaoErVb2VmlcerKpZiMwJgjuTJnHkQOPbzvTLvDDa5y3GRBadV2Sh
	0bmv
X-Received: by 2002:a05:6a00:301e:b0:89e:37b1:b81e with SMTP id d2e1a72fcca58-8a367252ab7mr4249701b3a.31.1792993054002;
        Sun, 25 Oct 2026 22:37:34 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:33 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [RFC PATCH wireless-next 12/17] wifi: bcm4323x: add the USB transport and firmware setup
Date: Mon, 26 Oct 2026 13:36:18 +0800
Message-ID: <20261026053633.361454-13-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds the usb side of the driver, enumeration, tx/rx and
firmware. Requires brcm/bcm4323x.bin.

The ID table covers the BCM43231 and BCM4323 adapters of
Belkin, Dynex and Netgear.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../brcm80211/bcm4323x/bcm4323x_core.c        | 545 ++++++++++++++++++
 1 file changed, 545 insertions(+)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_core.c

diff --git a/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_core.c b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_core.c
new file mode 100644
index 000000000..e1a3cdf3b
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_core.c
@@ -0,0 +1,545 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <brcm_usb_rdl.h>
+
+#include "bcm4323x.h"
+
+#define BCM4323X_FW_NAME "brcm/bcm4323x.bin"
+
+#define BCM4323X_REQ_RPC_RESPONSE 9
+#define BCM4323X_REQ_TYPE (USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE)
+#define BCM4323X_DL_VALUE 1
+#define BCM4323X_TIMEOUT_MS 2000
+#define BCM4323X_BOOT_CHIP_ID 0x4322
+
+#define BCM4323X_BOOT_POLL_US 40000
+#define BCM4323X_BOOT_TIMEOUT_US 1200000
+#define BCM4323X_CONTROL_MAX 1928
+#define BCM4323X_IO_SIZE 4096
+#define BCM4323X_RPC_READS 16
+
+union bcm4323x_dl_response {
+	struct rdl_state_le rdl;
+	struct {
+		__le32 chip;
+		__le32 chiprev;
+	} id;
+};
+
+struct bcm4323x_handshake {
+	__le32 version;
+	__le32 chip;
+} __packed;
+
+static int bcm4323x_bulk_transfer(struct bcm4323x *dev, void *buffer, int length, bool *sent)
+{
+	int actual = 0;
+	int ret;
+
+	ret = usb_bulk_msg(dev->udev, dev->tx_pipe, buffer, length, &actual, BCM4323X_TIMEOUT_MS);
+	if (sent)
+		*sent = actual > 0;
+	if (ret)
+		return ret;
+
+	if (!(length % usb_maxpacket(dev->udev, dev->tx_pipe)))
+		return usb_bulk_msg(dev->udev, dev->tx_pipe, NULL, 0, &actual, BCM4323X_TIMEOUT_MS);
+
+	return 0;
+}
+
+/* from brcmfmac: check_file */
+static int bcm4323x_check_file(const struct firmware *fw)
+{
+	const struct trx_header_le *trx = (const void *)fw->data;
+
+	/* Unlike brcmfmac's images, this one is not flagged TRX_UNCOMP_IMAGE. */
+	if (fw->size < sizeof(*trx) || trx->magic != cpu_to_le32(TRX_MAGIC) ||
+	    le32_to_cpu(trx->len) != fw->size)
+		return -EINVAL;
+	return 0;
+}
+
+/* from brcmfmac: brcmf_usb_dl_cmd */
+static int bcm4323x_dl_cmd(struct bcm4323x *dev, u8 cmd, union bcm4323x_dl_response *buffer)
+{
+	return usb_control_msg_recv(dev->udev, 0, cmd, BCM4323X_REQ_TYPE, BCM4323X_DL_VALUE,
+				    dev->intf->cur_altsetting->desc.bInterfaceNumber, buffer,
+				    sizeof(*buffer), BCM4323X_TIMEOUT_MS, GFP_KERNEL);
+}
+
+/* from brcmfmac: brcmf_usb_resetcfg */
+static int bcm4323x_wait_postboot(struct bcm4323x *dev)
+{
+	union bcm4323x_dl_response id;
+	int err;
+
+	/* The bootloader stalls or answers short while the runtime starts. */
+	return poll_timeout_us(err = bcm4323x_dl_cmd(dev, DL_GETVER, &id),
+			       err ? err != -EPIPE && err != -EREMOTEIO :
+				     id.id.chip == cpu_to_le32(BRCMF_POSTBOOT_ID),
+			       BCM4323X_BOOT_POLL_US, BCM4323X_BOOT_TIMEOUT_US, true) ?: err;
+}
+
+/* from brcmfmac: brcmf_usb_dl_writeimage */
+static int bcm4323x_dl_writeimage(struct bcm4323x *dev, const u8 *fw, u32 fwlen)
+{
+	union bcm4323x_dl_response state;
+	u32 rdlstate;
+	u32 sent = 0;
+	int err;
+
+	err = bcm4323x_dl_cmd(dev, DL_START, &state);
+	if (err)
+		return err;
+	if (le32_to_cpu(state.rdl.state) != DL_WAITING)
+		return -EINVAL;
+
+	while (sent < fwlen) {
+		u32 sendlen = min_t(u32, fwlen - sent, TRX_RDL_CHUNK);
+
+		memcpy(dev->io_buffer, fw + sent, sendlen);
+		err = bcm4323x_bulk_transfer(dev, dev->io_buffer, sendlen, NULL);
+		if (err)
+			return err;
+		sent += sendlen;
+
+		err = bcm4323x_dl_cmd(dev, DL_GETSTATE, &state);
+		if (err)
+			return err;
+		rdlstate = le32_to_cpu(state.rdl.state);
+		/*
+		 * Unlike brcmfmac, expect the bytes to be accepted at once, as the
+		 * reference driver does.
+		 */
+		if (rdlstate == DL_BAD_HDR || rdlstate == DL_BAD_CRC ||
+		    le32_to_cpu(state.rdl.bytes) != sent)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+/* from brcmfmac: brcmf_usb_dlrun */
+static int bcm4323x_dlrun(struct bcm4323x *dev)
+{
+	union bcm4323x_dl_response state;
+	int err;
+
+	err = bcm4323x_dl_cmd(dev, DL_GETSTATE, &state);
+	if (err)
+		return err;
+	if (state.rdl.state != cpu_to_le32(DL_RUNNABLE))
+		return -EINVAL;
+
+	err = bcm4323x_dl_cmd(dev, DL_GO, &state);
+	if (err)
+		return err;
+	return bcm4323x_wait_postboot(dev);
+}
+
+/* from brcmfmac: brcmf_usb_fw_download, brcmf_usb_dlneeded */
+static int bcm4323x_fw_download(struct bcm4323x *dev, const struct firmware *fw)
+{
+	union bcm4323x_dl_response id;
+	int err;
+
+	err = bcm4323x_check_file(fw);
+	if (err)
+		return err;
+
+	err = bcm4323x_dl_cmd(dev, DL_GETVER, &id);
+	if (err)
+		return err;
+	if (id.id.chip != cpu_to_le32(BRCMF_POSTBOOT_ID)) {
+		if (id.id.chip != cpu_to_le32(BCM4323X_BOOT_CHIP_ID))
+			return -ENODEV;
+		err = bcm4323x_dl_writeimage(dev, fw->data, fw->size);
+		if (!err)
+			err = bcm4323x_dlrun(dev);
+		if (err)
+			return err;
+	}
+	bcm4323x_dl_cmd(dev, DL_RESETCFG, &id);
+	return 0;
+}
+
+/*
+ * Reads the response to a control procedure, skipping the responses to other
+ * procedures that the dongle kept, and copies the start of its body, if any.
+ */
+static int bcm4323x_rpc_response_locked(struct bcm4323x *dev, u32 procedure, void *response,
+					size_t response_length)
+{
+	const struct bcm4323x_rpc_header *rpc = (void *)dev->io_buffer;
+	u8 interface = dev->intf->cur_altsetting->desc.bInterfaceNumber;
+	unsigned int reads;
+	size_t length;
+	int ret;
+
+	lockdep_assert_held(&dev->io_mutex);
+	for (reads = 0; reads < BCM4323X_RPC_READS; reads++) {
+		ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
+				      BCM4323X_REQ_RPC_RESPONSE, BCM4323X_REQ_TYPE, 0, interface,
+				      dev->io_buffer, BCM4323X_CONTROL_MAX,
+				      BCM4323X_TIMEOUT_MS);
+		if (ret < 0)
+			return ret;
+		if (ret < sizeof(*rpc))
+			return -EPROTO;
+
+		length = le32_to_cpu(rpc->length) + sizeof(rpc->length);
+		if (length < sizeof(*rpc) || length > ret ||
+		    FIELD_GET(BCM4323X_RPC_CLASS_MASK, le32_to_cpu(rpc->xid_class)) !=
+			    BCM4323X_RPC_CLASS_CONTROL)
+			return -EPROTO;
+		if (le32_to_cpu(rpc->procedure) != procedure) {
+			dev_dbg(&dev->intf->dev, "skipped response to RPC 0x%x\n",
+				le32_to_cpu(rpc->procedure));
+			continue;
+		}
+		if (!response)
+			return 0;
+		if (length - sizeof(*rpc) < response_length)
+			return -EPROTO;
+		memcpy(response, rpc + 1, response_length);
+		return 0;
+	}
+	return -EPROTO;
+}
+
+static int bcm4323x_rpc_transact(struct bcm4323x *dev, u8 rpc_class, u32 procedure,
+				 const void *body, size_t body_length, void *response,
+				 size_t response_length)
+{
+	struct bcm4323x_rpc_header *rpc;
+	bool sent;
+	int ret;
+
+	if (body_length > BCM4323X_IO_SIZE - sizeof(*rpc))
+		return -EMSGSIZE;
+	if (READ_ONCE(dev->dead))
+		return -ENODEV;
+
+	mutex_lock(&dev->io_mutex);
+	rpc = (void *)dev->io_buffer;
+	rpc->length = bcm4323x_rpc_length(body_length);
+	rpc->xid_class = bcm4323x_rpc_xid_class(rpc_class, dev->rpc_xid);
+	rpc->procedure = cpu_to_le32(procedure);
+	memcpy(rpc + 1, body, body_length);
+	ret = bcm4323x_bulk_transfer(dev, dev->io_buffer, sizeof(*rpc) + body_length, &sent);
+	if (sent)
+		dev->rpc_xid++;
+	if (!ret && rpc_class == BCM4323X_RPC_CLASS_CONTROL)
+		ret = bcm4323x_rpc_response_locked(dev, procedure, response, response_length);
+	mutex_unlock(&dev->io_mutex);
+	return ret;
+}
+
+int bcm4323x_rpc_send(struct bcm4323x *dev, u32 procedure, const void *body, size_t body_length)
+{
+	return bcm4323x_rpc_transact(dev, BCM4323X_RPC_CLASS_DATA, procedure, body, body_length,
+				     NULL, 0);
+}
+
+int bcm4323x_rpc_call(struct bcm4323x *dev, u32 procedure, const void *body, size_t body_length,
+		      void *response, size_t response_length)
+{
+	return bcm4323x_rpc_transact(dev, BCM4323X_RPC_CLASS_CONTROL, procedure, body,
+				     body_length, response, response_length);
+}
+
+static int bcm4323x_handshake_step(struct bcm4323x *dev, u32 procedure, __le32 chip)
+{
+	struct bcm4323x_handshake body = {
+		.version = cpu_to_le32(BCM4323X_RPC_VERSION),
+		.chip = chip,
+	};
+	int ret;
+
+	reinit_completion(&dev->handshake_done);
+	ret = bcm4323x_rpc_transact(dev, BCM4323X_RPC_CLASS_TRANSPORT, procedure, &body,
+				    sizeof(body), NULL, 0);
+	if (ret)
+		return ret;
+	if (!wait_for_completion_timeout(&dev->handshake_done,
+					 msecs_to_jiffies(BCM4323X_TIMEOUT_MS)))
+		return -ETIMEDOUT;
+	/* VERSION sends no chip ID, and CHIP the one that the VERSION reply carried. */
+	if (!dev->handshake_chip || (chip && dev->handshake_chip != chip))
+		return -EPROTO;
+	return 0;
+}
+
+/* Reset the runtime firmware to its initialized state. */
+static int bcm4323x_init_firmware(struct bcm4323x *dev)
+{
+	int ret;
+
+	ret = bcm4323x_start_rx_urbs(dev);
+	if (ret)
+		return ret;
+	ret = bcm4323x_handshake_step(dev, BCM4323X_RPC_PROC_VERSION, 0);
+	if (!ret)
+		ret = bcm4323x_handshake_step(dev, BCM4323X_RPC_PROC_CHIP, dev->handshake_chip);
+
+	dev->rpc_xid = 0;
+	if (!ret)
+		ret = bcm4323x_init_mac(dev);
+	bcm4323x_kill_rx_urbs(dev);
+	if (!ret && READ_ONCE(dev->dead))
+		ret = -EIO;
+	return ret;
+}
+
+void bcm4323x_kill_rx_urbs(struct bcm4323x *dev)
+{
+	unsigned int index;
+
+	for (index = 0; index < BCM4323X_RX_URBS; index++)
+		usb_kill_urb(dev->rx_urbs[index]);
+}
+
+int bcm4323x_start_rx_urbs(struct bcm4323x *dev)
+{
+	unsigned int index;
+	int ret;
+
+	for (index = 0; index < BCM4323X_RX_URBS; index++) {
+		ret = usb_submit_urb(dev->rx_urbs[index], GFP_KERNEL);
+		if (ret) {
+			bcm4323x_kill_rx_urbs(dev);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int bcm4323x_alloc_transport(struct bcm4323x *dev)
+{
+	struct usb_endpoint_descriptor *bulk_in;
+	struct usb_endpoint_descriptor *bulk_out;
+	unsigned int rx_pipe;
+	unsigned int index;
+
+	if (usb_find_common_endpoints_reverse(dev->intf->cur_altsetting, &bulk_in, &bulk_out,
+					      NULL, NULL))
+		return -ENODEV;
+	dev->tx_pipe = usb_sndbulkpipe(dev->udev, bulk_out->bEndpointAddress);
+	dev->io_buffer = devm_kmalloc(&dev->intf->dev, BCM4323X_IO_SIZE, GFP_KERNEL);
+	if (!dev->io_buffer)
+		return -ENOMEM;
+
+	rx_pipe = usb_rcvbulkpipe(dev->udev, bulk_in->bEndpointAddress);
+	for (index = 0; index < BCM4323X_RX_URBS; index++) {
+		struct urb *urb = usb_alloc_urb(0, GFP_KERNEL);
+		void *buffer;
+
+		if (!urb)
+			return -ENOMEM;
+		dev->rx_urbs[index] = urb;
+		buffer = kmalloc(BCM4323X_RX_SIZE, GFP_KERNEL);
+		if (!buffer)
+			return -ENOMEM;
+		usb_fill_bulk_urb(urb, dev->udev, rx_pipe, buffer, BCM4323X_RX_SIZE,
+				  bcm4323x_rx_complete, dev);
+		urb->transfer_flags = URB_FREE_BUFFER;
+	}
+	return 0;
+}
+
+static void bcm4323x_free_transport(struct bcm4323x *dev)
+{
+	unsigned int index;
+
+	for (index = 0; index < BCM4323X_RX_URBS; index++)
+		usb_free_urb(dev->rx_urbs[index]);
+}
+
+struct bcm4323x_reprobe {
+	struct work_struct work;
+	struct device *dev;
+};
+
+static void bcm4323x_reprobe_work(struct work_struct *work)
+{
+	struct bcm4323x_reprobe *reprobe = container_of(work, struct bcm4323x_reprobe, work);
+	int ret;
+
+	ret = device_reprobe(reprobe->dev);
+	if (ret)
+		dev_err(reprobe->dev, "reprobe failed: %d\n", ret);
+	put_device(reprobe->dev);
+	kfree(reprobe);
+	module_put(THIS_MODULE);
+}
+
+/* Reprobe the device in case the firmware stalls */
+void bcm4323x_fatal_error(struct bcm4323x *dev)
+{
+	struct bcm4323x_reprobe *reprobe;
+
+	if (xchg(&dev->dead, true))
+		return;
+
+	wake_up_all(&dev->tx_wait);
+	if (!READ_ONCE(dev->running))
+		return;
+	ieee80211_stop_queues(dev->hw);
+
+	if (!try_module_get(THIS_MODULE))
+		return;
+	reprobe = kzalloc_obj(*reprobe, GFP_ATOMIC);
+	if (!reprobe) {
+		module_put(THIS_MODULE);
+		return;
+	}
+	INIT_WORK(&reprobe->work, bcm4323x_reprobe_work);
+	reprobe->dev = get_device(&dev->intf->dev);
+	queue_work(system_long_wq, &reprobe->work);
+}
+
+static int bcm4323x_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	const struct bcm4323x_chip *chip = (const void *)id->driver_info;
+	struct ieee80211_hw *hw;
+	struct bcm4323x *dev;
+	const char *stage;
+	const struct firmware *firmware = NULL;
+	int ret;
+
+	hw = ieee80211_alloc_hw(sizeof(*dev), &bcm4323x_ops);
+	if (!hw)
+		return -ENOMEM;
+	dev = hw->priv;
+	dev->hw = hw;
+	dev->chip = chip;
+	dev->udev = interface_to_usbdev(intf);
+	dev->intf = intf;
+	mutex_init(&dev->io_mutex);
+	init_completion(&dev->handshake_done);
+	bcm4323x_init_tx(dev);
+	usb_set_intfdata(intf, hw);
+
+	stage = "transport allocation";
+	ret = bcm4323x_alloc_transport(dev);
+	if (ret)
+		goto error;
+	stage = "firmware request";
+	ret = request_firmware(&firmware, BCM4323X_FW_NAME, &intf->dev);
+	if (ret)
+		goto error;
+	stage = "firmware activation";
+	ret = bcm4323x_fw_download(dev, firmware);
+	if (ret)
+		goto error;
+	stage = "runtime initialization";
+	ret = bcm4323x_init_firmware(dev);
+	if (ret)
+		goto error;
+
+	stage = "mac80211 registration";
+	ret = bcm4323x_register_hw(dev);
+	if (ret)
+		goto error;
+	bcm4323x_led_register(dev);
+
+	dev_info(&intf->dev, "BCM4323x RPC mac80211 device ready, MAC %pM\n", hw->wiphy->perm_addr);
+	release_firmware(firmware);
+	return 0;
+
+error:
+	release_firmware(firmware);
+	bcm4323x_free_transport(dev);
+	ieee80211_free_hw(hw);
+	return dev_err_probe(&intf->dev, ret, "%s failed\n", stage);
+}
+
+static void bcm4323x_disconnect(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct bcm4323x *dev = hw->priv;
+
+	bcm4323x_led_unregister(dev);
+	ieee80211_unregister_hw(hw);
+	bcm4323x_free_transport(dev);
+	ieee80211_free_hw(hw);
+}
+
+static int bcm4323x_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	return 0;
+}
+
+static int bcm4323x_resume(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct bcm4323x *dev = hw->priv;
+	int ret;
+
+	if (READ_ONCE(dev->dead))
+		return 0;
+	ret = bcm4323x_rpc_call(dev, BCM4323X_RPC_PROC_WATCHDOG, NULL, 0, NULL, 0);
+	if (ret) {
+		dev_err(&intf->dev, "firmware lost during suspend: %d\n", ret);
+		WRITE_ONCE(dev->dead, true);
+		intf->needs_binding = 1;
+	}
+	return 0;
+}
+
+static const struct bcm4323x_chip bcm43231_chip = { };
+
+static const struct bcm4323x_chip wna3100_chip = {
+	.has_wps_button = true,
+};
+
+static const struct bcm4323x_chip bcm4323_chip = {
+	.has_5ghz = true,
+};
+
+static const struct bcm4323x_chip f9l1101_chip = {
+	.has_5ghz = true,
+	.channel_data_2ghz = { 0x58, 0x44, 0x3c },
+	.has_wps_led = true,
+	.has_wps_button = true,
+};
+
+static const struct usb_device_id bcm4323x_id_table[] = {
+	/* Belkin Double N+ Wireless USB Adapter */
+	{ USB_DEVICE(0x050d, 0x6050), .driver_info = (kernel_ulong_t)&bcm4323_chip },
+	/* Belkin F7D4101/F9L1101v1 */
+	{ USB_DEVICE(0x050d, 0x615a), .driver_info = (kernel_ulong_t)&f9l1101_chip },
+	/* Belkin N+ Wireless USB Adapter */
+	{ USB_DEVICE(0x050d, 0x825c), .driver_info = (kernel_ulong_t)&bcm4323_chip },
+	/* Dynex DX-NUSB */
+	{ USB_DEVICE(0x050d, 0xd321), .driver_info = (kernel_ulong_t)&bcm43231_chip },
+	/* Netgear WNDA3100v2 */
+	{ USB_DEVICE(0x0846, 0x9011), .driver_info = (kernel_ulong_t)&bcm4323_chip },
+	/* Netgear WNA3100 */
+	{ USB_DEVICE(0x0846, 0x9020), .driver_info = (kernel_ulong_t)&wna3100_chip },
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, bcm4323x_id_table);
+
+static struct usb_driver bcm4323x_driver = {
+	.name = KBUILD_MODNAME,
+	.probe = bcm4323x_probe,
+	.disconnect = bcm4323x_disconnect,
+	.suspend = bcm4323x_suspend,
+	.resume = bcm4323x_resume,
+	.id_table = bcm4323x_id_table,
+	.soft_unbind = 1,
+};
+module_usb_driver(bcm4323x_driver);
+
+MODULE_AUTHOR("Ragul Balaji <ragulbaby@gmail.com>");
+MODULE_AUTHOR("Ho Jie Feng <hjf3108@gmail.com>");
+MODULE_DESCRIPTION("Broadcom BCM4323x USB mac80211 driver");
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(BCM4323X_FW_NAME);
-- 
2.53.0

