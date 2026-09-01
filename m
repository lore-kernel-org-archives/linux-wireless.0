Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6343D890B
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 01:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227581; cv=none; b=jXIfENB+pYGrYmJVu2oAzw1zS6QygRO4i3JksCGKR/BDc4gUIZ9sEAknVTwb0kNjnBRFv2n4J6LbQAkyJkkLdKYf6HjWkDHLONG++6h2Y5BCHZs8l1whybKqTALGEGsNR+aY7k6sUHcYceNqhtlOAe9I6tbr4/s2Pxh/BAOoO/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227581; c=relaxed/simple;
	bh=VUwZU7jWoZ6qeQcd5+n/BQiIogXblzniZHsikRu0mN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kL68hy4En3A8xJBUWOEU+tk2FynY2fifpGBws6u7o9eDv01sZLBC4rIxqG3FhyAOr47GLlkkO2xnEaass/e9uNDhhbyc1qbxqbMO9XGAP2+Bhb2IG2/FTKlRp89SYwK9hzFGVut5vVET77N58VIxSYI+vbrvL4S2iKw4bJaaHzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=F4UdnJWs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I5h82XV+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="F4UdnJWs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I5h82XV+"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6810o60d500209
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2026 01:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HthPli1doBJ3r78ciQ2kNfx7Zf0urz5E+Lq2coHiadY=; b=F4UdnJWse8Wo6ew5
	R6u37rQSAUg0/2vPiAvQmwnmK1KhIW53x4xtnPG4+5WSClh3+na15cFmAu9ury3+
	xosxq2M7PmHFyCdM1y7+n1ECcoFD/RGSz1COfySCRBYZvMV7fIfChLZpCX+pJqLc
	Tolh1S/6n3lpjDrL+PUlugd7UArkgzjn5ytAFvb3pCWAaW4KKC+GbKHjIyatalV9
	QDhvPnF4yr7XSO26LKCjt8r76FqU75HLHWLvMOkSafg632ZvVAVpRXYNihYdYxLJ
	cm5k0rRs9PD9b0afbIrEO90UqVgdO8LcY6h2pRVuvvfwi0fMdeJQrVTF7OIO5VaP
	eStxPA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdjtx0kw3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:52:17 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so7176151a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 18:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788227537; x=1788832337; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HthPli1doBJ3r78ciQ2kNfx7Zf0urz5E+Lq2coHiadY=;
        b=I5h82XV+5FkrQJrGanJ9O4nMA/a4fLbkrC6fVQ3Ay7yfKIHuA+syE1CUbqnSh1v3JU
         Lrza5TR++Pr2U9o+IaOY8mUeC/gbMmeBwVZOqHg+Zee7uJqr3W0VTt2kj9bZGD0T92BA
         uYeOFBWYAwgqdHy7o5jkrfoMCctsSrKIWq/XpN7lsC4eFKyPy1zDlS0pN3aIiiX6T2XA
         /RVSeYQTi6YJypH26Cn+MPeDlKEzh5rwFW15qQNGQf1scG1z+E5hFFEVTvp1eDsI2wQK
         av6zgFKx7a0wWRHn06MdCGoaxDegHM4xXO2vxE0fUWjFynpGiudEEhNzQlCNM13ZI0Va
         pt0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788227537; x=1788832337;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HthPli1doBJ3r78ciQ2kNfx7Zf0urz5E+Lq2coHiadY=;
        b=Y5KLH+9g/ejeI4YoqjPKFVZL+BzjjD31uNht8pRqwIHgKTUmIfTkvgMsnSyo4DMduG
         I4efRurA7WhExVlm6QVDakesWrpq6qYqoJmhB1qwiZwbPy0L+W/L0MPkcvHjMTxOwh8c
         8W4pF5oLfoz9doUnR1nYFitdhJbvQyM7UfepVvd7fb6KPdE8LJCJkKAnZYdrN2oGTM1v
         MUJAKdEB+NC/rnI8uSN6DpcPfaa1QgOVpO/7iNx9zTttwlNYYbrPAIhMwg6zF8PsZgmN
         MZCMoWrCd1/fYG9Zn6Qm+lAuqmUmOxhXBp9vBDwhveELTgeizV+akihcQThax7fz8l/W
         u/bA==
X-Gm-Message-State: AFuF++kRZU5NG/PQHy3Tl4v86KAX7AxjWCVE0CM9uGT8S4GOUBPzE/Y4
	Orflr0cfZbC/l0tkaiOwjmmEQMLwuwjpIqb5SPReUcev4FJotm1JZcpwn2TJSxuC/HklpXdxdrh
	v3/daufMBeOFR6DinCuHlvKLSMgm8l3NpU3lkIsyIptergsdwqK5nedmwn8pPLgJ+ss6UCCc7Gt
	3E9g==
X-Gm-Gg: AYBFou3FYXLgpVUECksxA5XWbXZKkxMNrqc7KVcIOwyaGShjLWImgsv4IuUa7N74rW5
	6x5CeAE87qM89mIb9HyWsT+tgstECzEkaHOLEebu1eGiWXahj6swrEHwOOMXa/i8AH3eVf23jyq
	R+pBg9EahXCuWzLcVxx4kM37ghOZg6FFQsDC+3Kx34hTGv97p1QvGwrSjk3sZzh6cNqQA7ov6xU
	O5kDSAi13dPtmfdtXbt5lX4uA8WM//4KYIkPeeQsnoquzUR1nI0VvlDdXCAOHwhOwFGjLn3F3qj
	ILCt2YO5Loqgqsx9R/HEMymuiYT66KbtAk4rvdoUpiB9CfMybJ4hW3cVl/jdgyWsAL5mqidmHDE
	Y/WF8KnQCyryfwq3AGH28IeVUPzsRbPLcqyijRrc3rm3IJDzMzAg4/jQUhilCe9EMDwcG8sIB
X-Received: by 2002:a17:90b:184d:b0:398:9c00:29ed with SMTP id 98e67ed59e1d1-3989c003c3cmr33405066a91.21.1788227536782;
        Mon, 31 Aug 2026 18:52:16 -0700 (PDT)
X-Received: by 2002:a17:90b:184d:b0:398:9c00:29ed with SMTP id 98e67ed59e1d1-3989c003c3cmr33404983a91.21.1788227536255;
        Mon, 31 Aug 2026 18:52:16 -0700 (PDT)
Received: from [10.133.33.22] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bcf8079sm2709695a91.1.2026.08.31.18.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 18:52:15 -0700 (PDT)
Message-ID: <1a9f2e1d-163d-46bd-ab40-03491786b962@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 09:52:11 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: ath12k: support calibration-variant from
 device tree
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Andrew LaMarche <andrewjlamarche@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson
 <jjohnson@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ernest Van Hoecke <ernestvanhoecke@gmail.com>
References: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
 <9e22e5ec-70b3-4ec9-ae75-295fc13a23a7@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <9e22e5ec-70b3-4ec9-ae75-295fc13a23a7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=K78S2SWI c=1 sm=1 tr=0 ts=6a962fd1 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=Ggg6OIdO8VovxE8tBwMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDAxNCBTYWx0ZWRfX9zAIRh7yx588
 a2y2oFZQa5Wu5Z0e7/NIJeJHHwIDhoDtlmRohXW9JDfkIZxio9NZ8OpxTLYtk++NqTGOu1MV2tn
 pmQnQ5WVqTbdg3zWtWZv//JnmzTWTRk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDAxNCBTYWx0ZWRfX0YT4Yx+/51yw
 8Wx6XDGCu7NY8mPQ9uMdzNKRJavbzFgee8Zix0z1g6Bl3uUMVudiG8I3MvqatLZqm6waxLPmdeM
 mBoD/INsythXKA2NhlRhBjcPA2HfbwX1lPU7bn7JvU2oLljj3KlcsFqemfRxHvSUxLJTOCzQUwW
 72CfAOZ6FMBdM5X2iyZT6h1BllASOhv6j1+DZFG+q0uyvCPPyByz1zLzS9c7Litdn+kViGiyScm
 6EZOnV7VJR6RcYWTBPAzqUylQRx/jUvlJgR9zzFwB4Rq1UZ3AfUmQjli93Is3PwzwyLmbcqjWx5
 IpzVYiJZTAnOWkBu+pWj0l8QQoiAIEd/kur/1xk6cGUz0QmrU5cvnr19nuFPFV3GZEXAxyRAsWv
 I+DxSZwWLrILzsx2CssCphLCOmBO2nRmC3y0dGluErJuZiwQ2xd5bG2eI6Ka1gi4DlFES9MknG7
 EBu+0bWSObAQOT+8O3w==
X-Proofpoint-GUID: _Q9V64jUHZxTnu-ArE05gLBTt21VQkah
X-Proofpoint-ORIG-GUID: _Q9V64jUHZxTnu-ArE05gLBTt21VQkah
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_01,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010014



On 9/1/2026 4:09 AM, Jeff Johnson wrote:
> On 6/30/2026 6:30 AM, Andrew LaMarche wrote:
>> +int ath12k_core_check_dt(struct ath12k_base *ab)
>> +{
>> +	size_t max_len = sizeof(ab->qmi.target.bdf_ext);
>> +	const char *variant = NULL;
>> +	struct device_node *node;
>> +
>> +	node = ab->dev->of_node;
>> +	if (!node)
>> +		return -ENOENT;
>> +
>> +	of_property_read_string(node, "qcom,calibration-variant",
> 
> I've fixed the following in the pending branch:
>     ● checkpatch.pl: 126: CHECK: Alignment should match open parenthesis
> 
>> +			&variant);
>> +	if (!variant)
>> +		return -ENODATA;
>> +
>> +	if (strscpy(ab->qmi.target.bdf_ext, variant, max_len) < 0)
>> +		ath12k_dbg(ab, ATH12K_DBG_BOOT,
>> +				"bdf variant string is longer than the buffer can accommodate (variant: %s)\n", variant);
> 
> Also:
>     ● checkpatch.pl: 132: WARNING: line length of 121 exceeds 100 columns
>     ● checkpatch.pl: 132: CHECK: Alignment should match open parenthesis
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?id=c9d2d0d1c4a0faaba5f57e3c3350707db9f4f3f3

looks good to me.

> 
>> +
>> +	return 0;
>> +}
>> +
> 

