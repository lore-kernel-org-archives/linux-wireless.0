Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793233695;
	b=YW+YQtlAxKBfWuQoEK2eojcCAcpEN02qycTIMRb0YJa9hWIojxPm3Bs5m6S3iImWTa2F
	 TvLe/n3oyJAiQcZcr64flTLpoInLwELuJMPT0AIKCMTOm1Mi44EW4Zf/pjSqywu2fhrfo
	 NdmUxdOAPWi7srH6rBIOVe6uoCIi/eoJVpG9gxO5Zr5uGBfMhb8tRV0p1kOYGdwg+xaKn
	 k4lUem6YvKSjOl+RHm6fbQVKuh1X9c4b5Ni1NoC5OV8486uRrwhdnr3dq3Mx6xTJ8FK1Y
	 9PWf4wBJTxprhtZfRRZ+VIWRWc8buVGHqH/j+DxtMHHJYJ6HDLWGJ3nMUnQ7ZbK7S1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793233695;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=161wcd9EPFoe3fJhGneKDOtD4VA/F1JbIvr2VPER94s=;
	b=3xsUau1OY4OgAEROw5OYgADRYyks/JbBFS8koCQy5eOoekWubbXXawTM4/JaqzeDJzko
	 n9dN+Rh2lHVHvdg2ByI+uCsePC28FlcOWlBsRqX7vHYUFLYiQ6FCe0SDm5qddCpSVyAu1
	 TEgYElfL1DdK8qN3MvGx//vgKGjCRA+JxQunXiLf2qQSdudBlIvnD43UQZaa2ejljHyT8
	 VI7hKMXDHCtFRyl5gYsbMU1FFpAciK1viiYctg0LavGI/Z2JCV7ImmEnY3d5cssOzT/kl
	 +5Pose6WU2GI64P/94UD+9YsERyUDeB+TIKdFYW/qHuAHRjxQFqakCSdf1vq6mJioeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nS5l03fE;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=c64Vynbm;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA33606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 00:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EA33606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nS5l03fE;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=c64Vynbm
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SMAQiO1877963
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 00:28:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	161wcd9EPFoe3fJhGneKDOtD4VA/F1JbIvr2VPER94s=; b=nS5l03fEVUvDe0RT
	cRhgGB4bxhYdd7GkTwMJ7APOQy6+oPJIUncnlhygtyk2VY+KPgalb/hnlMeBr0hs
	4i5IdqnU8daYm1b6lyJk/lv0UBaNj3pmgIxPFp7m9s7hwcepVnmOqj8TNmKvgVML
	RJs35MV1YQYdbAK/yaZGukQ1XcJq8Vkve4uHk4z4z9LDomtMoh/qSwaOBwkNpxWl
	LSBrTkJzsVoT+LrKH8zoApgwRfLOOlQKqcK7d5DtO6nuj6yGMq6PYSpfdxS342ZE
	TYDG+H4Jipn1F1JSTY7fwWtv2ow0Cc8m6h24lebVt1gnGqHtRnwYAOB5qaRhiAeL
	H8j2jQ==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hks3n8hyt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 00:28:13 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1a71dd190b0so4622514c88.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 17:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793233693; x=1793838493; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=161wcd9EPFoe3fJhGneKDOtD4VA/F1JbIvr2VPER94s=;
        b=c64Vynbm/iouzcW3TMdL7JakVLqzduYyfDPst5lEeeyHsZpoVJJNM7K94qSbRJGYB6
         J00YX2bvRFNVCl0Ya5iT4O36hCtDAwWYNch+FrhdlzorfarESFuYYdlBuMlTAcFkunm7
         zHmn2cB1ajgFQ6U0XUpcm6qZW4C5XW+4U01hDy+yE5Kn7+xg2SYo2EckEnuYbSgdTpbp
         4o/uiOwpf0au//x4iEPEeX7OKPXF8ZrAXew1XQvNCAPjZU0aGokk2mv12HLVIWQhvuUp
         rtq9F7qVStGnPL16F44fzHn9y7G13jZoQvr70nNQ45zQdN42vOXzGvTc/saWVLTxatKj
         9YNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793233693; x=1793838493;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=161wcd9EPFoe3fJhGneKDOtD4VA/F1JbIvr2VPER94s=;
        b=k/Mau9VNFFN3iyWDwWFAD0FXHnMhxz6qORD0w7mWcJD5vQLbiR37xqpnnmZkfWbnHG
         O7CcZdNaP/UP1I9Y3eqsv+gT2Wgzq/SjJBtvuAV0zCMuimg/FsDosQ4TVMTdsoynBN4g
         UhXBOj1OBNFFzs4VVnKfU1Kvt/5pewNFz80BAtxMWEwNwkje1yTqij1uxpki3VohmTm0
         n18A2GvtmzHPQb7zl2l1PlbpGY3cRS5IV28Uu4oKltui/gi/mnkMtLbH1NhekIQ0lKaa
         my8im63UHo6Njpnv+X4kuf8X6MRTQ4jlX+gX2lHAgcabfq1nzeBfeXkKhgkSKzqntjI1
         HGzQ==
X-Forwarded-Encrypted: i=1; AKwUvBzTA+9f4xg22UU4MfRqbZSrTv/EO4w5ARN3N09qlSfjXNJqB6+n/taPzkhx09H3Rzw7OfuQ0D+978gGUAgBdw==@vger.kernel.org
X-Gm-Message-State: AFq9FYL44C/jfDdLeEB8R+D0WyIvr/nO3rR4Dm6bkkVWMhcKBbcMjRJu
	1VyxiMI8wLschxY/AFJOljrVuNEawCtf0f79X6gQx3rGjtG1oV+36I9b8j9kpu8W9pO1qbm7DG3
	lI7uQJmuU/6yNIo0wSgpxz1xI2hhBOv4N0FhEeDvflLujUR8gn3T5c6GNH83E+W2mHBP82g==
X-Gm-Gg: AYBFou3vvaDReQaQGjeulJx7YpWDmfrTt62q96zNtrEKaqmmuELDIktAem0J2Te/ibR
	6wjvaXdPQZypOgWs2UoimxfZy+VvPV8LD9a1Cn1rOSjLJV+/2OHiF2lHaoOgfLixG3Y5+ODfkHt
	0OjjPK/kwPX4sEGHeDhrS7FNf4h5UcXWD+g+LtBZvlPXcjeghLVkHt1klgC8bRmzxYmZh/ycwKK
	IM8/Re8clyD1rd9VJ8Acxu3VDc50Qy8VL7r2t9eLs+d/eVdwJZHdxrV0OL6ITjTaYk6Z4FZnEb4
	ZhGApqq2Ots+2jYCDlpcMDbxi2Hf7DVfECsuZYIBbZT72/lLJhlujMP3xJCslNPvqfee5yibzzF
	HpwKTAzi39dI7JTgOj4Tpbq84+St2RnnOSw2EkT2qsmJF6a6YWTnZM0gPLKWQUsHvaxU8+3hCiF
	w6BuJSD5MbdkWFxNo79CoROx1oFm9UW6E=
X-Received: by 2002:a05:7023:88c:b0:167:d73a:e994 with SMTP id a92af1059eb24-1a6cd779e67mr6125344c88.24.1793233692828;
        Wed, 28 Oct 2026 17:28:12 -0700 (PDT)
X-Received: by 2002:a05:7023:88c:b0:167:d73a:e994 with SMTP id a92af1059eb24-1a6cd779e67mr6125313c88.24.1793233692158;
        Wed, 28 Oct 2026 17:28:12 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a76056a001sm13527135c88.22.2026.10.28.17.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 17:28:11 -0700 (PDT)
Message-ID: <35ec209a-a62c-4fd9-aaba-edeed86dedf5@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 17:28:10 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] wifi: ath11k/ath12k: validate capability TLV lengths
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org
References: <20261028051254.147628-1-yaojiale02@163.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261028051254.147628-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: om8WZCpdhdnZZ2s2gCn8gVsvZn-Cl9eg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDAwMSBTYWx0ZWRfX4zkws7Gy239W
 fCxKXak+YXCya0KG2J1jc7ate+db0Bc55Idn1pIAbTdG4NfSWRTvEXiMKJFKtgNsZu51VQJNWWh
 KKJthuyst2Hpv8gHCHF0gjOYTZt9uSELrnxkfHRYM9FLBFjYqa+Pj7eDo0U3Xb71FMRx6u4csiG
 YMh6AfjtJolmuaHEMKUbghtGnQxyqjA5lvXyhlFMzohh3/QmcxSIZlQiKOS2ly1QDaAwKbQKfdU
 HZkeKkN6SUCOmQMHO5ikTNZmFNVhko/l3qfLjPx6FsZl8XqNFtXgVaDj4ZjNWbtth5YMgO/WEOe
 Jbcok85XsMoFekphwgiqjnzx9ryGB+ZG52phKl8aWrwd3gB28MXIaT1w8ykP5vv0Q3Oj0A4txq+
 2LFZFTHRwuOUco+U5Glym24xHpRDhMloisWTHK318XSIt/Jys6WT3Ipb5/jx586jNJMSy++DD6V
 jKaurYpw4YB/eaoI1Sg==
X-Proofpoint-GUID: om8WZCpdhdnZZ2s2gCn8gVsvZn-Cl9eg
X-Authority-Analysis: v=2.4 cv=XZEcX455 c=1 sm=1 tr=0 ts=6ae2931d cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=zf6acwKC7uJQSQTK7isA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDAwMSBTYWx0ZWRfX+jjZ5t+NSO5Z
 q/3ox19M2fV2arEzIIO7jZH9ibpdonvenZNd7FaM+7q5XMXjKRiH4OQvmIa42Fqdv123rxL02VY
 JGBY230mu3GbmRNbhBAX3FhGNc31WtI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_07,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290001

On 10/27/2026 10:12 PM, Jiale Yao wrote:
> Several ath11k and ath12k WMI parsers count firmware TLVs and later
> consume them as arrays of complete capability structures.  The generic
> iterator validates that a TLV fits in its enclosing message, but these
> tags have no minimum-length policies, so a short element can still cause
> an out-of-bounds structure read.
> 
> Add policies for the DMA buffer release, hardware mode, DMA ring, and
> extended MAC/PHY capability TLVs used by these paths.
> 
> Jiale Yao (5):
>   wifi: ath11k: validate DMA buffer release TLV lengths
>   wifi: ath11k: validate hardware mode capability TLVs
>   wifi: ath11k: validate DMA ring capability TLVs
>   wifi: ath12k: validate DMA buffer release fixed TLV length
>   wifi: ath12k: validate service-ready capability TLV lengths
> 
>  drivers/net/wireless/ath/ath11k/wmi.c | 8 ++++++++
>  drivers/net/wireless/ath/ath12k/wmi.c | 8 ++++++++
>  2 files changed, 16 insertions(+)
> 

I was surprised by the asymmetry between patch 1 (which just added validation
to the array entry TLVs) and patch 4 (which just added validation to the fixed
params TLV). After a session with an LLM we came to the conclusion that both
are incomplete:

The DMA-buf-release event has two independent OOB sinks in each driver — a
fixed-header copy and a fixed-stride array walk. Both drivers are affected by
both. The series fixes only one sink per driver, and in a complementary
pattern that makes each driver look "done" at a glance but leaves each one
half-covered:

- ath11k: patch 1 guards the array elements (_ENTRY, _META_DATA) ✅ but the
fixed-header memcpy at wmi.c:4669 (16 bytes, unconditional, from firmware
payload) is still unguarded. Needs the [WMI_TAG_DMA_BUF_RELEASE] policy.
- ath12k: patch 4 guards the fixed header ✅ but the array stride reads
ev->buf_entry[i] / ev->meta_data[i] in dbring.c are still unguarded. Needs the
[WMI_TAG_DMA_BUF_RELEASE_ENTRY] and [..._SPECTRAL_META_DATA] policies.

And since you are playing in this area, my LLM thinks that
WMI_TAG_HAL_REG_CAPABILITIES_EXT has this issue in both drivers, and thinks
that WMI_TAG_RSSI_STATS may have this issue. I haven't verified that analysis.

/jeff
