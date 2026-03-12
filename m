Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AF1282F38;
	Thu, 12 Mar 2026 06:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773297048; cv=none; b=oC8A9KoQ1IA/PglvSolQK/Mm7VIO10ZF7QLLls+kRI0ekIYDCL/wptCSdfNkcjI+xgACbkttWUhrowhJkduYYF1Q4aRdSJkqu7EWTYi0ioV4b9ZRCUFgjskGjKsJ69mQq8GhRpTpuG5Rex3Zmw9TncDjftFI++ko2out2kUWCb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773297048; c=relaxed/simple;
	bh=+WPauxWCOutLzKrZffBXMMITweY/oTZZzgDQTHSVJK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSS/xW1STdPjQ7IYamaffCncWaxfu9QtCv7BvtWDxT7KioK+EX7yFQ0M/kwaZeRQPF+o3ymHODNSHUUZIGaOKlDYZckKCHGCILtLduYEfpt07FQ4xodQTIRkhYUHyPVB2Zou8GxC9feFj5A0/qB+vof509140CPl8doQgS8LVzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2PZMDy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2PZMDy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCF7C4AF09;
	Thu, 12 Mar 2026 06:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773297047;
	bh=+WPauxWCOutLzKrZffBXMMITweY/oTZZzgDQTHSVJK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2PZMDy1DnDnL/cFxTNim4OOAk8ACgOblXvZM0g5M9szw/8ayW73FfUnEUo2UQYKW
	 s5Dq1lAm7nPY1OpQHbb7+yTzr2hlkTaIyw03YQfgekSTDfXQlM6vS8Cfc0tH4mIx5o
	 1ka+BQ+B0+qMU3an4ZCsVtqC9Kd22D6I+QxpZmSyXyGP14siteCguaa01Y5TUbgb5D
	 2jrBdFpZ/AWwvCx1Cji0DY0q1KKhkr9YSRkqDdiUoBl4ZLEWCeeOhuIv4TetsspBZm
	 4kdgfbiE7rQLLabzwB7suAodPKcIOFVSZ5Et/RAEkBPXa2XGKALC+0OvHdAAdJOueZ
	 yOLmefPL7PoNg==
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
	linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: [PATCH v2 09/15] remoteproc: qcom: Select QCOM_PAS_TEE service backend
Date: Thu, 12 Mar 2026 11:57:50 +0530
Message-ID: <20260312062756.694390-10-sumit.garg@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260312062756.694390-1-sumit.garg@kernel.org>
References: <20260312062756.694390-1-sumit.garg@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sumit Garg <sumit.garg@oss.qualcomm.com>

Select PAS TEE service backend driver for the generic PAS service to
enable support for OP-TEE based PAS service.

Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/remoteproc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index ee54436fea5a..0411a38530d8 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -230,6 +230,7 @@ config QCOM_Q6V5_PAS
 	select QCOM_Q6V5_COMMON
 	select QCOM_RPROC_COMMON
 	select QCOM_SCM
+	select QCOM_PAS_TEE
 	help
 	  Say y here to support the TrustZone based Peripheral Image Loader for
 	  the Qualcomm remote processors. This is commonly used to control
-- 
2.51.0

