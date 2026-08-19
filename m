Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301BA3AB5DE
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787146020; cv=none; b=vEr8FYyiisqrXWeQu2zkK8GFmI8gcR3ZGIjSDEJsaBlen5An5SN2Q5rPdlaYgJ7YYjgFOiOMgOyLIuP4/eCHVwaVdK95Vkn57KsPQpRFg8AzHAU82SsDo6GB6HVJd5J8504LCD9a/feojZbDdSBVoQNuGdXc1Qjf1A7pv8zeNwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787146020; c=relaxed/simple;
	bh=f9YlB0Fh+bNAledBbgwJEMD/HQiDELnKiSK0+Ha5n1U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=btVVaRldoUGq3PnrrnTBNW0VLIIs06lOUg4DQr4iY2nLMsQnL64GXT7h5qdK7H4FJCwvPg+5blkVg1aTDWPT73i7/fdWCEWL+vBkf+KXe4+T4YoNHbczHYL8G1oUGFC+hjIKk8SbZAv7q//lp++sQgRmPep7l8cHHpYewwcaGDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AI4H7C3b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Xcg3rzA3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AI4H7C3b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Xcg3rzA3"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JD0bWf3600882
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tzW5IHj5NxVpXb/NDn7q5pRWgTqd/agwSM5EqGTVbRM=; b=AI4H7C3b2DllNm2C
	mfg1zG4Qe5AQ2RDvEozScu2JhP59LxOlpO0t8kYdXGsG6rvLT4oTJV6kIKItX2SV
	6UpDb80fjlTebjInuL7bYXpQua+NFIF5K3oqhl+VvrorbLWr7wDi/3DrBf72MGco
	pHGj1IXiBZl9/pmhgeXGOqb9IMVStj9yHg+T8wUsiOVnnHHLbudJIKpRrg2P3lXb
	y7LEdNPzdVRtknGlZ8dDuDqpuB58QjdDJPujDAtaLqoBnUFcHwWTcGEeAwG/xuaJ
	ca2vRrZJDCucdQb4oVZb63L2u4Pi81PFW0YmfaA4MZ5g1ZftrY4X4MEE9kA4i2s1
	YosDxQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfm3ddk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 13:26:53 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cccfa32670so17744185ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787146013; x=1787750813; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tzW5IHj5NxVpXb/NDn7q5pRWgTqd/agwSM5EqGTVbRM=;
        b=Xcg3rzA3Q/mK8mmM+hfU61RH+fysRbbsIhpknE3RYUCWiR/3Cyme8kXCnEZAeZeDaz
         mJ2Ea3EaosEO1/dfisVgqIjL7/6IBt4dJ4X8koPK2ZGhw1nmVc/SUbrv+TzD7LxkIm1R
         5cDxk8esqLrDmamWUK14vGVod23W+s8jTF5cDtbrbBqgFQJDU8NPWk1WH+17IwnIkV1y
         obeFQy6Gq2ZNmYWCN0fog9v6cnz56b/em6oa9uLaTnMXkuNK+39PpTT6yf4qG3lHwSgN
         J2vHpYKoeSwZeoWmPzTG0O/SY/iBiiYTQTtnoCGanWPiKk77sL8IUvSFe8DuUYKR57z+
         qxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787146013; x=1787750813;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tzW5IHj5NxVpXb/NDn7q5pRWgTqd/agwSM5EqGTVbRM=;
        b=rzVPP1RddZl/SRVS73Kdmc2y1PV/H2Sb5BBj2e5hzE6iVyTPwQucgcBVdexA2gOKuw
         hJMILxYWiCy912mzLWAzLGevQTlkolqKUyNM+00iqF9Hca37kJVyd7vekQiuwPb2VwVs
         cVfoMpQathJ8Wh4DpkdIrekmxRfQ3qCxNRh4VlypX9OPLEu4Hcuz1TCDQUfodXUlkFF1
         aN5piyc+KOJ5au+UIwB5F1KBn28efkURJfwUgSGd1O2KjruT8oxHKQ0fiO/uMreKCjdv
         eKhIAVjNwCQfQv6F7Tvv2WJKQLnwQAb04sC0JxohaD5W50l4pjDv6ajc1gA7j1mb5RF1
         jpMw==
X-Forwarded-Encrypted: i=1; AHgh+RqFgk/szu4BIVG5x6BhAUrPSIbIsrf96efReZr1PtC+SNTTFv3rlF4QFxv5zJBMk2nC2++N3ruHwzc+cn2PMw==@vger.kernel.org
X-Gm-Message-State: AFuF++nIQV7wUFssi2QO0pcpAuygYcQVGwTu7e/9fC2TEvZ3596bEIDp
	8Ggs/71TxzoYt5Z97oTqzOt8R9W67On4dB/FhCHvZrfGscqYGKjW8ym1JjLFCl6X9aHgqSikfGK
	bXKdf3z9ACjpT1+DomghmBxVQmewbUJ5THAb88UXLhiJUS7Y6PuTbBk8+3/aZZs3l/CWiMg==
X-Gm-Gg: AR+sD12GIgBE8KMPi9yngJoWGpi8ansjA4LWjhvVDDGbn9RuQ6b62y4fBjmDsMqbOph
	BvJdV4InVmpEa2xkEsQVUpoxjAOvpzPT5rJy7iG6sAWTkVBoAPoJA6qyLv/vWhWdtPLhgeceCf1
	1hvYfKmG/ZNzmcJ7yF3gnk9EV2Haykgi7O1YonyyriC8LUDwejipdDkZTsA9C7FZqpdNa9TcmPu
	v0WV+4UK9S66rnUAslPiYJkI65LRixqr5SDL7NHCVYQfz6bXkbX+cd89p7BcZ9RPZbwi4yMiY5Z
	amfOrbe8/MxEL5ZSPfVwnxCYSuMzeuI6s+pUclPn0lm527jfjFoFC27X1GZ70v/ukqku62ZYmai
	QEBigjiitKD3EhgiuFUVggArLEUhdA7NRCj8=
X-Received: by 2002:a17:90b:510d:b0:38f:18f9:785 with SMTP id 98e67ed59e1d1-39580f2d498mr9334505a91.8.1787146013017;
        Wed, 19 Aug 2026 06:26:53 -0700 (PDT)
X-Received: by 2002:a17:90b:510d:b0:38f:18f9:785 with SMTP id 98e67ed59e1d1-39580f2d498mr9334409a91.8.1787146012498;
        Wed, 19 Aug 2026 06:26:52 -0700 (PDT)
Received: from hu-krichai-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327c2a92406sm6126465eec.11.2026.08.19.06.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 06:26:52 -0700 (PDT)
From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 18:55:57 +0530
Subject: [PATCH v5 6/6] PCI: qcom: Enable ASPM disabling during link
 retraining
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260819-bwscale-v5-6-6dea79786b37@oss.qualcomm.com>
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
        Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
        Krishna Chaitanya Chundru <krishnac@codeaurora.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787145973; l=907;
 i=krishna.chundru@oss.qualcomm.com; s=20230907; h=from:subject:message-id;
 bh=f9YlB0Fh+bNAledBbgwJEMD/HQiDELnKiSK0+Ha5n1U=;
 b=OgQCeukC0yqHkRBcMr7JYdM2b51+4QKimpjb1JOms87pWnVBZMA/wPJfz26Gp6RTe0N2xIQPZ
 HXv8nvTacz5BZOz8pgiG9ztzWQqkRsKziXtqPbqDfuD+EpVFPQQZzA2
X-Developer-Key: i=krishna.chundru@oss.qualcomm.com; a=ed25519;
 pk=10CL2pdAKFyzyOHbfSWHCD0X0my7CXxj8gJScmn1FAg=
X-Proofpoint-GUID: NkY0wwdl8lO5-93TNpuSz4moG0mMRTrA
X-Authority-Analysis: v=2.4 cv=bth8wkai c=1 sm=1 tr=0 ts=6a85af1d cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=LpQP-O61AAAA:8 a=0KoEUwRExAGgTGxQCIUA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=pioyyrs4ZptJ924tMmac:22
X-Proofpoint-ORIG-GUID: NkY0wwdl8lO5-93TNpuSz4moG0mMRTrA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDEwNCBTYWx0ZWRfX4x9f/8rdnfyx
 ZMRe+/9z++lBj8yqOvvVqnZ49X8kfrIxRYgTIkOtw05nRfV+9YffjLEH0EsLgHj8sRuRgzkMRaa
 cwrO+vmOgSqNadBpCzHg9YrMyEnkcJa13eGyETZst43G2eOPXffV7T2rZQHvnxOQkdTHTjGDFCn
 ZF/MaX/KirLcXwxeZ0RI2TNDSmDwD3aqWD0imS97m9wn12LxdRYsu8RfbmquTG8X17DnbL3Hu6r
 VliUACEj+mnLARJvVVKOP6/IxU+7Y6pHddO4pRRbH/SfN3ac4CzAqzSyVrRZq5DtgLPtD1iR8Ao
 5I8/pKgWGY4yzlR4+tNzHlYWt97SRSCJ8VGWDs/PNwHbiEm3K5ZfsdQSb7YngxkxH760GTkYpX7
 vjMFIyoFlzfOabejcT6UtISSZwRjidb5zdKwySz5DxxsrVUpsC0fuyF7mBLOyWL5jTPE+NNSMw8
 ISBzsylFeSir2jLn/JQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDEwNCBTYWx0ZWRfX/k9BAr01yYp4
 K29Gd6y8+Fj1aWYxK8ubpLVjaxj4DrZcBwReWndN42Jtzg6vBhqBPn+ARo7cQpuKUeSL7mGfzRw
 Oz8si7XDgMjmt7yCgmtdu1sO993ZXJ8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190104

Set the disable_aspm_for_retrain flag in qcom_pcie_host_init() to ensure
ASPM is disabled during link retraining operations. This prevents potential
issues with link state transitions during bandwidth scaling on Qualcomm
PCIe controllers.

Signed-off-by: Krishna Chaitanya Chundru <krishnac@codeaurora.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 45f4caeb0814..0237f747b69a 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1395,6 +1395,8 @@ static int qcom_pcie_host_init(struct dw_pcie_rp *pp)
 
 	qcom_pcie_perst_deassert(pcie);
 
+	pp->bridge->disable_aspm_for_retrain = true;
+
 	if (pcie->cfg->ops->config_sid) {
 		ret = pcie->cfg->ops->config_sid(pcie);
 		if (ret)

-- 
2.34.1

