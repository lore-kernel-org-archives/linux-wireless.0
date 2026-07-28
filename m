Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441193A3E8B
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785261321; cv=pass; b=eIPQDxXmFnFk0hkHCeK7mC0PLcxaxLtuIfl5lI/YWWFbWkSGuPLzhmuEX0iPkyiTCvOsjSrj1/scci5ZBU+bb3lHXy07PtZrKm1FWBVS/Gan4ubkywCuvSVF9q3RAB2foxa+k2KbQUP8fWv+1wtigEaYE8G1OEKCJRpr5Cw0SPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785261321; c=relaxed/simple;
	bh=0vwVVe4lbLYIv+6PjR+nGMgzuQ36L2AyQGRpPmcGQ7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JCHZuMi4z3KONQhFDLvz5ui2M3gxBL9sGO7W74VBhWa5ZZpvxUxkeG7Yk4BR29CC025S6hdtqridDr94q9eOakcxvI2CuJGM2p2QOpP86c/dQnnrmCzwfLgsxwVmioI+gV/CDkJZWDueDXsCvfGRnS9gUeBU8NkYhxoTo5BabZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LrE+Hjxn; arc=pass smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LrE+Hjxn"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9e0b89e228so14124a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 10:55:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785261319; cv=none;
        d=google.com; s=arc-20260327;
        b=pBnekZafCydOmOHnMoKDoxZEQQieexNtHQ9nUkW8MuUUcKzJsgy61zREK+WdEKmXgQ
         QHVJ3qc8GwgJxlYFFQryauYRF6wl5wNAyVebq6Tu75030z+dv5h8+UdPDFCwZEPLaXPu
         SET7Mniq+QzjReU1Tm13ZBHg8sukueSdbSKtk1SNAOwutUeKCUQJOerADRKvUetygjig
         eKFxHfFwtg3n5CQ0xOhsi+3fmxBvsOb/Lw1mBDOIsRqWrEW0OFsR5JJ0+x26V2iayeii
         7xsxZHZ42n5uTJQTPgm0m2EuIvMIuq4CsThbp6rsnmPFpG/zxKBHKXyXtE24AAxI0vSY
         Wm8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yfPYroLvAXbvDD7Gksc9w99kNnMpyUwz9A9cSGtYuV8=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=myp3/nJnLFEq4boAeqVerzb6SnWVDBOGHWIBHxL5XM5eva1L/S1+FCCS9aoCDZiOoH
         XSnp0mIledDHEbMy3aRKbrh+/CNP81242XaCS0lREHkQVCR43eGZxJlZpoJXLayu1lqG
         m4WTpQ7P2bz79m1G+dX5j5uhFKUoRgTPw9p/94NVWncFuQkPW1KPZDfER6exPbKTUnec
         3RkRW4tjroiah+38UoSbfz1Tx3DlgxfPOwXL4Lq3Km/6wYAOjGYS2go8RY2KBSQEUF/E
         4gzy90xuKOrXGzsG45aUFYfA024YG+Xd14N1ONdKSvIe8bbNc6yxXXbM3b0nc+4rdD/F
         g1IQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785261319; x=1785866119; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yfPYroLvAXbvDD7Gksc9w99kNnMpyUwz9A9cSGtYuV8=;
        b=LrE+HjxnMAfk8dmH9VSNuutTa1SdGAYxZtO8GidIvH1Pds8KLoi4NTMhDBO98vwkz8
         dkOG0yZbyzMKwrv9SQFGYKsWUA+ErTt79871EgTXOtexUgJkF/xiwAJjhdaiJavL4mFa
         7oHDSHLTlZJVeeStFBZ4vi8uBG8vBr1je4+Yy0oqFBI5K6mIR7p1SpqDnUpF1NzYAzuQ
         zBvwRt5nMu/RJKFospwLnE3kPbAGzGq+P6q8tTiV3+1PPzZZUclYFSHFAujnFFQr/4jG
         Ln5QIpsGJRa/SRa3JdI8hFpqWYod3GK7ce/pscJIBQjp4hG20NW3JReAdDck+bLhyv4o
         sxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785261319; x=1785866119;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yfPYroLvAXbvDD7Gksc9w99kNnMpyUwz9A9cSGtYuV8=;
        b=IwruMMRRVgnXaUPlhWvcioi+2FwrCrFM34ePLnktksKZnoPPivaJ2AMkN3UXkkVHNU
         G08Ra4VMGRbM7oxXElJbnl6wanFpL4b/LMpeHR7SfXgycZysoF7zGKQ0scEmsud+ANcm
         8GavrN8dS2lhRBQpu5YW9wh3huD5g4NypguNy2lG9pe+Ynz9iu+AQGHGAzLbvhp5GVwK
         4Lc4lsrlZIB8AmLv2d6wFlIutXhFf8J9lLB9ySQjzt2fKXXbVaQrSo37hSep+ANCLyIC
         veKYk9HVLiS74Oqrj0nBlEFkCo7Bikuubz14BUJTnmfBx+dKqGrlobz5Me8YxvRD7hW4
         1yIA==
X-Gm-Message-State: AOJu0YylTF0Bdf7VlDqIZNFOkZBlt7bvykP441qrcIVruiswu6RVAzai
	YO/CNPXaJYloFogsQPcPA1/wrXsrXz8PQfUK4xKVJa+9fo+LSCI/koIhRUhEAAKWx8vtdxUfJ0n
	WOK8BejEUCjyKH/o7NTRg52UccyK3DqQ=
X-Gm-Gg: AR+sD10prSDmwLhyGik3Wq5H8UuLC4Kxq/UivD6Ck1BCGV3d3cEZv8500/VuwSdNaSo
	KZotsySCsSPPGYnCvVGdPqPbhB4GiDljWD///PGsL4+PnxUmuvcKbLOXEIBydk/mlHMGWkQXLqZ
	CzVv40KxhWr5j/cJpa/SP+hBI/3vE9fzfSXxqi9iMHeD9wsUQIz/IIHP/rBpe4rE4vuGqJkZVdq
	yS20V8LWxc+DMe0mZS7rsxB7nxAuOnTAzlBFTgsAbuUR3qVdxv55eFlp6nVMO3ifyfNNDyiw6lM
	atDXYHfgZPNAbyVegSiqwyzypNWwvoe750iSv9wCGJofPFYy
X-Received: by 2002:a05:6a21:4847:b0:3c8:d3a4:7b40 with SMTP id
 adf61e73a8af0-3c8d3a4a7a2mr1595167637.2.1785261319341; Tue, 28 Jul 2026
 10:55:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
In-Reply-To: <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Tue, 28 Jul 2026 19:55:07 +0200
X-Gm-Features: AUfX_mwDWZNy9okj8MVqMliNa1MPXUSFBhbZfKO4V-hiichVkhqKo4pg2_g5Sjs
Message-ID: <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I used my PC running kernel 6.18.38-2-cachyos-lts for almost 9 hours
today and just when I thought the issue would not occur on this
version it did.
Do you want me to run another kernel for a day? If so, which one?

Full log and system info: https://paste.cachyos.org/p/d481dec.log
Firmware version is still 0.13.36.2 (52acc807).

Relevant output of dmesg:
[24695.491422] rtw89_8852ae 0000:05:00.0: FW status = 0xbd001100
[24695.491429] rtw89_8852ae 0000:05:00.0: FW BADADDR = 0x4400
[24695.491434] rtw89_8852ae 0000:05:00.0: FW EPC/RA = 0x0
[24695.491439] rtw89_8852ae 0000:05:00.0: FW MISC = 0xb898f053
[24695.491443] rtw89_8852ae 0000:05:00.0: R_AX_HALT_C2H = 0x1000
[24695.491447] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO = 0xf1000001
[24695.491455] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea5
[24695.491470] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898febb
[24695.491485] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe89
[24695.491499] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898feb7
[24695.491514] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe89
[24695.491529] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff89
[24695.491543] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea5
[24695.491558] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff85
[24695.491573] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe8d
[24695.491587] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff7d
[24695.491602] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ffaf
[24695.491616] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff81
[24695.491631] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe85
[24695.491646] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff8d
[24695.491660] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe8d
[24695.491673] rtw89_8852ae 0000:05:00.0: --->
               err=0x1000
[24695.491676] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO =0xf1000001
[24695.491680] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO =0xf1000001
[24695.491684] rtw89_8852ae 0000:05:00.0: DBG Counter 1
(R_AX_DRV_FW_HSK_4)=0xdeadbeef
[24695.491689] rtw89_8852ae 0000:05:00.0: DBG Counter 2
(R_AX_DRV_FW_HSK_5)=0xdeadbeef
[24695.491695] rtw89_8852ae 0000:05:00.0: R_AX_DMAC_ERR_ISR=0x00000040
[24695.491699] rtw89_8852ae 0000:05:00.0: R_AX_DMAC_ERR_IMR=0x00000000
[24695.491703] rtw89_8852ae 0000:05:00.0: R_AX_WDE_ERR_FLAG_CFG=0x00000000
[24695.491707] rtw89_8852ae 0000:05:00.0: R_AX_PLE_ERR_FLAG_CFG=0x80190000
[24695.491711] rtw89_8852ae 0000:05:00.0: R_AX_WDE_ERR_IMR=0xffffffff
[24695.491715] rtw89_8852ae 0000:05:00.0: R_AX_WDE_ERR_ISR=0x00000000
[24695.491719] rtw89_8852ae 0000:05:00.0: R_AX_PLE_ERR_IMR=0xffffffdf
[24695.491723] rtw89_8852ae 0000:05:00.0: R_AX_PLE_ERR_FLAG_ISR=0x02000020
[24695.491727] rtw89_8852ae 0000:05:00.0: R_AX_WD_CPUQ_OP_0=0x00000000
[24695.491730] rtw89_8852ae 0000:05:00.0: R_AX_WD_CPUQ_OP_1=0x00000000
[24695.491734] rtw89_8852ae 0000:05:00.0: R_AX_WD_CPUQ_OP_2=0x00000000
[24695.491738] rtw89_8852ae 0000:05:00.0: R_AX_PL_CPUQ_OP_0=0x00000000
[24695.491742] rtw89_8852ae 0000:05:00.0: R_AX_PL_CPUQ_OP_1=0x00000000
[24695.491746] rtw89_8852ae 0000:05:00.0: R_AX_PL_CPUQ_OP_2=0x00000000
[24695.491749] rtw89_8852ae 0000:05:00.0: R_AX_WD_CPUQ_OP_STATUS=0x00000000
[24695.491753] rtw89_8852ae 0000:05:00.0: R_AX_PL_CPUQ_OP_STATUS=0x00000000
[24695.491757] rtw89_8852ae 0000:05:00.0: R_AX_RXDMA_PKT_INFO_0=0x8000803c
[24695.491761] rtw89_8852ae 0000:05:00.0: R_AX_RXDMA_PKT_INFO_1=0x80008000
[24695.491765] rtw89_8852ae 0000:05:00.0: R_AX_RXDMA_PKT_INFO_2=0x8041803f
[24695.491774] rtw89_8852ae 0000:05:00.0: R_AX_CMAC_ERR_ISR [0]=0x00000000
[24695.491779] rtw89_8852ae 0000:05:00.0: R_AX_CMAC_FUNC_EN [0]=0xf000003f
[24695.491783] rtw89_8852ae 0000:05:00.0: R_AX_CK_EN [0]=0xffffffff
[24695.491787] rtw89_8852ae 0000:05:00.0: R_AX_CMAC_ERR_IMR [0]=0x00000000
[24695.491791] rtw89_8852ae 0000:05:00.0: [CMAC] : CMAC1 not enabled
[24695.491795] rtw89_8852ae 0000:05:00.0: R_AX_RPQ_RXBD_IDX =0x00530053
[24695.491799] rtw89_8852ae 0000:05:00.0: R_AX_DBG_ERR_FLAG=0x00000000
[24695.491802] rtw89_8852ae 0000:05:00.0: R_AX_LBC_WATCHDOG=0x00000081
[24695.491804] rtw89_8852ae 0000:05:00.0: <---
[24695.491805] rtw89_8852ae 0000:05:00.0: SER catches error: 0x1000
[24695.538126] rtw89_8852ae 0000:05:00.0: firmware failed to ack for
leaving ps mode
[24695.539757] rtw89_8852ae 0000:05:00.0: FW status = 0xbd001100
[24695.539762] rtw89_8852ae 0000:05:00.0: FW BADADDR = 0x4400
[24695.539766] rtw89_8852ae 0000:05:00.0: FW EPC/RA = 0x0
[24695.539770] rtw89_8852ae 0000:05:00.0: FW MISC = 0xb898f053
[24695.539774] rtw89_8852ae 0000:05:00.0: R_AX_HALT_C2H = 0x1001
[24695.539778] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO = 0xf1000001
[24695.539786] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff85
[24695.539800] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe89
[24695.539815] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea3
[24695.539829] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea1
[24695.539844] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea5
[24695.539858] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea7
[24695.539872] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fea7
[24695.539887] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff97
[24695.539902] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fead
[24695.539916] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff9b
[24695.539931] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898feb9
[24695.539946] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898fe8d
[24695.539960] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ff7d
[24695.539975] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ffb3
[24695.539990] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb898ffd5
[24695.540002] rtw89_8852ae 0000:05:00.0: SER catches error: 0x1001
[24695.540095] rtw89_8852ae 0000:05:00.0: FW status = 0xbd008100
[24695.540100] rtw89_8852ae 0000:05:00.0: FW BADADDR = 0x4400
[24695.540104] rtw89_8852ae 0000:05:00.0: FW EPC/RA = 0x0
[24695.540108] rtw89_8852ae 0000:05:00.0: FW MISC = 0xb898e663
[24695.540112] rtw89_8852ae 0000:05:00.0: R_AX_HALT_C2H = 0x1002
[24695.540117] rtw89_8852ae 0000:05:00.0: R_AX_SER_DBG_INFO = 0xf1000001
[24695.540126] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb893b8f3
[24695.540141] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb8939577
[24695.540156] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb8936bdd
[24695.540170] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb892d651
[24695.540185] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb893afe9
[24695.540199] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c130b
[24695.540214] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb893a5e9
[24695.540229] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb897bdad
[24695.540243] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c21ad
[24695.540258] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c136b
[24695.540273] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb897dc61
[24695.540287] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb897bdb9
[24695.540302] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb89c130b
[24695.540317] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb893a605
[24695.540334] rtw89_8852ae 0000:05:00.0: [ERR]fw PC = 0xb8936b95
[24695.540346] rtw89_8852ae 0000:05:00.0: SER catches error: 0x1002
[24747.600633] wlan0: disassociated from <mac-address-redacted>
(Reason: 2=PREV_AUTH_NOT_VALID)
[24748.039837] rtw89_8852ae 0000:05:00.0: timed out to flush queues
[24748.249924] rtw89_8852ae 0000:05:00.0: timed out to flush queues
[24751.377137] wlan0: authenticate with <mac-address-redacted> (local
address=<mac-address-redacted>)
[24751.377141] wlan0: send auth to <mac-address-redacted> (try 1/3)
[24751.389576] wlan0: authenticated
[24751.390445] wlan0: associate with <mac-address-redacted> (try 1/3)
[24751.398314] wlan0: RX AssocResp from <mac-address-redacted>
(capab=0x1431 status=0 aid=1)
[24751.509782] wlan0: associated

Relevant output of journalctl:
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea5
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898febb
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe89
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feb7
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe89
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff89
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea5
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff85
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8d
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff7d
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffaf
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff81
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe85
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff8d
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8d
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[CMAC] : CMAC1 not enabled
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
firmware failed to ack for leaving ps mode
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff85
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe89
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea3
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea1
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea5
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea7
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fea7
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff97
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fead
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff9b
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898feb9
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898fe8d
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ff7d
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffb3
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb898ffd5
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893b8f3
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8939577
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8936bdd
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb892d651
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893afe9
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89c130b
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a5e9
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb897bdad
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89c21ad
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89c136b
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb897dc61
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb897bdb9
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb89c130b
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb893a605
Jul 28 19:11:15 <hostname-redacted> kernel: rtw89_8852ae 0000:05:00.0:
[ERR]fw PC = 0xb8936b95
