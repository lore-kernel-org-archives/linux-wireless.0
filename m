Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F3B43DEC2;
	Tue, 15 Sep 2026 05:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451251; cv=pass; b=eWI0hXPYzYuAUhdn5RQo7aFVkVtVpivV/xwb0wCF7ma+0cDO9VvjyEdNHTl35aTxctzK2xrTq/k+FMZoSfGRF9aDkpk/Aqf+Zw2ZTV6SH4k/DGk9SurWfCuW3tywvSvlh3aI5hYs1cVfMuF/HnTu+kYVP3VG5xuWhyqELAQD7TQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451251; c=relaxed/simple;
	bh=rxPegwfWsbhaXnaOfXAiSIbv8UqPN8bqJ9GM2VU5AGA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e6uUDvaVGFhpkNyiXop8yInYP2dO5Bp2nJRODXt5G1/jm93DJ9ux1YbE2zrdVGu9XDd/tY6uLQqb96//1Y07r7WeZlUFPyIaERsEWPcAeJ9yQ7n0owsN6enRcH2+Bms1bwsCurxFYU+DYCYnhQeGwszc/NFiB5UAkIKFH5OT+Yg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=BWRfjJU2; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="BWRfjJU2"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkWHv3QkMz49Q6x;
	Tue, 15 Sep 2026 08:47:23 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789451243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8dnLpIuawa/T5WKzmKQT35hCSn6pD7KsZ9UF2NkcKc=;
	b=BWRfjJU2Y1pi/YVWwpzyOTK4sAjECFATkJ51d8lxvHUftCGPXPk94J+hB2A5QY0v9ONrFo
	/GMVsrnydVc9q8Ci4Xu+TWTPxoHllx1DPnS8U4VyaKr0esBo6BQAmmJcQRuYUMTdYnV0Ov
	5M2gwnO27CB8P0UagBvD2LJQopfVc2uVVjm+RTSwkzHL2oJs/XqtTXtgDwszkRg/qLu5sb
	z8YHZEKOYmLADKyej1j9n1ZBiryUenCugC/UYHIC3sK7rH1M8zbgQFwPm6e82Fb4tDPG90
	cqBz9cSaR32DxtiqSIhH7agp90PpM7ORZVIlJtM4gTSPTubdEtJ1fCDFap9iHA==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789451243;
	b=SsHBof+dIMMLHxAnF5KvFGo2Exe9Z4BYZUwq6kJks0+G+kjGpqy2xQHg1s8yO9cncDfHW2
	oyi4gSYtt1nWAGT3Sq/Vdn/7JLS18EvZX3EIgPqCzmf5pdHQptp4naivJ4YQhnxp31U+nr
	yVNNXSZyq8PryhhzhVZSSkaPQzVr32IRXWAK/3oX3oukHf/armce2jake+OHHjeAg6rTRG
	RAAhOJAgW4vZfilI365RKMoKA7yu+1MSVie6t+pBiJ2CXeNDR7mToErgjw6pl4h4MTgPxg
	bcSiQygjB6tGKJLNh8kNIq4B4Ev8pQDuIbknrK2/iyWmbWxAFtC5zxMbKJyK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789451243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8dnLpIuawa/T5WKzmKQT35hCSn6pD7KsZ9UF2NkcKc=;
	b=fNJkeDHqKc4dOdtUsnvq7Gp4t2WKpLJq+NYagZIi7oX2SuUNv1nyPZKQ9yapDSk6tru5+o
	Mst19EtwC8XIJaGXooKfxUxQyvN6gyCxX90GJQFc0kFzo2IeUX9yqYntMKEPNChF658cFa
	09qrwo7iWDFOD66ENwFtm0gdomX1p3zo2Wpahfl8+pzKpcJIWEnUNa9ZCwApGvzM7QP/vI
	ryEKW/IQ7vp3siWMob7Tkqu50OPd/grIvOp31MsenkKOn3ZuJHlXELJF1eJDWmh5sKU/we
	Tu3RhKEgNGcx8jvi/Ax72PNOJ/LFN3k2OVZS9RmLA0cRov+5n4ouEd+kegR6DQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: Manivannan Sadhasivam <mani@kernel.org>,
	linux-arm-msm@vger.kernel.org
Cc: Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Mihai Moldovan <ionic@ionic.de>,
	Denis Kenzior <denkenz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Andy Gross <agross@kernel.org>,
	linux-kernel@vger.kernel.org,
	mhi@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	netdev@vger.kernel.org
Subject: [PATCH v7 12/15] net: qrtr: mhi: Report endpoint id in sysfs
Date: Tue, 15 Sep 2026 08:42:04 +0300
Message-Id: <20260915054207.2513877-13-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis Kenzior <denkenz@gmail.com>

Add a read-only 'endpoint' sysfs entry that contains the qrtr endpoint
identifier assigned to this mhi device.  Can be used to direct / receive
qrtr traffic only from a particular MHI device.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Andy Gross <agross@kernel.org>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/mhi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 3990da1a65dc4..630ce0da060e5 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -106,6 +106,16 @@ static int qcom_mhi_qrtr_queue_dl_buffers(struct mhi_device *mhi_dev)
 	return 0;
 }
 
+static ssize_t endpoint_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct qrtr_mhi_dev *qdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", qdev->ep.id);
+}
+
+static DEVICE_ATTR_RO(endpoint);
+
 static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 			       const struct mhi_device_id *id)
 {
@@ -135,6 +145,9 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	if (rc)
 		goto err_unregister;
 
+	if (device_create_file(&mhi_dev->dev, &dev_attr_endpoint) < 0)
+		dev_err(qdev->dev, "Failed to create endpoint attribute\n");
+
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;
@@ -151,6 +164,7 @@ static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
 {
 	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
 
+	device_remove_file(&mhi_dev->dev, &dev_attr_endpoint);
 	qrtr_endpoint_unregister(&qdev->ep);
 	mhi_unprepare_from_transfer(mhi_dev);
 	dev_set_drvdata(&mhi_dev->dev, NULL);
-- 
2.34.1

