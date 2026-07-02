Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095F047DD47;
	Thu,  2 Jul 2026 12:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993754; cv=none; b=iz1xTrvqzNkvz6ZEOKLLq8GB3XsELVWJGtalBf6VRjMf8WqpxeZI6UmRG8A6INNM7IY9GfV44D6tpYNJXsw1HTHfSCkUJ0ZHpjTr9Lyva2GE6WMXGYroUbwc1K4JiBLLKO4O/uYod3nSodX8l8c2mGVX3cT3L0idB6Y6Agsg08g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993754; c=relaxed/simple;
	bh=Kass8ShLtCG2cBS4Ka4UPuU1HKrZoxA2WVsdRH1GDfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jN/VaV9ISxHi3aDxB8b0t87QDio4lEfr/Fy+05wIWl83iL0qRMXhVgzjn550mee1qNJTsUjuQyJL2IuFR4SMPfwhHVLb2LCKJKRjI/ODRa0KskCFU+zO3yd2vhVJDq/aDyP7lVqjt4ex4xzqEFLlDgK0N+zuhljLX+EsU3rGOOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7yu/WSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7yu/WSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639F21F000E9;
	Thu,  2 Jul 2026 12:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782993751;
	bh=XJUsMAYjmWAnU9O7bNhJ//OMZ13Hh1LDu2wdf2fpjto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7yu/WSpsrbUQBhA1/dvGgNOT5ajJsFHvZhouEJj4yIudjK2H5UoZ6oXk7G+oSn4x
	 /BIJNvqHNnSwrcfCSllGP1RPHKBe2entTebUAcqehuvCDacnFvfAV9NOJECf+XdH3l
	 bu8d9ao7eOY9xWnklfWMlVXCv0Nzoh47AE+LwMHlF/bMcPDeau/XR1uIFj/GF74NVj
	 fEiu/3lBiCnPpNjjaCQVx6u6kozBCRl5eDM7WA/y/h6zTNw00XkdZ2V1UqRmr1OfI3
	 KGS1wWSJ6A5I7EGsyFQply6BzRBKBEN4xxiYtKYO+T1Z+aEwoN2p0fF/rS77Vkc1sj
	 zdgrWfRazZMtQ==
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
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: [PATCH v9 14/14] MAINTAINERS: Add maintainer entry for Qualcomm PAS TZ service
Date: Thu,  2 Jul 2026 17:28:30 +0530
Message-ID: <20260702115835.167602-15-sumit.garg@kernel.org>
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

Add Sumit Garg as the maintainer for the Qualcomm generic Peripheral
Authentication Service (PAS) as well as the PAS TEE backend driver.

Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 15011f5752a9..7847b2a98f90 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22315,6 +22315,15 @@ F:	Documentation/devicetree/bindings/media/*qcom*
 F:	drivers/media/platform/qcom
 F:	include/dt-bindings/media/*qcom*
 
+QUALCOMM PAS TZ SERVICE
+M:	Sumit Garg <sumit.garg@oss.qualcomm.com>
+L:	linux-arm-msm@vger.kernel.org
+S:	Maintained
+F:	drivers/firmware/qcom/qcom_pas.c
+F:	drivers/firmware/qcom/qcom_pas.h
+F:	drivers/firmware/qcom/qcom_pas_tee.c
+F:	include/linux/firmware/qcom/qcom_pas.h
+
 QUALCOMM SMB CHARGER DRIVER
 M:	Casey Connolly <casey.connolly@linaro.org>
 L:	linux-arm-msm@vger.kernel.org
-- 
2.53.0

