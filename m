Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C0D4B8DCA
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811324; cv=none; b=add1Bz70yEejKT7ntCddaxj5Ha/c8ERgXNjuywbDOnWRC6Re6Yq31wv+CQcRVbo4FeVWRIJtfK9HcAIaQdPdNRIA7/dNYOWWulnK6PjtQuGvUjyYN5OhNUWN/LHxGuEGj4qibNRRxV/kwqjRPH8lMZELABSSX4QiIDQWYQ9Ol+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811324; c=relaxed/simple;
	bh=v8mrqCWp0tPlAUxPFzuVBEBBH+KhMRIbVyPo46x+tXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uoqZ3SbLl2nrt0s6BOelo9mrpv0tcedJyAzepjhBJqOsyqd8ADJMimGpWMiBhD6Dc6Df5rMCvMn9uqSmhUp/2t5c3QuzdX365+pEiXtYBbi01RUqc4d+7xMOfEj3AtxfJ23nnGXv9ebrcuWCpzU432yrIBYt63ecAUEF+C8NOEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PFzmGpid; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YPcc5hio; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PFzmGpid";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YPcc5hio"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NC67sr3833452
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=vZ9rslL3Elc
	R7tyBivla530viAQc3QhBebjgDeKhgjI=; b=PFzmGpidn7WAb/f0l7NBwl0XC9u
	Szu1qAUzg6fvEFAwQD9eMOxcOT7LFWUZoJQXAmUx80sJ7CdeZhfR78mEbdFOPkkm
	OJj9O+p8M77OBPj7gVI3nU0UcnPpnoMQhfvLgdGNpb6RwTmdwycackvHHkeQLLMl
	tXkz3JbBF4KZNAbsUXGIUasGtLuVsfwZ5Ir9XuBhM0g9rV+2OkieC05SeQyMaBCj
	xfJTm5tz5xeyi7EIO5ds97+YIMOXqFCVHWElztMTKnx59PeYIXPNd7AWQ6U34KsM
	TB0KZYCx+l6cTN/FbmQrcJ9u7xPlw84+iUQGpEPI905sIsUYSYiZyeJcd/g==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkjnu86aq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:22 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca124bf0189so320689a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811322; x=1785416122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZ9rslL3ElcR7tyBivla530viAQc3QhBebjgDeKhgjI=;
        b=YPcc5hiopoNjU0KS8KU5OzZJhRIO+qAwfXUN+4EKmlLylYESZCFVUfocPlTNn3lr6x
         dbjLIrUPX+K6i+vmYqaw+mk9mgfpCr/2eCRQxtoUwfK4FdVIqW1/Nd0UnVB/kWoPpoEv
         pa1OLawBHUQH9gADxkP/2ckQn/GR4RBXnwfe/X45m6na4Dh+XWdxu3aJQF1ucllstyPg
         FlmohDpWRgxet2cYvzEjg0GmmhJH270CSc1K7Nojit0aa7IyjExtPdTDYiq1gx855YPI
         0d8jURk/9H9djr3BcN4KwnnKS6qr6Kbg+8MV30dChK6hK8r5CZzE+6g+UlDc9gqjZ/6F
         1Nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811322; x=1785416122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vZ9rslL3ElcR7tyBivla530viAQc3QhBebjgDeKhgjI=;
        b=Vk8HWONE9IU6YgpUinxftaS4Q7jHzyWKemkEt0UsGd02vKmo4Ps/xmJ63YR5WDJhy4
         YNpwa7jHk8IcsnKdRE96rOdUtfzszj5f0NY6IdilVtoOSJRhiyE5l9SEXzErFdfjsNN7
         dHhHtxFfizQjaQ/M5cKtSOEnBSkayfx2nJ87eGUgXpnUzEGLQKdH3ll6k5Ul+elBPFp8
         VbpORxIvDOqxEujEMFNriZEMVXkaPLuPsTSApjUsqlaus2ZiFqFkB7EpM5I8T8OImYFN
         VmL8Aj04WLFfxN9t/s6msKRydmbA3rV/64ZCkmNbl8jr6JwxWCmbcoQc4GRQt+nDBXQM
         Ca8g==
X-Gm-Message-State: AOJu0Yzs9uxcdSiL9kNPMrwdciZKDfXh2NytbwLH/H3iKRm05pCubRTy
	rjpgknOwyCNSEsdYWZtkGVRwHnZ7Pat/0oO19gWfSS35Il4jR9BzPDHudqkKIa4toTSiHxf6b4C
	hsXWPRlifrPJPFt+E+Lb1aXT+JcVhxOd6hHsp3aZBkUl9SP2NmQWty8Fv07kHQEnj5RYoQw==
X-Gm-Gg: AR+sD13rFa3kjum0reKXWy0hX/+DzhBHksYAwZtCovOUr5Z+77laB8c0c4uci7dOGDB
	+1pH+TTnsUkKoRuJf6Jr+L3dpybIa4C+3Ki69F6MBYGYmoLajTTe1w9MVE5dsWVQDmsoB/BQ4Ra
	/wUcTk99UK66gNLL4ltjSNvbmdXxxNgQ8EIvwhvUlBKacZvGoXnSAnEItQwyrHgjS0XCvDWa4tn
	FX4achZf0w23vUXYwunrIM9HJxB8epdUR6Co7SXM/jVCDEkVn13ImGmPGdeldmFKByou3/2ZQ8j
	33pQAd0c6s/vf719QWCRMQt6+XZ0zB1rpYkXtinf89gQaJo0WNhYIDUDURlPvAPxfU8lQ97Cihm
	0WfxwmCFcsMPc9fes3FU/OhhOrWnEijdGr9MoQcAUlflbuL9SNXNP
X-Received: by 2002:a17:903:2306:b0:2c9:994c:9a5 with SMTP id d9443c01a7336-2cfa9588d7emr30978765ad.30.1784811321878;
        Thu, 23 Jul 2026 05:55:21 -0700 (PDT)
X-Received: by 2002:a17:903:2306:b0:2c9:994c:9a5 with SMTP id d9443c01a7336-2cfa9588d7emr30978475ad.30.1784811321413;
        Thu, 23 Jul 2026 05:55:21 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm32998385ad.70.2026.07.23.05.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:55:21 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 7/8] wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output
Date: Thu, 23 Jul 2026 18:24:47 +0530
Message-Id: <20260723125448.922361-8-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: nfB3H3XMVfiyoJM6XGkl75V9bynpJa4Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX8WqYwqNJkkGP
 TpHQx0/pinF8d6lfw+XtCaVdYr8TmfdwKSdi+JpS/2JiTTSIyKVFz7BhVZ2c4KSp1gV+QDlVwIK
 khqVoj/ITn3bzziZTh0pgvjLakhltLe5ZV8JM56YTPWgL/9nU+aZWH1LZKpSlF/PwDpFrOX7axv
 X6taNQo1kHuRjF9LOKYlFr35FmAqBtsV8AbF7DWSS3jb9aDcruPOeoSj6TPc+ubWtWmvWZj3aLp
 /+74dBKtOYQafAodzc429OswpdMVCZCGqd4We3SOpJVNDET2f1r2ovSVmrJlCcwi9eZFKF8WfXT
 VBdNZVQinK/Ij1SoJoi2CaI9CiczD+hFts6dvKFkOE/asjGObRafQrGqPths6cNyLyIb8RLcD+R
 EIQnJyT/7jotg9n8oabTw8zCp/G+bPigIb+TTdxBVEM4sU1fIZ9hiKq4xoVF5EmYx8LwhWMTR7P
 Utr81UAW/Poln6pIakw==
X-Authority-Analysis: v=2.4 cv=Een4hvmC c=1 sm=1 tr=0 ts=6a620f3a cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=qz0A3ntWxt9h8-tH59wA:9 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX03nRT0WFMlSY
 A1jNsViyHDo30SgL3rJfnArDrP3FQj07paYPU+32GpXKFVNPehevwRMNn9QI++vFz1pMpas9QgQ
 /u5BJgMjeqd+a7awXjhV2sOyjobgwPA=
X-Proofpoint-GUID: nfB3H3XMVfiyoJM6XGkl75V9bynpJa4Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230127

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

The REO Rx Received section in device_dp_stats debugfs uses a 1-based
ring index ("Ring1:", "Ring2:", ...) which is inconsistent with the rest
of ath12k where rings are indexed from 0. Fix it to use 0-based indexing
and lowercase "ring%d:" to match the style used by all other ring counters
in the same function.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Fixes: 84873d542e95 ("wifi: ath12k: print device dp stats in debugfs")
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index 9a8d07bfb848..4176c837a6ef 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1210,7 +1210,7 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 	len += scnprintf(buf + len, size - len, "\nREO Rx Received:\n");
 
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
-		len += scnprintf(buf + len, size - len, "Ring%d:", i + 1);
+		len += scnprintf(buf + len, size - len, "ring%d:", i);
 
 		for (j = 0; j < ab->ag->num_devices; j++) {
 			len += scnprintf(buf + len, size - len,
-- 
2.34.1

