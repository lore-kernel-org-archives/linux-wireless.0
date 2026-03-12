Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD228B7DA;
	Thu, 12 Mar 2026 06:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773297144; cv=none; b=RJ7SlZqlq/vpZL1WUVxw9P337jFP5ZNsHSqVFeGHH5RlK/MOkWKkz4eUYi4y6zxprzK0V6+b0gaPSmSltk23YI71z1F1i7fM5XrZgpUe8feqsMP5Lz2zDmiinsnsELNftDewZIUibjVFrKB9D1SCNMrjn6Ci1WheZRX0dp/qBTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773297144; c=relaxed/simple;
	bh=KkrCQPuk5NSp3xHqruunZhn3/8ssDm+UZVNEv0P3bms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTQ/SqpwOWb+umin9ACBLEw6dBYQBLwsYmJgTl6imEBQK9OafdY/V5Lb8tEZsVP9rwcZqM8eZN3OJecIcEms4GjFnXThfp9iRlMPtySE1Z9cWB8vz+Ro3Jptrd1W3wPWsIIiqaZhb3oqik3RjCD/lIUgCKIe4om3Pdh+ddrG/JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrEHxRTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrEHxRTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BABC2BCB1;
	Thu, 12 Mar 2026 06:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773297144;
	bh=KkrCQPuk5NSp3xHqruunZhn3/8ssDm+UZVNEv0P3bms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrEHxRTGyhnx0bDmrlk/KRyum1eqD0B3AOjSqC4q8LRFqLV++KI2PjmyW37gdFB/W
	 91Wg9NVU9sQ1p/iX1X1hRQrjqizeUh+c2mEnGMPuatawW/O+mD1j6QuYQTTmDpgBeK
	 6CTcmtlrxOh4lZ8xQ6gd9qQoWEFGnFOs5EqclVWR/Crd597GQrcHQnisTWNY+MZzNh
	 EheRdomGAYyE3ZA2rASVMP3r0J4FcE471VjfF0qQSJRqY3f8drzeRwUl3pEPS9Ea7I
	 xhQxui745utU9Ylv+It5WSG+rjl6MVLDnjZJbHnrKC0eSYWONPTak4CdKzcHQatrlJ
	 PuyDGX5/W3AmQ==
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
Subject: [PATCH v2 15/15] MAINTAINERS: Add maintainer entry for Qualcomm PAS TZ service
Date: Thu, 12 Mar 2026 11:57:56 +0530
Message-ID: <20260312062756.694390-16-sumit.garg@kernel.org>
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

Add Sumit Garg as the maintainer for the Qualcomm generic Peripheral
Authentication Service (PAS) as well as the PAS TEE backend driver.

Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61bf550fd37c..88763b3b2a4a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21822,6 +21822,15 @@ F:	Documentation/devicetree/bindings/media/*qcom*
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
2.51.0

