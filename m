Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBDB3D3CF5
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122485; cv=none; b=MZEL5PbB7J4PO310Fw5XGSZy2pKX6BjzddNIlvWxFQ9sEVKFesWlLqs9pY5Jcga+q4ZUC528a9LTsZYYNf4xPuRJ8mFxkIrJmjptsVGu3UR0t7X376MPGVqtrvkkwhbRaqrDs5LEIGwR07o8EYLsoyoa5AcDM3xtEAM+qNDZGqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122485; c=relaxed/simple;
	bh=nMaH196+qv+C/RFhejARWcrf7/rtufqsE2+QCd63mTk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Uu3uE29drXVE4LAYfuzqlhqxrVmIoUyzX48lxLDS0QjZBGhabPcIY9jCNd0ESLQQMqgsdQtAf1trTMM5RWo4pouno3sFisNMUr9N6q5Far7Yunv636Ic9uiKbxfNYIMs2IhAdMW4EQEYit7D6I46c455H5eEtVITuYvk9iAbWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Tk5VPhlJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T6vA5iAN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Tk5VPhlJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T6vA5iAN"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6ZE0Z3171950
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=WTMQHAvus3eQqbOqBL9T+Z7tOwb5b+iMEY6
	repzLcMY=; b=Tk5VPhlJ156DFonkvdJDqsjyyxgKDxppJrFIgTVMeiidllrOOUU
	VJzSsIaXe+TgmVF7BwpQSlKgA5IeMOFVipa42OQlG48FEt22o05iYSrKkQJfsdz0
	wqu0fEgJaivgg5G/8/f/1Xddyy6a3YkRz0vidfRaSmSznRJPHDfPWWXzr68IFa7o
	S2GTURlsncZB/arHSp8N1utn8a/vzmhaPAEXnyQ8vDxG+H4pEeYu1DVnQAHie7Io
	nlFJEVjDCvjzGGK66kS43N+pB5ZDuUrlYr+5Y/KpISPUY6mBD/vyxsvA8CMbAdMk
	2L8/93I8BJ+MYrsE0PnpXowIZt2j5jQuvUw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfkhtmu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:43 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38fa7b09921so1311705a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 23:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787122483; x=1787727283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WTMQHAvus3eQqbOqBL9T+Z7tOwb5b+iMEY6repzLcMY=;
        b=T6vA5iANnnfUBAxLan8tKaXf0BILcymK/oEXLz2arZVgpDe06+ggZzIsRjtpsmWotq
         LTbcCGA/spMnAmH0wQoFZuGnvPwhqqSQsoCEaI6BmHvGVi/CSevPDnX+3a/1LGFBk2oY
         kbxvACfwRWZDwfnKLwH+k5zC76sE487TgV5uCVTFAXDaUHAO/1NRLJEc8LQMderJiFGB
         t23yGECN79TUN6XeXq0+AE3tdmlEs8d86OCkPdwN8Vj0sOdjLnLdaO9RMxPLEBNusLqs
         b1m6ldxrSOzN026CSyYDzgW2vtBZXoy7jYSEcnflmu1KIIn30wNxTim9Dbf+ac536J6j
         0LKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122483; x=1787727283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WTMQHAvus3eQqbOqBL9T+Z7tOwb5b+iMEY6repzLcMY=;
        b=dcGzfVmBmqlQKjMi67TbpFwmTv6hEFQHDrKWWONzLTUYKkiWZYI6W5g+Wn+PyKvIub
         xqp52OgvMibgp63EdO6ZEUytjzFDpkLtAuH1pF76SOQB77z3+/wP3Jj+I3HZdjk3US3s
         2+4cATwxqQ2mUXixkjjVYJODmEsFccxh5FF1yNUAqiUxJoLHXBbyHQyb/e8xm1x0pFp8
         HichNqghVZslWkfPqklgNzpYXB4ly7RC3N88fYga04b//ulVzumhSuBVDLg3BW/xWmnz
         XGHMZc4An4LNRcsjIGCu9Db6uG8mHTU7Eei91vvxK/GJ81iC5dUmn9ImZXtkuLM+oqTj
         MZHQ==
X-Gm-Message-State: AOJu0Yz65Mb0c2ftUSb1OUe03Hi8UbxaliF5Q80vQe/BJgSVRB/hlhXO
	cguUwSEnYKw7kea793JRijYb1xtX2NzGiCkr3aQbDsWK4takKmDFx6ofeYXk1eAjt11s7ns/g3d
	mRo267ZCJLub31B3tE28jjr4yCCdUD0vq4RV9UyB4/lR4kDLlrRhUBvAUz82wCHfKPMuTH5hie+
	9lrg==
X-Gm-Gg: AR+sD10fza8vEg17G4H+nchJqzL7TDeOj/qqibs1wdpdBct618E1tw0e/ymaKTcn+AR
	vGzKMevgncRFh82lk9gFGuGJTqungAirwG6PMSjDnNKdVCbeU0Q9dy2uMLjnol9ZzupUgiSoxvc
	1ozc7lJ36nOH9oxBhNiNPTuC/LT9DNskLJ1tCo/CQACqncdr7qI4pH6bZu1TSLBgGx+vD98/Oip
	DpCIGaBDzIHvzpj02Ghjn/twNZevLnytgW4l4ZFFJhl4IcQZiVDogdDxCBbrJgIi7pWr/lQ+/Vm
	eTpXatvZg03aH0QUxacJ2Tp7vdknHjQ+KKN23aCzXVOssUilLKzlExHAvJdJ2oDXHI7Xk0ZNPBy
	Fw2npNqkWgYUoD9TV9x3Iv4xuBt46VaWjK1PeAW60e53PvaguCVOfcv1OLDjpvCYsLrymw1ISSH
	HSWb2YeqT9WPSIWq4GVQAxPeU=
X-Received: by 2002:a17:90b:4cc5:b0:37c:6130:7a5b with SMTP id 98e67ed59e1d1-39580ed0a57mr5089558a91.8.1787122482488;
        Tue, 18 Aug 2026 23:54:42 -0700 (PDT)
X-Received: by 2002:a17:90b:4cc5:b0:37c:6130:7a5b with SMTP id 98e67ed59e1d1-39580ed0a57mr5089496a91.8.1787122482064;
        Tue, 18 Aug 2026 23:54:42 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb4ffcasm1526626a91.6.2026.08.18.23.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 23:54:41 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath12k: Fix IRQ cleanup on PCI IRQ configuration failure
Date: Wed, 19 Aug 2026 12:24:23 +0530
Message-Id: <20260819065425.2044186-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=NoPhtcdJ c=1 sm=1 tr=0 ts=6a855333 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=bw38Geq8loADsqHK4B4A:9
 a=ZXulRonScM0A:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: LbIaaXucrMtN-prY5YvO5gZOJJJZnswo
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1MCBTYWx0ZWRfX1vX42fL3ujI4
 NB1pQ7rGlh1vzgqXHV371jZwoJ9dUlgiAeG9lpZoTO5Cp4h1iZMS5wBNP8WN6m71D4qWqPR52fu
 +FE28u0uLpoRT+BMHmmpBMIXGV1EdLU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1MCBTYWx0ZWRfX8CKcXXpLt8b0
 YaYMOVFH71+ZT99GlYI3mIO5gj2ZDupJGd9MHPtpm4yuP+lo1lh4Zkeci3xxBJuFGOUiY5X9Fh5
 jbWX8bD/wJW32PNEHEoSOUfgySedqCGZVNXr11eWVsBK+C9Pwu2P0oSdDA4SlsXS2JFLluNinmX
 tSiYcbkDduce/xogW1JAJNQadEnKCxSbyuPIQzGLthLCm033/llnV1ZXuzSEuj82uno4BdhQcye
 9P9sFwGC5b+oArwpnR6hYm5a2ejOEzAo6lAzW9BYo4fp7viWa4tTDdiSYOY4oRQiTV7P3Nu4tFF
 W/Sq8Xc3WFO3nUSERYkwfxTqMMhkaOpwam1m8dxtuFkuvK+Zgu6e3b8mgkBu+ZFEkwSy8I6YXQO
 KJYlzRjWCM7MC9qek9MZr6GU3oYiA4OiXk5+O4+AbYf9NxhTVjPDXioYT/ZlH7O7zYvDjUvc3vb
 qGtmXlLoIJVdZkVuojg==
X-Proofpoint-GUID: LbIaaXucrMtN-prY5YvO5gZOJJJZnswo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190050

Free partially allocated IRQ resources when PCI IRQ configuration fails.

The first patch frees previously requested CE IRQs if CE IRQ configuration
fails.

The second patch frees previously requested external IRQs, stores the IRQ
number only after request_irq() succeeds, and cleans up allocated
resources on failure.

Aaradhana Sahu (2):
  wifi: ath12k: Free allocated CE IRQs on request_irq() failure
  wifi: ath12k: Free allocated external IRQs on request_irq() failure

 drivers/net/wireless/ath/ath12k/pci.c | 55 ++++++++++++++++-----------
 1 file changed, 32 insertions(+), 23 deletions(-)


base-commit: e07447e654476262558bee570f4cf456e2b32565
-- 
2.34.1

