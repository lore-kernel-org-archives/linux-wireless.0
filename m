Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95F9516149;
	Fri, 18 Sep 2026 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789748899; cv=none; b=JtSWe9IYftQWcmvyIUKON1hk4UZdovSeByq9ifnSgVFGv4Gr4A7o+EOkz0uHVWGmg0uNNBahVO0tq/an9PDcitzOdAWpmQZyB050Hy55W/kRD4VfHM/zcRLeP9JZbLgoO0aAIAlbK87k8vhEDG0oxu5d9t9KSNj8w3+fgkTkXB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789748899; c=relaxed/simple;
	bh=hkOGfl3uMR+TD4cA7bZLolJR7gTPPKlkrku5dBBzcmk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ua0M1uphbYdHUks+3m/bpXmZLOINXbosXWXSS2iDz9zCa6GsfUBmW9b2xIcajYzCRCFXssvBwgn6zBwpy7o1xu2XfyA7NLRQcdpy/DCdQOkdFUQMJgKXYMUzHKogLT0T9LEnJgDDa1Ko8jm5SlAoTDYMzbnSUFqfR1GCELHGZiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8vteWUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8vteWUM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2A80C32781;
	Fri, 18 Sep 2026 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789748898;
	bh=hkOGfl3uMR+TD4cA7bZLolJR7gTPPKlkrku5dBBzcmk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Z8vteWUMfZWnzD6qkN7QDGkZR2RwHqmxHIydOYb+9UTBQqrJVOt5GoZw4mBPtByAq
	 atZ/69FXevdWOv3GcF3GOKMHSqEso1sYAbN6+SwNEUzfoF5sBNxrfaYnidE1zr5ppK
	 Lm+EqZfooEHEGOa4y9xyxM4y3sZKsdu6Qqf0LFm0gZQd6ynkkyN4EwP1cKl13e6NeU
	 /GaymeqD0/j+VI29mD+QP38ioY2rVRYpz9KSp1+btYzUxo5Z/n5DbmS+jHKcRyLkdt
	 jn9mLEdPERKNGMRAY4Ie+3JUt5CesKtBXvLESZHAili4+DccjWcj0Nwm3mhhLhfAUt
	 si8nEWmG6l/CA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA04FC982DF;
	Fri, 18 Sep 2026 16:28:17 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Fri, 18 Sep 2026 18:28:16 +0200
Subject: [PATCH 4/4] wifi: ath12k: Connect to the QMI server belonging to
 the device owned by this driver
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-qrtr-multi-ep-v1-4-8a06caa368d3@oss.qualcomm.com>
References: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
In-Reply-To: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4259;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=curbfmqjxjKsnWzL9i8aIUn+dQtL2mKCKSdc3ihT0zc=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqrWafO1di1O4lB6nHUNfWzvdQz+gMTm6+uqD9f
 2NI1o3gjLqJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaq1mnwAKCRBVnxHm/pHO
 9dNECACBqfY4aXbYqtyfGh1aw0bHIUcBfUl/RrqJgbsU87TPa6Yil/k4pOBcfgsWi8H6LyL7L4L
 8MnL0j7MpsK5W/M3Fa0Rs9miENaW3fgyJ/Ds8k82EyAJX06ERwWPJBFPuUKIwIdAIl67F1YBW/t
 xhTrc6kciZywKXMUiMRID8ePN9LAu/FY5tK2v7PQiI9b2PdUgGxOT6WuY/FppsvnmciD/xf68+J
 MJBSC2m7ocBiOFoFFQY3WfhLcG7iDLysHmeWs5BPTSLekphfYyKpznypApBQZS3n9UW9PZskSQj
 sCwsTbApOTAM2u3AZ4qQ716vhSy9uiP87Hr5JHNpPSDmj3Br
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

When two identical ath12k PCIe devices are connected to the same host, both
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

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hif.h |  9 +++++++++
 drivers/net/wireless/ath/ath12k/pci.c |  9 +++++++++
 drivers/net/wireless/ath/ath12k/qmi.c | 11 +++++++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/hif.h b/drivers/net/wireless/ath/ath12k/hif.h
index 4de8667690e9..be9c070cf716 100644
--- a/drivers/net/wireless/ath/ath12k/hif.h
+++ b/drivers/net/wireless/ath/ath12k/hif.h
@@ -32,6 +32,7 @@ struct ath12k_hif_ops {
 	void (*get_ce_msi_idx)(struct ath12k_base *ab, u32 ce_id, u32 *msi_idx);
 	int (*panic_handler)(struct ath12k_base *ab);
 	void (*coredump_download)(struct ath12k_base *ab);
+	int (*get_qrtr_node_id)(struct ath12k_base *ab);
 };
 
 static inline int ath12k_hif_map_service_to_pipe(struct ath12k_base *ab, u16 service_id,
@@ -162,4 +163,12 @@ static inline void ath12k_hif_coredump_download(struct ath12k_base *ab)
 	if (ab->hif.ops->coredump_download)
 		ab->hif.ops->coredump_download(ab);
 }
+
+static inline int ath12k_hif_get_qrtr_node_id(struct ath12k_base *ab)
+{
+	if (!ab->hif.ops->get_qrtr_node_id)
+		return 0;
+
+	return ab->hif.ops->get_qrtr_node_id(ab);
+}
 #endif /* ATH12K_HIF_H */
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 6441927b5382..2b1b122bbb3b 100644
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
 
+static int ath12k_pci_get_qrtr_node_id(struct ath12k_base *ab)
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
index 280e50a1f31d..22b8cbbbf4f4 100644
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
+	int node_id;
 	int ret;
 
+	/* Identical devices advertise the same QMI services, so connect only to
+	 * the QMI server on this device's node. A node id of 0 means the
+	 * transport has not assigned a unique node id, so accept the server
+	 * unfiltered.
+	 */
+	node_id = ath12k_hif_get_qrtr_node_id(ab);
+	if (node_id && service->node != node_id)
+		return 0;
+
 	sq->sq_family = AF_QIPCRTR;
 	sq->sq_node = service->node;
 	sq->sq_port = service->port;

-- 
2.43.0


