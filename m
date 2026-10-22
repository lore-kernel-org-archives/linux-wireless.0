Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792691001;
	b=5E4KUtOIrRvj3eGNT1XPfYEA6eCNnAVtnLLsTrIVCdGB91fhF/34vUTS3LBKPhwfwfMp
	 YJ1JDybPO3uNLqJiQ0087e10tGSxg4mDABycE4hY8J/cvzPcqxGfmxMKsjnpGxFbjgl7O
	 ELwsW9hZ/oT3fy8z42VumvKQfkSyZzPgtFlfWu98zNQq086tkDnkNHllwsGEm8S4jF1r1
	 fXr86iIOm/iwvJEuNRheGE2AJKoGfHJlnqQTDJSHvf2RLId0Z5IRTnTazZzK3oJv9ZogT
	 +gROaiVOBp2UQXIY1BjPV7l86O0bnoLTjl8Yy2WDn73XP+0PAS4vGWGAspjNDo4DDNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691001;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ADWdCCi+iizlsM98N39+pquefHMXXpgP0VwZ90V6c1E=;
	b=C8r/Xqn7QWh9wob4iaWFXfElOhanWCOhoEL94c1Qf7JNm+tkuF+FNdXT0Fw9YJETUy0E
	 MAGgvT8YvGEXVshZDjOjHRuVSqeBmmBSyRDTtRbZZWDSMAYSraopnSKIzCcsnCjwezgoL
	 VZGk5thM+weEl3fDthqSaRo+Adzu+hV/1dfyhHfwIBi+fVww2gvBep/2VeQgT6Blxoovu
	 9sDNFq4uNxXsMj43tCpxZaTXRxoGmDWlFlYNvhfg1qskzKmcIvvduvtrtvFWDjsVrvRwl
	 g2qx2n4d1EY4f9l+QxOK7stuXW4KeWLuL1aZ0piqX74l6q5ZRiRBeEmnfbTciHA7Mbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T0VwSJYt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D65C606A332;
	Thu, 22 Oct 2026 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T0VwSJYt
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792691001;
	b=jbKNmLGSmuDZ9Fm0+xLWa12m1vMaRXVrtXvUeSDj1UaLpGaDkvX8fqh7nt3iUzcqeNY9
	 uSkAErkL+g6ubKR6CuZoBWHdI/zVIOgXMUrbYP2jhj5OdmbdKyFWn7XV0moDEvynCHs6n
	 hTD4V/+1OyUl5AV05cqSUgS8NIOSyGqowc/o+ZaDUrHw91N/yr1bS/Ov5ghZNh1xjKSHI
	 6lJ1fVT8+vHZ7ggYmPGTvj0+RSCxKTR4fQCi4O0ME2t1AH7ZNj5GKjPBOtIN3dQ7dnKU+
	 k5Kjas3qI6aw9wSSIDQ5wxxtKKRv2xtY/if7llgn89cZJ+POCpnr7WN+wvrJbhS+M+w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792691001;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ADWdCCi+iizlsM98N39+pquefHMXXpgP0VwZ90V6c1E=;
	b=fORBzXxoQabBWSabQHsrPp98+dW6YuGSBqF50yHNftxF+K3AiRjCGmuQDwYN8f1BM/FN
	 t91v9PDKH+60fUuWFW/I4bYbOjI59tJIWX8BBT5sz2/FduKwbJAULpNXow9U6/svmJSyQ
	 a3UTDzGcKS4OG+P9ykR32YHaaMFHkcCtltFjncH53BvxrlYtW6pzX0hx4XfmNJ+/6jeLG
	 Ff0yv6Mg86t1KBUXmTpxMotlr2LpGzSPhYgE8Er00097KVpVc2IH3u2s8J+AOIKK4mb6j
	 cczVwEGOAa5FchYSmfXZWTRhenk6Z+1rHELVwcf9avn7+gd8cx4DvY2ie8bppW/5PuQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6831E1F031E0;
	Thu, 22 Oct 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792691001;
	bh=ADWdCCi+iizlsM98N39+pquefHMXXpgP0VwZ90V6c1E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=T0VwSJYtLWy5OkIhzpsbbRvQUIUB81DkRzJPcICgziHUv8nwWqBws7xi+/xRJRfzH
	 dnHwiL95TVC2z9dwNTHUE2c/dlTFHqk8Ke28X4aVXFrLHtv8AKrrixzbXKrjLksb0J
	 g7IyYxh9g6n6nkt7wcNHzBdncWM/3tA6Z2DudZi9MbZ3uAX25fIIYfT5nqVzFy1lso
	 OTpAvTfaltn43GdKTA8sRQYU/xHTh2AszbJJi5AmotqsQ/4wOZk8xgBc25xOhkHXRZ
	 imYUllQBKRhzmmOC+SIhqR6s9uOG7MsFV4+ttO25eJoUFyuDP39bigdXd0SVzC9zFV
	 bR2qPJUoa/lmw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D670541E99;
	Thu, 22 Oct 2026 17:43:18 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Thu, 22 Oct 2026 19:43:09 +0200
Subject: [PATCH v4 3/4] wifi: ath11k: Connect to the QMI server belonging
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
Message-Id: <20261022-qrtr-multi-ep-v4-3-c6fdb75fcd3e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4091;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=5fbq8IwxgM8XJ6aODOGmdRnrrzV+MomZgCeu5eoQmhc=;
 b=owGbwMvMwMUYOl/w2b+J574ynlZLYsi65W2SvVmxnE/cf5vntrT6rW+c7n+oMLh3iNV1o53Gs
 +nWDSGenYzGLAyMXAyyYoos6UudtRo9Tt9YEqE+HWYQKxPIFAYuTgGYSOIq9v+ZiS0zIxv2mkd5
 rw3vvck3P9T0eInqj32COwM9itraiyRM7prfdPaPD3YO4BZ9niK8tyRCzWvPr9dbfdbFRxVGP57
 Bo1YmwBA8W6y/91gUL7PGPYtTV35P4n4neZ+Vz/J3sYd/RrH7Gtbwf/q3/JL/NKe/y1XbVV+wzJ
 T3ULXSjNR0zc1uZk0m7ceWf/VfX/b6RZXEVLU9OncfJBt3NRvr3uEuXPe8XZLfJYt1jTSD4Juap
 J8Tn0al/LTk7pdfksl5UEXp5DItDgPl7Tm55X7RE6cKBqZ+Ea6JP1TweZfpiweer5MNT9qtLT33
 83GPFouAqQvbB6YqpxKvz77da8JOsWRMqb2UOCUz8TcA
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
index 7dc07339b957..6d86e552038c 100644
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
+		return -EINVAL;
+
 	sq->sq_family = AF_QIPCRTR;
 	sq->sq_node = service->node;
 	sq->sq_port = service->port;

-- 
2.43.0


