Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577813B7B6E
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 10:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790592363; cv=none; b=hRdLt5pO+QOnE5k1uMfyfB4eWPGqTpU7GE3+xhaqjbtmq6QRwcJqC20BIGmFAi09NtO51c7xRce3pW92FfpaBOYeZQ9fepbuHWBWUs2WxMU6E+s7SfhHtuslA4UVCi3VCzx+LuKsmbnwF8fKVjOIyUnVupwjrCrfuRqMEhsAvy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790592363; c=relaxed/simple;
	bh=ymiwB6pBlibDJdmQbykkq5flAXMTwAn4gz1TM2yeciA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=eOLF7asT2zk5bJ8o2u3zKixMjHCU9SKErEfjNsa8BqXCE4mhHpFqAvnNZCQLCccwwfv1eNwioKM9VgzVYkPQOB/qunnisGn/IBRuN/SsxnDNbm2y4qOIb4e/dS5cTq4btVMzyyBQOTNETDX3N/e24Pw71KwYuUpA+Bk7FRngVNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hMo33KeH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WeswjKtw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hMo33KeH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WeswjKtw"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9MAvN246128
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 10:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=jTwsyMF5VW6h12cFc72PJn
	uylDUnWOYRvi8NoTiovMw=; b=hMo33KeHx8cN6j+n1VHJg3y4PELhemgRhgVeW9
	qM4ViP7SyFJy5oFLQi4ea18VWamrIVf/pOApjGJVEfXYXAKxNww0saO1bT67kpOL
	xPOjshcM/8V4W2uS1WfXDMKl5BWgxZnbHNFxiY8On18gBfibLofgzh0gfPJnROdY
	+znlXI3K6Jo/CeOLWdHnZVR6UeumjjxAZZCA3wcCrTrQGFuSmglIYIsGv7I/MlAA
	1BOH+N+5AUYARGwG57V15HU9A3bbxmbQ6NROuLFaldupVRuOkqx9rCj7EzgshsyL
	D0cSipdEmRIydS7hS9epITeng4Hj/29Sl/ZxJXax6sOSPdnA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gyjt1109s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 10:46:01 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d55d8cd938so48530305ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 03:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790592360; x=1791197160; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jTwsyMF5VW6h12cFc72PJnuylDUnWOYRvi8NoTiovMw=;
        b=WeswjKtwNdV0QIIDE7Lurtb9MUnRfowaI4byO4wPduh52Cfeg81VsAH4PBtR7LuOug
         QyvdHo45CFwOuxbIZAuMif+HKaCXkDezAMsUkeB3204MnzBNpKBC7Lmrs7/zTQgqVmd9
         wBvw/XymMpAgoVKZ3iwoJ1PGBgQcVrsJq5H9llxqKCzXd3zPySW3sSKiq4nwDZOveJ8Y
         /ARgg4lNn/UuG9TIX1IyDRCg+Iiaw3yo1Y4eCxmHdLhk1R0exm5n4DjNo/Gd+9DaDKnG
         ZwqYSIu6UjPZue0uBJy7XR6azRNNNwJuFCr1I0HX6oM1MYxCwn56Fk4Q9++VW/IHBBqt
         7Zmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790592360; x=1791197160;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jTwsyMF5VW6h12cFc72PJnuylDUnWOYRvi8NoTiovMw=;
        b=qJkK7CLxLQNhZJn6rrK/yhmjBXR4Ays5DvxMjLbgy4Ny32KTTbQtMorGR2CX/HAOMF
         FmuzdIRr3eAL4NtWFCBDdFjZWZ52UCsMaauolHkBXPkXbj/zgg/XEEzIs345htGxeMig
         Q73zKZCYxM2z3IJkCbV5Vdl7P8HpO1gC1ywSpaJw+lc4TBy/GtLrg8r4U/qsK1iUdHSO
         nGhPkNCQiGSojyL1te56uxQDw5FxFwRVDlzC316EP+WrEcC8SCN3pujx8gK+WkbSeLZ9
         CGGmsFM5hj5VwJMx4LsN0LtOaCyOHUG7D6FI+Gfat9HfTcd0xVmgIiyid2ayS2fLcEQv
         4VAg==
X-Gm-Message-State: AFq9FYLrVXHFa8rX+Y+U2QxJyFJ4ACzxmbl3fsAuHxfpP7GLZxswMTBk
	gL01beppRQPFEj4mw1YBW30JVb/s95cw86cNbHMLIyAhIR/3Vm71Cm1YGR4qvOEWot9BDYACNpG
	Wh1fRR98UAVUhEr0BcFhewLvNVTsV9Z7qL8FNrnfQggxSSSIxJNnuMqSaIoBfdSaMgWd6Vw==
X-Gm-Gg: AYBFou091GERhBpsgsZcbJ8EtFHJWPi509EQ8XJR1iFurwP4aQftg6chsfMjvgRA/oR
	/Z+N1EfoSo9bSdP43gjewJaIQ2QVJky+x3nWwWb/ya/rRWUobfdYsbZ8c2L1eKiWUgwFszGde+5
	vMuKIQSeLIEFiTQAZ7OTz6cOR18JLTfC9+k/xsltHowArHV74eHKPfm0+jD3Qsq/KouzUd7VZPd
	VNb+c0+k2Jom13QctkyeapkV5LQ0jA84UrazSGlaIAy/TN1QfcxILUevfsFJzW15AfA2xZLXi1i
	xlz93SNHjt7cF67RO+o83eoPNJKmypDNf/VrX2+wcqMECbaxBL+wOGw6n8C1mRi6wf3oJKwk6fp
	8cnEWnLM7Nadfo73h7o0iSuhoz0o5NSNrtJqsaUfaBl7zkdxxTxx9
X-Received: by 2002:a17:902:ebd1:b0:2dd:c100:9434 with SMTP id d9443c01a7336-2df94c1bc03mr78579865ad.50.1790592360101;
        Mon, 28 Sep 2026 03:46:00 -0700 (PDT)
X-Received: by 2002:a17:902:ebd1:b0:2dd:c100:9434 with SMTP id d9443c01a7336-2df94c1bc03mr78579805ad.50.1790592359631;
        Mon, 28 Sep 2026 03:45:59 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bfd4sm39619315ad.52.2026.09.28.03.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 03:45:59 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 28 Sep 2026 18:45:25 +0800
Subject: [PATCH ath-current] wifi: ath11k: fix unbalanced IRQ
 enable/disable during suspend/resume
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-ath11k-unbalanced-irq-enable-disable-v1-1-75166f534763@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAEVFumoC/52Oyw7CIBBFf6Vh7TRAHxFX/odxMaVTS6xgoSWap
 v8uYe1GNzO5uZNzZmOBvKHATsXGPEUTjLMpiEPB9Ij2RmD6lJnksuVKCsBlFOIOq+1wQqupB+N
 nIIvdRNCbkHfdEXYKq4rzgSXU09NgXllzYYkAevWe7MKuqRxNWJx/5xeiyCe/2aIAAUo3LUkti
 PB4diGU84qTdo9HmUb2RPkPWyY2561qeFOjqoYv7H3fP4vQQcNIAQAA
X-Change-ID: 20260921-ath11k-unbalanced-irq-enable-disable-4beab9a3300f
To: Jeff Johnson <jjohnson@kernel.org>,
        Julius Bairaktaris <julius@bairaktaris.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0MiBTYWx0ZWRfXwhQGDjwfJZOW
 0B4o25KIsym3fLJvqxRvx+/cOPNQIRNZaRPK9yhVSNUnDghMDz70e/OKkUFt3lEPbpJ5Gvel91E
 80+XUtDrs+4hvqpILpW5ukGD+AwZ8lbr3HmpCPhjghWGzb8ccKPZLzquAecZsXuW+uMlIK231jz
 C1zH6VU4fLS0FvV6oLlRHseq2SEdtJqZCwswGF/ZmJx2mvDqdYpHnA9L9CyMm/RyOCy8qnRxAqc
 i9io1DrOynJ8MCgeio8yDTHm2oa1FQRo8DutnEIWRCv6P18NUeo+ZtR6rLOIvTY1C7KqiQvTe39
 35XhINElGHDjuw564IC/TNG4j+5MyK3r7p5z2BdU0VmdawnK3jLfw0jwLZHY01YPaqI+APkhOEc
 Tdvop7KoS6V6fzG+/hEG7UNIxatPMkeRqY1C4Fs2tNXCFobf8VdrYXkqUwFDwZ7xTCRN6xDZB07
 D9uo9j7c7Ji3hIpOrSA==
X-Authority-Analysis: v=2.4 cv=V8foQuni c=1 sm=1 tr=0 ts=6aba4569 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=hD80L64hAAAA:8 a=EUspDBNiAAAA:8 a=KAfsIobKxm3l_v_usUoA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: WWWSoOM7lGutlE4iBSQjVf4ODIOGN8xi
X-Proofpoint-GUID: WWWSoOM7lGutlE4iBSQjVf4ODIOGN8xi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0MiBTYWx0ZWRfXydeNUYycZaOR
 ziTQF/VYd4nLVFtOaiHi9OF54mFo7emR+F2k+RhYehIyZZ9KHEu5EgYBZKScOt9IOd2p5IqNy1j
 NY/vOLBS3ncye9bVTPfd32VVR/eA4xA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280042

Commit f7a74e131d3f ("wifi: ath11k: disable interrupts during firmware
crash recovery") added an unconditional ath11k_hif_irq_disable()/
ath11k_hif_ce_irq_disable() pair inside
ath11k_core_reconfigure_on_crash(), guarded by "if (!ab->is_reset)", to
stop the DP NAPI from touching rings that have just been torn down. That
fixes AHB device recovery, but breaks PCI device suspend/resume. During
suspend, IRQs are disabled once in ath11k_core_suspend_late(). Then during
resume, ath11k_core_reconfigure_on_crash() sees ab->is_reset clear and
disables them a second time. Those IRQs are enabled only once during
the following reinitialization, leaving the IRQ lines masked. As a result,
HTC control responses never arrive, and resume fails:

  failed to receive control response completion, polling..
  failed to connect to HTT: -110
  failed to reconfigure driver on crash recovery
  failed to resume core: -110

Fix this by disabling the IRQs unconditionally at the top of
ath11k_core_reconfigure_on_crash(), and instead drop the disable
calls from the two places that already disable IRQs before this
function can run: ath11k_core_suspend_late() and ath11k_core_reset().
This keeps a single disable per recovery/suspend cycle regardless of
which path (recovery or suspend) triggers it, so the refcount on
PCI parts stays balanced while AHB parts keep getting the disable
that the original commit needed.

Fixes: f7a74e131d3f ("wifi: ath11k: disable interrupts during firmware crash recovery")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/linux-wireless/a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Julius Bairaktaris <julius@bairaktaris.de>
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/core.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index d2ed6a0ea7e3..1ad0a47653de 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1275,9 +1275,6 @@ int ath11k_core_suspend_late(struct ath11k_base *ab)
 	if (ab->actual_pm_policy == ATH11K_PM_WOW)
 		return 0;
 
-	ath11k_hif_irq_disable(ab);
-	ath11k_hif_ce_irq_disable(ab);
-
 	ath11k_hif_power_down(ab, true);
 
 	return 0;
@@ -2333,17 +2330,9 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 	int ret;
 
 	mutex_lock(&ab->core_lock);
+	ath11k_hif_irq_disable(ab);
+	ath11k_hif_ce_irq_disable(ab);
 	ath11k_thermal_unregister(ab);
-
-	/*
-	 * ath11k_core_reset() already disabled the interrupts on the reset
-	 * path; only the firmware crash path reaches here with them live.
-	 */
-	if (!ab->is_reset) {
-		ath11k_hif_irq_disable(ab);
-		ath11k_hif_ce_irq_disable(ab);
-	}
-
 	ath11k_dp_pdev_free(ab);
 	ath11k_cfr_deinit(ab);
 	ath11k_spectral_deinit(ab);
@@ -2605,9 +2594,6 @@ static void ath11k_core_reset(struct work_struct *work)
 	time_left = wait_for_completion_timeout(&ab->recovery_start,
 						ATH11K_RECOVER_START_TIMEOUT_HZ);
 
-	ath11k_hif_irq_disable(ab);
-	ath11k_hif_ce_irq_disable(ab);
-
 	ath11k_hif_power_down(ab, false);
 	ath11k_hif_power_up(ab);
 

---
base-commit: 03dee8921448c661b06116d14967a57fbecaee6d
change-id: 20260921-ath11k-unbalanced-irq-enable-disable-4beab9a3300f

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

