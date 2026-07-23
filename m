Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6119F4ADDBF
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811311; cv=none; b=tmHvsSvFAOKPjf84y53tq+nqUsCBHmCcK8m31pF7yBzRMKPk0iTWmKxTIjgci2pHPYy/MZB6s+lukSJWzPsVZiMfzeEDuh7qXuovkkGG4hYpK6nEcM6Xg8S1xeW0B8gACJTI6uBE1bBFlT9xuKwUOAoo4boXl90YANub6ag59is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811311; c=relaxed/simple;
	bh=z4JzQ7RkVBENInX9E/F6zyTzXjiyF4Yn3Hv72Jk2xAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ggont11BA8IYFHKcz9PUhtcjUhrDj5dlRkgTHa9I5CF++gx0015D5U4zFO1TzsyNKyV5KfxHs/YYhvovP5W4LJ5xtDSYr2XPMBx0TrcpX6vWpJKCFqBzpZAzowRAsS4WaJUAa6NUOiowi/LowEauH8LRoWC3XZA/CkYgQou9eT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eiqhZmLX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jh2w0gd/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eiqhZmLX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jh2w0gd/"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N8qW3Y3390463
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=b94oKJI0V8o
	iizpWlY+ZEOOdVZp4WMCXLAjxVvV7f3A=; b=eiqhZmLX49jV5vQNQmSHLEujs34
	8en113oKs7KNYCWlyTilZCH47Au6Hn8IK3ZHcC3mblgs1I1Wy/5vpdY14llBjwmz
	TIz0pC8lrqfGWyo3VrUFeSuImhVCMo4rGBQB1LGZgqaAQlmgJe8pT9ZhpLOsjqaG
	1bqv6s1HOWrekvW+7mv63HV9IGz/F7BzzHvhJD2yaHG3cdXVt8DnvfG6XoKWqF/Z
	Zx1SHQnimJns1EwzZh+RUR1PzdLjk5dUr6CHW/afEuEDobQazn8syYoI7gfdy2cL
	6i9rHWpmmMfaXsQtfz9+4c7hWnhbQ0HtnzylltMz43N9KHQLcxs5hZ0baWQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fke0ksdwa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:08 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ccb6f6a3f4so6819875ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811308; x=1785416108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b94oKJI0V8oiizpWlY+ZEOOdVZp4WMCXLAjxVvV7f3A=;
        b=jh2w0gd/PPEOEB/FPtG1V/qgtB6sasE4r5nBcYh1ZeemTe/kKFKHIfrkRdZrljDHki
         uAviRu1TYDgs2gDW89FRVtzCNESGzPqd2Uuirwf826Bqv+V3lgptakkMzVkRjh8dJ/8k
         iXwdncxidHT/2NynfS+kQcIWqZ5cNNvHrHwwRsQirDzVG+R6Y6w1cjDq3M+sVOGV0pX4
         UaEDBvtG8eLT5vuxj0j1rj5yNgchrsLQp296ExalYXIwhmlLaTQxUZWa647jnVp5g0x8
         rhnXA+YceFXl4d4FCwEmW8shGGAULIKkf76wqHDjih5bBgaQ+pxAeQQe6ztZEqMrdrqT
         OC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811308; x=1785416108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b94oKJI0V8oiizpWlY+ZEOOdVZp4WMCXLAjxVvV7f3A=;
        b=TK9+7ZwkrRzhnBHZTO06O2jxWUyE/hM9KaFhUPFBIrXM2yC/WY/1sz/MRquyQ1NslC
         HhlfJVnEmadDG0AZtR1gl3YbzvKWYd4rsqqE7y+DbWGFjXfWygWrCquLFZwvTQKqU1FA
         nkWEWCjpl5iXw+moIwacPAL/zav3pCruLbcYHsm3sC4mVuD4MGO4nI+x3F4gv+xQ/8a+
         K8a1BU6o6ui4qZeSn0iBOyOU35YJ2C3lc8fydHPNGhFweDIfCpWTnqIlkIme/lZy4PCc
         BJDDwX9GnXiVGWbWUtEc7w4/fzsaWFxn1RfUY6iQcWawgn7jR/uLsEe3R5LZzX/itFlb
         sITA==
X-Gm-Message-State: AOJu0YyjfcDSqYlm9ZTVHnKhml5OgvemyN3411kztuW7FhKpODXXDnGF
	5gEGuUIGWunl+pbM6tKSQLsatCH2mQJu2hRyRvChc1ZaS6Pq/kNEpe6eKma6hwYcjpBmy5TU8xl
	jcVwXVjsMkVH/JiLrfxqtADQDS3amqitWHU3Z8VtnRnyZQX0YXxIN9EnIpxBJJgx75Tp68aMoLY
	B+Yg==
X-Gm-Gg: AR+sD10V1+8S7HIt8/p7GARAWaklwh4ZE4151qDHZ8zV4dLo5G1NaBBc9GCXv4lqwNi
	WI4c/syOIw76o7nn33B5qquTMQ+gqIxlHjvkofv7HPfmEKT9O1CMxoZEA2DqnP0d2CIB3WAvFa/
	dtmXvsp75puxmQYiynLLEpzztQiBN01eMKGHRwLbL68+RBt43d1aOsd72sAy/p5oml1OAzkbFsL
	1kOvueZefPkCLQIKIewZGfnDo28A083G4IgAqDvxHQUDlT5w1/Wp8PSZ4Wk7v6ZSunBL9R130V5
	/kFIyAKV06w+P9YlrwaVcesTWJd9Ws5/aLDqKftq6pZB68V7hri6k0UJkP85hXJkvDAaSJ0z/pq
	px4pk0w2Xp9Ej4f4sJyhwCiWn2Rkp7VBhfkLfoHwOOUSEZaaX8J2v
X-Received: by 2002:a17:903:f8c:b0:2cc:fa13:dcab with SMTP id d9443c01a7336-2cfa947ec37mr26487985ad.8.1784811307777;
        Thu, 23 Jul 2026 05:55:07 -0700 (PDT)
X-Received: by 2002:a17:903:f8c:b0:2cc:fa13:dcab with SMTP id d9443c01a7336-2cfa947ec37mr26487645ad.8.1784811307305;
        Thu, 23 Jul 2026 05:55:07 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm32998385ad.70.2026.07.23.05.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:55:06 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 2/8] wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
Date: Thu, 23 Jul 2026 18:24:42 +0530
Message-Id: <20260723125448.922361-3-pardeep.kaur@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: aaedkY1LJE7crbUX4YjP9XbAkdVKklk4
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX8PPzW0HypMRN
 2KukFpJDh4iSq77vLvROBuIXNATRK976YeiEMNiarbua2KYvdM49UK/0s8kRFqEQ8sfg3Qlb0SV
 p/WJWoi8zMv0nht1AuSjYKmEVSyweN0=
X-Authority-Analysis: v=2.4 cv=S7DpBosP c=1 sm=1 tr=0 ts=6a620f2c cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=RuwI03aZ9ZQFnXGR-2kA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: aaedkY1LJE7crbUX4YjP9XbAkdVKklk4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX/M+k4C+R7qeB
 fOEM930/Ac8hF8Z/lf5zc2N96oZXs/O1l0ed7CbVaoLEXorgD4WZePzXPcNEQ9FcYZqdiZwN0sd
 1AN++shUIXFnGul3PjvRhZI5hQb2VLq88LkYJoEvuGHiSUvi1qm2XaeWYXa9Q4v74AL9Ss5Koqu
 CnCRT775wV84EGOCi2W+l3pgmmW6rfO/nRFz4l6bLyAkKDS81I4SHAvUbwFknS0brXUGlQAd0A6
 vuAPA1urc0xMMqYd4iC0ouUFKqjFo67sA9C374hPyKqFRzweqTUd4ASW0MU9VJ5Vr8k0KKQmfXG
 oXuhjq+Rp7I98EaCZ6RAPnLv2v+e3SGJmdcWULauIxz0TObfWfh60soOGj6Ejyix8QNAIayhnec
 Xm45R2WAYAOaJipZ7AqvYtjFRvpZuJAifp/iYEvyjwKQh5BPkbYSvNVsGbIRNMrho8c0WKhEzPU
 0w2WyVYxQtuZPbaUxyA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230127

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
index 1d55ccacbff4..a0e409452a19 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -513,21 +513,21 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
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
 
@@ -549,7 +549,7 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
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

