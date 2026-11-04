Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793810771;
	b=iMrUKn9cMIERAeIQOk+DtwHCz49MUR6Rl1aHkuzxc97bkzdv1UP22EKMdINE1ZmrjHUk
	 XvLPn6j511KwmSfh5acnRRiXeqvJpmWLllgLtlYvrxyPorvWx6NDChuUyd4b2gRyJ4Kug
	 F5NRFLVPbOdf/JPVMl6cdm7Wd68PsGR2ng2MhhDzDf+ttZQ6SMxgvDDrkTAHTCPj59jBp
	 PmNZcLvkNUIOF9egUCeO0YywkgtW+LkhdBG4ld/tFmWxUEfewfZiqVp8mQCzA41D69OlW
	 STZFWw4DcCNgYhsqf/CKo2+WicRUjv7r2nSs3EQvDvLvvF8WsxbadsdgQYMLAG6Ro9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810771;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1AvE0qmPTLYEQNW/JzGmdacSOhBtwOVKmHVIwVQeERQ=;
	b=nC/9spASWQIWrDXtiDk8+zfppH7icUI1cYSa3kUa5zQLMzvMZoV79OPcRh9SOZ8wn6eZ
	 QPvF8SBq12FxQPhySkJ0E0jo8IfbawxuOipcCiohxni1iI5w2B11zRMQQiHQ10mQ/soDY
	 nb86aco5b4RENcB87Lx3yY7UzJQbigApr7G1u3EwTV9M6Xl8CmGv2Uew4kaCSlU/sL0A+
	 6q96g4/2TLGh6Rnb2G8L1EnnGpIMM7U684Kwql5V/Q/y+OgAogdDevTNe3zaH1KCKgNq0
	 jWRZg8k5w074t/JDUVjti6q2Ta+PHLBzIvdHw82KGL3FESLwXefOb2s1slzDe/db5xA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="mPAopgw/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB153606A32D;
	Wed,  4 Nov 2026 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPAopgw/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793810770;
	b=eB4tcH4DbWD4aV4Gp1k+9MPh3SScZeN0kab7+r+hKfY+00/ZHcGQFcPFcDfR+HCf3Rny
	 6pbgvty6+pl4lHsMJzg89DmKufAmRGTc7nFNJ1cwaUZb+VTRIr9ZSdINwo/poER82B6+5
	 tpA04cjjx0JH34j1cthRxcnyYh3rU6+6NfUSZW1C+GiMVnrVUrTFjcgFGy5yD6sW7hoAH
	 Z9mp4m5vUj+X+vOgXqLJLV0eITSIyCoeYwh4d5vREGWkiL5K2II8wguAkx2+UDB9QLNjK
	 rgewnoUb9JFHpJiI6F5sKou/cJNrzVypFlIVzTnAVEh/sM2ri14vGXGi5fR0/736vlg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793810770;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1AvE0qmPTLYEQNW/JzGmdacSOhBtwOVKmHVIwVQeERQ=;
	b=OsVpvIYiGWSYzRVXYi0I3lto0vf2Un5gwviVo5qGl4Qr19r7enxdnDEJgba2UMQI9Hwb
	 /5KY1N6RL+r9sdntsssI092Sz/ZwDPtO4/pDdlKtACNECRfj5f5sJVshw2C+6zDHWpWxP
	 L0O0EkkLTw3Ai9F7pOgac5QzX3MdDvSGrV9iW/e7SmqJLzmvkHWuHc53FwECgMoVdNS81
	 XxnBMQ+/SFw8SxSSgAl3zSqyDpFxPJQ9l3+lFE6eTLe6uCgwzUwCXdwcKwZ26/l5EM7JG
	 xGP1Q07S7aBBWUGtIc5G7WIZxpw+If1ZwhnkSLVOrHmMru3NJUUWZ4c+QCUSoY0d0Cw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E92C21F00A1A;
	Wed,  4 Nov 2026 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810770;
	bh=1AvE0qmPTLYEQNW/JzGmdacSOhBtwOVKmHVIwVQeERQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=mPAopgw/Cg/ftiWOv66+NnNXIgp+4kvxzaxY8+WTj7c/kpqIeYbtAdCVjOOw7crNF
	 a1bLkglDWQvLVZgyGvJIx11UVMpQAN93MKJPLD/h8oM9KhBZz9mTUYa0TKb4O9iKjI
	 FNBYUdUOFH8txXzhH0eYg/+T5MAqWeKwbNRzl3gnLeXDhlrd7fU6+ktkFKA6TuKboC
	 0+F7GY+fWSB/qSugrHYFYgFZeZUjGsYwI9uznraQVhjuS7y7BvumE9srLfMqRvl6YO
	 XdGyI91wsoxzTB+GCdBwd2W/cFuft4fqwOcdxXh35j1LpJJNR1hBE7/yUeh95VlYpW
	 o3M7a0Fn+VfkQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6B0BA46ECE;
	Wed,  4 Nov 2026 16:46:09 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Wed, 04 Nov 2026 08:46:02 -0800
Subject: [PATCH net-next v5 2/4] net: qrtr: Assign unique node id for MHI
 endpoints
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
Message-Id: <20261104-qrtr-multi-ep-v5-2-4cdb2b4f1920@oss.qualcomm.com>
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
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4010;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=H0EhOTeuguMjwzlWxiNEAiptD2hqK51M5K4T4n4KhQY=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBq62FPzegVaTTaIYEmlqTf1i1XwQs2eDOwgYn5L
 iTv8vNrkjOJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCauthTwAKCRBVnxHm/pHO
 9cpnB/wIfv7gXHw090GbwPR/AiMkzKW/gaLUdnrfR112PCA4/edrZOfIWKVk5UuMnI2JcCgsctn
 3lnK4dgFhTZRLX5DIsiWJJ2Cv6f9XVAVGnUcEQBubruQqA/o3T95KUe8xH69+xrXk12WKeC90yK
 XBblZ7chZJA00aXpm5wIgEWfhb3M0Ch3QsPiVeKvCxg1AYLvImlgKkJpSXLqZjWbmy0fwvnzKHq
 o1zBh53vWFdYG7uhYWoA5f3Fq8Xf9Unni10mcH6YDc9jkWGRc2wPxg80IxBqqtDoD5Le9IARmIb
 Y8WMkPoZfqVrRTEYwtHECLMKsrR6c+nHA7eZgJ44wtG4v/W5
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com
Content-Transfer-Encoding: 7bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Now that the QRTR driver allows using the unique node id for each device,
which is different from the node id received from the remote node, compute
a unique node id using a new API, qrtr_host_node_id().

This API takes the 'index' parameter and adds it to QRTR_NODE_HOST_BASE.
The base is chosen well above the node ids in use by the remote nodes, so
that the host assigned ids never collide with the pre-existing ones.

Since the ids at and above the base now belong to the host, reject any
packet carrying one as the source node id or as the node id of an
announced server in qrtr_endpoint_post().

Finally, call the new API from MHI endpoint driver by passing the MHI
controller index as the parameter. The MHI controller index is unique for
each controller, thereby for each MHI endpoint device.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 MAINTAINERS        |  1 +
 include/net/qrtr.h | 22 ++++++++++++++++++++++
 net/qrtr/af_qrtr.c |  9 +++++++++
 net/qrtr/mhi.c     |  4 +++-
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 09713dc4c6a7..79ccd2ec2bf7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22992,6 +22992,7 @@ QUALCOMM IPC ROUTER (QRTR) DRIVER
 M:	Manivannan Sadhasivam <mani@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
+F:	include/net/qrtr.h
 F:	include/trace/events/qrtr.h
 F:	include/uapi/linux/qrtr.h
 F:	net/qrtr/
diff --git a/include/net/qrtr.h b/include/net/qrtr.h
new file mode 100644
index 000000000000..6beefe89943b
--- /dev/null
+++ b/include/net/qrtr.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _NET_QRTR_H
+#define _NET_QRTR_H
+
+#include <linux/types.h>
+
+/* Node ids at and above this base are reserved for the host and are never
+ * accepted from an endpoint. The base is well above the ids used by the
+ * remote nodes, so that pre-existing node ids stay untouched.
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
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index b95ffb98ec23..33df07fb836e 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -11,6 +11,7 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
+#include <net/qrtr.h>
 #include <net/sock.h>
 
 #include "qrtr.h"
@@ -590,6 +591,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	    cb->type != QRTR_TYPE_RESUME_TX)
 		goto err;
 
+	/* Host assigned node ids are not supposed to overlap with
+	 * remote node ids
+	 */
+	if (cb->src_node >= QRTR_NODE_HOST_BASE)
+		goto err;
+
 	skb_put_data(skb, data + hdrlen, size);
 
 	nid = cb->src_node;
@@ -615,6 +622,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
 
 		nid = le32_to_cpu(pkt->server.node);
+		if (nid >= QRTR_NODE_HOST_BASE)
+			goto err;
 
 		if (nid != READ_ONCE(node->ep_nid)) {
 			rc = qrtr_node_assign(node, nid);
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index e9a4bb92ce76..b464231fa0c6 100644
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


