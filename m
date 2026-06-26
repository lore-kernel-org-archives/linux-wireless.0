Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684853F7867;
	Fri, 26 Jun 2026 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481342; cv=none; b=CsMi7Eb633h7DaZBviAngfZx9g5s5GuNvN1gBWs6o6lMOe7cLi7xvDgaUa8d/Tcuj8ZZE0V7UkHDr9/RPNJA9HkipFVRtA9hubYtH2Q08yVCkv54McYiZZsz2Cy5tOr+tUg4epTSgCGrN9IkEqeDcfsFd/IdtDBU/ivkdjIG0jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481342; c=relaxed/simple;
	bh=Kass8ShLtCG2cBS4Ka4UPuU1HKrZoxA2WVsdRH1GDfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTZfPHzm4dhetscZCqoANMxx7bppqvf3DZAZ6C/6+1Sx2rnSknbsKbGce2HLsvpUIzPSUwSYZ4Z23nmUoF9YHNvnHt7GLUOq7o2/4KNI0tUWxv/23YaARK6WLgkkkOBo1mM/BS9dm7OkQTeNMiJaHh1sORkAITHfEhIwbojOe48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mquDSpOP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mquDSpOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE331F00A3D;
	Fri, 26 Jun 2026 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782481341;
	bh=XJUsMAYjmWAnU9O7bNhJ//OMZ13Hh1LDu2wdf2fpjto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mquDSpOP4TG3h9syVbjc0phTij1tuiiPAgBU80powv0FLrpBIgWzva7ZL7PN2UNEJ
	 tqBTK2bKPvDzruG06ALOUKtHcYbKkqWUFj9DkadZ0Po4yYSoqWUtXDz08A7K04ef/+
	 uOu5xB7u+SQnh6MLMZ6CkK5v+UGicaSXMWG0gKyp+TLta6mMABV5i/qJ/L8RfyT+sE
	 w71NGn7eiTWg6N6cIMXiyvP52Fz8GdBgX+XDj2x7gS1eMow5w+M64F4anKs/QN4y8c
	 B98ugQqjAgLQmRy3HipPfslJgqdVmnR3DQwxcCEuebUvpfAAos3JaH9L5kKDf7cQDf
	 b/qAn43Qp5KWQ==
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
Subject: [PATCH v8 14/14] MAINTAINERS: Add maintainer entry for Qualcomm PAS TZ service
Date: Fri, 26 Jun 2026 19:04:34 +0530
Message-ID: <20260626133440.692849-15-sumit.garg@kernel.org>
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

