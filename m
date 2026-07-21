Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9564C8FF0
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784645274; cv=none; b=qDxU3no91SlZSJHuy5pGfm/VRobhpwlf7XxEm1OxooLnjApPU+PXWJ5y3WmjLbquTj7YQBZRRYS4MC/xv6zoMFf3ZTJg8T94wuUD9YJTA0WSnsOZN2lzJIHXPQS8CjYYs1efy2b8jsraMjzg+CfUmfaThh/cGYVVsVjUYp43Cz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784645274; c=relaxed/simple;
	bh=hyz02JwrAMdSZNlThcG4hqriLDqhltw2NznNX5juJvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y2LwkV/bbYZZxmMhJY6Jn+S+erAf3f+THvyQicM40HnQXm2Trdd7LL/Uu8LmQGR76oKe0X1Wv4QLhcerreYffQvhTdhRxYg9k/qQpTNkkdhLBNQyvL4u+X7d+ufAtubM3nEg11/qjcO6eaKjR/lbUO6ezp5N2DTfSVZbUcHny/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPXLuP6n; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPXLuP6n"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4956869750eso4881565e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784645271; x=1785250071; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G0rUn5MSwK/16r2xvLLRsGaeTKvr0ladreYJq8LBvQ0=;
        b=UPXLuP6ntTHs40PbiFoK0dWPej+13r8vcpK499j+Z41tsYbOPTfUk1TjNc+5k3fQgS
         rmH1GPgI8AyF8kofMUYJO1zybH/kNN7jnTgj0JUFsRWkmPHifcSYl9yyaXy3pgqO2N0v
         XoZYxXrPZ31rWUZcUTyXHQj8FOetVwy4OWo4SVkkAZN92Jv9nz14ZuRUDx/DYuV730uv
         MYu7MG/j8HdTpjgQkAFhwm3WXRc0Gg7PR25pu0ZiBDb+52T5Rly0bHN66o2KmKGsvudM
         qL6pfuthwX2L2gUOlan+FoQ91q1WvSNFzf2MlVSFelSdeAPQIT8fzRlsuNaMgV4Ny4iI
         tqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784645271; x=1785250071;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G0rUn5MSwK/16r2xvLLRsGaeTKvr0ladreYJq8LBvQ0=;
        b=XEm8SezEkyaSf6YeBUY/HF+n5LxU1SQhGF0XVo5faOg2reOVnz1GPM57ch02BQWUba
         Uem2Gavi71+ZaoIgRoxz/lizfM3XmwT3getUxfWGzPTRbTUqiYPMClRuYnwBtUi8V7BG
         MjzsiJC52YFo5kl2lCL81cMSsSxS079YvmBjIuMswVsyKNHk31BFCZgG2HK8XtQy2hSz
         xGYsLqmM0A1oPcEAS7JIRt0mtjoMXRGFp821/jan4L3aom7D2W8Tk+ejetnjCGH8JktC
         pINPKpOVDxwiZTvXupggt/xns/YfaPNvZrJnXZEHKntHNVM4zCPXi8RrICyefN0xXACA
         bDDA==
X-Forwarded-Encrypted: i=1; AHgh+RpTYVyPQcxpO0CadP9EgU5koMtG5EG+KXZ6ugHNalY55DPYZ1LLas9RPkIgHzGB96+rWkraLoOlPtQP77wOuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+TemLY5QossRHuUCroWM1hebQCZPuTllYBntf3EpVMxZycsJY
	mUX5VQ2dagQccqaGB0janCYGxyMhKMBA89zQZA+xqJVLDOGItuIG/QtV
X-Gm-Gg: AfdE7ckLA0/sDFYziM3iKuCRmgcslHQl/mqjei9E7efg0GeQMAR3gB03z+9hp3MY57U
	vbtaSB0ePEggvtZZWqhxfLz76X8UI28kUBGI4llD/9kGEYOwNMMEtMzog4wPvIO5mT72r70GK1R
	FJoGtZAWUJUzL7VbUp4EDtHCgiVzmHT7vb1ztrfP6xzzsaZPSCBy054ozVsFEB9XBKXGnLC/H3k
	ZD1CraHh7WoLmEiIVnRXjXyvq6imgrzCxLAf+YHNplDycqaou/y4LoaCszl3FIQR2Q/mBrnzhw2
	kHlHEefL+n84l1NHzv7vXctGXCTFoXcK6GOijx7Sy8891dEDGzIojTANYbX2XUkJ3ZjIJ9XOy/D
	CwNBm5dm/LHPTk2SLGP4wCLanJMrlk4eODZ0Ihjs6B6Wo7U2cA4Z8lqT8cMKUVRb94gmrRA7PC/
	Y7ooN/+tHQlg==
X-Received: by 2002:a05:600c:1396:b0:493:b150:c607 with SMTP id 5b1f17b1804b1-4954a3f36a9mr206621895e9.12.1784645271332;
        Tue, 21 Jul 2026 07:47:51 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495653bfed7sm82287445e9.11.2026.07.21.07.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 07:47:50 -0700 (PDT)
Message-ID: <7b9bf365-d07c-481a-8c9e-c2e03e326d5f@gmail.com>
Date: Tue, 21 Jul 2026 17:47:48 +0300
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
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <9DAF08C8-7661-4AFB-8676-70AA856E1D0F@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/07/2026 13:55, Luka Gejak wrote:
> Hi Ping-Ke,
> 
> Thanks, and noted on stopping the v1 review. Before I send v2 I want to
> report two things: the firmware experiment you suggested, and what I
> found when I tried to work out which patches are actually droppable.
> 
> 1. Firmware
> 
> I tried all of them, plus the staging blob:
> 
>   rtlwifi/rtl8723befw.bin      loads, version 15.17.0, associates
>   rtlwifi/rtl8723befw_36.bin   loads, version 36.0.0,  associates
>   rtlwifi/rtl8723bs_nic.bin    loads, version 35.0.0,  associates
> 
> So the driver runs on all of them. But the coex reading does not change:
> BT Rpt stays 0x00000069 on every one, byte for byte. That makes sense in
> hindsight, since the version is reported by the BT firmware
> (rtl_bt/rtl8723bs_fw.bin) and relayed through, so no WiFi firmware can
> move it. rtl8723bs_nic.bin additionally produced 72 RA report WARNs,
> because the driver sets c2h_ra_report_size = 4 for the v41 report format
> where the siblings use 7.
> 
> Since the driver was developed and tuned against v41 and swapping the
> blob does not help coex, I am keeping v41 and leaving the linux-firmware
> submission as it is rather than withdrawing it. If you would still
> rather I hold it, say so and I will.
> ,
> I have not closed the coex question, and I no longer think it can be
> closed from this driver.
> 
> The driver does ask: rtw_fw_query_bt_info() goes out on the connect and
> scan paths and at power on. The BT side answers, so this is not a
> missing or timed out request. The answer is the problem. With A2DP
> streaming it reports conn-idle and an empty profile list,
> BT_RSP = 01 01 40 12, while the same dump shows 440 low priority packets
> each way. The profile byte stays 0x01 (CONNECTION) and never sets A2DP
> or ACL_BUSY. I checked the decode against the vendor driver, which reads
> the same byte, so this is not a parsing error on my side, and the coex
> algorithm itself is clearly running: TDMA case-3, table 10, reason
> BTINFO.

Does the driver receive BTINFO regularly after you connect the headphones?

If it doesn't, maybe rtw_coex_active_query_bt_info() can help. Currently
it only does something for RTL8821A.

