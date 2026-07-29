Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465943E1228
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309527; cv=none; b=bL/VQgQBBI9uuuX5rb87g7cSDLLTDvjLmeAyJK98FZnd/xYOv1YJnDBqCsbMYoONwD7PErIWuGYR3Y1H6KoM+j5khShLiAlc3EryYcN7PVbrl09WRUh8rTx6IcM0Pi2mg92w0sA6iYW4kwdCSuz70uXP7rawCu+6QBmDv661kSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309527; c=relaxed/simple;
	bh=3lb7vV/fDgy/7b4K/uTUPgfVCjp6EfBzApBs4yK4evc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UeKzXIq6pC+dn3Mhhfdcz4VhXOtCcLlx+HCbxAwaNb5RfL900RS8ID2RL1zUZHAx2LSCVDBZY50k9VAfFt3mQ6F0XVLlNmK3177ciVk0VpOa8Lh7acM5Qphw7bm/BbNQFpKWwzvYWU9iX+ZRQoaOtX8VkltNM1Kx2LHtJoeN6ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LyeJN2UM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WyXCYMA5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LyeJN2UM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WyXCYMA5"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T5bI32882583
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2vV6PuhWyYC3Y53legCPkn4+Y6Rrzb6+xFpOeHasTnE=; b=LyeJN2UMjXJcIwvz
	0GdDcXSc9aIVC4jIP0MHJWyirG1Af9iJXBlyhDpCiIbSt+R4WbishLtuxIdE2REr
	q4ce3bDvyNJ4afR+RghuRsNyrjJ4V6vknX4I2BsPoWudJR+47LAFcr6odjeWCStg
	asVa3lBDPRrXgOtNp9cHB76ZYAL22qehAoNMp8WGUqysbacbqXDlcOKIAvAmniE2
	sK18qyP5MZkP+Y3kZLk3UVlijWGnzLCg19rwZcPaLEqAC7qZv+jk/deuYAjXMxyy
	t3fdDAcC9vL7IGbLkUSLAW4VCcQXhfQK/IJqA++LxJ041/ElQDZybajRF7X7dLlz
	FIlH1Q==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqbhj8ccs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:41 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb5cc1e139bso469965a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 00:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785309521; x=1785914321; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2vV6PuhWyYC3Y53legCPkn4+Y6Rrzb6+xFpOeHasTnE=;
        b=WyXCYMA5vvkvOoyb3REHT+Ziz1BLGPzGr2gJNUVO6DFzzERxScC89KqQ6I2YyxqinO
         gh9ivzL6oZeo1del6g4rfDBou+Ktj8eiKw2Mdp/+OkfNhgZo92VdY/oSzz4XI/cRxPbN
         u/ciaGttGaPPL6TTV4s1RZJq2p4IpdnLfPNpP6FsOX36V45sahX7qMdBneWACMrx7hYF
         U3H+XjNVDXrrxu+SQ9TajD/MeALsn9nEWVktpjVaJdCPfCzJjSB3KQFKaAJFeGuvoA8h
         QlyZ5ZQ4XiNVPofGF3LrYRzYCZAe5y71NAQue0r1noHOfAG9O4SFkIAcF33++LwV90bL
         GqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785309521; x=1785914321;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2vV6PuhWyYC3Y53legCPkn4+Y6Rrzb6+xFpOeHasTnE=;
        b=kH6llCKivgD+MLfcmRJdeV6CsSfVY+U9qVGO27lUeMNY9EPqlEZQEjf2i7TS1QEhIL
         o42c2I/GB/AUyMh97R2gh3N1cZHYr3pCTMBPa0kUh/zhjNIL7zxNCi+Cg0z7tG/ChZL1
         DpBHvXtEMMuK8GOvHwoKkiUhSdhaKdlebeKBxM4uu2+a56AO9yUiA9pVszFpc9NEdFgo
         E8YvvNaxaF1QfT4T8yQA66ajPE+h/oRNj4D9Xn7zzBVq79LVWvbyOPfJMcY7Vi58xlgg
         qgtVmSjuy824KSMNqZRFJKO6uPLOJJ9yU2J1PEF4FmpvsHrYGGV5Ed+OgvqiwIpNpOWE
         2LLQ==
X-Gm-Message-State: AOJu0YwDpwy3UZ52DzDETitNKW93GhsiBkRCwhz9dUEY4POcAirQffz2
	WQAd4LfNy3X5O/xWQ/eE987MfN6KdtIn131es7iI5lIa79Lwgx5yoRj+oQHZidv4WYDncYIIHFA
	2H6FEHUsH0+ICrQh1amn53f1w4rTPT+Ols7fPqCaVZqjbvk1klmmG/RPTBb2sLjzaG7WEwQ==
X-Gm-Gg: AR+sD10j9Igtk8eyFodqAeM0DivrWNJElAZfoOOD5oyIH3UISwIfqQlA78YrNz+Amgt
	gIWjlbxfxSZxC8cfH/rZsMez+ErI4Qej+ACscPS61Td3CG5tkFFvld7y1P+/AvLvfyIl4WpMYQp
	OA6UnpRNjmS/RV74uM5OP50KJf0W8577k9GLwmeNhJ7C6Azq9w4IPKITXBsruzsQtJICLKox9Tf
	hWoedyYkjplXFsSOrV+xEu8ypmf29FvRJGV9XMLiswwb+8Pfh94wmu9Hvly1j8MJElAM7kc6BvX
	09ONSdNE2DZle+Oe8iBnLUeJTUOrHmh99i6LV0SaEic96czFfLvngq/IJfF3ikMAGB0tS3mh11j
	i/oEot2d25fpVfAqDzDuiKHNGwn+XuozjRlxfJlfSc4gIb3gSDqAarw==
X-Received: by 2002:a05:6a20:7291:b0:3c3:a140:939e with SMTP id adf61e73a8af0-3c8ba5f59a7mr5905266637.53.1785309520900;
        Wed, 29 Jul 2026 00:18:40 -0700 (PDT)
X-Received: by 2002:a05:6a20:7291:b0:3c3:a140:939e with SMTP id adf61e73a8af0-3c8ba5f59a7mr5905248637.53.1785309520439;
        Wed, 29 Jul 2026 00:18:40 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb78ae98asm474793a12.1.2026.07.29.00.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 00:18:40 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 15:18:14 +0800
Subject: [PATCH ath-next 4/4] wifi: ath12k: skip setting country code
 during registration when unchanged
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-ath12k-regd-wait-timeout-v1-4-504aa6e7e93c@oss.qualcomm.com>
References: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
In-Reply-To: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfX+51jFYJioKBd
 GY6/uLOuI8XrEs3bfott4H8It5XoDcRUv36v6ZDNeUfbUgUnjnyPg1eZEEP+owWQzRgdfJKA5e3
 QTS4vn0Pk8TE7V3nLMq7jdW7pv5KHdKTscmFonPYce/GCo52WvjfVHv5TuWzrCXa8KkxsGRUJzP
 Kwv3CQu3Y1TB49DQfi3UvZ8L/hr84ZX1+iwkeVXZXQBZ2u+t1kQA97aN6KJxdi7TCef51VUibKw
 945uGj1uYheKpJ/c48kABW/GvMAKLaP6UQrBkUoDwKCvT1LSB63HziRLHPokVB3NmGCg2NLdFHg
 CdAdnmUt3CR9iTr0JQO1VM28f0gCwrG/74MpSBDaTgvZnBOxWIaiNDxygZRGmelsMHRd5tYm/Sm
 8gRrUSMXU5ogFipdLgCv5Wj2CVoU4gouMrciUFRBlVK44tjr4Kw4zwPQTa8cV6DH9cErJFEXKAO
 Xd0b+hrUvRt6g9TChLA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfX2mLjnrUWpf/2
 lwuaDy5UaNsBVv1EVB1mt+rs0lQZ/PofgsnyZQBBJpRSOaDw0SXCEfJq3hrTQAeQ2fRKgwn5hhz
 xqqjFYK/tK5+UyZQuyio1/UmlNDR/3M=
X-Proofpoint-ORIG-GUID: AfAxFMoPVUcj2gMD2T6hnHYi4lwoXFY9
X-Proofpoint-GUID: AfAxFMoPVUcj2gMD2T6hnHYi4lwoXFY9
X-Authority-Analysis: v=2.4 cv=dsvrzVg4 c=1 sm=1 tr=0 ts=6a69a951 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Z5rCUsNQUV31c42Ogt4A:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_02,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290058

Currently ath12k_mac_hw_register() unconditionally sets ab->new_alpha2 to
firmware. But when ab->new_alpha2 is the same as the country already
applied at boot time (stored in ab->default_regd), setting it again is
meaningless. So skip it in that case.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 56f9c1945cf0..91182e826bb8 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -15054,6 +15054,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 
 		if (this_ab->hw_params->current_cc_support) {
 			struct wmi_set_current_country_arg current_cc = {};
+			struct ieee80211_regdomain *default_regd;
+			bool same_cc = false;
 
 			spin_lock_bh(&this_ab->base_lock);
 			memcpy(&current_cc.alpha2, this_ab->new_alpha2, 2);
@@ -15064,6 +15066,16 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 
 			memcpy(&ar->alpha2, current_cc.alpha2, 2);
 
+			spin_lock_bh(&this_ab->base_lock);
+			default_regd = this_ab->default_regd[ar->pdev_idx];
+			if (default_regd)
+				same_cc = !memcmp(default_regd->alpha2,
+						  current_cc.alpha2, 2);
+			spin_unlock_bh(&this_ab->base_lock);
+
+			if (same_cc)
+				goto fw_stats_init;
+
 			reinit_completion(&ar->regd_update_completed);
 
 			ret = ath12k_wmi_send_set_current_country_cmd(ar, &current_cc);

-- 
2.25.1

