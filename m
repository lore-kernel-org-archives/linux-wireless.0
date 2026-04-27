Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5903B0ACA;
	Mon, 27 Apr 2026 09:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777283916; cv=none; b=JYI+J5TOwsbRFenw0n/33+tXwqf//MaclPW5/cz8MWycd7gr4cf4N0glqfnhNT3l7HLbgh055JNyOmaCxYRH119RMTgexMxuVLLNBR3ER5/dYd8DHStddIsIGSAxdB3Y5UdZVXx5dhjgOd/yVjjXLLQru+9x5Z4Xww2kcgYOSis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777283916; c=relaxed/simple;
	bh=xYlvJO+JflPgYH7lV81mrAxzP35EX+W421jGEAyidpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7FMnqfUJqOwWdu/XdlEt1BfWQqPYo8C4fL9W6vgLqfo+ftZ2nto7VX7T4r5h9/2V9iSUzDvwKBJNT1/djkAKe6Qv7QHKZ9k/Ws8AbhKfaOGp0ILQSVbh62xtNo9g14MKu+mysVuiTSbQRptP/EHgQTh+Bp+dyZzFWqqy512QS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=poZiuXQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="poZiuXQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCB0C2BCB4;
	Mon, 27 Apr 2026 09:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777283915;
	bh=xYlvJO+JflPgYH7lV81mrAxzP35EX+W421jGEAyidpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poZiuXQaK+RMtf7K2aOlAUJi4kCbFFBuAtE8LsuQaL73aE65NbJ832nqq0RwR74jN
	 BV4kY+BPz3ughnNyUdsvqIlQ5EMHiFhzjJBF9Aokuew+S+s2+U3Mp9+yhSs6CE8y6p
	 FR0BPZxUU9d+pSSJ3alTf/lO7p1F6D2bOqfQe6zpZnQyRSfJgp4xGJ8T3zefDswcml
	 GpOxyuLDmr5TzuICuLCUKBiBBBt2xI6w6peUGOVpEmrUKpSWzkw38p8rjZLC4naGoK
	 zek/cp3u22URZRBVte6v2qcCju0lFb8E5b1ev4X/9Q6ehAg4NDRYZEaVnczI+RuWlK
	 xPM7/7NBSWing==
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
Subject: [PATCH v4 09/15] remoteproc: qcom: Select QCOM_PAS generic service
Date: Mon, 27 Apr 2026 15:25:57 +0530
Message-ID: <20260427095603.1157963-10-sumit.garg@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260427095603.1157963-1-sumit.garg@kernel.org>
References: <20260427095603.1157963-1-sumit.garg@kernel.org>
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

