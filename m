Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A343DD854
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153425; cv=none; b=jMBl1WVIxpZ2OWShOD7VTBaGfRVnJp/59PbpJszvSkngNwVORUX0xFGaBUs0/UlLwK+/06A/sYgzxtqFlsk9bMUrzk8eXNpCSyyYthb9qytKvy36gDYQfbW2fQtAxAHiZoCCL7OAynO3RZmp5AatG6YzHM5/loj8aXdrmuQXd9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153425; c=relaxed/simple;
	bh=wOghcGOSFojLTwr5rZMmk25qAZsebnu+adbwA9aFgk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XjpgtzWsK5yOpQhN6Vxy5Q6ikNDWU172pB0DkAvDP/Ygy45O8OiYKrjtWOWFD7OQl/uLo0+calSR6ZPXQeSK+DFqJkYjukEZ2GbamcVh5ii4lcgF1OACVgiD8YwbHSwX3ZoV09jZ4P4BhkP1GMmVfv9iBN7DFcXTTN7syMRnltg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bdmVqWUv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZgI9sxwl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bdmVqWUv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZgI9sxwl"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8JS1u2718888
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IcBEO3tqolSSDGnwFgxtWVMAvNqUYs7uANQ3K8/ueLM=; b=bdmVqWUvwfUM/NzH
	C9M3sQfHAJVUA29fGYkVINDuy/1By3pWiI081uN+wm29lkXrUhHPequ4MdG99R3O
	KS55ZLpORnebG+IQnodlrXyb6EuEwxcFlHAJsCSJT3MNnrlzSCa1X3JIZyL6aBjT
	D3Qrh9fbdm/QPiTClCH2PRKC0qRHgnumxF4yH5CtJKzUQkdZIVsaKp/RBsJpuPxM
	pPt39d+bdiply7MjlcdkEdfF2FzJVgRv+PxME2ScAVy7xsz2bbbV3P7/niD8m5pL
	yTqDs2PDXShKZAeyWGYN+PB6jOECTnFS8z+4NsunOzEUsJA0oLuJA285IJF5aIx3
	llPiAA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gv32qsx70-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:50:22 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-398d0010cfaso726417a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 01:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790153422; x=1790758222; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IcBEO3tqolSSDGnwFgxtWVMAvNqUYs7uANQ3K8/ueLM=;
        b=ZgI9sxwleN3Crl+3rHMdo3ol11JLilH6v4hMwgFZFV2qztkS7rqi3Sp9PTUEyZiayA
         gb4V9hJP/bSVAeMtyBT/8VGPy8WC28Rcc5U5Z8p9wuiW5CJbXlsFHPPk6ucHzdb5Tfoe
         ynsLrqNy2QllJaFU7ObdeVwvob4PR/JriasQtLP0oqiD2EWUtGUYfp5QFODY7w1oBhD5
         1UjKmmijdcT78SbkdSZrw9AmgQsmw8VlIl6NEFg1dVSFUvIcFSg6MsKNdBCAxFsCaZqr
         E7H5H8RUNqpCS9cZg15ZuTFU7z1bASJXIuPPUR81PDMH17aIl+mzAXaWfHStSrXyfEsF
         5E9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790153422; x=1790758222;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IcBEO3tqolSSDGnwFgxtWVMAvNqUYs7uANQ3K8/ueLM=;
        b=spa0lKGmF90ucW6McFlEGLCq80+jIW30WY71C7K3Q3X9wx85EHWNK66aLszeU12hML
         T6ovu4E+YdsYpjm+Uve+vWvHu0ZSvcluajET8SV5lDTIs6bDwMne7qtltV4ZLNTZ5CLu
         BfLdSZZYRFPRCR0CWicxD+U87Gwai8HcX7ekbH5tTOLH3rsAFldNHGClenwOoA6592uF
         Hv9K+0GsTkiwP8EyWYPPzMp1e+cMbKHqseHlSMXkQC2Ni1LQjHGSmwkQ6+JPDMKbgrvt
         LD6nN1CzKiXSlHfafMh/u3TO6qEeebw8mx53YaFDbRZ8RNdlH8qoh7lFu46POSbK6CiD
         7qiw==
X-Forwarded-Encrypted: i=1; AKwUvByx2HkC73vGB1aI59D4aps7MhTLHOnoZYskYP48dVUn/3sENNX8WBtdnQtPa0KrmJnlLahBBk3B0FfTccZEDw==@vger.kernel.org
X-Gm-Message-State: AFuF++m+MaIvyM+eN2KtUg6jtq48ipzpMuhmX/d2/J6mGSRDwd4koH5O
	07253a4DgJUwHEtnXaRmAPxUTM0JgBTQFEl+TBkR2cKBpQdxC1gSnxFRSWTa9e1oQKSGgaCytyn
	TYnuAkvPdmmvp9fm9a+YBiPXnb41feDBHUF9t6taM9EPgb6/UWcXex2XFS6//0Re57ME8g5Gjk9
	xfjA==
X-Gm-Gg: AYBFou0B6FAVvDcEsgRDnw30+YL0ehTeVa/9arNcVa7u7wmTHGxJ9t3ROmV0jj65I6N
	twc5yp7FFLaTJEdvSU/NSnjCy5O1fSein8n3VzIsE92QTrd4gsVuTTBE5/JN1sNZRgV+t4DqKPx
	Xv3wp6kGVND6rVFVtd+cx6pKdtkwAaPHO/g01AvISHF4zFME0vs8PuFarYWoS7qitaG6rNH5TP/
	tq9AiVWeT/Bf9ZfKcZ4kajLA5ZmWso/duftouZQEre9/zqCCc/WpXKBJMjjXnv/IDZQT6SwTH2O
	vU3SkV1UaKGpeQcuJCT17hsq6lNo8Fy3SnwI/xtKk+6CMTf0a7poU9GJUb1wKCF5xtUSC9loqMM
	ul0hsG/N/RC6QA5Nd7j+w7efaNabBvswBAKjBTBHuBy6WKgI58jCfeqPHykaiK/oQuF6jtE1Y
X-Received: by 2002:a17:90b:33c9:b0:39e:6c69:776f with SMTP id 98e67ed59e1d1-3a07e6a66c2mr1496382a91.24.1790153421759;
        Wed, 23 Sep 2026 01:50:21 -0700 (PDT)
X-Received: by 2002:a17:90b:33c9:b0:39e:6c69:776f with SMTP id 98e67ed59e1d1-3a07e6a66c2mr1496355a91.24.1790153421265;
        Wed, 23 Sep 2026 01:50:21 -0700 (PDT)
Received: from [10.133.33.161] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07de57682sm4609661a91.16.2026.09.23.01.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 01:50:20 -0700 (PDT)
Message-ID: <6fc9265b-c58b-4747-a5ac-510e93bce60e@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 16:50:20 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v3] wifi: ath12k: advertise interface MAC address
 pool
To: Vitor Soares <ivitro@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        kang.yang@oss.qualcomm.com
References: <20260921173033.846332-2-ivitro@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260921173033.846332-2-ivitro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=SJnXx+vH c=1 sm=1 tr=0 ts=6ab392ce cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=m8ToADvmAAAA:8 a=EUspDBNiAAAA:8 a=CvJZMSMp8JnWWA3HaTQA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-GUID: 3StpVppLJYK4nds7XuzrWH9QsmX0i1T6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAzNSBTYWx0ZWRfXwFqPxCpjaUA6
 tI5XW2I6s5AzYDU+MtkXuriEf7Q9JxhoJZChqeH4QL7c1C4mKI29jm8UKOLLD5oou6RsiCIPIkZ
 f6ykg6grVYaAidNM9M+FQZw20bS+4H8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAzNSBTYWx0ZWRfX24vK2nI2+Smo
 wlzU071gndXYrfSUBOhKxsjQ5HBPEoLfEQCiTtRwXlRGJpDQiigOpHYK/vvjyZMyjl+iDqcynzU
 zOupootm/Lu34E7S5kFkWBuI2VnMK1zM4VkMyd1Wn04h+5Yh5DpV2iGHqFwRIbh/Y/Cl0YE3Dtx
 DYpdVItpj3sbzWid7zmxJ5MJcEYPwNOIoSsd3H7bKoBbF1oQHumtFZliAXVlasrini9ozuZO8SK
 mAGU4hIViUtsE0d2pSQ4TE8CvHYlsaN8SZx2cFrvPndGOoC0hDREIRJM2B25B/hqimTBNuoA64J
 m0o7XB/JmRa3aqTW7BlSzOIFpow9MMp65LZUUBdme6yEJq5wfbglWGg1SqssLz7fGzkQUAcSPbM
 XGccluDxgY2kXXx5wL7VOS4KEc6HXsF+JTAmMKPKk4pd5G5zrEepoSmkpuBln/ivT1/lz1BflWS
 ffm50k2DN8iBFyxBcMQ==
X-Proofpoint-ORIG-GUID: 3StpVppLJYK4nds7XuzrWH9QsmX0i1T6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230035



On 9/22/2026 1:30 AM, Vitor Soares wrote:
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
> advertise_iface_mac_pool and enable it for WCN7850 and QCC2072.
> 
> Other platforms keep the existing behavior.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Assisted-by: LLM
> Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
