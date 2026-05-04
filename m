Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428DD3D523C;
	Mon,  4 May 2026 13:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777900152; cv=none; b=g+x2VtzA5CC4LIbObauz9RA8PmmhglQAQVleN+Fievf2MVVkSRMKFpMvVbY/LFEc1bJZvtbUWaW7D1vgYezz/7PwtTE7BJvlUDbvxVzem2YqMHaZqckCeJxbCzqu5CqzM7O/rcz3+0zI1RO/rrxxF4G998l9IqWWKo5YimkOEIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777900152; c=relaxed/simple;
	bh=Ww69rZmwVfBry2lRl5WuseohUPKiZtw6HZ59g3rgRO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTTf8BhVh+PlhK8JVd9TQXrYSaFgcnwUY/17c0uhu4nQNlaxL6ASOuIxZzJgFZjndX+UfJhjzc227+G3Bzd/EnwTW0WpeaF1LO50N7kumFTPy+lVnTrqOVnJRqKbRKU0jcIwQyaajfr77EYGjGDa94oo2zu2CE8conb54js3tyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwT4SPx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwT4SPx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F33CC2BCB8;
	Mon,  4 May 2026 13:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777900151;
	bh=Ww69rZmwVfBry2lRl5WuseohUPKiZtw6HZ59g3rgRO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwT4SPx8fDc3IWKVYzvLC/6GjTeDBR12CeCMECLKgRvSNW+C1LpPLY6gDVW0pGIkC
	 oubAKUE/l8N9wN5MtnNmUCgZEpk7y1zDe5JI1zNLmRUIn0Nh32ZlnJd10MpKvhu6IA
	 wB83+Yj+tfPWGeHw+nE/DFZfCfPprMsCLeYUu4ZiNaWQOQkl0PrIcjd5IILHTXLw09
	 dN8Z07KqzNYiJHM9ZxvM1rgvPBoO+rer/3hnMZiPH0E8v+vfThDTL64GktPczO7JaP
	 OPB2U96vAkgxj8ziYK+1gVJ63ZN6ZQIu42gKIf5y110+wI/M/CqxNnjXQlgEp7LlRR
	 0sMa74wRGE9Ew==
From: Sumit Garg <sumit.garg@kernel.org>
To: andersson@kernel.org,
	konradybcio@kernel.org
Cc: linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org,
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
Subject: [PATCH v5 09/16] remoteproc: qcom: Select QCOM_PAS generic service
Date: Mon,  4 May 2026 18:35:56 +0530
Message-ID: <20260504130603.1474043-10-sumit.garg@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260504130603.1474043-1-sumit.garg@kernel.org>
References: <20260504130603.1474043-1-sumit.garg@kernel.org>
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

Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/remoteproc/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index ee54436fea5a..9a6ca30e1481 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -210,6 +210,7 @@ config QCOM_Q6V5_MSS
 	select QCOM_Q6V5_COMMON
 	select QCOM_RPROC_COMMON
 	select QCOM_SCM
+	select QCOM_PAS
 	help
 	  Say y here to support the Qualcomm self-authenticating modem
 	  subsystem based on Hexagon V5. The TrustZone based system is
@@ -230,6 +231,7 @@ config QCOM_Q6V5_PAS
 	select QCOM_Q6V5_COMMON
 	select QCOM_RPROC_COMMON
 	select QCOM_SCM
+	select QCOM_PAS
 	help
 	  Say y here to support the TrustZone based Peripheral Image Loader for
 	  the Qualcomm remote processors. This is commonly used to control
@@ -282,7 +284,7 @@ config QCOM_WCNSS_PIL
 	select QCOM_MDT_LOADER
 	select QCOM_PIL_INFO
 	select QCOM_RPROC_COMMON
-	select QCOM_SCM
+	select QCOM_PAS
 	help
 	  Say y here to support the Peripheral Image Loader for loading WCNSS
 	  firmware and boot the core on e.g. MSM8974, MSM8916. The firmware is
-- 
2.51.0

