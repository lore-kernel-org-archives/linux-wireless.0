Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793930908;
	b=NvZC/YNRdZ3QuXfQ4TjaGloAsv+FgKpbTWMSulJwBziITvcBrWtQM4PPytZ97uS9s/MS
	 VSy7v5o8WeB827rC5BMxxHKiiN2W8Gg0RbLBa79ZvEWmfKIux3tMG0akai14XNoEm763A
	 4UOpJyPN7B6bBD66vb6A6ZM5FLIiDJVJIT0s+pY7KVc7wUiMI3ZG+02dbg7O10e2BA59H
	 5u1Kwbt7lFVkrHvd/FlfiLz1r0pt5C0FWBNpphfQ+XtipU+z39lkr5N+ITidygQycKuRC
	 bMqa3MUO7RmERuwpMyNXOJ0R2GXJqajsK2OTxdT/mxhIC4Lkh8Y1mPZhABOxTvtQFBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793930908;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=nf/bH+V3LpW42TMR0N1eeqd5iHEPLwJw3sYgg0jZ6eQ=;
	b=wb0GEPE6csuiK4ZBDrqkm1GPPRz5lsjpiqLubGKVL8CxbEDSYgA+Ad/1sfADokJ0Hu1y
	 T1hz4L67/wYjo77lpvj1jk+e/yOC/+2mfSChgyI2YSTWNO276Feh1JpMf7Sk6Pg1wA938
	 qeOjDJmomPHuSwhj38HKMxI67ci0YtpQ0Pe7ITMi5x2YGRnZ8A87/ncLCurZt20QsB70/
	 4gqEkGgxIoYRhD5ZtorTJiRvzuzUxkCmtNves7Y3Ryk2060hTCb0IDIWtwsx2GLN+SCr/
	 n5JiaqViI1d48g8TgSNzJ4nv9582kj+NGYoDdItSJ1I1ZdnCOm2VSHiGkggaMQocN9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nUzEdP9w;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=U8skVmq6;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B10606A32E
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 02:08:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76B10606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nUzEdP9w;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=U8skVmq6
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5NeTJ42855089
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 02:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=nf/bH+V3LpW42TMR0N1eeqd5iHEPLwJw3sY
	gg0jZ6eQ=; b=nUzEdP9wl8T+wVbNvUHQNbNYOp805ZLOGUbPqvGISohFkbl6eko
	ba311OLu8/745KDhbd5YBSGkizx5HwUOt1fnck4enNBHX1vtxC1vqYOg/ezT12iq
	j8/eIDOJfpKBVmZ2EGygUK0gJPYQJiJ23KaYOKWi/7MyE8suU2UyDJ5vKd/3dsjS
	uoVigoEbWhr/HC8wUvO0nZYW4n9LkFEEaDPhZi3jIQ24cKP4wT5xf79sbb8W5yIX
	4UL7y1vaeuij+CtsKW5xBZzomIS8w0yz5wm4kyYeBNQGzwRv7Dndnffh2tiYdmYO
	SQAn5rcu4M6PXAtsk+sBfvcdwcGSPbvv4cg==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pb0f65-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 02:08:26 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1af203073e0so295639c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 18:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793930905; x=1794535705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nf/bH+V3LpW42TMR0N1eeqd5iHEPLwJw3sYgg0jZ6eQ=;
        b=U8skVmq6m0CUGBrFFOcEUUmNx6kaj4xN0x7lQKYZq/SLBoalngQCgUAcuNoCnqzPJV
         QN0wWSCC+GPnRM17c/5V7m9UHi5O1XC2PtlERNI+Ec2Ve6pkD3Rfz2m+Opc39rRpWnJo
         j4mP7HsrlvE00x1erb/MSIgRLjSQvT7Hh5dQT0sXEjuor9Kal1PcAIOgQKQ6uQQYdeCc
         U0IuxFzhjdNasXXvyBvf0Xg6F4Q+KWLtoRyfyHtUPpgfFbRtLXtOH2X/5f4KyG7BKYRh
         CPvIWJWUzrVkDLQWaYPYPGZbqEzuOePScd3lgOXTIIk5ANKYRkKIgDVc88D2l68zwSSk
         ABWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793930905; x=1794535705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nf/bH+V3LpW42TMR0N1eeqd5iHEPLwJw3sYgg0jZ6eQ=;
        b=dfDjOnmayj30dSnnqLGjhPrJfBiafck9AJbjn0fF2/oqFyKja26VnL8LxFk17aT/UW
         TlA7JCU6JHnNeJ8ykszi1fNPSXf9bsYV39ZbMsDsr+7FOaS0sU8X93Uu5HN+yFsAviA0
         iO5AGNZmYmcQqmyS3IVm/R5MgX4fs7FPqevsETrsr0LGoPe/WhWZfzr4sgizjK62LTr/
         BAixKYpgC32/0xppqCYpZu3NXz0fqrNfXOOLz6nmdpUh2e2w65UdUAZJMQfpg65Ln7CY
         map1xwUB9m4/R+zM2yHPAMc52SQeMJKe61zFVy9iQtIjqicdwuN+YUWJpjEe5JhV5jL1
         5KtQ==
X-Forwarded-Encrypted: i=1; AKwUvByi/GjRHKSl02SMK70mV14Ljt/UVg3rv6Wjp52BnlTKMqp6BqasSWqyjt2HHF5QpsCQyhjDx0dcBXzMMrrWsQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9Lp7BHstet5eq+g7e4a1oB0CftFJFvJ9N/itCBz8SirMroYn7Q
	xumpLAQr3cGPg857v4KUajB22Hyuk2n0z+pTpcoagO59yWhp4DPc+jIqxUtXmEN7cz5icpFSKs+
	XCMB3AcvHo88xyf69QPkVV8wXwfAv8BaF+UXNHF5c2devBAK10aqO7nDH75N5WgYhUanOjljb7t
	HOjQi6
X-Gm-Gg: AYBFou1gIXBGwDTQjf0GBJWNHNLnNdZU3b+go8s2v4LNimkI+hL2eWdCQbokanSCon8
	UQxttEjgKpE11rCRO8lWB1qxCyKWD0z/YsH5O6vpmrSMpTZcTc/Pj/RIIWqadrLHqoxitkYwifk
	Z75E5rzQ1+U3AM7gS+vR2bWUoNrRXTJts2v4T0kArKrlNrmqIs9ELAHkuMfquqX+dT+zmFXZuxT
	L+oNA1t1lCZd8nnS9ArPwLf5QlqmU8wQhD33WimWT3mloieWfUUNrympzc+pupVr1ikzZir7XTB
	TQoyM1pIhSmMkHm5DzJnsnowrO7Ly9+5E3HkmMVfNQzzqpeoKfcgubTOkNip88COhXAizH018Jc
	g+68ZdoFapXqtIdGU8fTHe3ngSnkXRSjhAA8fnOFqrnGIsDyO02IVCqqxvYjYnRvYQ4vhR9q1fr
	LmeOzkZtnd
X-Received: by 2002:a05:7022:4183:b0:1a8:4997:65f6 with SMTP id a92af1059eb24-1b25d30ec8cmr1490438c88.20.1793930904826;
        Thu, 05 Nov 2026 18:08:24 -0800 (PST)
X-Received: by 2002:a05:7022:4183:b0:1a8:4997:65f6 with SMTP id a92af1059eb24-1b25d30ec8cmr1490393c88.20.1793930904197;
        Thu, 05 Nov 2026 18:08:24 -0800 (PST)
Received: from hu-hongchen-sha.qualcomm.com ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4a63f6sm1324796c88.9.2026.11.05.18.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 18:08:23 -0800 (PST)
From: Hongcheng Zhang <hongcheng.zhang@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        linux-wireless@vger.kernel.org (open list:QUALCOMM ATHEROS ATH11K WIRELESS DRIVER),
        ath11k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH11K WIRELESS DRIVER),
        linux-kernel@vger.kernel.org (open list)
Cc: Hongcheng Zhang <hongcheng.zhang@oss.qualcomm.com>
Subject: [PATCH ath-next v1] wifi: ath11k: add usecase firmware entry for QCA2066 hw2.1
Date: Fri,  6 Nov 2026 07:38:08 +0530
Message-Id: <20261106020809.3580396-1-hongcheng.zhang@oss.qualcomm.com>
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
X-Proofpoint-GUID: zkxllnM0vN261kL3CktI5M1xYT8sMKX4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAwOCBTYWx0ZWRfX7V2vAKzdRRog
 nSMpMmjrhHxqO5lUB88n0PZBY+OgKxZMMV7JUGORz8Am5sJM3XmGPQKur6Z+OMLzGpnuGrGXNDK
 Ik00vSAg3/4eQB3jkD2OcK6zMKtTSW0=
X-Authority-Analysis: v=2.4 cv=LIrz05W9 c=1 sm=1 tr=0 ts=6aed369a cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=SfIHIsIoJ2N3z6ihRgEA:9 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-ORIG-GUID: zkxllnM0vN261kL3CktI5M1xYT8sMKX4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAwOCBTYWx0ZWRfX/BZsH2xKQjIT
 M6WVUc7i8B6Xcd91LTrphvSM5b8f4Eag6qzgh/2GjzleAFZ006jddivYuHWWF8up0zkJ5octGkE
 dJdPzbPySOa9JG67smahrWtSa6FW1CcNW88zx0IlVtcvO49V06jIa/OSrtfEKY+0+IusEaD3/AT
 MwBwAGdrAic5ir8bw62m8mwjA81C5gLuy1sqwwbhyggv/2NH5Wj92mTJ0MMMM84mtCw/Y6oJhyz
 j33agQmtZuOoT3oZ5lx3lCjsqHNmy23w+TIqoOuviS5ofVc0SG7FR2+Lh2KNfzRZY2EBIpapWtV
 2JdHUcR6wPyT0lqWllM7EQQs8co6YcZyEut9EEfn/eS4H2PSsIMt2VUYIXqS994z3CozsOQdGqC
 2NCmOmdr3lTD7v+YeXWmRWMyvIsakgZwpa/5C75VuNIKzC/BrmyBbE03iCo1r6Wq8CDlEhE5axC
 TtKAOiFR9kH2DlkuAow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_06,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060008

The Monaco Monza platform (QCA2066 hw2.1) requires a usecase-specific
firmware variant located under the nfa725 subdirectory.

Add a new entry for "arduino,monza" compatible string to ensure that
the correct usecase firmware (nfa725) is selected.

Tested-on: QCA2066 hw2.1 PCI WLAN.HSP.1.1.c6-00302-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Signed-off-by: Hongcheng Zhang <hongcheng.zhang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 766ae27306f4..b58dce133244 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1049,6 +1049,7 @@ static const struct __ath11k_core_usecase_firmware_table {
 	const char *compatible;
 	const char *firmware_name;
 } ath11k_core_usecase_firmware_table[] = {
+	{ ATH11K_HW_QCA2066_HW21, "arduino,monza", "nfa725"},
 	{ ATH11K_HW_WCN6855_HW21, "qcom,hamoa-iot-evk", "nfa765"},
 	{ ATH11K_HW_WCN6855_HW21, "qcom,lemans-evk", "nfa765"},
 	{ ATH11K_HW_WCN6855_HW21, "qcom,monaco-evk", "nfa765"},

base-commit: 5c8eab13e391aaabd5a1ad58f3ee4bb10ce7573e
-- 
2.34.1

