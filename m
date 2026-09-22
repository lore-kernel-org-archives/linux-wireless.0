Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280FE548562;
	Tue, 22 Sep 2026 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084525; cv=none; b=GRSEKb/e0E5l5KRslExoIbb8ZZsW7v6BY8cE3+U3WJF+zfl0beMhXgl6bH8OdmFnVI6Mi5orKzfDNkLrU5SONx/C1G/M3vTrDM/KoJnT+L0IoLNEx52jMLk1F+mj4fJXXN9V/46dG3r00Aom/Y3aOHg1046vrBk5uWNR3XJYO+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084525; c=relaxed/simple;
	bh=xROrfFeYggZqxoTBcr+VcNs80P1Ms0dAQ/3w/YExYt0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MK6cqe/Cd72MGGU5zHqIs+fKWUY3DqdL4niegH6Z9/nS7p9o7w2NPEsMXyporYREbkBV0G3Ac/BVbZuiO7RwBavOKKMciP9PW+MORAK+aFdnlb/C8u+79D+Z5GyQCh54z4mfX7XCnU4okNeFAQIYWH0Ziag+GvoZ7mHHeiahFxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfWh8F21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfWh8F21"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C63A1C2BCFC;
	Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790084524;
	bh=xROrfFeYggZqxoTBcr+VcNs80P1Ms0dAQ/3w/YExYt0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IfWh8F21m0/buevOmiCo7sUCNnXBprZ0iFgThd8GYHkF6iDHVoslxIealdpkHzafB
	 jZ/pQQsKTZjpgPN2sSOoLEZ7KPqRkDb+nBN7ojf7BhWjfihAvN5wUkxo65rRwERxId
	 zqtyU9MqVQo3+iLrl/9exY7ual+3F1LQenCLpCU+78iojlUXBd/jxOAZ7u6+OvdxYd
	 cMmvI9PjmvRknBKPf7o8DespibNSFr375uTGV9YFJClPnv0XGJPuItNF9vVC0nmMuL
	 x/+JeRxxE1WYFtHreI8RVm6513UW0ydDHoqaEy9s9sAQACKDJcOK5EkNzdBBkUZWho
	 YbDBkKC/D83ww==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A8FC98309;
	Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Tue, 22 Sep 2026 15:41:47 +0200
Subject: [PATCH v3 3/4] wifi: ath11k: Connect to the QMI server belonging
 to the device owned by this driver
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qrtr-multi-ep-v3-3-c00831e88957@oss.qualcomm.com>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
In-Reply-To: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
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
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
 Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4309;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=ovtJzcguavWNvUinoFzMzVRQK6JoHlMcjMYxr8KLoaI=;
 b=kA0DAAoBVZ8R5v6RzvUByyZiAGqyhamh+RwBXtaITKsY+ZO19duTX/BJfGSgOLMUXoVSBZkcW
 4kBMwQAAQoAHRYhBGelQyqBSMvYpFgnl1WfEeb+kc71BQJqsoWpAAoJEFWfEeb+kc718IwH/jtd
 EfnmTerjNfa6Zda5uaogCGUh5ZAvnSA1nNW1jWIwh8YEL+fEvQ7H2CdcoUUwKFPLblsPV5TmpyG
 RTEkhd+cJiYYyqNBkaFjo4JZX8EGppBAw03m9rYMCKf/NMhilC8Dj0q4irzL3WalzCKKmR8Sg+C
 HNJTj2fGZnU/DSSbg8jo4BnCtwLgWsu10PVN0ujp2pRsmS/ieKllClIjExV6OhtjBgqWR54Ay82
 QptTEloryIrlMLldp8sj4cwZjzWGecnHV5DHzROiMovI1/ADzY7rk8SkhpAEOJG+PjF8oeKSLFk
 lNK2kcd0PXguL4hkcCMMy2rvlYpx3JqIkQIJ4WM=
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

When two identical ath11k PCIe devices are connected to the same host, both
advertise the WLFW service with the same service and instance id. The QMI
lookup reports both servers to each device, so a device may connect to the
firmware running on the other device.

But now, QRTR provides each MHI endpoint a unique node id which is
different from the node id announced by the device. So use the same id to
pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
the node id derived from the MHI controller index and zero for transports
that do not assign one. In the new_server callback, skip any service whose
node id does not match. A node id of zero disables the check, so transports
that do not assign one keep their current behavior.

Tested-on: 2x WCN6855 hw2.1 PCI WLAN.HSP.1.1-04685-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Tested-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/hif.h |  9 +++++++++
 drivers/net/wireless/ath/ath11k/pci.c |  9 +++++++++
 drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++++
 3 files changed, 28 insertions(+)

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
index 7dc07339b957..9484b0eee1a9 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3170,8 +3170,18 @@ static int ath11k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
 	struct ath11k_qmi *qmi = container_of(qmi_hdl, struct ath11k_qmi, handle);
 	struct ath11k_base *ab = qmi->ab;
 	struct sockaddr_qrtr *sq = &qmi->sq;
+	unsigned int node_id;
 	int ret;
 
+	/* Identical devices advertise the same QMI services, so connect only to
+	 * the QMI server on this device's node. A node id of 0 means the
+	 * transport has not assigned a unique node id, so accept the server
+	 * unfiltered.
+	 */
+	node_id = ath11k_hif_get_qrtr_node_id(ab);
+	if (node_id && service->node != node_id)
+		return 0;
+
 	sq->sq_family = AF_QIPCRTR;
 	sq->sq_node = service->node;
 	sq->sq_port = service->port;

-- 
2.43.0


