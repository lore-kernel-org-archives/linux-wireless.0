Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792691001;
	b=M6LSGiORcndu3RC08UZs5V7db1shn/nkmN0oJvDrW5knVXRQdqgSc2+3QteyoTzCH5vp
	 SQXxUSsA4YgEiiKDoTqEqAg8SN4MGx1NO66o9VWpBIpHb1/PWE1RtT/H2vgmMSjOn+v7U
	 C+MnIEdfPykDYOXOhbX5zxE7FDdjE7Shl3b6RX0z2q5ymHjwtq5v3v7nfx3HxxkzlCwjw
	 WSIsVCwzd4HnK3KsYKyfSFLVlFNB28nPSz8xadkKbcLPMEBMU1MwtFm+UcdfFnnxu8k7o
	 cLP2Zqda4WtpXjdv/7My3h+478quVPyzV288GJBlsIwuJElzDQGvUDpN9jqv83/H8Uw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691001;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yETL4knWUPez/VlRTmODuvPK8zAIUkmtTs26pSwP9pg=;
	b=5biItRZN/XxZp83KAQ9WCSeAEfGiPB0zAJaKknxE/5hUMiS0Tpfjw/uFJAP//eb/FUKg
	 hskjZBcj1mf81V1gGZTbla5CoVidqKIw2FY/FgUNG2aQDiO4wX6nm7vuwaH8jrLu2isR2
	 zsCudsgCsOtF8fPqw7FOxzM/fNbM/ElB1zUoUUtlwiMBe0+PpUIn4sq82soPbyDoW52XL
	 whEBOMjJHhCijyhMNLH/czoZLO21/FsEErWNPC4uSyE+R9TLYovagZ8ZTzF4EqXKQmKMT
	 bcp50vZrXD1QODd8dZLJkerGi7AS7Ykfc/tW05JgrjA5ntlRqjAUlGY9jQPXqbG0UEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NQGDdrYL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9D7606A322;
	Thu, 22 Oct 2026 17:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NQGDdrYL
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792691000;
	b=HsDK4bvjnQgHe4we9XB0T6buTjWUEOi6iEZ+pHC0Lt4c+a+oQYzyIGgwkTmzH8h6vgxS
	 vabsD/MVpdyYlQTaBbifnYxeor29DrGYOeGqYY/dmjBxMeXgNW3FAZC5vwaqjLw8gPxjZ
	 ik+AzLtZ7E8xyEhpBwsl3kkZQ7EnuagrT8fZQc0keBJVH5FeX2fy2EbgOLvSLBFlLndIz
	 fFDygb6Svm5U0Khi0igqOiCfPbPZ0VrlfH7OnrLLwVokTpgwXjtJUU8OYAHMWlQEdd+UL
	 08Epebr/kck+XhxSe8LpYy/3qu2ewAMRl8iYG0PD6zvpoQ8I10+NKSuH3MwgZCfKjAw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792691000;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yETL4knWUPez/VlRTmODuvPK8zAIUkmtTs26pSwP9pg=;
	b=FNB7eZpUDHFubg4ytqntw7HY1qcVuDcqr1wzqPc+BVCg+d6D+K6GNidiTXijG8WIsvg3
	 IrOux5C59ighwLfNuvDUc86rIKrqD+3hMtXb0bFxRoSGhT5xeNkjRWmFtuvHAmcbAdQ78
	 M915ainDF4ufv4EQusAM5zZx5v+aEHOGIGpFJCsFHz6n7dfJnJ9S4I+FLLDcP4dpJpUDT
	 KKNFAWAacO4womq9oYE0kzdbhPObX2KW55sbqpjb9AOPNTtMgFV28J7bu3YS+0/TBztYD
	 xspLfn1l2odMUJxr3kOXe03Nl5ULbHFBmAIzcLmJdI2/3Pdns9A9y0Zbj41sscmcNbA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 686511F031E1;
	Thu, 22 Oct 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792691000;
	bh=yETL4knWUPez/VlRTmODuvPK8zAIUkmtTs26pSwP9pg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NQGDdrYL8Cr425TZ1cjS+x099ww88t9C86rOK2UgZ6dj0dUJIfVzbWDAJvSTnvitA
	 oMYFge7+QjOHL/FOKZ9mPqjuc8re8Kz7oBodfkxgwpczRetXcsQCON2RPZ0NuWzRIv
	 snFzSc/LoO60C7BiNoXfFBxuZsybBJJkFrdmZjUURBXOh4bzFifTbtH4kZkUCs8YdA
	 XBsQpsqMllwTY6s86DyHKXEAoqlUTQVy6r5NCgjfkBUzRqMIRoKnWTXc9Xi+tbk6D6
	 /fyLc2Tg+NvJfFT7bV3X2inxYU52mjeEfH7vUaOEo0TIxrRBcFeBZryzfnJ5LLLfhh
	 iglCsBuSatDqg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E051D41E9D;
	Thu, 22 Oct 2026 17:43:18 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Thu, 22 Oct 2026 19:43:10 +0200
Subject: [PATCH v4 4/4] wifi: ath12k: Connect to the QMI server belonging
 to the device owned by this driver
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
Message-Id: <20261022-qrtr-multi-ep-v4-4-c6fdb75fcd3e@oss.qualcomm.com>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
In-Reply-To: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
 Bjorn Andersson <andersson@kernel.org>, 
 Chris Lew <christopher.lew@oss.qualcomm.com>, 
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
 Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, 
 Juha-Matti Tilli <juha-matti.tilli@iki.fi>, 
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4303;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=12Qa0EpdKE17l7J/TlSWmlYBFBDnMCpE99H5MSImZQM=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBq2ks1l0yBojVpshNCZp9U7fxLtGT4aTO89TKkM
 GrxDwXHwP6JATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCatpLNQAKCRBVnxHm/pHO
 9RasB/0UnIGBlYOFagdQugHnjX5NyZ9LrSeSLbzd9ytyzqjrZ1sJN3K0J0QsAsjo8rDOzCCIctD
 HsclzOy/kY9LVwzvBFD5zuzqz3CVaZ5FPNKKJMiI+CPAqYQrDI6D+9A9KiVIKHlILtT75aJMGV9
 8Y8tezgoEi4/iFy58BaBg3bXm/aet9yVrVEQupGDlSVPJoOk3eI1gCmNFPffDCe9ljKMvJAqRc9
 EsfvOQN53KJcQe8w8IQH18p8XGYHSabx6uxQ2dyZHfl7L/FyJySf7poITdV3HpD3lewqAfugHxh
 DAiSgnlZA7bkBxtK3lR0IJh/SYHTJFe3GlAL9JkSLfqjvu14
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com
Content-Transfer-Encoding: 7bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

When two identical ath12k PCIe devices are connected to the same host, both
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

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hif.h |  9 +++++++++
 drivers/net/wireless/ath/ath12k/pci.c |  9 +++++++++
 drivers/net/wireless/ath/ath12k/qmi.c | 11 +++++++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/hif.h b/drivers/net/wireless/ath/ath12k/hif.h
index 4de8667690e9..b8592c3d84e7 100644
--- a/drivers/net/wireless/ath/ath12k/hif.h
+++ b/drivers/net/wireless/ath/ath12k/hif.h
@@ -32,6 +32,7 @@ struct ath12k_hif_ops {
 	void (*get_ce_msi_idx)(struct ath12k_base *ab, u32 ce_id, u32 *msi_idx);
 	int (*panic_handler)(struct ath12k_base *ab);
 	void (*coredump_download)(struct ath12k_base *ab);
+	unsigned int (*get_qrtr_node_id)(struct ath12k_base *ab);
 };
 
 static inline int ath12k_hif_map_service_to_pipe(struct ath12k_base *ab, u16 service_id,
@@ -162,4 +163,12 @@ static inline void ath12k_hif_coredump_download(struct ath12k_base *ab)
 	if (ab->hif.ops->coredump_download)
 		ab->hif.ops->coredump_download(ab);
 }
+
+static inline unsigned int ath12k_hif_get_qrtr_node_id(struct ath12k_base *ab)
+{
+	if (!ab->hif.ops->get_qrtr_node_id)
+		return 0;
+
+	return ab->hif.ops->get_qrtr_node_id(ab);
+}
 #endif /* ATH12K_HIF_H */
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 6441927b5382..9b6108c1abdc 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <net/qrtr.h>
 
 #include "pci.h"
 #include "core.h"
@@ -1491,6 +1492,13 @@ static int ath12k_pci_panic_handler(struct ath12k_base *ab)
 	return NOTIFY_OK;
 }
 
+static unsigned int ath12k_pci_get_qrtr_node_id(struct ath12k_base *ab)
+{
+	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
+
+	return qrtr_host_node_id(ab_pci->mhi_ctrl->index);
+}
+
 static const struct ath12k_hif_ops ath12k_pci_hif_ops = {
 	.start = ath12k_pci_start,
 	.stop = ath12k_pci_stop,
@@ -1512,6 +1520,7 @@ static const struct ath12k_hif_ops ath12k_pci_hif_ops = {
 #ifdef CONFIG_ATH12K_COREDUMP
 	.coredump_download = ath12k_pci_coredump_download,
 #endif
+	.get_qrtr_node_id = ath12k_pci_get_qrtr_node_id,
 };
 
 static enum ath12k_device_family
diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 280e50a1f31d..507062068f8e 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -9,6 +9,7 @@
 #include "qmi.h"
 #include "core.h"
 #include "debug.h"
+#include "hif.h"
 #include <linux/of.h>
 #include <linux/firmware.h>
 #include <linux/of_address.h>
@@ -3940,8 +3941,18 @@ static int ath12k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
 	struct ath12k_qmi *qmi = container_of(qmi_hdl, struct ath12k_qmi, handle);
 	struct ath12k_base *ab = qmi->ab;
 	struct sockaddr_qrtr *sq = &qmi->sq;
+	unsigned int node_id;
 	int ret;
 
+	/* Identical devices advertise the same QMI services, so connect only to
+	 * the QMI server on this device's node. A node id of 0 means the
+	 * transport has not assigned a unique node id, so accept the server
+	 * unfiltered.
+	 */
+	node_id = ath12k_hif_get_qrtr_node_id(ab);
+	if (node_id && service->node != node_id)
+		return -EINVAL;
+
 	sq->sq_family = AF_QIPCRTR;
 	sq->sq_node = service->node;
 	sq->sq_port = service->port;

-- 
2.43.0


