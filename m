Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73D53E49DA
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153462; cv=none; b=uq8zdRX17GPQKxpzbrOloIuJGSVV1VHJa5jP69WnxHttG64E5lL3bS4OMFdSaByAJ7dBX1sGzbzQLlM6ryfy3KcWvoC7D9zAS+JqG7KOvhm3xEB+RZWz3J46uX34Bx8v+EprVHSjt4BI6F2ROSpsEbbSq0d9p+Bv1p9LGdEfd6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153462; c=relaxed/simple;
	bh=16c8In30yT/bstw6x3U3gn0chGLv6hrAzivb/92m2jM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OB5MUHLGx+5dLJT/PRtTZAdJIpHa6GhknBgY1z2JrT074c2j8zREfiWypQ3k2bJ2qLiXivRfE4ErAy5gJiadTer1UvScqd4YrqZM5zsfeszOvIpPTTl5hiP4stxk/n6h1pg+j5oSH6eTZDc0fCyTliRLuekPQLNEgbInoZQRnvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fRMRH1g8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dactseMS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fRMRH1g8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dactseMS"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8JUYI2197271
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	V81J0//aP7Eaf0ycXsuGgGwagnYfs3gvKKc6hSebF7A=; b=fRMRH1g8eb6sYlWz
	93awt4dhBu5vB5nlHMNwrYFixvGr2Sq9Txt1BlNrRyoFT09KEOGeWXUIPBF5aeb1
	uxSA7vlkEYF1+TGm13zg4/I1FsUhPAVbHZgbIzapgO71QsZo2GxZvMbN9BGJkSJu
	gV5Nsw7cBDYFyH0cVCSlv9+uNRMDs43Ed674G97FIelUf7fphDjS2zY+zTNfy/dI
	vJ4BrutFYw2gvjzY7xAA6BMKKLikH8c+5qR9cAw/UUOtgG9gGR+CEcV1ogv7OUeX
	NqvB/4l6skg2chbKpuUvjmaMbmSbgspMknXV77k8mIkgJDQfrA67KH9TMytu6l95
	EOIurQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gv9bqgmur-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:50:59 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-86ab8302b54so586203b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 01:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790153459; x=1790758259; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V81J0//aP7Eaf0ycXsuGgGwagnYfs3gvKKc6hSebF7A=;
        b=dactseMSN31ZjEVuZ6CKM7tRHYVya3aZ4TmkqjshuvLyFNLnWH0vSepiLmseigUtVz
         emgZHkLr4KTahvA/2wEtPn3vvJvcnP4kF/tdLejrtxT/nf0SWNWEPFeODL7V7Lo/RVTU
         1IQaTC+HPbGLWIuXUHkX+DDaHpsXOM9ymDkIkMf/sUMEq0SAwkNrZqnZeNMrPp8n1Z5T
         tsPygeBshiA6UhtLC2gtPEDULFL0FW+Qn00xgsNBUfaW6iNn4BpgBuVQ8CWj33TAcvol
         CH9f1r04jUnx69Zql+tNIWcXdIMlfsvuXTX8TLQeXNpVhRCXUnBXLfEvuIR6AwwtbugV
         6E/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790153459; x=1790758259;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V81J0//aP7Eaf0ycXsuGgGwagnYfs3gvKKc6hSebF7A=;
        b=Rd17521Onk+yb6rIf80j5yY+at8WZ1WzTh696ThXC27OcGBv0p42FcQ20ibna05Ncd
         PuZX+EAV61qWKbwtGqT2j21oHkUyFsMujGeAno610P2S3HhK0OduLf88Maofp/bR9/Im
         48g6a78OWzxIbQTIxHNK22dUj0/TC8BrOVoaZ64qh+yepwaWnc4PdABu3R8FwqVsEHHr
         D5IlmKUMxHZc+TCrJrOAsOdMtcu399xLaG1Ico1AfzaZ6jZ3P4YGxs8/bCyv4RGGigHW
         NhvblT3EuaPfxF51/G9funRH9gaPj/nlYqLSSYGXVhlj9a/u8hLV8y4SQaxUHdsf3WsH
         N4lw==
X-Forwarded-Encrypted: i=1; AKwUvBwtbja0/z6vd9tLjzV6cfa5t7Snmx7ba7pRo3Uxn5KCeKsN6Tt9rb/LB690qB6FE9cVlsre9SNTkYvQa0XoAQ==@vger.kernel.org
X-Gm-Message-State: AFuF++k01QAM4/az3+44xb/9OBk2b80BJjLcWmZxGYQyYb13Kqu/+1PC
	LARZvYIMcQr9hheCBQN2v/HVbRb3TnEF8F27gyvR3p05BQU6NhbHEl1HgmCb5DC+2zkKJd8oLKH
	OmERCqBiu0ToSx05I+DmFyU71u8P1yM54ACisf3oAtZOQDrs9Afvc69gBPYTOOK6yP+90hbTumK
	vWPw==
X-Gm-Gg: AYBFou3Nz7yshQGnr8LELSfjE/0ETZHVxr8qjyIstfmqtt1OBJLiz1AKA4PSGevcz7P
	WM0viiaKQEMZvTKolrN91d04EtR5Pf4PTC9DKMk0YYIPJfXJlR06dOFVL+7CMwhQdv5/1boxVgk
	RSCveoGL4Lw8brQqRVyxFxpUTl1CvF1S9qyK8feuUXQEJGUUbEDS5SHsEWKlwHX/XwEvkvovuWO
	pydaoNyy9PoPpbm6RRQE2GVWI9amXphLZLkNGWkqu/J0PEjrtqz34gQStyVm/uGz3vMVUpCOb8e
	mEylZOesPRdVLquQ6Q1TcOnS/u4Mqno9yiSgzhNhrLl3VY1q7jYEXlSOMORGooqcS8uaKQrICYB
	2G8NkHserU9lmHdK8Zz1cZVKZbIhwYQ/uJPTwvTt+40ftY2I7s+flOi2QacxPwtncaCJBKjAJ
X-Received: by 2002:a05:6a00:3318:b0:857:73e2:9106 with SMTP id d2e1a72fcca58-87d1b3ace7amr2110666b3a.22.1790153459109;
        Wed, 23 Sep 2026 01:50:59 -0700 (PDT)
X-Received: by 2002:a05:6a00:3318:b0:857:73e2:9106 with SMTP id d2e1a72fcca58-87d1b3ace7amr2110650b3a.22.1790153458595;
        Wed, 23 Sep 2026 01:50:58 -0700 (PDT)
Received: from [10.133.33.161] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1cfbfd11sm944539b3a.11.2026.09.23.01.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 01:50:58 -0700 (PDT)
Message-ID: <16ac8645-3aa9-43da-bcc4-9ecb2225e1f2@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 16:50:58 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4] wifi: ath12k: advertise interface MAC address
 pool
To: Vitor Soares <ivitro@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        kang.yang@oss.qualcomm.com
References: <20260922200643.1133491-2-ivitro@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260922200643.1133491-2-ivitro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: eIPTM1Y746ExiHjlVSuH1NRRClSOxlCk
X-Proofpoint-ORIG-GUID: eIPTM1Y746ExiHjlVSuH1NRRClSOxlCk
X-Authority-Analysis: v=2.4 cv=WZuZ+EhX c=1 sm=1 tr=0 ts=6ab392f3 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=m8ToADvmAAAA:8 a=EUspDBNiAAAA:8 a=PJUtwoy5LLMsS-UO4yUA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAzNSBTYWx0ZWRfX/JRBDNVY7/SO
 8AVkPfs4QbQ2jGsZxZ6l/kGclraFG4ZU25Ours4qCX14qbVvgBaE0HC1TcNc8xqykZWPkEqlMTp
 aM5uSXK8uO2AfQBUFhRrTsXkjkvQPRY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAzNSBTYWx0ZWRfX0s55AkXgL299
 g9v9bUrP+INsn+1r/kW/57jaeXbCIa8J3XCYZA8PG4APtnlwBCrFr6YQIvHkCLhNKOZB6OmKZFR
 MRyuyrtQ+DnhC4mcO1gYem/uBy9RmD+2dxRP59sjra5zdRP+pe9E7Z9Cq0ey0OP4+TGJXAbiL4P
 nzEffvbP9CkO1y2bvMZuH20w6JW68vAtO2vK9Y8hDZjOl6UDFH6cUo+miqHuG0cwzU47fH0zwcz
 2mMjNa4QZdPfgLhbFyP0orWPMEhpseZax8xorJ/v/MrEegYHcPc8R9jEWfaStoLdIILX4aWKlAl
 eyRAdIlN7PLw0tGBzfIo6oI8UI48as+Kh7CyfusgJofQcIUN6EW2yjKMV0q+pjPwxE5/1cpMOUF
 zomTEPvx+TFeY0OdXC2ntgSDGKKArNI36R/XC5NbXbPTohvf4i1ugL7PYfdzSEeUSKT1ualrZDf
 qQHL4SzqpddYx1/4Uaw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230035



On 9/23/2026 4:06 AM, Vitor Soares wrote:
> From: Vitor Soares <vitor.soares@toradex.com>
> 
> ath12k supports creating vdevs with addresses provided by mac80211.
> Userspace can already make concurrent interfaces work by explicitly
> assigning different locally administered addresses.
> 
> However, ath12k does not advertise an address list, so when a second
> interface is created without an explicit address, mac80211 has nothing
> to pick from and falls back to the permanent address. If the first
> interface is already running with that address, bringing up the second
> one fails with -ENOTUNIQ.
> 
> As in ath11k, provide a list of usable addresses so
> ieee80211_assign_perm_addr() can hand each new interface an unused one.
> Keep the first entry as the wiphy's permanent MAC address. Generate the
> remaining entries as locally administered variants by changing only the
> upper nibble of the first octet, which naturally limits the pool to 16
> unique addresses.
> 
> The cfg80211 definition of wiphy->addresses does not specify where the
> addresses must come from. Some ath12k platforms use it as an interface
> MAC address pool, while others use it for firmware-provided per-radio
> addresses. Gate the generated address pool behind
> advertise_iface_mac_pool and enable it for WCN7850 and QCC2072. The flag
> is read from the first radio, as all radios behind a wiphy are
> expected to have the same setting.
> 
> Other platforms keep the existing behavior.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1
> 
> Assisted-by: LLM
> Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
> Tested-by: Kang Yang <kang.yang@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

