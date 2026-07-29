Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDB23CB8F5
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309527; cv=none; b=DigxsTt7N4D30uE87cIYq4Uk5P/02tw4/l+NKUVrwRzAtmL2xQjULoDhE1kbxUutbQjAoA8+vF5rHopcON11Je5tvuOhYvfWKMID2luzc884oI+F4FGfj4FH5t/vKxcqFTgNpvzWrNdkdyoO2R1YnxiK+1g9C172vqdv08NtXvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309527; c=relaxed/simple;
	bh=MVZDT4FuF2RAHuBTrBMl5OLdVoCJXxMNrd+wk9Z1OSU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bOFE7yUuXX/2qt9ripx25AKhVHVLtXW65mxZL0KBOLyEdUo6phmIGveHH39+LyYQx4JOqVhuTDArSoXb8IdtOK7zANWP05ZSsQjkeLXVULuJyiXsqGnIF9ttUyZTfAkylbi3aoJ8PSTn9u5jmhcq1NCKrYzNZ0HWO3VRLpZ4SJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DBvcsEoR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UY5voFRk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DBvcsEoR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UY5voFRk"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T4cQO6641714
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0/q4AL3UqHmQiIbXfDF4U/jvRnNoEITC5BmiuZkEIC4=; b=DBvcsEoRnd4gnwi3
	T7ylSpnozhVcNg13SYqFhhLMJ0q3wWBQsqhdT0EZy/r9EQSKaTBieCTR5IKWQZyH
	T7wt2rh+Zon8FKYfAwjzZOdL2qjOjrUaTC8w4zy7EDRBLN/F5M2s2VOSBRWYIU05
	NMuw399qCYvjNYc/4m1ljOldru+cDaLozax+EIVLLG5gWqHGtkVZjeiY9KFIffaE
	Vcm8VaG/3c1vRD/EXuYOH0oBa1AXgP2+EyB2UCyEQHC8eQ5YF2sz7AzCn2NekhPU
	5MNwtcOWWTG0ryNJAn9CAwEk1poPGvoGlOkOkfCbQEIQ0S5cixrkuV6pmXbaU3vT
	aCsl6g==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqa300nqe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:39 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c860544c077so1342642a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 00:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785309519; x=1785914319; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0/q4AL3UqHmQiIbXfDF4U/jvRnNoEITC5BmiuZkEIC4=;
        b=UY5voFRkQHC8kjaa+QbMMsdeWkveKAP5nqxWl4vmvU6Dh26jOIdBCGh8EQagBwN5bc
         exf9P78cqzmQnmBJCC+FpM4OhrKcWl7YIiyPR0A6/V5/UKEoVZZRj6aZ8Zjs51SVftDF
         4gefM4kOG3yvYOUt+e9e1RfgYW5Iy0JVp90EkwavvwADsxDqvqg6S6caKRNX6ZA3il4G
         IWRg2Id3qfOCtwozM+qxCf+bZQS15HPBzNmhLErDuTwVpMOjIUIm8xm6i4i9CnItb+gb
         HNzNfQzA2B6aaeA5RQ52C/xTZEkML9CvFGlWSpVo3iNSmIjIyCL9ojH2AuqFgVZxapo+
         YeYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785309519; x=1785914319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0/q4AL3UqHmQiIbXfDF4U/jvRnNoEITC5BmiuZkEIC4=;
        b=h3V5tArrw8AaA7bPEH6QYZmM9K5ps6kJMqZMdpPq3nXtuKgKkU48d2gTbV/jCPS05g
         AuMMEzA6oeQsKaCdZxSx08Qbe0Lc2ohB0/KQHYgJPl8DsSpZDzecaABZm8tBlRD8bvek
         nMPMFSNwgI0YvMMjdwHKRttcTT93Tn9upEugVT8MRRDbVDh/KTum6tvRPE+a2cU/x8QE
         OKxPbIu0DsXF8y0utCdCEh2LcgaG77NQ0qNRutS6VgAqvrup+TfgaWdbuTzBySisxP3a
         Qxxc8zsq/UAIQdS3ewD2m9/BZ56vMH8Kj0sfPortDkyArQmu01ZLIARU1PUPK0ANlx1H
         MGdA==
X-Gm-Message-State: AOJu0Yz7NsGkFu9Umqdk9QEvCwqWG2IvA4YvMjmpT2ynERhG8i8+f57Z
	laB4JTMEaVQB92IAVI04yg+TJVRYee1MIqy0LbsL3ZIN1YWEvtbwQg3uSWnG17yiPo8BLWeLTdK
	PaQn0HmCO3J/30sem2Dkrsaem5N6Og2eaACHXJBb+9DCqOAhCbVaa1iP4UPu8KqRTvorVTA==
X-Gm-Gg: AR+sD10xFhhLSOg6UczlWi7iv5QltS116JZhj7G8mEQqYaXLLDpuv7kLpJxUMSlyGAW
	atr02WNgBYkHOR8ApraQjNY2dOecLUCaotwzadJR1gbyi6HF69v6h9nJvPwwwezMKoj6bpTF6Kb
	yfNqA5dY0xLr2QfPASNBtO6GFOr5m0LUyHrMG/+sH3KYyihe+sEp9LP7VZlvkubt6Vetj2Unvvh
	CczhiiO4So+T8Os9DCAm30sJ9HTy3MIn3nASiN9lnJSy2bwrF95KuXh/yP/GLOt7DS1XJkd4sLn
	xFbBdlGdWiemExlP0uN7Y4UEMn4XdpUJmGEijr1Vbtsq/pnB8JtWP20NixfciOyhBqAr2Bh3Lfg
	WBP5cRBM7EPUaV7PpoerIFtVdbwieeb+TfzzgNtG7H4ZDSBEJ369NIA==
X-Received: by 2002:a05:6a20:2d09:b0:3c3:6528:c87 with SMTP id adf61e73a8af0-3c8aafc03aamr7355008637.1.1785309519128;
        Wed, 29 Jul 2026 00:18:39 -0700 (PDT)
X-Received: by 2002:a05:6a20:2d09:b0:3c3:6528:c87 with SMTP id adf61e73a8af0-3c8aafc03aamr7354981637.1.1785309518744;
        Wed, 29 Jul 2026 00:18:38 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb78ae98asm474793a12.1.2026.07.29.00.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 00:18:38 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 15:18:13 +0800
Subject: [PATCH ath-next 3/4] wifi: ath12k: protect new_alpha2 access with
 base_lock
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-ath12k-regd-wait-timeout-v1-3-504aa6e7e93c@oss.qualcomm.com>
References: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
In-Reply-To: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: jx8fSEngcalK3xbmKZT1pvT4bAhdVCyo
X-Authority-Analysis: v=2.4 cv=EME2FVZC c=1 sm=1 tr=0 ts=6a69a950 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=lPJdulcixYuF9D0iInEA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfXxvQFKSFPSyKy
 r45ofL5BenT3bAw18llC1WQCMXPJ+lQaF9M6H920ckRVKwWO3nqEDB5yM18CWLoqe5uWbuj/Zc8
 ivBnRqrW7IIzajCRX8U1TbFKzMjTWnw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfXwmCpeGhjiklm
 chCJEQwGkzFEP9fLGcmdqZw3YF+EooFLy9oJNCO0npmm8fm09uVDMhy+fZu8QaPV8dtOjuGIgr6
 s0pW4jio38NIBUMr0loMQRtKAyr9E8S4Mwgs5lz5MPnQVwn9T97aXqyYocwkXjHH8Rok/IojCqM
 VVsXHGZSx5BpO06jWm2rfICUVUC6RRei0GpqVFfYGm48XMPg5/Jtl4TScWLZ8J9zA4uT94h3aCv
 TVBKnrbDYRt+nkDV2+mXak1ND/pkUBkYXhBjK+K928eitsD9zES+/NBdms6k1QkHXAf1ZpKF9rl
 zH+qNLdxCxx9ZK4Zc/WqF7PgOiiBnc40I3V3YVI9XKaL7iBTsR2Mqd27y0XouhFoo3MHedIJoX5
 hKXyIZqFP494cSst74h9QIfljcC3niUQGvuoj/X9He/XOcXhcNkQMTkQlbpQNTaPksESL5pSffC
 C/iizaYr6SQgZZ0PQdg==
X-Proofpoint-ORIG-GUID: jx8fSEngcalK3xbmKZT1pvT4bAhdVCyo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_02,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290058

ab->new_alpha2 is written under ab->base_lock by the 11d new country
code event handler ath12k_reg_11d_new_cc_event() and by the SMBIOS
BDF parser, and read under the same lock by ath12k_update_11d().

ath12k_mac_hw_register() however read ab->new_alpha2 without holding
base_lock, racing with those writers. Take base_lock and copy the
value into a local wmi_set_current_country_arg, mirroring what
ath12k_update_11d() already does, and use the local copy afterwards.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 82cbb5b9cd11..56f9c1945cf0 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -15052,11 +15052,17 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 			goto err_unregister_hw;
 		}
 
-		if (this_ab->hw_params->current_cc_support && this_ab->new_alpha2[0]) {
+		if (this_ab->hw_params->current_cc_support) {
 			struct wmi_set_current_country_arg current_cc = {};
 
+			spin_lock_bh(&this_ab->base_lock);
 			memcpy(&current_cc.alpha2, this_ab->new_alpha2, 2);
-			memcpy(&ar->alpha2, this_ab->new_alpha2, 2);
+			spin_unlock_bh(&this_ab->base_lock);
+
+			if (!current_cc.alpha2[0])
+				goto fw_stats_init;
+
+			memcpy(&ar->alpha2, current_cc.alpha2, 2);
 
 			reinit_completion(&ar->regd_update_completed);
 
@@ -15067,6 +15073,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 					    ret);
 		}
 
+fw_stats_init:
 		ath12k_fw_stats_init(ar);
 		ath12k_debugfs_register(ar);
 	}

-- 
2.25.1

