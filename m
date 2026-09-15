Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3D445D900;
	Tue, 15 Sep 2026 07:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458176; cv=pass; b=TN/AX3sIzuu381/NsZZv6YE4UsYDeX9kdhDdGxGbT4/XMK3+9x3fuVEuLEYMaHdg6xmbj2By7GHMuAvAf12zhbBwueFCaGGo1f5XOcCtvjf7eZjc8A0V3nIKenM3SRkUbIrQMUog+EXqz+B9gHkTzkNvh1oHs+YVb78hJ2RVyi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458176; c=relaxed/simple;
	bh=B8GhkT17+ArMORtb+3H5LoP0LqXXLHms78MLvyrKV2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kKriGNlDaaqJNNvjEnK5fw5asPpYXq1YkxUbENY3Dv5bQ50QNn8DzTVvekqHv6Io1jX88UuczHgQPBe3AqaG66W12ukjL++6BhrR2MuLErE1C4J7oqoiuNaaOeAS+Siljsl/gc6Oq1fE+ZwIZX3AMLlR+Qul7T1OD8E7fua9cEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=AuaAdn8Q; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="AuaAdn8Q"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkYs14CQrz49Q6x;
	Tue, 15 Sep 2026 10:42:45 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789458165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Angl7vosthCmbDal4tBWwtsxKy9LKqnIGYA36AA3r48=;
	b=AuaAdn8QybOKuXFMOM/VlqmJAQl0rjaUuLhJdMz8qmaIY1HPGmxldld4a8eaVKArjRD/Xu
	v8L8QxplrxY0s/GxWEyIUyUQ8xmnkogGJP34ekzJQwEiXC/f1yvtwGnErnNbw5G4tTRwBP
	EZTCYHOET0h9C0IepiwJ6JYDSYxGMGbsd3OeCtHNvWOWfK/t6MKtgITfGEHe8BJ3PI1O8r
	t2LrcaknHwghjY35WODghaWkKz6aJ2wku6kgyTKJULJY6Kgl6Igov/wlT7YK1mafdEZ8fY
	ovv78PzXqihiQ02ImEfZqJHMxLO+unGvzvLJve0gTRR9/NwZqf/TMZ2gKadPYg==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789458165;
	b=PI21Vk+wZ8LkVQLq2V/9DSFWzUxKDoFE6euN+9TlhVDEUgEVcMIRakCFP0F5UKWIPKDOLj
	sGlh7o3+XcxLOk7KVNaFdDVoCUaS0uc58W2NnNWZ7WMXSqKdOG1Kkpmm81Ak1lbs/Ii3KF
	A8ff+K6ScVueQdtHg2j4nv7UURQ0mpBEk1PPk+MCH5qzJHMDQWRfDXhKnKddgNHgCSd6Ka
	Tu+gX1a+wSicLQmwsH4/JH5TSh0uhZBDq1Eo0By2izgd2eW4KO3QOLaLpM6U7WSqPLw9sF
	iTLtRGgu1Yq+kmj9j+HyqythxIPoiMSG7UIHLd3EdhHZTaPRhPt44rsebULYLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789458165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Angl7vosthCmbDal4tBWwtsxKy9LKqnIGYA36AA3r48=;
	b=Jmr8WyOQa1eaf0rWN5jxieyYjlaqymiojPz24wbUkvtpsvuOaciiSdQ+eeNd/Efo0a7ffm
	veFW9+YUzD73BHfL6vavVoePX8dioUSgAooGYjg6D9TWo3h44x55sUODMuggzsOw8E5JBi
	ne1mDX+/e24ZJsWZd3/E4DPM/kUaoN8TTLQaGNHsGdoFKHJbUV5J7b/ZW4YrGXw61lFnRO
	zoI4mSuhySwnyd9EY0bCxoS2IdA7duWMiVcvpsZkQrMLuYxTy3YkSAvJAACQTkpfwTRZd3
	mx7T8b673kiZo1qCy6MZ4BKSFKXdEkJ2m0SH1BHb6Bwz8KmuyyO/Em7wHfhfQA==
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
Subject: [PATCH v4 03/12] net: qrtr: mhi: register new qrtr endpoint id for mhi
Date: Tue, 15 Sep 2026 10:41:26 +0300
Message-Id: <20260915074135.2567411-4-juha-matti.tilli@iki.fi>
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

MHI will use the mhi_controller data structure to store the QRTR
endpoint id, as explained previously.

Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/mhi.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 630ce0da060e5..41b58ab854725 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
+#include <net/qrtr.h>
 
 #include "qrtr.h"
 
@@ -116,6 +117,17 @@ static ssize_t endpoint_show(struct device *dev,
 
 static DEVICE_ATTR_RO(endpoint);
 
+static void qcom_mhi_qrtr_free_mhi_id(void *mhi_cntrl_void)
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
 static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 			       const struct mhi_device_id *id)
 {
@@ -130,6 +142,23 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	qdev->dev = &mhi_dev->dev;
 	qdev->ep.xmit = qcom_mhi_qrtr_send;
 
+	spin_lock(&mhi_dev->mhi_cntrl->qrtr_endpoint_lock);
+	if (mhi_dev->mhi_cntrl->qrtr_endpoint_id) {
+		qdev->ep.endpoint_data_id =
+			mhi_dev->mhi_cntrl->qrtr_endpoint_id;
+	} else {
+		rc = qrtr_endpoint_get_data_id(&qdev->ep.endpoint_data_id);
+		if (rc) {
+			spin_unlock(&mhi_dev->mhi_cntrl->qrtr_endpoint_lock);
+			return -ENOMEM;
+		}
+		mhi_dev->mhi_cntrl->qrtr_endpoint_id =
+			qdev->ep.endpoint_data_id;
+		mhi_dev->mhi_cntrl->free_qrtr_endpoint_id =
+			qcom_mhi_qrtr_free_mhi_id;
+	}
+	spin_unlock(&mhi_dev->mhi_cntrl->qrtr_endpoint_lock);
+
 	dev_set_drvdata(&mhi_dev->dev, qdev);
 
 	/* start channels */
@@ -150,6 +179,9 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
+	mhi_dev->mhi_cntrl->qrtr_endpoint_id = qdev->ep.id;
+	mhi_dev->mhi_cntrl->free_qrtr_endpoint_id = qcom_mhi_qrtr_free_mhi_id;
+
 	return 0;
 
 err_unregister:
-- 
2.34.1

