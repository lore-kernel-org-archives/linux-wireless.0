Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDC347986A
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 12:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018192; cv=none; b=IiEMe5B/cvHtQT0CjU21hc9vJFTxhKytSG+DUAYPRoDraBefeHxzhkxvtwvbWeCAS+tGaRyEDcb0nsCNhnAKPgt3Ud2sN0Den4aYB41y9eb9t/SM0caR+zF/ILnHxyhMR97ttaO2QjfGzluGwuJX7/BztKgQavR8RHEN0PjdJFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018192; c=relaxed/simple;
	bh=zkIyrD0LtcKmokmX7wJVEdwobsTHp2ekxdppZlTjbV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MbJQDcr2OAW8xBVXbKCwSXgn3dBzL+h5XYrBOprmm7TBCMrRpzNdMm5xLrL3c5CckrEAyPjcUlkAXU5vtplWC2aiI0VO0yNqn2NKgBnHngKOpFNOXoPpfIOfRJLEXgwt0MiiABDexS60uGfVRK4Pyr+83BAwT/fCdr/KVgYz+ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OGSEjlJJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iJDy/OBe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OGSEjlJJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iJDy/OBe"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nr5K1228396
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 12:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=NA8MWFLnRkH
	6OIWjAyG2+978gj5PqzR5yRejjiikDww=; b=OGSEjlJJPvOtbfa+y9KmupCVLeU
	aUxUv4DGcjvUX0Hj71hHlo18SxlnHTIlhIBj4kGR/HM2zTVlDxqKb0avQ0pc/T75
	zkkz5Afx8bCoa4xUOuto+UyTAHF4q7SlfrTCixvVgUahBeHKf/3xivw68yve+oL4
	MgLSBZCSVR3efr/aJZbGT3J9f+nTnTrE2o/mX2sx+Lo708zoUu8Sj5acB+lc+Ch8
	7fPVyRufbWXIFhglWdb75xugH0gJ8lwsrqAyNcIesr4qixE8brSSYyb9pJjnRK7x
	8liQRFwq7bqwWWqy7C+CNj48GmAqKs9ik872wYCB2UJEno14O5+EZc/yJ9g==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvqdugt14-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 12:09:50 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d04908139bso38453215ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 05:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786018188; x=1786622988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NA8MWFLnRkH6OIWjAyG2+978gj5PqzR5yRejjiikDww=;
        b=iJDy/OBe/AuBGvx7ANl9aeiZ33P5y+WhO0FMOwqtwGbpkgK81ok/zVqQRJQs5c+Ys1
         zCQrpcXq5pDSDJKRsUgWZr3h7Zk4uMk6pq+UEFDq3Sw84zD2alWZgbXpTKeBMQvu2EbZ
         3QDKGPKnZRpDTf/ZQiQov+pS60MNlaqAbSAPMhPmUoZOasndv+wP1F0qg5iEg2PEs91N
         TkTJSay/DjWZomBh2UFDUSWTwLLcQKpX2tt1vAXpIZsgPIHuuH6IdSxFA74R0wBzD40/
         qCyNhbdElGxy38J1s/o6cXCjLQZ9OLECmQ6QOGbSqZyWj7okVfMS1GZ35QpALrDV/oVh
         xMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018188; x=1786622988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NA8MWFLnRkH6OIWjAyG2+978gj5PqzR5yRejjiikDww=;
        b=I7UJeRYrm7Ad90LPi07yQAC+CrxNLhiR7cl8IBXbJ0hbjZCZcEQ6VzA7NanXjMyTtr
         5l6kgOfRB28EixDy8S/1Oww298i7TXblHtP2fdjMoJ80xm8CeiciC1QA+9kVpw6JQFXZ
         QzpAikQoVpN+iHZneZ4lRpf7VOhEo94IfTikuFQQFpUPxoPt/8YOpsDG3Yt4xjYTX7aQ
         AOC0+gA3eYvHG2d8o2S4Hbm63Z4HINQpQWSjQioo2f008gMw3JAnOIqN1eOZPeg0weox
         jUbuMdlItUMjCPkMsZIqONPTaerKuOK4UOQGVyqosNgB9Xl3m4/3CV2cvPPMq9wUa4JN
         Bv8A==
X-Gm-Message-State: AOJu0YxtbrcehVrrXGZXEwCmjC2bD7piWTwLPvLDsaNi8r8HcVRa5LYV
	QvVqSN9zz8x7g26vjzBZvEl6ziplb9X+tQ+wUYCntEVydXjOOhgaFgj7uEZT7mVU0sup2xxcBYo
	81gAIaP5+Ac/L9gBpKDa9TOxiwuI3+nSMDueejhQEj2GVp/Qnk5KX1/ShRnXnqgIa2YMJXA==
X-Gm-Gg: AR+sD10ZCqX2yEN4Xy0Eu3tsYvPIp/4EwQyNSrjWvLikHHnN1MGVaiBLdYZomiFZ9b6
	TBlgOPGwu0p/NbteUX8KxjR/7QgHUy05sP1+IQeUoGDGXt55oHiglNv4p/VJjA9P14EEXnM1e34
	O6Hneu7YTcefHu+VUhRzNvKQWzO4xd8ikNGWxQiK4N60iEL3vHvxp1lZnoKtjhwovVnKF+fj6JV
	ZKgfqlJaYHURNwxotIoOtpkADqozUv6xru/CiplsQGDF7p7Cz54S56L5zziwFIwq13XRlsAmL2Z
	Dt7+Y5WSCvFVGcLnfFDzTakZWgY6jvsZ9BVMCUkMzSQEUmKIc1uv8U1ELNcGnvvrCS9Qt1laRxK
	EaSMHYZX6JLw35sagYmIL2T8YQJKj53PsDvbGjlbexelLzXEgSJPG
X-Received: by 2002:a17:90a:da83:b0:38e:2c8f:a01a with SMTP id 98e67ed59e1d1-3903c5d2f8bmr14359578a91.11.1786018187861;
        Thu, 06 Aug 2026 05:09:47 -0700 (PDT)
X-Received: by 2002:a17:90a:da83:b0:38e:2c8f:a01a with SMTP id 98e67ed59e1d1-3903c5d2f8bmr14359467a91.11.1786018187388;
        Thu, 06 Aug 2026 05:09:47 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085db4a6csm1469079a91.3.2026.08.06.05.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:09:46 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v2 2/8] wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
Date: Thu,  6 Aug 2026 17:39:21 +0530
Message-Id: <20260806120927.3607733-3-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806120927.3607733-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: G5hBi60q1VZAW68thM2wz7l68SkO69VO
X-Proofpoint-ORIG-GUID: G5hBi60q1VZAW68thM2wz7l68SkO69VO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX6In2rmZ0N4Hh
 HkLjEjOr6HsDVsF+ES6bbgrszTStWEpF3ITMzoi/kWlONtbTTG4j2/BOAWkKYaAGx3LXaFyY8TG
 jTb6D3xI0gcHN1NxKwWjTP6FSNKpaMjdJBCWoVM6exECvn19VPYtdSOXGztS9VLIGgbROQPAjki
 SKCjGfsb259WOGfmHJkkuAdt7auesAeMrFVoE6D81HlhNZxW7zEUybg1HmWdh5v3STD7Kh0m50n
 WaY/fITbL/gc53lfY7HGwmzSxREZEnYVTaoWMjuNFrIERbT9Jz7LTfPDInkZRF3tXrmGUrOlFCy
 fWRFo/9TufVSM0lneEIsPhzDcCgXWCyAdoE10oh5Z5pa1DEnWSqQLNbBYGAKqIltkjQl/TBbXTJ
 e0zYHqcoJkO4azGdWx32pSJXCl09aPd0bQ51G+aJoizwIkvkpSLfAFTzuXNz1pVp/s20tgZZKd6
 qbisgwkpLE5NC+mUs5Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA5NSBTYWx0ZWRfX3wMmzppJjigG
 4qiXGm+ovlIpEe0SrgFGe6qd+ZVWSiDFlfiYhgNYNzPAyhiT0vHF+ZaC/eBK1lE0xOmkacUSlpO
 cZPnUIrvQqJQbiekK6A1hkuDj+g+/KI=
X-Authority-Analysis: v=2.4 cv=bdtbluPB c=1 sm=1 tr=0 ts=6a74798e cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=RuwI03aZ9ZQFnXGR-2kA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060095

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

The variable wbm_status in ath12k_dp_tx_process_htt_tx_complete()
holds a value from the HTT TX WBM completion status field, not a
generic WBM status. Rename it to htt_status to accurately reflect
the field origin and improve code clarity.

Also fix ts.acked assignment inside the HAL_WBM_REL_HTT_TX_COMP_STATUS_OK
case to use true directly since the condition is always true within
that case branch.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 632230e77802..d46a3d14f018 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -575,21 +575,21 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 {
 	struct htt_tx_wbm_completion *status_desc;
 	struct ath12k_dp_htt_wbm_tx_status ts = {};
-	enum hal_wbm_htt_tx_comp_status wbm_status;
+	enum hal_wbm_htt_tx_comp_status htt_status;
 	u16 peer_id;
 
 	status_desc = desc;
 
-	wbm_status = le32_get_bits(status_desc->info0,
+	htt_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	if (likely(wbm_status < MAX_FW_TX_STATUS))
-		dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(htt_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[htt_status]++;
 	else
 		WARN_ON_ONCE(1);
 
-	switch (wbm_status) {
+	switch (htt_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
-		ts.acked = (wbm_status == HAL_WBM_REL_HTT_TX_COMP_STATUS_OK);
+		ts.acked = true;
 		ts.ack_rssi = le32_get_bits(status_desc->info2,
 					    HTT_TX_WBM_COMP_INFO2_ACK_RSSI);
 
@@ -611,7 +611,7 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 		 */
 		break;
 	default:
-		ath12k_warn(dp->ab, "Unknown htt wbm tx status %d\n", wbm_status);
+		ath12k_warn(dp->ab, "Unknown htt tx status %d\n", htt_status);
 		break;
 	}
 }
-- 
2.34.1

