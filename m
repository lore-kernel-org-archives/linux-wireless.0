Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793775205;
	b=jyI3pVokyAG324vEYxyVEZI9hXelK6bvM5oYDlgTvl32eyvEgG/C1t62zA3qk63IfNGB
	 tP5bt9XI4Mt44m9Y3IZe+RgGJavKulNZNHuwB+scDtz3qYCq1nw3FIBglEdtKDDFgxHpV
	 lXYcwsgIlM2YRzkv0sZBh0Fylux4aXm0qDvBydG1mKmeXTRQHbS0C/mUccIwFyOf9tRC3
	 Gv9zkz05NS5SeZHmffc7z8Xwj3NSwxlZhLJVCD+ibZqe3OAF221/0971d80qGEPGtPa4F
	 hyir/xB5ILYED5cYd4GAxz7eYO92DmCJaf4TFhmQxNAt/h5ZYT9y2cDW+n4bflys7xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793775205;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bAsP3vEcsMK2Pyfp7DECuhtXhrSBH3wv4vtWNL9Hj1U=;
	b=kk/FnmJs/bpJi78L1Pz+s98HWqS2TwndUw/kwwbanLgG4gE/hTy3cmgYzFN07ywC+WR1
	 NGZT434BPiYAP/9OdzdUqXWy7SmRrmLxhoMkvWvbTxGKVwE19dKkMMw99oJjwToTiOWW8
	 e2gd4wCQ8i08m2LzWs9e1svYUU1A05SnwjvAC2O54sAC05PzFgF97FFMN30nZqJoGDYO/
	 alzgvS/5STzNBVvqQoGCWgs7ILpg4tFpRQC0Adh11uIpwId3D1wJK1++YD4agHIn/PVGu
	 0I9S43IDZyiVrbzUvGp+ImI2ZJDot+Yr9IDJSWzfIcFaskicI34DQzHk8rm+7EaaHPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JnrT8aeB;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bJsWGnIj;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09CB606A326
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 06:53:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B09CB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JnrT8aeB;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bJsWGnIj
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A442CmC3300277
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 06:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bAsP3vEcsMK2Pyfp7DECuhtXhrSBH3wv4vtWNL9Hj1U=; b=JnrT8aeBkvY2MHZJ
	ggyESnE4tBC0LAs7gD19JJW3qSkdEA8ngg6p+IR05G29hn45K3BTEh7bPj8s7Fr1
	oxb90hILLnQmYU6Ga+kbmvk7vrVmL4Eqj8OM/K4Y+IUAXvL6wglWZgnyqFKumfHl
	VqdjwUXMErhHP1QCV/RRjstfD1QiGUqOo2ICBL1lIQSSJrso/7f6a8CdaD6g8Ho9
	FZd0eFRtwbaHwNNIbSvwPLTTq41Yz9qq4oMCe3IRd7uG3lCZa2Ph6cis1362xK8R
	NwlyZZa03NNapZz/CZXTxdUJGQ+MDkd8MZ2CcjbMKxaohe2B/S3J/9n/8WjW3nDz
	heI+uA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqwb08mhf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 06:53:23 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ea446ea8c9so10718025ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 22:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793775203; x=1794380003; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bAsP3vEcsMK2Pyfp7DECuhtXhrSBH3wv4vtWNL9Hj1U=;
        b=bJsWGnIjxiZewPhPr/gwA5eK/EjrRSZVPCt9qp1SmBeIXILowXBFEmKSX6z2YFaBo0
         3HVqKuUDSe6nPDoivbQXc8j1EiknlY0/cFnWkUGCZPCtNES4/omAMkcCH0z+dLXF2yzz
         XgAbYsZ7QP3lwB5HibSkjSr6hp0S3Orf6BfH8zbtcjKfqfrTSgs2B28vvjjBlK4XQNvB
         p2EB9FJ9ZOi4FZUYYEBun/5qZ8X2x4CDZRbyvXK8YgvsFcl8V84niSf1gm9tpT6NAvUd
         HHmSx3h8Yj1EA3Foq+Mf4cNGEhNLOBv0fbLcPzRVsBLUkTZ62Y3IKLyW9UYJnu/8/Wie
         UPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793775203; x=1794380003;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bAsP3vEcsMK2Pyfp7DECuhtXhrSBH3wv4vtWNL9Hj1U=;
        b=PZyv4D/h6u+YVBIETi4U0kPB0zxZ1waRbxBn0CPNssDH0i06T349FNcJWnCsJE2CPg
         IjCrThIzkTtR5QzispN4lqZaS2yeLCqD4GMdlWmRzfunH3XcluluvbTw3FdbnoywyZYD
         hFZOjPL+qlTuveyRTzwQ622U6cOaeiaG6xDICDiLkb9pUrqububFBeLvozsJ/4ItGw3L
         WVSoq6VOOICdzirodzC/t7e7pQfyqnOhG0WxgvQUXZ6J/Frqd7fnKpKVfabokCD7fIhm
         yCZVXv2186RJzd1k0OhEnI1QsOAZx2erxhJkSxaR5oZ/Gpt9YJlqbUh+wF/XvhLW1GZo
         CwZw==
X-Gm-Message-State: APuU4Z/OIhDDgQxw1HkK6hYWI+gvrdVle0VDgli1Z8zfW2C3iKTyhuSp
	uPqvjSaxUuzG8uB6kdD2tUBaPcUHzqieHG1iw1PNvPYBlb7Nip2wWvASmoYUaUYUsxd6OJNSG89
	PyKRSgPEcdiNp+UFSMNAGau1r7265xt5Q0jdM0VOkgXByqCdxda76qRzgCsNUaS7YCLtAaw==
X-Gm-Gg: AYBFou24CPdB7negG682CVu7kD+lkUFRsLyQKpKdCxi+fKY/oszpETLeTuGUvKzxgPD
	VrJeZqI0SCF4/Cm+w3cwmCcgc3E6IQ08bWn+7/aJEf2OLdcp0dOwVsKjcWDK9vcaX36lCnJRlBT
	raK41VmRKQpiGI+uLnURZkMErQAw8Pjxqkgrm0tTc8avvrNYl6xh3XjQJke5abkn/J0icd0OXWv
	5pqfqeDDAqM2VuN120LcP8k0pVacRlBVlVjjr0K/WKbSVsK2rwDh4rDWLdFmXr6hMWGKrrZ6xLQ
	QtD3eEeFQMl4prJ502OAXVS+OE+3NSWszagGjnc948XyjQxb38JYhOVQ3Af4RX75v+nKcU0fw3A
	++c2UqQIjsF30HAfE8vgW/FL5hsHVzu8xCrUvUb3blMrF23Y+ltFv03akgXUXLnBYQ8WDj9EdjA
	ZVtZkEkmcQJ7axTIKTQ4pESH7yCSv6c9YDkBXIwNCLCyM=
X-Received: by 2002:a17:903:1aa5:b0:2e8:5857:b5f4 with SMTP id d9443c01a7336-2eb364961c8mr99565715ad.10.1793775203240;
        Tue, 03 Nov 2026 22:53:23 -0800 (PST)
X-Received: by 2002:a17:903:1aa5:b0:2e8:5857:b5f4 with SMTP id d9443c01a7336-2eb364961c8mr99565615ad.10.1793775202770;
        Tue, 03 Nov 2026 22:53:22 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed090724d1sm3471465ad.35.2026.11.03.22.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 22:53:21 -0800 (PST)
Message-ID: <029eac4d-9516-44eb-922f-73ebce894925@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 14:53:18 +0800
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
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: refactor m3/aux_uc firmware
 memory handling
To: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyNyBTYWx0ZWRfX+PMsPLFSI0LN
 mDGHsywk2FS4f0FQVNBY5qd7Eg4hjofvkiplz3VxPNSGww+GfQXA7giRaoTPU+CuxYTamiowOz+
 57j4YQ7Khnwy2hF0CH4MY57zDOG7EDU=
X-Authority-Analysis: v=2.4 cv=OfINnRTY c=1 sm=1 tr=0 ts=6aead663 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=WH3b8gmyxz3kVt_5t98A:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: y1s89qaOZXbcXBNGOKXdEIdacJDjWU6X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyNyBTYWx0ZWRfX9ippMKuSnv6/
 Vb/dZVP1aU3/U4PFlK/CxZ4yyOjA6FG6u1mTMvVj5LIKy62DVyBy7Scw6Hq5DmEEUhMZmypDV5i
 XZjs17fzv6qXiIOHWZqirJj2H6ALbe6SX3krZHglI+/mhtf8IRTfeN81Ds1DAxdPD+cBu5YB4Qr
 GBDJr6nn5k45kV5agGZzTmksrEn17gAimFKW/iwPpHho60dYLSvWxrCUmE6sKdFNLZJuuu1B7T1
 QH8S3vjeyn0wa+Y3Z7jHP5Dui01nau+1926qIJZk/LzZG7lwqE5fI0WOSVwC1C0DU5a8QqIy1VR
 3XWYYA6Jx0DNvlqB86X8SO/vcC7cnglhdPoZoB2bx/ZgTp/N/LQGrHWZCgXkDnlWeYbxqmRcMsn
 g+jhcGNjrOWVzyvUG776O3bXDwNUEnl6lkxSs8OIpxADv6gMeYkfp9R5qDstzaMangJmhJMlC7i
 hMD04dj1Z2vKFPHCLTw==
X-Proofpoint-ORIG-GUID: y1s89qaOZXbcXBNGOKXdEIdacJDjWU6X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 phishscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040027



On 11/4/2026 2:30 PM, Madhavan Ganesan wrote:
> ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
> ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() carry near-identical
> logic for freeing a DMA-coherent firmware memory region and loading
> firmware into it. Factor the shared logic into common helpers.
> 
> Patch 1 is a preparatory, no-functional-change rename of
> struct m3_mem_region to struct ath12k_fw_mem_region, since the type
> is also used for the aux_uc region and the old name no longer
> reflects its purpose.
> 
> Patch 2 refactors the shared free/load logic into
> ath12k_qmi_free_mem_region() and ath12k_qmi_fw_mem_load(), and
> rewires the m3 and aux_uc wrappers to use them.
> 
> ---
> Changes in v2:
> - Addressed the review comments.

this is not enough: you need to clearly state what are changed in each patch.

And I already gave my Reviewed-by: in v1 review, any reason why you didn't carry it in
this post? I don't see any major difference between this and the previous revision.
