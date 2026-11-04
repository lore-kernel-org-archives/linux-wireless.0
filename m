Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793769524;
	b=noVwYrtH5F5U7vronXfKOmU9ygzRqcdAi2ito4euYdwoJoIyoo0iTzWEpbzCDwYI3ODw
	 9FsSZHO8KPuEjMkgxT7whEc+jcuV0rpt2HwR9+mfA1TNCrJes8Igai9wckqxZizesf8xZ
	 WAS/gieJPyt/adoC78sjYncRWzJsEFKmnRHUOgErfE5SzvwXQCzcGrA22MI0wxHVIH4PA
	 Hn+ftpTvZT8aRebVflE2MyRqP81x652KrmYZoW7TZmRrYNEdLuXbSJJjELDeFwbK0OasF
	 Jh2FjdARzNXEwjx0mXFXPURhOquJX8jWrq3Rs5oEOYBj2FWXUaP8Vet3ro9wxMFUBiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793769524;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=0nQY2P9RTAtBJlrcwnAVDlNOCpLlXDIIS1OzEwCWkgU=;
	b=ix7UGFZCuk9PR8I0FbrQrpR9twkq+WbXWT+3Bo2QxsmfGNLbTOW/ZjwC/hQ538cqHPdv
	 Ce41mPaRnLnR9wcJ4r96SM6pfq2EFzlzAeQhx2rNhNtxtPBzVqCWDaCI+wlAZxMpyjijD
	 5pd/JVHyuym3QuwKIHDAOqaUnBBkH6WUNIqbN4iu035E66qdvP3q81eeRjBdFOT/sZAem
	 hZiwBBtjvx2VfnIvlMYUlfwKsXoMFrI0g+oVr/InDRU7vIdr01skjREkyvruZmMYx2EOJ
	 v8cy2ebZrYIoE1bf4r/9RKYz/CDiyfyMXtw6/MaxUJzJQtSFnZwLCGnNfdICbdI1Ueg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kthFtGq7;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=e1BHEiVo;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC7F606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 05:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DC7F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kthFtGq7;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=e1BHEiVo
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RCuO838262
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 05:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=0nQY2P9RTAtBJlrcwnAVDlNOCpLlXDIIS1O
	zEwCWkgU=; b=kthFtGq7PVeynKAu00mftuwBtzX5H8t2MQTBXmDOB/Cm9116Fyz
	YKE4VBrQbdvKr0q94yvnOYo6aVTwBc9rJShCDQN9rL1IWRttyrKa+HtaaITwAC3K
	LbsTeVrTlS+1Pd4saul3cTJQkxpJwgplBzIJEt17J3VecRqqb2qMjh1c+YuPZhrP
	Xe3sOSeHqdBOHbRh76mOYQiW5KkCmMa4EWrELOgHjJ66SBwlCBvekH95uA/tb2VX
	STZi+RA7KtkHdSxhCelV7M+hVMZACbN6pYlS2oO0v9krBNWJ/yPvxRJb8sr64kWA
	COr+BFZOMywkog0EKBN/h0RStBhI9l9gXEw==
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8mt45b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 05:18:42 +0000 (GMT)
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-85d630e451aso459576a34.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 21:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793769522; x=1794374322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0nQY2P9RTAtBJlrcwnAVDlNOCpLlXDIIS1OzEwCWkgU=;
        b=e1BHEiVokmj6NnEP2ON3+mo4zC6sy1iVmsIEtO90HraGiGS+1uul/KxJaI5aoe1oPx
         Y5AO9M9l2YVdxoX65plzLd8dITBeMdiCLtjAibiL3lGJ7KTw7EuCtxBz4eBeuAfUWd78
         F6c+v0StdQk71lSHh9incT1RMnQaFREW/IIviB0pCjvce4N7idqj8NJVOHvSunb6Pi5A
         lk0j9n+6Mzoa3VBKFLN6WJe6BCgW9xZZ2n8s9IcfNNX0cZ5bZAryhuuXt6BtnAqyzwnV
         RgiUKFlg/A9sd4dhJnZsZPRYRp2YXiVBiLj+2DOGpLmrd6KTVWOIRiHk+D1HdW+hQraR
         m3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793769522; x=1794374322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0nQY2P9RTAtBJlrcwnAVDlNOCpLlXDIIS1OzEwCWkgU=;
        b=umZlsEDeElD7iWAz7tTN2R2MGZqDMWM2Hw0I4aP2wknpZhVs/mS56RDC2QH93x+TA1
         nL3Cmgy5UKQlN7Ms1Radb/0rtiu3K0QRF/TB53E1jpabSdTBL96UQoTb2xspGqGSFg9j
         q0ii0CXtATk2vh16Rewpu9QuClqxiaFNP1V63W8J8ea5Lrz+A/1ozq3YXnm95gge1Qrj
         u66E7HLRPjj0WK90USwXB/drtS1x621OMwC13uT/Gx1PIvYSzjNYMTnYlg02I1zxnlcx
         6dYz2zjF+wfxVwn8JoQ0HTY6spBfD07LW4sARC19bMqIVoSAN7gp3d2kYsua0Jg2RpSF
         4UYg==
X-Gm-Message-State: APuU4Z8L2BB7riDoj+ks4rL/UHVYR6EP3m18yeNHYmzg7DU+qYw59XG6
	2BfcCspaitTkhHKoVjFPPCip+S9NVPbi0Y2dI3eg3Zkb0wxZHyid6PVWYQ/VYqWz38ub+vyZpCf
	VlgpPQj096uUvfeBFhzLEY4LmEevshxXEUNi3iqKn4REbQg6Rtx+ogftSHCdR3ymYVyCWL4VBmf
	QS6QDI
X-Gm-Gg: AYBFou0zqtJCuR2gNWE+LHfVVKYkxiQX8LzbpLDULSYCOKFRMB+h5pSC2rGIM2a+9i8
	73ByAZgm0oLn7T8DN0WAFQWNiF7JeLmiC1ok21fVaC230QrtBoXQcmUfoygo6bRjMuP1fuF5PRN
	AF7L6guTp2dhelRc+4GOdxww4J4Yq+qiAPmGXboZqmTXS7Zwc790DYUpIt0Lp6A2rQLIgTIbCcn
	bHy2G4OYG5Z4OrzfxL9Nm1TF0i1oAfUKm+KiPBJ5qf7t/lA5f49Ykt6Qixz0bBxOYFe1a4vXIrl
	FnR6F60kvExdSpSXtPsuiD+nGPKAbbgFNDmsVzwt02sJfJROY5i4Zof2JnYhzwS2HoiJuYMn6Xm
	dJvWpIptjPHEo2MNR869Ik9dil5w8tgbqQj3UkoPlwhU8xA1sTNhlkrrva2FUEbvMpovr83b+/2
	T8HgFILbG/VXoCgJWM9iQA7IzNj1EIr9tTMjPK
X-Received: by 2002:a05:6830:4392:b0:81f:da91:c984 with SMTP id 46e09a7af769-85d364470d8mr12320477a34.11.1793769521709;
        Tue, 03 Nov 2026 21:18:41 -0800 (PST)
X-Received: by 2002:a05:6830:4392:b0:81f:da91:c984 with SMTP id 46e09a7af769-85d364470d8mr12320469a34.11.1793769521305;
        Tue, 03 Nov 2026 21:18:41 -0800 (PST)
Received: from hu-ggarmidi-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85ef3e1f2f0sm1097317a34.17.2026.11.03.21.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 21:18:41 -0800 (PST)
From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, sibi.sankar@oss.qualcomm.com,
        Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Subject: [PATCH v2] wifi: ath12k: skip hardware rfkill setup on Surface Laptop 8th Edition
Date: Tue,  3 Nov 2026 21:18:38 -0800
Message-Id: <20261104051838.2912931-1-gopikrishna.garmidi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: b8wD4Zg6SMznCkAuTwSajS1Q_oHDLknb
X-Proofpoint-ORIG-GUID: b8wD4Zg6SMznCkAuTwSajS1Q_oHDLknb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMCBTYWx0ZWRfX6id8oL0MAT51
 ZgRcNRAA7gvv3EKlMoZDmDqhHEuyC4EpxA1mlDujyiVjGHpMa1dMS4P6lXJrLFnJapxwtOpr7Uh
 VgesGSsHXmQr/LpVrqucYHjjVIQW32foaRvNXq7CO2Rbl9SOr12BSYENDk1e8FOuDXG3XOXz6+R
 pGjeQQ0UrOQlS+0iI7P7hHHPpflNHR34DiJnpkiGVTtNBR4GfrzlTvXde1XXaLXRT2S5SHBkoK1
 gXykdZxtokwi4k8NUZ9Cec1E8Sq5npCJi5tqhKGvpEgN27UX1MSp1qb6atY1T8I+X12z8PEgNFh
 qENu7529QUSa3MxaeDbsp/quNaIG3HpkD/qTIW9oCouiG1vTIGq2PhSImSyLjqjvIefwDJAaGS4
 lhhM7ehjrRthI+avcHmMbfekuduUgGIulRQYpCX1AbtRAa92RmflQakIzQ6cP1jfdYeTHLJFUyZ
 T3n9VcOmO0H2+S0ormw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMCBTYWx0ZWRfX3H9pysKM1Dki
 3UhND9v5o1v2ryESjFzdLGLB7lVgQksNKksv08QYxUgfXmg3Pc4kL2uT3CDaXY88b26qvCxActz
 b7mKxTwYmX15Rqtc+ubJ3rMRJRrPcpE=
X-Authority-Analysis: v=2.4 cv=HbWB3SE8 c=1 sm=1 tr=0 ts=6aeac032 cx=c_pps
 a=z9lCQkyTxNhZyzAvolXo/A==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=VKJZL0GhgKsj1iBI1lIA:9 a=EyFUmsFV_t8cxB2kMr4A:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040020

The Surface Laptop 8th Edition (13.8") has the same broken WCN7850
rfkill input as the Surface Laptop 7, so Wi-Fi stays hard blocked.
Add it to the broken rfkill table.

Tested on a Surface Laptop 8th Edition (13.8").

Assisted-by: LLM
Signed-off-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
---
Changes in v2:
- Fix missing comma after the new table entry (reported by kernel test robot)
- Link to v1: https://lore.kernel.org/r/20261103094024.1764151-1-gopikrishna.garmidi%40oss.qualcomm.com

 drivers/net/wireless/ath/ath12k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 25987bc58556..c0e7503c71de 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -87,6 +87,7 @@ static const struct ath12k_core_broken_rfkill_table {
 	{ ATH12K_HW_WCN7850_HW20, "microsoft,denali" },
 	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus13" },
 	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus15" },
+	{ ATH12K_HW_WCN7850_HW20, "microsoft,surface-laptop-8-13p8" },
 	{ /* Sentinel */ }
 };
 
-- 
2.34.1

