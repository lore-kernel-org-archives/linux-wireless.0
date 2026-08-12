Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF0D320CBE
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 19:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563157; cv=none; b=Qt/8H8zCFh2gLxCEaMtsE5AAzTw7llxLbZLIk/Nf1evHz4j6RTGXmnImpUytEJtxJ/pyB0TOHYZkge6pcxEnrzmzk73ceAX6JC6bL0ROIgXUR+HOyZmVkfBZIVTx0GWPGVuZwL/njxrs4a0ncdWumF7uGfCfGDb25sQHmtReJwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563157; c=relaxed/simple;
	bh=vZLNwwP5GdiKa7KoitweNGgAoS8uhcEmnLooTMmG4/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PquTR2EJziJLtWnnwxIsa0z3eYp/A7GxYPD9s8UGrurmgiXuMvAEoH01Mt1amNGE5xs/BEnzbfdFc9KRx/MkS7ukWIUvPaKCubT43Bg1Rit6HDLfsByMQg5yKnGIG6ZdlH17OlklMyPBKkN5znpD0RVDpxt15Als2FD/vptRMag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZOiPzDv4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hh6UCFye; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZOiPzDv4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hh6UCFye"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67CI8sDT382594
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 19:32:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Up2cNT+N8D3FeQZBU2m2F2swH7E31oQNst+RvFDzK70=; b=ZOiPzDv40R6nfG38
	u3FXKibzKxzqGA6XkEsqp1GluloXYyynAQiScD6pQL2lHgYV7KV1KJNNq5w5Drh3
	TQsriHpY6qTWjcs5lL0DLcHNME7s5G+D2ossPHxLdrzzT4c9e7d6gzObCkmADFy9
	ehg/j2zhobJYJ1gZ8lRjFs2t6PRQ3CJQQ9x+eMe67YHxvre8OjBvitmWo/KF1yNk
	XvqD617nDdlsgqrVZE/w7Ujn3x34zcT391qGJ6EEDZ4pZ4VRy8TNKvUMMC4naxc6
	qwqOpD9gJiN0i0NEeyAccMUn4jnW8w0KlOlarA50WCDstKpUQN/rA+aVfPrEW4xT
	dq4xWQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g0jgrkp16-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 19:32:34 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca8aee88725so1870247a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 12:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786563153; x=1787167953; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Up2cNT+N8D3FeQZBU2m2F2swH7E31oQNst+RvFDzK70=;
        b=hh6UCFyeqVgzkd69GBH9hyT0MiRvB760y1IbuBzrcYpPnmWhmpwu9z/8RHhA+m5mQc
         dUDqPVl3TXdfLn4vApKrNGzkZJTVIh1AD3KfcsLvbNzuh8orAyQR9OPrK8+7sgpb2dD1
         BNGuF8Ef4dxSUlgLN1a+zw4bsUYcvo+adkLQ1xg1Z5DxAknfe5nwg62dyuR3jkOD+E9P
         TxoyqF3HpqM55pDfUjpM2gVeihkqeyc7ILEbx0zHnYpTtq9HrL/h0ziyDF+xn5j/VOCZ
         qIWoSVzTk/TuOwIUrs33U09gb1PbIvHM58nnnduUjTebWXFRR3kPjIYT5cJ8/PJ5O8Is
         +NCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786563153; x=1787167953;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Up2cNT+N8D3FeQZBU2m2F2swH7E31oQNst+RvFDzK70=;
        b=VecVK9qPS9x7AaCT9yOdAlp4XmL1O7dUc9rzB6ezdYJzax5U/JSBdy/2zv9Qk+OgJ7
         bj1ZI3NdoGPnA+29kyVUJchu20U/OCHXMI3uo4BfWgvKTS7o8c/5qZDGQs1jPKJt1MhX
         z+MxypyNeEV7fCbfakYmagO0cGvRmvu8d/2kbJUIdl5xHxkDieQPhR8GS7obSt2lhQt0
         Ns1oKD1D99JfAoqwbsIspVpFLoLc9VQRgk7XvBZlm+isuR2/LXUs4Y83SXNrPDJtcoYN
         yzbnqtM3eNXt5HWp2jOGPiQPVwzyaEs/OVJRr4O0yCenIbZ9sSE+03lTYRXwu7RcGCtG
         D+2w==
X-Forwarded-Encrypted: i=1; AHgh+Rpw7r12+hg11UOvsb63GCKaDgwLKtuFojylAIji1tqbXiltzs1BkzFnxcj4Htmfldt0eZk9MHEW8H3AUf/ulA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrzxrE1ilqIgxuG0Rf9RjvD9Gi6eZp4dw8rUj7ovUF0K++VCbo
	qZqp9AmTPsATgokex2iXZp73d1BW5+uwQnhMpEsr8T/kO3YcJAJXAeK/cV/qUUjFU/erutbUf+R
	uapMyJpQqsnSewakKkvXWfOz4q6Xf8MoD+Ah2CVvHrJ8BsLPkJamFKVQF5+XCCnsG6LuUXA==
X-Gm-Gg: AR+sD10PM8E2l7vwZMQdzVmAGYHLWcSgVy3op7u6Zc/ZnAq/E2WWjYZrQ/d2YPkTZdl
	Fkje8rkKApCHqMBJuBleF5mpBy10avdlIrX6VOLRhquQIjplvj0BTFnUXVoRxn/YgT3uztkQniH
	8KfRgcSOUKLjgnnAj6ige/Z793RDQFLM8qKnOyToAZZOTiHiym9sybcQxEnJf782UAksGbrtILF
	jCebKfl5meWLxA1j0XEuutLqoh4lMckqFv0D79Zt0JPRSZ0BHpZSqv3xfYXtwa8IdlNsL3Xwlsk
	XUhnnZLjCu8NQpk+TgKEcJXOTKmHLgwaIoARUHP3IfDtOfJj7kIfBoEkELqjr0XOo7RrxdrXALh
	SC9rjsjCo5Fk0tkgvcsocW5FeWa+lMV/uWkp5EI4anWep
X-Received: by 2002:a05:6300:408a:b0:3a0:bc61:62e6 with SMTP id adf61e73a8af0-3cc55062a03mr995765637.8.1786563153308;
        Wed, 12 Aug 2026 12:32:33 -0700 (PDT)
X-Received: by 2002:a05:6300:408a:b0:3a0:bc61:62e6 with SMTP id adf61e73a8af0-3cc55062a03mr995693637.8.1786563152701;
        Wed, 12 Aug 2026 12:32:32 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf67912dbsm14721752eec.22.2026.08.12.12.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 12:32:32 -0700 (PDT)
Message-ID: <142142f0-b7c6-4d64-9de1-9143cae86dad@oss.qualcomm.com>
Date: Thu, 13 Aug 2026 01:02:28 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: advertise AP_VLAN interface mode for
 IPQ5332
To: Kamil Bienkiewicz <perceivalpercy@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org
References: <20260801004243.489010-1-perceivalpercy@gmail.com>
 <88d5042e-21e2-497c-b86d-3cdf8c0642dc@oss.qualcomm.com>
 <CAKXN084AmmjNWLM2fmczTpvDxr15t9-YmvZVCKGbO6TYzfOOrg@mail.gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CAKXN084AmmjNWLM2fmczTpvDxr15t9-YmvZVCKGbO6TYzfOOrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDE1NiBTYWx0ZWRfX/10A/+blifMr
 HzLd18jLUGhxNQez3wjFiAr+F8DBys0w3xCnpqz79xU+WrIcw0D95Wft3oIANo784MRcF90C35N
 c8fECF8etFapUQtyvyDYEGygE98tIBUtooONDtv91YTaOkdifdvjyv3IuDAkvF94VQzOlnesTwH
 n0AfELM3whlJFPDqVoAm6bBiVRBUZkUo8ckZXbWRmAV56I3W3cHkEAxYWpSCmKTpwGp0tLLBXnD
 81nwgTjdQG6R/5LMGYo4lRg/OC/qq6ReFZaBzUlJgyv+aUYO/xNiEV1Byvxy6TBXc841QS5Wmc0
 Pe53s0mD+b/Yy71fk/bIi1rmKp+jUp0vUweIcxYISH4qRlb1QPMOpZqFYapsz8QLNV71sU78wsT
 cEo5q7Nw+Vqmb6a2Y+B16j0g5r2S02MuF4sAIyD4FhZHKyESzpZmAW5ZWRp/vvTm0VrNbFOUIWc
 I3JcG8mAhQNB1zXeUwg==
X-Proofpoint-ORIG-GUID: 42Izg70rrT1um4jjPg-Q07kaM90NwNmN
X-Authority-Analysis: v=2.4 cv=TNJ1jVla c=1 sm=1 tr=0 ts=6a7cca52 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=FcZfrfRKbPvLg6eNy5MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: 42Izg70rrT1um4jjPg-Q07kaM90NwNmN
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDE1NiBTYWx0ZWRfXyhH3RM0s42BV
 JCMvGElZq9YwhG8qjajhreTs5WUQ59Rk5J8mvvaYq2ocI09yRUtsTgLbk1cWQY6KB/isNMVnRBs
 Kmfhi4Ls88vmyOEbE0UiWvfuOpUtDAc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608120156

On 8/6/2026 10:41 AM, Kamil Bienkiewicz wrote:
> Esteemed Rameshkumar,
> 
> Thanks for the review and for the correction — you're right, and my commit
> message is wrong. I've verified it in the tree rather than argue it:
> 
> `cfg80211_iftype_allowed()` (net/wireless/util.c) short-circuits before
> `interface_modes` is consulted for the 4addr case:
> 
> case 0:
> if (is_vlan && is_4addr)
> return wiphy->flags & WIPHY_FLAG_4ADDR_AP;
> return wiphy->interface_modes & BIT(iftype);
> 
> and `WIPHY_FLAG_4ADDR_AP` is set unconditionally by mac80211 at alloc time,
> not gated on AP_VLAN being advertised (net/mac80211/main.c, in
> `ieee80211_alloc_hw_nm()`):
> 
> wiphy->flags |= WIPHY_FLAG_NETNS_OK |
> WIPHY_FLAG_4ADDR_AP |
> WIPHY_FLAG_4ADDR_STATION | ...
> 
> So the missing `NL80211_IFTYPE_AP_VLAN` bit cannot have blocked hostapd's WDS
> path, which sets NL80211_ATTR_4ADDR. The `check_swif == 1` case falls back to
> the same flag, so interface combinations don't block it either.
> 
> The premise the patch rests on is still correct — mac80211 skips adding AP_VLAN
> for us because of SW_CRYPTO_CONTROL (main.c):
> 
> /* if low-level driver supports AP, we also support VLAN.
> * drivers advertising SW_CRYPTO_CONTROL should enable AP_VLAN
> * based on their support to transmit SW encrypted packets.
> */
> if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP) &&
>      !ieee80211_hw_check(&local->hw, SW_CRYPTO_CONTROL)) {
> 
> — but the consequence I attributed to it is the wrong one. As you say, what is
> actually gated is the non-4addr AP_VLAN case, i.e. dynamic per-station VLANs via
> `hostapd_vlan_if_add()`.
> 
> On what I actually hit: the symptom was hostapd failing to bring up WDS station
> interfaces on IPQ5332, and I developed this patch alongside a hostapd fix in
> `get_hapd_bssid()` (bss->ctx dispatch), which Jouni has since applied. Given the
> above, the hostapd change is almost certainly what fixed the WDS case, and my
> attribution to this patch was confounded — the two were tested together, and at
> least one of my A/B runs was invalid because wpad was never actually restarted.
> I should have caught that before writing the commit message.
> 
> I'll send a v3 with the rationale corrected to the dynamic-VLAN path and drop
> the WDS claim, keeping your Reviewed-by only if you're happy with the reworded
> message — say the word if you'd rather re-review it.

Sounds good to me.

> 
> I have the hardware set up (IPQ5332 AP with a 4addr client), so if it is useful
> I can also test the non-4addr dynamic-VLAN path explicitly — with and without
> the bit — and report what each does, rather than leaving the justification
> resting on code reading alone.
> 

Also, please use inline replies in upstream discussions instead of top 
posting as recommended by the kernel documentation - 
https://docs.kernel.org/process/submitting-patches.html#use-trimmed-interleaved-replies-in-email-discussions


--
Ramesh
