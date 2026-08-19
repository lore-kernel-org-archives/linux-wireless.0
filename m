Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5188E44DB85
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787137346; cv=none; b=ifNkU+/eAsaGkzvyxkZ64mJxypvgtjYGgEB8DL2mx7TqdU1oZ6Ngaj5UrppgAxFVqCzgGw7jy6Xy0teAaGlSP3EBYm6Db/SIraiC92XxHx4vuafDChEQglw7dVpOLyaU7xCm3wRQTd1Z3Qniq0GQGrNNpC6ZyfxpGlRRSJeDuFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787137346; c=relaxed/simple;
	bh=XhWrhq3hc6/06lyQ5acIfbn1ugUgf7AywPMsT2g0I/c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kp4l2E53w4YNRFFB9MCdhQNr6LX4oZEIF/UeoEgOM3jRE+tUEx9KWeWrVFed2UsDi9mVrSSpslzzFya+O+xo2HkPGt1lIGSfdymicQTYrRx5lpG4wLCNdnM6L8jutAx1ETGH4P9R5gjlbPJghLeI/wGOvY6FO+aEVds9HUvkXWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VK/VUE6R; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JxaYNoVB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VK/VUE6R";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JxaYNoVB"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JA8ClF3216598
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=sGruxQJPPCCQjxLY2D8dvvaTHG7OpIgDOoQ
	tn310XEA=; b=VK/VUE6RqzEq95fjJKJB7SgbQWRDnxcNexxoADoulhsq78YPMaM
	f5okh0glyV/rdhzFsHktTuAd1xUJVSpMPm+pBi7aBVis9aCEFjecNowDyJWIBvc9
	KkksaGW5QqrlAyJRioZdJiM0lRQYm+6HkWQaRL8EZAz04Nok+IQgzmPDYl+QLAn2
	1KB5SbMFZSA5/AAkTVtt4dbnBvusYdNwWHO+iveaDCHrGwTcxXaSQBn2h9NtAhMg
	fLfo/aX9imtzjunF2yx28KC+Pf4M5+y5AV6w0yNuqUZjwGyU8BVvYKLAGVb4A8Fr
	Q0Odx5I3ROmAz4meeusOJmfYO9yN0lF74QQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfm2uam-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:02:24 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so1609550a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 04:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787137343; x=1787742143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sGruxQJPPCCQjxLY2D8dvvaTHG7OpIgDOoQtn310XEA=;
        b=JxaYNoVBc3lAWhJiRvh8/pv1KRb42SAHdk//Bwh+9JksynYWgDtOrHq7WdqAaiPskk
         lz0zHqLSvn8MnxoHXtXdhqxsO6LY/kYgwBidFib7JftyiMeXK21tq0jkd67W4gsHwOep
         xLT56CKO+o/ETFQWsvDdi59q/kdd9gSE5iORTKjUPtoep+QG6zZa3d2handQO8VRlmAG
         In/xzIArAUVi/bv4GIts1NXjdaTM+PrZK+BhZO8oyv1jm7nI5rc+mse2j0wGM+AMqAcv
         Xx805tIGrgS9uymyY2oyxoGWRJWRijC2QgSyn78JYXtT5vtLRefq7K90vM8X3BtozP/A
         JBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787137343; x=1787742143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sGruxQJPPCCQjxLY2D8dvvaTHG7OpIgDOoQtn310XEA=;
        b=fE9Jn8CNABOQgqHJWIftaoXAVwzBmHz1IzlpSzABwbs1IKaFWU7HKJf9k41ZKCjIUt
         1jOHgSpcdvJeVNIKUmKtS05IWXleagaIwG1LQcqhlgnvae8KGs1nKgH9PybJ3DX0WxTm
         kpbNdJ5I44mOmnebtskHmBzOSs9S9mp4vXYHlJKxThipez+dWHPL6XNpTVY/nPNRANdM
         wCzLlbD4SFduoGiVZcbwPRK+0Im8M0YIApAXjaVZttHPXdsOg+OeGqdhR4sy0ttTVswi
         oYEsH+SXl7skKzo3I9NUzLTTj7Pz1S1Tpm4SjtXENQfXnewZMICuiSnLAGBOYbXYB0m5
         MHZA==
X-Gm-Message-State: AFuF++k4dKE/B69rC5tKRcHOd/KNAh1e3F43I/YjmeyxystquJoyvahi
	uxiWXpoY4QOsGOAKJWfCTuw3ts6OF45Yf1ScD1N8WdUbBx/71xY9N9s2/V9S5AQOgadU5zmpqpC
	viz7qvy7r2qxKKApBsTH9Xy1PxLw/zna/sIM1bCj/0Ml4fQxDbT93WazUJQ1qpXbZ294FIg==
X-Gm-Gg: AR+sD12deNCjudNGjXLW1UjoEftdB5Pxyoeka9zymb5+AWUFOYdHN+9f8AJsJ2fgXOG
	Ic4iixHTPfMy5kliH3sHfPtZ9+FpEKihTFA2iHRyZr1zvr9unz34ZoqjcY5G5GLti2bhJ3QbPqs
	Quywq6YHwg0GjvtEizMqm5Ox7roH+pNLpqCyPfBVX3IoOhyr/8XOb1ddjfQbZ0xFwyNladBof6h
	W6zldiAf47w4FFU2GOCXkngFQZIsHz10R3kuTq0cA+ZsSK72FB28UmMic+NH12XJhHd8jOuzx9p
	y6J7Dzrfak0734e216I2Qw30621BXWwE19xi1zL4J4/6Z4MXlwhQSj01jKiJkrU13Hm2dtGJvca
	m1XZlS+pFs1VCDtFkUaZHs89yRBXcfnfMme+laeioyK+tINAatvSlgz8fAJiS2TmpGoLnLiwu/3
	eIRcWr4TB+HGHpcQUa7XmJDAA=
X-Received: by 2002:a17:90b:510b:b0:38e:b400:a860 with SMTP id 98e67ed59e1d1-395810e84bamr7388828a91.13.1787137343216;
        Wed, 19 Aug 2026 04:02:23 -0700 (PDT)
X-Received: by 2002:a17:90b:510b:b0:38e:b400:a860 with SMTP id 98e67ed59e1d1-395810e84bamr7388664a91.13.1787137342611;
        Wed, 19 Aug 2026 04:02:22 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb30541sm2223640a91.13.2026.08.19.04.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 04:02:21 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next v2 0/2] wifi: ath12k: Fix IRQ cleanup on PCI IRQ configuration failure
Date: Wed, 19 Aug 2026 16:32:13 +0530
Message-Id: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: d4073ffU1iyabtKl2_PdkGMfHb_lvn9z
X-Authority-Analysis: v=2.4 cv=bth8wkai c=1 sm=1 tr=0 ts=6a858d40 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=bw38Geq8loADsqHK4B4A:9
 a=ZXulRonScM0A:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: d4073ffU1iyabtKl2_PdkGMfHb_lvn9z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA4NSBTYWx0ZWRfXzHXEYuTelnT+
 bV6bQhEo4Anp1YOGU1fpTfS3mHL47YVd7uoGImdUYsqwglB202UmhJsuqDlMSkSszUjbi2iha20
 Vs+gOv+VYyBi/RirOgcfPBAfCchdln1ack2sk19biqnpm0zcIUJo6Bgrs5WrsfRTytIBVgDqkyM
 qOdYEjRlL3QLB1d3IQX12MsdBkr1rV5JEYoj3QAUMEdctgonTj7uCDk6cgSADhIWWK9XaqmBatO
 4ETSO7KB/9IcMDlIzdaAeiI4f5lwJ2bLRP/LuTSR+6fNSOUA7++QKtCm3VpdWnVthmhC0n5z2Mi
 WDdh2SphuxHWUI9jpVeZ9NGGkqbXKgg+olTxZ8J4VDQ/FDalkCkWT5QdVQ9ZQzpJbePzM5dOaGA
 R+GHdbDKn89hmJhYuaifMsQryx6xsEHYY+hHLTtvUqV3Ruf7ALTeai6BEHr/hCGilEkAiB0HKsv
 AjbcZgfKHgLD9g9De2A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA4NSBTYWx0ZWRfX91J5NpGXFqgN
 eFu5pKWJeRMGUVF7CjQNuJ5TbjFThEsuYo5TfizsdheR/qJ3U4zvGCyowGBWy3HgWFPqCHAmkgQ
 Jz6L2yz3sSmSZXA4Z0rKxnvkV47wuVw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190085

Free partially allocated IRQ resources when PCI IRQ configuration fails.

The first patch frees previously requested CE IRQs if CE IRQ configuration
fails.

The second patch frees previously requested external IRQs, stores the IRQ
number only after request_irq() succeeds, and cleans up allocated
resources on failure.

---
v2:
  -Used ath12k_pci_free_ce_irq() in the external IRQ config failure path.
---

Aaradhana Sahu (2):
  wifi: ath12k: Free allocated CE IRQs on request_irq() failure
  wifi: ath12k: Free allocated external IRQs on request_irq() failure

 drivers/net/wireless/ath/ath12k/pci.c | 55 ++++++++++++++++-----------
 1 file changed, 32 insertions(+), 23 deletions(-)


base-commit: e07447e654476262558bee570f4cf456e2b32565
-- 
2.34.1

