Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5212BEFF6
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 05:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792129776; cv=none; b=UzaobzoJnd8T19CzguKwJ81XqAEkVyGbgdsr7TjIYIW2W0bX6R34x8H+/kbMzjOk3exRSzAaQNgVYd9dJ9ghvKm8BgPnauFk4gHOfr0IWJlzHL6X/BzMkDZcBjwF+N3cClwXymMwxagEsbD4z0XfFDSl3l3nhYso8l8FPwNc3ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792129776; c=relaxed/simple;
	bh=I9d8xWEo5OHZJlpC7CvboIe1aUH6zlpyma8avvawm+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=P1glZBpxLm2yC6drc/gsvVjlMALySTXsUxwuLRTyMvu0TOpCJgtUE6W8jbnxQetATwW+G6Cn/oJCHETdg5bdD5iDYYVlgxFmVaINMEzUZm1/bCrNA8Pj7iLgfq5LrN4gfmW1LaXCRSbyjsDYnLZ73Np8nVwkSpqekVbr6VpAgA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M+eMjzYY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KMZQeG6r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M+eMjzYY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KMZQeG6r"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G4JdVQ3800047
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 05:49:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=nTODudGNTz3m10Dxqs1k0c
	fH0C+ngep5olRntbkeung=; b=M+eMjzYY27prAdwHEegNeC/Xky13K+CVK4ietW
	D7IGMLZTd7u4Mxjj01tIlci1zFwFeryEqL2EMkFn7YfnZ8X/9BIleCWviLYMVGMr
	lPxrN3tPT4RErY1hL5sqIUzL7DLXmfBaipy/zwKU47d0Ax/SHvHJaVYKZroEaafp
	LInrruy4zpMHFNh42dRwx1Y9BxTALaqalI6J4V91XBh7c2jWxJY5VDXU50kVvafy
	kMilwKe9UjxZ72Fm8eszO9YBeNIfQOIOvX2QJoSZIL5GCmFeGPvgrKSINsuijXLV
	oCsN+tAaKof9Pvgt2RtRpDlUOaoC1YLJ7UVuo/8R9lz9osaQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb5se9qx5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 05:49:34 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35fb6be0f9fso2851762eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 22:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792129773; x=1792734573; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nTODudGNTz3m10Dxqs1k0cfH0C+ngep5olRntbkeung=;
        b=KMZQeG6raQVCgcKkgOUMHuaQlIiXvAM7TOpXzXOyvMlcRfA5W78+v1yX0yhZYLiKBo
         W8QUFTBi4nffw6y43b8zO0GD+OGVmf2yBjgEC/GEdKhGP8sEaU1tyi398mINBdyGAqUB
         ek84RMRNR8gZzH2ZRM72cqGuMrbIRRkkIrUDDktccvN7pNrEs9izo/LQWvVJrLcZZu5C
         oaUiIF0oNOdvh/tikfGT8GsRO7mD85yYgTH7yo9gk/5LFRgHF69HWu0GDceWU4XspvPF
         c0e6mjyesg1QkUb282pMLXwHTl551I0gEWuWKkjsiiXMDob/KEUlW6SBpBL9b3F89y9s
         /w+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792129773; x=1792734573;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nTODudGNTz3m10Dxqs1k0cfH0C+ngep5olRntbkeung=;
        b=zuaioRPuiDoahi22wLcKALA4XHWyyW3sVea3rjSN29RuwFEAFIktIEf8/yM2PQ0ghK
         P6I2ajIbuRByjX+oZr0SeZ8rB9z+hyph+krroRhxDuyDD4CbawJoBh7bFQN6oOgWspIu
         MLVSuDKIWLlLI+vPIFq5KFytjJkKeyD1KE/P4ktEBCNxjck4iSkyKdY05xMllHlAj8Fp
         B8hm6K46kZVYeoYV8hgGh+Mr6fV6OAmsOM6z9tyJfSzWQZJ5o0GYNGQK/Oiss+CDyrBI
         RG8Qni8JKp41g3KZ0fGtbN1P820lZBE3QDb/Tp9uQBl4KaKoxzQ0DcAGcjQGCbz8DAsw
         T27g==
X-Gm-Message-State: AFq9FYKDWrNSGal0BB82xLqo6PmjfH+n+4aY/q6x5f00TK11PN/1qWzQ
	TjHT49h0IO68JN4EfNSt2kfo8Vi/j/OsF561Y8TlrHYZ2mmZOjXOlCJK2OeIykZzcnjGWIeXHZa
	1x+hEiV/dWQ/674IT7m5IDQCMmVzq6DVKPPQjVsxdykbofimYQAMn6va+Q+qRSWPcbLyUbKt/qJ
	WOMg/r
X-Gm-Gg: AYBFou15FTO7S6UBifmsYtfK6i/GrEnJwupxXtot5N6wGCLpR43tI3wyNrUwQYzkq+I
	fUUlFmuVhErtyM/YojnEL6g93PB45lODG6ojPF3EloXWNmOfaEy5dbEIMS5Gh/HoFjy3lJQGg+b
	OMH1bL8SoMU6MfgdX/RSfKpcgYxPZZRn3vU2SLTrmIvwSutm0AP6lcpXypBR6g5jx737BOE7flX
	BJAkv44Bw855ANSAoUuqkE3bjEFYiovW6K869F9t8Bz38pMeD0m0I3mai9V1jay7uvl0a/8tw3f
	fIXonHv+wV9LcILD3b1B/M9HFD/CG40J2GNGKIw/M2Fj3QB4r8lphMzLWHZDcmmvdpwpu3qQVUs
	31saQG0u1CABpIM7BgpOFAA2yKyin+fL6A86X9mfifwqN1af6/w==
X-Received: by 2002:a05:7301:4546:b0:343:ff9f:26f3 with SMTP id 5a478bee46e88-3537e033fd4mr25913208eec.9.1792129773345;
        Thu, 15 Oct 2026 22:49:33 -0700 (PDT)
X-Received: by 2002:a05:7301:4546:b0:343:ff9f:26f3 with SMTP id 5a478bee46e88-3537e033fd4mr25913181eec.9.1792129772764;
        Thu, 15 Oct 2026 22:49:32 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36081ab80f9sm5154534eec.12.2026.10.15.22.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 22:49:32 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 22:49:11 -0700
Subject: [PATCH ath-next] wifi: ath12k: use hal_rx_mon_status for PPDU
 parse result
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-hal_rx_mon_status-v1-1-b32d5a7383fd@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIANa60WoC/yWM0QrCMAwAf2Xk2cJacGP7FZESZ7pmaCdNJoWxf
 7fq43Hc7SCUmQTGZodMbxZeUwV7amCKmGYyfK8MrnWdbe3ZRHz4XPxzTV4UdRPTk+1cCD0O6KB
 2r0yBy+95AdRoEhWF69/Idlto0u8SjuMDur0lBH8AAAA=
X-Change-ID: 20261015-hal_rx_mon_status-7e162ff7a9a2
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Kang Yang <kang.yang@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792129771; l=2102;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=I9d8xWEo5OHZJlpC7CvboIe1aUH6zlpyma8avvawm+M=;
 b=yeFdn6b26ATm8jKXV4WetkuB1U8Qf2yEDn8iGo/SCAWA4+pvJIFFG1xVHYEUuDQtQG2Atsxav
 51TdFA5P1FyBIFbMWzWNGueWMO2+KkR8WlUjxYYAWMvdXsYecy7vtET
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyMiBTYWx0ZWRfX3+idmt0iS9O9
 /8TDLClApxhyRHyDNj5dYPCnAHWAPsGPg1PnarmpX6bvychdwG/EyE+X7ZFHWYuhxZv7B/PDJRU
 W++4OZzy7Poth2uhaObBcggWoWEEP2Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyMiBTYWx0ZWRfX6XI/GIKcOaCb
 WAPIRA2CNJRiqpzV7EkcPNy7OYgJ9uKJb9/zDibJYgNMpWNzj6JhWUbO32jTojX/TzxJtYuy7pX
 ZonYE4FLSaj/sB/TqGbSEBSZr+jw//WqzRswRtYJxo1QFlNN0XMzc14rLTEuDnefgYC2Q/RBGF7
 FAUkwBM+r8kUCxrnoLKRx4xl9Xd/SUm9dFY7pJJeAEZZri+jAOQcAwmJ4C9s4XDs6ekjjPA+lxt
 n+Vbosemledl626PxOORIXpeQkmurZ1jFm0eS3YedXlJJHBTte66ZR6px2D9+L4jTdL02z4VuCG
 rB28yPSPi46zvIK4+HNKNftNNh1cspsw+q8tk+bSaMg0CBKH0T1+PrDMPAxM9vH6jKUdDDRQ3yl
 PMcKty7SUREX6exkxpILM/baAEp9TR3D36aWJ30iEJzjlJUG07WFdMGJ1PZMx9mC6qrdRaLX9Qn
 V49C+sqjbY6aWxx1QWg==
X-Authority-Analysis: v=2.4 cv=P4yvFSAu c=1 sm=1 tr=0 ts=6ad1baee cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=oYw4PtFvaC85l-aFUhcA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: BTRNY1I9di1OBJiW2j3RvV31w6TynNUq
X-Proofpoint-GUID: BTRNY1I9di1OBJiW2j3RvV31w6TynNUq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160022

ath12k_wifi7_dp_mon_parse_rx_dest() returns enum
hal_rx_mon_status, but one caller still checks the result against
HAL_TLV_STATUS_PPDU_DONE.

Use HAL_RX_MON_STATUS_PPDU_DONE instead. This is a cleanup only
since both values are identical.

Remove the now unused HAL_TLV_STATUS_* defines.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hal_rx.h | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 1e29c13ad66d..7d29b49e8a54 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -3214,7 +3214,7 @@ __ath12k_wifi7_dp_mon_process_ring(struct ath12k *ar, int mac_id,
 
 		hal_status = ath12k_wifi7_dp_mon_parse_rx_dest(&ar->dp, pmon, skb);
 
-		if (hal_status == HAL_TLV_STATUS_PPDU_DONE) {
+		if (hal_status == HAL_RX_MON_STATUS_PPDU_DONE) {
 			ppdu_info->ppdu_continuation = false;
 			if (ar->monitor_started &&
 			    pmon->mon_ppdu_status == DP_PPDU_STATUS_START) {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_rx.h b/drivers/net/wireless/ath/ath12k/wifi7/hal_rx.h
index dd60626b3240..3d7694c22774 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_rx.h
@@ -41,11 +41,6 @@ struct hal_rx_mon_status_tlv_hdr {
 	u8 value[];
 };
 
-#define HAL_TLV_STATUS_PPDU_NOT_DONE            0
-#define HAL_TLV_STATUS_PPDU_DONE                1
-#define HAL_TLV_STATUS_BUF_DONE                 2
-#define HAL_TLV_STATUS_PPDU_NON_STD_DONE        3
-
 enum hal_rx_mon_status {
 	HAL_RX_MON_STATUS_PPDU_NOT_DONE,
 	HAL_RX_MON_STATUS_PPDU_DONE,

---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261015-hal_rx_mon_status-7e162ff7a9a2

Best regards,
--  
Kang Yang <kang.yang@oss.qualcomm.com>

