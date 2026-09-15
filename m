Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CA445D900;
	Tue, 15 Sep 2026 07:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458305; cv=pass; b=I7203+17yfQxLiI2fZ3qIp4LHsRGCbK7VOUOgGJggMj9hV/pQR/Xh4hcfOJi+sRKDTqAhGvK68iqNs1kFeb3rMdwO+Bdu0oW2FEDCX/qaOos48cOhUZPraPzZlzg8dVQvdLHMm2/3SZs0fCo4Wh20QZPfvfn2KXunUyDgFPgWNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458305; c=relaxed/simple;
	bh=enV2kS1MIwHjXbYjHjRD3HBW9Nc1XOK61bJzzLEmGds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cTZIvSeCUG/D7syGJhTys4ugV6J8WCCqmZY2iFMUz5HTZf3CGx8nw1s6kQw0d0V+rwGebvgsy6ZOoeKKR1qZHtnn8f73RSnKwpzmHQfqtyZeBY+tJwPeFHAiyUzwQUD2elqOCOhfTaM0YtuPvnfzJGCLtAFhl0hYEu/oUtlcTdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=fssxXVkK; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="fssxXVkK"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkYvZ2c8sz49Q6x;
	Tue, 15 Sep 2026 10:44:58 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789458298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dMiUD8CXxFO5/POyjEVKFLNmf5/jxdGfzIul6o7WvA0=;
	b=fssxXVkK8DgY8iIwyUdYnqoRCtMiHEoxVRRWm0G8vv1PLLCrk50pDW4XSGfO65dlOgGz4K
	CLiHU91nnRkM9yZYAe0bn7MP6wr/OOoVbOEcGHpw5sIr/QFdnsr1MG9QJ1eRs64zk0kJ1R
	YyTIF+r3kFcduNuF8f5BkG8y+2NxuaDGV+FmgyhHx2W8NhUHHN5nsYNglR/oS6ebLza/aY
	xMTZNae4DdTfjpuPa1qsNY3DDYaASg5nutiOTBz6ZDPnhX1qyzn87onVuOUNOetZcYUMwJ
	w0X6GS6+Z4EYUxRH5mOwlLb6IK3ckT9Dupq7mYYPjh8scOOh/oKbt0tdR9pWLg==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789458298;
	b=N622PJwHRKgr2SvSUv6xpskxMSna5SH66lZizoeezWBVc1Nr8xwXgeJ8E3ctpjJCAjNU7M
	tnlGNuYMLMkdz8QUDuUadky6Vg8ceYl0b+PUB/w6cFn1mn+ghgAF0MymuAhbuh2Z3NHU7R
	cVHg0F1w3FUghd33uMY70OtZu5XHtRU9oaJEaEGu7pPsFcooneBElVD8DKAaez3pyRffuT
	VCe+0Da4uSio4gqm9nW+VtzMnjtB32tgqgtSR4mQnRkLwyqIUj8z9Y1viVgfXN+oV8ldp8
	VBLvGtak69sJkrguezB64K933GQ3oOTDcQheP31zb+wntK42g45XDlpA54uVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789458298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dMiUD8CXxFO5/POyjEVKFLNmf5/jxdGfzIul6o7WvA0=;
	b=O6xP6DD29KaPJIzUUa5MGKvZCo6jvo/pFzuknYmdV2JRtADc4Y+a7oei9GD9HSgSozC2wq
	+XVZY9V/ly2hWonri9Cm6juH4C06kqSllOQGjfdJkIrV9kSeX6osKtEUWiPWFd/pFXeok6
	/KRADscJHkfo/kNK3r2vr0/S6Jm56kQWm2M7KjAnEKEj5q/IR8ztvWX0zVaEKojY3vwWjX
	gwHw5GaYVK73t8uOCMuL6g50k+HMvgG4DUVkRUvB9g/Ta8vhTxFpL7Yg8yQN6S30ZrcPIH
	fZYvqhlBU9/0WEeeNo3/HiI8bQDT17huYgajARx1Ft0CO7UHlXufz5BGUJhOpw==
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
Subject: [PATCH v4 08/12] wifi: ath11k: implement QRTR endpoint ID fetching for PCI
Date: Tue, 15 Sep 2026 10:41:31 +0300
Message-Id: <20260915074135.2567411-9-juha-matti.tilli@iki.fi>
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
 drivers/net/wireless/ath/ath11k/mhi.c | 46 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/mhi.h |  1 +
 drivers/net/wireless/ath/ath11k/pci.c |  1 +
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index a6c9ff112c68f..755a57b6058a1 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -11,6 +11,8 @@
 #include <linux/of_address.h>
 #include <linux/ioport.h>
 
+#include <net/qrtr.h>
+
 #include "core.h"
 #include "debug.h"
 #include "mhi.h"
@@ -502,3 +504,47 @@ void ath11k_mhi_coredump(struct mhi_controller *mhi_ctrl, bool in_panic)
 {
 	mhi_download_rddm_image(mhi_ctrl, in_panic);
 }
+
+static void ath11k_mhi_qrtr_free_mhi_id(void *mhi_cntrl_void)
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
+int ath11k_mhi_set_qrtr_endpoint_id(struct ath11k_base *ab)
+{
+	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
+	struct ath11k_qmi *qmi = &ab->qmi;
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
+				ath11k_mhi_qrtr_free_mhi_id;
+		}
+	}
+
+	spin_unlock(&ab_pci->mhi_ctrl->qrtr_endpoint_lock);
+
+	ath11k_dbg(ab, ATH11K_DBG_PCI,
+		   "queried mhi_ctrl QRTR endpoint ID: %u\n",
+		   qmi->handle.endpoint_id);
+	if (ret) {
+		ath11k_warn(ab, "failed to query QRTR endpoint ID: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath11k/mhi.h b/drivers/net/wireless/ath/ath11k/mhi.h
index 7e7561ce883cb..46a9c978b30d1 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.h
+++ b/drivers/net/wireless/ath/ath11k/mhi.h
@@ -28,4 +28,5 @@ int ath11k_mhi_suspend(struct ath11k_pci *ar_pci);
 int ath11k_mhi_resume(struct ath11k_pci *ar_pci);
 void ath11k_mhi_coredump(struct mhi_controller *mhi_ctrl, bool in_panic);
 
+int ath11k_mhi_set_qrtr_endpoint_id(struct ath11k_base *ab);
 #endif
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index a163168f36176..56490a21964a3 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -918,6 +918,7 @@ static const struct ath11k_hif_ops ath11k_pci_hif_ops = {
 	.ce_irq_enable = ath11k_pci_hif_ce_irq_enable,
 	.ce_irq_disable = ath11k_pci_hif_ce_irq_disable,
 	.get_ce_msi_idx = ath11k_pcic_get_ce_msi_idx,
+	.set_qrtr_endpoint_id = ath11k_mhi_set_qrtr_endpoint_id,
 #ifdef CONFIG_DEV_COREDUMP
 	.coredump_download = ath11k_pci_coredump_download,
 #endif
-- 
2.34.1

