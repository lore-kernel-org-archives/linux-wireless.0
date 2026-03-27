Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F963E6DE0;
	Fri, 27 Mar 2026 13:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774617212; cv=none; b=MXmyPKcxSa/Aaz8RpvvZbajTJRSLtLz3cofCCq+2tPh8H8taXn6WedZP/d06IWp5HO3yU21jH76GDxwXd5wr9M/WoJtIsLk7xgIxArLfDGXJca6frGNtm2wsR+563HRcbPGuk+mJvaWCOSFeuT4oZfdPeCw3QN1Jzx6VAEt5O3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774617212; c=relaxed/simple;
	bh=xYlvJO+JflPgYH7lV81mrAxzP35EX+W421jGEAyidpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmBHIQx9w5W1yqsOczLfyc8R3mpmGJM9n5yTFPK8zElinwOGsYNVxoSeo79unh4wvl9ko5u6IcR+19ifJc5QHtzC7Rug5JMZewjwz0E/4hygFb+MCafztesN2pbCM3oglsaW3ne3P3OHYNglAvT6O5+PJ5m3t4OGxbBqNKh1jAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATyfvKGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATyfvKGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21E6C2BC87;
	Fri, 27 Mar 2026 13:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774617212;
	bh=xYlvJO+JflPgYH7lV81mrAxzP35EX+W421jGEAyidpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATyfvKGUmnv1kKnubs6IiLKUN4mUdaYjdI2G6QVAhehE1B+B5pM968CUWnh79vDZV
	 qbcMBvWPgvwiD8IfqILDBYLus+CdHaP+aJHmLJBKSqCtSir41Tl5Cpm4QMkTkCPgTJ
	 b9WmzcQzgu7PJzM9xxBssGMWIrteWCePRPk4eTjtAldyIv3ebIFX+S8Ie6RXbp4OjN
	 Yflewz9fGgFda2MnKV3CQPSSMoHW6V2p9ESaCH5pfAyW5XIkeUOvRYnxzgO3JlOP9l
	 7BiDeSrZZmh7v6bzIKiRDOEHfDZu1fbPpNxk1WA8p2wrioLUAppV1dth3AKcUL5HIw
	 Qp3sRJpgPNQHQ==
From: Sumit Garg <sumit.garg@kernel.org>
To: linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org
Cc: andersson@kernel.org,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	robin.clark@oss.qualcomm.com,
	sean@poorly.run,
	akhilpo@oss.qualcomm.com,
	lumag@kernel.org,
	abhinav.kumar@linux.dev,
	jesszhan0024@gmail.com,
	marijn.suijten@somainline.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	vikash.garodia@oss.qualcomm.com,
	dikshita.agarwal@oss.qualcomm.com,
	bod@kernel.org,
	mchehab@kernel.org,
	elder@kernel.org,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	jjohnson@kernel.org,
	mathieu.poirier@linaro.org,
	trilokkumar.soni@oss.qualcomm.com,
	mukesh.ojha@oss.qualcomm.com,
	pavan.kondeti@oss.qualcomm.com,
	jorge.ramirez@oss.qualcomm.com,
	tonyh@qti.qualcomm.com,
	vignesh.viswanathan@oss.qualcomm.com,
	srinivas.kandagatla@oss.qualcomm.com,
	amirreza.zarrabi@oss.qualcomm.com,
	jens.wiklander@linaro.org,
	op-tee@lists.trustedfirmware.org,
	apurupa@qti.qualcomm.com,
	skare@qti.qualcomm.com,
	harshal.dev@oss.qualcomm.com,
	linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: [PATCH v3 09/15] remoteproc: qcom: Select QCOM_PAS generic service
Date: Fri, 27 Mar 2026 18:40:37 +0530
Message-ID: <20260327131043.627120-10-sumit.garg@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260327131043.627120-1-sumit.garg@kernel.org>
References: <20260327131043.627120-1-sumit.garg@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sumit Garg <sumit.garg@oss.qualcomm.com>

Select PAS generic service driver to enable support for multiple PAS
backends like OP-TEE in addition to SCM.

Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/remoteproc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index ee54436fea5a..da3c5d9562ea 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -230,6 +230,7 @@ config QCOM_Q6V5_PAS
 	select QCOM_Q6V5_COMMON
 	select QCOM_RPROC_COMMON
 	select QCOM_SCM
+	select QCOM_PAS
 	help
 	  Say y here to support the TrustZone based Peripheral Image Loader for
 	  the Qualcomm remote processors. This is commonly used to control
-- 
2.51.0

