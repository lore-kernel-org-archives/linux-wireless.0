Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70C31B4156
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 02:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785120064; cv=none; b=pRG60xzixrWVw+5+za89JA+3kkdmtMPi704FkGlWnF4MWvrMjCxUEvHQs5WRTqYl95LxIz1AjksNHZ7VgL21jPGxhehEJ+ByMzd333zzBpKDs0H965zpEikYqodpRFwOkqnFfS8Qg/5lFbJT6EapAVxHbEk9W9C+wpzIffbgC0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785120064; c=relaxed/simple;
	bh=9b40sx68PHlLGqEQC+n778zUP1W23HYxaHg2k8zv+7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jzeDy0eJM7HXp9D4L/s/sa/q7k0W9ywQHW6Vz48f+5RAuAoMO2WEbz5J0BRKKoIGw9rcxPDGLqEPYqyi3zEH7TBkE6WoRsefHJc1ga+4tUDjetiaS9B/ZfTG0O/NbnT0D9RqWJE4p5GHyJYplI+j070zec094Kn8JNsPbPA6JWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MfAU3xVj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J5u8cFko; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MfAU3xVj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J5u8cFko"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1fkgW2381456
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 02:41:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TK6NjlG2f4PCV5CwJH5F1qGJLsW62BAIhYSmA0UjeXQ=; b=MfAU3xVjYWRO/RdL
	18IYWj2SQH8x9npH37BIvxA4z/Pv1B58Wmb1pRT+3UeRePlFVY1MESzHH+qtDAE1
	hKw4eW6FrqNXjZzoDvNja6/7Equx7WRAngyM2wLg186YoRHW2XKfQ4NVOPZeBoMJ
	9/jWN3nc+UZ5iGiGVE5HyZcp2sjeUbx3RnSDYXLPwabsjIPs+vcGmpssYxT64sjE
	UpQbQQOhta858VVshIWRgvYHEpsvwLLAR+fnWeSJorYkFwa9Y9bhBw45h4LAeCC3
	iOfg/nywlvCk+NM3VsLf87EGz2v61K7fHAmIQahtBS+R0x6WsHAarXbErujFFRZY
	BvVuSw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmn7vc6g1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 02:41:01 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so4766564a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785120060; x=1785724860; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TK6NjlG2f4PCV5CwJH5F1qGJLsW62BAIhYSmA0UjeXQ=;
        b=J5u8cFkodaWV8I4CECK4MUAryafEu7hPiPCqQMWd8P27lc0RCb14vU89dGDSZbtv8p
         kwTMJJazLBPX6XzEU5hpZcJfk1xYsR2WnayK1OsRO2Xo5loMMigMnzUod5bipFDrUTtH
         /R2pa9HK808FYneQheBgHhX6ifkcgtGgN4DBIgREhu4e0Hxoj9RHwubKAoIrpWFb0JVk
         CxAl2ipkmoCQTQMVXdgppKtCWSFjaDjZXCOXVerAwlNO08HsIjrO0vby6XdevCRbUHBJ
         xv18Y74pu+W5xINHztkewush5aJ+abTHaK4QhcQsB/hzrVH/B6/ReHQp4R9qGZeTD8Ww
         rz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785120060; x=1785724860;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TK6NjlG2f4PCV5CwJH5F1qGJLsW62BAIhYSmA0UjeXQ=;
        b=d7gqtCTTGnNrf46VZGz38hYtUnGNLER/y1A8bBfxt7d0631Q99Xw2XeQ/OCYd6ejCj
         Uwe+ysKd1jECY8qx5mEQ9bDRBhnfcJgPx2MiFjA7KrcT+nyBv6ifFwIlpzl1qE1xKt+R
         XKUcP3TaBMK4xZOOcF4GugwTjSpH6WG8V21tvpIw8t1Ocr3Fn7FFFx/8OW4GNrk9dFRx
         PBEv0d2oijnXhWih/bUqD5d9XcJtxP0p3ivkKMBW6dS+MKQDcT1zV1cM1CJGYSTdO+Bh
         cun4x4pYWDxylcCBrPOHMciDX/j9s29l/ORaTkoJyrZr5p1S9tQJOFBioe9la+n1iIi2
         Uudg==
X-Gm-Message-State: AOJu0YyJRAuxbmt9vdpE6Q6Rd+l7bb0S+R230H4Gpvypw0DMfxTLwP2R
	vXdkAZFSoQXg1gNaqfKXmc1WlenhyMEWqw9teyZp8w8C4+bIUMpLNNRf3oi56bNAaQc2rYCCyyW
	CdP6remOIPG5/rkaW7YH1zu+9stNc0Nn/l4P/ClUE1gnQhDtNn6v4WuKVCODb3PBxe1Jy7A==
X-Gm-Gg: AR+sD111xuAoLqklQr1zXGG9FrK+hT0wDow7ZXINGTxwO7U2rAwukucAEuQnOvDaMHu
	WUy7zjURra0rkITf5JuMod3oNr3ycE9/srKJYTw3UmTP4MVUh0KFVvJnRpwx+X37NRiVgJ7DXE9
	gYZd0c4cb3HVIBkZSD1lQWACnUgTo/ru4YyBecJRsnki/CeGzdbkyzCnmhj0uTVX1I+GIfLzWy5
	KPLXG/8DC4DjoavbPZwE7SrkSn2N2F8PHXQ9Okwjp/HANHeStrUtwxo7+AaN1Fu5pSSKkFJvfX3
	E+RxfuyiW60uACzIVZTKULerEaXHcwXZKJFdaMCT6eFkK6VLx67KLs6FFprxBZRWG57vDQJ042j
	89q+bI+fZq2G81ifRQBD189gNbbkIa+s=
X-Received: by 2002:a17:90b:254c:b0:387:e0db:3d8d with SMTP id 98e67ed59e1d1-38f298859c2mr6628461a91.40.1785120060273;
        Sun, 26 Jul 2026 19:41:00 -0700 (PDT)
X-Received: by 2002:a17:90b:254c:b0:387:e0db:3d8d with SMTP id 98e67ed59e1d1-38f298859c2mr6628447a91.40.1785120059795;
        Sun, 26 Jul 2026 19:40:59 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f041c3647sm4214768a91.16.2026.07.26.19.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 19:40:59 -0700 (PDT)
Message-ID: <8f327447-fef1-4c58-a563-bf4a0426cdb7@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 10:40:55 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: skip MLO multicast links during
 crash recovery in Tx path
To: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260723054653.2794550-1-pavankumar.nandeshwar@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723054653.2794550-1-pavankumar.nandeshwar@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GKk41ONK c=1 sm=1 tr=0 ts=6a66c53d cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=_N75d0clQG27oq7jPmMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: 5s8TDCU0tmRJMDnBnT-98jcJPIB3zBtw
X-Proofpoint-ORIG-GUID: 5s8TDCU0tmRJMDnBnT-98jcJPIB3zBtw
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDAyMyBTYWx0ZWRfX6gKTdnjvtWi2
 mJFnT0oMEl79pwdkltaOyo3R3WV3CvE/ki1uJvJDBsbs5wMkbRQOYSSRBG2bkqWS++pZIDqyI3S
 1BFrC7PGAZDok2DyaQ3lM7Uj67ilvRk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDAyMyBTYWx0ZWRfX5tm8zVLG5mRB
 PrBtdJJHrvy/K9xZNriUX5NJADOkSWkaAuBt94EiJEV1XeoKL4xbgi5bvNYahXJUAuYxYjx/8n4
 V1UYdfXlD567mYfQkR2bHo85SttqAVWDIXKTF3v4ruApw7qOaFUIupnuOzygkKWYz+sC8dHi0cj
 H/82qkJhHkHsOhBemQoQrS9cwgU48QkVQ8X9092E3SkDNg7OeGYtWJJLdLPcmHS0FFiSr9D/Ms6
 wZGYarq+soje73EHya5OjnrxR3npdytl2W0h5a5rfV+Yn4nlXtoj/tv9ooI+LVbJbww5N3eE4zS
 LYbJ66jWjYRWpwXbCOomdDNDVxWRc5wB5qfgRi7jOVOzYxzX10GfzcDY0HM+OjC4oihE81KEoDe
 iZslYWgchItkrCp5F0aRLhT3pwBOFsLsMnkFG1EFnhU2ulUic2VgfZR8TI2DS87K6QDVCtfQene
 wPU/57nOi9v2ZAFaVwA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270023



On 7/23/2026 1:46 PM, Pavankumar Nandeshwar wrote:
> In ath12k_wifi7_mac_op_tx(), the MLO multicast broadcast path iterates
> over all active links and copies the original skb for transmission on
> each link. When firmware crash recovery is underway (ATH12K_FLAG_CRASH_FLUSH
> set), the per-link copy is allocated and partially processed before
> ath12k_wifi7_dp_tx() eventually rejects it with -ESHUTDOWN.
> 
> This wastes GFP_ATOMIC memory and produces spurious "failed to transmit
> frame" warnings for every active MLO link during the recovery window.
> The unicast and non-MLO paths are unaffected: they call ath12k_wifi7_dp_tx()
> directly, which already guards against the flag at its entry.
> 
> Skip any link whose associated ath12k_base has ATH12K_FLAG_CRASH_FLUSH set
> before performing the skb_copy(), matching the behaviour of
> ath12k_wifi7_dp_tx() but avoiding the unnecessary allocation entirely.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> 
> Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
