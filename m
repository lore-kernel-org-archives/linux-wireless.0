Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92CD331A4C
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 19:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786650484; cv=none; b=FKg2Ku0Vd2z+RufCpm7P7o9Ua+uu0/09U73kcTwfXBKBfbXJVYrdHq9atVxWKkyvi1PjK3TsPK+wQ6j6q2nM54lxdu5eTUw01OZTNhiHc/jJm01GIhH1vAVY8dkqS5ghda/73ghBKzaPSbipkq6pbiB+1qs3ykykJ5EKH6+mvJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786650484; c=relaxed/simple;
	bh=jdff9RjTJ6FX5CYneqmJRs3kJJfu3JM/pEar10ZoML0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rPYgTBbbCje7vFXOPtqLKNqEeNw3xQIgFW3RVnDYmHlfEMNdXn8U+uyqRTOqEdr3BIf+Te4AQEy8r+SIwEF5PM/QnAy0kGL4miUG/zEx4A59KD+jt6blqWZnPQFSALRHd5kKKMDrNVCp2blxkSdXst6O2MHuG0iDqIefKnW7VvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tHwEfD9t; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tHwEfD9t"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47de0093c42so179037f8f.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 12:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786650481; x=1787255281; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DPXs8j8erucli+FArrA6gPvW9i2D52YxZx0U6KvKwvs=;
        b=tHwEfD9t2z4dGX2O31aooggmxQZDtYZ+CutHDnny21u3TlvtSgT5Aj9zz8i3fhF8FI
         xLFVXp3zkS2crcqwXkD0itRu2nOpAbQ4tUL22LWvXP9dWJ28Oymf/GR5D9CdxBcgiZNL
         5J5xh1AzmaPyNNS1idZ8gUT91APhjc4c7NZq9Op/VSogkBtSlOmP0V23W5FStZ4bYfIx
         90dL7mvjHW8XkRmHr2MPtMG5QqjN8Q4v5V4wPAj1+UqLRsf8J8FJY5SixvI043mNuGUV
         p3m1U4ogGENYKkPFJtbLNKa45uIqA/jWOuZWuX3kBuJtBYhzfFD9NTj4l/GbBWszL39g
         xF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786650481; x=1787255281;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DPXs8j8erucli+FArrA6gPvW9i2D52YxZx0U6KvKwvs=;
        b=ddjqSVsliemv3Uuhj2b7dNKC+4ShoLTrbXb71+a0Ov5C2Yylfo6A4Yeyglbtbbu6D6
         UW3M9aycA5OqSOwKFpe+lZ6qYW9traP47/aVaV5GUBbwveWZQWyWhQUscnDTri2yHGFa
         /5MxC8MpLbt3zvAfc3MIWbwcFaAlErrxRveXe/CF1G6O8P+Rjz2MDzYRUxbn7QfjmrGr
         jpdhN4WBg1nFV4YgJNVcSu4zyryZlWz55WlW6MHly6id83O/i1j0JnybN7MDhHGpwQ2I
         dcvyWNbAhb0pZjwsGd36cp336mlY+09Gglkd5Ux3FOk+Zh2sq+cHIBUuGZZvPKvg92rf
         ColA==
X-Forwarded-Encrypted: i=1; AHgh+RqN84bUoXRubnMwbNidqHpSJWmE8rE00THiqYvugA77NagOGd4C2AmB4cW+dvPvOTUmC8uMImckQymTBY1+Nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjNWzRcsnEL5wSc/Xa5yBTWQcCxK0zn7nCBCATX7SuFL6VChMn
	7AZNs0XF0ozrYaCeeY6yuDT/HbCK93WehSXCUUh2uYNDMI8MX0+I710c
X-Gm-Gg: AR+sD11alru36iK8T18YQXJOZQng7gTRrvqafrvVY9uM8AajACvaaXS70CgYdCHs8VS
	/nuImI9GxSBQ/TE7fIp0JKFr8iarxLVXs/GMcLHiWoaP/PANh8LepcywhIMBY6vgtG2+HFVu7Er
	iSbjau0DVmU9773eHbybLtoZi7NY7MfkY0OOwFxFFzmeHZbCM3Xg5Mrat6uv/wzxuKfFLf2f18Y
	YrLDdp1kKfpJyFIucJwipbeQZ1+oOYo8PJFp2XUNKwa7Rb4h2932P/si1z7Xnu88FcRCyWWHzNl
	we27UZ79uZCOwIUCfzH6B7wcNjDNEG/5zw0cHJhMjlwAytqtxPVs81yEBlj+D2MXRW/72lhCdJu
	y/HUSk0AN5ZdlR4WAP+V9Nw48P4NodBvEC2tNxnu8ygeA6qx7hg5uSKqDkpDOe/JHgaWTG+Gg6b
	25mS2zA5zm9PaYbQrepjjR20pAkPjxUY/O7cs2WNGbnjWn42kXjH3sO3JSm5Mq+U3lQllFug==
X-Received: by 2002:a7b:c5ce:0:b0:499:726c:d658 with SMTP id 5b1f17b1804b1-499879bb9e5mr6552485e9.19.1786650480602;
        Thu, 13 Aug 2026 12:48:00 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981b631c1sm178430575e9.14.2026.08.13.12.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 12:47:59 -0700 (PDT)
Message-ID: <ccc4cb9f-41a8-4de1-a6ca-b5e074385e4d@gmail.com>
Date: Thu, 13 Aug 2026 22:47:58 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via
 the AC queues
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mehmet Fide <mehmet.fide@screeningeagle.com>
References: <12eaffd0-9d0f-44bd-8163-d05b6a3df611@gmail.com>
 <20260813185021.2290877-1-mehmet.fide@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260813185021.2290877-1-mehmet.fide@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/08/2026 21:50, Mehmet Fide wrote:
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
> 
> Hello Bitterblue,
> 
>> Could you check what the official driver is doing in the same situation?
>>
>> https://github.com/morrownr/88x2bu-20210702
> 
> Good timing, we had already done exactly that comparison before your
> mail arrived. That driver was our working reference on the same bench
> throughout the investigation (5/5 reconnect cycles where in-tree fails
> 0/5), and we went through its AP transmit path to understand why it is
> immune. It handles this quite differently, in five ways:
> 
> 1. bmc frames are buffered only while a station is actually dozing
>    (sta_dz_bitmap check in core/rtw_xmit.c, rtw_xmit_ap_enqueue). With
>    no sleeper present they leave immediately through the normal AC
>    path, which is what my patch restores for rtw88.
> 
> 2. The buffering happens in software (the bmc sta's sleep_q), not in
>    the hardware high queue. The hardware HIQ receives at most one DTIM
>    burst at a time (chk_bmc_sleepq_hdl), so it can never accumulate
>    into the page pool the way rtw88's standing high queue does.
> 
> 3. Even then, a filter decides what may ride the HIQ at all. The
>    default (rtw_hiq_filter=1, "allow special") lets only ARP, EAPOL and
>    DHCP through; mDNS/SSDP chatter never enters the high queue. The
>    rest of the buffered frames go out through the normal queues when
>    the burst is released.
> 
> 4. The driver owns the TIM bit itself: it sets it when it starts
>    buffering, pushes the updated beacon, and clears it only after both
>    the software queue and the hardware HIQ are empty, polled through
>    HW_VAR_CHK_HI_QUEUE_EMPTY. It does not depend on a beacon download
>    whose pages come from the same pool the backlog is exhausting.
> 
> 5. MORE_DATA is set on every burst frame except the last one, which
>    carries 0 and terminates the burst. rtw88 sets it on every high
>    queue frame including the last. That may be part of why I measured
>    the burst fetch not happening here even with BIT_TCR_UPDATE_HGQMD
>    set: the hardware never sees the end marker the vendor code
>    provides.
> 
> So the field-proven driver never routes bulk multicast through the high
> queue either, sleeper or not; the high queue is a small, filtered,
> explicitly terminated DTIM burst buffer for it, not a transport path.
> 
> Given that, I still think routing bmc through the AC queues is the
> right minimal fix for rtw88 USB. If you want to keep buffered delivery
> for dozing stations I am happy to work on the fuller shape, meaning PS
> tracking plus a software staging queue released at DTIM, but that is a
> much bigger change and the current behavior is a hard AP breakage.
> 
> Thanks,
> Mehmet

I don't know enough to have an opinion on this.

Shouldn't mac80211 handle the buffering already?
