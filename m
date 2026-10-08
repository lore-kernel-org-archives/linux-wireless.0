Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE4649CF42
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455125; cv=none; b=sLYMFK+C8K1SUC6V3sq1TLCEyUvoOoqqh08DEOYgbKUXRriniXJ1DuDGl+YPtkFaDnTriVHzVFZl8tii6HrJKdap9ckzyYfS7etUPU5wZFKVyaZ3mkQ1Eo5Gj4+50VlaZCCaJgGiP2DT/dykvOrQk+ihQn8OEvrvHzrrfUuSlMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455125; c=relaxed/simple;
	bh=/mQaQzEbMO9VUMkth+p0PJ6HTf8GgML61Zf2gvxD1qM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qznSaEG0dqDNl8tr0x1ykrlaHKlMpauo6g8xcAZI21cUfdHhKUywGpbyIIQG0PocGuk1+7t3LvITVjQmL2BXANqd3Rg88worNy5+XRidS8KpLCzQ9s22sT26lmWATKbZizdZ1NePQFcFk06U3wQ3huTZpxxH9RgvipCI0E7MLlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NEKK2MXK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Lf6685hC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NEKK2MXK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Lf6685hC"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KXlm1169987
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oQKRkceBsEcEBBuv3P9e+e6jVPpMSJdqRVHP6jxhJdI=; b=NEKK2MXKPNP8DBzo
	hT2ieGi76xJlW43gfDobjLYzAziL/QP4nhLoZDfrZAR/ahZBrSL7zCpOaWfTcpoB
	exINA/hXi8zC88U8mcCij/ZN8TTUw4kLcPcz27x26+jJMBzhi5ZUYz9x5KdWd4Ek
	P/oA+JZ16vR0832CZaSR1+J5GujALxpQYvt1kIGQFhAD/4jvLnXegT4zDyGL1Cn2
	PQ/lTXklLCjeOVtnrDO/ksapZRBzuHky3wR+5NGkX9UAoKBBtA/Mhe5ONd6MuRot
	bb31IkyM4WmnXPR6uSIbbFAtTVb3bapVg2Uf42g6+SE3hZBHs3Sc5Z4V4RjBeBBQ
	G8CgBw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe3adss-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:25:22 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e827b3a6b4so1049155ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455121; x=1792059921; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oQKRkceBsEcEBBuv3P9e+e6jVPpMSJdqRVHP6jxhJdI=;
        b=Lf6685hC8IEmWrBIpXA7alJlHQtZ7Za5+wpl9WMuHXhWi3ZEiimKap5oolpspcB1jZ
         N+kZ0Y2uMvfqJ3jsrcqGfQJ9ctkrcH7l+fRTNZUN8v81Ah1Xp+kTNvIFgQg3bDlmYD7w
         paM0WhGGqNZeT2/uZedtFWr9/GdHj2y7J0xcg4reEemT/ikMZdiwOM7+JeWIyYBDao6B
         7Nk5DMbBLKOnSeQPLqRU5TsuOvJNMDLnlMpKQYTO21g82UE1g4b9DsSBM6C/P41fPFoj
         J3rOmztP1TaM6NM3YBStDzf4amQs0CMlV1yGh7A+4TqIzKximyhSLt4DPO3gfUGRobBX
         4lmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455121; x=1792059921;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oQKRkceBsEcEBBuv3P9e+e6jVPpMSJdqRVHP6jxhJdI=;
        b=FP/+PQpCYH0ZTW3jbHfZJmWgoUOVc2VuZOpP7u42wd+fGhv3KhgTbHyHcoH1MoOnQx
         YTpMWT2rsqqKO+j73ipkKDRE9AH2rVT3UuvlPWKBOmWGTrt21xj/zAe6Ryvq81va32Dw
         jH1Ue8x4yKXmb8v9o32rhILHwrlphUl4CRGuCs1XkcNh2YnIaAUXpzjP2vcKq6DUPlli
         Dy1YwGpyBLkWwJ4zvo7WmnLHFe3IHRC6ia4NEyLokzqzdLzaTEQU7HENlkmYZhSqlA3c
         GG9s8P9BuOyNN66i90RnhGT2UiCUb29utE6wWlPPkkhNUK6lhJEm8D6GVog0bCsQHpAx
         KcgQ==
X-Gm-Message-State: AFq9FYITV/+mZxEMHZfy0e2GWQNuOxDhjEB9OrX74GkJbEiE1hy/mebX
	Qc/hgKSyAgDWrI5VLHW5o8YghCFN0lLU2up8BIm0JgWXwFJcj2QvgttYo+SJe3ZQf4R6KuXIit5
	+lMiBUDErUPsDdK7H5aAPqiYPnP9tg9RN4jeVMVXUFDEVcylbP2VvRQUU3/5CJIiowMSx7wmAU0
	/z2g==
X-Gm-Gg: AYBFou3An6nyzgdkRsPv7sTq88StVKh+XIJmdPW4HDiYwyoNrJU3i1A0czKlO/8hSHj
	7XoPl3OUeoRe1/TVmw0+JFGPaOgSXvTOJ41kidUXdi8iulBPDMbqgocKIpXpmL1GWy2XAHE2VpV
	FMeesOA7pdP+Nto5d/5XcCOZ/LP0TWk/Kzcc0P6NVh8JShvYV3k/RU5EjHqF7UHvj6GqF/hQcJi
	gRP6/00aSK7IQgY3iiew3pz6I051RpfMLdZwdndMQLdTDVIf/ex6HA+gqJQZATuTuG6f/aaXStg
	Ktj2iIg502m76xDAId/D5Z8Z8QgEAZ3eyK054pD9O6emW0CV1W6lKVOT9sx2+rb8KIwIRTRV5Fp
	BVx8+F3fyOpKpEDzZIavm3JDR+PHDfmw8x1vtMR2zkzC5/x4cxaVnZXNJhswWMcwWTCgB8Umntg
	oAcuYrGFMITVcrZ7VudfT0jQ==
X-Received: by 2002:a17:902:f787:b0:2e2:d83d:5004 with SMTP id d9443c01a7336-2e60057c005mr44321515ad.58.1791455121442;
        Thu, 08 Oct 2026 03:25:21 -0700 (PDT)
X-Received: by 2002:a17:902:f787:b0:2e2:d83d:5004 with SMTP id d9443c01a7336-2e60057c005mr44321395ad.58.1791455120968;
        Thu, 08 Oct 2026 03:25:20 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:25:20 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:11 +0530
Subject: [PATCH ath-next 15/17] wifi: ath12k: Derive QMI service instance
 ID per protection domain
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-15-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: tPdiwyjnNRxpk7A9r6tOHEvSkNHGaTzC
X-Authority-Analysis: v=2.4 cv=QOz91QLL c=1 sm=1 tr=0 ts=6ac76f92 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=1lU9L7Y0PnsvXye6yGIA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfXyQoWEGIp2e3j
 lPfnTYJhX0JmSAospFV9bRwcRyOAsXvMMolJTv9iwsBkmQq+oNnXzvywk4yoXcuq9kSzGC4pA6k
 //W+utGIa+biiSQ6+lrth6eCxa3+uzE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfXwSkFhdARK3m7
 eg/lNfSTmnMThPbUfd0eHfj8PY63RR4DIe9rxm3kOu/1ZyNa96bA/zyAdex9/8kzao5PqmYWHig
 AIGaOVC3WtpHVegdqBRVJWPsQ7G5CT9H0LVrYl99z+gQGjzgMyx6rZtE4e7qCBhPcinNK2XaOlE
 xUA8M22zQVywY3fk7kZVasIpYNmFqZT6oVqvZ186lZTLstjyRXIKUPc6iuIuYTSwPDPodkPoj1P
 ygDTQdEjtlUuXLBqL2nVxzCrWx6Q0XQ/QpEIFsMv6nJ1XXUE/JTNxCFWB0wZf2sOKl376SEbOE3
 +zFh4wD4tQttr5TVEcqtQT6uIkCSXvwp810ZMPdwIYeylbt01JAihCOACv/eS6gjvQvr151YeRZ
 6/ppKTPqkxGf7Iifrpzfklm5dgrg80hX470AlTHEU8/CACWlHuRyZZwwUYGGcLgLmunqd3XJRPb
 1RzN7f/Xg3xQo1IS4/A==
X-Proofpoint-ORIG-GUID: tPdiwyjnNRxpk7A9r6tOHEvSkNHGaTzC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

IPQ5332 platform variants are supporting multiple Protection Domains
(PDs), each PD exposes its own instance of QMI services. The current
implementation uses a fixed qmi_service_ins_id from hw_params, which
results in multiple PDs sharing the same service instance ID.

Update ath12k_ahb_init_qmi_ce_config() to derive the QMI service
instance ID based on the user PD identifier. Offset the base
qmi_service_ins_id with (userpd_id - 1) to ensure each PD gets a
unique service instance.

This avoids QMI service instance conflicts and enables correct
operation on multi-PD targets.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 892872f70b2f..3872aeeb9ba7 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -542,12 +542,14 @@ static void ath12k_ahb_power_down(struct ath12k_base *ab, bool is_suspend)
 static void ath12k_ahb_init_qmi_ce_config(struct ath12k_base *ab)
 {
 	struct ath12k_qmi_ce_cfg *cfg = &ab->qmi.ce_cfg;
+	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
 
 	cfg->tgt_ce_len = ab->hw_params->target_ce_count;
 	cfg->tgt_ce = ab->hw_params->target_ce_config;
 	cfg->svc_to_ce_map_len = ab->hw_params->svc_to_ce_map_len;
 	cfg->svc_to_ce_map = ab->hw_params->svc_to_ce_map;
-	ab->qmi.service_ins_id = ab->hw_params->qmi_service_ins_id;
+	ab->qmi.service_ins_id = ab->hw_params->qmi_service_ins_id +
+				 (ab_ahb->userpd_id - ATH12K_AHB_USERPD_ID_0);
 }
 
 static void ath12k_ahb_disable_irq(struct ath12k_base *ab)

-- 
2.34.1

