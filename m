Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE81F81AA8
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785287733; cv=none; b=uBLw6Y4QaJI4gSqNojGPTw1rbAUiOHYwT9Tjdzu1WhQLSGExSd8XMaDfXQu5fQCY+4ZfVCOePgci4HnvCqUvu6W+fJrT8b/f82u6N1C3Ec6JoxELyNAR5hVz8mNGxztEwAGv9g/Hcf8mnEf4AU3tRj2QHpHs4ZYUNT0PZw9eiVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785287733; c=relaxed/simple;
	bh=YG8M7fqFC51CXT8kkS5mrYzynUgxnYZgztNYuFtjsqI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=W0Ivd7VG6tXRjEN944J7KXDRZSd8Y5wdf9uAXzO3aepGxopRZp+Mf9aZRXQZ310ueFWwK5hGGZqMlp++uBbxC6q6GpmchXJtAXhm4XpX53JlipEfOG1O3P0bGClmOhMEZ0TBIpfTAmk1gKj36EJ6yPHFi+Odm5qeiLu4zIG5l7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JO6vB+Ps; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i18xQy+V; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JO6vB+Ps";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i18xQy+V"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SL2raM4087381
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:15:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=b8lvaeEa9L03FoFsbXkFBN
	Dcr8fgF0GHUf3602Z1cqM=; b=JO6vB+Psdn4duW8LBcL6KrJi/oebf9PZ8a4mVP
	qKnt+6xllsa7Vp/IHqJoTr9MXTRi4aYh+R/qqVFVw9nAOmjJgWUxV0xn6lLu0Rjk
	V19L+5aLUlF7JIOrOn7EPWhJseFUCYFT2UvDXrNKtlCaqYtMv0SSnarg096WrkpF
	6imXzU2ZdfiMxdsrPyefwOlZzTAcHJpBoDjDdeViawNlGLQkpUAbivvZCLB02mZd
	rq3vfIYCpJ7V3bpx5FxLPzInxohFa8jeMsF3A/4x+PhQHRnn+FM6Rv26Q14kJNYK
	BmGsvG9DefTuq/NL8Dg2C50Y0iyNZ2KukB1VqsMreg1NJyyA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpvtvb548-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:15:30 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca8aee88725so505598a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785287730; x=1785892530; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=b8lvaeEa9L03FoFsbXkFBNDcr8fgF0GHUf3602Z1cqM=;
        b=i18xQy+VmvYvSGBXx0ZE+hXl7QcCH4jh6n828pRRxHGGOWfAGLpnDT4ZPIxxzqDIio
         7xwID3wMfbMZukXL9PsBmXyJCi4UC33/83sMEB6aKN+uhKlvni2hj5oogxQlE/ZIH1Kr
         nR2vEQTaQ33DS2pEfj2LtcUqrWqLjNZVLjyCLx6X07BF0UiUiFkI0lG+KsN6Y+ifreLw
         xlu94JJq0Bf3/2qhWEUhfCJVRpeUft7C6VN2KIMlwN85Hdte9N3zas5PhvdHuL8PqmnP
         aIc8Cg6qAlx4ymVahA6+XjaosESt7DD3vLc6IhVL8UuQdWEmBgdSB6eCOda83itjFUkb
         fy/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785287730; x=1785892530;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=b8lvaeEa9L03FoFsbXkFBNDcr8fgF0GHUf3602Z1cqM=;
        b=e0adfXP0lXxHUYD8qYFm2uYj2PEMTDZFqgukOcNBzDLA1s13lXetkfu+Kq/rIbrEBr
         BYLAa0h9c0Qsknva0sWaN5HuFjdJPVqmp661oKGkNJwwOZsXv+WHsn7NLbfKttrWCctf
         co+Hsflx6yS4zTy8YM8Px2MDoxwhH5eDxByLimMfXVek0W5gpvZWoXbmK7sy2Hy43H1Z
         3fCASZ9Lq1Z4C72F3YkEMpjEct04uaWX8iPPYE77CjVXZ/MjSDpn/6UC4GhlFaYeWaqI
         pNHLlIvZYhOGva76PivfDXthHJFa+CBGWAnkUDsRtNc7RcONJY0UUgiaWgc088SijHMT
         iRQw==
X-Gm-Message-State: AOJu0YxhCpYDvflXw8ThhF5NwvMbcSv8L2RwZTwoDzQI1n4p+A+nm/5u
	Yp3RV4SqWhZrrVfN28oqTrOAgmLWU8L63JGegs71tWEeqVbflkfZk0MoJCpoHrOiGJ7cmDXRTzY
	KPKfQkgDWrCm7bDc9kn1fAzHpdLuLuYwlTG4pbm4ioxz8F+zorQ5eoHXg6RYDtBTyEcwPCg==
X-Gm-Gg: AR+sD12cpjUhdgpwy0q4DSJ9INIM1zLB43217mlv+kYc63vaWdvYc1l+AMYzRGC88kV
	ypC1eAbxpavAOFfD02G9vCyu+QVH7Viq+RYbYhogUZ5EwtVF3MOQ8aRXhVu2mGPgDpeAUlDS0r2
	gxWJPu0c6piHyrLcQvZ3zKvsgA8EUdquE3X/gX2APwRqOBN++mj62Z/LNxmiykW6F9M1WG/K6lv
	N8+OjTLV+ZyooSTrqZZM8sPKWeP0mMH5wQGfLPl/FI/Y0jDkFt9MxhNcM4WI2Ub0uLERelFu1jO
	ApLL0Clvc7MrDEWWTvY1jeTWFqN2WeWV/sIjYJ+n/Y4dAgPsAry089bST1SIyZqzIYRnhj8CMit
	yign5aTcg+fiypUX0IRPK4rQIBEQ78N5OmYUfylryfquKGcX1Wuha4ik=
X-Received: by 2002:a17:90b:4c4f:b0:381:5ab5:b667 with SMTP id 98e67ed59e1d1-38f6a4972bcmr4855289a91.31.1785287729571;
        Tue, 28 Jul 2026 18:15:29 -0700 (PDT)
X-Received: by 2002:a17:90b:4c4f:b0:381:5ab5:b667 with SMTP id 98e67ed59e1d1-38f6a4972bcmr4855264a91.31.1785287729078;
        Tue, 28 Jul 2026 18:15:29 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7f2b9e35sm565432a91.14.2026.07.28.18.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 18:15:28 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 18:15:24 -0700
Subject: [PATCH ath-next] wifi: ath12k: remove skb->data check in
 ath12k_wmi_process_tpc_stats()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-ath12k_wmi_process_tpc_stats-skb-check-v1-1-01b7d09be20d@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIACtUaWoC/5WOXQqDMBCEryL73Iib4l+feo8iIaZrDVZjs6m1i
 Hdv8AZ9GRg+mG82YPKWGC7JBp4Wy9ZNseApAdPr6UHC3mMHmckiK2UhdOhRDuozWjV7Z4hZhdk
 oDjqw4KEVpicziDw/Z1Vd6xbrEuLY7Kmz6yG6QdwQE60Bmkh6y8H57/FgwYP/K1tQoNDYoaSCd
 FXi1TGnr7d+GjeOaQxo9n3/AZCWiwztAAAA
X-Change-ID: 20260726-ath12k_wmi_process_tpc_stats-skb-check-5530899ab197
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: 2fnVAr1MZLccy1x2Dm4eWVub9TFfRV6y
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAwNyBTYWx0ZWRfX9NHwyV/6Phtf
 Ofo7z8O6+ooSwHP9c63G/+Nx2G0lvh//3hBZRtvliWv97DKvQKrdUB/okWDT1/aNAnz0kJ1LEBS
 PS2rXAXFcO7i8MHRToAR0Z6kuW7tXLo=
X-Proofpoint-ORIG-GUID: 2fnVAr1MZLccy1x2Dm4eWVub9TFfRV6y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAwNyBTYWx0ZWRfX1a0GCTAPp+Xn
 PanTxX3y7xxznNrutyQvkPC5SQUrSQ0ZLfljMvDF+9GI0Ti/TSZnzqdvKnoDyxgTNSPr5rfS426
 VJ0r6CaAs14duB5Xk3A+eEuGdt/59npSQgNh3ggBw9r3dJGd2ltV7zIRdcei5hyI4SQ8e44uadR
 okP3ijwZpofVjDTNw2Gpjal3n+PfDCLgxRN1rr2jWzucYb+iXYC1WvLAORo9mYcA4K23reAuPHh
 WAE8IPSeOpPDXHDwxhTr5uNrphNTn6KUWWuuF9ni+DHsM3XgmMRZ/pHDGpsGzQZ4kiGQTp9DDqc
 e6bcByT6+vrpNqep4gJXeZoB5h/IwWJZrJxF/iQIZHuuBm/4IM6velZ4aDFzyr+3BO8q38cSYFP
 u1UeWgK4kWfcCRHdCGBbLXSkph1ymULBSPS4PQu1VeUIEX8xXlprv9f85d571Pa2ZrSMvvQufzP
 mQwAaPJH1a54dG/7OeQ==
X-Authority-Analysis: v=2.4 cv=dOiWXuZb c=1 sm=1 tr=0 ts=6a695432 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=J9Q00Dv4GsgNDm0QbNcA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_06,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290007

Currently, ath12k_wmi_process_tpc_stats() has a !skb->data check.  This
check is pointless since skb->data is accessed by ath12k_wmi_op_rx() in
order to dispatch the message to this function, therefore it is always
non-NULL.

Remove the pointless check and its associated warning message.

Compile tested only.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 2b707ffc1a20..cd3040b8388c 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -9973,11 +9973,6 @@ static void ath12k_wmi_process_tpc_stats(struct ath12k_base *ab,
 	u32 event_count;
 	int ret;
 
-	if (!skb->data) {
-		ath12k_warn(ab, "No data present in tpc stats event\n");
-		return;
-	}
-
 	if (skb->len < (sizeof(*fixed_param) + TLV_HDR_SIZE)) {
 		ath12k_warn(ab, "TPC stats event size invalid\n");
 		return;

---
base-commit: 32f39e331f889a0424f7a0a82893f628e2705727
change-id: 20260726-ath12k_wmi_process_tpc_stats-skb-check-5530899ab197

