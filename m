Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6C63B3BEF;
	Mon, 27 Apr 2026 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777283873; cv=none; b=r/sxTrJ+UFhFsa05lnU6e4V0A0e/78HLkWkMA9AjuLls7kNRD7mKJB32T7f5BVu+urHAg5onJt9O2k2qequD6Hk725cE5OQJJVuuQIi6OxrH+pWm+mMpmAxZv7uMW8Nm7uRTskL/O2zKyzurXFkvGxqf6PTbW+Bn9CVeX2r1i4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777283873; c=relaxed/simple;
	bh=5si9p9X+QdKOUj/kEC+OxqljHo6dif086Up1Mo3twcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfnB0DbYlWdjxs/VKuCjICgLKJpWmcAxPO6fMfJiyn00sNgUyg7yn4dJ7YO6yKYHHgh8fhjrieEybm6OCuIUubM2bVjjRdG8XyalQVMIjUQ6iOongxsYCtffCPUeeWzGTZbKnmBxghX5oXMTh+BTC+xqOzkpO5sRP6oe5EEhGK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZ9bXcmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZ9bXcmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FBBC19425;
	Mon, 27 Apr 2026 09:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777283872;
	bh=5si9p9X+QdKOUj/kEC+OxqljHo6dif086Up1Mo3twcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZ9bXcmJU6u6s38rF4Nnjw6SoDEJKoVZH8lE1sqhS0fDzscFXMeSO1kjVR3xRILKl
	 m1PsnyF4zb+1zveZDnnfNPCabApls2FlymUpbpIaQZQtCe0U2bLrB4qVoTUzqjGY+Z
	 pzCRiL0kVtcpgq2S7J5Vplz6vnQO4GZ6oAfna42tHLBOMJdR3l/54iYqLuMmqT94Ho
	 y34bDP5x4w28FrvSsd5nxlKVWQLeDzcE5YMUiuyaTQEg514ouNZB7optAFLtx7xvFP
	 tYlswTDUg72W3VxO34uOVAyv4q5/oZxsXmhzy4oZaf9l8cQYCgbgcWmW/fsQ+GY3EJ
	 BpRtrPMLsj9Bg==
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
Subject: [PATCH v4 06/15] remoteproc: qcom_q6v5_mss: Switch to generic PAS TZ APIs
Date: Mon, 27 Apr 2026 15:25:54 +0530
Message-ID: <20260427095603.1157963-7-sumit.garg@kernel.org>
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

Switch qcom_q6v5_mss client driver over to generic PAS TZ APIs. Generic PAS
TZ service allows to support multiple TZ implementation backends like QTEE
based SCM PAS service, OP-TEE based PAS service and any further future TZ
backend service.

Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index ae78f5c7c1b6..96888007faa8 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -34,6 +34,7 @@
 #include "qcom_pil_info.h"
 #include "qcom_q6v5.h"
 
+#include <linux/firmware/qcom/qcom_pas.h>
 #include <linux/firmware/qcom/qcom_scm.h>
 
 #define MPSS_CRASH_REASON_SMEM		421
@@ -1480,7 +1481,7 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 	}
 
 	if (qproc->need_pas_mem_setup) {
-		ret = qcom_scm_pas_mem_setup(MPSS_PAS_ID, qproc->mpss_phys, qproc->mpss_size);
+		ret = qcom_pas_mem_setup(MPSS_PAS_ID, qproc->mpss_phys, qproc->mpss_size);
 		if (ret) {
 			dev_err(qproc->dev,
 				"setting up mpss memory failed: %d\n", ret);
@@ -2077,7 +2078,7 @@ static int q6v5_probe(struct platform_device *pdev)
 	if (!desc)
 		return -EINVAL;
 
-	if (desc->need_mem_protection && !qcom_scm_is_available())
+	if (desc->need_mem_protection && !qcom_pas_is_available())
 		return -EPROBE_DEFER;
 
 	mba_image = desc->hexagon_mba_image;
-- 
2.51.0

