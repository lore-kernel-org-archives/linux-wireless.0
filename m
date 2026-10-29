Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283245;
	b=MtZ+z5o9Kw/5hyIrLg43VCfJGAEAmhhK7qUlOAXxCuqw3ZiKHadRtgisEMPZzYtHRQEY
	 bnWYtSbaUGoAwr8FdXw9D7COBvX+gkmSwtm2u/5YP6DHIANaLltnLGMdrbhCAjyZ3M4mm
	 ePuxbRk5EC3wCKESxwvwm1TVbuJLNO+ruzlYMdL/ri5A6KnfvAxwfH7LKLQeTeMTPjzM+
	 /AggDV2TzF7hXJmcspZ2LZixIjAt2m9FMCTvMbj9QSiW27CYAMzvYfnc9lnemy2KTmFb8
	 hMM6UI5jlMi+ejnSLwdVt112xH1zDTKEZU7SyjMRi+tyoGhlIp8B3IkUjHrB2R0WpAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283245;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UO8qVAs8xQmrL2EMRzPDG1f5vM+ly0/vVJEiX0Xp9So=;
	b=qike10PAuES37avgsCHzDsfoo61Yvu5fSeCLhFziD4+73oOPLB9HwAprP9ae5/MCd0Dw
	 TU3fsTtr7krSMDlyoxkQWb8CNuNUklvfyPQocwmGvMeKYYwJkh1TwcKigAt7gsm4GThRv
	 LotEreccHQ5WgEQhUbJHppHU/TjtNf3FL4VeVCMljV6C1Vh0t8GuMydkJyaCYjyVJWGAD
	 X54eVHG5rXczvc6qUOSpjsItqb+d678g6K5R5cI/fmScVkxYlI360VwxcotlBEfcGU9lD
	 dVam89hAebD/I/WO5FIFj8aQUP4xIqRDEkIQWvHZPIhCwjAR2u2OvEeKTRY6VoGRnag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sf3hrZzf;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7636360A2621
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 14:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7636360A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sf3hrZzf
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e8da6ef7ddso12796805ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 07:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793283245; x=1793888045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UO8qVAs8xQmrL2EMRzPDG1f5vM+ly0/vVJEiX0Xp9So=;
        b=sf3hrZzfswmiRfom4xpx9ZN26p7rDVaqEOC8lRcXYIuM2g+TsOMmm+CIl9IlCBYmNn
         5c4i5f2PyA8hxedyBzHOK+ubiaVMfFfhsLb/lOmp39DdStQ0bo/XsZ9wzbfWYAfnxQUw
         dUL/d5xuKPwHg+CVBE/PdWNeXvR8L3l3u06TkfoPBrvqHIcJ3GjqKEnoQD4u+L4RTkBK
         WZJCd1U/UQ4ntZJGOocLnoL2qvz6BKtwnWxKDK/6BaZnhcDLRrxoonD01rfgNRzoYNaW
         Av/L9+hA+l4E8ScXLrj/M7GO6V98h8zbQCHVdF/gRKkt4v/XVu2Q6Q1fA2AeKmCbzO+c
         kp8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283245; x=1793888045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UO8qVAs8xQmrL2EMRzPDG1f5vM+ly0/vVJEiX0Xp9So=;
        b=Mr6akPqPukh4D2/lUkd8iL9dbGQd365Kbz3ISAELVJy1PYShv5Y3p0wqRN6NWRLfgU
         AYasE5jd2zGepyrwfpEGUfTxKYCh2G7DizT2mZMCs3XAzZYcCqyXxv0gY141IqQFm+yC
         nLBEzQ7BhYIAvh+ziKFLL3NZRbQFjdjZ28onmEZc6lDQwR/WJYtyGi3XkW0Khvmo35SA
         xn13IvA3taq9a+u9TQfWF1hyA1mOcXBhsweUmSp/qRWW/d8J9Ws+zte1tjDg5E86JrIj
         ebuhcQnIF1yXg3GGmPuIEuOISuFHGocoKUzqa0HEb04O7FBjR1gSVAULusXWelj5awNT
         IGBQ==
X-Gm-Message-State: AFq9FYIzwogsSsnCuLR1xxdcgzlrp9WMD182pNPy2jffg74QZA1vkEZz
	ACNHzOSR8IPK68NLb1tDnqCQ4f/T2vvaqCw1okbTPb2/jt3L8ym4P/j98SPuThUV
X-Gm-Gg: AYBFou1hZkeGrkrQsjhHOeqdAOZlQ471oVQ+wMLK/SuMUmsJFjWKkVLA0dEP8fjysv9
	nGUEcw6LCxIkU1Qz8hWwnuijd5jZn8FEr7jAgQETiPV71Nq6GqMkP0/7stYzZNs+zp3BkUguGTp
	Zl6wf2iAXjHz5R6k+2QS1iYq7FAuLTa7ZXqERXVa1IRYWrbyidMkAAyAlTu/ruI4JBIwEUesV+w
	wWReZ8JtRlwgOZFBdEkS7caUJoFjZAaWBTG/vjMzDQR9xDGJPzKiFpvUD76sqcCSpR8Dwg1wAIu
	nR0mixp2r2fafjAo/54NbTW6QgOtKaZsf3AbaY4b6IitL0047XSDvIA5iIvl2zXTWuhWng6+EBI
	dmvGmsNYLQ98sHzkt/MFj4cHjPPzWlUdBlbar4UB5NrFJArcjcT98ZE4tfY7OGMW9MVTB+wXCXB
	O+y21NYI6WHDHeLUz/NUyqjVvvW2hgpyOpjpfeDyGY35H21ec5Oa6g7OZIOKnlIXmPnje1X3zZw
	ozx1clsU4uklAahkAyb/CyIaPmNJz7c8nzneecRGAho2a3ZTKB8+EVv39VvL5Q1ArEUUIsq/mE7
	4t371mGzr9Yxq28kL+PhB/3BDdmzIR5eLXWAHA48p/0xfEubpafaD1raW8Ixqfi2ywbZU7qwIDl
	xmb+G
X-Received: by 2002:a17:903:3c26:b0:2e9:970c:2c9 with SMTP id d9443c01a7336-2eb0050bd4amr57078465ad.42.1793283244792;
        Thu, 29 Oct 2026 07:14:04 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2eae6ca1bb2sm34766145ad.68.2026.10.29.07.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 07:14:04 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH 2/6] wifi: rtw88: 88xxa: receive VHT SU beamformed transmissions
Date: Thu, 29 Oct 2026 22:13:56 +0800
Message-ID: <20261029141357.152345-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <a437b090-8285-4fda-b695-da4b66c8f365@gmail.com>
References: <20261029055212.84711-1-hjf3108@gmail.com> <20261029055212.84711-3-hjf3108@gmail.com> <a437b090-8285-4fda-b695-da4b66c8f365@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 29/10/2026 14:33, Bitterblue Smith wrote:
> On 29/10/2026 07:52, Ho Jie Feng wrote:
>> Implement beamformee support for 88xxa since they have
>> support for it.
>>
>> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtw88/bf.h       |  2 +
>>  drivers/net/wireless/realtek/rtw88/main.c     | 12 ++--
>>  drivers/net/wireless/realtek/rtw88/reg.h      |  1 +
>>  drivers/net/wireless/realtek/rtw88/rtw8812a.c |  3 +-
>>  drivers/net/wireless/realtek/rtw88/rtw8814a.c | 36 ++++++++++-
>>  drivers/net/wireless/realtek/rtw88/rtw8821a.c |  3 +-
>>  drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 62 +++++++++++++++++++
>>  drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  2 +
>>  8 files changed, 112 insertions(+), 9 deletions(-)
>>
>
> Is it really this simple? The vendor driver has a lot more
> beamforming code than this.

Yes, this is the beamformee code, not the beamformer,
which has way more code than this. The RTL8812AU is acting as
the target for the AP to beamform to for this one.

I have the beamformer code, which the RTL8812AU
beamforms, but I dropped it since it reduces throughput.

I can put the patch out if you wish to see it, but
won't be enabling for 88xxa.

Reference:
https://github.com/aircrack-ng/rtl8812au/blob/v5.6.4.2/hal/phydm/txbf/haltxbfjaguar.c#L229

Vendor driver and rtw88 can be sometimes confusing for
the bfee vs bfer distinction.

>> ...
>>  	if (rtwdev->hal.rf_path_num > 1)
>>  		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
>> -	vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE |
>> -			IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
>> -	vht_cap->cap |= (rtwdev->hal.bfee_sts_cap <<
>> -			IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT);
>> +	if (rtw_bf_support && chip->bfer_su_max_num) {
>> +		vht_cap->cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
>> +		vht_cap->cap |= rtwdev->hal.bfee_sts_cap <<
>> +				IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
>> +	}
>> +	if (rtw_bf_support && chip->bfer_mu_max_num)
>> +		vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
>>  
>>  	if (rtw_chip_has_rx_ldpc(rtwdev))
>>  		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;
>
> This could be a separate patch, since it doesn't look related to 88xxa.

I can put this in v2.

>> ...
