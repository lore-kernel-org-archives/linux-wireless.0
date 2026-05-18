Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A283DFC99;
	Mon, 18 May 2026 07:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779089495; cv=none; b=PNi9DtGOig1bEp7Ob9DxxhPT5POgYyHmxPN4o2yktFZILTXgveQXgStB2tzjijwnSB5cisiMFPZDnMjhRetfcD7KkbPwRB6QBzKdJJcW0YAPQr8i6hYSpQvBTQ66h6qioatT355F+3yz8is+Fn9xGYcKndmbTrPv+H/DV+yxMMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779089495; c=relaxed/simple;
	bh=Ww69rZmwVfBry2lRl5WuseohUPKiZtw6HZ59g3rgRO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwiteBiRYamwp3iR2HVsu9P/0ZoCUXvkjliciwRwxD3BLG2K/krvVmXE+ZQ/Yg4zvXhoZVM8CLg61+KpnzDGDabKwxMl4qaWjom062IvuCMLv87dsn6YtHo2X3XZpSlKEApGcYT1K7pnLEnH6pVBMkCya70RnhGeQAuICjMJG9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pICJrdOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pICJrdOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37B3C2BCC6;
	Mon, 18 May 2026 07:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779089494;
	bh=Ww69rZmwVfBry2lRl5WuseohUPKiZtw6HZ59g3rgRO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pICJrdOVnorVkG5WlgqTjBwM4o29OAcyf0YTiGkKifaJTZKcXXH9FSB+dv/zzDQWq
	 E5mh5Eki2G6Inn2ukv2h0RHClWs4oYRwqfwGKOAQMHHvFypJHbex27cO0YQdHJ8BW5
	 StdM6HcpQRRcHQTHKwInPvOFDZK3bSaLzkO7nXwQjSp7QmDSOCfGyUpZFjWrxEgfyg
	 GtLhrPIifW8CghVTpxUDqIEZn+3WcmJ2R7rNCjEcf/3GAHNVU63aqpWFy0LzirGQ5m
	 siMaeJWrVnqByiHWoD2DkI9989N/hvhZOqyA3jeTHuK6qK6CMWYJnrlJuCFHaUL2Id
	 ciwLEv1BKI8uA==
From: Sumit Garg <sumit.garg@kernel.org>
To: andersson@kernel.org
Cc: linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
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
Subject: [PATCH v6 09/16] remoteproc: qcom: Select QCOM_PAS generic service
Date: Mon, 18 May 2026 12:58:49 +0530
Message-ID: <20260518072856.22790-10-sumit.garg@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260518072856.22790-1-sumit.garg@kernel.org>
References: <20260518072856.22790-1-sumit.garg@kernel.org>
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

