Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B297F373BE0
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 13:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786022713; cv=none; b=dpTONC2ahBPG3L1Bkf9BX8hfDpcCeRG1IWPIHcW/dqe1FJrsWsOw7LTATunAmubDaQXlSwQqyC2rpDPeYoPg/PzbUYv9veiasalq69zZLO9+d0t7WPzuvJtvJ1nOMw8xpT3bpnsZ0pKY0S9u/f36dhiOp5oO65cYE1p2k0ZJGe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786022713; c=relaxed/simple;
	bh=2KaQD6bXpEcI/gchgEMT/UxEAeiWS3xm6HYXNXXQMsU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hsnA1b02Y7hVaZ5G5efjpe/x00HjjqN5NospzibSrmH22lD8XBbOfQ+/UhFsi87ugpuhI11zJNE7mk9NC2gMWosy7cdqAUpp9b6O3V8oTCwNPYhwpW5S0I+2OZ6QIhy8YgqWcPwaK7iofIZXmcIA0QdE1p91BjsG1gFYPb52dT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l0r2YB4u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PzAZqPHp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l0r2YB4u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PzAZqPHp"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ntPx1579452
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 13:25:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Vk2aJqzmseV
	OnxCV3HG/O3mxaCuN6ou9ie+hVVr7VQI=; b=l0r2YB4uazz4kZrfl/Oa5NAA8jW
	pZRua59IEtEvEKEbLww/dpPOks3fR87qHxfMb1MkcJe0NNMYt13niNGQvltCJkT3
	eI+J9YjOJV5T4QYda00FVTYm0meZCnAh6d8xFkcOuJPrhsiX3yRM5nIlfSuqaLE/
	QV7pGWy+6eCscbKmPi3kadZJJIr15EO1yIea3vV5PJ4C0BTEkYbvvVCyCJsXvZUd
	ILLEn+B+7l1vJqbiWkprxR3JqKL07CrHrtNlQLATSGXVTA/mkfObXhXFzjzJqsMp
	ZL3nGl3QKJjQ0GmoiltTba6+fcYMnUi+yZX3VBZdH6pxehTFbPQIlPmQOBg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvju8jc36-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 13:25:08 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84e375d9736so2836363b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 06:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786022707; x=1786627507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vk2aJqzmseVOnxCV3HG/O3mxaCuN6ou9ie+hVVr7VQI=;
        b=PzAZqPHpSc/0JJBCoyKSmxdUZJVc5Ww5fGaRla+83jrFTKBeWl9kDjznBLT3WbTbEX
         A7FWuiSbJDTMBP3WoKiMuD2rY23Hm4vD/M5KKAWO1+kKiZo4X9fF6fmERfaLVMVdakko
         ZTP9mU7JYSsVfNkhSmZPc+hNI9VsrE6P3Pj13epFUG48M+lnirlUpHQk5nFVPJ9vWUVU
         /1iIM7dtqEU9shE1Wta2lWqDLaw1d9RGTlMLqTk+wiZavr9PkUwNLZv2U00NF7u2NZnm
         /xcbT3sWKnNdaRt+yMsSj4F+tL34s4D54PtjNxSKztIDWdKBrxE+C7lEcy0Mna5S63yF
         Tu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022707; x=1786627507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vk2aJqzmseVOnxCV3HG/O3mxaCuN6ou9ie+hVVr7VQI=;
        b=RbFBnUJkaj3GjKluFZ6B/YWCiiiZvYCz+PXMxnoEVrhjOkXtX+bL/lahirziRyAbRE
         bN9TIMuOAMUfmrKdckCd+rnx+08ujCjVC3F6ipr8ooVkZohfXrxLZtYyYnBgN9LOF/97
         k0G1WqIX6KY8WeHf2Jb8VO51AdE0IVlnPFPLKVpC6KEVf2OLzIeZP/IbGOsFiLN0VmiV
         5ZVy9U4JtPR4wX/6GZYTREbmJ1UNNtryqMBtuvyzuwhTqEXqA9WIkYbvH2+o1Lu/FVjo
         0OBx8NaVrd9b8Q5bBUbSCAj+A51/FuGMl1kZ39rWzwr9PEo8fNAkveTnH3TeDoHLDRhP
         qJRA==
X-Gm-Message-State: AOJu0Yz1OkMMACLQ0rtARQFSQwEn9AhWNXx3xSwMx4FuIYt9gSoh3bgl
	udbcemLABHuO/RuTqTjpJ8DJ2OMrY7gdqDQ7yJSjMXOBd5yy1MXXODdpPRqC37t8lihTTl5RaQ0
	sgGhDGQTuo5HMSiagI60imWbYVH+aJwbgcdsrK59/5q0rZCM1vXzkN26FYP/B2h+SYwPMXw==
X-Gm-Gg: AR+sD12JVmzfTcTVlNWeFrzpPwW4KsuFqtXuoGdhkeZtYKVf3plC7F1f14DR21Qvijt
	ob3if3Rybx95hvgee+Xn4LFBxRhGIaukMltbYUy8f+JdJQKP2Du4HcQlGmR3M/cd/I8JUazhuLW
	fF4De9xTKGZedjlpzAssnYDspLqT6gv8tRTU1BPmVXKdc91smo1pQDmQLRrZrv7VuJS7DR6SlkJ
	/Tw1i1v+JE8ckNpy+h0nRJioHKgN1/v84C1TW3fiGdKWp+tVMLOvyoEvkiPjGT+4FzK9iH+t/YM
	6F/VnwSmN0qxffm8HjMMKQxCd9DDmkWAGfT+7F6mAaL1AIsmu/ZGx706kKJayQ6ZPNbxMXNz7Cr
	gu37T4yyO0Xxs/ePJGEu0WzAN50nvbdqViXQX2JiWRhDTtBBFiP68
X-Received: by 2002:a05:6a00:99c:b0:847:80f5:c616 with SMTP id d2e1a72fcca58-84f2dfc89b0mr16931670b3a.10.1786022707241;
        Thu, 06 Aug 2026 06:25:07 -0700 (PDT)
X-Received: by 2002:a05:6a00:99c:b0:847:80f5:c616 with SMTP id d2e1a72fcca58-84f2dfc89b0mr16931607b3a.10.1786022706778;
        Thu, 06 Aug 2026 06:25:06 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f456b785dsm1411637b3a.36.2026.08.06.06.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:25:06 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 7/8] wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output
Date: Thu,  6 Aug 2026 18:54:26 +0530
Message-Id: <20260806132427.3704828-8-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: J1DPjI-m361XGTwuVxpdQ9X7md1IE8Ew
X-Proofpoint-ORIG-GUID: J1DPjI-m361XGTwuVxpdQ9X7md1IE8Ew
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX4L/fXxEzWylU
 hRYmi97KOJgA1AcYh5kz/VE+jrsblGcsPMh4j1WIpF717h4aREN71V0X514usNkIh7tLzaw14ny
 fExgeg6j0CRm+WpwziM2VfV03XAq5dH8Gu4k1LwwagfVK6ejj70cOtd42M3qS3WIhhTEdrelSMN
 NyyCw5OHu3LyUD6pqU6Fjg5dBU3S+trT/JOEki1y835Cm1VR06ElGjbxtqrpQKCkRwmJrYziQzy
 U9dB75K38UD8wb3HV6nL3S13BXFEHpuG8nRFM+WSFvHwxVSrh0kKgOk1G2iD2aYFAxrUlE/QRIf
 mc7wrbOE40RsV4YKwC5DsdNeNcG3yTWQ/8AzslM4vZh1Smy/sjhB85mXn5vEHPnxf9Y51Nm3279
 AmXGNbnm6TrUrd2L5GSOWo+L0LHZ6qWxg/x0CqT6W4DaMV1+m/uZaYGNTQAmWKs+CGFgXaFD6G1
 1uwY+FuD2p8+jRRtn4Q==
X-Authority-Analysis: v=2.4 cv=K5cS2SWI c=1 sm=1 tr=0 ts=6a748b34 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=qz0A3ntWxt9h8-tH59wA:9 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwNSBTYWx0ZWRfX1yvo8tWCK4PO
 7lEF3bkukLGPgMhq6Cu4G1tMger8tD8dhbaP7b8wb8tuv5GbSIoeXlTT9SN+i7tlhOIHm0yFJPE
 43NzqLBLxmz4lIVRthxeqetdSwA85PQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060105

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

