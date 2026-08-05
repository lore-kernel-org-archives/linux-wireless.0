Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C2B3876BA
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940253; cv=pass; b=R8Nqayfm708TrTHUGy7i0Tf3/Kk27CjM3oUJZ7K4PKDPhQXqHRhrCRtVMufV+yWXkGRdIzTlGjS8h7m6MYwDF45vK+TiO4ZCdDu7L6uvZ52NRrP8+o9jgfd9dWI5LaxQcdnyCoPWUmAmtQNO/H8vigpt1VGmi/T4ngmjNhWyx0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940253; c=relaxed/simple;
	bh=nVkw7S/S8YZQkYX75mov7wW1nD1au4zCD5yOqhgZZLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aM87er8Oabsx+ff/ryq7qbbCyt1DEAdGtSkEVowjK300jY5pyGPp8gderZzUBsLCLuRVLE/olTd/drB5Ci7r9ysAYP61lPqbtoATlSCMwtKCRx8HjELW0yCc1/KJrfxgPeynxOekxsg8xoHFOT6zUpFqX/C2w+oZdnmaJVn5fBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=EsBJUgZG; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="EsBJUgZG"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso1037860a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 07:30:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785940241; cv=none;
        d=google.com; s=arc-20260327;
        b=Hrvl+J1UY00btdXGdQxDH+5EEHfmFsVZg9GS8CCZvcvH8c0VPaL0eU0UTWqOX/2K5y
         VmHN88EzM6sJMwztADSGtvH41uuAH5EFVvR1FAxYUALlznYeLPw3NxRLu+IUG6b+JBsA
         e6zWyhPKupJFRlJTFRQFI0+cgtCNZJaBfXkfRtdDiaBBI046JIP1b/H5xr5SXt9jL3WK
         Pnufsn1SENBlElkZ0Qt0zGHbwBuHOUol1qzIpaWx/xqNjLlRU7GjngQiAHJ/ocQFlj5F
         xxGVweXdhTp5QfQEAiifhz9RFwK9krj858nzpO6n3wm84O2ucs3OhTDdZXe+EZAA411u
         l0KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4ABBdm8gy6VtPwyClt8h4QARX2YqTG4pZ6M4pDua5XQ=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=joliTqDZws5MPcm2gz5/XGhY3fRsH5BSftISIkW7mO7LdKUdp+T5Lejr6+DEAzOX1a
         MQlVlw0wKHn3uGEsiWnQfZvzwc1tvF6rwy2AZWuwqGXbYP9p1go7orgp7witddDto+K4
         /DhOq/QkhZvklFxLu/JsV+4LiFwxLfj0KTwUCRF7CaCAmV616jwQGIruacNxmmf7+dhr
         5+V9JuB/M5yHgRKH01GaZYtqoy5PxMrsBlNL/dYCZdeMyhQG+wjQcosWxTXxaKvOdqA0
         nz6NVVvQcLFrLfCWvtOW0U6LzYJ6Mj7EvQ4ADJUWOdTNEV6OrdVHYzKz3PUt4+C6i3uX
         FalA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785940241; x=1786545041; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4ABBdm8gy6VtPwyClt8h4QARX2YqTG4pZ6M4pDua5XQ=;
        b=EsBJUgZGkarInuOQcggo5fEYSCJjcWUlym2bmmA/ILxNYPD93qo/FuUEi+2hHgi3mg
         7x7a88VLL1DAj5SkUXaS/BobcFdeBD8CgVUTHYGTusH9jyY6wY5EuOdFf7JN+CVeyTYl
         T8NMAcShpdR6swhlU2xrLi7/U5xVx1EDjSwybnLDrdLfeTfDncckZkBpl4lYoVxSu6jh
         WvlehYJQGlOfmGLjLr3LYUsGJ9yZf4shUFxIFUmCoMf5L75E9ZOjIK3IKX1g8090UMvQ
         GM023MzVWkz1ggBeYaQ7GmUvPFrWPwj/E9+l2lZON8KELHtJvhe6mDVpCzP8NZeo7rWJ
         eCQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785940241; x=1786545041;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4ABBdm8gy6VtPwyClt8h4QARX2YqTG4pZ6M4pDua5XQ=;
        b=j0eOa6dMyB32Cp5Y2WBsrtbx9xwpZiSVR4LcVh9dFaTTgfLubZAZBuTzW7JZ7fetmH
         V+a4prfyKtL52Gcw71aYt2eID9l5HGMSHob2T62DWSfq3hSVJun2TJyAw0352s0S6hs0
         5dHzSgFDJHgQEY8uQD8tmHpgcN0tBSDEsG+8lAGB7AX2Pr9vD6TMJfQoLG20GGLF4NS6
         ZWTy8JtRbzIeO6G3J3Enl2hS5fx/EHD0++WTymt1LpheQkDvQT9fHHxyhzJwukzQhUmk
         hoNw6hisvH6r2Cbeva0efgyAadCnAvuOj9TJtpbiIBpPLbguUemcWu1a0jPmopOjmWDb
         Ee9w==
X-Gm-Message-State: AOJu0Yz6nWQfwKZLITrFTM1RrAOqEg5I9R/Rv+3zNFSJYAXVhSfR9/7h
	rUVRxFX6+/skzGTu7CEBVIfYcCBnaLriC04J9i5enNW8J4XVQdJOvNGUBRuS/JDGU70EQHvmzzB
	R7VPzBLUXMW6ZJDS0H/zpDMy2gBaFsAZcsME/
X-Gm-Gg: AR+sD13ps7K+ParERP3DNwRmYBB9OmlcXJJj40SEUQmljtn7W5+Ypis03fmUNMU4+p9
	lQQGbJOW58xGaYZJzSgkZZYYbh9/7TG2ZmMOo8DinpbwjoemTLfUEI0iRuGRW+s+xVDXhJ43i5/
	Zkn8VKHeWt6Vv6vLhcKozKPigGrbYAuMG8sLWGnDu1NcojuDm2pvmq46JRVewf6de/qGliOVoF8
	cPfz7U74Am0D9yjHhhQDxA/t1Hr/zUTeAbA9jsDZZOxUuevrcTynF/UfnM7kZn08cH21m6GlO5m
	gOognGy6h2oq+08u4ZoeuGpOWyJ9b+I+/ZHRausXSgIoERRgAAUA4mi3vAPrK0R4G5zsAU381pC
	rMZzcmqcVgg2yba/c6HYFTYMa+f7TsLYQ
X-Received: by 2002:a17:90a:c107:b0:38e:6f90:eabd with SMTP id
 98e67ed59e1d1-3903c53783cmr8635709a91.5.1785940240885; Wed, 05 Aug 2026
 07:30:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com> <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
 <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
 <013f7d3cf223417c94df41a2a45fa540@realtek.com> <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
In-Reply-To: <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Wed, 5 Aug 2026 16:30:28 +0200
X-Gm-Features: AUfX_mwp84vSDWm6IjL_F3xXtpMc-1zdCjpR9YOhAveHuqZZT4EgP95N4evRl9k
Message-ID: <CAOQMLZVMALBLeCZUB3Jdvk75znt0D7HxrXyPMhGPvcKLx3j-Yg@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Continuing to use 6.6.9-arch1-1 was a good idea. I did get an error
today: https://github.com/user-attachments/files/30747862/2026-08-05.15.51.12.6.6.9-arch1-1.log
Unlike errors on other kernel version I didn't notice the disconnect
here. I just saw this error in the log by accident afterwards. I was
in a zoom call during the error, so I would have expected to notice
any disconnects. Maybe the recovery is much faster in this kernel
version?

The output looks very similar, so I believe this is the same error,
but I am not 100% sure. For example the message "firmware failed to
ack for leaving ps mode" is not present here, but maybe that message
was added to the driver code later.

Also interesting: there was no message like "wlan0: disassociated" or
"wlan0: authenticate" after the error. Maybe there was just no
disconnect despite the error, which would explain why I did not notice
a problem until I randomly looked at the log.

Relevant excerpt from the link above:
[20763.187469] [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=36 TOS=0x00 PREC=0xC0
TTL=1 ID=38024 DF PROTO=2
[20836.465375] rtw89_8852ae 0000:05:00.0: FW status = 0x62001100
[20836.465385] rtw89_8852ae 0000:05:00.0: FW BADADDR = 0x0
[20836.465389] rtw89_8852ae 0000:05:00.0: FW EPC/RA = 0x0
[20836.465393] rtw89_8852ae 0000:05:00.0: FW MISC = 0xb898f053
[20836.465397] rtw89_8852ae 0000:05:00.0: R_AX_HALT_C2H = 0x1000
[20836.465401] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO = 0xf1000005
[20836.465409] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ffaf
[20836.465423] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe8d
[20836.465437] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff83
[20836.465452] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe8f
[20836.465466] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff8b
[20836.465480] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe95
[20836.465494] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ffa7
[20836.465509] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff83
[20836.465523] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea7
[20836.465537] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe8b
[20836.465552] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff97
[20836.465566] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea7
[20836.465580] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff9d
[20836.465594] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea9
[20836.465609] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff9f
[20836.465620] rtw89_8852ae 0000:05:00.0: --->
               err=0x1000
[20836.465624] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO =0xf1000005
[20836.465630] rtw89_8852ae 0000:05:00.0: R_AX_DMAC_ERR_ISR=0x00000010
[20836.465633] rtw89_8852ae 0000:05:00.0: R_AX_DMAC_ERR_IMR=0x00000000
[20836.465637] rtw89_8852ae 0000:05:00.0: R_AX_WDE_ERR_FLAG_CFG=0x83190000
[20836.465641] rtw89_8852ae 0000:05:00.0: R_AX_PLE_ERR_FLAG_CFG=0x00000000
[20836.465644] rtw89_8852ae 0000:05:00.0: R_AX_WDE_ERR_IMR=0xffffffff
[20836.465648] rtw89_8852ae 0000:05:00.0: R_AX_WDE_ERR_ISR=0x02000020
[20836.465651] rtw89_8852ae 0000:05:00.0: R_AX_PLE_ERR_IMR=0xffffffdf
[20836.465655] rtw89_8852ae 0000:05:00.0: R_AX_PLE_ERR_FLAG_ISR=0x00000000
[20836.465664] rtw89_8852ae 0000:05:00.0: R_AX_CMAC_ERR_ISR [0]=0x00000002
[20836.465668] rtw89_8852ae 0000:05:00.0: R_AX_CMAC_FUNC_EN [0]=0xf000003f
[20836.465672] rtw89_8852ae 0000:05:00.0: R_AX_CK_EN [0]=0xffffffff
[20836.465675] rtw89_8852ae 0000:05:00.0: R_AX_PTCL_IMR0 [0]=0x10ff20ff
[20836.465679] rtw89_8852ae 0000:05:00.0: R_AX_PTCL_ISR0 [0]=0x00808400
[20836.465683] rtw89_8852ae 0000:05:00.0: R_AX_CMAC_ERR_IMR [0]=0x00000000
[20836.465686] rtw89_8852ae 0000:05:00.0: R_AX_RPQ_RXBD_IDX =0x00e400e4
[20836.465690] rtw89_8852ae 0000:05:00.0: R_AX_DBG_ERR_FLAG=0x00000000
[20836.465693] rtw89_8852ae 0000:05:00.0: R_AX_LBC_WATCHDOG=0x00000081
[20836.465694] rtw89_8852ae 0000:05:00.0: <---
[20836.465695] rtw89_8852ae 0000:05:00.0: SER catches error: 0x1000
[20836.465837] rtw89_8852ae 0000:05:00.0: FW status = 0x62001100
[20836.465841] rtw89_8852ae 0000:05:00.0: FW BADADDR = 0x0
[20836.465845] rtw89_8852ae 0000:05:00.0: FW EPC/RA = 0x0
[20836.465850] rtw89_8852ae 0000:05:00.0: FW MISC = 0xb898f053
[20836.465854] rtw89_8852ae 0000:05:00.0: R_AX_HALT_C2H = 0x1001
[20836.465857] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO = 0xf1000005
[20836.465865] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe8f
[20836.465880] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898febb
[20836.465895] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe87
[20836.465909] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe97
[20836.465923] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898febb
[20836.465937] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff97
[20836.465952] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea7
[20836.465967] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ffa9
[20836.465981] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff9b
[20836.465996] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe7f
[20836.466010] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff7d
[20836.466025] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe8d
[20836.466040] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ffa7
[20836.466054] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea1
[20836.466069] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff9b
[20836.466089] rtw89_8852ae 0000:05:00.0: SER catches error: 0x1001
[20836.466325] rtw89_8852ae 0000:05:00.0: FW status = 0x62008100
[20836.466330] rtw89_8852ae 0000:05:00.0: FW BADADDR = 0x0
[20836.466334] rtw89_8852ae 0000:05:00.0: FW EPC/RA = 0x0
[20836.466339] rtw89_8852ae 0000:05:00.0: FW MISC = 0xb898e663
[20836.466343] rtw89_8852ae 0000:05:00.0: R_AX_HALT_C2H = 0x1002
[20836.466347] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO = 0xf1000005
[20836.466356] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c2133
[20836.466370] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89b56a5
[20836.466385] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c5137
[20836.466399] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89394af
[20836.466414] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb897beaf
[20836.466429] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb897dc23
[20836.466443] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb893a62b
[20836.466458] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb897dbe9
[20836.466472] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c1311
[20836.466487] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb893a66f
[20836.466502] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89369d9
[20836.466516] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c170f
[20836.466531] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c163d
[20836.466546] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb893712b
[20836.466560] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c2103
[20836.466572] rtw89_8852ae 0000:05:00.0: SER catches error: 0x1002
[20836.502850] rtw89_8852ae 0000:05:00.0: c2h class 1 func 3 not support
[20888.217364] [UFW BLOCK] IN=wlan0 OUT=
MAC=<mac-address-redacted>:<mac-address-redacted>:08:00
SRC=<ipv4-redacted> DST=<ipv4-redacted> LEN=36 TOS=0x00 PREC=0xC0
TTL=1 ID=301 DF PROTO=2
