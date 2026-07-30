Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D643392C4F
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785392299; cv=none; b=bAP3SlkNHhE0igH80GHlDCOSEqgxiLCOAC7MyCQKxUX1GR3EdNfxpgso/lYBAP2PptJLH7xbkUVPpy8VmBB9j2/iT1eJtpuEsxHvRm3bZmkEaMg6C47EnDS5VXYjkHz92ABpY+QFeYaU67GbGBxAF2Zw8FyhaRdyDPj8oZmzZhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785392299; c=relaxed/simple;
	bh=fq9N8UNY+h5lKfo9lzutke6NUJ1ESzET8yck+pKGcos=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=YiAtzQYS2uZIwDtbfb0oBsfR6TpHC+wjFD04Uebos9NY831GS/GryIDtduT/W2KRVV+4iZuI6Z5sydSLr24IsXQywUDTL4aGwFwZ7VIF76NUxi7uvmQd6J9yb0N7aXuZIwAxsXYtxDQ1g53tBpqmq6Tsspw7Z5I4eDDy8rqpHSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WOTu5pLO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JzBPXALu; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WOTu5pLO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JzBPXALu"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6G0aE4093902
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=sSTld8JbLzNx3/RvownXYU
	l3LcclfnTNfSM0xsQdSb8=; b=WOTu5pLOcAA1lvOVE0elAa48o51Z4ay+VgzgpC
	BbkgVE9cSTM0L6T0VQcH/IewvehaunYnENioEMlk9cVunNYY6dWIgSGvj07dpagD
	QdMJGEAAEfT/UGP+k34gGqlmcl1h+pawpp2PgCUl7nQKjbgEk4jQgEdKxEG56DEI
	ViIQQQQ0SX6AGMbjVX02RQXTopSTs9QQ7ql9A0Sf0dBEC7q8tIYk4CqkirfbTA9d
	obMEBWq7mS8B4vJgOMOgRrQlaBKdagoUacVzQWDps8YnwSO1PjLmERKk6tWZdF8P
	ZSerQEUu9tolIQpSVFvsTvIyQSKVVBeXq5xBUeDtpUMaCIdg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr16q00aj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:01 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so2415735a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 23:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785392281; x=1785997081; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sSTld8JbLzNx3/RvownXYUl3LcclfnTNfSM0xsQdSb8=;
        b=JzBPXALuvzziBk4q3l8rKNOaX8wXEOgc8h2xlBeQ9CxdfwFE0XKf82il0V6tBoVgJ5
         dZ8dAowVQVjVuZmaC5IoVEhSSvEZuBOa3k8nweJsAw1kGgoebCF+nqlnigf+v0jEAySl
         tYWeMCJYApcrcmQiMap7Z9G6N8iGmYD8h3sl4Ogqf+cXnAHVqyABJNz1iZ6UaGaWCUy3
         rvmW/psx+HzmhYQ6R4QrJ3YCOq/0xWpV6XnRkHuX9RbUxfL5rWL2VjgMRwbgG6f2cGam
         Wu0EgFzLL3hw66F81ZmiYUMibMQWzIIwvjschGZI2WLyKW91hNOsNsOwIn988y7l7o6H
         wxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785392281; x=1785997081;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sSTld8JbLzNx3/RvownXYUl3LcclfnTNfSM0xsQdSb8=;
        b=oZAXT8B9a9GEbJUuKzpI8jw9R952mO4aSlT7NnjEn5wbtDMmHdXcG8dDHbtQyPH8n4
         huebXDZWdKjdfjvaI3oGFsGwKkYm4KCxLx6esQXDNd3opVM+PvJKkizrcvx54qF/sNAf
         2+fXC8Vwal9Be9Y9Um8V7eHQFUs0umqpPXV6tcBFsbh9261giMJJpVxaLa0i9BYXR6+u
         hyUfBLgzJagcYZLiZPRaAZqmwafLb+xoeLiVrwYL2d0evN6Osac/bXxRVxIEryiUrEgS
         lhKTGtFm0Hhl+gBWUUFLrHru+fNHodDD+DiyH6KAGE/r+KtbmRt02TOkffLJLuYnhV1t
         mVeA==
X-Gm-Message-State: AOJu0YyrdDuQuDWMCSICal0S6F2KZG/vXY4rxeKGDbR6sPCZhbxN9BaX
	99JBPuKvptuwLG+Clii8ljsonhwpxvuRRfrE3gxkuAGSlXwMTFcJFZBFcCKhj1CEF8ySQDlZy7v
	mQC8tQrwRk2WrGsPgv47Q7PA4Hn9d+qQcqj6oiymNtR3slrwXEeOdxXDae3y7JRFo8mYeeg==
X-Gm-Gg: AR+sD121sBz0KEyAs4iFRxdwDWhqwwf3nF11/MSYEaSpvpvhoVDMPBbaJGQzLQkqq7p
	eKm4CSMCBRs+VBaCdNT9OdXJCjz/b4ya2NYEP7OwXnTMNJFqmxctLLO4rlt2P1zI3YPiTZpLfLq
	/n3Je7Rf2NUg+4WpL9aMzKfPzZL10aPcbaT9+Mk+dwaTHIIyYasN3n/m88DuWPTH/ufx2UlFg9E
	6rCQzoVK49JdLj9LMInadruqzshHPg7xI7LAAN3pT+yXg1X34RHSUfffIkMeLSFRB2bRXMbixTi
	XvQNFoXnqmC+gZgPo/4Pki7l0OrNDnreYgXMhMC5uV94LOM/hben16+7dQWSms0hhYUaLz4nElN
	dcuQ4mNEcjMs2KouieArrtQEAYwN8c0d1ktQSy6TrISLvtmMGF2k+tw==
X-Received: by 2002:a17:90b:39ae:b0:38e:7268:220d with SMTP id 98e67ed59e1d1-38f9bea6293mr1025276a91.20.1785392281089;
        Wed, 29 Jul 2026 23:18:01 -0700 (PDT)
X-Received: by 2002:a17:90b:39ae:b0:38e:7268:220d with SMTP id 98e67ed59e1d1-38f9bea6293mr1025260a91.20.1785392280649;
        Wed, 29 Jul 2026 23:18:00 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b928f09sm457254a91.2.2026.07.29.23.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:18:00 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH ath-next 0/3] wifi: ath12k: align QMI memory to 64 KB
 boundary
Date: Thu, 30 Jul 2026 14:17:39 +0800
Message-Id: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAITsamoC/43NQW7DIBAF0KtErDsRDGBQV71H1QWBIUYNdmMcK
 1Hkuxd55UVpuxnp6+u/ebJCU6LCXg9PNtGSShqHGsTLgfneDWeCFGpmyLHjRnBwcy/wE9wlnQe
 45gSZ8jg9wBlvTeiwo6hYXX9NFNN9k99ZHcFA95l91KZPZa6L7eUitv5PfREgIHA0KmC03vC3s
 ZTj9eYufsz5WM9GL7jnZJtD4GDiiQvXRa4VNjj5T05WjmNQXp60RCsanNpx+AunKic1GktBShV
 Vg9N7zrY5XblILmhlIhrSP3Drun4Df12q+gsCAAA=
X-Change-ID: 20260710-ath12k-align-qmi-memory-a7c87d626ef4
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=Yqo/gYYX c=1 sm=1 tr=0 ts=6a6aec99 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=YCfBL7qkbQnd2ZjRc3sA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: V30vsZuc2GZwMrbPydxLRVj5GlY_5dCY
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0MSBTYWx0ZWRfXwQC/SuqSaaai
 eS4FrIeZMkcufcIvMOIydoYBDFDg4l++USHsu2kHmiQ4hY4x9cUnM/E2q0qtQczK9gV4zWBm+4+
 2VCK9uPz9kOYT+I6kuBlmoyEMDU1JqE=
X-Proofpoint-GUID: V30vsZuc2GZwMrbPydxLRVj5GlY_5dCY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0MSBTYWx0ZWRfX0ea8eKaLZdAn
 HD+8WBSK1A4zjd/LnNr8K4i/Y9i2Umgau14Hd4XQfsAmhz2dC5W1cju8v3qpL89XSU2Z8/k4CNj
 gni60PUthKQL30A0g2ErXDm5VFO3AgcPucX/DPV1vx989oYaIIhdwTnXLEfP8WLl++D1Ak+n8fH
 L4WqUbOEsPEVV3IsiC6bqyrKhPu9uCA5T6rVzXx/eqZgfNfBD64U1BlJL84uHgSzmIIAcxyxvyD
 ve6BF/A1Mm/PH9Y9K05LivepMYJFx0X0ngm3Cc0KiBPY2Iv2zzdxC78SXsjietbErfFK7VBzyjq
 TjDTsbuNZrzAR3FB2pd08aEtRwJglpiOL9/npjcnhXX0C8an/+kgos0I275BAzsTDKhor7RHBmT
 lTcs9GlFFwqDAHSY6i037K0h++ttQhyD2aSMKiAg5iyspwE1NPFhwItav8kwqpQt+EZa/jiSTSn
 dJNG66p9vgxPO/Mg3Fw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300041

Firmware requests the QMI memory to be 64 KB aligned, or crash
may happen. Fix it by manually aligning to that boundary.

---
Baochen Qiang (3):
      wifi: ath12k: use per-device max QMI chunk size
      wifi: ath12k: clear chunk paddr and size in ath12k_qmi_free_target_mem_chunk()
      wifi: ath12k: align QMI target memory to 64 KB

 drivers/net/wireless/ath/ath12k/hw.h       |   1 +
 drivers/net/wireless/ath/ath12k/qmi.c      | 102 +++++++++++++++++++++--------
 drivers/net/wireless/ath/ath12k/qmi.h      |   4 ++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c |   7 ++
 4 files changed, 87 insertions(+), 27 deletions(-)
---
base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
change-id: 20260710-ath12k-align-qmi-memory-a7c87d626ef4

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

