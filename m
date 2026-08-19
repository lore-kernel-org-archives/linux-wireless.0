Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4663AB496
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145998; cv=none; b=EUQpq2944RS//ootMjux9sSExTrO5O9bXFpmdGvmCTZeARASQpoG6k0S5op9ojLI5UQztmKpnlsOn8Mv7CK5N2Yhx1W15ArKOUbxDi6xNdWI7Y3vQFjEA0xoDQm08L0tHfVrtPJOqMyDmxiqBSd1J2KYuI6VejA4Gya8lhWtjVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145998; c=relaxed/simple;
	bh=WyEzptVv7uRVS+fTWzoU6Xos6GT52swB3MLhrEXcDEg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HEKVZgFmVQrqplHbWanVzmDlNp5IDibExpaw6Um8i4221L0+JtoVNmBtn2HXL0P9Tr4NitIbJf7koO1J8wYWz+1+sWnQltfcDa7wqosV7DpG45rQxpNlcr/Ei7ks2BTiKZJn2ByppXyo8Jkkrm51OiE369rvXiodErOXt/uNcDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=o/OiSXex; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cyL+VYD+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="o/OiSXex";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cyL+VYD+"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JD0VPE4136766
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GA7vzClWeSwWPtSLmTimBFoLovSegooKkc2VbhIOLI4=; b=o/OiSXexN8V1G/qJ
	gWfaMRTTi5zuo3GeCBei+dNNHGcXWkq0R/MUJHYxoAhrN03eGN+Jp3kh3qF/zcox
	vL0l4Cz40c+Ii+79dFKJaoH7efydHgAv4BWPgLZ4yuYZjk6S+Nq9Np8M5aVhsKhw
	cQp5JAeB0SJrrTWTpU9cghboyHUnTgOI/fjXVklnMZ+Y9mnpJZiHL7KV4mxl+z1M
	lzQLtlsFn/KXYcEhYHCA7bAK4jlXgwUoyTTJcFU7XG+vXrm8NIFTg5Ts7DAujsO7
	KY6sgbhELpDqErttvjV8NxGfuAb4sUObP9ePsNE0vZSoONBpko29SadPBXsY8mqo
	qZ0iLw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yffkb2t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:31 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbee8d434b8so784311a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787145991; x=1787750791; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GA7vzClWeSwWPtSLmTimBFoLovSegooKkc2VbhIOLI4=;
        b=cyL+VYD+/9kxQB5/Tnphn6AodwamIyuTX6y5CIkeHSOKvgcQQXPBTtI8H/VuTzwoAY
         jmTLcV8mkMuiB1AS8Pvg7W5AV5u4BThAFPYeCwTMijVWaBTAWVOIVrWk6xkGGWLVY9UI
         NAFKX9opJisnz/99gpXOqSeJbnQuhi1W5QqIYXOu6xtW5BJxAxNkhJvor2BiwupmsFlV
         i3V01kVt0Ib7iNP7tqqeo7nqNw9FmBH3RBZNhnz7fEUr79YBkMYVjkyVVDiHZO4nkkx9
         8Duw7F5oUB8ptM5FZEVor/M6a+j1gWgleWwsr+jxJTeoAtttTaIEWEPVybEu/FlTVDwr
         E89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787145991; x=1787750791;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GA7vzClWeSwWPtSLmTimBFoLovSegooKkc2VbhIOLI4=;
        b=XXHAcM22uOWcmBOyYHGdZHSDQDOQxh1Ur6KcfXkAQZucFTGSaqpJ64nG/uZnphIhZL
         PUYXsqk2DPshOjVRoHgssrWxhI23tINwdMSodN1yVomF56ddzEVaCs3uN8cl9GLQSYeQ
         1/Tvf6EE4oMN0bcCezYD7yXYuPq7i6NVSZNpJnpmw8Tyt7ffpqECbYIFOqqXCFyMxkbj
         LKXghl1c/991GUcbKei4P0xM+8ap6abGxD+HC1AGLeT8msgvTRKqkLcDIBQKbF733cqr
         sBScTQ20k+4WQ6ehZczqrAyJMx0W2o3kGAPBPBQRK5PrpzjSRgJxZGu5oY6xKJyAt0tD
         vDUw==
X-Forwarded-Encrypted: i=1; AHgh+Rq7bI5K8HBqgQUQSGvN9E+RLIDH0jsJDCRgPBCHF73Xc6N4ioldI4teMppsyYXqIu8SK39OswPHouIgwx12XA==@vger.kernel.org
X-Gm-Message-State: AFuF++lZA/LxomoB87bLvuhr6E2Ojwt+JaBGocJ2jjDhLXE19L2R9tv0
	lQFzYyS4+wauaYyHSy9seNbLDT927pwNRztJdgLONEurCp5GyDg551IXN6b1vGBx/N4zV1fIe6M
	YOePD1VrVQa2+jws/CSxQ+hc67LzyLWU1w/yskySq2MvqR2RyNMMLKdOfqDr3HUZ0FPM3JQ==
X-Gm-Gg: AR+sD12LjxYs3Vp3pf6zF7zemnKKjhJIMpE1YnqUKdbW2mOKDr6p7MfR0kWtNm7aWFS
	9IMFeOBjelOcjk+74HtjtmlwBrwxaujiYsoHd12+O//G4liSXE3ukhSFT0wdvbKPk0RFW7WKwxU
	XzUQKJAutxnTNKg7F4rTY7cCYotVwjRlisNbgH0YONPTO6rrQlZYFCf997vInCfth3S3zAHQdWa
	+Eadvv6TfZm8CgHrWsYY5g3X7D3Yt205XR+k6B0Y3MRWKJUFy4KeBUFnZHosXCSZ762RichbMyN
	JX6tnOxTXrDjSomTYBKnEzEZL1vJ2P8BuJqbEoUxhRWJMTtu0oEKctQdVcKuLivPz+Hso+7FnAQ
	O3tLEt5lEqNvkPkXFLuE07lxNv+FJpTe9ubk=
X-Received: by 2002:a17:90a:ec83:b0:36b:b903:994 with SMTP id 98e67ed59e1d1-3957f86d960mr7218177a91.4.1787145990558;
        Wed, 19 Aug 2026 06:26:30 -0700 (PDT)
X-Received: by 2002:a17:90a:ec83:b0:36b:b903:994 with SMTP id 98e67ed59e1d1-3957f86d960mr7218129a91.4.1787145990140;
        Wed, 19 Aug 2026 06:26:30 -0700 (PDT)
Received: from hu-krichai-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327c2a92406sm6126465eec.11.2026.08.19.06.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 06:26:29 -0700 (PDT)
From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 18:55:53 +0530
Subject: [PATCH v5 2/6] PCI: Export pci_set_target_speed()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260819-bwscale-v5-2-6dea79786b37@oss.qualcomm.com>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
In-Reply-To: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Manivannan Sadhasivam <mani@kernel.org>,
        =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        qiang.yu@oss.qualcomm.com,
        Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787145973; l=734;
 i=krishna.chundru@oss.qualcomm.com; s=20230907; h=from:subject:message-id;
 bh=WyEzptVv7uRVS+fTWzoU6Xos6GT52swB3MLhrEXcDEg=;
 b=Ck/CEbFLWH7VTG9uktRjIhO+x0ADX2v3SpS1gJJH7UzHym4rKnJTUhEfeNLXMl2jzTD885c9j
 O0ztEcXozknDPDijfAx6Myn/TJhPpQpE+bnqryQw6/AfJURhBkxpzdQ
X-Developer-Key: i=krishna.chundru@oss.qualcomm.com; a=ed25519;
 pk=10CL2pdAKFyzyOHbfSWHCD0X0my7CXxj8gJScmn1FAg=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDEwNCBTYWx0ZWRfXz0SOBMgqTYxT
 toeQasa3Isole/G1tyLb7V3FUV38smHKD6X3F7hEDJVZUB7KgC7AmDLLOQ38DlCJJnQYBAzkSFk
 Sad2alXp9uuDnLbxkpv9mV2uKtpnKmQ=
X-Authority-Analysis: v=2.4 cv=H5PrBeYi c=1 sm=1 tr=0 ts=6a85af07 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=QyXUC8HyAAAA:8 a=5E3R6_0bZ0f_H1kkCjQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: 2n6qRJkE-_6V6JTYwj3AeUCqORXYOjx0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDEwNCBTYWx0ZWRfX6ltQthoSjqiB
 7e31fKtETWD7dACOUhajP2x4H6nQ4z9UNv/rSW9ZXNLv+o2WoQmYFLnHFf2bJkB9jPTdEsMVbfq
 seYwiHQW80yosl2/CgezySU7pra1FoRMhkRoIA627Jr53nQlA5swMQVDMbCxI88I/YxEEIiIUrR
 jYUQ5vaxq8ZMrQS1+KUH2wUq8BEc803lvj8Ecte2q20BRt66BKBRvYvCGq7lrLJBimOtturIKTg
 1FmSUomZ4YcXVcfPL+QegQuBD29GhcpbLDL0J75mwIFx3ICgMbexeNQ1ahNsBvsT6ScbeBGyMuL
 o0oYDE/7S2nBCgbiMD04OpK/qeCVqrdXFMmWzHpX6zyfVWAps6Cz2S2W/YLYT0RGV/qpYjrmuhm
 swozEHIApn09VDZ+Hn4h7FZU6UlTbhpjDUl0YTact12TXhOc8lsUDe2TC6JFenEmLjXXxvcMKtT
 R8/5CteLFVFCJpffTlw==
X-Proofpoint-GUID: 2n6qRJkE-_6V6JTYwj3AeUCqORXYOjx0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190104

Export pci_set_target_speed() so that other kernel drivers can use it
to change the PCIe data rate.

Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/pci/pcie/bwctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/bwctrl.c b/drivers/pci/pcie/bwctrl.c
index 6fa1522c47db..a337f166465e 100644
--- a/drivers/pci/pcie/bwctrl.c
+++ b/drivers/pci/pcie/bwctrl.c
@@ -239,6 +239,7 @@ int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(pcie_set_target_speed);
 
 static void pcie_bwnotif_enable(struct pcie_device *srv)
 {

-- 
2.34.1

