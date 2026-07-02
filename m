Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9B147CC80;
	Thu,  2 Jul 2026 12:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993711; cv=none; b=aqw1VYPW7mT8+dB/kotNKyxY5USCTarmkywNtQ6UGVZA4PpfuVNGdJXG1ndvMiLe1GrGUNuPHRDyrJIpZAD5rSyTjqld9G/XERSzcnV9OINXBMRHk8iGYAQhynz2S40PA14IIujTV8RPHy4Uky1ZiMA+gy9cB7boaeG5NcZzUcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993711; c=relaxed/simple;
	bh=VQ2cpDVSwsNef1Jfn9mWBgnNz3uZRu0ctURhmcgs1CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfI6MNz4vb+Sa76g/w5WSiUeK40+vBLDfOc+f5EN0XxGQkdy2hLzQCps3FiLs/e3ThqHbtbDATiZIcE14OSzrAQvtU27Tga32VEEsZIYfnRClSyQ2DnYZT3nUjhed9w/V3ZgAkxcckHGwSf9mUcEya/im9s28EPDrz10Qt1YmEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGmdbQIO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGmdbQIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A41F00A3D;
	Thu,  2 Jul 2026 12:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782993706;
	bh=mygERH1kptmisPRhMGN1GtdvkxAHUPGzgcKwV2fxOI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGmdbQIO8amLJztTs3teKvUs8+MZnVsP131zyRHEjyP9HIWn7ZGwQ4YqyWvYWaOWk
	 EvtmhzlJz5ug3PFpVXVjBpXcFqfT+nN70sGLTwLJ3B746+SPE9jYM7k6Mpqf2tgnQM
	 uD0wVEHLKG52EXjGAW1qpxaPW0bmP40mOAIiF0V5Bq5SfygB5ztmIeDwHMf9xq05z4
	 RiPvdUxJOmnmiRhRfaXAf0u2Bh3EJ+VX6gFPEA5EgqL1J5DomC9osOQax7wGrj2QDg
	 lFUjFfpolPY1BSraqnLhIrS7fjCxxJS7kkXO7NTbvXYU8STDeEbqH0BAwBy7lenDXh
	 itW9UYYbx0spA==
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
	Alex Elder <elder@riscstar.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH v9 11/14] net: ipa: Switch to generic PAS TZ APIs
Date: Thu,  2 Jul 2026 17:28:27 +0530
Message-ID: <20260702115835.167602-12-sumit.garg@kernel.org>
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

Switch ipa client driver over to generic PAS TZ APIs. Generic PAS TZ
service allows to support multiple TZ implementation backends like QTEE
based SCM PAS service, OP-TEE based PAS service and any further future TZ
backend service.

Reviewed-by: Alex Elder <elder@riscstar.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/net/ipa/Kconfig    |  2 +-
 drivers/net/ipa/ipa_main.c | 13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index 01d219d3760c..a9aff1b7977d 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -6,7 +6,7 @@ config QCOM_IPA
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
 	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select QCOM_MDT_LOADER
-	select QCOM_SCM
+	select QCOM_PAS
 	select QCOM_QMI_HELPERS
 	help
 	  Choose Y or M here to include support for the Qualcomm
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 788dd99af2a4..3cd9e44680e9 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -14,7 +14,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 
-#include <linux/firmware/qcom/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_pas.h>
 #include <linux/soc/qcom/mdt_loader.h>
 
 #include "ipa.h"
@@ -624,10 +624,13 @@ static int ipa_firmware_load(struct device *dev)
 	}
 
 	ret = qcom_mdt_load(dev, fw, path, IPA_PAS_ID, virt, phys, size, NULL);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "error %d loading \"%s\"\n", ret, path);
-	else if ((ret = qcom_scm_pas_auth_and_reset(IPA_PAS_ID)))
-		dev_err(dev, "error %d authenticating \"%s\"\n", ret, path);
+	} else {
+		ret = qcom_pas_auth_and_reset(IPA_PAS_ID);
+		if (ret)
+			dev_err(dev, "error %d authenticating \"%s\"\n", ret, path);
+	}
 
 	memunmap(virt);
 out_release_firmware:
@@ -758,7 +761,7 @@ static enum ipa_firmware_loader ipa_firmware_loader(struct device *dev)
 		return IPA_LOADER_INVALID;
 out_self:
 	/* We need Trust Zone to load firmware; make sure it's available */
-	if (qcom_scm_is_available())
+	if (qcom_pas_is_available())
 		return IPA_LOADER_SELF;
 
 	return IPA_LOADER_DEFER;
-- 
2.53.0

