Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793407857;
	b=KLBXaXub7v/xymk2bwX2yaVFpP/M5MSuj1uEEcYwuAvuUezYa/ZvtU5a+/gN08YTHusb
	 xAhWah/uGfgqJYXGe22CH7NPMXEG6adPvr1tYqADdRR7Tz1ONEGCZIvANhnKFkRTFv/nh
	 ai/q/DAU9Ag3gJ4Xg4DH/gtBRAC1LQ2+w+2/dB2F9PM9w4SQk9+E4ZycReMPHXhb/8bi2
	 ixFVDSne8SXPIvmDlt6PEvYsZsyDqDPDl8okDAPA+pkzKarinOMhvAsU0XD2tB2wAPK6i
	 iOmNXQWfZi//uLnG35FloKn/2QPGw/hkJAr55CqyJ7ZUlpfbT8/xVWWA1c8L4zJPEVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793407857;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=6iLbcIK1ROxHAqAZicwghsY26jAXKiGL1CdeUbl58kE=;
	b=S7l57gCIi5oUZ6eJZ4pRqGkr4qQH3KO0OrklHDapEBO+6hrAllPCoaj5IesU93DndzZK
	 JlXKs7/jUUp8Rt8hmv1plA6aBy2vpiLl5xm6hfOOAQ1dK0H7LAItas1Ktif4NbAYLYEcq
	 dSBiSutHc0sK5vzLUdL0Q6JEBSePIq5tMoM8kHeVWgd2R3/LCslxljUK8GRJKkrKRZQrB
	 E+wsJmhpf0rxhX/uPMXkofmq8jBUyc7h8RkoI3mzeDEmxfiNndrIbUwmY30ALJynqacCj
	 1c4pfF6f+R8M6qvOUN+Equs5pzlUZ7nON5RahUXPX1ut/gPdHGcqNHT8e96KSfQ7qqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KaIL1N4Q;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=g70kZj23;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5736D606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5736D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KaIL1N4Q;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=g70kZj23
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ULtEpf3462781
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6iLbcIK1ROxHAqAZicwghsY26jAXKiGL1CdeUbl58kE=; b=KaIL1N4QFUwekjB0
	NF5mKnBlnGyRrXJ1omtGRYcwarwxq4ZrntPz0soTHV3AOUis0Mt5DF3Qyo3UJNVI
	kkN75NNzTIav0ikNd+Vx6eVZCToGrR5sCnvvH0mnRBhtgza8xb5tEqTzPm6ud0+G
	IV6plYy/db+vT5uUJwdnT7LrWTtQ59dAbezp2V/B233shL7XnFp+/lakiJIc1mVA
	Y6pqxAU1Kf0tMJWN1Lhxom4uRoEJW8AI4UM3zFv0Mkgx2ylDpCeXxwvr3z8h9iF5
	3zJUCayspo0RPxG9sSB/hcUxnH4VNGGMKiPZEkCYNZ+khxMur3+uzQlsNH3JilDX
	0ik6xA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn2x08gjn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:50:56 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35c5aef2a74so5118795eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 17:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793407855; x=1794012655; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6iLbcIK1ROxHAqAZicwghsY26jAXKiGL1CdeUbl58kE=;
        b=g70kZj23c9RcGdJQi/nhrQELMrN46AT6bpEAXnQSH0vJl4/Oqod5vtwe2YffiouqJ3
         HPN7zV4S0dVrxJFN001CqQvGYsmgSnLrAaseEVsIvFRDn+dqq9Oay6oXcSA62Wupr73T
         hsiuy9y9rlVXP7viAR+cJPWUFoIJMvcc8iKGPdTVxrxctV3m/eo5oegnYZ0mFCVBDjR0
         YE//yvUqTOzO0/GCbcYFRPAzzouwBodgSzNkica5JXLYigwqvJiU3wp854Nn+rkJDh6H
         TKujHSyQ854InDSXRLunsJWSsafWz/cuOyd6+aZCUlzFRIjqIy/KUJCMZ8DllUX91kwE
         nWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793407855; x=1794012655;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6iLbcIK1ROxHAqAZicwghsY26jAXKiGL1CdeUbl58kE=;
        b=uEAk6mNB5JfsOomwtB+NzyXz9pdSvClF+1M219ttIKbr3mz4PufZ6l+8Fw790kOcQD
         VWXCgsOnB0Cbnj626PXBbX9Fj3B6t+WqjN/VyDh2umBz09Ihj9DmR6T98LxWTG6Dmuo+
         S1lv2yaIlMZI7NJ7YvWzs5eyE6bDtE9LlI4g9K80sPPojYu6tDJ3jXUDyzxCFyUlGjA1
         /vrsAKW75pl8yPx6mY9gGPWPUEc5vke3FuXDQ1GjBBUQ05bKGD8HXpXRONi32NiToYRl
         IVtxrENgJ/zWYRG//HO3a9wlcK1KOYe1SJ5d4qPyziX8zATifz7NT6C1kCOMeukQNxPF
         fFWg==
X-Forwarded-Encrypted: i=1; AKwUvBxcXfEOHCnR/tsggwA/dNuKVOVYIaStKg3STWB6J7GBKwaZZYBhAnhQBmc2K+tsgY6OQrcUkiIk9A5o/5mw0w==@vger.kernel.org
X-Gm-Message-State: AFq9FYIbHRUcaTlvyb1q+zqg3OYuHXgWvM/l8iUiXQ5UPFDrca42ndD+
	3H/anDokiT+jdhJFNKUTX3t7G1LyrMrMwB53H7Z0D7dF9E5XVvyPoKtL5L6t+L2twtyyvJm6v2o
	NBhxPXADn6IunKeajrgbr4njOgoSPmkmQE+vw28akKcqTGD4tgEwzNrOGbWQL/+5f4ElSzG/lT8
	eWGg==
X-Gm-Gg: AYBFou2JVnHhjRdbAoLFa0BRXgz1AEbHS8Q40ZlbydhToap05Va5Ox1pDKa6lBK7yOx
	qF/txoB7SrEH9DXrJ2D7THmZi2b/JO+mtlyOYoWjNBbTmUX7wgQECBmvSn9Rej8bnUBfJkjMjPe
	NI/zZXzTYURYQ5lq5HTC1jtpjsayfHLvAM1gVkBDZVUQl404yXzfM1yPpuCX5LcaxXeEAo5ZQ42
	UEoaLO3PaobcQHt5o2dOCXAsQbUuCaCjWeOdv8S6t87yZPYu2BzHzaAe+bRviswksfFFcWIQ3wN
	zpfingO+rlKnsZo9umQ+cWj2Hmh+dugQnJACI7D74hb3U0ZshIoOcrE1pGeKHaKCTyoi5yNcWub
	eWzCICXmdA51TQDu3PK7k58Ii3PufnDvF9unp/FUADzk+7BbPFzyzGU8cM1ZKfvQJ2G2oS5FiTi
	lGREWg+TazxNXGwoVRzPCK6hP7k3JPW6Y=
X-Received: by 2002:a05:701b:42d2:20b0:1aa:6c3f:2f7b with SMTP id a92af1059eb24-1ac5b3fdef6mr5752358c88.24.1793407854932;
        Fri, 30 Oct 2026 17:50:54 -0700 (PDT)
X-Received: by 2002:a05:701b:42d2:20b0:1aa:6c3f:2f7b with SMTP id a92af1059eb24-1ac5b3fdef6mr5752325c88.24.1793407854248;
        Fri, 30 Oct 2026 17:50:54 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1a13652csm11452134c88.17.2026.10.30.17.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 17:50:53 -0700 (PDT)
Message-ID: <e57a8259-6950-4ccd-95e5-d6d1feacce2f@oss.qualcomm.com>
Date: Fri, 30 Oct 2026 17:50:52 -0700
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
Subject: Re: [PATCH] wifi: ath12k: fix wrong register read for RU start index
 of 80_3 segment
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261030090906.298234-1-jtornosm@redhat.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261030090906.298234-1-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: U4iWBRqcDv-TCa72J1jX0VwE4a2ajare
X-Proofpoint-GUID: U4iWBRqcDv-TCa72J1jX0VwE4a2ajare
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAwMyBTYWx0ZWRfX4vEiXD9ZR6hK
 +XnJDwWEim8CsGIROZA4N8t48AZwDTZIrvzkC1sHJZOZ6v2ffo4KLQOYjN7RgP3mMK0zm1/G2+g
 U1VBi59sdg5Sen2aQ9w2mjd+H9iF2HI=
X-Authority-Analysis: v=2.4 cv=WfKZ+EhX c=1 sm=1 tr=0 ts=6ae53b70 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=LQZMuA99dPo4G15aSkQA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAwMyBTYWx0ZWRfXyPTCr6C6V6zm
 4wPywwSWlm5dYky8BMC3+6+rlpDZnQWim62/lmm53VHgECO52c5YmGjQ2RCqzbY9a99bg7cSn+0
 iMOo9hvS7Vpk/Lc1vvMcuxWkZ39vEOULsFvquozW/J6AjdbTA6IkgdnSdarvfmkUC0eP7JFMva3
 jOrcFg2AHqGgkC3Gv3HGlfe5DhxgiS/aKkb93x59eZ/XBAsLKP3+4TsMPFKnQclk/160jbLCSEp
 jYRpZcmyKyaNzJ2GuUIWWHvrIzFk2v8FuMVhG22GaN24m5cJipfTD8keNlsmf3/VvPZhIr6qnF1
 57L6mqHKYFdTWDqLrDEVukvrJyViZIvO4PhdwnkUJpYmLAf8gcLTLTF/NfnrUq5F/VpVC+rtOSN
 uu3iEXMm0MlPkeCvMht3iYj9TDB3kojXpUUy//qAiyaXQb/VmP3Wum0D5NG3ELVeFkA8r3ro1Lb
 jRSZz633iWHn7enuGnQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_07,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310003

On 10/30/2026 2:09 AM, Jose Ignacio Tornos Martinez wrote:
> The RU start index for the fourth 80 MHz segment (80_3) is read from
> rx_usr_info->info2 instead of rx_usr_info->info3. The bitmask used
> (HAL_RX_USR_INFO3_RU_START_IDX_80_3) is correct for info3, so applying
> it to info2 extracts garbage bits, producing an out-of-range shift
> exponent that triggers a UBSAN splat:
> 
>   UBSAN: shift-out-of-bounds in drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c:302:22
>   shift exponent 284 is too large for 64-bit type 'long long unsigned int'
>   Call Trace:
>    ath12k_wifi7_dp_mon_hal_rx_parse_user_info.cold+0x3a/0xef7 [ath12k_wifi7]
>    ath12k_wifi7_dp_mon_rx_parse_status_tlv+0x621/0x990 [ath12k_wifi7]
>    ath12k_wifi7_dp_mon_parse_rx_dest+0xa9/0x2b0 [ath12k_wifi7]
>    ath12k_wifi7_dp_mon_srng_process+0x34f/0x560 [ath12k_wifi7]
>    ath12k_wifi7_dp_mon_process_ring+0x205/0x270 [ath12k_wifi7]
>    ath12k_wifi7_dp_service_srng+0x1b4/0x5e0 [ath12k_wifi7]
>    ath12k_pci_ext_grp_napi_poll+0x43/0x100 [ath12k]
> 
> Read from the suitable info (in this case info3) like the other three
> segments do.
> 
> Fixes: 5db19c488413 ("wifi: ath12k: Move MU user processing to Wi-Fi 7 module")

This is not the correct fixes tag since the issue predates relocating the
code. I had my review agent follow the guidance proposed in [1] and it came
up with:

Fixes: e6fa62bada87 ("wifi: ath12k: Add HAL_RX_PPDU_START_USER_INFO TLV parsing support")

No need to repost since my automation will pick up both tags now.

/jeff

[1] https://lore.kernel.org/all/20261020142534.3533478-1-sashal@kernel.org/
    docs: submitting-patches: say which commit a Fixes tag names


