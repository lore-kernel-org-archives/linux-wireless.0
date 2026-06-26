Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83862380FFD;
	Fri, 26 Jun 2026 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481228; cv=none; b=UDkEJ0kcVYyPXoKHN9+U6nV4SVvhU1c0NvywrgkrNr8ZjyLb7O83z9X0bpps9t1HY91F/irp6rzzFtXsk9RPD/wXk9E+pJCl1w22yDcuNSAgs3nRr2E7mkPVJ2gE5JYGM+FS92fpF+/hD7IlSl8MJKFLrKzPLvf85/7nytJxRQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481228; c=relaxed/simple;
	bh=EGSgAFEyseIu5XdGQdyMv++RpltdjD7ZMVfmRkW+WAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZCobLEtWM4vIrbUEj9CpcwUQm92NjrhEtkGC8OJpaXopMu7xmjvKED3xJ+zyNxzKDpeJg2tiVIVO4uoe0sYvgD+PVo1H0+fapIODTcZz6/MM1yoAE5XqzllOHViG6YLva3rVlFDVLh9u/PN8TNJq9OJgIi+4igEQ15W5KR9D3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAgwUiRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAgwUiRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5B11F000E9;
	Fri, 26 Jun 2026 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782481227;
	bh=iCejPFH6P1HmrWkN4qRLjhA4j8pbccgUzz87LFYWmyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAgwUiRJLYPPyzyTujYgsT5puuVF9K46zDAGtx3tlxScOWd6wy9vYOh7NLNDa2JQp
	 emnX8ibYelENHNuaFKB1fqal2RVxa20X/md6qCheCKC8T0UI0YkA/irQKSZy/5BsnD
	 u6K8eCt997y25g7IFKa5WG9BNqRtPrJsx3ICz4KFAJB+4a59y1NNsJh06suIW4C8D6
	 4OAUTdQfIBuEwVkLPE/Nl8jApajYrlIaUcCHlnGp9VLC2XAwCnsefGokCwnOxDjbne
	 /lYN9uRUQ1046f5bHPTeDfVJ9CncVWcLTkd0LqgpFAU0JF/pThdgIeXA4xkyd+izu1
	 S28rG+j/1ExOQ==
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
Subject: [PATCH v8 10/14] media: qcom: Pass proper PAS ID to set_remote_state API
Date: Fri, 26 Jun 2026 19:04:30 +0530
Message-ID: <20260626133440.692849-11-sumit.garg@kernel.org>
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

As per testing the SCM backend just ignores it while OP-TEE makes
use of it to for proper book keeping purpose.

Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
 drivers/media/platform/qcom/iris/iris_firmware.c | 2 +-
 drivers/media/platform/qcom/venus/firmware.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_firmware.c b/drivers/media/platform/qcom/iris/iris_firmware.c
index ea9654dd679e..d2e7ba4f37e3 100644
--- a/drivers/media/platform/qcom/iris/iris_firmware.c
+++ b/drivers/media/platform/qcom/iris/iris_firmware.c
@@ -110,5 +110,5 @@ int iris_fw_unload(struct iris_core *core)
 
 int iris_set_hw_state(struct iris_core *core, bool resume)
 {
-	return qcom_pas_set_remote_state(resume, 0);
+	return qcom_pas_set_remote_state(resume, IRIS_PAS_ID);
 }
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 3a38ff985822..3c0727ea137d 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -59,7 +59,7 @@ int venus_set_hw_state(struct venus_core *core, bool resume)
 	int ret;
 
 	if (core->use_tz) {
-		ret = qcom_pas_set_remote_state(resume, 0);
+		ret = qcom_pas_set_remote_state(resume, VENUS_PAS_ID);
 		if (resume && ret == -EINVAL)
 			ret = 0;
 		return ret;
-- 
2.53.0

