Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792691001;
	b=F5mM//iqpP8Jo9+7empqqhhiJzCPzSXa33LSDenDaUgkX6C/voNSuKW+0As150NoMnQJ
	 0h6XTNlDw2dBIEPf0hNxQRARt//byOcrQPwWrlFD1dZx+zUyLuhGwU1PnL/Xaqf/JZDdW
	 zjzp4ve9768xXnzfvbN43jTcYlLursyb1NZDUHHz4Z4nUGQUBzvZg/3OUPQ/Dv3xjr/8+
	 lu5ORdQRrePTn6yPuqMSm8rv1gWHS1tffGiNjDW4KvpDhjAGkaKyn9BjLklakeP6MJuwg
	 ZT9hJ3xwM3JCOKXGABx+1l4zRKIFyZ6bsgWjplK6qmN72+Q72ZWB5SNOqDtk2ApP4TA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691001;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=H8oFF1LtZaOpfb2WufcD/7OuNnm3fLLdYsc5GK5937w=;
	b=HWnGSnerftPP+J0IQ9Tg8CNND+znPlmIuJSfZ+2dFp/3m7DD/0PsILEjtOZ0oAhJVw85
	 Q/vT1r5V/1523qknEcMK1gzF4O/xHP8ECkPNcTlIAjrOfOmt11XdNRGB/MvyAhjBPu49t
	 1KSUkSFrecxWHWwCpHtqogU6hTU6jdidkvdvU/YZ8nexQlJTFDkVxUGPYXM0W8OtLtHx4
	 mRR4LHGP+XoIho5u4QS06ycQm6B27GRIe/y3uzz02E2Sp+wUfDrvRmFHBLcMIriY4QrBR
	 fDJoCiq5WqDdb3gRE4IAQaw0tC2lT82NFX78BTYcIN4WSvDdzC+Gct/41YHaiAVxEtA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F5IPy2ng;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB49A606A31D;
	Thu, 22 Oct 2026 17:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F5IPy2ng
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792691000;
	b=fnWv8kI3Hg3yLMgKpB1Cn+/wUkG8M1OkC9Shq0xBm/IqcmZulBubglDXVlIpB6NCBEvx
	 cTyeVJZNBu/24vq3srPAAA+q4IvnJqB7m/1t7M0jugUz6CKcN4WrUFVowCcw5rWGB1XJg
	 XDxemaWMIXRiAwD44uJLXDA6FmJK+OmR99ZIBsIlYX/UjxPlUdEX52KFeoNnq5iPjV617
	 7tsNsM3PkQeSCo+X07BiDe3CVFfVD2nt2T3YdATloE4h7OLJmpuxNFtIBtIvY2B1BzAD8
	 QjqNL7X0Hvts8rJfFk2HEDBlJ3n9yQ/lvn4VthRyWawMefeWXgAgDJuwe/40m1I9/pg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792691000;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=H8oFF1LtZaOpfb2WufcD/7OuNnm3fLLdYsc5GK5937w=;
	b=0bHHcG07wG+PPDwmme8sM0CFIGY6YxNBj/vDUa1YHpiKAtD4IksVEWxqpfIRvDMAtKoQ
	 VV6FZEKdcWGG+EEfRFpKCG5Kk+di9wFrtffjoz5kn9Ls0bvFJ5A3LgjRVVy28DdDYy/Ho
	 kT9o/ms8a+qrfNAj6Yxm0V+FgF+0m8gQPwARhFwT982s0BwX3GY6vVkXBQUrEiKREuSq1
	 OiiH8T54oKEFdTx6S/3pwlyBi19p2WP/aHrl2WwKSt9JbeU4B1vPoLk/Anb8LDiEcl7xa
	 CGh+aSm/5kU1OP4vyGEaI9eWS2pQZl8r+4G4wLYym60TlCp3Ph4QcJGJG2UwGT014+w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 667D01F01828;
	Thu, 22 Oct 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792691000;
	bh=H8oFF1LtZaOpfb2WufcD/7OuNnm3fLLdYsc5GK5937w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=F5IPy2ngQWVgkdIKnq9Yt++HJIdzU2OTboyyGKBFer+RoBv1JucCPZzeYoqDx//x8
	 Ffd/g3cERIJS+0Z+WsTtoXA8HscQoOD0816YF5SHF6+oURBL2mxg6IobOPmb8QQpmj
	 bfi0fEinSFmqvpzFtnrxRpJFTGID1HKz2sBLLofPmrS6BnQHujLAZ7LMep1ph5Pb/7
	 CmghI3fubgt18Qrq43knZlMz/XH0WsbQbK3gs8t+EmKTUHcv8vE4x/0NrvGkx3Ly6y
	 HS+1omrF/I9MNCnYk8mUu4zSB65YY7ZqcCC+8elmQi3m7xXeEwD4ZoPjx1GeQterbJ
	 HGIdcJ3EMGOCQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CDA1141E95;
	Thu, 22 Oct 2026 17:43:18 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Thu, 22 Oct 2026 19:43:08 +0200
Subject: [PATCH v4 2/4] net: qrtr: Assign unique node id for MHI endpoints
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
Message-Id: <20261022-qrtr-multi-ep-v4-2-c6fdb75fcd3e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3964;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=YoEVGfn6pJagg3BMv8pSYGkO4MTCJESp0TWcBZdgqL0=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBq2ks0vhlFnClGHeItG3ycQMIpF0sxPskgHG9yp
 YQtb7wH+nWJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCatpLNAAKCRBVnxHm/pHO
 9c4KB/9BZ9UB5TqxY/WW3iYzlOOZUCzvatQQhXhbp+QAChdrkob/igzvFhLyekAks633VNEj1Hf
 e20Rkxm+ULE91vXMArBuufXbhVQo3YR7+VyHo8MDnWakpRhqLzs2Qfc8+hDRHSiz31VXq9twS3R
 p5ZASCejKGRZArBkvOhTSgucHQZWhgeKEkz6APCu8wKEGHF0vWwVy1QiynRJyxy+E8UlIgFrt+y
 bQGfX67qxYJHUMJFX3maunIlerSFW7/Q7IXScREBSP0J+O7qpGCtFt2Br/gz4zDwzE0mdkErdSj
 dlxjUnR8hRjBjcT1CjVRnR7n9Odp0ptO42fTOkOQQyDHbUxd
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

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 MAINTAINERS        |  1 +
 include/net/qrtr.h | 22 ++++++++++++++++++++++
 net/qrtr/af_qrtr.c |  9 +++++++++
 net/qrtr/mhi.c     |  4 +++-
 4 files changed, 35 insertions(+), 1 deletion(-)

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
index efa70b95f8a7..7a59ccf15490 100644
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


