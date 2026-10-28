Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199307;
	b=l2ONjiEPkfWMGAORYMdZ/lMen+sntRKjL332zBK6Q7Wl6AoZSjO6TxX2BRHElGXDpDjr
	 +UFH2CpiYgyJa4EYMz503Fo0naZZYJAoxm1ziHhJ2Snu19PGdJ7MDpo8eRatevwwRTx6W
	 Lj506M3AAEKgcvGsfUlvAzVGVs2ED33hbitgp3J71LQMZ39V/i76a0b+tOiO8PgWWA4NY
	 EInS1sisxzG7GSKL4S3kzH8HO554uYZ2NDK1VCEvgy26Cfm9EdR9QfZiJw5UoE8TvBC4M
	 1bVm2ydH/N8a2akzAyDn9g1WY5XUeYZ5GUjVaivuRFuhvc3d+ByWo3uk8wxEjomKXEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199307;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=BbfM4q1S2eDcLx5Acrn8FFVA4Ky/HliaM3KoNkQCYTA=;
	b=Q4bzRnrzfehqT7EfHzedcFB3zk9/2BhDw9qGxvtW0sbUxwk9qkyUTiBFQUmb8IRj0D8X
	 5HtM40DK47VSvBmgvq2DUoOH+9I0/y5HvRaOCLbMyWqEORRSghL88DZ0gBnHRtc++WnMl
	 up8K7op3YjWrgj8N/0F+G4gptlz+623bSxdDNnMm7khR8ftBGFqedyXlazzBVmhKXPwpe
	 Yyltb+CWGPVxCid+LDyk/g4G2sAYnhQE0H0X2ypR0GrlYWttqPnNbNZBBErdO0mEVprs6
	 wKt0WwsxXctyBD5xeb/z7B0KNpklbPrGe5IPSj+NhVJ5+sPa+iYJ7WZ+1evLNu8O9eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZRoUfoPb;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cFyROUrA;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB138606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB138606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZRoUfoPb;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cFyROUrA
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SDIG8e3916331
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BbfM4q1S2eDcLx5Acrn8FFVA4Ky/HliaM3KoNkQCYTA=; b=ZRoUfoPb2xD2dHH2
	5Ipt4+HVjNs3iEEgG+EcDE+jVtBM6CgX4YzMoXr/Ropuys5PKBPN6am/TcC44H7g
	OEekrV9gR3yl+/pUReerZx2x1OOAYyjvMeBuc5vGBayL1m1bZQLaKRp3EQ9Y3HF2
	XdFRxQIXO+NXyDukzgbx/AbD6NDrVXrOum43tpcOhrD1SC3VVGwn8R8OAWpxYsn+
	LfedsIO04wP2zFDTCBxZnd2ShTih9HyoueRYwr5SmzqUU2EOCcYJcUU5934/YCuL
	LHi1D3L/sNZ/0BY5cL3n28SAzaEEjtYeW4utjzwX7X/v9CndC2XH84Y4yNYdoqKN
	9uVG2A==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkhtnge10-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:55:05 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91c71966998so15358266d6.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793199305; x=1793804105; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BbfM4q1S2eDcLx5Acrn8FFVA4Ky/HliaM3KoNkQCYTA=;
        b=cFyROUrAd4QmnnI4ctw+RiL7Iw1ypmXiht/VxMnl7EgmgTAPMvdNviN+X9wn0vYMdJ
         vAwffe+pe6fq5wIhQEwAJPdZsfeji6RecNKH7rErU0exiSFtNiNF8f9QSuP1f/YoEqQ3
         Ph+GEzpKkgHrPIfLrkeSVV7UE3UzxRNFYL96+DwLYCDBj0r1LNosotwAohtqCElNbTqY
         KC8dXQJEAXIY1rNDcmXcg40mX8o+KDf7OKTM57Ix5uQY98jbcpyL9x58GsL9kk2/tnpf
         +o2XibpGogday+JI/0dyZG44D5zn7ppTGKl+U4NhPb+4YDCgIts7qMMVIDCrQxA9xkSW
         Uj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793199305; x=1793804105;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BbfM4q1S2eDcLx5Acrn8FFVA4Ky/HliaM3KoNkQCYTA=;
        b=DTuiWeaS5ZkH2wWPpKOGkLDsV1AGbowWwbSzrxtIjuA2HydxvWHCj4EjpgtaGWcpr9
         ioIc986q8pN+0sUOALngCzz373vwBHJbuuXR6xiY5+GNbx/WW08M2HJVeIbbZR9qgAEW
         kz+e25N4PFaEwZQ/z3fGOLARIPBOAJd23IayE9hgGw5gV1GYv7+Qm7HQroTNC6gEylBU
         smAP2Gt3QHtOnC9x4VPidUF5iRBie06oMfyA/THBVHiCvGSa9mO+NXazVFahGqHFT8rF
         xUEOUxUSgCRBqbNDBnTteqZhK+GLAXxplOgeMzcYhQ8GVsdbrDBowgFuM7r67ZvP+8lq
         CggA==
X-Forwarded-Encrypted: i=1; AKwUvBzq5TorqXm+b9zt3otsnPI9NsY1DTg7ilYZa0HwsASAPMY92RfUJqb8kK1OMuDAhez2HgFFSniM/HJ8tRafvQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLHpsYbYfz+ID4J6DfPWSBmUojYXgs1HA6ZrsigziQYeq6lilD5
	btsSRTkf64y1cbJ/kLG18Fg0OpAbyOz4t7aNHfxHm1YPu51AHOPVbuBRg9XZpDmTPRQFMJf0Mey
	sTtcmtnRy5le28UxNp5RM8I4PvcEsuhS/h6kFlFR9SpWYU4iJ+9Wvyp1I3rq/XFHDrDvxAw==
X-Gm-Gg: AYBFou3vPo2gQtyo3H7QfNR+MtE0EQJaiVaCLMHlha59OaFFyp+976Lcxfwmmj/DQAD
	246oTmZNSuN8fBeGONt6AFy/KYZfhYxrqldQHawwI8Fw7xt8EP+Lzx5N//Qp07to64G6Kdrson4
	oSBu2e7gsTUrTXY6Rs609+5DAwJiELwhOynFgj7EinqFz4lQ7U5EgJiYN7ASjuS9Iw1ILOvJECT
	1YTsPAMTGY3T1ed0QbByq8eH4Hkf+0t3uqT7pb5Keo6vlArIcjYMrltGLVntlwbClXT3bY0zayO
	kE5VDQs4o5I7L0240KIVU/d93xHzMApcjqyojctvyS7r9JKWPj7xE9V0as2+W/Vo/3WmdY98xv7
	CZVMJeVSdE06kZwmw7KGMRrH1LHk9AJx8AqrZljEIZ83n7jR7ssSy3JKwIqChG7/8FHceRlR+h8
	QbA1FeKKHZoPk56orAcMBQM+3G24emG3P3Aw==
X-Received: by 2002:ad4:5c6d:0:b0:91b:827d:841a with SMTP id 6a1803df08f44-91c7cfaf4bdmr38275426d6.41.1793199304792;
        Wed, 28 Oct 2026 07:55:04 -0700 (PDT)
X-Received: by 2002:ad4:5c6d:0:b0:91b:827d:841a with SMTP id 6a1803df08f44-91c7cfaf4bdmr38274756d6.41.1793199304200;
        Wed, 28 Oct 2026 07:55:04 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c6bc95b66sm64155086d6.43.2026.10.28.07.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 07:55:03 -0700 (PDT)
Message-ID: <d7388ba1-926c-4a2c-b79b-0fcc0759d4d4@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 07:55:01 -0700
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
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: CROEIG7BA2cikL1Ooy8O-8xsJWzxA45a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA1OSBTYWx0ZWRfX0rV0tzIzhSG9
 c6tkGi8cQWnXkQ7Z+UP2YacrrIBx8qSnyxL+RC5MjyhCoFw2ZJhBb6gu7eT7A6LCPs8vC2UWt6z
 Usa97PGv1K8hK34G6l26sYxQ4CHvAGpYfRq8gjKT8pVMNgHyhIPbpnfe0KCXgxM/Uu7UzK5utXO
 5AGzB8igrdQZGMahr9g8QubDMaYxSl7suwwmplSg07zE0JzS6ihGkfQaT+kasn5Mlh0IUwlMVVq
 nH1nChxC9imQlDF1ERuS3OGEq+OrmSsGBfYi36sYN7RJcedRNdQ5FTOv+ZFLPssu9smReq/DUUQ
 /7QwlDviG2Z7oWITQ1VRJzdzeabzWN9NHb6MHGkSszHeaVR+FGR7/WYuKwrkBHzyUAfWxoLo1GX
 zVz4Z7Fkp/rXKwgFiEIHPIUAcyC34NjpMwdLGdTMY0ML1m/gLbGppk8TTGRUfBG1vSfY8ckxBdb
 LzvGUNmIyKnbtwnGr0g==
X-Authority-Analysis: v=2.4 cv=c/A+0h9l c=1 sm=1 tr=0 ts=6ae20cc9 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=LpQP-O61AAAA:8 a=COk6AnOGAAAA:8 a=7uwlnTk8OcoAl1f2pbkA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22 a=pioyyrs4ZptJ924tMmac:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: CROEIG7BA2cikL1Ooy8O-8xsJWzxA45a
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA1OSBTYWx0ZWRfX6tedFqhhY8zW
 Ns23skd+khBclALOdcLz/rHIHjXEXWINinzrUEGwmM4tqDypyaYYs6w9Eth/0hUwddkTJD0KT/v
 wzukGrpCvITvIylxnfGvy8WUVbSCbKg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280059

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

-all codeaurora.org and quicinc.com e-mails since they no longer exist

In the future if you fix multiple drivers with one series, please send all
patches to all affected lists. Alternately, split into separate series, one
per driver.

It messes up my processing when a subset is sent to each list.

/jeff
