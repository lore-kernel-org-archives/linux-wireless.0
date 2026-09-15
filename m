Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6D23BB57
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 02:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789438849; cv=none; b=D9QtF1CO1ZgARC5OxWFGMbDUMQc0/5bX/9sUG9g1zkmhBENnOPS2F3wIA3O+Fmi334iA59a1aBnwY7IH7BgCenjK7wIqFN5xhu3BRH29ysV8jKrdeJAQbAEBDUDa06itOMt0nIzxtaYYz69aBBVVIXOR8pY8QM6L8NkeFiQ6JmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789438849; c=relaxed/simple;
	bh=GkfeWuVt/53I1RZM/ZlujIlVK/giOeDyxNzkqYFrxBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ou5ikfariO8YZPZIRQR0gfn98wOHWqZuH/JGIE6RSn2vewiWfxOzynTmvGKiw5UTQPkGEBDAr9icZiYbdL+7xle1PpyIiNjlDqrBtsd1sVgNkF5iw8K4MwhJwY910yJgIRTR7NOvedG3e3emNvQ7BnPiNs04Zbcxm7q9+xxPxDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pdhdPGav; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Fyq794L4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pdhdPGav";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Fyq794L4"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EMxkk21439489
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 02:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PRRE+UZDbFWUSTbpMf4eK7mNPwPbcs1iwqCTx/rSKpI=; b=pdhdPGav5xUdGu0j
	jqLG34NDXpSksBvAx6j6ZxjMuMivEn6809pw3dGzv/cqvBVABZBuB7UseSvNzHB1
	8WuOmKQJWW7RrG9XNSTAZ7tD3kQ0JTmClf9zZOvF7wjxiiP2mHnFeKtE5RLdnUpy
	6p7Sz4MZCvIB9CBvIusJ+JP3ntSWJ2yxqQ3KR3+71te36MDx7emh+3znEC12gc3l
	/9q6esypxjPJz5xLDp3o2b2Iq4syxJCTpIpH2MYzdHwjtT7pubdIUWLh87mncx+N
	zLYfY2krLF6C8IwCt/ikxDBPZA3EcFxHe02R7keV0s4lnBksIqPiRYDfKmpnjALd
	VTG8Cg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpeuqbfxr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 02:20:46 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so2733502a91.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 19:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789438846; x=1790043646; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PRRE+UZDbFWUSTbpMf4eK7mNPwPbcs1iwqCTx/rSKpI=;
        b=Fyq794L4C37F6SxbjsiphFQhFxcLo+P8oVYO+5pppJ7s8nz18lW1v5uIgsfFmEsTI1
         CQWA3SWx9I6eSG7P/Iq4MT5tY968ScteCyZWW8G4AdmvQcNQKCiKMQ4Y0NMsD8obpY0L
         qxUsWi4QCcjFF1uMo9ePqey0vzi6U9B5rjp3jFDRfExDwUQYnF2rxEKK/043aGkQTGMy
         KAp1C0mrGKM5oCat6OwPALJb8iKr8Zz2A84NYiKHFMRdyzOf9asXGOs6Wyn/nKBUCCOl
         nSdnNQ3Ay09Wl6n2IIPu/k4vBv5WuUDyq4ZEaKrItwsQn5NAWhpEqqW0dbXlFVu/RJnl
         aKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789438846; x=1790043646;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PRRE+UZDbFWUSTbpMf4eK7mNPwPbcs1iwqCTx/rSKpI=;
        b=Pzt2nGJ50/Tcc/xN2jJaXKCXyvAsmfqpVs5M/73L5wzunMvyhdx2RUNzcCRBiIsKSw
         IswsAhPar8Z+KPrk9VesxBUh0Tts3VOT8Sg7rJt7QZVPrQt8VANNM29kDtkZrW6ugqlQ
         kpF/J565qKh7FbFa0cIYv901KNLt5MmBjwL47ERCltqo4J3sZzJ9yAixP0yK+KxRfYnd
         DOb/1u7X4AKEBrVe85J4M8F4CKxBHV11QYmrQ3aTAWsdfwiPGCojKrpdhqZWbGXNK4HG
         iUlZHtqwlmuxxwsU5uVp7p7KlKd+NVAnOFdEdPYgaCsrIod1TBnpk26TqM8nbpFwVroM
         +9KQ==
X-Gm-Message-State: AFuF++ltdeNckVgYwViX8t+mlJzMrOihX87g+OhfHNm0IL2fzjoq1zoy
	aguF9Bc4eA1kbpTPMV/BEgT9xRzAbn+HtLssBLWbrfPK43T98sPtUt8syfZgLkYcbavOXyvlZrH
	NO2CBatqM7l19OP9pyAr/uarNxoPqtR3j1MNEFxmWEZH7oL0AJHXLctSrfPko0P8Ie0+LIg==
X-Gm-Gg: AYBFou00F2QWoh4kB6m2cJL1ccpmA3FW7TfKcMFadHObwFmgqPWO3wH6WK3hb0F9OfH
	AJ6Bhmb6KpCggEqrqcCoopNNxOa9e7c+nYgL3eoHUZAFyx5oyXfl0aZgp23ZiivtE1ukg2N31MB
	z82Kx8AJGjq2iYGdrVTmACNI9RlMMG037/ze+IX8BuK9lrqgHQqC+ZH/BLr5iJ1f6N+R2qvrwXO
	GOG3i3YlBlbBtUf4UqhAMxvH0HT76PE89bxKqNsvY9hBdxjusReD9I2kvHL2dWg/XIc7UbZ0sg+
	JJqqtCWiIOEi4bVkI4HfneGcda5VmX6+tSXRhTKX5grR9kzOZtQU++KITMUaL9hgFNhmqy/XHdl
	XsPgZ9guLRJGJDt3GeQSGJ69jLpl8y9IrmsyNhwWs
X-Received: by 2002:a17:90a:d648:b0:39d:cbb1:c96f with SMTP id 98e67ed59e1d1-39dec09a779mr10055129a91.18.1789438845603;
        Mon, 14 Sep 2026 19:20:45 -0700 (PDT)
X-Received: by 2002:a17:90a:d648:b0:39d:cbb1:c96f with SMTP id 98e67ed59e1d1-39dec09a779mr10055074a91.18.1789438845138;
        Mon, 14 Sep 2026 19:20:45 -0700 (PDT)
Received: from [10.230.189.30] ([27.61.59.201])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1438d1381c2sm2720203c88.10.2026.09.14.19.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 19:20:44 -0700 (PDT)
Message-ID: <3e7b15b0-3fc8-49fc-be6e-23d651a2161c@oss.qualcomm.com>
Date: Tue, 15 Sep 2026 07:50:40 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v3] wifi: ath11k: reset ar->num_stations on
 hardware start
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260812-num-station-v3-1-871d20e043f6@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260812-num-station-v3-1-871d20e043f6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDAzMCBTYWx0ZWRfX9wobV5IrY3CO
 dtfdH+JIcCCmENI/1ZOowxPxLBsB4NvKaLIyWktZz8ULBqldSPIdLgahR7Y9CSMP4uF3jg/lVqh
 rZvY/lC4Z+CORvP/cJB+GItNIckBt5dRlidWkZaqIK2IeWrrlifPCBaJn0D4FzrXROaOaWvRwy9
 kYRs899uBTn0VLH/jQCqQ4WnKvTOY/9f97VxQvr4iusr6JNujUEZn7w0/onprxspTV0fW9msL4G
 Zlrg0giKHj/YegaF/Q4yWXBICn6K1kZ0TtTaXQadR6JAg/kgiPzSGOEcN3KTJLYYvdu+v3n42n+
 c1msg/cW8zVpO/2QBRcT/f4L+k+8o2JAYYIa97QVqw9W6A5J05oSvDq81bfT0nAemwzrQA0T9ld
 E9CDKhX7dIBDdO3tOvg8m/BfvOSrOqTI1i8L1ZvSxm40ikS+pZ/0QbPBeDqer2BtvZYbK4WSt60
 1wFKyHbvGENb/8K3O3g==
X-Authority-Analysis: v=2.4 cv=TrFzFzXh c=1 sm=1 tr=0 ts=6aa8ab7e cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ecYIMxqgMxwo3LF2e/bUvA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=XDoMHiau_i5UK2d4cvIA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: fRHD-cl2EKJD6J_nbqQg1nlw3UT879Bp
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDAzMCBTYWx0ZWRfX978u2o7O/JsT
 LYKdvSe0S4MpapR96YkGai3KYAdabhsm/kJxEUbPgRtCN+6k7SzrxK7o2PD6JpgcURNmpN5la5Z
 OHjt7mQKgF+ILbBPC9KBhPq71MX3A2Q=
X-Proofpoint-GUID: fRHD-cl2EKJD6J_nbqQg1nlw3UT879Bp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_05,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150030

On 8/12/2026 8:28 PM, Nicolas Escande wrote:
> When (multiple) hw restart occurs, we end up in a situation where we
> cannot accept new stations / mesh peers. This seems to be the
> 'num_stations' in 'struct ath11k' that did not get reset properly in
> this case. In ath11k_mac_op_start(), it was indeed the only accounting var
> that did not get reset so let's clear it too.
> 
> This avoids problems like those:
> 
> 	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
> 	[1248828.088115] Call trace:
> 	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
> 	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
> 	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
> 	[1248828.088127]  process_one_work+0x178/0x3c0
> 	[1248828.088130]  worker_thread+0x280/0x440
> 	[1248828.088133]  kthread+0xe0/0xf8
> 	[1248828.088137]  ret_from_fork+0x10/0x20
> 	[1248828.088141] ---[ end trace 0000000000000000 ]---
> 	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
> 	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: xx:xx:xx:xx:xx:xx for VDEV: 1
> 
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
