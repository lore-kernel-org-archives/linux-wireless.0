Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD0E43CE62
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315941; cv=none; b=tg4LF1rBkci5ml5NJkqXJrt378UFwQd3jJrkmvtw18J9aekBjoBxwvjMHRspTojwAqJNA4twdAqnlg7LmhboaFwIvKC/8MPWZ5RGrGNP3TYVEs+M2oPY7nnTkdWYTZTb9w2/e1U6/BDNdKhtPUIo1LH7N/4BSTAUCEY0iD6spJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315941; c=relaxed/simple;
	bh=QNikqTvqVkGmUhXpmuK6j1Gvqf1bluFLLOGjK2Nisf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NjAfQReh//c2U3Y6b6KV2inBwWUoi1I92fhJR2krOVYBU4bUNDi15f6YNCMRW7Czdi+Ki6au6w+1zhvx5OatmzmTFuDWOgxpBllUurMvvcSoJWZiKVXHWxZV5DGFpvusY/OeLubn2gA682HwE+5Y4cOSFHAw8ByUIP7x0I4RsjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ny90bndp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XjZ6Lkdy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ny90bndp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XjZ6Lkdy"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T7f2FN1088697
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VBOrrFUaJtsfvmkvZqyRp/Ke0BbDoZomzwSefP6ue+w=; b=ny90bndpXhALLEDO
	In86EzGjmP7l9+McPk22Q2xuhWQzTd8PCXBGct4xLC0BYWPhzzNTEe7Gb69P0a5S
	OJLgqvFWWqGrug8+bNYJFV6l6MGTT0ew8cAhyETof7/Iny1x7vt5wUWHTLVTBy6K
	E4MmRu1UvIKjdlx95CgPJbk7R8Ur89bnKUUiju7OHn2c1qISELz51PYC7Dxi1nKz
	7zXklqx274lgX+Oqzsa09GbjhmA77z6cvXKpYN7/ZBH4go+U9R28GkKwJN7TIuqV
	5zgA6CZGoUze7AUjHIlae0y0xdeu2x48rjH1QlVTQq56c9xpGn6K5ROMinFesisH
	cNtBNw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fq5sahxj7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:05:38 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cee1ec30f2so10740865ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785315937; x=1785920737; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VBOrrFUaJtsfvmkvZqyRp/Ke0BbDoZomzwSefP6ue+w=;
        b=XjZ6Lkdyrx45ZP3A5FxkPeA47KB/A8S9UOJw2hJq/lJ0NnjEcJLkPsl/eLM9EWmit7
         usJOhmnRCbyN/hjUagqbn81Zex2B43+hmEXJt9/O8Kq5paWbJ1k0M0sBXkYjbQ2JATFN
         8SzUjnowM/bjgWIZ+dfMOxXJUoVlwSOChHmYZOv7N7JZZhn24ywqTD0g9SUqC2DMLmeZ
         9WpA8g44aw9JOve5AAxmy2jP0d1eNEMLr76IqSyT76qPCiQugqGBI7NZK7ysBSK/y9tt
         m3GpMjDKqdvO6W9lpCWjgzyq5b6u/IAw+XVtSdeHFT2j+X0en0MNMOewQh2FAAJDvPzX
         7Dng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785315937; x=1785920737;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VBOrrFUaJtsfvmkvZqyRp/Ke0BbDoZomzwSefP6ue+w=;
        b=Scw48NWvVQ10cwXsT/Y/++AiBqA1Fth9Xk5lZJcghtRTWVgg/YSZFbAM2XrEFVx7M/
         ALm/Qjg7jhljXxLzcSO/iPiCIEXCTmF0ZetvQfFTs1gZ78DpIbvR0kvZ44faj6yvy2Oc
         1bKW7xsMeSn79bVrU/rOjwz2zjMyAqQftU7lOY9Llqq6q79eDd+qu82WDdjF0dmYPMmr
         SCjPfsee9P9bDpCmZlUOt/vMhwQPoEEKAtV/R8LbvQmR0Jhm8te55xjJLmDlHGypzs24
         kCRPK0DSNS+BgNBlmojaJjWOOqK2hXHZVrrab/3I4T1zvr4BBja/KNWS5KaUTYB9kZhf
         +UkA==
X-Forwarded-Encrypted: i=1; AHgh+RrQjStqYdEWKKSy9gJyGKOU3Yb95AnvN4HVl2iboTH8i0jeap8c2+eMrEyabXbDboUZBITSuXuAYajE9DHf2g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhs8ntUbgemRLTBh+JfWanZnqqv2V4/fEAhR6wEHIwEWm0bC+7
	xon6JHgI0/dcvoW1cwt2dvNAvZJrvqaQ8x1Vg9Mk5twk6ZbgbEJB8O8AyRfOpfGNWRrMibFuWmO
	P4mgt2dXxIYbWjbDMyUlztTS4B4lHIFKv47rTBWlbGTrzJFuav40wCr+EPuYIwXSyhMY2pA==
X-Gm-Gg: AR+sD12lIf785VFsi0DwsDbvmWV2S+KdHXbjJmuVOGRorxeuQq0jg9BqLpDkVXvyXfG
	bRN1RQGnbGKc7NeD8KJHIGVULvyLdqaMUWJYCy7cjfs3xMf7JVtwdMUfgUqjbluFKimDn2kg3aw
	fDXzNzRsakprW2uxfkDUxu/EeAEB0Z7Njv4XfqkMB4y6a+yUp/LT8Q9u84a+xX80rbHn49cLWZ+
	7Y+4zt2Q4Jq3cUW8mJYw+jh86X5lnjkeV6XKbQeQSOomKrG0BdcSp+saOm9YyO6SS00erFksh0H
	c6XT9jXoMGTygtS3R98BNRZ8d5dnLZgmYjf368ePI+jbqCigksNfKOH7CfOSHCKT1PoK2O21zDU
	nasuhQqDCIb9uPXUhWrhLCWv1aNcfSicLupwcSG7lK9tDhU8zLxCDlgy2WEzX8jBI5hpiXQS9xw
	==
X-Received: by 2002:a17:903:1aeb:b0:2ca:be8:62d with SMTP id d9443c01a7336-2d015d26298mr69152745ad.32.1785315937495;
        Wed, 29 Jul 2026 02:05:37 -0700 (PDT)
X-Received: by 2002:a17:903:1aeb:b0:2ca:be8:62d with SMTP id d9443c01a7336-2d015d26298mr69152335ad.32.1785315936912;
        Wed, 29 Jul 2026 02:05:36 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a1586esm8247835ad.12.2026.07.29.02.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 02:05:36 -0700 (PDT)
Message-ID: <13f6c903-e85a-4f3a-9c96-ffab95f831a2@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 17:05:33 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath11k: fix leak in
 ath11k_service_ready_ext_event()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260727-ath11k_service_ready_ext_event-memleak-v1-1-e8373d27bdd1@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727-ath11k_service_ready_ext_event-memleak-v1-1-e8373d27bdd1@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: GqddcJLWR5VHkDZcuKcaOtlkFIU_KpXx
X-Authority-Analysis: v=2.4 cv=C5fZDwP+ c=1 sm=1 tr=0 ts=6a69c262 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=aNtGKDg7WqoNcE6Ki84A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: GqddcJLWR5VHkDZcuKcaOtlkFIU_KpXx
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA3MyBTYWx0ZWRfX1WgxSpp+zRcP
 uwC/QpfPPFHdgQOstkh5jTxw5/vNwJrZaRgqEFH6nyWx1sGLULucEGtewW32QHb13N2BXsK1Iw0
 qvhTahAUKqR0RHwnXNB6wg0jpVwLxW8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA3MyBTYWx0ZWRfX93Xg4kc+HUMw
 HR3xu5hFRDQi05F4QoHEiasbPEEIcnH/4cVFepqo2Cq2ypE9YNGtj2bie9aT6qx3EfUp4yqD3Z9
 /lQS0FAj9DUFogBskE1YA1T54GoGSMUDUGRD67jqpgE7pH/JgRqnnIHZpauXUW9LbsmnYI2iHM0
 OlBKHKgJr8qBzxlqyzCtVfM72lmt6OMqErjFbfNsNt39H5jCsunb5D4QCUwxjPoR0CkixZpKWFK
 Jlvrec+khbHIGFhlAB7Rd9zBdDvWASkWGwJpKj6Ya4H5Y5hEScTRdNOtq9eifF1B1jDwg+OueCb
 JwUEdBCd6gY1yCethPXJLicGeEwI4IEWKmOps/R6QqDiuuSgKdMxGxbiNTWngx0rS0hJX7Io1xo
 w/iTbYCMRPAKDLwrhb0o4Ubbr56w15BFEbOz2L/yyqkkEwofLtgolQ4eE5CV4zJDViofS16e1Bh
 XhOi6FPb4L73JJVJCyw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290073



On 7/28/2026 7:39 AM, Jeff Johnson wrote:
> Currently, during ath11k_service_ready_ext_event() processing,
> svc_rdy_ext.mac_phy_caps can be allocated during TLV parsing. This is a
> temporary allocation that is freed on the success path, but not on the
> error path. If parsing succeeds far enough to allocate mac_phy_caps and
> then fails on a later TLV, the allocation leaks. So free the allocation
> on the error path.
> 
> Compile tested only.
> 
> Fixes: 5b90fc760db5 ("ath11k: fix wmi service ready ext tlv parsing")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
