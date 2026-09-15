Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968E38F651;
	Tue, 15 Sep 2026 07:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458140; cv=pass; b=mONdqzHHO34XeiSOAa1LwM+5uSQLXbN5XpbMV6mjxlrcw8zkqeNA37QFx/tBkV4j3xQl3Cl4u/c/kOJnjt+/Fi2JXdnP96fHJeoIuPDdyRoA/V0R/SdshK7KfltxYU22eispcBPDNCP+DaBidfGX5Pvrcoi2wYtNw0ULDI9+230=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458140; c=relaxed/simple;
	bh=2DqcLFZjMCwvz4P2NATYwLxdAxbP1BJo+S/HUmZkm3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eY+/xxRhdhXjADMGVEMLlgiX3dAl9glAi12iCh2Mb3GcZrjQ/grPyhIoD0UBSSlmxoXa57767UDfaus61Rv3+laxr10tMv+wqYIAQ5A9yWI7akTHwyljgVtJw2PbiKfgUjCyT8z7mrAE4Sm86Eh2BctJwkRXGdcQvXfx8y5GA9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=hQ3sLSty; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="hQ3sLSty"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkYrM3MVdz49Q6x;
	Tue, 15 Sep 2026 10:42:11 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789458131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnSIfRHoHMbuoGc49ZmGo5twqqhr6EXzw54yp5CgxrQ=;
	b=hQ3sLStyGskXfdK19cDQavOa4VJlyQtDSRKDOk9CAhITDiscVOMVnp+laekRBZXZ8ytn+v
	xJpfZJOUatK98uLYAKb23IJ2eGRzqRA35O80miwCMtTbSodbWrClqeGZqDXGpL3Rg2i3wb
	QhyJrKZRlJ34EEA74y78pN9eX3LbIcqQ3iEM/XJXXm/DtpMcvaHHPWJ8I1H5p7LsfA6pKT
	a8wA70SAU8OaB+W1tPNw27oo6UKRQOTuFU8sOoJj0QQCLMDNjuqVtc/yoYkPBZfoRF06kV
	apCpLNVrog0aNHoE3agZrAQz2UePqokQcqqmeG9c/me1pLrbHa922tIXUIa8CA==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789458131;
	b=C/pGxqJYK2JYz+STw8K0inNrDk38CVhpuk9d/0y3V1hV7io0DlgdS0JgNhueIvcl3thrz4
	t2tFD7zt7YxTu1R4d2Qv8X0Pr02qLMDFE8xNJhsDgpCjQORni82zoJBVTX21kR4nN152ks
	pmjR9tapfLN4bcZFfmDzaXiLtV1B9kMcjESh5zpQBkGM8+Hrf9yrmIy/5+dCTAMMflS32+
	ja/UfEE/GQBsAQ1ts/pL6eSGNTLBsORg+rrcP64nrdRpHyLUdgk3J/bx1JZDS355n0vwuP
	KUsTBGc8Mrm4+XiU9lyPwPiJkzY0u8HcpHsHTpMp8Ur8VKb53aH192MXZweZxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789458131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnSIfRHoHMbuoGc49ZmGo5twqqhr6EXzw54yp5CgxrQ=;
	b=NvnlXjzXw4+cc211btM8rAfzKKrsjm3nL7IC1oUmMxJSAdrfyF9RUY9OoGausJOiTFo3rp
	tD60t8dtaRgxrDnuVADBgkB82GuHRkq8GJcmKa/FbOqPCGL9CEZPTTQiBRst0/luuZlFHT
	RdpxwzVFwKaOLLUWXscVeGYGFU/RqnVS5aclKtAoz5fszwYUYNyl77K8J8DHIiKaTaOmFw
	x20ig+IIOUo0ZqjQD5iurrAISKkTILGFyRRRzkmfsBY/79iwK0Q8FUwmC7Y6HQCraY/lfp
	fXN6M6rdzLRhw9uOaB0mhYPbb/e/CGKkHfDkoHKgzML1r0dHzw5aSi9LdDaXHw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Mihai Moldovan <ionic@ionic.de>,
	Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v4 01/12] net: qrtr: support getting new endpoint ids externally
Date: Tue, 15 Sep 2026 10:41:24 +0300
Message-Id: <20260915074135.2567411-2-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
References: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
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
 net/qrtr/qrtr.h    |  2 ++
 4 files changed, 49 insertions(+), 6 deletions(-)
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
index affc24f426c64..45e38be0b2cb6 100644
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
-- 
2.34.1

