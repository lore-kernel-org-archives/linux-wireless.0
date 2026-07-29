Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A103E1D17
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309524; cv=none; b=eNuROYxlEB+ZEZ2MVzM32AixYMSPC4gEp7Av/cSziW/+5mr/PxacGDM5VJJH1c5KlrLDnjtnOI6YghxWa3+9aiICyMx5MBtHJuFevdoZ0bO4Lhx1uGE/fpi4VtjrEt0Uk6Iehzwr3nGUJzwOid9RXub+UFcyt5U8Oc0HbQHhOMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309524; c=relaxed/simple;
	bh=pR9AUGNjQijx+YDLTdmo7CPtAts9NnvZBs8QX8KYWCU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=nujD26SmSnjo6/XTOQ+BM94EKdnYTozGosWQpggxocS0vSWseGPxauVe9uuuad/BGG8q511tZr/qtrFMuaxbb1epoLayah/3iMyXguMgq1Zft+f6mXFHTkTcxc9hYfhMtSmowROvq5iy6m/cY0SmOBcGkvpPPoajxHVMxISJPxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Re3uUjME; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ai5NlPJH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Re3uUjME";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ai5NlPJH"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T5gWLC2055172
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=DCcX7xf/ngzQRU5CloFpJD
	SQhr7BK0s74VSAzlm3R1s=; b=Re3uUjMETPPg0EZzo++HIqpFzmAbWUKt+Db9FB
	C9prygbN5s9Ws0/atrf83AuUDnQXn24/Z/zW7JD4y/W2YhIIDas2xqe/LXtV6Ypz
	G8L8NJvjqOcHG0CFFIkVIxrkaKP0b2i+MJluWJ9bHVV+Z4XeI5yFj5wOOOw8vyP+
	81tcwSM9lkyhJRuoM/9YOX3P/9554gcBRUFbRh3OsANTcCkrUTsGtrzXpj4cqVsr
	+gcbbGJe7Ea1AjAPqPw398IdOllhpWIDa18oV5IzWWyu3ew/wwVLhTMYlKSLbLzN
	bO51bjnrM0h2s29VnZd4FsPj2eoei+Tk8JDlSEg2ZWRInOWQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqbm1gbxf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:34 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8485b7e18b4so1171395b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 00:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785309514; x=1785914314; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DCcX7xf/ngzQRU5CloFpJDSQhr7BK0s74VSAzlm3R1s=;
        b=ai5NlPJHlW3SmPfgOBlLni/nbrQnQEdPgCcgmdjWUQ5Wz8B/jlzauSExlrEgVrDWlx
         h9KsVcm0X5eVZMeQG0V58xqUcIPvoBi7c7fkXpEYWdNiVtTx47Yg8cu9ICqtBOMyjRrG
         y8efvXkDRf5x+6bSnX0LXeP1B0Gb7AXM2Ov3tprzpSlIBWut+382kfXF0rD9DIKKse8C
         ZEohTGpQGOPB1Jiv3noSvCjn4pk01N3IjN1/MgH2rRid8rhv2lYqz0zEsVhpAdp0Y/Q5
         jhitZwUkg3ZwZsP9dmfFgetR5MJHjijAwPBbNqKi7tilhLuoslfwIjsiew3yUdA/jXhy
         YwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785309514; x=1785914314;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DCcX7xf/ngzQRU5CloFpJDSQhr7BK0s74VSAzlm3R1s=;
        b=RRwAUQ3xeP5b6GDgy4nSRt/5Dnh7t13wBoXEc8m2tPkbWASfKdY8Q26s22DmscrsG1
         BQrAyVXgzLksXzcmnTHTbqtZ3AGXkyJCb0PA0iq1CHc2ApNiONUVe7Zcu6CF+IQ7v8We
         8tsYg27fGt2xOAi1ohELMVkfE1qoaOvPlg5FAxpc6Wz3COSQ3Ih+WRJBtOW0AhQ6RA0I
         Pe6NVd3yMG/wcYVRPTL8u6SD8rPPxlj0Cxhjr569Oc1IeQsE/Rfgg1FTJY+49zZ40sOT
         HwgngweEyp3ZT9iNQfP1bX5Pi1W2Yuy6MEZbEBvIn2/iT2u2l9OPV/LUPZ+iac5TpJjd
         qMQw==
X-Gm-Message-State: AOJu0YxK47sqW1OKZgst36iSMbR0fsurSKsc8vfzl6m5Pr4sQdwMaFwc
	PTpYAA24Dbu6O/8aDcsJ9151c4Ay9me3Co8UUjrkGpdzFJPr9CpteCT8KJ15D3F5y/EU1aBZV66
	sfzaqtRyI6kPPROXl6/alqhDXOFnwOU/QNKZ3S/j0G5xhKp3qT5k5qC/tiLJvJVy4kXeKhg==
X-Gm-Gg: AR+sD13gPpqvdL5OjMYQa6JjDPbmp/KmyomjgK3UKQWu6WFCTNghWTzZiWGwi1bQvYa
	4gqKD+Xq60J+Jxsd2QBmjDrQo8Wj8W4IsZTLgYUREZqsF5VFJM0RoIQHyRIm5HxNn1wIMvWM7b+
	ozFwOl1aM8ZmwrnAKTjijxRDOPQLwhP3G3FT7I4bw+L8s4KWWNAN00/2mVTlvzzQgMiR+sWyuUs
	f1ll61utx77pZrWdtKy0xGw/f6PjQ9Ux/qMq1rDPDAxi3eQ4q+n1X4Lnp5pfFcPjt9XgD6czoCe
	SMiwzNrIWJ6NiT9Qc5Q/Qg1hF0aaR6Ak0nJJXlV+8Hd5oVQtRL3ciZ/26LBF6OGjhgZIEdMUvKV
	9eOs9xjLTc+OWOFm2My9FpDqJxlOS6lT1WwExB+4PRyKdxwwwvCWpjA==
X-Received: by 2002:a05:6a00:23cb:b0:847:77e9:acbb with SMTP id d2e1a72fcca58-84e93192425mr5512102b3a.13.1785309514215;
        Wed, 29 Jul 2026 00:18:34 -0700 (PDT)
X-Received: by 2002:a05:6a00:23cb:b0:847:77e9:acbb with SMTP id d2e1a72fcca58-84e93192425mr5512080b3a.13.1785309513744;
        Wed, 29 Jul 2026 00:18:33 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb78ae98asm474793a12.1.2026.07.29.00.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 00:18:33 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH ath-next 0/4] wifi: ath12k: fix timeout while waiting for
 regulatory update on bring-up
Date: Wed, 29 Jul 2026 15:18:10 +0800
Message-Id: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADOpaWoC/4XNTQ6CMBAF4KuQrh3SH2jRlfcwLkoZoVGotgUxh
 LvbsHJhdDPJy8v7ZiEBvcVADtlCPE42WDekwHYZMZ0eWgTbpEw45ZIqzkDHjvEreGwbeGobIdo
 e3RhBFlQU+0qjoDVJ87vHi503+kTSCgacIzmnprMhOv/afk5s6//zEwMKpqwla1TFpCmPLoT8M
 eqbcX2fp7PZE//0qh8eT15NhRBsXxql8Iu3rusbioq5wCEBAAA=
X-Change-ID: 20260721-ath12k-regd-wait-timeout-6403498ae30b
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfX2+gPHT0UBdhA
 G33gWpWvKFea9Q4LuG3yyiKepniYGy1CYRhC68dCqaT6OJ0R/93eTNY8/C6DibiUYw+93dJEOXT
 BG2LItc2B6X+vFsQzbzzDwnRtuXoUsB47KocPUtaQ642HZpmm6Vv4Yq7LCs9e+46sGXgT9861L6
 1WCc3aTnJpWntuFsOYRT6oZaIcpihmLLQJ9sedey3B4rBrHzQi5J7wEFMqsLwi+xzc74lyXMsTr
 Nfy7THGrJYv/utZukdfyrjs4HyKVTg4hcQuDA9qgsIYiMRF2RipMed2DRQzlncsJXWGbME9ZQMe
 HD0Sfq5DC50q9tiFsAUisihwMKxgbQWja3jNHYdC1C0G131pV0L91QjptQ/NjiqORXRtD2d4IRf
 SIfC3yN+N0sn9fD70lxe1NjbGoQOMdHyxspD+TnePeyQtHAVoEngSnbXTASqAg+eHd/yNJ5jw57
 0B+mOt6QYqvG53H+rig==
X-Proofpoint-GUID: s4FUPDY1F-gJvhw1accDd5yQxR3OnOQO
X-Authority-Analysis: v=2.4 cv=R7Az39RX c=1 sm=1 tr=0 ts=6a69a94a cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=mipiRFW3E6dyOBJFvI0A:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: s4FUPDY1F-gJvhw1accDd5yQxR3OnOQO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfXx/Brnaw/hJnl
 d/b/3qGNMVoGt9pI/DOamp/IdFRjIS07UmkKcSZdFpgVtqG3Cs+cQHMhlQdd1RAb8aMX+NlnY4K
 +DCHeOQH7lveW7/QA2biRmv5I1iyLI4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_02,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290058

On devices that support setting the current country code, the following
warning is seen during driver bring-up:

  Timeout while waiting for regulatory update

This happens when the country to be set during registration is the same as
the one already applied at boot time: the regulatory event from firmware
gets dropped without signalling the completion, so the waiter times out.

Fix it, and also skip setting the country code when it is unchanged.

---
Baochen Qiang (4):
      wifi: ath12k: signal regd update completion when reg event is dropped
      wifi: ath12k: use per-radio ab in ath12k_mac_hw_register()
      wifi: ath12k: protect new_alpha2 access with base_lock
      wifi: ath12k: skip setting country code during registration when unchanged

 drivers/net/wireless/ath/ath12k/mac.c | 31 ++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath12k/wmi.c | 11 +++++++++--
 2 files changed, 35 insertions(+), 7 deletions(-)
---
base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
change-id: 20260721-ath12k-regd-wait-timeout-6403498ae30b

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

