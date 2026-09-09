Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815713D410E
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 09:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788947200; cv=none; b=mU6Qgly7n8CEH5JB7PHurQB5ymBkrL5eva93omg/FGIg5Rf3A609ZJWqcrieG7IqcIhQ4JXSZ3p0G6n4izYFqIL6r2AAwQ1hERmknZz2xMl0aaVdaxq3lrTOyFRjOFzWbjhVk8gb638VmzHeBjdr2z3yOx8h8++JskNFNcq9LDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788947200; c=relaxed/simple;
	bh=uaXS0h7uHx7Wpev8jynEBaYf9Wns7q0uFKtexs5LkKQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=HfDr5QtTId340muovuDKRhm2ouyPiYUEmElkJSH611BGonggu3x50ByMsc7cHwuttpCezau6QuNktxVanG/x84fkkCajcfZ0Ptw6rjvnZ1VgxFZnnhw4fJzb/at5aNAQkmnoug2s83cOkfb7MSajodpWQQmDHXc3B28Z15jFap4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wn31AvSU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=j5MgYgpN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wn31AvSU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="j5MgYgpN"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68965IQ4964981
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 09:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XFkhDXbkZn1yjQAgYJhG1jCYyeW9Ybaqxa2Tec91Hxc=; b=Wn31AvSUrmLELzCr
	zWh9m+Ysm/8nQpSluVh2rd6jSDhpLuGqTKNBK1fiPEYE0IVR+jCqk6JoPSHa1BeU
	XPoki5jFiCxuqq7cq6EJHx9hYpl/8A5QQccGMATp5VWsF7EYVoO9dr87/JuR8Z2d
	uAepeJXIQ9lCXMBDk6098omt7+bqNHvXFU/8A9sWetSrknneeCUKsMLtrpr7L89S
	Ve04dltNjGz1Ya1vsqMVM9bQiKivsRjpffWltmWw2t6Mc7tFj2QP9/Ov7/eeS7KN
	ieK02vDPqStNjRHTwtn6oFsQvDWac4lpI5KETFq6ySSy0UkJIlG65li/py4VMks2
	7SqvDA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjqha3dm0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 09:46:38 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbedbd182f5so4651199a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 02:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788947198; x=1789551998; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XFkhDXbkZn1yjQAgYJhG1jCYyeW9Ybaqxa2Tec91Hxc=;
        b=j5MgYgpNITrtFt1mOscZAZnXrz/6sPtl4iYpzTk8uin6+Mxe+YmZ1hbQZMJHkJAsSP
         eSQuYiPQfVuU7BLeJszXmswZkalKenDWlQ6GWvtFGU0+XINrsP6rbLdZ9pCK0G/3NoY4
         +HYxW0qZz8s7QGxezC+W7NyO1iOdGtyAd2voOKdDsfCgh7Bz1l8bnEv4cJ386XfBlM2I
         OxQF0I7lI7uQRafXKrsS20rKxcWct+rihKhe0WmAqogoZM6hi4e5VuTvq2BHBH7AQHFX
         LDCdvcb5VyiR/HfzyaNQXuCDPAb9CT9QmUquque1HfT7rkH2ApSJTc36/QFFK+uce6kz
         oS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947198; x=1789551998;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XFkhDXbkZn1yjQAgYJhG1jCYyeW9Ybaqxa2Tec91Hxc=;
        b=l0bF7Cd0N6/WbiN9zObiRfWf+7fSTBpnVuqjsSPNIaRnWiP7i2H3+i4yREizaIrYzO
         D/PHaLHPAeWIGpzRW5+jy/s8O3Jd0SmPZO4ukZQzg0AJDfrnNMDgKFs7MWMYtKKZiv6T
         onQ4BkeApLbEunvUgBMFGYOTUZzy2L+S3jAqkKPaoY1c5f2pzdWevmvyEFH4mi2e57ND
         pSBJCDlTg0MYSIrdhce7sxIChrkkNX0uJp+kuEfuDzWZUwC9TXjMPPE1dqaTd/dvd/jd
         5mJP0OkD7qPChN2VOVBoNsS1dneRpFoxwIjXE5OwBI+3sgyFMIGXHqEtd7XE+/3eWxnp
         Kb/A==
X-Forwarded-Encrypted: i=1; AKwUvBzCNx8Q3lwdvEabKAe4NFxu2AruAafTGG0uLyKAzfnOkAlBz8/fPqqgvCic1xdbyVPBNANmqH233O7YgtdfzA==@vger.kernel.org
X-Gm-Message-State: AFuF++ned7+uefRb+EAAzqorNdR/1hi0GJYO6r8rO6rWrgQUi0flYg/x
	1GumGmIaGYx7f7jd66hH602+vkoZlvSZpOC0N/hDmkcOO9cnzxKjJAE0akdgCg0NWGmAuwRQpxQ
	yfB/aiXR4HWpiAzMKP6aonMis2vL1NEIf/hw73F4Zf4LrKfFz/2JLxcI27zUKVILVIxdI8Q==
X-Gm-Gg: AYBFou2lNB8nysoho9ftvQ7uqRkrj3Wb1QtxxTlNM/qtavPB5LNfbRFJZdAmptzrQbv
	OpqgdKnkhBPNbE0pvSn79gpst0Xla4FnX/h1aRBm+IN4W3qgSo9OrwZ7KZauf6qHiQ6XnlDpvBk
	E63lSzSQOXw3OKaFSqjpCDvfBd/qsfUSo5J+vzRLSsOmj0bYstjPv6nEwPcHzi3Zx/OJprcw/n4
	cblwes/6VxD/t/Hi3hN0kCdhzkOWxL5WfBC5I6unQSdZjrARGpEGBiSipvpay+kBFiYhqpAMPKS
	iXvN3lw4/kAvWMNeNfToCuQlauZS3cv22fdZ8uj3Pv2TtXleJSXi5g2zt9EFSrJvgPpRZSRYoDM
	WGbGLt4pNdYwtwKIsxCX2nuuFTs2gQBBDQUZFJ67c2tUs/D6Xak8NPjIUxAv+1w==
X-Received: by 2002:a17:90b:4c10:b0:398:9bd3:d6d1 with SMTP id 98e67ed59e1d1-39b8bec869amr9484762a91.11.1788947197666;
        Wed, 09 Sep 2026 02:46:37 -0700 (PDT)
X-Received: by 2002:a17:90b:4c10:b0:398:9bd3:d6d1 with SMTP id 98e67ed59e1d1-39b8bec869amr9484723a91.11.1788947196832;
        Wed, 09 Sep 2026 02:46:36 -0700 (PDT)
Received: from [10.133.33.129] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39bac3a2809sm4980076a91.10.2026.09.09.02.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 02:46:36 -0700 (PDT)
Message-ID: <b4fcaa4f-8c4e-4fc0-898c-6c97e1446323@oss.qualcomm.com>
Date: Wed, 9 Sep 2026 17:46:32 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: fix frequency range for
 single-pdev devices
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
To: Shenghan Gao <gsh20040816@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260715065218.41232-1-gsh20040816@gmail.com>
 <5ca16013-e8a0-4403-a2b3-b3b43ea2bb2d@oss.qualcomm.com>
 <CAMVcGaDKC626A6=VC+10vtw3KVNm2NM_yPXTbgnA9Efd5eyL7A@mail.gmail.com>
 <9dd4e992-5810-429f-bc54-036c4eb276a7@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <9dd4e992-5810-429f-bc54-036c4eb276a7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDEwOCBTYWx0ZWRfXx2jWvycIttm6
 NmWvwSPGxj8efbeMsCDBQh4/TtvAbEE0jDVLu7Kss30lcHVC5TfSZ23IQ2+5POLADAu60GPpblT
 vbWEQe3ZXzciksd0HSGlMDXySvoQjcLoEHZJauN3o5DJ+pm7DEv3lKK7hta58MGry96nx7j7Hf9
 cFH8o2zNNCMgDG7nSlBLQLy+CEd53243z+5glQ37zZzQU2axROuez3aZk1eK9sThxaj++WDtsKo
 K8sY7jFpTeu4rzB/qVK/dteRBpmrRpDdakT5Gp14S/VlqqV6y/grrSMSX2R5+EXkkpBw4Q+19+B
 +ZudQ4eYSKEaATqkTZnGYAZH24yzummN/ogNYgo4/gAX1Z/2TgQiHVED1rPesxvuMG1NIJJ8pJB
 m0SEUIoFRnTuY2T5P3Uuh9tWG5x1lNrrq4g0QmhAL7w6FDzV86VffQqxMx+gyL2n4iHmEfQmY33
 ARjwACNPytcZXzsn+VA==
X-Authority-Analysis: v=2.4 cv=Z5Xc2nRA c=1 sm=1 tr=0 ts=6aa12afe cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Mt_g2Jb-QnVg90RqeeoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: rtQyiozZ0lNHxTuGObj14x7WITjQcVCx
X-Proofpoint-ORIG-GUID: rtQyiozZ0lNHxTuGObj14x7WITjQcVCx
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDEwOCBTYWx0ZWRfX/Ohpf6wb5wTY
 N35O5Lnp95cofNxTgi4tOZDQpBAiSvjbL7T9QM49LotFiE7cZNVtA286LEx8Es3ThQxUP+krtxB
 983v0H/M6YvRxcReg5M2M05TdXsDwk4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090108



On 8/3/2026 4:36 PM, Baochen Qiang wrote:
> 
> 
> On 7/20/2026 5:25 PM, Shenghan Gao wrote:
>> The update sequence is as follows.
>>
>> ath12k_regd_update() first resets ar->freq_range to zero. On the
>> tested WCN7850 under the CN regulatory domain, the 2 GHz branch
>> calculates a valid range, so the first call to
>> ath12k_mac_update_freq_range() sets ar->freq_range to 2402-2482 MHz.
>>
>> The existing 5 GHz branch is skipped because ar->supports_6ghz is true.
>>
>> When the new regulatory domain is built, reg_freq_6ghz.end_freq is
>> reset to zero. Since the CN regulatory event contains no 6 GHz rules,
>> it remains zero. The 6 GHz branch therefore calculates freq_high as
>> zero, and ath12k_mac_update_freq_range() returns without extending the
>> existing range.
>>
>> Consequently, ar->freq_range remains 2402-2482 MHz, and the subsequent
>> channel-list update filters out all 5 GHz channels.
> 
> Thanks, now I get the root cause.
> 
> However the change of this patch looks more like a workaround rather than a proper fix:
> 
> Current radio frequency logic has been architecturally wrong from the start. Ever since
> 657b0c72c4ad introduced reg_freq_*, the entire purpose of this code has been to compute a
> per-radio frequency range (to advertise each radio's own Frequency Range to user space —
> Idx 0/Idx 1 in iw phyX info). Since the quantity is per-radio, reg_freq_2ghz/5ghz/6ghz
> should not live in struct ath12k_base (per-device). Storing a per-radio quantity in a
> per-device field is a layer mismatch, and every problem below derives from it.
> 
> Two problems caused by keeping them in ath12k_base:
> 
> (a) A cross-phy race that silently drops a range. Firmware sends WMI_REG_CHAN_LIST_CC_EXT
> per phy. build_regd() resets all three ab->reg_freq_* to {INT_MAX, 0} and refills only its
> own phy's band on every event, while regd_update() runs per-ar off a workqueue reading
> that shared per-device state. A later phy's event can reset, e.g., reg_freq_5ghz back to
> {INT_MAX, 0} before an earlier radio's regd_update_work runs; that radio then computes
> freq_high = min(high_5ghz_chan, 0) = 0 and the range is silently dropped by
> ath12k_mac_update_freq_range(). This is a real shared-state race.
> 
> (b) It forces the ar->supports_6ghz proxy — which is where your change comes from. Because
> ab->reg_freq_* is per-device, regd_update() can't tell from it which band this radio
> covers, so it falls back to ar->supports_6ghz to guess whether this is the 6 GHz-only
> radio. That proxy only holds on split-pdev; on single-pdev (one pdev covers 5+6 GHz,
> supports_6ghz=true) it breaks, which is exactly why you had to add the || single_pdev_only
> exception to rescue 5 GHz. The awkward compound gate is rooted in using a per-device proxy
> to decide per-radio band ownership.
> 
> Based on above, I would suggest making reg_freq_2ghz/5ghz/6ghz per-radio, in struct
> ath12k_pdev. ath12k_pdev is the driver's canonical per-radio object (1:1 with a radio,
> holding ar/cap/mac_addr), and this operating range is a property of the radio — so it
> belongs there, right next to cap (the HW freq limits), which is the same class of data (HW
> capability vs. the rule-intersected actual range). Both problems then dissolve:
> 
> - (a) is gone: each radio's range is isolated; a later phy's event can no longer clobber
> another's.
> - (b) is gone: the gate can ask the ground-truth question — "did this radio receive reg
> rules for this band?" (end_freq != 0) — with no supports_6ghz proxy:
> 
>   if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP &&
>       ar->pdev->reg_freq_5ghz.end_freq) {

Shenghan, any thoughts on the suggestion?

