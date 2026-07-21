Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7246E37C932
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642763; cv=none; b=noq6asJLR0QCX+xP4B6mub5iDdv2mgpuiTm/FSIx5YftLJxmGLhS90WGYbpsziZW2ZY5TbjbjJo0dwlHqlJpbLRlwwTxN9osgaeyfkbEbSw2h6Fv8uYCUNJ+YVQzXxi5to3/aWhqc6e/irr3qF/stlUWEONac+UJdVnuOdfubuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642763; c=relaxed/simple;
	bh=s7/X4UUUfSZvl2Qff0oPDPg+KAHaU6bVz80b1BTjpzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YV1Zb5EJDXuW0ahyZ1L5XEDc+6Eg8mNnhk/xARvQ084B5eZcn7lBKCLM3oZD0Uv6dvF1x8KYyJTY6vWjjt8f1yQXSoe88lCoiSUtFMsJa/TZRXYgvi8WByCWMDtAr85gaEDJb0A5xyZBQTZ6E43PTaO0EgxFesaVCl9RRQcV4WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Um3PKVo3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Erxc6EGU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Um3PKVo3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Erxc6EGU"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDfr5x2071483
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 14:06:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	s7/X4UUUfSZvl2Qff0oPDPg+KAHaU6bVz80b1BTjpzU=; b=Um3PKVo3mdzPjXRn
	Weqlz4OI2y2lbEPegZE2Afhp1OOjsJ9Xd83oPK0H6nft3LKLNJU4gsOtIoX4USBj
	q1cHuNFwLElVPhcxzhFUlvVeP/TeSzWTlkIPuESD9FyD2IyPdYgvwgoh3gHaEIvm
	NC3ccqzoArpVPHsm5A/IisrijYbps4keY3M/6UkQ5HWnvswGsZjUNQ1AlAKtnycm
	Cgo4wcWne9uolQMvxZOnZIO43o54BLHBKzbkYTqcRDRIDZK5Jp9REm+wl1Z1D/AM
	NAUPkUdF+oZxhP5lCEUObv1cK6rFHXFF6p/Nb8Lse2Et51XJ42jixLE50OCzv8Vh
	gBW5fw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6r3h2y0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 14:06:01 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cf7dd9fd91so12905435ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784642761; x=1785247561; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s7/X4UUUfSZvl2Qff0oPDPg+KAHaU6bVz80b1BTjpzU=;
        b=Erxc6EGUzV0SGkJLdHAlorWnfOGL6DUpmuRs2DAf+JzZGUSbKKFoekICTecP2zIVuT
         4a4TAEiUEEd8S/FEvqM5iTikEyCiUG+FnsPAUB8luGoHaQkj+2h8/6Mjaz58Q10F4oe1
         vS6IBqNxJUcT4InptNKfo9JMGdrPhGRzAjyJvQ2Ote0wnw5Q2h6KT10PQ6qb0ruB+Z0X
         ZSio69MkRgV6tFEp7qdo+o+ibAvuYozgsNaXP1DhMSKEskvij9dDzSRpWwV1iBgeAJPM
         Zw92FPHEDPDp6Ay3F1jcSrDa7ltR7F8i0CORsDCm6BXeK9NAMRky5TT9rJyCtu3JP0M7
         sSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784642761; x=1785247561;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s7/X4UUUfSZvl2Qff0oPDPg+KAHaU6bVz80b1BTjpzU=;
        b=MslyNCVpweqgM6l/xkIkNtQsVGEBO0NCSdeqAN50/C9VK+CKWCS6Wuv6FG34gqQasa
         Wmkl4Tz1bZ9sWGpPx7Ifco+lmoZ2nytDLMRpr9jpDCX/2/Xq2vS8tHnuxpadEgpTBPeQ
         l5DVVTX9KT9fFcozjtqo4j38jFW1xAsBOEKdAvQxNP+Y98JuXl9xzUKhDcpG8HnMadVs
         R8kFYKoxvyh/3+FZsAtZlkxKufd/QG4qz4RGR9q2dNA66EO9+8aikf78d6xEmauLPplx
         gv/8YY2zhXUyLnXkQYuvb/fFeDgLPXIunJDVi0JV0wgLzVvDV5Bae3BLHVA6G/53vB3e
         YtVQ==
X-Gm-Message-State: AOJu0YyGgsR4z6yitm+axAANO6OTYPg475MkVSHbIk6LFsaREXbItr8I
	D58GkeU3L2imdstrerze3/I63Bk733et4BCK3/7IuovqL2jeVG44ButWuQVVykirlcpvotneT3n
	+PhkxNcSVt1KaujbQw2fxOwidXkGaDqiS42wXUVtLdyanhUJECKwFJOKmnHTNmjjzON0DyQ==
X-Gm-Gg: AfdE7clpcvRtsazwVu8kL/UzULokSJCubgNPdxPz2idc2UjMe6uLW9vqM9Q9eZRe/9N
	mEOwSUSSHAHemB8UKpTT5TOVCE9tbx+mVmwsJtj0/45ATBenpsg3IMW1DJTC+eYtzQOgyTQo8JW
	UweMCfFJPAy2Kj3oa0Ow3HlmAP+TnoQa0eGMSUvQupa5zOK5/CzUwZcl8DokAfntkTvSnLERJES
	f7JqT4Olyro4p5bpVQcOcyN/DOx5cVbh4qRJtDmiR7Oe8v/10gEkTbQaGqeAyxZr21+Tvdfv1Hr
	LGLq8R3nf7if2TBV5kewuY8Zq8dta2PYMjnRMUk+vB8bCfxPTzfXzTM4Z8cYjNhoEwWT7T3pyYi
	2JmqlzJaggZhHoupPCOtuoi7KDv1tb1r24jKh8Fz+pyVXGpeq2ASXwOkD1iw7
X-Received: by 2002:a05:6a21:8cca:b0:3c2:dcdd:a85a with SMTP id adf61e73a8af0-3c3ad7a324bmr21705844637.13.1784642760728;
        Tue, 21 Jul 2026 07:06:00 -0700 (PDT)
X-Received: by 2002:a05:6a21:8cca:b0:3c2:dcdd:a85a with SMTP id adf61e73a8af0-3c3ad7a324bmr21705772637.13.1784642760162;
        Tue, 21 Jul 2026 07:06:00 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a20bf96sm46640518eec.28.2026.07.21.07.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 07:05:59 -0700 (PDT)
Message-ID: <a85bf89e-5a4d-40f7-9797-66f078427f96@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 07:05:58 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <181b5ee0-f002-4f5e-93ff-49b6aa0a6e61@oss.qualcomm.com>
 <20260721072128.142668-1-zhaojinming@uniontech.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260721072128.142668-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0OSBTYWx0ZWRfX2ze9G1NSqgQU
 EQ0MeCBtu7qHYTsKBTqVGbzpYl8zPjivQkKU+370mYz+BWLZpd0ZIsb0BAabIdI07ojkccxPeGd
 XvC+nSwQ0dvQKhZ9nJwNmroGiL74N/Mp2yOKMcnSU8Q78CjOxWxnDq40ewA/6H0Ao7Zf2XzZ4x4
 lYGhzSAEGHV2D5l8Y9Q8Vth/TsUxT1SsNoZELijv5I/Ih5yLOpZb9M3n/9ZIbnvFi1Z6Gx/+eZo
 DRfwBVTi8MLPsmq5enfHlzFZkMuf8l3cFnK2Rf0N2nHS0K1eugZVqa+beBD3Ps7Pf2PSolQUov0
 5Uk8ZqqMjNF0yRQqVITH9oWteT9OoSVZfOysw9/4qNwWoylk0lBSMYNICgjxS4gN0v1wdxfb5h9
 0LJ2Pq8XLi+nmAD+SGd73q3JSRp9rWmNm0dKT4F+TKTgTNUjlIEndIyMq8HGzBRBoR6luWs/bZW
 F81+E6XEoNwMfa/VR5A==
X-Proofpoint-ORIG-GUID: PE6rfuKTWkH33z5K0ugJbdAEcUvFG-PH
X-Proofpoint-GUID: PE6rfuKTWkH33z5K0ugJbdAEcUvFG-PH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0OSBTYWx0ZWRfX4pQzkB+smWZ4
 IZTx7rIUJbCcIUDlgyUCCErVAT6ULi4bKYuBQAMUR19aC89H4ryaYAEpk04IigR1e7/jsVXxVHi
 DPO0a80HbsktYF+Zog0fPWOUSaF4Jus=
X-Authority-Analysis: v=2.4 cv=SIRykuvH c=1 sm=1 tr=0 ts=6a5f7cc9 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=c5RWqA75Khxowu9MsocA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0 clxscore=1015
 suspectscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210149

In the future please post new versions of patches as a separate thread.

/jeff
