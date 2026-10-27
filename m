Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793102560;
	b=WOfXMuZoksbQIKK/Cr7Izibb0dezu22iB/yQogf/yHpMikxTx3We0EwvXa1fZSkdG7g0
	 puntzSBIujB5g5gK1ytqyMFBFn3XzIrkn2p9ioYCh1fOHor1b2AZwgBHmqNjNhGplH5Az
	 LtTDpSv5Ko5Y+ra1BCHLNtHiltK6RBYAFIvZIuqpNnGK2awH1CimOOAAqToFIjjTVHuTt
	 jR/YFqdrd9eDusnr3ORx0YDioqU0mHVx1aOwakyejU5yUWlDg9mD6fGoklolbLc8EMqId
	 OhGvfI2ryKNOha8UjloAw5S0ihK7JQ3WhETtc3lHoF6nTP4Z+zNii/DmXHFqRi4aAVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793102560;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:To:Cc:X-Mailer;
	bh=n101vkG0N/G/63SBZEld8AZPiXf6J3zncGJX/JaoIzM=;
	b=Zm4nCf4P3cHQG+OAqXCdU+i8dX0PUpuzfE+JsdEyNQ2s+mxDYzmAmF0XodOpu9PGo3j3
	 5qNpdqks6gGU0ug+mkuWOi905wUqfbHazFaqE4v7aIygVxOtlkKh/HrblPcXMIVKsSVNd
	 BApz230owFyaYMjN7GFhhCfhRBomnbKe83TTTS8VDQOrXTdWBoetMMCyvhrrs72IR6IWq
	 uZG06PKEhsQrnNOeUb+XtYl8LgiglYFPz6+T/Uep3ok+KxVUCi/hbEQWWNm06ETayxNfB
	 OE6aa8w58bA3IaU9pNUJN1ezy7SdqeLH2g2P1QaGxoRBvAbgg7zj0pCo8ahBluouLRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8u6qZc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27815606C967;
	Tue, 27 Oct 2026 12:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8u6qZc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660421F01240;
	Tue, 27 Oct 2026 12:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793102560;
	bh=n101vkG0N/G/63SBZEld8AZPiXf6J3zncGJX/JaoIzM=;
	h=From:Date:Subject:To:Cc;
	b=J8u6qZc8g069GwgzmnAC3uMDNUnqXvnD9BP7WZKkQIqY99YlrTnV01nehNpCETVoC
	 TXICza2KEl9OXJL7Xu4T7bPReJCUvKGJoWnHllnvrkX2THMnKomoUu5Z1AtXEmdXqI
	 /ntFNLbBuBrzYmctN/c9KEduzA6p8meF8/ME3jsheazi+LrnXiBlC7iJ7zrQkgyxIw
	 orwlNFczG8oigxjVST8Zh8go1StEdu3i+8Svx+hdTSWqXaAqSB2n3FjqoL3SwVd1gP
	 Bv1EqQQHUYa1aoIULQ98SXUrWpbOJwkHGkC4/4TgEy0mCispiGHoT0ZglJMd9bgGyO
	 xt8LDqqDtROJQ==
From: Sumit Garg <sumit.garg@kernel.org>
Date: Tue, 27 Oct 2026 17:32:20 +0530
Subject: [PATCH v10] media: qcom: Pass proper PAS ID to set_remote_state
 API
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pas-id-media-v10-1-8a5312d3050e@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAMuS4GoC/x2MQQqAIBAAvyJ7TliFFPpKdBBbaw+ZKEQg/r2l4
 wzMdGhUmRosqkOlhxvfWcDgpCCeIR+keRcBFq0zaL0uoYnSF+0ctI/RY4qzNy6BJKVS4vf/rds
 YH15rRMNfAAAA
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, bod@kernel.org
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org, 
 linux-media@vger.kernel.org, netdev@vger.kernel.org, 
 linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, 
 linux-remoteproc@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org, 
 conor+dt@kernel.org, robin.clark@oss.qualcomm.com, sean@poorly.run, 
 akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev, 
 jesszhan0024@gmail.com, marijn.suijten@somainline.org, airlied@gmail.com, 
 simona@ffwll.ch, vikash.garodia@oss.qualcomm.com, mchehab@kernel.org, 
 elder@kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net, 
 kuba@kernel.org, pabeni@redhat.com, jjohnson@kernel.org, 
 mathieu.poirier@linaro.org, trilokkumar.soni@oss.qualcomm.com, 
 mukesh.ojha@oss.qualcomm.com, pavan.kondeti@oss.qualcomm.com, 
 jorge.ramirez@oss.qualcomm.com, tonyh@qti.qualcomm.com, 
 vignesh.viswanathan@oss.qualcomm.com, srinivas.kandagatla@oss.qualcomm.com, 
 amirreza.zarrabi@oss.qualcomm.com, jenswi@kernel.org, 
 op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com, 
 skare@qti.qualcomm.com, linux-kernel@vger.kernel.org, 
 gourav.kumar@oss.qualcomm.com, Eric Dumazet <edumazet@kernel.org>, 
 Sumit Garg <sumit.garg@oss.qualcomm.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.13.0

From: Sumit Garg <sumit.garg@oss.qualcomm.com>

As per testing the SCM backend just ignores it while OP-TEE makes
use of it to for proper book keeping purpose.

Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
---
Changes in v10:
- Resent standalone, as all the earlier patches of the series are merged.
- Link to v9: https://lore.kernel.org/all/20260702115835.167602-11-sumit.garg@kernel.org/
---
 drivers/media/platform/qcom/iris/iris_firmware.c | 2 +-
 drivers/media/platform/qcom/venus/firmware.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_firmware.c b/drivers/media/platform/qcom/iris/iris_firmware.c
index 21f57d37da18..ed2bd0e83797 100644
--- a/drivers/media/platform/qcom/iris/iris_firmware.c
+++ b/drivers/media/platform/qcom/iris/iris_firmware.c
@@ -262,5 +262,5 @@ int iris_fw_unload(struct iris_core *core)
 
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

---
base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
change-id: 20261027-pas-id-media-7cc70fc5716f

Best regards,
-- 
Sumit Garg <sumit.garg@oss.qualcomm.com>

