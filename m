Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B6E513550;
	Tue,  8 Sep 2026 09:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859963; cv=pass; b=AbKKot8mgiv0NSYvEoRHR6jCKw3XedGuSyPtcQj6BAYs2c6Hb+VgqM1lLwWligfQAp0Fhod5RcNmlr4/h37V1gKWZAURKv+vvt+6w1wAM9VvnzbWuu7HsoQRVyJ5SXf9BhiHrD32gcwwlFL5508CT3UjV6D3MSoMBkFLXLfaKJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859963; c=relaxed/simple;
	bh=jm53VqNDB6v/9bNj/RPzRe0AynScrjMNr2hvumK9x+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pEFolDBB9FTNvbsMH4tSaAXn09W06K6ENgfc6TzOv0r6QnfLdffBc1qTrd/9ZLuU8Mh+OXyrC/ZpvtG/24/48sBlryG+nOnJFU2ZMPFhpjX+3wxGxqz8oC4K9sfKt+qUxzimkodLpnnsTXxchfHJ1hlChDR1kUMOBZhCgLWmxgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=IOHk0Pyx; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="IOHk0Pyx"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJd02Bz0z49QLK;
	Tue, 08 Sep 2026 12:32:36 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788859956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+aZSiwdH5N1vZ7BksR/50oyXsfQFMsN7A1hoQYbSHs=;
	b=IOHk0PyxMbRa110ROyJG+jpxWrz6imAFItRZY7Ws/ISGnw90PgCxNAmdunl/Iwky/R0x/q
	5erbDh/W2fL9QwC1QgoZ6YdfuDxYqF8wpmGA85OjAYLLqw19l2/C5p5wVk021/BH+Xrz9I
	GpdWsNMm3Z0rQqw1HPqHxPfcA7Pk+XqtanjEZ0JeqZoto2sJjG9jjHFG6VEqIjwMSp+uZE
	R/5xiWBa6PNJPUeMucmt+uc+/zP/oj7a6RhBgl2fK97xOcoE0PyXwJIIGBYVL03+lW2czN
	5tQMbTjNJDMq4RqvUHXtsYmTN/tjyjcgxwuHgRP5dtgfIDVHnM0ejt6MOpshzA==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788859956;
	b=S0Qdm1I33KvJDZdEFzvKrvsI1FR/L6oD09Z5Rz4Pb58lFKyduuN3RuNG6gcaJJJVJJk3DT
	KI/bIND2nAS6G8lzRpKazMk6STy+BpNo/5U2p6hRflKnaJHGNRtPb7/pEMustKICSFQyZ0
	wvQFvt1bGthETT/AyitE1SODp/s7pjmjrvexo/RTpNkdE4L9NjAcoxwcfN9tEqP1C4rTwL
	gwSTbipm+wDN2UjG5G5yhG4rTHnonxMXe5P7CdPpMQXOgbq7V8uj+Q3LtToSOPuGe9W38f
	fUyGnTr1jxZC3bls3HbKNfvLkWRVX8qEu627xCyUUhU4dp8N82eC8zYmM8meeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788859956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+aZSiwdH5N1vZ7BksR/50oyXsfQFMsN7A1hoQYbSHs=;
	b=h8B95emPsI0cqOacxnRJxFm968kwJhkpiRRufQIET2PxV7nvRvftNWvyihd7M1Rqqlu/DZ
	TWd922cFJJkbuDW9aRUA4QLEc0UDly7WKmEXMZGq7vOqJQCNSemX1MRfVKRI5/HjVPQrRt
	To8LY7cyeXSCdDS6ME8/wNYqTo+Z6YELqhd224tM7dW0vORgHx7eOdTD+7AkchNLj7bjS0
	nZBH5hTJiVljL4XBgo1eiiJSnRzzJl0/ZhDFSL95GA5695XH8uOLAwuSCeeQ0e/EjaYJl0
	heo27wKkdSveYo2YS3HjcMKuXskpYHcsLUEmE8LSe5ylx0kIZpsiK50tuQkCCA==
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
Subject: [PATCH v3 03/12] net: qrtr: mhi: register new qrtr endpoint id for mhi
Date: Tue,  8 Sep 2026 12:31:36 +0300
Message-Id: <20260908093145.2492666-4-juha-matti.tilli@iki.fi>
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

MHI will use the mhi_controller data structure to store the QRTR
endpoint id, as explained previously.

Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/mhi.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 630ce0da060e5..60d85f126bca5 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -116,6 +116,17 @@ static ssize_t endpoint_show(struct device *dev,
 
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
@@ -130,6 +141,23 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
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
@@ -150,6 +178,9 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
+	mhi_dev->mhi_cntrl->qrtr_endpoint_id = qdev->ep.id;
+	mhi_dev->mhi_cntrl->free_qrtr_endpoint_id = qcom_mhi_qrtr_free_mhi_id;
+
 	return 0;
 
 err_unregister:
-- 
2.34.1

