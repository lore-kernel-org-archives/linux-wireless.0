Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D02526AA4;
	Tue,  8 Sep 2026 09:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859952; cv=pass; b=VhParQzz+ZLIP34RO9hWf2fheSeA+fRQwltcy596kg7iyLZ9WSe0NdxEkR04YNfsNzkpIj0RPv3BdRNeElZf4Ujwi0+iQ3ZvVqaDqLk9TuQZLgtd++JR7L9N/w1nKvjcqx+EbuYYw7DArxtHUP++wS1xrePQjIfsPioLLlHsgXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859952; c=relaxed/simple;
	bh=g4aQyOLEGD/J/mGAzOphPB7YVWZKQDyor3F2/f8yv0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hvjXy2k5SCp7lgmY4apILry1DsVLuRzxj7F69+tItNlMplIXVfrZ6qanuRMn5LbRcBSowqAVe1MdiZtKOl9j8jc1nb5M6fujWfphvao3hRweHbKxBgIpKy4ASv3rz7ZtDHF7Cu13zvdp1UoOO6mg0GnGYXNf55QnUuCyVJ+p0hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=bNCha8mG; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="bNCha8mG"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJcm1nmlz49Q5T;
	Tue, 08 Sep 2026 12:32:24 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788859944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AzdAznUqNvjD+c6FuDnuoa9sVaQ4EnkP06j7nL3toE=;
	b=bNCha8mGfHu/ArQOTOeQC6ulWG1k49L2a3fGyzmGlOKMpYOBjoeDffMWhSChV8VXN2rihW
	2lKdTJpDyEYY+yIVDRHFzWIaFQSzR06HnlC5e+RlMcPodmPBddpyyK5i0lCe3GHuxBthFk
	33RTnTYClGRgHQH6ODNsQ5dN65lNcafCzMu7yYVo/d+M4CPLtQDgb/0MMW+jvlGOWzr+hf
	5uXBlv+3R77DSHGYOYASwcSKc+y7ayYwkIxqYvL7ivHGxUDM9iK7P2GC3UbPewmtFCswND
	aGoqKmXZih6pJWY9DI0Wl10TTxbbXMhhVxLESoZ6glNR+xUCwIrhoQVSW1080w==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788859944;
	b=v+1tEc7HACRgLsvSQ6KKAmmvg58EUyACOsKsP9w8cdFxNb9j20QRsOcH6w0ZOoBE8r9Mpy
	agrTFYVEhomJeio4v7zMlyTG2fl+/gnqaUZ6n46isfTmv04NjcYkg1mwgpuF2EG1i1x4Fe
	f5QJNPiHQ85hyb7rOjmqaBKuSs9mVRbt8VLBQOUrEk7mKiWcYO5DDcv5U4Y88oGvHxOEEE
	lk0M/wqHt0ishSjzzvn0tGKDbonhzAWqVK2WvmLfuAZHeNl8qmkEC8qj2DVuQGZQU8dsAy
	dUFREmNMp5nTP7XSwyAwx8jtYPiHgk1t7U0zeGbHpp3xm50CuCUQnkSnjOr87Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788859944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AzdAznUqNvjD+c6FuDnuoa9sVaQ4EnkP06j7nL3toE=;
	b=sYV0KppgnRiohA9MRKbLoC/DJzb1us01T0ojf0sLqxmy7LFjEmYV+bpusJ+jO//9qxtTWM
	xgKU/Uh5qgB+GThZtLYonse3iJfHXNCdcVtyvgxU46LSS/ZHmz/+27bvqk63tbcL+2hX9K
	3BsOaK1Pf5nqhCqZSI4v1uzSe6u/R0a7mDkuw+SHM7oDCkUyUWruHsCDIbTwX+e4XCWsPr
	jskiQGVaYjKuGlBNKg4oIoZgk0O9HUBpFV3vVK9B0sucQOT4JVcDMdWuwFYwC84mWPMri2
	w+0+2+vEzknaY/V0PByOln3pThQ6oKK7lJKQ7Jsz3/geHZzwhyM+DmQTpVmJJQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mihai Moldovan <ionic@ionic.de>,
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	linux-wireless@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/12] net: qrtr: support getting new endpoint ids externally
Date: Tue,  8 Sep 2026 12:31:34 +0300
Message-Id: <20260908093145.2492666-2-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
References: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is originally based on a patch by Mihai Moldovan, that allowed
registering endpoint-specific data and getting endpoint ids by the
endpoint-specific data. Unfortunately, the old API did not support
freeing the ids, creating a memory leak if someone repeatedly unloads
and reloads kernel modules. Also, the old API had O(N) complexity where
N was the amount of leaked memory. Because the patch has been
extensively changed, I reset authorship.

So, the new patch version only supports getting ids externally, with the
idea being that MHI controller would know about its endpoint id.

I made sure getting new data ids is permissible while holding a
spinlock, since multiple threads may race to get the same id.

Originally-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 MAINTAINERS        |  1 +
 include/net/qrtr.h | 10 ++++++++++
 net/qrtr/af_qrtr.c | 42 ++++++++++++++++++++++++++++++++++++------
 net/qrtr/qrtr.h    |  5 +++++
 4 files changed, 52 insertions(+), 6 deletions(-)
 create mode 100644 include/net/qrtr.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b42e898f4d8e..491f09cb7939c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22506,6 +22506,7 @@ QUALCOMM IPC ROUTER (QRTR) DRIVER
 M:	Manivannan Sadhasivam <mani@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
+F:	include/net/qrtr.h
 F:	include/trace/events/qrtr.h
 F:	include/uapi/linux/qrtr.h
 F:	net/qrtr/
diff --git a/include/net/qrtr.h b/include/net/qrtr.h
new file mode 100644
index 0000000000000..762d60b03012e
--- /dev/null
+++ b/include/net/qrtr.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __NET_QRTR_H
+#define __NET_QRTR_H
+
+#include <linux/types.h>
+
+int qrtr_endpoint_get_data_id(u32 *endpoint_id);
+void qrtr_endpoint_free_data_id(u32 endpoint_id);
+
+#endif	/* __NET_QRTR_H */
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 7c50d32b11015..86a92e95e270f 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -11,6 +11,7 @@
 #include <linux/wait.h>
 
 #include <net/sock.h>
+#include <net/qrtr.h>
 
 #include "qrtr.h"
 
@@ -753,8 +754,8 @@ static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt,
 int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 {
 	struct qrtr_node *node;
-	u32 endpoint_id;
-	int rc;
+	u32 endpoint_id = 0;
+	int rc = 0;
 
 	if (!ep || !ep->xmit)
 		return -EINVAL;
@@ -763,9 +764,18 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	if (!node)
 		return -ENOMEM;
 
-	rc = xa_alloc_cyclic(&qrtr_endpoints, &endpoint_id, NULL,
-			     QRTR_ENDPOINT_RANGE, &next_endpoint_id,
-			     GFP_KERNEL);
+	if (ep->endpoint_data_id)
+		endpoint_id = ep->endpoint_data_id;
+
+	/*
+	 * If we're registering an endpoint into smd or tun based qrtr,
+	 * we don't have endpoint_data_id. Thus, allocate a new one.
+	 */
+	if (!endpoint_id) {
+		rc = xa_alloc_cyclic(&qrtr_endpoints, &endpoint_id, NULL,
+				     QRTR_ENDPOINT_RANGE, &next_endpoint_id,
+				     GFP_KERNEL);
+	}
 
 	if (rc < 0)
 		goto free_node;
@@ -857,13 +867,33 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 
 	qrtr_node_release(node);
 
-	xa_erase(&qrtr_endpoints, endpoint_id);
+	if (ep->endpoint_data_id != endpoint_id)
+		xa_erase(&qrtr_endpoints, endpoint_id); // did allocate
 
 	ep->id = 0;
 	ep->node = NULL;
 }
 EXPORT_SYMBOL_GPL(qrtr_endpoint_unregister);
 
+int qrtr_endpoint_get_data_id(u32 *endpoint_id)
+{
+	int rc;
+
+	*endpoint_id = 0;
+	// GFP_ATOMIC to allow while holding spinlock
+	rc = xa_alloc_cyclic(&qrtr_endpoints, endpoint_id, NULL,
+			     QRTR_ENDPOINT_RANGE, &next_endpoint_id,
+			     GFP_ATOMIC);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(qrtr_endpoint_get_data_id);
+
+void qrtr_endpoint_free_data_id(u32 endpoint_id)
+{
+	xa_erase(&qrtr_endpoints, endpoint_id);
+}
+EXPORT_SYMBOL_GPL(qrtr_endpoint_free_data_id);
+
 /* Lookup socket by port.
  *
  * Callers must release with qrtr_port_put()
diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
index affc24f426c64..86c9b4e724d7e 100644
--- a/net/qrtr/qrtr.h
+++ b/net/qrtr/qrtr.h
@@ -21,6 +21,7 @@ struct qrtr_node_lookup_helper {
 /**
  * struct qrtr_endpoint - endpoint handle
  * @xmit: Callback for outgoing packets
+ * @endpoint_data_id: an already allocated id to be used instead of new alloc
  *
  * The socket buffer passed to the xmit function becomes owned by the endpoint
  * driver.  As such, when the driver is done with the buffer, it should
@@ -32,6 +33,7 @@ struct qrtr_endpoint {
 	struct qrtr_node *node;
 	struct qrtr_node_lookup_helper helper;
 	u32 id;
+	u32 endpoint_data_id;
 };
 
 int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid);
@@ -47,4 +49,7 @@ void qrtr_ns_remove(void);
 int qrtr_msg_get_endpoint(struct msghdr *msg, u32 *out_endpoint_id);
 void qrtr_sock_set_report_endpoint(struct sock *sk);
 
+int qrtr_endpoint_get_data_id(u32 *endpoint_id);
+void qrtr_endpoint_free_data_id(u32 endpoint_id);
+
 #endif
-- 
2.34.1

