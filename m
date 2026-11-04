Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793810772;
	b=WsRJ6WqllrfPsa+0XZpJJgdx0DPP6uYUPBnpAZ6h3qdf0/ysX67ceH5gxSOo24G99R4M
	 q+d+D3D8w5Qypcqrs6MaVwxv43UnF/FW49CfN2i2eJDB3BvQhbU8Zy762m3Pul+kJTVlH
	 JpGOTNcdrpqlEWrMetlmLMYB36wLgePeaPV5Cku8PFK7iU8X1MpTOLTDESXC5lydC2VzN
	 PJA3f8ZVamqqpAqncMB0n0C4UiBd/6LmYGoAxClOfGX6wO2GiuiSQ96/1/cKmGGxDKep7
	 EOs5x5ELqVW45TFSUNPUu77o2iTqETN+kDDIp1CaBQHGjhItIo6brQ85PkvVTBFzn2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810772;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=JfRW0SPoALVVWDl2xAXTfh37dfRQmby6sb8WYvVZUog=;
	b=1LwIvpLuFFfJMKXvN7fprJMkMpfSOmtReVWXMppoXFHbsDJrkUpbWh2Bfxd+HeNaNhKC
	 xrCdOisFs1uK49jDOv8qNIc+S7ftySvwtPCh8TuA9uWl0AI2fvefM17JD+gYGrfUePG4Y
	 Ofw+eOqQsx2HkjKP3hs22tkF2NQ1ldlSJlvM0mHLUajCxZbZu3reabzUP8XEa6vZj8R7c
	 /ozFNSfOmMkjmRoul4HwSe9D2vyShXN9Oc8ebEOI62EJ/U1a1gRkiZIQNADc3DgW6T/2w
	 27o9nMDC1dZb/CW4kcTUh9WmYkv1oPHk55Cbt4MP3T4OIqzYThndafWhXEnBTRu5dLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WV9EWSqQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCCF606D817;
	Wed,  4 Nov 2026 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WV9EWSqQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793810772;
	b=oX4qZQ0X/LEZpGiGsTad+R+lcXXEDZWouBoS3l5mbcOOX6XK2hZXXoc6U7SQdSKa3ZOs
	 Mt3W7EmwwJ5iUQ0E5XAS15xpatC4V84T87ZsDWbTXcjJcF1YgBI12g6RSNKXrdtEDfXFD
	 dibho8BNkb59sObmY1ORzmTViUkASmgb9D+8nDgy5V2u5An93LjptChBrCtVkcqdzkF7u
	 0kWNGJGHFrfvUr/M07+m/ddN5GeUB0YWURz6momw21L2gZlpRkfy/bxZp4YEeoX286Key
	 yXEg7FEGtbkeRNMfEdEYsFMNY2oNlKK3if1dMwq1jdYHN6Sm+DQ39630wHYMj/p3C2w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793810772;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=JfRW0SPoALVVWDl2xAXTfh37dfRQmby6sb8WYvVZUog=;
	b=mG3qJWzHM+oE6KeOzg/+3REXCv/7hZrdpr1keji4ZT/vHlgxM9hIoazDgOuXL8BcKtbM
	 vvDzX54d3s4Nw9JO2PtLZX7AYV7qmX3AFNiYRbAtwm218NKC9cRdP0dQzAjduqAv/xIBS
	 o5sRgKAorOBv/EWcTp1V+c8M+CLuTW5YN9TRtXZOfUFWELh5E16Mfc1kY6AOpdmR/fjVV
	 ghaz0r37byly4r4Wd8fdzAF/P8FIkJZ++0/swPFO/1mKe7GkJOdxfU7BoJ33RUx3t96S+
	 JhEwLL7MOdcyeB+ye+fKA8SXgq3jmuAoe1gr16fyEmizKrFnLlcP1yNoFQubgwSkt0g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F0AD11F00A21;
	Wed,  4 Nov 2026 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810772;
	bh=JfRW0SPoALVVWDl2xAXTfh37dfRQmby6sb8WYvVZUog=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=WV9EWSqQrxTLVYIztlmELVMVh85LejnCzBIC/5HM5n2zKwdA0gfrXRjWfoF++o0TO
	 bl91mJb7fEVI0JbWMBszqwbTfU14LXei3zPpLRQVF7I2pti/yOu4LMd/qz6iwCMssi
	 cAjPa2ZJxWP85xi2ZGVDsHLMKxQKPdj2PGy/MJ35LvWa/lSVPQ8+GftpI1YaDw7JYu
	 OLFq5Agow/jaHVmgR23ZCg9uvZCqetjCGX5G4PnYn+y7nazs9eUiiE7dyTXk7LuAUh
	 0wWofSEUX+MsN/nceCi8NuWRmkXPkd7h/rslsP8V38vIlpRElE6vL595Srh1DzZrIc
	 Gw0rBmvp+f2hg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7BA4946ED2;
	Wed,  4 Nov 2026 16:46:09 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Wed, 04 Nov 2026 08:46:03 -0800
Subject: [PATCH net-next v5 3/4] wifi: ath11k: Connect to the QMI server
 belonging to the device owned by this driver
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261104-qrtr-multi-ep-v5-3-4cdb2b4f1920@oss.qualcomm.com>
References: <20261104-qrtr-multi-ep-v5-0-4cdb2b4f1920@oss.qualcomm.com>
In-Reply-To: <20261104-qrtr-multi-ep-v5-0-4cdb2b4f1920@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Jeff Johnson <jjohnson@kernel.org>, Eric Dumazet <edumazet@kernel.org>, 
 Eric Dumazet <edumazet@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
 Bjorn Andersson <andersson@kernel.org>, 
 Chris Lew <christopher.lew@oss.qualcomm.com>, 
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
 Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, 
 Juha-Matti Tilli <juha-matti.tilli@iki.fi>, 
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4200;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=8jdd/IxbkpdXzxb0pbbCtVyl0Xl30Xp8Q0D9LtdyvhY=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBq62FPbjDf/0qWzmhZRJGSlPc5ilpfYhrma+JkR
 fdrQ7uP0XWJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCauthTwAKCRBVnxHm/pHO
 9R8BCACidy14HAjJGZYhBuvH+k52nwAL23/DmWX1dAWwekfv4MDQF8Mdj64fv2T9mMtH8wOaQUM
 dT470wVrTKQAKkfzzLMPschxkhU9Y7BdbFAI2dE+Wjv0mHTCjKUnB5EIFtJzZxQRtJm0zCOwpiQ
 PB1RyQdwiruDc/o/OIEOR3zgTZROTIejzZ6JxdFEjJx2TG0fByWWvRU8FqNWrZNl1+VmJZ2o30S
 vbL84l3K8MHy1yjWWauqzT15iT44TJc09Jmh6uAJTZhzQWIDo6PT1GvU8pspoUQn+vaegVLO57w
 7XQUlbm8TLs0+WSDQsdhSf91VgQvDYzqpoZpGMhuVwntwryg
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com
Content-Transfer-Encoding: 7bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

When two identical ath11k PCIe devices are connected to the same host, both
advertise the WLFW service with the same service and instance id. The QMI
lookup reports both servers to each device, so a device may connect to the
firmware running on the other device.

But now, QRTR provides each MHI endpoint a unique node id which is
different from the node id announced by the device. So use the same id to
pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
the node id derived from the MHI controller index and zero for transports
that do not assign one. In the new_server callback, reject any service
whose node id does not match. A node id of zero disables the check, so
transports that do not assign one keep their current behavior.

Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/hif.h |  9 +++++++++
 drivers/net/wireless/ath/ath11k/pci.c |  9 +++++++++
 drivers/net/wireless/ath/ath11k/qmi.c | 11 +++++++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/hif.h b/drivers/net/wireless/ath/ath11k/hif.h
index 017fed1b4bd1..f432fa4890be 100644
--- a/drivers/net/wireless/ath/ath11k/hif.h
+++ b/drivers/net/wireless/ath/ath11k/hif.h
@@ -32,6 +32,7 @@ struct ath11k_hif_ops {
 	void (*ce_irq_disable)(struct ath11k_base *ab);
 	void (*get_ce_msi_idx)(struct ath11k_base *ab, u32 ce_id, u32 *msi_idx);
 	void (*coredump_download)(struct ath11k_base *ab);
+	unsigned int (*get_qrtr_node_id)(struct ath11k_base *ab);
 };
 
 static inline void ath11k_hif_ce_irq_enable(struct ath11k_base *ab)
@@ -159,4 +160,12 @@ static inline void ath11k_hif_coredump_download(struct ath11k_base *ab)
 		ab->hif.ops->coredump_download(ab);
 }
 
+static inline unsigned int ath11k_hif_get_qrtr_node_id(struct ath11k_base *ab)
+{
+	if (!ab->hif.ops->get_qrtr_node_id)
+		return 0;
+
+	return ab->hif.ops->get_qrtr_node_id(ab);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index a163168f3617..d40c057e130c 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -10,6 +10,7 @@
 #include <linux/of.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <net/qrtr.h>
 
 #include "pci.h"
 #include "core.h"
@@ -900,6 +901,13 @@ static int ath11k_pci_start(struct ath11k_base *ab)
 	return 0;
 }
 
+static unsigned int ath11k_pci_get_qrtr_node_id(struct ath11k_base *ab)
+{
+	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
+
+	return qrtr_host_node_id(ab_pci->mhi_ctrl->index);
+}
+
 static const struct ath11k_hif_ops ath11k_pci_hif_ops = {
 	.start = ath11k_pci_start,
 	.stop = ath11k_pcic_stop,
@@ -921,6 +929,7 @@ static const struct ath11k_hif_ops ath11k_pci_hif_ops = {
 #ifdef CONFIG_DEV_COREDUMP
 	.coredump_download = ath11k_pci_coredump_download,
 #endif
+	.get_qrtr_node_id = ath11k_pci_get_qrtr_node_id,
 };
 
 static void ath11k_pci_read_hw_version(struct ath11k_base *ab, u32 *major, u32 *minor)
diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 7dc07339b957..09c23ddffb38 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3170,8 +3170,19 @@ static int ath11k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
 	struct ath11k_qmi *qmi = container_of(qmi_hdl, struct ath11k_qmi, handle);
 	struct ath11k_base *ab = qmi->ab;
 	struct sockaddr_qrtr *sq = &qmi->sq;
+	unsigned int node_id;
 	int ret;
 
+	/*
+	 * Identical devices advertise the same QMI services, so connect only
+	 * to the QMI server on this device's node. A node id of 0 means the
+	 * transport has not assigned a unique node id, so accept the server
+	 * unfiltered.
+	 */
+	node_id = ath11k_hif_get_qrtr_node_id(ab);
+	if (node_id && service->node != node_id)
+		return -EINVAL;
+
 	sq->sq_family = AF_QIPCRTR;
 	sq->sq_node = service->node;
 	sq->sq_port = service->port;

-- 
2.43.0


