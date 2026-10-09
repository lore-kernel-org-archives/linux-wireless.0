Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2453655EE
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 23:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589634; cv=none; b=ONjYaX589+vVZMwjI1ZZ7C2QYkQg82Y8S+oKjVhE8edG48ZR4yEl7ecCaaYWrlA5xxGJ0g5hcqLSmqUvtcSUkSMD3QEEulLr4fKRwZaxG5BH26Jg0uf26l+fwLufHFpFJP7Zgu6z0/XtAgaHb8PUC3EByZCRs5Wa1adJsX2INjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589634; c=relaxed/simple;
	bh=9MJ5hn89waZkXkFmJfomh3TQDSXTX+9XbksXsgj8480=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P6IGYRtl+FxAOj67I8GsyS9UApHRwXVQcmI11a2HQmp9uAtdp8/AMZKg3BWr4RFxehgF9+YHHDibsEADdsvJ2fwMo4mJWy1jWj/CghQlRtGpPgIRUJcSjy644rXIGOHf8Pddogx4QNJcqzhVNvlMC+LPI4ZYZwn5NFvFoFX882I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AhRY/OcB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VBD2sXV1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AhRY/OcB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VBD2sXV1"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699NKEBP2174978
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 23:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	orfUOzgOKH2fvhyFNmsCJ3T9j7vjj7UDmnHsEpSvVwI=; b=AhRY/OcB/Oym0G+w
	roAxJzrTfMAX6Mr/Fa8rnytqYCtVqm/IcIdqC/YyS1qhQCzhjisGvCtTAURkaIiW
	/IESqlf6dWy6+9nZNBcpnBqMED1nIenvn3798QhxvSVojPRyTJgodMvAZ1ApoEpL
	J130Qcye4OKE9QeWDosnbMiGvgfo54aClTMWm8oBn5Yl+fqvbm5YpnLQQvWVF5z9
	84A98qcC2A3KEe3P7BrkAkejXtopbIWPKvPr6UzkiVukSD84rJFc35tp40MQqbUG
	SCPEX8brUTBn66VkveZv5qGn6Dd2vRIxmr/ExF1jxQ+1+60bczgLMztNIr931MH3
	T7j20Q==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h74tbh616-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 23:47:12 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-34ef0362d95so528540eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 16:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791589631; x=1792194431; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=orfUOzgOKH2fvhyFNmsCJ3T9j7vjj7UDmnHsEpSvVwI=;
        b=VBD2sXV1Y8n0SNwz/x/Siegju1WYBhYpgnwjHku40uZTJRqyAt3ui5BcXT8D9XxPJb
         Muy0LcRGqLv8cElrCZRHKnoV6hxF47S2JM7XxhVW5kaifOh/JSZRRCoIEGxFJbHkekBZ
         Aiq53X0/sd2Qo/pP2h8+lm/T88G49i180p4gW4/nnxTNWELDnkcQvFQXMkTKvLs7UGel
         YgXfMR9yjwb4qfl0hn94typdpUQ6B/HEH487bm2H3NbiN+jh7eWCjF+RZ85/5HMGCJWU
         axGr2ug5nWD7p3J96g7tXR7vLkeRt5oF3EV3yWIno3epqNrXtJHhBYYQyDkTpMYobDST
         S9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791589631; x=1792194431;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=orfUOzgOKH2fvhyFNmsCJ3T9j7vjj7UDmnHsEpSvVwI=;
        b=TO2qWbAzBMftxaWYc7UHVrYprDcjNXiEcSa9GN51AFOiDs6TDZMZ8J+GygPX6B9FIP
         TOGCvjUsAOPD5HWCrmGjzyJjIQtPwHMOBagPQujru//S9OEvbOo71uB8SRyn3qnmp0HN
         uiihyjiyCyWydUjOTcYC2/LAkhmvhYSJ0V1mxkQXgM/oYOc/DvtZn1Kh2n+kv8vaNzPC
         ZfvaaKOUuTRVVmDwTQhcrYyN2HwRmOIDe4MxpCK+VVAwZrGXNK27r8ObCKyk3QhCICbK
         UazsM9eLFl2M+XxgiYXb8kLBOJbzEQBoRov28/IJudT2/6z9J3L3hAxgFVFiqwltEKza
         uzvw==
X-Gm-Message-State: AFq9FYJUJNrYk7RyIe27gthq95kjomVpomri6AesR6u23aBTIIUAOzWI
	KshAQTL/Xobn4sULjeB3PQtt4KIdGD9TVdjg9/xcXfuVOmGIi+mAA9txvdKys2qerjIJaISTcHd
	KiLnIuBBbmJ/wb3tMf/+OJOH3/uuKm0Pcv4E2ryI1+JBPuz8bfJFM/PCNlvnYbW5zvaFnKw==
X-Gm-Gg: AYBFou1DZL9hzwIfrZ1wAr7cfOcBz/gQDJjlMtSWt2JCOMg3wYSFUSXIMSQb2yyy2NY
	dGCaGPSCtlwrUQXBcd6aZx1SQVyt1UWUEswjwlfizuqN++iidRPqGFmtDcv3AkwQcJhIPDJ7Dzj
	ECeA27qDd3ru3x4P9gCyNIRAAPbF9XpyPrPePQAedDN/XwTVrCpmvzeHOVAXaJNKx+aRL52YKzj
	IxK7g3fytS4PnxyB05wko2zASCWbC+j6JAp5MfntpgRBxnxQwLlze+bzNxgBpoh1J7q8jSBPD12
	VuyAVqw72UrA1vuZf+yyAqxQFGgpw/cgWa91Lb0Hjc4KttnUgyYDBcw8Acm+w6q7mYBg6ZLss/p
	5nahHSTWvPafKUl/e4pWM58iv+NblXm1sD0irdo0dAYVvfH38RAs/DVUdbQ==
X-Received: by 2002:a05:701b:2411:b0:164:3237:4485 with SMTP id a92af1059eb24-16a4e9af51fmr3953180c88.0.1791589630862;
        Fri, 09 Oct 2026 16:47:10 -0700 (PDT)
X-Received: by 2002:a05:701b:2411:b0:164:3237:4485 with SMTP id a92af1059eb24-16a4e9af51fmr3953150c88.0.1791589630122;
        Fri, 09 Oct 2026 16:47:10 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a1dd57d0sm9142318c88.8.2026.10.09.16.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 16:47:09 -0700 (PDT)
Message-ID: <c03cff3e-b135-4125-9dd4-f9e342a02f8a@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 16:47:08 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: remove duplicated STA state
 from link peers
To: Aishwarya R <aishwarya.r@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
References: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=RcEFmFtv c=1 sm=1 tr=0 ts=6ac97d00 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=kiikUzmmTVQhVswUDHEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA5NCBTYWx0ZWRfX8p1Z16qzHtQJ
 cCVF7mHS+lAUjIlAgLm7hadvGXz4xYTwp7ChjIWuphd30gipEG97QBXDBsudndEffop/GI7WIu+
 jsHsxWz7+2twMKTDlWGAVbKqjq1m2VmfTVNwNfVpyFf4AD+SpfSybxzm7RtvQF0XpwhRXKG39Aq
 mag2NVvBogLlHiqANF4/ihxAQQkpbSNLVj84wJ8bFUKBTzJUNL5c4WyBcii0WPBdnV742G/Dgz8
 hgGTdkz5edFsNrjpKzldOIZSaGaYh0uy0EaAzBowRM/qloI4dZKTHVLGpHzNlcl3OF4hd69d1Is
 +GuLRWi4KNC9ktLcyOJLK0b/6pYp/ASWHg2F8Rsq2ihomU15puWnJsPEUrD4uyxTdhMvJTDqlAz
 ur2UVnb7IQfmPCQYqH/Hoxmcf78X623sDxNsJaE0MoeDmqaSaZsQ67Gsrg1NaLJByGlWh8kqJ+T
 lDfYTL6oXQ9VMW4ImiQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA5NCBTYWx0ZWRfX5gTsgXhBwQHQ
 8jrf7brKT1o5SzH0Jqr17dpv+/tXDfayzgozU3RQ2mhLbjq2SrF/98SCLolWkDeAb7RscgYaUw1
 PVajCEDPHGI/Fj5UoMs4UkjGHH+m9Z8=
X-Proofpoint-GUID: N-sImTvlwjUKs8F89m2pVCfR3JuiS-cm
X-Proofpoint-ORIG-GUID: N-sImTvlwjUKs8F89m2pVCfR3JuiS-cm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_07,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610090094

On 9/24/2026 10:10 PM, Aishwarya R wrote:
> ath12k_dp_link_peer currently carries state that is not inherently
> link-specific. Both the station pointer and authorization state are
> shared across the links belonging to the same logical peer or station,
> yet are stored separately in each link peer.
> 
> This series moves ownership of these fields to structures matching their
> actual scope:
> 
>   * Store the station pointer only in ath12k_dp_peer.
>   * Store authorization state only in ath12k_sta.
> 
> Doing so eliminates duplicated state, reduces bookkeeping required when
> the state changes, and makes the ownership model clearer.
> 
> Patch 1 removes the duplicate sta pointer from ath12k_dp_link_peer and
> updates users to retrieve it through ath12k_dp_peer.
> 
> Patch 2 moves is_authorized from ath12k_dp_link_peer to ath12k_sta and
> updates authorization handling accordingly.
> 
> ---
> Changes in v2:
> - Rebased the changes

In my v1 comment I said:
If the conflict resolution is trivial make sure to carry forward the
Reviewed-by tags.

You did not carry those forward, and did not indicate here why you didn't
carry them forward.

Please review:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes

In particular:
Both Tested-by and Reviewed-by tags, once received on mailing list from tester
or reviewer, should be added by author to the applicable patches when sending
next versions. However if the patch has changed substantially in following
version, these tags might not be applicable anymore and thus should be
removed. Usually removal of someone’s Acked-by, Tested-by or Reviewed-by tags
should be mentioned in the patch changelog with an explanation (after the
‘---’ separator).

If the v1 Reviewed-by tags are still applicable, you can reply to the cover
letter and add them in the reply -- my tooling will then pick them up.

Otherwise reach out to the original reviewers and have them re-review the
changes.

/jeff
