Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85BD394470;
	Tue, 15 Sep 2026 07:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458365; cv=pass; b=EEK6uZuKd00QBKTtX9L2UnIYIQiYKt/w+vFOIdq48CyvIpopVyJBsCpK0OgKdAYb0uaP9xj5rp7qrRZufTlUtapdt3qd/MLVWsNejyU2f5zKCxvjcojsjXjbHyKd8DvCsPIY+1Rf01fhg7KOaSf39oe+f2PVE9yRdZ1SG4n+LwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458365; c=relaxed/simple;
	bh=xs+RvB1iCnuBwduzzzqF2lCfl4nixTxCqex0JP+Z/Lw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JCDGO0uDCYU1mTggN8S1wFcgCwCOEMRUnZqo1zGzTt7/qD42VszEUs4F6rWbIaHdeK15jZiGvxKiu1a+ArnkyYuHvr/CdlUxgQzF0Ng27qwdD6mbIlhAQj73/6b367yPaiN3ZUjCWv9cPO9FKWP8Fjnbqiss/PRu+pZpXCEsDMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=tkgoV7sH; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="tkgoV7sH"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkYwj6jV6z49Q8v;
	Tue, 15 Sep 2026 10:45:57 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789458358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DkkTpGuw3kjQPg0827cXMo9wlb6PxVdztbjyv9fxYRE=;
	b=tkgoV7sH2MyxlYGpctGt4LQrpHRunNaSmutUxAwS8R4rneEuLo6wapJOB+7ahBVHd4eMyu
	0zaXbe/KTFVON0cH6Hjkeg9X8oRd/MfuslJBwDcDiU1N/qKuwZebcqUXPgpFA2pTkGlkXU
	UdSP9B2lUS4t9pwBuK6k88zB64YJBeWGTi6NMhURYFm2vdEYUtpPGWEfkt1hM9E2b972g7
	hh8KMFUbgftOSLwRDoMpUQy7ymjSipV8B1ahr9NokKXZbp217mPnDCqKZfJsPOgvnZZ5aX
	ivY3/1Y1pBkHUWKovWgROIu15gZHGu3GcfR8nY29NbjebsX9gr65rN33LrvI0w==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789458358;
	b=BhVhSAt39LAEYLm8MPu4TDgVBTBSJzLcHDOozD6K8OW0yr/Y0wq3G3cfR3JEhYvtz1/2DH
	q78Nbtlv88W8gG8AZfehIioxvhAD2cDZsw6WXlOO6IzVVNle9Gb90WGIaJWmjyFLDFs8/m
	plw5Ohggsdmz22uZU6YzCloBVY2eULfnbWT8G3DDA98xdeL9g80yay21eQFTWsP12EA6U+
	xzh7/pBz7+/c8LrKwQBvwi3RJSIWxBafK1x0beAZkF9y4+egYpO5msoTQJfFa23bQEdsnI
	Jbb5LZQIUrl4FCZ2hZikfv9HqCmZAxYg8rC3rip7hDRPTTRL1feP6aum2iJNSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789458358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DkkTpGuw3kjQPg0827cXMo9wlb6PxVdztbjyv9fxYRE=;
	b=j+qBtzUZIfx3Eh4TxJcT9X1c1tNEBJ+QR7hhqkRIwArNZgyykrKkIn8qHu7oNCQ3kKfcYR
	74ngVDvXRq7a0RIlfCSlvKEM2pKjhi5Vo49kqvMv+KE2KsoSysjaeLESgwpX3N4dLmz5KK
	hIqwLkA2o0b+fbokzsN0eqwlnqFMK6pyV+y29KQ4oZ1GBDyBjPqrE5rOAfF3a+1z7sQy9N
	gTLM9IsSG2IPLsa2fnjFJYD5JgLOJgVJEo/CrOERTwXVR1tjUVcmykCNDuixFfjqRa45iR
	8MRoJ82L1q6S9Mh2kz5IhHbuqQKNSbz/iub6ShieOQzB9pi2xR4O++fQejFUYQ==
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
Subject: [PATCH v4 11/12] wifi: ath12k: implement QRTR endpoint ID fetching for PCI
Date: Tue, 15 Sep 2026 10:41:34 +0300
Message-Id: <20260915074135.2567411-12-juha-matti.tilli@iki.fi>
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

QRTR endpoint ID fetching for PCIe devices will use MHI.

Originally-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 drivers/net/wireless/ath/ath12k/mhi.c | 46 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/mhi.h |  3 ++
 drivers/net/wireless/ath/ath12k/pci.c |  1 +
 3 files changed, 50 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mhi.c b/drivers/net/wireless/ath/ath12k/mhi.c
index ee87f00bc5de9..3d0884e65939d 100644
--- a/drivers/net/wireless/ath/ath12k/mhi.c
+++ b/drivers/net/wireless/ath/ath12k/mhi.c
@@ -8,6 +8,8 @@
 #include <linux/pci.h>
 #include <linux/firmware.h>
 
+#include <net/qrtr.h>
+
 #include "core.h"
 #include "debug.h"
 #include "mhi.h"
@@ -527,3 +529,47 @@ void ath12k_mhi_coredump(struct mhi_controller *mhi_ctrl, bool in_panic)
 {
 	mhi_download_rddm_image(mhi_ctrl, in_panic);
 }
+
+static void ath12k_mhi_qrtr_free_mhi_id(void *mhi_cntrl_void)
+{
+	struct mhi_controller *mhi_cntrl = mhi_cntrl_void;
+	u32 id = mhi_cntrl->qrtr_endpoint_id;
+
+	if (id != 0)
+		qrtr_endpoint_free_data_id(id);
+	mhi_cntrl->qrtr_endpoint_id = 0;
+	mhi_cntrl->free_qrtr_endpoint_id = NULL;
+}
+
+int ath12k_mhi_set_qrtr_endpoint_id(struct ath12k_base *ab)
+{
+	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
+	struct ath12k_qmi *qmi = &ab->qmi;
+	int ret;
+
+	spin_lock(&ab_pci->mhi_ctrl->qrtr_endpoint_lock);
+
+	if (ab_pci->mhi_ctrl->qrtr_endpoint_id) {
+		qmi->handle.endpoint_id = ab_pci->mhi_ctrl->qrtr_endpoint_id;
+	} else {
+		ret = qrtr_endpoint_get_data_id(&qmi->handle.endpoint_id);
+		if (!ret) {
+			ab_pci->mhi_ctrl->qrtr_endpoint_id =
+				qmi->handle.endpoint_id;
+			ab_pci->mhi_ctrl->free_qrtr_endpoint_id =
+				ath12k_mhi_qrtr_free_mhi_id;
+		}
+	}
+
+	spin_unlock(&ab_pci->mhi_ctrl->qrtr_endpoint_lock);
+
+	ath12k_dbg(ab, ATH12K_DBG_PCI,
+		   "queried mhi_ctrl QRTR endpoint ID: %u\n",
+		   qmi->handle.endpoint_id);
+	if (ret) {
+		ath12k_warn(ab, "failed to query QRTR endpoint ID: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath12k/mhi.h b/drivers/net/wireless/ath/ath12k/mhi.h
index 3674326763858..3e692ce0b5108 100644
--- a/drivers/net/wireless/ath/ath12k/mhi.h
+++ b/drivers/net/wireless/ath/ath12k/mhi.h
@@ -41,4 +41,7 @@ void ath12k_mhi_clear_vector(struct ath12k_base *ab);
 void ath12k_mhi_suspend(struct ath12k_pci *ar_pci);
 void ath12k_mhi_resume(struct ath12k_pci *ar_pci);
 void ath12k_mhi_coredump(struct mhi_controller *mhi_ctrl, bool in_panic);
+
+int ath12k_mhi_set_qrtr_endpoint_id(struct ath12k_base *ab);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 6441927b53822..7b73672e5e8e4 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1508,6 +1508,7 @@ static const struct ath12k_hif_ops ath12k_pci_hif_ops = {
 	.ce_irq_enable = ath12k_pci_hif_ce_irq_enable,
 	.ce_irq_disable = ath12k_pci_hif_ce_irq_disable,
 	.get_ce_msi_idx = ath12k_pci_get_ce_msi_idx,
+	.set_qrtr_endpoint_id = ath12k_mhi_set_qrtr_endpoint_id,
 	.panic_handler = ath12k_pci_panic_handler,
 #ifdef CONFIG_ATH12K_COREDUMP
 	.coredump_download = ath12k_pci_coredump_download,
-- 
2.34.1

