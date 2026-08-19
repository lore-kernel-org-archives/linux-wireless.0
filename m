Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5C1B4138
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787117588; cv=none; b=MJ6s03JgWIJjygWZ9sHX/drbLi2DepIx+yPPtLvlEqjOWWg61clF+Ggdrdzb+yKYim0UQhfLdcHGMoU0dYuNCs0XIwLt1xY2qFoYIi2/ld0mpUTf9QdcKiFcwseP/DhfHK3GXUzmR2yohzQaGuK7TQnQ/XC66U2lek9Z29V0WFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787117588; c=relaxed/simple;
	bh=6cGc4L7NA7gSihp+HkmNS6nrBdm+mhKbXgOLFu/+JBk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tVFN56SsEnfg+ahHSm5Y/KA84E55hR1eoucZnhDon8gxZQBbS5S40zWE4pg3s/dmm12RSAd2O1RowRk53afXYEI/b/DptJYSKuUcHrv1dkb4nL0lAV8ngikeg62z2EIA07xNtRiJB0uY963qu4Su3UYGuvqCHpuAW1RKzDquANI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ni6k4Bzo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=O3J+ppXh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ni6k4Bzo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="O3J+ppXh"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J5IFL94049283
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ljCy5O5Q13z
	J0R0deOdY6rUGXlXk5toVBCxTqHElnkE=; b=Ni6k4Bzofx4L9jeiHsfuornG53I
	SNk8CEIgK5Wl4P6F2lwfEzJGs9gCyKU5L0ChuO2FfhAxr4j9mO09Jt3Z50W8U4eb
	je/Pc/MXdF+Lf1S2zuiQUy4sTNmypAKMcbr/l7W8twE9yOuGTEsMa3suMkZTO0z5
	/9fQQV+zQ2N9F6PWLllWpVGAcj/Pr1gDY+nn13ssPY9hpjqkxWeiifIzkTyafUp2
	YJufLKIFZw+gL3i6VCkcIh2wtlcF4N2ug6TWy5valzl4fEjJUUmbRb/OMG7wvygc
	aqZ/XGioAulVKN+Aibcxp4jflEHiIKxdcIXAU28tDgsj1IEjO0xFs519LMg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfpsf65-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 05:33:06 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38dbf293831so1731486a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 22:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787117585; x=1787722385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ljCy5O5Q13zJ0R0deOdY6rUGXlXk5toVBCxTqHElnkE=;
        b=O3J+ppXhC1QQt4f+dnSwicUmTLHKK+4Qy6i+YSppSR/kLjUHCJOmyqS7qZFK+3HOzb
         nfR3mgz1yLxzZd5zzcSJKGnoWoVKyhmcWkTbG9LLp/s62O5NIaXVg4PWOokKQBV6Rela
         KDxvr2cDlBzCHj+oUIQFzckwOy70Bg/JDKl+0vQt3y4O7qZPvPsIZL0uDtYQph0NRpbp
         yaZWak85pndEGUnGcvW0xf6VpQiPW+b0K7ApXiObkLcRweCglNLAcOpwoOyRB3LqGcVn
         XFQrgezprkz58Fuav0AHYSqVbCO4BY9agvzoBc6cpmkbheiLKY3fG+5WfT+OoiZERNMH
         +1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787117585; x=1787722385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ljCy5O5Q13zJ0R0deOdY6rUGXlXk5toVBCxTqHElnkE=;
        b=K482nUhHIBh8h27R24RCqUpf2KXM8re8MkqMJM4jsUYbOGU6xb8uCA9Hi2tG2um5D3
         SWek222yFZ3XMo9hiTyPzES6Zp9zfRRt7Bk3Vque/GKWJMeMswpVbz4hPHkQoRDHu10w
         DncMype0LtyHJQ0SlcwA6/B4h1zDxymhLkC/rxpEBYEUrAtn/71sf9ehV6YzRF4Nf+lX
         5EBXiHflZhEV5ob5yehpKde17qk3pVM01AaRjfdhJI7MLP13YY7ycQb4JtdUlsXlU99d
         IzMt0wJrNTZXZ8RNBGFFOk8sUDvWjScxWN1R6XrtTjDYs0OHz3S0tOh1nLNld1ho3YqC
         mY4g==
X-Gm-Message-State: AOJu0YyxymAg7M3BOyh9IGl+T6Stfu6a+LumzyVjJnh1PCM1sc+b92Ac
	dXlxabqrxdTd+4MVp4518cHglVZVlSWgNfn7lsTACbPyfSIp1agDcnWgiFrQu/AzV2cpG3KnB0m
	mX5IOlUd6M6RHOakNBij62lhXdTCgzLVl0uSkNifZpSaiLmBLK22g/fcMkjrvpdzoz0EGutVlvk
	EFOw==
X-Gm-Gg: AR+sD12SvWZAG1to088C4i2uGlcd6d9K5ew0zBzen1Lf4pQftqjIKqFxZowoy6mfv7K
	bTZkMZHTBWyxnYazm1LPrIynF9VkbuTVBchLUfMABCpScQzFl59bwaF5Tuug2ODR9H0QFS4bspM
	ZmTjch1qLLuMHi8GXYR1mHLkQzOkHU43t6QXwLvfFbTD4CiTXPMsdXIPxp5tRYnA7QPxzj8XPP1
	1dNEkI0GrWzgf0QQaGdzr3XzoVR8BLZBonPRp3ZL9z0vAZec+9FxEfyIkO5kcmo5Vv9H69vpSvz
	Shz/HO8Yi0AZg0NA/5KGH0aIU4FQ4Fdo+wEm1noeHlDnjLkKF9t311uz4qSSJ0dyFWA9Ty4uTUA
	x+q91hYLnvwajlAF+BaJdrcOnIV4OAD2u6IHFKHH+GxXO8OTiUoyq
X-Received: by 2002:a17:90a:e7cb:b0:38e:6f90:eabd with SMTP id 98e67ed59e1d1-39580aa5106mr3748470a91.5.1787117585418;
        Tue, 18 Aug 2026 22:33:05 -0700 (PDT)
X-Received: by 2002:a17:90a:e7cb:b0:38e:6f90:eabd with SMTP id 98e67ed59e1d1-39580aa5106mr3748378a91.5.1787117584916;
        Tue, 18 Aug 2026 22:33:04 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f4c9918sm404261a91.0.2026.08.18.22.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 22:33:04 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v4 2/8] wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
Date: Wed, 19 Aug 2026 11:02:41 +0530
Message-Id: <20260819053247.1420393-3-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: CAyzbsizZZ6LtRfxlP4cl1N7Yhy4BiYY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX127taui88eS0
 2ncka9rhCviQZIIPaTHKxLQs0vdjQWbjQu4VlzWYR8yQazgx8vu2MCUQrpBw5IMH9gsefYXj9+h
 MPRmRv7F/vJvF8AwfahVk//wzm7qs15EDuuqHtQd2/tPulAhXq8EqEyPgx4PtRcvzgsEgfv5iUQ
 1z+VT+er4rRx89MA0RgTcJUMXKehR2Yy6DpevaSobx65ZpZPKqFRjd784J8E5ar8dbhmoC4xC3g
 CncTHx/lz9Axb5aB4WoiDL4lIx6sXdQ7MAKGU11NMALGWk/1kbBSqFCgU4bRWMFDIQ7GrbxT3Ms
 NQ55cNCsjdYiGZ24NKaJiCaTk5EuM6Gq20KYaZbXQ9nyAMi6pW10p893my13EydTfm0NmRwfPr/
 L2EktLzffpt6JlQEs4kz+ewBLmgH7v1lNOYEesM6QUS2XHBQJc/wL+mc703xWRUTrHt3sfZHk/C
 u5SRO9mfqgluTethUtA==
X-Authority-Analysis: v=2.4 cv=aMrAb79m c=1 sm=1 tr=0 ts=6a854012 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=RuwI03aZ9ZQFnXGR-2kA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: CAyzbsizZZ6LtRfxlP4cl1N7Yhy4BiYY
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAzOSBTYWx0ZWRfX2C4+atQ53XIC
 omrS3+7AZj5VqxzxtzH8IXsYBpnsRvYogK1Qgm5YTMZ9y09alJwcUQGhFIba5vND0Tuq3Vuc7Dg
 5yCaBgEvoKtAtnPT8McYP5iAyILMAGM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_01,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190039

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
index 3d635cac8f8c..a8afc1cb0712 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -575,19 +575,19 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
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
 
-	switch (wbm_status) {
+	switch (htt_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
-		ts.acked = (wbm_status == HAL_WBM_REL_HTT_TX_COMP_STATUS_OK);
+		ts.acked = true;
 		ts.ack_rssi = le32_get_bits(status_desc->info2,
 					    HTT_TX_WBM_COMP_INFO2_ACK_RSSI);
 
@@ -609,7 +609,7 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
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

