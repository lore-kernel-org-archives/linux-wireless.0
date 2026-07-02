Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA0547AF71;
	Thu,  2 Jul 2026 12:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993633; cv=none; b=UYx029Q6gZnMQqgdIN+xGaxUR/cYKlSG0XcB1sAguR1D3M/hCVES4djM46KHeyT+8EprAqLAqmPAjgq55h7YhSwk/60lYfXnqfH3dbXRvIxIGxS4LLVMtHy4cU/1uSWZ1uHfbkFrz/0braaxWp1Q3SpbsaH9Bade5/Q64U2kMeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993633; c=relaxed/simple;
	bh=6tRC7tZMAK5eDK5NBOHer6WMu3gt84gQPYX4SCBd0Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDPCMzhQV/7G3FvADwH0PUG0kM3R1PYN9UxhXxp5WeXhXwhNvnXJepBVywvqT/ItMuGxKGjdr+eBciInY5NSOQ9VTsAsYHVPbUaPju2uxnA4ZpRkVlFvZMHrLMtebmL0WwhME8UAc0teB5hxJtfp2b0HxaYaDY4SoPzQ8pOjw00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUjbxMfQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUjbxMfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5976D1F000E9;
	Thu,  2 Jul 2026 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782993631;
	bh=g7FpjBIt0YeokSFzLC6S/XCaod58GFwuLHuUF8Xfqag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUjbxMfQep0Npbs2gHIS0sUTSCCw54soOpfH2nkVrZBh6QQ0x0S74HNHRtpkuwiu+
	 27AwM6fjUMErPybxGHSy30FC//loGNqZKep/0XO4qLvJO3lTls1vwKWRPUqvNC/FNl
	 OFsJIFvBco1mmroKQjN8q/+49y1M7ZBIQYuYjMoYTAxYfLMvaD8ApKysiPO6bGwk8V
	 hZhnfiKCG82xb5CnZNmRFJINqzgFricsfqzAzC0s2CyeLtt1SwnV69jl3jlKpjcGpa
	 +ygWmhygSZ7xrDLiCphUpiMu3tmA3/jZ4c8DVW0e4XD0lP+Qzm3GE/ftNantxESkEx
	 TSp0Rul1rnsHg==
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
	jenswi@kernel.org,
	op-tee@lists.trustedfirmware.org,
	apurupa@qti.qualcomm.com,
	skare@qti.qualcomm.com,
	linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH v9 06/14] remoteproc: qcom_wcnss: Switch to generic PAS TZ APIs
Date: Thu,  2 Jul 2026 17:28:22 +0530
Message-ID: <20260702115835.167602-7-sumit.garg@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702115835.167602-1-sumit.garg@kernel.org>
References: <20260702115835.167602-1-sumit.garg@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sumit Garg <sumit.garg@oss.qualcomm.com>

Switch qcom_wcnss client driver over to generic PAS TZ APIs. Generic PAS
TZ service allows to support multiple TZ implementation backends like QTEE
based SCM PAS service, OP-TEE based PAS service and any further future TZ
backend service.

Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/remoteproc/qcom_wcnss.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index 4add9037dbd5..0dbdd18ab3dd 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -19,7 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
-#include <linux/firmware/qcom/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_pas.h>
 #include <linux/regulator/consumer.h>
 #include <linux/remoteproc.h>
 #include <linux/soc/qcom/mdt_loader.h>
@@ -257,7 +257,7 @@ static int wcnss_start(struct rproc *rproc)
 	wcnss_indicate_nv_download(wcnss);
 	wcnss_configure_iris(wcnss);
 
-	ret = qcom_scm_pas_auth_and_reset(WCNSS_PAS_ID);
+	ret = qcom_pas_auth_and_reset(WCNSS_PAS_ID);
 	if (ret) {
 		dev_err(wcnss->dev,
 			"failed to authenticate image and release reset\n");
@@ -269,7 +269,7 @@ static int wcnss_start(struct rproc *rproc)
 	if (wcnss->ready_irq > 0 && ret == 0) {
 		/* We have a ready_irq, but it didn't fire in time. */
 		dev_err(wcnss->dev, "start timed out\n");
-		qcom_scm_pas_shutdown(WCNSS_PAS_ID);
+		qcom_pas_shutdown(WCNSS_PAS_ID);
 		ret = -ETIMEDOUT;
 		goto disable_iris;
 	}
@@ -311,7 +311,7 @@ static int wcnss_stop(struct rproc *rproc)
 					    0);
 	}
 
-	ret = qcom_scm_pas_shutdown(WCNSS_PAS_ID);
+	ret = qcom_pas_shutdown(WCNSS_PAS_ID);
 	if (ret)
 		dev_err(wcnss->dev, "failed to shutdown: %d\n", ret);
 
@@ -557,10 +557,10 @@ static int wcnss_probe(struct platform_device *pdev)
 
 	data = of_device_get_match_data(&pdev->dev);
 
-	if (!qcom_scm_is_available())
+	if (!qcom_pas_is_available())
 		return -EPROBE_DEFER;
 
-	if (!qcom_scm_pas_supported(WCNSS_PAS_ID)) {
+	if (!qcom_pas_supported(WCNSS_PAS_ID)) {
 		dev_err(&pdev->dev, "PAS is not available for WCNSS\n");
 		return -ENXIO;
 	}
-- 
2.53.0

