Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400083;
	b=BlTjLNCg3v/QeJ15h8qSViu4Ciw2KPJHfWwTN5Y6X6XXjpnW5uHqZdqrwS+98oud1mFl
	 NSgygAda5urFe/JHTBBkHzh2QXVmfIYlzcofZWqcDcour0UFxoNBlN9IzZvifwBIBRyA+
	 3nbt3nTzQqZ7pSHt5JIi7r9Kf7hDt86Vy+3R2EqB62INWAaYhKTSwA76COFa+Or3+ZvIQ
	 b7wANSfr06/z1PoVNrqCpfL6ui4t0asOdp3d2whjRJoqqo1IbuD8Fj58Nm9Rl97tbLqAb
	 H0A+jo9It7tR1EirdQsYH9tzqNwEDWzOozO+vBDbtsQw152bySmsyIAiKYW5qNWEhuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400083;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=/M+guSwoUUJbW4+q61V10waj+erZ44ZYQ+J9aHIJa7c=;
	b=08ewbxCtauefGQ8Pc8QqsmeJANlx08uC4yEzok+a0mb5RaKBFu3b/qBdZ+8Ca6406CRF
	 3BwbE4JwxKmAV38jbsSw10mtlFUJldWymVfaJ7NSN0PaN3W6mLshXEGKnPnXymMWnHBkS
	 40KyJHIl4ohGLmOwxlcQ+I4rZsqeIOH50OUy5Nac6rDZ3rQY1IuakdVatmbGAO2+eu39A
	 N1eYVh0nog2EDk8gtjPL8cXkDGf4f4CZCkeqLLBV+4qMNZVG5IX3NE70olZ0dLLtWnCgA
	 A8hb2LsSQnC1ISScJRNzsMdyYOQ+FYZNytzV62OKgfwy7EsbJNjBxvrQSkNC1+IsBqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TLFfrCNj;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jooJld9j;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578FD606A31F
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 578FD606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TLFfrCNj;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jooJld9j
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ULtM8N299760
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/M+guSwoUUJbW4+q61V10waj+erZ44ZYQ+J9aHIJa7c=; b=TLFfrCNjrTTxgqnn
	jxpH7DzAWxcamJvHJR3iQMrEe+bf22GGqFX+jDICN8vl0GxobHdgU78l0HJi8K/2
	UVw6x0zkbgmPoo/RjckWL77qFrlxvCzxDHB1AsA0ScbjMw6IyaVCwiNwB4r4Thqg
	wc3x3HMst9G98KvAC8+rTCK/P+iWoquOVRybUlbNH/1/lwOkb7aBH72QTbSa/B8h
	w/bGHbpMpC5hlSksroN+cR25Seh/7kmeh5xOZSuQ4+tlhmjMF1p5h7abAxOlyRtY
	08Vdx0U6ha9eL1s/k2dwU6m+8/0z3cxytsfQxlk4eviPJH7gQfc4E0LqwvlcksAY
	1jjjOA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn2x0g92s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:22 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36a1e2485fdso2882204eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793400082; x=1794004882; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/M+guSwoUUJbW4+q61V10waj+erZ44ZYQ+J9aHIJa7c=;
        b=jooJld9jQVlLB8yPP6gkXlrboPYRZ1VS2QaTAddzd0mwJ5ik+7BRmp+p27TuriU37N
         2SudshpBooT94CeQt0wEfpKA/p8iwtiQ9oM0KWvKVi3I9y5Xwp+cNMnqDNiqGkVFoIXU
         LGNeLvVkowIwT3yT4OaUuX/MlV9TXlcEsHOMKF2fh4ozSc7sFqSUXRgqASBzG19pVwMi
         Kl+n7t7vF+L84X4v5x+speCZzX7yWe2zdq0bP6+2NZ0dKCCtIopsQ4NVEI5I/92dqnjw
         s/CtrbHeBEHyOWsUnFE7QZ7+wR7ApPXX+aL733UM4pD8xXBoSOxHRN5JAf8miIaGTRcS
         UAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793400082; x=1794004882;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/M+guSwoUUJbW4+q61V10waj+erZ44ZYQ+J9aHIJa7c=;
        b=AWuXdB4ifB9QDPN/VC07beDpZKx3zydh/Q/KAH82nd22VKi6q6gA/7P6G7cGhM3MLf
         uEA7yHsnP4Ax/TYuZ8Jy2yVUaSyeFW88Z6tLooIHiiLwxOeSvY+9NfwCyybyYPPyf2tn
         nNwmWCMPv4iExVpEFh2v4xJ1stT4buCf3UkAa66rLKl3M2r1mxF+AhNnisSUukmyabWd
         WybtFedZcVS62pV+Hzq3DiL/VdnPtNh/q/dO3eFJ2MDYnEUiB8ELn4uGbrHDjAwIBcKT
         dP381/dIlMRNUdX1lk9LrNpICpc/VCyYawJixZjZGRldn3RBITCBB67AaKRetz9Y4nfB
         8r7A==
X-Forwarded-Encrypted: i=1; AKwUvBzTSGrENypWtbtbNPW6rIryGynRrsbPKb0hGrwKlzi0CTod5C01OOVnwyaU5Mr4mfvWVnDYENN/7xgQk+bPSw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6uPG5133VlXAsO4wp2oPVP7aTM7RZkCahiYk2ULuOLHoiQV38
	Qvk1J5XxM+rpXCCdjJuLdmr6slSTsLKiDMrtv9bf2+bF8YpIr2cSKx3Ds2D2fjp5d5Hi14C4b33
	6yTmYTKYPsXenGEv58B99+DLvxdXMwznMysJUiJRd8JgYCKvAJ2GsgC37+u1OwDfE1bWQAykE7Z
	V0dg==
X-Gm-Gg: AYBFou2TOwh0KzYAVePCb4X5UE43cE9vYKW158STlW2SfZURSWXlpaI1gjehz0/ilrv
	oifxHQUlS8tHwIZjM5lJEPmc9B1r9XNtPGPUxBnM6NsRT1NVEMh0OJhHQ8RFj5vTRYRDji3Yjhk
	gKT3eMLtjke8FMsElLWHGcN47+lgW89vIJI0VbBHc7l1/p0WQiU0asDt3hN8C4v9eGK/5BefSWH
	mTGNCOU/QqZe9gXaKFnBs2Xgr9SLR667DCHOXtiZSkWctOdmHIogxA4BorDuoGJYngbXXllB9Jf
	IppUYLKJZeXz8VJfcS7g7bAxFDX5C145aIhIh3QWFEA+NfYfQFWLY9c1+Uuwu67WcBwSpeKamFN
	Y1XSCEkaZxS4N0smsIqrnR6hhwOsu7WEH7I47dtWbf2BVfdcSkU/RrBUNTrCnnASlw3poEYuv1i
	qsEGUz+2EpU3SbiM/P9KJmAH5t5js=
X-Received: by 2002:a05:7300:ce86:b0:35e:a225:3ba6 with SMTP id 5a478bee46e88-36a424011eamr4570383eec.13.1793400081603;
        Fri, 30 Oct 2026 15:41:21 -0700 (PDT)
X-Received: by 2002:a05:7300:ce86:b0:35e:a225:3ba6 with SMTP id 5a478bee46e88-36a424011eamr4570352eec.13.1793400080933;
        Fri, 30 Oct 2026 15:41:20 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42935b4asm14002245eec.16.2026.10.30.15.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:41:20 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Ernest Van Hoecke <ernestvanhoecke@gmail.com>
Cc: Andrew LaMarche <andrewjlamarche@gmail.com>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
In-Reply-To: <20260907-ath12k-calibration-variant-v2-1-1a9d6c47dade@toradex.com>
References: <20260907-ath12k-calibration-variant-v2-1-1a9d6c47dade@toradex.com>
Subject: Re: [PATCH v2] dt-bindings: wireless: ath12k: allow calibration
 variant for WCN7850
Message-Id: <179340007978.1790611.11188538641227151930.b4-ty@b4>
Date: Fri, 30 Oct 2026 15:41:19 -0700
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
X-Proofpoint-ORIG-GUID: -QOUbuDM3jlFD-1S9VmguiP7m_0k3Zl1
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA5MCBTYWx0ZWRfX+ZT4SurjC+Uz
 QKVpWTE73CqaAEiFZ+UUDwPnDnjpPBOnbne7ize2HlHT6DT3JobTuAPwOWZp3k4f87J8z75K76p
 lxPFoNnqFg8OizZ6Xrg9d07IDf5ebSk=
X-Authority-Analysis: v=2.4 cv=IpyL47/g c=1 sm=1 tr=0 ts=6ae51d12 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=gIeeTYuhQ723c2I_zY0A:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: -QOUbuDM3jlFD-1S9VmguiP7m_0k3Zl1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA5MCBTYWx0ZWRfXw8IX5OIBTZBt
 7NGqg3VRwyvgx4M/0zTq2s+mwvWup+7P5FBIyAEQ9RcbsssGXqA35VXJZquwWNnVzw84VlMuJ8t
 hOY8Prt/VpMTa6Gt+1JFnnIMRL+2+RLbYAXdEJNEQgKXctP6CvT5PLKFLK5UMPhQ3ZajfyvI/NG
 0hq93BlRx3wwmrmIAtdIjwZ1keMOHBGPMndeqPYAO/b66gdx82j7oUHFxcZA1gOTxvVmnSeSWxK
 +7r2+ctihQLxsfXtBK3MmqJnaqEEpr82nPr92LDWxNergl7y7c9tf2llNXyn34TNblx35/fhtv9
 GKWudJEmJHBmHlem3leg4X5qx9+1Ec+xCSr6i7lSHR5xUScYYs3qC/hQVxOHGNThOQ+xbzAVTFa
 mvs3lmv67vtCK8QBb1s4Jn4vp+5Jv174f/5n42eV8T/PdCIQfY/zbhVqYhfYMMYKOowZUoHpzng
 f+hwc48ARIFvgBiH65w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_07,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610300090


On Mon, 07 Sep 2026 16:17:20 +0200, Ernest Van Hoecke wrote:
> qcom,calibration-variant is the generic Qualcomm Wi-Fi DT property for
> selecting board-specific calibration data when the device identity alone
> is ambiguous.
> 
> Commit 06cca100ad08 ("wifi: ath12k: support calibration-variant from
> device tree") implemented support for this property in the ath12k
> driver.
> 
> [...]

Applied, thanks!

[1/1] dt-bindings: wireless: ath12k: allow calibration variant for WCN7850
      commit: 75bc725cd92b2b4dfa76850ce5983aacb52d894c

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

