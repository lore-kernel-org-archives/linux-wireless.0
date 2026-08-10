Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353653F788F
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373099; cv=none; b=mdjUNvVhQ3ok0CHg87ceEommEqkhPS0MHadiCLKfoHlOK1fLp5qJ9nTNxzPGkbLAl0BFFRuP2lqxA1TS2eQm6VHvMOhHvUdabnLhTTbJPWxPvwOGrxmQxjFbGUIlp0J+ZH0OQ5Bdu0gydlnTH5wye5fVTLyryt6dYPqw4tsN+5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373099; c=relaxed/simple;
	bh=6cGc4L7NA7gSihp+HkmNS6nrBdm+mhKbXgOLFu/+JBk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r1JlnaLeEUAw4bXWk2e1YgJHcsWxsy9gki8cts9tI+BjF+ZyGCdi5SNOSUeht23vm2EGRG5e0yUMeFW1GEE27XtM/RFK/xeh4335242TcNj563kPpoJ36TeC199URKkyK6EFagTvfl2JNfiOVMTK2issEAAaLCAgA7hmbO9DJDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ae9yOzJc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V2HP8Hnt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ae9yOzJc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V2HP8Hnt"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACiv7M914555
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ljCy5O5Q13z
	J0R0deOdY6rUGXlXk5toVBCxTqHElnkE=; b=ae9yOzJcBn5YASfu5dXsTCBiLm5
	hGDOJW4ObionaZQx/vzSKunv+6d4QzCGWYkGJNbZS661ft8+EjOfO8eQKc4BZPHM
	W73CYDHBr7DZaJIED/EG9ZGNCy/Krnc6YTvgmaIsEEKVQVYxOxBk5SrcD49n3fnS
	GLCmWfZpXe/WzeDohARWCZRzGJIeEQL12dVGuxsxRGVEtI8tf+wEHkqNXUDybRmz
	LpnR9DazuXZs507Hhh47LCabK7WOCr0BuarlC9t/PzNnzSYd2UkOM4FlTIFJ2Phe
	ujgu6ewxukDHCKQwGGeXCsichUO9LqZaQNTjOsDrw8pAU0GYAzK4mmWmPlw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy8v920a5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:57 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so2351449a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 07:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786373097; x=1786977897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ljCy5O5Q13zJ0R0deOdY6rUGXlXk5toVBCxTqHElnkE=;
        b=V2HP8HntHM28OoNvZpu2qUv5ffOsXWAimluUxCttNiOHTClSnIjIZ7pa8bNm/pRnz7
         5CLA9T/Nrurmbt4CQ/RABVfLzQLHqNwXQp+t6WyT4cljNVBc6dRNaGguNIiHHAPV7n70
         FRyFW79EdYzOuaT4NLWUoxXO4EewV/ZVVxCP4egcIbHzxo/N75ncqkvuZ+z8zOoISgOp
         64eF07yG91CmbrWD5q6PI8LM6WMkbXgSv72t7CkxG0WDVDFkKtx7/GLuaHwI18TEiS+s
         tk0MskJQZMP5m7MIHkz8/115b5HRpiaEL08lhv1wxTEJ81oy1YQ0IEeYs2xoAjab/BIK
         j0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786373097; x=1786977897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ljCy5O5Q13zJ0R0deOdY6rUGXlXk5toVBCxTqHElnkE=;
        b=AbVIUOaVuNo6gvvB2gBa7ONj2GiSHC6+1vEfnHYM++DENju+alTWp/CbwuPWXylFdp
         YoSSdo3XGy0XlxOLElEshNQrz2weLuHBhtrYxlS3y4VTFZSkZMfS9g3mcc0xSBjuyz1P
         MRf6Qp3bZc7H8EbdLmOeKbSaVarQgo+eNFcYRCBu8urKRdjSdeolgo7m4TEo4XGs5aV4
         AjR8Vah5WDzNbFwd/L3xtNFFeqSIgTNlbO8uEE48sG6nsJ6cyQMnckf19kmDLAJjmdEf
         YDU3VMVPgRB2KS+hbkPa4tUucuOeqkEFKPRHMY00YZkERf73mRov4UxmNBZg7TwEwv84
         GIxA==
X-Gm-Message-State: AOJu0Ywmy/tvEtbwdsN/cNnx6JX8Iq3r6EXOrVX1wncitei7ubEYvT1K
	f2o9+5GLS6xabUxZ/5ZLR9ihzMhn+3TRo3lmO5N13gyFTjFjGTdpQDu5L//zoq/pSM1aTkEbwya
	ROuW9x5XA6xy+B0TqbbWJCgjk6v4N3SIBel2AugsvbORNjNNHnQdk5ZHtJA6N6wqmx8+tiA==
X-Gm-Gg: AR+sD10KQqbUFL5bHk2ttA5f5umeZa4521AF8NcY4ukTkdyN0jDax+mL30keRPmZWYj
	8lxSpql3mRDtCdkp7Kx8stZLwY2guaoqEzeco1wvi4KeYV4hEji6HmX9TlV8ZtkbzcTl8GzSexV
	ESemaRSXApE/OXvJDAWQnFlV2mDloHYsDpHeEUCNOQV4FkQibnpprcoYrPtZYVL9r8rQgfHLISJ
	cjtkxuoPf7mEHN/W/XWUNF7+AqzAi0W4ytgeFhU+iof7bqc0RRAo1RL3MlNfrG2ryc8YBH9rsN+
	TWhvN+s/aNL+UAchDJ6nca7Ne2fXn0JvqhUUYHanP6brhkvyzAGya8MIWKToJtm/tCBxyToxD0P
	kWvuBk1QDiIrP8H5msHPQiPHoZggRIifkgYrvBGibgayb7lKnbu/J
X-Received: by 2002:a17:90b:4ace:b0:375:2a38:1d40 with SMTP id 98e67ed59e1d1-3928246545amr19902502a91.20.1786373096234;
        Mon, 10 Aug 2026 07:44:56 -0700 (PDT)
X-Received: by 2002:a17:90b:4ace:b0:375:2a38:1d40 with SMTP id 98e67ed59e1d1-3928246545amr19902434a91.20.1786373095725;
        Mon, 10 Aug 2026 07:44:55 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm12797317a91.2.2026.08.10.07.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:44:55 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v3 2/8] wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
Date: Mon, 10 Aug 2026 20:14:38 +0530
Message-Id: <20260810144444.2033607-3-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
References: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX4PCFD/fmAX2E
 ok84QTpyT7N1t+wl3kkGx1sekHH7wFSI5Bj4OMWDeDLiI+RaFycaj/6WLO+AhQ3Ei8f8dWKdmWv
 YeMQFOPS25i+NtpwRrfAyhkxgpG78pY=
X-Proofpoint-ORIG-GUID: 4xnX0_ZfgTZJCVrDsMJH1mFJeRwt8qk5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX90Hpa3wacWCZ
 F1lST/wBZu8old32vxGzt2rBYQeoIGoOZvtyeVOjB8vVPZKCoqZPdxXYmYSGJwdGIYjS63J0OVu
 bKoBCboKKIqChbVdOFBm2PxU7sgGaDAHA4F/d6Y2MsgL1TfZVPeYC+hv5bCRP/elSrGtxfuuvV3
 /QegGajn8Yq8nrhGgHjRLs4mCe3sYl/uYgZpX7z30ov7YNU6Arpb4Tojq+DGoKRqINAlVTHhNpc
 76YQl0O6zm26LOWAV2rNZ9QznFL7Xg8danQ4rNRqKPo+RF+eAzDZVpiCn+e0iuA38G8YGJ4B+01
 iRyY4h3Itczi4E7uOfuUwGGzzdb+FmOlhOGgelJFiyFJSSOVh+THMjpf72ADCGy7miLYN5h2Pqz
 sSydNSw9JRbdc7shYIlTy3wISFtz2L63UT16DIXuDBzTraBobdJa876CWjoBXI8dAOZAoBIZ7GL
 zy3tzNIgDfSERicXdug==
X-Authority-Analysis: v=2.4 cv=T5m8ifKQ c=1 sm=1 tr=0 ts=6a79e3e9 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=RuwI03aZ9ZQFnXGR-2kA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: 4xnX0_ZfgTZJCVrDsMJH1mFJeRwt8qk5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100126

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

