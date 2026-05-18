Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16C5392838;
	Mon, 18 May 2026 07:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779089599; cv=none; b=mbxN7+XDTU5lnDkJGnzKPu3TwJL3s9UIQH0kX81mk02meUXoZ2XGSD0TxGQpmSckDIoMDingBe0G45QR4qlGuMjI+S8P8Zf3c152QrbITW3C+U+rKJhtN3g/AwwWIYyJC+8HifLVUtQUFDzOYI819i1v1GRWoOa8lQJiVSQ9zXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779089599; c=relaxed/simple;
	bh=feQHjLZ/DRdp6bnrbpfoBvfoLos1Lry1wljdglm94Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgL7UFtch4PXxuGYhNdJ+SoNKEiszSe79fYchtpl4Pu3YNkcM+KYKayu3YHosKdRLspqiZdlgwzIX23hM+s7ImSSVxwgvVQZCS/D4XDSlTfZ2Zubye2ntW1UgxxuGHBTVhJ1mdXZO4sV1CL8gdyFoJZrfSUnWIZUdaC84OyUj0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rO+kuIx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rO+kuIx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71603C2BCB7;
	Mon, 18 May 2026 07:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779089598;
	bh=feQHjLZ/DRdp6bnrbpfoBvfoLos1Lry1wljdglm94Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rO+kuIx6GxG5E82BzK8VM1HDyZZJNBTEWjeoJ5U5fFefS3j1wMTP5qNjakR6nwYtG
	 utTiRebxbRIu2JOTEqdXiRkFFqUInj1MIgg1YYjGJQgLCSKuourdXtMfs4i0mxE7Dh
	 PIewOoi8G68mSgjWilVxK0rE+QSkuhnltBPwOZYLdmy+wzxQuPSctuCThmZ7H1qe7Q
	 pQWqoR1TpF09ATaUiyKI4YmWX4GKbKK98tM99zHkevQRpuvNfWfnLo3dTkgAxRKWmv
	 AlyfGKSB9lZFe+pIvslCXcR6XuckTmome+HdcSFXXODzlPwOg61EwrDmf/kX9qLa6X
	 IU+4SF/xkkNVw==
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
Subject: [PATCH v6 16/16] MAINTAINERS: Add maintainer entry for Qualcomm PAS TZ service
Date: Mon, 18 May 2026 12:58:56 +0530
Message-ID: <20260518072856.22790-17-sumit.garg@kernel.org>
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

Add Sumit Garg as the maintainer for the Qualcomm generic Peripheral
Authentication Service (PAS) as well as the PAS TEE backend driver.

Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2c6d79275c6..d054850286bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22052,6 +22052,15 @@ F:	Documentation/devicetree/bindings/media/*qcom*
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

