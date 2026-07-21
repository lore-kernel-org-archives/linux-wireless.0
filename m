Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F9F3E49DD
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 17:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653949; cv=none; b=kOdM/T4xF6qol+BJt1olir9DBTIzxrmKpC7eqW0qMzVCYM4AfJrCoGi9i6Cx9KgFK0S3rcKVmAti8XWeOBCEFE2ZMvZd2eZ9RPj4dG3Ow883rZeJNGktzq8xmKUi8hF6l6set+Ud34wrjU5e6p9tonEKrhVolwp0bZxgCKigfJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653949; c=relaxed/simple;
	bh=gZTI9BD++aH3mPUH81RjuOPitkR/8NB3AVE+6utFAlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gh136Bq6wfYEtUZF190IKhEA91W7Uc/wxZWDTMm4Zje7vHRV/Hu3Lhr+ptOmFn/kHbCaAgIjO29s7zHj0267zsovUlSX0s/CJqlWVxA6ZgUd9RiW9c0bDlVzc9APPYJx9RnMfzRXnP39uEYbudB8ApCurGM+hrYZu3IKTx/k00Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7RZ1dcz; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7RZ1dcz"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493f75f7172so90237025e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784653946; x=1785258746; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yfP+igNJtjQ0feWA90w2r3JV9fyiHfM2sQPAfSJd6t4=;
        b=i7RZ1dcz2BhJ/0wN9kurH4OFMi5gCfcJKAWcGyAm1902BFiU/zMf+XvoYFo1LcOdJ4
         ZBBgMDMAVrTK+37s4RySJPvsL+lPdbxcFmCk95tZZwY9Osc1LuRHVs4xSnOCNOrcs9mk
         C2r8Irjc0BVkGVHAHAQwT5rxtS6g8uublF5ND7NSfOoKA4bbg1yh22h/kTUwX2gtNrDg
         3SzfKenF26wqm9nA2obrgWzcUftptgn8CWkszKBAj8TllzwkeaMZ5xB+MqjqPLkNE7Be
         UkDQkXVBsdi4sZP8VchUBgaioStTWiRfi+vjOXMqESlKR5/GV57uJxzlqxJ2YVKLgO1c
         05ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784653946; x=1785258746;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yfP+igNJtjQ0feWA90w2r3JV9fyiHfM2sQPAfSJd6t4=;
        b=bCypLTVI/t/xyxSeDtty8KNzUmfcHWuyZApAucbvk7w8BHlNLcPo6DmWzxDKVtC1zq
         08+6xJAB5mIuz7D19lCYNexgX3jp+XHC8B1q/NKdZrw70nmhRLtfHiR8pFK6unFSs9Zo
         JlGE/snH5L1vcw3j29e0z2TSQVrqy7X1KM9AW+GAV4AexmWY40dXPIG3RMtJwLO2PcCn
         xz+qz80VRa5DFKgk8aioxIsRA6wN6iGrjsbuZpWhRWzbFsAfY9syRe0zYsycwT+mUgcM
         G0Pji1kiFfstpFWyA2C+w4CcYpqdJFB6L2qxsb0ZSjd8WZPMoGWO5nhLb/JPoR8qAJPs
         /Xgw==
X-Forwarded-Encrypted: i=1; AHgh+RpR3+V/SoJ7O/jLaOG3vKcyyOCLRm1CdY+UE+zuN6qwouCwkS0UYgCoQaLaoHDiGnx5HCThn8/8XvgJ1g+d2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRMZVhTTAEE5TiQMmWNPkgCZ96UvvY7in/PUoadSiYXCk8c3Ky
	BGm6AHm9x+6n8oFKmdxlC127XlwTW+49BpVpttbNes/07roqo9B1T8/W
X-Gm-Gg: AfdE7ckPZWVTJXwt6CTCJT5NJU21/MdPyPYZ11IcAOFGMUBBGA2xYLV6Yju+EFs7Cp7
	i7+LFx8mNrF+3ey0KWeF9wPkXslKLQYqF12yw2FT9N+lSA2FTtaweM8nWJFSuQdBLA6OuG2o2Ot
	iM7WEebGfgf5JxjnAZq38DjGzqjwE7SUKE+M+GnduC9yKyWZ/bsrLhHGKmAPyqMS/gIhDIltOql
	Sn4nNWlUVfQthyXt4ufGh73tnXtIs1rXSByF4Jsp4r82PshG9m0LCtuv2L62AuFLdT3ntIh0F5Z
	SNrbRqiz92TxiXFnnO0aAauDvj5iUfUs9R66wMLnDIYqgzg2bZ7eUMwHVB/XyBZO4R5g/YGgrET
	/QTf2jD1AWiGP+ZQxgfHJXZMLbAEQ/gyB5CNPUeCaSCg8UGlNCHET2SN+y+rNoP13ld/LpuovXt
	2wgFHmEcYb3Q==
X-Received: by 2002:a05:600c:3b9c:b0:493:e57e:7aa5 with SMTP id 5b1f17b1804b1-4954dff444bmr224977345e9.22.1784653945856;
        Tue, 21 Jul 2026 10:12:25 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956ab2f0a2sm1432055e9.1.2026.07.21.10.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 10:12:25 -0700 (PDT)
Message-ID: <949a7883-552c-42c1-a98a-c7848377979d@gmail.com>
Date: Tue, 21 Jul 2026 20:12:24 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "straube.linux@gmail.com" <straube.linux@gmail.com>,
 "pbrobinson@gmail.com" <pbrobinson@gmail.com>
References: <cover.1784047561.git.luka.gejak@linux.dev>
 <1800080a275f4421b16bd3a028131e8a@realtek.com>
 <3EA0A653-D15F-4DD4-8DA6-C9CFFFF38205@linux.dev>
 <cbaa891f94ce41c7a6a1d576db50b75c@realtek.com>
 <9DAF08C8-7661-4AFB-8676-70AA856E1D0F@linux.dev>
 <7b9bf365-d07c-481a-8c9e-c2e03e326d5f@gmail.com>
 <DK4DINWYSQQK.3687NKGCC6EJE@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <DK4DINWYSQQK.3687NKGCC6EJE@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/07/2026 19:01, Luka Gejak wrote:
> On Tue Jul 21, 2026 at 4:47 PM CEST, Bitterblue Smith wrote:
>> On 21/07/2026 13:55, Luka Gejak wrote:
>>> Hi Ping-Ke,
>>>
>>> Thanks, and noted on stopping the v1 review. Before I send v2 I want to
>>> report two things: the firmware experiment you suggested, and what I
>>> found when I tried to work out which patches are actually droppable.
>>>
>>> 1. Firmware
>>>
>>> I tried all of them, plus the staging blob:
>>>
>>>   rtlwifi/rtl8723befw.bin      loads, version 15.17.0, associates
>>>   rtlwifi/rtl8723befw_36.bin   loads, version 36.0.0,  associates
>>>   rtlwifi/rtl8723bs_nic.bin    loads, version 35.0.0,  associates
>>>
>>> So the driver runs on all of them. But the coex reading does not change:
>>> BT Rpt stays 0x00000069 on every one, byte for byte. That makes sense in
>>> hindsight, since the version is reported by the BT firmware
>>> (rtl_bt/rtl8723bs_fw.bin) and relayed through, so no WiFi firmware can
>>> move it. rtl8723bs_nic.bin additionally produced 72 RA report WARNs,
>>> because the driver sets c2h_ra_report_size = 4 for the v41 report format
>>> where the siblings use 7.
>>>
>>> Since the driver was developed and tuned against v41 and swapping the
>>> blob does not help coex, I am keeping v41 and leaving the linux-firmware
>>> submission as it is rather than withdrawing it. If you would still
>>> rather I hold it, say so and I will.
>>> ,
>>> I have not closed the coex question, and I no longer think it can be
>>> closed from this driver.
>>>
>>> The driver does ask: rtw_fw_query_bt_info() goes out on the connect and
>>> scan paths and at power on. The BT side answers, so this is not a
>>> missing or timed out request. The answer is the problem. With A2DP
>>> streaming it reports conn-idle and an empty profile list,
>>> BT_RSP = 01 01 40 12, while the same dump shows 440 low priority packets
>>> each way. The profile byte stays 0x01 (CONNECTION) and never sets A2DP
>>> or ACL_BUSY. I checked the decode against the vendor driver, which reads
>>> the same byte, so this is not a parsing error on my side, and the coex
>>> algorithm itself is clearly running: TDMA case-3, table 10, reason
>>> BTINFO.
>>
>> Does the driver receive BTINFO regularly after you connect the headphones?
>>
>> If it doesn't, maybe rtw_coex_active_query_bt_info() can help. Currently
>> it only does something for RTL8821A.
> 
> Hi Bitterblue,
> 
> Thanks, that was worth checking. I measured it with debug_mask=0x40.
> 
> It does receive BTINFO regularly. With the headphones connected and A2DP
> actually streaming I get 19 Bt_info arrivals in a 30 second window, so
> roughly one every 1.5 seconds, and the values do change between them:
> 
>   [BTCoex], Bt_info[1], len=7, data=[01 40 0e 00 00 00]
>   [BTCoex], Bt_info[2], len=7, data=[01 40 11 00 00 00]
>   [BTCoex], Bt_info[2], len=7, data=[01 40 0e 00 00 00]
>   [BTCoex], Bt_info[1], len=7, data=[01 40 0f 00 00 00]
>   [BTCoex], Bt_info[2], len=7, data=[01 41 0f 00 00 00]
> 
> For comparison, with BT disconnected it is 1 arrival in 30 seconds. So
> this firmware does not go quiet the way the RTL8821AU one does, and
> rtw_coex_active_query_bt_info() would not add anything here. Good idea
> though, it was the obvious thing to rule out first.
> 
> The problem is what is in the reports rather than how often they come.
> bt_info_lb2 is 0x01 in all 19 of them: BIT(0) CONNECTION set, BIT(3)
> ACL_BUSY never set, no profile bits. So bt_acl_busy stays false and
> rtw_coex_update_bt_link_info() logs CON_IDLE 18 times, which is the
> correct conclusion from that input. Meanwhile the same coex_info dump
> shows Lo-Pri TX/RX at 419/418, so BT is clearly moving traffic.
> 
> In other words the BT firmware reports connected, not busy, no profile,
> so I do not think this one is fixable from the WiFi driver, therefore I 
> am documenting it as a known limitation rather than guessing at BT state
> in coex.
> 
> Best regards,
> Luka Gejak

I tried my RTL8723BU with rtl8xxxu and firmware v41. The first byte has
the expected value while listening to music:

[Jul21 20:07] bt info 0x02 [0x49 0x00 0x14 0x00 0x6b 0x2d]
[  +3.000128] bt info 0x02 [0x49 0x00 0x15 0x00 0x6b 0x2d]
[ +18.060885] bt info 0x02 [0x49 0x00 0x16 0x00 0x6b 0x2d]
[  +3.000191] bt info 0x02 [0x49 0x00 0x10 0x00 0x6b 0x2d]
[ +15.060793] bt info 0x02 [0x49 0x00 0x14 0x00 0x6b 0x2d]

So I wonder if you use the rtl8723bs vendor driver v5.2.17 what kind
of BTINFO does it get?
