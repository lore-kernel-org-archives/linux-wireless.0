Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05AD43C055
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010878; cv=none; b=c5m2pEL6F9Qd+e2gCFquiRQQ4lYll03NKQVj6K0UnzpAmQdNym4hrTnE7F6/huFjYX0i0qGrD3XfZp7dOkdZ9NHkJ0niuBnwotU9Tv7YbT4KNhGQVOhZOCQQNk3zruoItdZnxay1TYS959TxcbT67tstSjvhtVz+MHJhhpX4C5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010878; c=relaxed/simple;
	bh=2KaQD6bXpEcI/gchgEMT/UxEAeiWS3xm6HYXNXXQMsU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bb+2LbavsYluwoGFhfk9gUoOb7Gy3AJQg7oYnIseXHdakriO0DFJdRxxpnzA96un6aI3jkIGBuTk1ZfFPRjm5lQiv75xR+6TWbDkDyiGHzGUcWTePadmFOjkpv6dHpKpMO9LNcmqqcf81Z/FbCjbSmqVXxDfxeIuU9UgVWZy5yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OA9Kiumh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hnpQv60T; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OA9Kiumh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hnpQv60T"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769o1rJ2105641
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Vk2aJqzmseV
	OnxCV3HG/O3mxaCuN6ou9ie+hVVr7VQI=; b=OA9KiumhcOefbW/AQRZDTP2vSmI
	t1084NzpDz9PAofPhrDB+U3XcB6fHacmIgFhieQ9USlmZpoPYdCcL+1bUp5XS/r2
	HyZELVa11cMx4JuGUl301ooYT5Ub0p7i1DZfp5LAafgoKE20a4RT8E071WhCu5R+
	Xkw+9+KClsawWbHsG1HtiVKzbvGCGSvLdkShrI3x8OTr9mU6gOSX2PPWtEY1ADTj
	oEWwbz9fYZtKeuTEliyeZcG0GSWfUAlz71/MmKos0UCLESqKoZxkbgp3xZ0cNAST
	Nrv23j5gtiFstUCmKuZQJPWxM5FTNbQsg0+sGUH8RN9ievMsmzCHNmWQLbQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvq7309y5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:48 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3811279d51aso3389998a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010867; x=1786615667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vk2aJqzmseVOnxCV3HG/O3mxaCuN6ou9ie+hVVr7VQI=;
        b=hnpQv60TXTx7L8lUkD6Dn4SRpotItR2XSwlJoetA/xH72ZQ+nBsckLcoGPZ61QoJIx
         UYO27hAKIkSm9B3DB13Zm2ABZDhekib+2FOdBvb2BGuzHktBldezyy+7i7HPQoT8Y2Er
         KbLU3mB4eDYGaLOzy+H7cQLqHTx/xTgDNo1Xph1mn7pRbtIxm2GIoRSb2C5btvRHTvz2
         UbOcim9LLOAtAdj/ZNg9WtnY04ypqVmwI2lw3dvu+Ce6pS37eRXjBSqScV1adGKu/4Bh
         RWURtWCViONrQKqVG8GXKW+Bhq+cj0el+5WRdhNDNVXDIU7ZIix+1KhKk7CfARFMY0qj
         BLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010867; x=1786615667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vk2aJqzmseVOnxCV3HG/O3mxaCuN6ou9ie+hVVr7VQI=;
        b=KVZrmAlVYn3jYwky+6vk+zf04DfxDD3v0du3h2KNsRU/1oE5zziqw/2Yjn4t6cpW8x
         qs2o9Lt1nsgYhAgGp7tjq/IvJWhwz11d5krsG5O+yDxSdpEw2rhBuZXMtIfn8CIA0ww4
         yQ0iSNlKtlfGl35x+agtvLfkPXFYz13samNFklcd+v20sXPbcRxn5t9nA1sIbIKnlWJs
         DSU3ZYgwott0zWKa1/YIroHGzQVptJas4YS6wiKUouB10CMxi4OT7gXPXxSBOJ9+lVM/
         7Vii/fwrUGmsKSr/zkKDjwqoSDHjV/5OLMqUCVIa1j/SHB3uQzqQftfdoxhIq2jRhf26
         CIRQ==
X-Gm-Message-State: AOJu0YzlewgR9VFG8a4WWwrD5DFgCSHz+7YbsBddL+9QhwUl35MD4RBv
	b8/xFcZvEA2rqoyvzMXoTdk62CGFjY4Cl41z1aLowAJs7ziPsHJxIR3zEQ6dsJ6IGKNYf5XdZXP
	ObFxWYEOEJVnQ6QlwxnICHrQz1MVS/+yqeafHgvbbzTSVkFVsAySm012fgxO00uZ0hxGCIg==
X-Gm-Gg: AR+sD104Nv/bSDhlBsVrk2iTTm3CO+lk/zda+9j+smkhDtwAqEax2OfyRL8n8+DNm6u
	EgGJgzXA6ZpBajoKPOet6GBCJOyZsQOedTzseHF6QHgBMuYJSn0GTuqv8+IS9E63m3zEWSC2i8K
	XpEVNlu6B0YKh/K52e+2Lw5rAr+s5yzi1oLZaCjy/Z7f7qbf/7ec4a6ddeXgUGir63lpAba5UnD
	EcEMY3Yw1x6uUBF6btGfIrcw5RJRfQLjRHUOi7Vue8I2Eb5EjkhuZnBpstnYF5U/8vS7OzaT/hG
	xpVbcqWFrqPb9lldu+KtGqxtHtuAdNuj3CaySmqgk0pphDGmjum8fbGQmppJPA5A0OTWV955BwV
	WjoBl+9/lAhSGk9YLuVsEO7lwwe/9Y0mwCP3mfkQihwA7+Bzz8l0Q
X-Received: by 2002:a17:902:d58e:b0:2c7:1200:bd7e with SMTP id d9443c01a7336-2d0ca9838ebmr175036745ad.18.1786010867488;
        Thu, 06 Aug 2026 03:07:47 -0700 (PDT)
X-Received: by 2002:a17:902:d58e:b0:2c7:1200:bd7e with SMTP id d9443c01a7336-2d0ca9838ebmr175036105ad.18.1786010867008;
        Thu, 06 Aug 2026 03:07:47 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:46 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 7/8] wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output
Date: Thu,  6 Aug 2026 15:37:01 +0530
Message-Id: <20260806100702.3479326-8-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX5xAFX6gZQapa
 GqOlKqYfuBlC0AKQ/XQqwSm/0Ul0SPpqaJrIg2pgeF6fYsBxHfc6UzRMyA4Yu4f6ERZ1zuQdPVX
 OAwH2na31dB+8OaLuDtEEBmucVxb5hOzrC6RwSG3m5xy6E6+DTgk8y/CBID1AeY5r3sIWpXo5QL
 yxQv8+b6GHHPS81//Eg0WS+wmIaXVcpYsIkqDiKOouAmdkOwiNLXlyhXsy/njQlA72UU5k+Z7V9
 QWxctcQk/wh/p9Uu/Vahkobj4SyvD4T7sAwLgMQI02yeQxvOG5+nPbwt+mzLkLEpR9I2LKJ8sQD
 PdskBoY3Em1lhNB+BZMfON92WvJRASojyM/nCq98nFeq9iw0RuG5sOfDRq6OZJo4+80SaOW1SVa
 qxArzBkQEyBdUeK8d2mgEV7T+X+h4yCzIJbk/6RnvrsGOaqgRfPBcHhcjvcswn+zUgwNGtkQhO2
 zF3JykwQS9gb9wylaBg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX47DaNo+/MUqD
 eMP99QiegYNE65+pJgS1LVqYtBO95SQXOF7j80obGgshAMILSoijVosquVElSV9OisSWt34hRpv
 nUF2kq3m4bLzjVm4kZEUETMG7Q8XGTc=
X-Authority-Analysis: v=2.4 cv=EeH4hvmC c=1 sm=1 tr=0 ts=6a745cf4 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=qz0A3ntWxt9h8-tH59wA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: 83cFxH8nOPI2uD7oZJFn8cQSvtwjjZxz
X-Proofpoint-GUID: 83cFxH8nOPI2uD7oZJFn8cQSvtwjjZxz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060079

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
index 216a1af22898..d4ea21aac21e 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1215,7 +1215,7 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 	len += scnprintf(buf + len, size - len, "\nREO Rx Received:\n");
 
 	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
-		len += scnprintf(buf + len, size - len, "Ring%d:", i + 1);
+		len += scnprintf(buf + len, size - len, "ring%d:", i);
 
 		for (j = 0; j < ab->ag->num_devices; j++) {
 			len += scnprintf(buf + len, size - len,
-- 
2.34.1

