Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F562EA732
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784856693; cv=none; b=CdmZN1iTzwHNuzSo5nowLNlk3zZPSCqbGfoh+fCiTkjwrpYsrLqbmsLwK+ZBEN/1HK1AEJuJcqqaUh/4nG/ancSpEZF+X5zUaQw9kVEfOi+0PnQUMMfdWdpJEDgt0f8wgKjyAYL0ntVEbVAoLk+UQA6AfpK4Y8STgjLqq+6XT34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784856693; c=relaxed/simple;
	bh=zWwsfCHLtrLHakKHc9avmCD2re5H1/EMCEEIcCGiijg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=I/7gowG3Zy/LGKCGwfwE2ksb/BgsdYpTtu/se4Jf4pVxLLMTMNWdH+Zcn0DBNIPbkWlwRNRKYOJQk1f6/O4EXRHaShfAZyUlgDJMkyZvIUvotla6Stb3j5kKVzUkS7KEAKkigPdeqOTIk+ym2GdRvJTGh1U77fnsYuL7h29FZs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KkNLG8k8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F/nR6zD8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KkNLG8k8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F/nR6zD8"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NLedEF949235
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=1Hw0owkOH+6wN9DcwjzLX3
	Ffn+1YguIY8Zhaj18HcfE=; b=KkNLG8k8HmiBUaenP1Mdnd3dCrp88GZ3RtBpht
	o1JOycBlAema3wXCdGSbjF2OEBERyTwcNFCc5QJDUF+3ikCt1Aw9EM3cl5hxKlSr
	S1kfcI1nsMP0OkJiglJpeoxJQF/AUg8Kv0Bcg1zWm2rNc63QCPIT6dbRwiimZQgR
	8HzfQIGuyFTRIbFA0m4CX4tusdP+GNaJOUvG6BQgVWNAEbaKEv8eUS/pBIeaSXbB
	WqvSp/pDT/oNHXFzyaJApGWG06kQYuOLeODfmBybu+tK+2AYPPwvNcJzt/3cREHv
	9GQ7P+0M7oomLPup5nBHLNLLm5UpQz5OGAo7eCoNStrqR9Bg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fke0kv890-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:31:30 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c892143db7fso1250754a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 18:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784856690; x=1785461490; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1Hw0owkOH+6wN9DcwjzLX3Ffn+1YguIY8Zhaj18HcfE=;
        b=F/nR6zD8WgfTPKDggWFXFipM69dEID+S3DCuWwPXDsWdyF2mGprmyaTLzeCKPn+zU7
         iIHsdqQPjLYh/75GkU5qR39wQ83SNVGUNs+t0s32JdXtiVb4JQ/pQkR76M/i8A43dBGD
         4uZ40tRLrfHuRPzl3yWu+uCKxycZGf7qjr1P8zZ+jk180uMg+YxCtH/+Oa9j8+64hUbi
         NceZjnC2Z1i962/3zKxKTnH9dS904gmqJjEg6g4oAJdHsxT2F0SbK6JiMA8cd66YRbw9
         C5G3X9nLjEL3BGdN6ffp79ss2QbuqIjIm4A7MN3pQcZGgKfon+8neyrXoRTF9T0naaOn
         N0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784856690; x=1785461490;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1Hw0owkOH+6wN9DcwjzLX3Ffn+1YguIY8Zhaj18HcfE=;
        b=Zg8aJzlufve7uwVXiT2mYahUeoh5UijKShrOGYF431U5Vg0cIljDp2v/SbFjUSyiTJ
         9O5RAl07vduEjDIARozQZnu20BliPRsad6T+aoLTFXYpWNgaegE/QaeXFB9RxjRLWcJV
         RB25VIyFeJhzHdiFV/NqiUMVU3mVFW/7pLEVD1SavGWnBKmzhr3/6pTjtHr45ZP4AHEI
         DB07KqEBISrZTmCZTfuWxXibqnD9/KfJu5a0WphdNO+F7ZkROcMS0/jCAuMig0K5NWk/
         n1qo0HGsNkKF3Vno/T2M3I2Nw6m3+jc1UdguIoOG/p9SCcNsWHAX2WihcvsffSUtgAK+
         NPOw==
X-Gm-Message-State: AOJu0Yzk4oy5xmD1wXAKF6AdoaBtgXlhrTmcHnyAduvmcX558EgOSeLX
	KQn8NgxPNXZCtwL5TyXM5n7A4hB+7eUL6yF8wGTL47SzhcSGdEEO6ecTlWP62yqJvQMReZOk07k
	rh8gxk1p7nQVs9KBvueQmIm2UGnUMiEFb/16b1a5IG/33cx6+zT89Xx+IvuG1zI4DH3mu/A==
X-Gm-Gg: AR+sD1162iPvpme9nkLbzFWrRryw60R0kYwMELGhxDyAFHzU0irGRDNW1/47Ue1Y++C
	pc1Aj/uKDA1i/L5uUqt6mFo60HDQEwOpW+D9J83+0pf37gZR6CdJHpZ4h7nFylpR9KgFL1sfF05
	Vjcb6G3DuinCqa6erslsAmwGEdWnyGSpwrIPyaE8G4M9eb+5phATyy21w6owaZYNZjwmP3y+goX
	pqlvQ+ysBDl2ppZtbbg9DCYLTCAsRu8kqL6QBL/3LnROOfrhhc+Fdx2G/BsJlnS3QK65fKKeN70
	Bz9YjykpWfQAli5TyYcMf1dD3zImst/KvVa+wbU+xVcpWkHJyz/c2z9gOO6NVLAzXlUD9IcW+h5
	lp64O6K46v388L17MeGyo3POqUvEAOLcU7KQwt4DZ5QTeA+XwgIfrfYA=
X-Received: by 2002:a05:6a21:a395:b0:3c3:b57b:628f with SMTP id adf61e73a8af0-3c44b14e867mr6229640637.48.1784856690000;
        Thu, 23 Jul 2026 18:31:30 -0700 (PDT)
X-Received: by 2002:a05:6a21:a395:b0:3c3:b57b:628f with SMTP id adf61e73a8af0-3c44b14e867mr6229605637.48.1784856689553;
        Thu, 23 Jul 2026 18:31:29 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df0ba0asm22655306eec.18.2026.07.23.18.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 18:31:28 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath: Fix buffer overreads in CSA switch
 count event processing
Date: Thu, 23 Jul 2026 18:31:23 -0700
Message-Id: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGvAYmoC/6XOQQ7CIBAF0KsY1mIAtVRX3sMYQmFqiS1UhqLG9
 O6Srt11M8nPT/6bL0GIDpCcN18SITt0wZfAtxtiOu3vQJ0tmQgmKiZ5RXXquHio1+DUGIMBRGV
 QK3y5ZDplwuSTggw+UdOD9tNIZdvwE2+klXZPyu4YoXXvxbySMkc9vBO5laZzmEL8LM9kvvQr3
 Mwpo7ZitWFS15XUl4C4e066N2EYduUsaBarIVGg5qBt3cIRBNR/oHmef4bU9HFsAQAA
X-Change-ID: 20260716-ath12k_wmi_process_csa_switch_count_event-cleanup-7fb191b7d7d3
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: Yg0TkUIXrx_bRgBgS1yLSZmsvg23O1KS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAxMiBTYWx0ZWRfXzZZH4CQFOmhN
 sY7TlzJn9XTpCqWjxJw6inytfWAv9oImo31EgMpqRNklkiQ0C7tcTDiQ1uPtZlwZSuHRSL4yU2/
 sGAgUMcCvAr2rLyfuZ+Jwsm7xIx+HD8=
X-Authority-Analysis: v=2.4 cv=S7DpBosP c=1 sm=1 tr=0 ts=6a62c072 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=0Wn3t2srTQlYvQ7pRnsA:9 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: Yg0TkUIXrx_bRgBgS1yLSZmsvg23O1KS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAxMiBTYWx0ZWRfX4WHMcxaTx7/N
 sdhVfAl85iP3t+Da8cPQLgceqGfhhyvN3j8N6l60UeIsnfcCqF/fWCTvpWvney4v621gp/SGQ8A
 nFn967tuTdAuw4eAdVO6m08cwZke8fOSagZHKQPx4Bx3Y8hIIAmrP0vCaIs51ezObSiMriGFVxx
 mV8Q45wzFSod1Pk1EDaVyjreyLSdsTKOPnoHptOXJcmIHq/vIAtzsaVa+2h2vcBWfJOqLfXCZHS
 mdvtDccrrrvO7pel1QZJuIU09q7dH74UIGf8YJidRfZln1jqRXWN5eJGSi/KyI+3fTL2yp7UEyo
 S9W9QxzDF8S+JHxB+40GxYq47yPZYxcr8UN5zWxics93541q2OF9CpeRX6RT1K0WdqL0g5qu5nU
 0dZizFBtDSjMaGZ60BUQkPMIo80hraleKOVvooJsccAYJRQp5kffGl4/jj4sf42nZ1ZJOZi2uel
 7f6jr8EwXQQOzl6QzFw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240012

Both ath11k and ath12k fail to properly sanitize the CSA switch count
event.

---
Jeff Johnson (2):
      wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
      wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()

 drivers/net/wireless/ath/ath11k/wmi.c | 21 +++++++++++++++++++--
 drivers/net/wireless/ath/ath12k/wmi.c | 16 ++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)
---
base-commit: 0ceb105245b5e57f803bdc0e79dc077fc06ff384
change-id: 20260716-ath12k_wmi_process_csa_switch_count_event-cleanup-7fb191b7d7d3

