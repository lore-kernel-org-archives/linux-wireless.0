Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7967446EF8C
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664151; cv=none; b=HpcxxwmHlMI0gkMV5Zy62E1tGTt+qquAa8sb1JNeLKQ6O9HcFiVy1q3c3e5/hYn95E5knWxP/2sqjlXvQGIigvR4HlZTaniLoEedd8JWkA+LevaZ14t0I0lz6WXyM91+Zkc6WpYMDZdrUgTZHyVHuShnur9A9ovBXQtd7XgGdKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664151; c=relaxed/simple;
	bh=drIwCRA1m6B7joPZ0VF4v47Lb/p+DVjBu4yj5aT8CEs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Kqp/XTt1Sf+/gYHnYdSESmzIthXOpzdpb9d/ebvqAt2yX/AP0i2cWC0CJ2kr6S1btQD3FGBafePPMJ1CmAbIXknCEN4G2H/QVUdQgsa4eZCwfRsvw5iM8IiS3IZARtktmKbeK+VM5jRAPxpHkOJSRUxlANTOgvia1sn5mmvEHgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VropzCQI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GRpm26QQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VropzCQI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GRpm26QQ"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LH2eKi2280248
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	S/l/yMHdfHJYVnxHTo5lq7Cthb1xoSc4Xg7Hp7LSLv0=; b=VropzCQIOzC3O9Yv
	Xoe634TjSbnxpNlJ5kr4utpx9tMRCawCXJGibgnhFdCwslp+3FNtai9Z/6qDlSyd
	qp6gBzOMqPOLqz0HjZyzK0roGOSrxNp9upQPYMhOTMNNS/WWYv6DSkhITXhIbsJR
	MRMFWUNMVxkH3uSVKjFSCecUXIGHpRjtRr/Egx81GFT1IEQUNVrscAeQ0ChXkv4m
	+YSx4+klw1ILPN7RqbmWFfFWpvLb7P7oeDAhdlnrHXpZs09ZJN+DW7MnGKA8XMoM
	QR+BtDt1sLar7sSeDOr8Qm+bJgDx7Qw1PW4ycZAkPK/1uvukcgwB8P772wJQ9rTW
	cUoXRg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6paase7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:28 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c89704da8c7so16950881a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 13:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784664147; x=1785268947; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S/l/yMHdfHJYVnxHTo5lq7Cthb1xoSc4Xg7Hp7LSLv0=;
        b=GRpm26QQ6HL4LBUuij9Eg3WcyZ+If4oMAR4SqyeI8w/kZSGDZLpu9Mh+BEpod7dMfG
         TaSxVCHufgejGet7yDTW41OqjLVnST3hnkRTYQ2NGktcKhLdHPt7YXU4LuVNf/NF8hk0
         8Nw1EDtegSbIU/ZtRino/Y3U2K+gvUJH5vRPimbgSWroEE6qSTPJwTytjsjhqtV4V2Ld
         CPxEBrkENzLEUwbTB0JJJ/yVuc5nAJHc5TqrKmTaMRlZpkm0vwtQ/vivItXSc5jA43yN
         ZJKKSt8MwUr97R9DzR2d4OBMrpa9Nf1Azi/Xo1G8K1bXRAFCI5QfqL4/5A0AM1ASiVT+
         tYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784664147; x=1785268947;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S/l/yMHdfHJYVnxHTo5lq7Cthb1xoSc4Xg7Hp7LSLv0=;
        b=q0bn93Y+5k2bMAX+3j6c35WhNg8IDbGdn3LsTX9rJlbXfO1AqYSP75KndbYMem9H+V
         cUhQN27p56rR7YPnLp46EboxPBs5S6EVdVmdm2JYLVUNRnYi81+C6trI5sAg2B2cLw3+
         waFlMs/nkFPwr03ChQ9DLy7NNpe0Ip5YtxxnD95yEUutY5LYfJHpsOkPjeAmdoCN01G5
         Z6f1W4oeO7q7L9lO3U5XqOGPec6pBcCGFNIw8LehnadfX6MZr3bNWesXaPZLymVYCILS
         3Zr3FByX2FYmaJA77rQ0IJsLjtp6n3KIKfLe3SWYEzV151+r0UYBqsvhfvPMPk2bBR4/
         Z8Ag==
X-Forwarded-Encrypted: i=1; AHgh+RoJg5agK470wyP2oDfm4qwrfIrTy9smsGzJSoPi879IEH8QaHsDHkuhtpComj6jIVQxDdmnA0sQy+qpwDEmtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtWE8q5h05rYPl51S2ojRcBbrBiZqD1/fqcfhusvnHiAbMM0u7
	szFisPL4MzJdoCLDbt9BIxTXqjIn7B+TOBbUG6TsyQHX/vbsb2rPiHI/2co6cawaZ92NyyO2438
	EgrOO9RKxkIJcEdxwsFN/V3MGx6D0XR/SuWmmBL4PTD3Cxloj9yoetHeUvM2tJZZgj4r44w==
X-Gm-Gg: AfdE7cnd2VqhZCjvKJDrJmwrh8jh6R4d6XFx0jMap6HUCePW/SPohucgxNyq9X41JyZ
	ky9mKte8B0ZyRkrBKlXu46a2/3ckqm5ZZmGS+z784dF612PHpe0Mx7nu15nwkaPdC7nkXvCZOuC
	9NDUpSRAt52NJ14mANetjbWLRToX6l0zGs1u0ZBJ/aMNSKQusQG4JrG9GWqZnJ2kPmURu2lLqqk
	oKwUwEK1QTl1Hj/wX21TcEPGnBlCHD4PZj75o/Vnezqk7DWOTH94i5WQTTPFfeV3jTLusLYPw+c
	Kc7+ZuY5odwNR6HMhw1wCAwfzsIsai/xKU+5NzjJ0AMOz3R4ry9nyHwJvhItJl7QMEstRpfnJPp
	PDVJOrD3AYjP7doocMLmABPV2s0BM6ftvUyeKYjK7UkcW5g2zLDUmRoI=
X-Received: by 2002:a05:6a21:103:b0:3bf:5b7a:fc8b with SMTP id adf61e73a8af0-3c3ad2e1915mr20894025637.0.1784664147095;
        Tue, 21 Jul 2026 13:02:27 -0700 (PDT)
X-Received: by 2002:a05:6a21:103:b0:3bf:5b7a:fc8b with SMTP id adf61e73a8af0-3c3ad2e1915mr20893974637.0.1784664146552;
        Tue, 21 Jul 2026 13:02:26 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc1b99esm1574958eec.3.2026.07.21.13.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 13:02:25 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: jjohnson@kernel.org, Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260713020359.3618193-1-miaoqing.pan@oss.qualcomm.com>
References: <20260713020359.3618193-1-miaoqing.pan@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath11k: add purwa-iot-evk and
 qcs6490-rb3gen2 to usecase firmware table
Message-Id: <178466414537.1747165.2309463198619583565.b4-ty@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 13:02:25 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: 3zfbCIYMvictfprsT-74LKiQTONfwPFG
X-Proofpoint-ORIG-GUID: 3zfbCIYMvictfprsT-74LKiQTONfwPFG
X-Authority-Analysis: v=2.4 cv=eYYNubEH c=1 sm=1 tr=0 ts=6a5fd054 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=oIn-VHLTOPPjS-blQnoA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDIwOCBTYWx0ZWRfX9NyTke0wl2RK
 oslcFrFTllkQtQzxvV3prHtnx7Itt5aoizfpp5VvU9YOkusRZBXuxS0sw3eTzV7LOQ4lRqJJzUy
 rqgL1Ctq+LrD+V8LlimxWu0RChIwSXJlcozezSgpAT4Cfl55R6tap+xbvsBCqhQrzQUg1EQsFQ9
 cftynxjbUYnbo6RNmWbvByZtp/D78cGUMnqBLpeDvvzJLfda795cC8p3oxIk85zTagO3GcLHdJs
 p758m1/pEddAACvm8nKWX3VIVU/ilAzQvz3GisfeA3Qmrx0XFX4qv53kupgmHNzM0rq8tMq2Cuk
 upzSavhxJo6tHn/xHoyVrMCzrYgi/1/oaStAhTPBoRR8iozPAs+mN/ugFhhuNbuwrsjz74KXlWN
 uBD+8p7MMcdlgZ6Q1sOkA5UgB5ihso+sbKzuEyzQ3eh2E24fJOc+QrEDcoT2jcme2LaKPvmdkIy
 rwbORuFJ9WQ81MUd//w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDIwOCBTYWx0ZWRfXzq1vQoMyymCm
 D3buILjt/0DohnANJEeywBAy4xnK8yEINGoQISIyi19kl83bOznrjKyjwXTX+uhZ5/LJIwmlQ4i
 DCr33jyC0DoeHL7+oejBzTUQ2Sey4MY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210208


On Mon, 13 Jul 2026 10:03:59 +0800, Miaoqing Pan wrote:
> Add purwa-iot-evk and qcs6490-rb3gen2 platform support to the
> usecase firmware lookup table for WCN6855 hw2.1.
> 
> These platforms use the nfa765 firmware path for usecase-based
> firmware selection.
> 
> Also reorder the table entries by compatible string.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: add purwa-iot-evk and qcs6490-rb3gen2 to usecase firmware table
      commit: ca27e3c2284a7a43ba390ed5ce0d68b3c869c0ce

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

