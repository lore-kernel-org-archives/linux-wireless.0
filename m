Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793127253;
	b=uG98rBCzl+r+gsJXIRjCIsKRLPmOGc/dRorCXlpc9RgaabgSwT8lWXlDpqf20oUWU6TJ
	 xkfEQCuwTmF5MOFix03NBhPWoO+rDSvQ076V9YFuNldPUwhd1/toOFUnbg6wI6K1A7Vh1
	 v+p3768zdyXmyc1SgfL86IO/znIhq0YIOYlx5yl343GF8bp+dJ4YL6NH8lHDG3poe9+eW
	 rHjqNEcUM0Wf/8N2uM9FZPVx1Us2eMEm9U5csWHg/1lR4xrY5f9CiiwvUjWlCYQhSRz1+
	 PbbmT/1t4iPGmjdaH+8LZjFO/i8NEu42I1XNV4/IT2aYW8c0nRYDoORrEcEsS/BxQVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793127253;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=uefC58gIjwFAaB/VvJkIhiVIo/4advfrCVoMO5wR0Os=;
	b=hoZqcxQnNxrxy9+/VR5jgb4kzsOIVPq/lHSCXLykbJxWu/OVvu/+wCzJRI3ylO823jBc
	 0UG9x2T5l0Qq8+hYSKSSk/ncDrTz7gobhKSc+0CSZ4jn+riIO7bq4LgtyIoQWKhD+yCwW
	 HnDyF7d0NWSrW+WMmw1rshqtCZNvhMhw1WTQT+YSfb7mknjehmKALUIfn8MYt28ztT2LI
	 ntVC85xr5E4f1wPj7gK6cNfWZzTcth6J5hdyx5KQtPoljvMJL4sFPgPcwVQCDLKBGxJeA
	 dgjichu69lDaoLOp+IVobmVZb8Elj715ADd9kuhAfZDdCXwddcHJsnL1FI8ZR+Mb+Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=WQ5xlzz+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kcjixIvd;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214C1606A322
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 214C1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=WQ5xlzz+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kcjixIvd
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RIHR0W2639291
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uefC58gIjwFAaB/VvJkIhiVIo/4advfrCVoMO5wR0Os=; b=WQ5xlzz+8yQe/0vq
	VydLRbT3hnSojbeS5zgoXgiCKQDHM3V7SdCAVlisgqahGsIokCtIIiYYXGg2N4ec
	lfCX6TSEbyVlc0SIUXLC0I/rmt3KPsoDM1ZCK0GM1swXgkLimwqsz1cEQZ5LBE6w
	UdH8oFS9sXFesFByTDgIZITqgXxNqWfPEX1TLntDkRU6o+PxbMSyZg17b6DRt7Zq
	RRQfk/U9k9y9XbGmsd57DSAKFZ3KkfCHq40plkW32v7DaR5TCs4E/MezxRBbCoZ/
	viAkrZO3aA7bSl3RjxgBz0LS+7OIpgqcpcHyEO/z0odKKVaP2g8BofEMUTaUOoKa
	yV0YvQ==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjqf5twnk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:11 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-151dcfb1569so788156c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 11:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793127251; x=1793732051; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uefC58gIjwFAaB/VvJkIhiVIo/4advfrCVoMO5wR0Os=;
        b=kcjixIvdAoRWa4yS9XdWq5yZtYzg6oE18erNiABnsBMPCqu157WxGR52OMcyysv76J
         vHnkL6AY/eGMybzovbq7bpSNNH85Jx8Hd9rWoA+9ir/4HTgnWLsBRxnPr40KAyYdHlJQ
         fcLKmGKXBz6rlryPDACr1OWGzZbU+xcH6nWZ8INmWr/LgmJTGuV5FwCqIXn/R2SZNdDU
         X/+lyUUSlzVxDCrSoeIbDQ8hnzm0zMvSeG+QwCyfLXxEiIjXteGSbCxfBmxqhn6zVH5u
         UkHAxkM9Uv6K0Mh8RlqRgAa1duFSaY3pDrEwHYn98zY5LZrHcWRW+WLk2UwKRAxFWnux
         DAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793127251; x=1793732051;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uefC58gIjwFAaB/VvJkIhiVIo/4advfrCVoMO5wR0Os=;
        b=vKL+W9s4rbD4g5v0gts6R4+rbXM1dn+EijaD6MktwKGAqS1VJf3CdEmv8D1ck0+krC
         38kIVIWdmS0bduoq9MzvAHcAsoJutkaVU1W3CP8Ld7qg9VC0XfdHfmoJuGjkF1gmYt51
         H7HpqrOtuTH0vFc2Ga6dWwXk2tuiCrWh2ZJApn9Sm7BsbKRyehRCTS4uniaw1tnvlXWa
         bHNh++X0nkw1Ta8o/dgMV7kE2/BsfN3ifHzBHI9GyIrh7EKjs2aCalp5WVEvsaOOCF34
         yF2/6EA/yOWLIDfPUlybUsE8C67xXyHgt7QSHMyO+pNwe38fP1qRYIjamTBcuLrgJK7t
         GxOA==
X-Gm-Message-State: AFq9FYLjeNAr9p2KdxqLZrsuilNXDDZF67Ef4Og5r0bZbyXKVPCl9Bfh
	Y8cBbwl72mlRumy8kodYlC7BYPdwka+Ir454pvJTVVJFmYDQ5Q3HZX7HE8aXrzlyxrGX7x9uvFG
	R1LiWSghcatcXcXVk00/+8oAbosan0Sv3bBcogH/KvD9jGrFHL1aF9uy9NcDFTMESbiLQgDXAVF
	Uo5Q==
X-Gm-Gg: AYBFou3m3VP+swnlHAw7B7fYcBd94qkEWmFf3cDcQyBMTRENThUQFPTCvBodtqb1eL/
	hKNje5wu2zHFlYBwD9dGRb2s28DASJ2YYlKX8juEFHwkpAhxDxoXRgqJVRnlC5FNuB9rQLdQCXf
	3ve6Lra+mGzF9+1lMZ+u6dAROLnM7DHfwxsRk9Kp/4Kd6Ng3gc2D+4a0cjwJNWfpb3CJE8xfy6r
	WfxmXBQqpK+JhRy4w0YWUeGAxLjmxwm+AezwBADSqtnIMMzoIuqTKjdJPnFiGz/0wo4NfZUyYpZ
	vGpCgfle3fMHjM7tHHyGGYtQcCOsYjDIW/l1QrrJ7Wk2OaGW8eolLE9m+AZ8VysYVFDBsCmaztl
	q4cGiVmh7dCtNJtBJ7DHKgjaWa50PB8+Q0a5WMDsuZTwbeyQtuy6gZw==
X-Received: by 2002:a05:7022:f519:b0:146:84fd:7b58 with SMTP id a92af1059eb24-1a3c75721cdmr4232674c88.9.1793127250386;
        Tue, 27 Oct 2026 11:54:10 -0700 (PDT)
X-Received: by 2002:a05:7022:f519:b0:146:84fd:7b58 with SMTP id a92af1059eb24-1a3c75721cdmr4232632c88.9.1793127249411;
        Tue, 27 Oct 2026 11:54:09 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a14383b02sm8989983eec.14.2026.10.27.11.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:54:08 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260918201145.kQDy1UrD@linutronix.de>
References: <20260918201145.kQDy1UrD@linutronix.de>
Subject: Re: [PATCH v2] wil6210: Replace %pK with %p
Message-Id: <179312724866.435197.6589341434716585332.b4-ty@b4>
Date: Tue, 27 Oct 2026 11:54:08 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfXyB+3Uym3At6k
 LfLfc7hdos8SPixVFk9yuU3fUlvhuA18pNf04xrJYUw8b+4UllP52aU/M7+cBnPhPQP4TPJ6jHB
 /IK3uYJrumOkJQen2uusDSvo7wKmAUM=
X-Proofpoint-ORIG-GUID: R1MR8MoXiLzfJ7ydbKAk1E6cGhnG0DCq
X-Proofpoint-GUID: R1MR8MoXiLzfJ7ydbKAk1E6cGhnG0DCq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfX5oscLyaStBDh
 0OC9xdwuXtQSwomrUyFRzTYg6fAOrMQqUxMZENUqdI+DlZL678qAbADsPU4JuYTW6RI1MLmOk82
 SlScy0wXDQXYC/XHTsHu65J+Y8qSaReu5YW6UQj/HjS2IUgmyWjjOcWwl3bOM5zybKwhIZ5DOKm
 7lxz+houWDraE+QLfNrRAb3q1coJr7qeiOhqVPRU/Vk8C2/BloyvQ4oqa15BaKRuYTmc7FjLXq0
 7Z1UzYqQV3BnJT+15Zh1Vwc6pH6q+MWNok/RGxTNS7hvx/dW5B3Bi0jNXNU/lwcohYSKapH6dXl
 L8CBkgt2Gb3dlAnKwJfws+JpoNvPWCemGsXoaiT8oZVImGPCSx0ArwilhJqHeE/Z/vwso7nxw/i
 /0XctbnmJfgKxn1FUJGPqMUwNYw4AG8Vh/J7NIkV5CO2BmfSUskCawG0+REVG4zFAKArcP5Uqdb
 0Ru5kWhoGRrO8Dc/1yA==
X-Authority-Analysis: v=2.4 cv=UOFIjyfy c=1 sm=1 tr=0 ts=6ae0f353 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=CV1thb187pRla9qUsHAA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270075


On Fri, 18 Sep 2026 22:11:45 +0200, Sebastian Andrzej Siewior wrote:
> Commit 71338aa7d050c ("net: convert %p usage to %pK") which is from
> 2011 and changed the %p annotation for pointer to %pK. Back then the
> default behaviour for %p was to print the pointer. The %pK modifier was
> introduced to able to control the behaviour of specific pointer values
> without changing the behaviour of %p for everyone. It was dedicated to
> avoid leaking pointers via /proc.
> 
> [...]

Applied, thanks!

[1/1] wil6210: Replace %pK with %p
      commit: e74e01146eaa2764d3a89a296f535b03904d5a48

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

