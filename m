Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D48472
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 02:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791771636; cv=none; b=h3+g7EHp8nibiFlYK/WekWZZe8Lu2d7C5bLahrKqhs9Mmob2XO5eJp5tOb2y58ZnMAYlkIAzUD4mLCJmEqWqnJcPxz1Qt3sfDJUbYLNpt26OcfzEgLe9FuJoGXGcocR8Z5Z2dz2TQFQaHJUKTRyhVoAykiciv0ShDRrVjRCL7ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791771636; c=relaxed/simple;
	bh=YAHaAVBVek5LAWqku7s1t6d03lqarFcdrAPVyk0QG2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k7JqvctNidhK1/dHs6YE+iF4SC36LtmSfQOdhK5hsd5itAJp56DpVDfgTni7P/5dE4zuDEw40t8CU2pGS9NWC5u40j96O2zsA1nvNItE/xRbP8ds7TUNDjMqw6QZPDedD8wR9Qihkjh4KwRh31217RSNRz/j3exC+OFUhZ2fVaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oFLgV7oT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RQ+NlnKi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oFLgV7oT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RQ+NlnKi"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C1lPIK4078384
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 02:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nqFzJZ+6aY9XoFhD2Cu6xQfyOtfvQBfCUx/gOqgZ9JA=; b=oFLgV7oTqcorUTKv
	+ht+1gwSBY3ZIDV158M1ey9S0EozLKChPRGShirZ7zvnEBlLe/8/qdRrBLp8UfYA
	wFmhWRP4m+Okpe4KKkWGk7IzIbs/U5EuOvZT+gdTcgqy3yRcI4wsYO82X9Lz+cO6
	qaF5JBY72MRsq0SOFR1BHFY4PZyJa72bzgW1/Zz3ec7e2u6NPpVobkBsFtoFt8kE
	nhyYskRQagEXFIYQZQgV36grZ5Bsi08SP5eCNeQitYAHvwUWayx5K9lMj4uw445M
	FqWIYgxGQwv0kgqhsziSvFQS+ybzI739IwJLOetrPHyi1oyRpjYyZ56WXO8GhWNY
	NRtgAw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8j6dgj3k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 02:20:34 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d02df2bf09so12716985ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 19:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791771633; x=1792376433; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nqFzJZ+6aY9XoFhD2Cu6xQfyOtfvQBfCUx/gOqgZ9JA=;
        b=RQ+NlnKijuEauWzktaBv6u28A3hk50JDOfktBK72uOTwiM1HLi1wKhFZp7o7KjP17Z
         YEnURnHdVftVnU3+tZu9z9vYxMXADPOLzXZpKbbiPHTHg9Q6K1sQ7gDm7BaO54+S5bKe
         qpTOdMTTIbF6mUC3xdNIwA/+gLyUu77di80A1Yg8OM8BLcFL4FZyDwngiGp5o9KJlZ/1
         vmM17AqAm9JV9r+hra8lP+dMBqzjgHSxx1omJbzsB1c0uq4rFH9+a0aJwfbQXdtJw44d
         B283KXlxHwhZcOpJg7YMpKjH3Ah3eaQpO3/ybOVOJp34TOuY5CaSxqeilvoafxIPBsiR
         +oIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791771633; x=1792376433;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nqFzJZ+6aY9XoFhD2Cu6xQfyOtfvQBfCUx/gOqgZ9JA=;
        b=LQwhRG0fvquSgadfxJ+y88aVNkWAaWVzAxQ1xTd6qCeYiSd9v/9sJUshzQy7Ki5xGJ
         6C3K4zeybQ3cM6lqCPrOdH0DVp/vH/OsZwHsgjTSqpEpoUNlN0uCRzF0+vcv+bDt9Z4F
         4UMlCIsZ3x9Wi5Eu6EYn9ZmgTL6ldRvzGTWmENpCCl2LVj9NK02P0L+yuzU+aVoDpO3e
         mIUBYV+B+7rZ2wG4ioxy2zWt43c1AGDoPZBYW5xxvfaoFVFWPhPuyJY6lkS+8cCYJCqN
         2Fn4LQ8CG26leC/8+Ph7pfM8O0SM4BccvysrePW3pRPFRz76o7+QRhqChwEFi25BYE7U
         84uQ==
X-Forwarded-Encrypted: i=1; AKwUvByzTRS1cyprwhWps66ngDEi9Yjr4qZ06+JzPzPpDYrXvaCpot8nFIgXSqWuqYCvpZ6NPy8BnBbAHCtKVKygmw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIFNjwlnCCdq4um9YIMzNDWT9zv4CAqRsJPsiakrrNswAb+7muR
	FeY7mX759Ln5fUk4Cx/3UVYLKqWR+bGrDdNIMG5pKGPLi3cLFqROuVGL6oKh1VpKMtmX8ArHY5y
	W8Xhow3+1OIlQc3HTPP9WGdch0B7itD/XRNnuwGdmdobK8auJm4rWouYiXwsRpj6Ag4UKKA==
X-Gm-Gg: AYBFou1qbib9GdM1K7bSfHX3L4eEnRMtizTRXXQxMK1b30PaDHfKbV9yJ6MfTmcOc91
	HTPl7ZFP2sV2BB32l0FDQg+0WeVm/Ez7pwH7YHWVPjg+oa5R4fgqoMfmyxdme5Fw3D5rZZrSeMh
	hXi2OsBS1MTVUzTQO2Hk5EXTbkX3eUZ1W1+8FaWaSx8cEHP7fzGhPlRIU8dUp86kkdw4mB6B1Ah
	FV37hrmTjt+gTwQTsYbC7IIpZCmAot4l8RgJaAS2P8QlMqzlr15ToOqGtE5WCXPbQczTy8e+d9Y
	+tY1eL7zydaFa1nfSMpoBtp2ECjcdYU3hhCMclqtm2UwBKEOPGkFbhmEd/pxQpeNqTs6T/Z67Pv
	s2Ug2wvxP6C0JOPs+E3LXL/xQiBXAtLY=
X-Received: by 2002:a17:902:c946:b0:2e2:c90f:968c with SMTP id d9443c01a7336-2e842ce4136mr67715585ad.44.1791771633060;
        Sun, 11 Oct 2026 19:20:33 -0700 (PDT)
X-Received: by 2002:a17:902:c946:b0:2e2:c90f:968c with SMTP id d9443c01a7336-2e842ce4136mr67715185ad.44.1791771631670;
        Sun, 11 Oct 2026 19:20:31 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e2570sm38639175ad.79.2026.10.11.19.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 19:20:31 -0700 (PDT)
Message-ID: <d845c3af-bc5d-4aa1-b04b-1030ea66d734@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 10:20:27 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 ath-next] wifi: ath12k: Add EHT capabilities to scan
 probe frame
To: Gaole Zhang <gaole.zhang@oss.qualcomm.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, jeff.johnson@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
Cc: gaolez@qti.qualcomm.com, miaoqing.pan@oss.qualcomm.com,
        hangtian.zhu@oss.qualcomm.com
References: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAwOSBTYWx0ZWRfX+4SNsdMFKknk
 NNucC/I6U0dfTYScsp7FS1wBb3Idn6pLYoDtbWy+AI53QguHkHiNxnqIjk7ESHfaCrhTlbwv5cU
 Lr1xbxyikuby7AzQ0BBJLx17L4eFivRrF0lviK3f378W1p4s7OQpHRhWb3b6kUQ5YzuB4Rpqjkg
 wI0FxvgDIX8wOm218LbbyGOBloJ15cXV13f1vfmEnXbHzTTIUZHvmGYmdyMN0MDs/UHCtfWkv/t
 zyopq5JvpqVUCDFcLrwL7W4kNdAYlRWLuf6Yp+GdSu6EUXEAwibo+qFKU0R0vrGiI4XV4rzUkDG
 ou/P73mtjW0mFUCpYYbU1tJZyqEa/3bkTTdrPEA2VFIEdIaUaPP1HERY9/iewL9Y0AmRxv0jQ82
 SSh9kIkiLhmutq9lvOi2uahwG6JEp3eCDMNNAKEBd8lB7jLGnahpkBtD1RUqZJsS8GnpzGmTorW
 yph5XywD3ZANeW5BPdQ==
X-Authority-Analysis: v=2.4 cv=aK5lOr9m c=1 sm=1 tr=0 ts=6acc43f2 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=QV8Wo-qd4fzodxduY_UA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: F74TXVzr6sPXwKsZL_F4kimoX-sGSH6F
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAwOSBTYWx0ZWRfX2E00zs+mAt4y
 s8nItXB4Hd/cErLJcAI3Fa9cEmUzL8zvG1m1v/IHLfj97A131QzAn0kzI6QchRJRwWui45C285M
 F4XGkId9eF757zvmsZC9WjogwONjD3E=
X-Proofpoint-ORIG-GUID: F74TXVzr6sPXwKsZL_F4kimoX-sGSH6F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120009



On 10/9/2026 5:55 PM, Gaole Zhang wrote:
> ath12k hardware scan Probe Request frames do not include the EHT
> Capabilities element. Without this element, an AP cannot identify the
> STA as EHT-capable during active scanning and may omit EHT-related
> information from its Probe Response. This can result in incomplete scan
> information and prevent userspace from correctly determining the AP's
> EHT capabilities.
> 
> For firmware to include the EHT Capabilities element in scan Probe
> Request frames, two conditions are required:
> 
>   - The scan channel must have WMI_CHAN_INFO_ALLOW_EHT set, which allows
>     firmware to add the EHT Capabilities element to Probe Request frames.
>   - The EHT Capabilities element must be configured on the vdev through
>     WMI_VDEV_SET_IE_CMDID, so firmware can use it when building Probe
>     Request frames.
> 
> Set WMI_CHAN_INFO_ALLOW_EHT for channels when 11be is supported by
> firmware and not disabled by ACPI. Also configure the EHT Capabilities
> element before each hardware scan when the element is present in the
> mac80211 scan IE buffer.
> 
> Firmware retains the configured element in the vdev context until it is
> replaced or the vdev is deleted. However, ath12k scans may either reuse
> an already started vdev or create a temporary scan vdev that is cleaned
> up after scan completion. Sending WMI_VDEV_SET_IE_CMDID for each scan
> request ensures correct behavior in both cases.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
