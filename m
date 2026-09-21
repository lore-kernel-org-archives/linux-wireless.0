Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A61C2367DF
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 03:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789960636; cv=none; b=k3UZuReYsZc2eRYImrfUTFeZ4IEHvmFxp3V1eIHuaE+MfP/felJcW27vkIP/t9u/d5M2jYZtBaznzGCe//3H7w9e2FCXK7UJQDWzyskCCyM1GfjUqWj9w7o+e9bzcZc6MG8HWw0oPhTPRGtsUpoyQ1CUOqSSKEVLCNwIq1ATQnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789960636; c=relaxed/simple;
	bh=gt8sPaxLPYaXUKUkJI1qSSKVhWtta+kMkOc5+Ye2iuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=foJBpdXZWBaL0HaOeTxCZD6f/C/IgkxD2qwePdS7So2pXL9C6R6eGipLlWSpsZimvJacsjKadmxtsffP/fAbnJcS/Rh3vNo7qOmtbzaaFzNzggJM1avLHe4cGaPwDieOwq+TfUrSekuKwWxFq9PhFFnNTbEGtqjWc5+L+5slrO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YrsXGJtz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Cl5+MhN7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YrsXGJtz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Cl5+MhN7"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L0kvBf3197422
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 03:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cYt8LOSON/JsGZ2ak1N5nI/Npl3t37NWkKDiiRq/YtA=; b=YrsXGJtze1bTtQjB
	54fIcsSgtaQbQAhttkwdDJ/7E3ussqxqXEr17889ChwyvuW7nNRWM16F/uDa5qku
	D9PpwPoiaTM+PngooLSiL9vH9ublSb/Lijfcx4lqWSmy+Su9udPzAaJIG58Qfu4T
	wX0n2lWMn1F4DTpNrjXvF0iIkijZB809iVRkY/v2hevYBIWIGY0DFzBHdidgiC2f
	EtzbKYai4s8/Mgt+71/XWMgVYuGHy4m9QMndKXmKO9fLeqOh3eh3j5ZG6ro6T/gr
	/KehjtVNYQ4jLQBNX7DUr7b7ycKhG/5jtmYa16nz7QwYZYfohyA5PDDgATjc/wLW
	iiQ5JQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gsjs84dhf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 03:17:14 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso3496796a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 20:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789960633; x=1790565433; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cYt8LOSON/JsGZ2ak1N5nI/Npl3t37NWkKDiiRq/YtA=;
        b=Cl5+MhN7W/1Z6FY9TEvfHrdyeABcD7OhrfkX8mBqM05zfiBtVFgsfqiP3w/91D31QE
         JFSbSVEdjmTz0K4YnAaY4bXlBrIKf29gnvTXAWV63IxtZT06PjvvlaOKabRxuTQMZzmu
         NSmnQ/m98lG8jlMb8y8w1ckIL9V5VxyvsHvi801DFVhL3S7GGud3e9MwFOJxs2cWoMn3
         v6lvMIjCvNr6FJ3FRf0/3JmN4mfCWHIJfkbLCW4nwxkH3cZkXTm+mNDxunDgamwjXYPP
         +8ext28uiunpMghHNk5b7iJvwM/8bzP4bMz4H+ntlb2l51thvekqlj8EsrO0t2Na6yER
         T8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789960633; x=1790565433;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYt8LOSON/JsGZ2ak1N5nI/Npl3t37NWkKDiiRq/YtA=;
        b=erGB2S723VkdmfmwWOhXeG2fl010qZOFBAnDjYEIvmUoFNwqTNAGJQiN8u9fUv/Jp2
         iRyGS9FR5Xv3gateETlGSr/yWnCDLQ1fW60me0XmVMEVvKkwVczBbFPngBiwQ02FY2Xj
         qD9QUlZoDU8kft8YYT+8NemsFePHjA9iAAYfzt1eFnTs40SmSLiVlPaY1Pln0+M4mpSi
         XidCCx5tk4O2LhAIEo31Yuwr0d0aH9qszuRW1ZW93Fa38DAbWZOh/PjIaKuxMTUt2DVP
         7+I64uMIEAy2kI22nHLqL18SXs7vXKreUuRCwEVPyX0iSto0l6LBWvZBQvOQ8Uzbc+SL
         pAmA==
X-Forwarded-Encrypted: i=1; AKwUvBx5z0y0uXs0uHwAFgJE9O9UfMJwZAh4aAkpt4bPcKbzbBZSZerxwmYCAgyPSclt/aDrdAg5VyXc87XEXFFFmQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kMs16XkqFyjngL+/QO1UV1ltuKv90kzDKHlgB2hhqW5O1wDGlx
	GHyl32+FLM5hXaYT7FXzw9nl70RNKLKLoAMkLf8bqaYUTSdpGT5F1Q6mTXN1prv1aZEN+kWeSr3
	AB7U5sIHuz5JKE/qf0LRGDSQdcUcwRVeVkNosoDbiwBDyqXmP3L4EeJMBpjzZQ1vowXXuDA==
X-Gm-Gg: AYBFou2W/Mw2EsunyoIw6C3nfv6UV1xhphiYaf/e8OI9B8cWRgn+BKu7nNzUc/X4HJw
	2viCojMCBCLk9FP0/qQtQm/sJ98GtnMbrqpjk2yzAejoQjznKGA+WxjgkidbvEK1f8V47ITSeiT
	53CQqEqtTB9KJq/dPqLOd15jHF9fwiAxzxlbk070o+JA/S2S5qJ8u7su6UgFh/XtP7/C3KKj/AM
	9AHzf06aDwGSov0HvtadLdNmpgSQUIIjmaw2fvRetg6YjWPyeaY1P0cK18yNil1e5cQ29LfaGbJ
	1KWp6WGR3IDQQZZHwF6qoEB4wQHe5oNE9/I+jBpU/f1OA6uewDJ82Wk2aTA/z9eZarKobgW4AMg
	XWB6bWkgwjRReG6WEk6j3JVkhF7+Lqok261IPiDw717I6+2Ft3uZZXiYfxyLvLi7U2Vej2k17
X-Received: by 2002:a05:6a20:a10f:b0:3dd:a196:5392 with SMTP id adf61e73a8af0-3dda1965441mr9479666637.52.1789960633201;
        Sun, 20 Sep 2026 20:17:13 -0700 (PDT)
X-Received: by 2002:a05:6a20:a10f:b0:3dd:a196:5392 with SMTP id adf61e73a8af0-3dda1965441mr9479640637.52.1789960632788;
        Sun, 20 Sep 2026 20:17:12 -0700 (PDT)
Received: from [10.133.33.161] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72aed5c05sm2662578a12.22.2026.09.20.20.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2026 20:17:12 -0700 (PDT)
Message-ID: <358d7dd0-20b0-44ee-8b1e-a0cc6cb40abe@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 11:17:10 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 2/2] wifi: ath11k: disable interrupts during
 firmware crash recovery
To: Julius Bairaktaris <julius@bairaktaris.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: jjohnson@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
References: <20260726221908.104873-1-julius@bairaktaris.de>
 <20260726221908.104873-3-julius@bairaktaris.de>
 <CGME20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3@eucas1p1.samsung.com>
 <a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com>
 <dd342f3d-36d3-4a85-95ca-6cacb7b834ad@oss.qualcomm.com>
 <10491411-b500-4e89-bf85-5142ced60aaf@samsung.com>
 <CAC1t37Ltrh+BBaEPi8grXnMrDt3qGDH8BA56av-h7=yPCCk0Nw@mail.gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CAC1t37Ltrh+BBaEPi8grXnMrDt3qGDH8BA56av-h7=yPCCk0Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 2rMWizXkyVECrzaYh4ohzeTNK9OtCybP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDA0MyBTYWx0ZWRfX0Enwz7mG9oZ/
 1MKTkcV07jxg95FSt2yVC5mygpIsB18gfr09ev5sN2l9X/Wn52eWORO1EsickV/oeS6Oav5bqYS
 f78huvW2/6auPw+ikDAZu2oPmPPOaYY=
X-Authority-Analysis: v=2.4 cv=YqWa1IYX c=1 sm=1 tr=0 ts=6ab0a1ba cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=19USHdIQmY6s7t-heMEA:9 a=QEXdDO2ut3YA:10 a=D25mL4rx1t8A:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDA0MyBTYWx0ZWRfXzSGJQB0UOmuD
 IaF/B6i87oUJF+H0+OzNbHEWMmKSNE34uBWaClHevFhfquNyZ/DiYmWBnlUh2A/Xhe2Rx+XWoWK
 CnszHAtLup5LAeV9q28P6xKQxXJU4jBrlmYMnsVp6pxMJyAMPDdR5dZ1vP/f3YAURqkEpEQoOYI
 ZhZ4f8A+8HG+aWVeurXP5PlcxUIa8FO6rW/dypdLPvN3gt+E1N284VjnCeqvAe7US2ARcTUuvD4
 7g7ExZHXK8zoRTigWU4VTZ4feNcjWvF8fC6/09MonKRAAwxpOZtkIZbA1Vk7ZYWwlgM04vLL1iH
 Kru5v4+Q2fDvyCSWnuL4UL/y9sQJLOgbzSN0jLsObbSjyeUmR2We22/h6G16WP79CKau5gs7hED
 hO+PtpbVVFKR6maDFRh0/kbT/VZaJLgBAKFLOy+gULxUJ4DB+L/csRUJD0zwqyzb/+B2jC26aPP
 fo9dr+BMRc6ioCOP2Rg==
X-Proofpoint-GUID: 2rMWizXkyVECrzaYh4ohzeTNK9OtCybP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210043



On 9/21/2026 12:42 AM, Julius Bairaktaris wrote:
> Hi @Baochen,
> 
> tested 5 times and it solves the problem. Thanks!

Thanks. Can I have below tag when I submit the fix ?

Tested-by: Julius Bairaktaris <julius@bairaktaris.de>
