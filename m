Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793386249;
	b=2z6mnAEUBhgqgMjmLIz2Vxj5qCGLA9+b9TVMfqX0VvAaxpJZX+spJllCFrMXpHd9O8ZR
	 j7m5O7/weA1RaNitE7tgXr5wUy5e2705084mXPYCx2qHArzmwQqyu1jLWG6B0NH6+hEWG
	 F38QJBMPqucOL1k+aeDCb2uLuA91Huh6ft5PtxTSD49VEw4+YQnQXPC/FP65H680s9UQ3
	 BbkcrRbRlD3v5JyGDvcJsjgZX+7dRzq9FrqRl8n5L0knpEEu3MUI1NJmiuwyDIRjF2wv9
	 kbYDucMUNdFX5totSSyY7pnGU6wa3EImVCXYfMvHNETk+tylmSJ3yvFy5MCkbggmRlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793386249;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=l378AgT+tO25P2E7QHXuF195+JVkEDiH7ytxJhDsLCo=;
	b=pS8JxBRPZP22UWi87+B4N88NG6pbeFyAdvxvrmhVurOxRXFzJ9FTqzVHyrk2R6H43wNb
	 rIfR4scOe0Znrx+dGjMAPQNlzQk+OTkT4pB8+CITy5ImmUaLEChx6P0McpLGw9j/wyaFz
	 e7CSRYQeTVd4ygPwFnEW9w4kmXLQ9WHASRXGGYI3fMHYotZtDkQHnqWbn/sv70iPBx3S4
	 vYgQty90LVxkWBg06kLAA3iPkCtRuLM4NLVCuW0trfwPS2NaPKTp8eKGAvgWcrjWTk+yy
	 01wql+b5VOW4m5Jf/PJoohUiCjQG+lWDCo9DS2fCoiiugbYbwtDc0YcWccdCdQCBOVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=psDrNpst;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002AC606A31F
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 18:50:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 002AC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=psDrNpst
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso11559145e9.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 11:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793386247; x=1793991047; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l378AgT+tO25P2E7QHXuF195+JVkEDiH7ytxJhDsLCo=;
        b=psDrNpstZUqLr2cNIvsaWSuBhnq5xJVHKN2FqzlhjEmfxYuVHEpltHqUfqCqtNxn7I
         6vUN+VTaCYXgRkqME42JlII1C7SLUbgXrOVmTS6U0EXoCS4/hOccZ3x2Q2r8Qpf9cRft
         HLZSZ6wL5ISjPyseJLUsMjQzqqCcMes5Ov5mbv9I2a/TXjxMAA7N5zzimbrwyYc/G464
         OkLJB5nNTF/N7c7TJo2xfguEbtO3exgpXvFNxzk0jXBD1pAEHEpUL7SsoFYcaTy2vQ3H
         ohh+wkQQj2szNnFmoh1J4XebS5d+C80+u7/xjHmDFmxuivjAkYulo+tp5iiRtOW5x2Hv
         4Ucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793386247; x=1793991047;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l378AgT+tO25P2E7QHXuF195+JVkEDiH7ytxJhDsLCo=;
        b=uhuhpAPxaMtOdBzef8QrWx910IxYWeJRu8cr2IiOU5quGE/NoVt387uM6VKfOOcZZm
         1b/7kxAZHyApuWkqjkydQszoPOTPQ0DJHtWA1jJItRowd3tar2r6t2h5nq5Yf08r092e
         dvKU6g0a6nmVVZ0DT+v7aiiIQyTju3mthVQ02/cSACvY283YF1VIN9EwwQm3NCiSQPwt
         nuz3x2kziIwb62R7ZAkUAusVKrv32MULQOxnrNgV2IUW1THLlGG9d4EpvbHOVi7cVsOf
         ln0uL0teQ9Lg8ZDRzdPT2iv0zB0uVihFArzK4fzMbyaOcSKceGQMJFS6f+9zZQ5wthRX
         PyUA==
X-Forwarded-Encrypted: i=1; AKwUvBxIahWPbAhw/01PHFKlJCFDiCR+K/qCML3A62C00UxBR+CxnGaimA2l5lXAOTynig5pDQPEQi89X0btzLRgIg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLarTxYApV23cZRzWQ4LH7cLgF3pbljhJkHlGTzIdAL7RIZtOpi
	vAZynFZTT3Kw0RA6kk2BTWbgfiUWMJhR43BAp2F5N7j4GpClV4b70fYw
X-Gm-Gg: AYBFou3LnxGjL54sM2gK3h9Boy6r6R4epn9OL9dNESIIhB2EN48ERRMLIcuvGyXrQuK
	WQEjAvc2oENSoEyAyzqugOhkUlBRv9U3r+vwK1aeuDirXdeCeVU0jJqaUEc9ZPGnKvhwDKniV0h
	LDfEzz6a/T9AOyXXMEx6pupliiqdS9oAz9af5sXas4MWBnoO0bu7992c/vnTUtATktdNPNz9k86
	Ecvp+BVgWHVIlbENUwZi/NyVALVF97giN3mQnkbyuZc1gNt8C7QiINPzFp/DhAvvVEak37/VPHg
	L3A8+dfusnp16+ck4P5KI9X6zeh9FvQzHKvF1QurbN475yimEm3QOmCiy7jTA1tTjlDhrc0SVAI
	rWWW3oEb3yMlM9CN1ayl63HqWeRSlAczjySPVKD6jaD/rQaX+/KZQkTXpxhtBhwXjy6aH7CsUNG
	YOBOBK0yWNP/GA0pXK4ycIinmufI38mMNMfMvrhq1x9OZZue3a2asGjV/hPIqVU2RUIv6YZk3RN
	WNFFIMk34On2ir/R9Ne6rsQjxXPNse2PqmMBCgKYqdu/dMfPotbIVU6McolO45RGZa0XxDT+leY
	BBNUMxD+4bwn5FKni8Ys2p2ctPwtpibO4Sdb
X-Received: by 2002:a05:6000:491c:b0:48e:6092:dea1 with SMTP id ffacd0b85a97d-48e6e304442mr7018666f8f.47.1793386247118;
        Fri, 30 Oct 2026 11:50:47 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71bab1a8sm4595187f8f.57.2026.10.30.11.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 11:50:46 -0700 (PDT)
Message-ID: <7f03b862-3cbd-4bc6-a1d8-9c2d5cd24afa@gmail.com>
Date: Fri, 30 Oct 2026 20:50:45 +0200
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
Subject: Re: [PATCH 5/6] wifi: rtw88: 88xxa: adapt channel sensing to receiver
 gain
To: Luka Gejak <luka.gejak@linux.dev>, Ho Jie Feng <hjf3108@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
References: <20261029055212.84711-1-hjf3108@gmail.com>
 <20261029055212.84711-6-hjf3108@gmail.com>
 <15240b8b-31f0-4587-a7a6-28cd4d36775b@gmail.com>
 <b54683e9ddd81ae2a4f08ed4a8dedcfdb0209a28@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <b54683e9ddd81ae2a4f08ed4a8dedcfdb0209a28@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/10/2026 20:16, Luka Gejak wrote:
> Hi Bitterblue, Jie Feng,
> 
> Thanks for testing this Bitterblue. I had a look at why the scan gets so
> slow and I think I found the cause.
> 
> October 30, 2026 at 3:57 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com> wrote:
> 
>>
>> On 29/10/2026 07:52, Ho Jie Feng wrote:
>>
>> During the scans I see a lot of "timed out to flush queue 1" (and 3)
>> in dmesg. You need debug_mask=0x80000000 to see these.
> 
> [ ... ]
> 
>>> +void rtw88xxa_adaptivity(struct rtw_dev *rtwdev)
>>> +{
>>> +    struct rtw_dm_info *dm_info = &rtwdev->dm_info;
>>> +    int igi_diff = EDCCA_IGI_BASE - dm_info->igi_history[0];
> 
> As far as I can see, igi_history[0] is not always the IGI in the hardware.
> Since 3f90942473d2 ("wifi: rtw88: Increase the RX gain before scanning")
> a sw scan writes IGI 0x1c without updating igi_history:
> 
>         rtw_core_scan_start()
>           rtw_phy_dig_set_max_coverage()
>             rtw_phy_dig_write(rtwdev, DIG_CVRG_MIN)
> 

That appears to be the cause. If I disable rtw_phy_dig_set_max_coverage()
the problem goes away.

> rtw_watch_dog_work() skips rtw_phy_dynamic_mechanism() while scanning, so
> if I read it right 0x8a4 keeps the value computed for the associated IGI
> for the whole scan.
> 
> In the 8812au vendor driver these chips are in ODM_IC_PWDB_EDCCA, and
> phydm_adaptivity() computes the threshold from the current IGI
> (cur_ig_value) with the same formula as here. So with the gain raised and
> 0x8a4 unchanged, EDCCA seems to get more sensitive by the difference
> between the associated IGI and 0x1c. Since rtw88xxa_adaptivity_init()
> clears BIT_DIS_EDCCA, the MAC would then hold the frames.
> 
> I think this matches the flush timeouts quoted above. Queue 1 and 3 are
> the LOW and HIGH priority queues, and mac80211 flushes the queues every
> time it leaves the home channel. Most of the delayed pings also came back
> together at about the time the scan finished, which is when
> rtw_core_scan_complete() writes the old IGI back.
> 
> The 8812A beacon loss branch in rtw_phy_dig() switches to DIG_CVRG_MIN
> after rtw_phy_dig_recorder() has stored the other value, so the same
> mismatch seems possible outside of scans too.
> 
> Jie Feng, maybe something like what rtw89 does in 280c444745aa
> ("wifi: rtw89: config EDCCA threshold during scan to prevent TX failed")
> would work here, setting 0x8a4 to 0x7f/0x7f at scan start and restoring
> it at scan complete. Or rtw88xxa_adaptivity() could use the IGI that is
> actually in the hardware and run again when the core writes the IGI,
> which would also cover the beacon loss case. I think this belongs in
> this patch for v2.
> 
> And one more thing Bitterblue, is there a reason for your email only
> being addressed to the mailing list. I am pretty certain that the
> author hasn't subscribed to the mailing list so your test results
> might now reach them.
> 

That is Thunderbird being helpful. On some emails it replaces the
"Reply All" button with the very similar looking "Reply List". I didn't
notice until now.

> Best regards,
> Luka Gejak

