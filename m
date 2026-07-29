Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA8C1FC8
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785351295; cv=none; b=OguK62TIUvMQuiK3bfqjom/1X6nmSntaTQ3pmib0NKsfdx/nDQtTkzAtApf/sRMQSknTC1486pXW6G697gaRDlX6I6PBtpJwJtLnU3dJT86BU+XU0773gOyKCHwldb9uhoN13zgQHjovWzxNjXDOjsUJHghIisnIM3kYNbUcyOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785351295; c=relaxed/simple;
	bh=mIdBjX8uWqj3jMTW4Q4CHO0TOmt+GQF84JHyOLNKTHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ceFEgKiYV5XIGUGKGHlMZuhMg/mfYdj2n9XmQbeu4z+hnYCpXUjslt58WWdQrVUPt4rZnXaVsXQLfke2ZQ09fIkzlGE/h6Nz7lu5Yr7eLO+80MSW1ztCDi4ddcfVGGbMlnK095bxDg3qFsckXBdYQOx0NQZp9cgBPnseeXxkdZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CpMHFBK0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=beub8Z4a; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CpMHFBK0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="beub8Z4a"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TISZhS2177529
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GGb/D0+cHzWfDdgb8vv4OyJOIxrUr1v/2y04Z8q3NrA=; b=CpMHFBK0Dt3WId6t
	94I3Gp4gLVZx+iRAu4EGJk19Pgd2L29Szjb1iMI214t1oAG3jWxypJSPfIJ/qRKj
	sijV3O6LKp0e6/qq+5zecS0Ga9RG+BeHfKbb0h0Un6ffOmTUDiticdMCLI+P+eYB
	umAbrER3dIeFaLdDEJ9shbRKuRQNf4BYc/r5lT8pQPyHEUsTLkLs+7Cr3yklMKTk
	QRBMRSyQa6wSabS+/iSfa07huE6x5ZiD0WbMcNKtFRvAWP0KNTbsxhoUXmc9MZX8
	jXxKCtHMS6BdMRru09gYb3R0QoZ9TzP8DwU7o8AVps4QGMAM+ks/QAZlwPIb8dVV
	2aDvcQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqps2r4cs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:54:52 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so24050985ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 11:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785351216; x=1785956016; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GGb/D0+cHzWfDdgb8vv4OyJOIxrUr1v/2y04Z8q3NrA=;
        b=beub8Z4a88InJOQ+lJ6w2KDnLDp/Q1qdyHNXWy8zDHYXdwS7DmmTU97RxiACU+Y+xl
         rR5d+gNu57UmrvuIZ/pfBi7prDEmMRkK4Qo9C8d0HfCzcnv8W7V/Ft7wP6q200Ap0C8h
         JtPBzT/Pmrum42Ouf0ar7Nc5RsynTe78w45I3uEIERM5fvKMSCV7J5JxZHeHl1fSeafo
         xy3XBPBM3S+UoSAWHmKlGasFwnobe/ML7vxA7qyly5BukXM1lyvCNe7t4iqzKrdE1Y4X
         nlm0G2wf1FFLVScA72WoC+8q2hCDo7afIyvyk0pW0C+JldaHnf5i4bIY0QyXbWMmbVUo
         M7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785351216; x=1785956016;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GGb/D0+cHzWfDdgb8vv4OyJOIxrUr1v/2y04Z8q3NrA=;
        b=UZLJVrNn3NUpjEOMsPwsHkpYM2R5YJYDJ6IPYezrYuzQQ4jGM0ohUjsg7MhkQR+lb/
         L0ro8n4Gtl0eRxCqDli5q+/Xta7WgJVanMuloHnZRriz3IausWiyMUFRF48NFkwye7Le
         oENx41zsTtWyc3I6tsaFlO4BAdPl7muvwMNkv/ski+2dUJRv+EXOsIWcS0ETerIdhHVB
         g38feKIdm+VBsCPyglTKtFixr89aOFwngYL/ZwmzcD3uce22B3xug48djPSLbQVRk8L0
         XEZLU9HZ9RFZNJ4ChndRqsmSUFK75oZjp42h7pOm0ZQkjLF8tiIdcnDTBKiHImyLwQoS
         Bnxw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4oRtZ3ItKnZqT0uAKxflaRLG59sxQz9yY/ejsMLVNl9YexrTaeuCA57UkuOnbAyUw4V6xtcwMXq7criT9fg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvGUz6IzQc0YsFEIGev5BtJZVp579hvM+m8vowxJOroHTdYc34
	Xhq2Ixr8R9wxCrtxQv0H8cd6SIqOThvcPDVoceBNHB3Gf2/HOZb92sT5azecTNFlpw+ChC/bq9s
	khd2+O68NDdoz7SXKaUtX/O4V+MFjIW1WapxoNLFlk0MNNiUG7XrLgCHM7rWhqUeMOY4V5g==
X-Gm-Gg: AR+sD102bGy8KwncUNjomod5COJWNtIffz8dWbRomGvL46BogwKFLSdKmnpgxpGQ0C3
	tFjluhbit3Hu+gycaCfThVRu1WR319PSZkTGI6qfgau6/GjwdElPv91Yc1EAx7QV4gFu3kNevfn
	AW2cgd/x7fntWUfYSwxsiM5FBhG/1Txxu3Io/SrJe/McqM8Nyt22vcp9aAWqnqqjnMiCewcRyN4
	2/sTOD18w3jMkVt2IKias31WG0S1/7DDdJKOuW7FDxGZ8GI2KvbMmRXlWWl7xnEV5L3D7mr4cqd
	6OcY7HlE2scU7AGixY7LE0YDv2Kje+hdOveQLh8zjqa0CIDhWeR0vCWFbottXxcuX0Yx8QQr+QH
	EAsC4OP6Hny++TLv67A2wbQqf6oxHBhYwCz/2NhZBcLw0Gb+iVBTbHpefEQA/
X-Received: by 2002:a17:903:19e4:b0:2cc:c9cb:371c with SMTP id d9443c01a7336-2d033d576c7mr632855ad.40.1785351215744;
        Wed, 29 Jul 2026 11:53:35 -0700 (PDT)
X-Received: by 2002:a17:903:19e4:b0:2cc:c9cb:371c with SMTP id d9443c01a7336-2d033d576c7mr632705ad.40.1785351215381;
        Wed, 29 Jul 2026 11:53:35 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504baa01dsm13218325eec.12.2026.07.29.11.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 11:53:34 -0700 (PDT)
Message-ID: <a8e1200f-5f79-4c86-915c-96464596fd0e@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 11:53:32 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: zd1211rw: reject secondary interfaces to prevent
 conflicts
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
        Slawomir Stepien <sst@poczta.fm>, linux-wireless@vger.kernel.org,
        Daniel Drake <dsd@gentoo.org>
Cc: johannes.berg@intel.com, kees@kernel.org, linux-kernel@vger.kernel.org,
        nihaal@cse.iitm.ac.in, syzbot@lists.linux.dev
References: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 8LMhqQC2ro-2Ayp_LaMg5kf7eNqsGc8v
X-Proofpoint-ORIG-GUID: 8LMhqQC2ro-2Ayp_LaMg5kf7eNqsGc8v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDE0NCBTYWx0ZWRfX9FgPg3XfI55d
 I3PrIDOfe3h+U7QrXCWYtS9yzNtOWBomCPn87Lq6etZdYxmQOz/JKNrhor6tr9fzOV9b+aekTlm
 EE1jiZS/iFajSmK2WO1mUDNEz1BhLQCNhqZM/iXYroi7mnFUhE5N+753ZHBdgRj2+6DTYTBnvqj
 Tn9r6/FyqZr/f48LMUiOUeeLh7BkJtjXOeacywABJzp4OlhLe7fAR//1alVB5/5z8m0hKJX0/IU
 ODSVD2AnuXGfUj11X7QNBrp89yx0aG7+zoK/5TDFCP7Xl6UnnjoU3MI78y35VHRyarLTxioMHPo
 TiGTVSTgNeQY/+lKtOTyIpKON2kH4AXE/PNqrjdTn23bmINzicjZ6adhil94WLOHWdOHXp2p8bL
 QJKDLzRvq0gOmudq9alCA41Jebb8CAr7EyFQbV1jl/yzs1HbleZWYPRH9PGNaiC+bclHsaGk5gI
 9oyitsN5BUG3D0Zs40A==
X-Authority-Analysis: v=2.4 cv=YaSNIQRf c=1 sm=1 tr=0 ts=6a6a4c7c cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=hi2ICmPa-PouKQFzbIkA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDE0NCBTYWx0ZWRfXxxWBq4OTqbfL
 Z0FPEFTMo2O0LqTJpePOlTDrbzCg5Qi47GfbaBI1nVjRWwuY/cgzOYLK5i4aSEs/KABT61h3Eqx
 c2g2mMOX5SMDeel2sLpYDvi7ht4ZTpo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_07,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290144

On 7/29/2026 1:04 AM, syzbot wrote:
> @@ -1353,6 +1353,13 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	struct zd_usb *usb;
>  	struct ieee80211_hw *hw = NULL;
>  
> +	/* ZD1211 devices are single-function. Reject secondary interfaces

this does not follow linux block comment style
/* should be on a separate line
(at one time networking code had a different style, but not now)

> +	 * to prevent multiple instances from conflicting on hardcoded endpoints
> +	 * and triggering recursive locking warnings.
> +	 */
> +	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
> +		return -ENODEV;
> +
>  	print_id(udev);
>  
>  	if (id->driver_info & DEVICE_INSTALLER)
> 
> 
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f

