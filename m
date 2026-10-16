Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1035F282F14
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 01:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792115036; cv=none; b=YZ+KpGzeZIJsuxOvziB5nyPTCWcdA8Kzasx+oew9xnhMm9CGukvOAhusSGThs2/haAt53cTBAgH9vhVfeNmhmpKMhHx3zApClmjRoFM4KeO/ayqRt+5KFuyQiLdf+LNMfQoBlaLsXejk4UYdfNdGKVpRh2vug0mVV8Qkx1+/lp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792115036; c=relaxed/simple;
	bh=kQkjlsIrQcHp2Nsx17GlvS9gPFBsPnNLRmimpEElKy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kR5nrSs3J7pFdagAvmreWC+vaFph0e1shpRSpR25R1LGSRh4sYH+CXqZMf9M8XM+k2/3R5hll4RXHCl86asA4OzrDom+bd1uqgRWhth+ZaTuRCP5Ckg9wrvSZrr8LS79o85QIrz8vT5usRMLv6JM/n4TW27z0H3+Wdl3HpBvTMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QL6IvYB9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bO9pe9MR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QL6IvYB9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bO9pe9MR"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKRhql3462800
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 01:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d2AdVVW/1VpGBm6jZek+loZ/L/qPi3e0KDm+GCFxSGY=; b=QL6IvYB9Pb1vVLzF
	IXjkvxRV9jcqbQQ/dczG8OCsZqgZTtLmqPFKo7MEEsmtIYUS5mxCwuAZM6UbOUD6
	JlPCHhp0piwaz07IGMiohubcoMP8VkWm1sDmT+lEchO1PzoR0L+J2lzKgKYa1wtw
	zFUbRUPuJfoKFVtbd7brLJnWKDx6RiGrwl597g11T+YwCUqHu9DKuCKVo33bg1wb
	Nx5ymk383xgIYrsCTX84a+IledBVnWqd+GApJ6MtDVcTurcd+lK7Mxe9EEIqWWVI
	y6WezmyliYkzcpF0fyum8d70JNnAoE1LcevN5/LUNqLQr8w02x/yChdaIRp6BZK2
	NsJCRQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hayu6amv5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 01:43:53 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-89f2846ab57so656723b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 18:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792115033; x=1792719833; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d2AdVVW/1VpGBm6jZek+loZ/L/qPi3e0KDm+GCFxSGY=;
        b=bO9pe9MRUhbqpltc0Th8nBQBavQam+KsdfIpBY8Tb+jiJCvYodDFLUgoqfAmW4WZNW
         JO+7Q0jMRpIZKcsUzQuwwS4uofsSZYkdv3PXbT1eWURdmK6Ed4SvuykDcBjvu0EjXIbK
         7tG+gb4J9KnEpcsRv3gw67WNOUwqd1bVURkFECH5kqEB05hjrCCSlXCKmJYC46Kigg/n
         3vTs/vaMcm6ZBpIHTQBtt9AA8qLVUij244ED2caMdT27XXOUr+KAW8oAGoM4BKt4gR3O
         9Taefjd04kxAgZlqFuVy+karRHLn8fFFzCp/XVIvAAgD7duN2QTINVq7/yNzRskpdQF6
         3IYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792115033; x=1792719833;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d2AdVVW/1VpGBm6jZek+loZ/L/qPi3e0KDm+GCFxSGY=;
        b=Hgv7PtBnuwcPTSg+xQ7ivEit2tHIlHSvNWUWyB2CgN9tDT6+oUG+4ismPz7rt4+tUs
         jTEY3A5YnxjhW5mqmrC8YzVRCrGBIUvOsdT3iKrVFvfCHBlNYya5APDhGzzMbZTUtJET
         oAbxmVJMPoytBzDDnyMOiOw/HZpztEdgu1I44hg7y44vuhoq//Ty/m1Cd5Z7rnzNnjmG
         CHFuA4NP9hFy9J75nmF0vX1TiANXw/xz+V0aeKwp9FZCUwJTfeP9kRWvnimEOjfDxIDo
         +1O2I7wDt73K9dBO5a9ZoN3+rpzqqowB0iQV7abOMlUVN/S7OT4GwB2JkrAyLxfDlRXS
         8h1w==
X-Forwarded-Encrypted: i=1; AKwUvBzcT+N8zAeOegmYowhGx8h/EmAwuAkCfM1mxlhM4WoSuuPgDBeXZNNpwLr2zL3x9rTintcU327rWimFHr0eLg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJpZPxk6+3jo+orarcUCsOhNLYtRcEUN6/rK/syA6RLhbWvhx0D
	ueS1uXzaxX1RkzdYRQAg5WN64BzME+IeiCAdIkD/mR7OFdUVP/ZeNeR4lzlAiKB95qUiwTnjjKN
	Ik5Rmz+zhgmTHDqmCpQbVXw2joSHLqLTuocCoscpPM4aOSLeYH5Xk7EF59CsKyzKD5KOLYA==
X-Gm-Gg: AYBFou21F/EwGaNIqSc1LUKPdYr61f2BW9f9pUCBqm4v/xlZ5CgF439G4oO+T9gYXOA
	iofH5ECELL7TIU37Dj1yue6pLyNFno89ophosZoT9qF2MmEX5FRdWNTIf/TC5BlmhQ61eb5OQY2
	cGhwKtqRyUmo6XITVszK7OIznKHxyCqBWa53nnep94IwyNHJiySuxinaRICAJBCoLyfAqA2iqUS
	EHpEHTp11SRJ9rf9gqZWtGDFoGZT3TiVawd6oPV/ma/CyzRXDY89qBuo1wuHZ0zj+10qzHwTs68
	dtf7nYMtGbQbrmKGnEIXfduzTrfBKye7cxAK5qx53Uob4OEkKktHvdAni2nt3vIWJMmprzx9296
	DMm/VSHf1UdOrdW3wtWIPv0eOupAamGBsSddVGoAZ6+YFNCZXvKNIJ/oft6bS01eGTV9yeVg=
X-Received: by 2002:a05:6a00:2c85:b0:887:17f3:94f7 with SMTP id d2e1a72fcca58-897c3ef90dcmr17799428b3a.1.1792115032734;
        Thu, 15 Oct 2026 18:43:52 -0700 (PDT)
X-Received: by 2002:a05:6a00:2c85:b0:887:17f3:94f7 with SMTP id d2e1a72fcca58-897c3ef90dcmr17799413b3a.1.1792115032341;
        Thu, 15 Oct 2026 18:43:52 -0700 (PDT)
Received: from [10.133.33.32] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f579456a1sm326500b3a.35.2026.10.15.18.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 18:43:52 -0700 (PDT)
Message-ID: <55cd74fd-cab2-497d-83c2-82e485b1dae5@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 09:43:48 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: Fix failure to create
 ath12k_dp_peer on MLO reconnect
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: mv8XQr3X51IHM_abRaZz4F4VSZv1F847
X-Authority-Analysis: v=2.4 cv=ff04WEQF c=1 sm=1 tr=0 ts=6ad18159 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=FeBjiSnNOcrKIJN5QMIA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: mv8XQr3X51IHM_abRaZz4F4VSZv1F847
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAwNiBTYWx0ZWRfXz3UywPguOoFX
 RVwubsZLbyNlHgqi12Nhkm1OSPFBKp7B1rfpWv9gUskSuFuRv02/YtNibsLvp6uUwS279C/JXwf
 qEr9nkKvG38YZg/3pobrlLO4WeZ8B1/e4ewgovZ7x7EDUrUPKIZkHnCDWsXk575RPcHHUTfigUU
 Ba5sox0RiiKcquLmd3PzsULAtDEwJi6sObhF20JyV2wYBO3Oz0cSWqpqhXAEiIPe/TZmTXRzJFU
 HjmjKYHR5/PSpUSckIsfKNPyko4NKkrjgNC+sl2Hjl/e5KqOhv07by9YdkZ4EPRLWECvvIJkhBd
 UuM32diL2I2+Es2NqkyCrImU7AF8PFDwLkNsH0Ci9ZlIwVobi0Ry2dfuuwXdUUGQL583MQ9gzf2
 Eb1Kk16PCWjnqbkxLIIDnI40W+l7mQn6UVBY+21uGch9BB/r4NcogPcUIJfX1Knkc1rDv7u5FI8
 xHjX/i/XmnG7ShZMm5w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAwNiBTYWx0ZWRfX1otLddDp3rNy
 zWglilruABISxrAiVPZFKBEfdTfLKDxMKk6Nwu5vLhZ0h0eHLHqKC9BDdMx3gPr56lKIhPATPhB
 yB0Tf/l81Xe6gqL/IBF9SYbIzH/+7mQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160006



On 9/15/2026 4:00 PM, Miaoqing Pan wrote:
> In ath12k_mac_op_sta_state(), when transitioning an MLO station from
> IEEE80211_STA_NOTEXIST to IEEE80211_STA_NONE, after ath12k_dp_peer_create()
> succeeds, on is_sta_assoc_link verification failure, it takes the
> 'goto exit' path instead of 'goto peer_delete', leaving a stale dp_peer on
> the dp_peers_list.
> 
> On the next connection attempt, ath12k_dp_peer_create() finds the stale
> entry and returns -EEXIST (-17):
> 
>     wlP4p1s0: failed to insert STA entry for the AP (error -17)
> 
> Fix it by changing 'goto exit' to 'goto free_unassign_link'.
> 
> Also, there is another error path in ath12k_mac_op_sta_state() that
> jumps to peer_delete after ath12k_mac_assign_link_sta() succeeds, without
> undoing the assignment through ath12k_mac_free_unassign_link_sta().
> As a result, the link RCU pointer remains assigned and a stale bit is
> left in ahsta->links_map, which can trigger the same -EEXIST failure
> on subsequent reconnect attempts. Fix this by redirecting that error
> path to free_unassign_link instead.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 0cd46d1f36ce ("wifi: ath12k: identify assoc link vif in station mode")
> Fixes: ee16dcf573d5 ("wifi: ath12k: Define ath12k_dp_peer structure & APIs for create & delete")
> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
