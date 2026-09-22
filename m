Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD04B4078DF;
	Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084524; cv=none; b=KKgjzP7KnvsJiBZlilrB1diEYSYvqZLCkKE31j1gOhbqrWnLSkIRjNFRMwL6UbgWXN4LTxiS0fxkKKArL0PQJEREG1m0oFrR1Mt7ocaa610urX1jQ24t9zhDWGvO+WvmEuWmVFYkZn8ELVDpRvzPa33PNaa5MqLM2ScLT1Q3sI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084524; c=relaxed/simple;
	bh=vyCcA7tnPPht7PT85axNJlbH910qapPAZZT/pgWHgoY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uDVlxdv/GqoG2Ly8/qnu5c2vdX/apkmwetVhkEb77sJI20fHGy+vLn8QRq91CrCj2O3JXFzeweJTNvfUPpcVlG4iiqAxZGlFoj4QvrncaZEe1mk5u8WtW6yZrEMhonuXw5qNh1gRcKpigHo7c/6gVn+EjF5alXxqraT8BxfWdVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ftj2INYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ftj2INYG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2B20C2BCF6;
	Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790084524;
	bh=vyCcA7tnPPht7PT85axNJlbH910qapPAZZT/pgWHgoY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ftj2INYG8GNVpLoH9Cxl3gEMwp+EMg9skHSOyg8V5T/unxWjWUMYXJHsdxcLJe2XZ
	 ZVvKKIUfQwO3Q3Ie9EVAoeYiWvL2NdC/s9bOSvpTwXe3mlk7wUQKc01atGzlYi1C3I
	 fVi76ZfY6+8WRRciZSmcXL4gSWK2k/LrsD5B2/nbgQnQpGvsMc321Ui6tOTVRHnk+8
	 XieRzbAHM748fHAkfsApZIRIeHMkEVg9rKsXjpjyzegsL7NBE7uTUM7aE6a+0CEIVx
	 oS75Zwkh/0Uh6EKmVk4J1pvQSrc5hhRIc4cmY64cGWE68a43LYbX+39bUFLG8utgUN
	 /17GFTT8IKAHw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946DCC98302;
	Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Tue, 22 Sep 2026 15:41:46 +0200
Subject: [PATCH v3 2/4] net: qrtr: Assign unique node id for MHI endpoints
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
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
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2620;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=KeQEnANlAXYlpqTacuONKxeWxAocy2Ur191CkncsK00=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqsoWpgF1ERmKKFgRfllMWMhlPIpcG3nOoB3HYz
 G0vgm16ZU6JATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCarKFqQAKCRBVnxHm/pHO
 9R96B/9ZauGHrvlwTacRyUaFmAzfIhB8j9LS0NGFuRQ4iW7kU/8U0SVsOt9F//gBDbzw/1x/I8/
 hqcWkSKXhmhiJ7Voi5UWakubMitFRKDVWwNOMf3arS8MRk4ukg/MZcl+jhbnoQCDEraGvW9eaGA
 SjLs7Il6xXA8Zh6XDN3shDJPBp4dU1fyQG5ILVNjxrerjjURcq0XKXiSeEgFS11qSvMn3vfErF3
 Xnzt1tXqBnqHnlM80pKf40sK1VHDoQxGedJ0SGNOY+od1QZvJrRDZlzDAbRA37oAbie2d7mea1a
 vvEiBOlNOeQsu+53uiXQ7IkYWXdGW1VCe2aFjrugemfeT4so
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Now that the QRTR driver allows using the unique node id for each device,
which is different from the node id received from the remote node, compute
a unique node id using a new API, qrtr_host_node_id().

This API takes the 'index' parameter and adds it to QRTR_NODE_HOST_BASE,
whose value is outside of the node id range used by the remote nodes (0 to
0xffff).

Finally, call the new API from MHI endpoint driver by passing the MHI
controller index as the parameter. The MHI controller index is unique for
each controller, thereby for each MHI endpoint device.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 MAINTAINERS        |  1 +
 include/net/qrtr.h | 21 +++++++++++++++++++++
 net/qrtr/mhi.c     |  4 +++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index df8ab9b82402..9c8bb086be28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22511,6 +22511,7 @@ QUALCOMM IPC ROUTER (QRTR) DRIVER
 M:	Manivannan Sadhasivam <mani@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
+F:	include/net/qrtr.h
 F:	include/trace/events/qrtr.h
 F:	include/uapi/linux/qrtr.h
 F:	net/qrtr/
diff --git a/include/net/qrtr.h b/include/net/qrtr.h
new file mode 100644
index 000000000000..745d51b4a6ba
--- /dev/null
+++ b/include/net/qrtr.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _NET_QRTR_H
+#define _NET_QRTR_H
+
+#include <linux/types.h>
+
+/* The offset is chosen carefully to not collide with the node ids allocated by
+ * the remote nodes. All the remote nodes use node ids in range 0 to 0xffff.
+ */
+#define QRTR_NODE_HOST_BASE 0x10000u
+
+/* Compute host node id from a per-device index. The index must be unique
+ * among the host assigned endpoints and smaller than QRTR_NODE_HOST_BASE.
+ */
+static inline unsigned int qrtr_host_node_id(unsigned int index)
+{
+	return QRTR_NODE_HOST_BASE + index;
+}
+
+#endif /* _NET_QRTR_H */
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 3990da1a65dc..c920ab61f848 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -6,6 +6,7 @@
 #include <linux/mhi.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <net/qrtr.h>
 #include <net/sock.h>
 
 #include "qrtr.h"
@@ -127,7 +128,8 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	if (rc)
 		return rc;
 
-	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
+	rc = qrtr_endpoint_register(&qdev->ep,
+				    qrtr_host_node_id(mhi_dev->mhi_cntrl->index));
 	if (rc)
 		goto err_unprepare;
 

-- 
2.43.0


