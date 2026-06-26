Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD573F5BE1;
	Fri, 26 Jun 2026 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481148; cv=none; b=ONIZ1AUORCAL3l5pKgKZkR1jAGLibTdI/6Ani7bCGUoQ2AwRixF7sK5piF4nozxkySE+hGHDg6tlFeKiSRpydoJ6wYzjLqhIASnKCCubSGM0g7Xh6bJbYSA5gWdoMrh8Q06nVU5RnfI23D4iopZi1GOjgCGridcaHbFplGsqmvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481148; c=relaxed/simple;
	bh=nu/9jxEBb2QLVeD4GmCl+KtHNFoX99ZtqK0bcXucmKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMI24wcVlIeEJMrtPGufbIxEFHTb4UF3c9TjbiB1h5BEEnv8Kph1jDJctzChu4facJvG6HzyMoYYYCtXkaiEHPuh0utZp8iHFmL8w3g6foOZnveUd5kBRzhzS3gmDwUCMtoBj0oH3d48o3Lel5Cbc/7B4sWOu3WNdqNG9NH4e+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQv9Xoru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQv9Xoru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A831F00A3D;
	Fri, 26 Jun 2026 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782481146;
	bh=YdTarFeUf3JjHQc11F/djDf59yjjzefRJxb3z71PqNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQv9XoruYe7wHbQovFN7TSIPIgS85BkX/hRx/IKyL7A44ybmDyLfF75QIXDVpD+14
	 0JOAsPT7GGpLWNfRhB6fshsXlahTrWvw0g8Vw5YUH80Oiyg0m3UL497BrF9sOXNJdo
	 IVvF4HjFKj5aNy7Dy4/a/uzl79wd5av36rQUPdGW7L2la1Qig3gspQiR2b+aFv17XL
	 UuSR+RyLRkBP0McUw/EZr753/rb6AcvamREK8Qp10Tt9Dsw1m0lCTFm6iW7ewILt5Q
	 27nMaIU96MqZgzxUCFzjWIES4cGmZMMWYVNpRV/W1K1uig8M73YaiU63Wlz5phQqnZ
	 xTUe8jOPtbZsA==
From: Sumit Garg <sumit.garg@kernel.org>
To: andersson@kernel.org
Cc: linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org,
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
Subject: [PATCH v8 07/14] remoteproc: qcom: Select QCOM_PAS generic service
Date: Fri, 26 Jun 2026 19:04:27 +0530
Message-ID: <20260626133440.692849-8-sumit.garg@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260626133440.692849-1-sumit.garg@kernel.org>
References: <20260626133440.692849-1-sumit.garg@kernel.org>
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
Tested-by: Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com> # IPQ9650
Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/remoteproc/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index c521c744e7db..65befdbfa5f7 100644
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
2.53.0

