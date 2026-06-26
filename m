Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD193F23D7;
	Fri, 26 Jun 2026 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481083; cv=none; b=SZbFwClkDl8cds7MulWv/+pZmquzohvrUOYjLKSGDu7Y6cjdQKGxHsm8SZQPSw1AaWrJVjNlyUEAn2rsbbUIpfurNexK90j81WWHj10owG4W2kYU4STX+KKTsDRw5mUhvO3N2hOn0jovuSWqOGrHQd6JL6A2eV8Unsr9bEzAXdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481083; c=relaxed/simple;
	bh=CWzjxofT51d/7Jh9TIJ+t+j7D7AxrnjtWXRf/UhKxyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEwvnvAy4e6FsW54mXYNaLKMcxWcVmudnHGXLQTHzuAQhyEyJLXVx3/k1NrXqavemFyDQnu2wlUlgn/m21cRy9+DfSTgOvZZfls/BSIOLO3lZZYK55at6Uww9mRjb5CvHP06KoxMoMYcYdQ2IdLsucEsOkdigVvDnUghcvE51uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwFpMxvR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwFpMxvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACC21F00A3D;
	Fri, 26 Jun 2026 13:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782481081;
	bh=iyRP6bU8GJwZIUhpMbHL1XggSQuYlDgwK1TwcImYTrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwFpMxvRpfAKkvj84g44PYk1X91/f7jZs29AVgqKOoefwXZDvMmVya/eboUtgdE3N
	 KjUOkoCFVUsKThToHZcT/rKczr7Ee4DBurfFDGw5fiIq26oeBZaLI0oGPJH6YRR96J
	 DY11bXS5pPOYvWTpbwVqB3l2eJdPdB4DLOQrMIyIpje95SGZjctigUszFsc04K7b7i
	 lohQnA/b3YtSFaDNvjdyd4aEN7n1ex/5NC6kAVF4qbQrLlkIHYrRK8h538Vg65sPx9
	 5wY2CvwhTR9ikKAWntRNQmB6fnmhu6gRsGpDc6VXFZ+pUKxkmMGS45p0xvekdKf0cl
	 joPXCQpsCWRkA==
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
Subject: [PATCH v8 05/14] remoteproc: qcom_q6v5_mss: Switch to generic PAS TZ APIs
Date: Fri, 26 Jun 2026 19:04:25 +0530
Message-ID: <20260626133440.692849-6-sumit.garg@kernel.org>
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

Switch qcom_q6v5_mss client driver over to generic PAS TZ APIs. Generic PAS
TZ service allows to support multiple TZ implementation backends like QTEE
based SCM PAS service, OP-TEE based PAS service and any further future TZ
backend service.

Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
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
2.53.0

