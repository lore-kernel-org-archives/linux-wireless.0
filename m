Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3765423A80
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169695; cv=none; b=aBQYDhXVX6QmcbgZpjpDUNJSMd46PEGsG/PR6nU0uEJ7plkI3KxxpO3U2tTb1z6CP1Pqsg0L2YOTpYubFjibYXKNIhjQDzfS1TfDPxOPNMZRCpd288BkerD1pzvjM9ESpOGPpfUs/cHGpjsvnsBqoTFDZQieyL7yCg85Sh9Cwhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169695; c=relaxed/simple;
	bh=/7f86A3+LjcVhGiTdoGXMVgBjHL8yRdw8oceoMwlbEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cpq2QoIc9eD9jROqW2SiSJ7T3+x1YwOt33ivp0QoWY54zxzrbvJvp9iWDnEe9CeavccDtFdujERabNXmvX+Dz0Fcq2ig/nrlWJgPwT787/6tvPf+aWfiT3ip/CHhX3nR2bzbXZZl6lh58L5UYoFCpElElUQS1iVdrYWztZd/Nds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=je7093Jz; arc=none smtp.client-ip=74.125.225.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="je7093Jz"
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-49556ce3549so12223265e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 09:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785169692; x=1785774492; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CfLACjj/JtfamMOkw6Mhzssh5fvxLzMAEBMiHp1DPTo=;
        b=je7093JzBdzAz7E8Pkb1Y3mEIJdzLfpYLIDtTlKdbbSdinaGo9pXe4va+U1G3d3AlN
         Kmd+mw8JPibqFKBRo8+xEYJ4/7SFOl0OnwZ3Ypi4rD9NcbMmVz94rV2fsWRRqlLdq9QD
         SwBdAO3XQenI/lXgfXy+or9jvmX8mpHSlWEBQPjyvJ2Lr7u5JfzvATU/ynj5Dm6vhwaO
         Yi43vystSxVqqEFhfjoOQnXCHKHQLeV5QsBR6NVR5i9DpFXqrJWWiX17Rx9T+K2q1aRn
         JZno6ckieGtD2Zxhp1I+ggD6WZDa3Rf8EhrATfQyOF5OsjEmaja6JTWveGyKFcgOxqkP
         hP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785169692; x=1785774492;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CfLACjj/JtfamMOkw6Mhzssh5fvxLzMAEBMiHp1DPTo=;
        b=FD7OrE3JpqiXSs3LIuD5VbT9lOYOtyLnnyQDz69Nyl1iLhvRFM/gGixYgag+Ips6ZP
         jE71jxpHlQHq4BBAeZfYAyLx1DeiRDNvf9SC2faLc7wUm05FKw/fmeAIK8ER1ROeclDP
         TN8aIWek/XlKuOnRwJ/8Sbje+qGlFoGXU8uMizs80xUESQTg/KPbjo5anPvPIdwwwgHE
         Dbc2iGxWXFqPf2zrtvcC9Mp8mbWkKgJcuK9cBBTUJ0I8hsjfjXs8cdDkMHfA4LnREOz2
         StxB8UTrvDil3pYTVL3rcXhAyrMaYfMRpPAJGu1Xc9Ekl/EN0znJCQezK9tW7/YZwXD1
         GzbQ==
X-Gm-Message-State: AOJu0YywpazAuDZK/2TWKeP4FSQFaP1JpnCjl0h1mcF/eb12gnzC4IhL
	062zfNgFHOEWEn6oYxKKUw45/Ek1Bg1yjfGQvHeiOuu5IkZXPDQQ+eZS
X-Gm-Gg: AR+sD113CvgoN6GfaLsqoQo5pV//0kMLrpt6YvN9zKu24BCO7Z3OsF4nUjOHQku2eHY
	yJt06pGyoK3n17z+Y2mh8S/S4sqirLmOPsvC8GHjj8KDPJqsCHGBj/4aUiJg4oZtyVt9hh3rhmv
	C9HdkMDGbBqGitwK14Rlga2DwGYuhZXvGmiFaeGCmEd/8i5jk5FSqiGbhEUkoB2f7N4qzyOoOQW
	MrtjnYQWZK925RPSYLRIN19W+1vsnxGGt5ejhFojF9MM804QfgQn22KPuBSW6yDuJfdcHTdjvfM
	eHVABM1GiVe1+6MvpVbRaSJjamb/p5CEo+O2+ZWhoFCmOwkuzhCdwPqLmxICWQOHh2jE5p78DJy
	4wJvQyhBiYanJ61gn46DLLqsmL6J+wHiiwt4v/AiMddH70OGUmeOfjGfakULiuCuFXxYdpQYQ4B
	aXs2hjgX48L9G59Dt7mcruARkEFQcp3cduYGhUqU0R9yyMcEByyMjlmAavXHAzqYyfgtBFLBU=
X-Received: by 2002:a05:600c:530c:b0:495:62bc:a022 with SMTP id 5b1f17b1804b1-496b56f99a7mr126331645e9.13.1785169691677;
        Mon, 27 Jul 2026 09:28:11 -0700 (PDT)
Received: from fedora.fritz.box (dynamic-adsl-84-220-246-20.clienti.tiscali.it. [84.220.246.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44b84edsm5878205e9.5.2026.07.27.09.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:28:10 -0700 (PDT)
Date: Mon, 27 Jul 2026 18:27:53 +0200
From: moosager <moosager90@gmail.com>
To: Sean Wang <sean.wang@kernel.org>
Cc: linux-wireless@vger.kernel.org, 
	"moderated list:ARM/Mediatek SoC support" <linux-mediatek@lists.infradead.org>
Subject: Re: mt7921e: repeated driver own failures cause hanging
Message-ID: <amd7c3Xk6NhBQr9x@fedora.fritz.box>
References: <4870974.vXUDI8C0e8@fedora.fritz.box>
 <CAGp9Lzp8NjVwkn2atNqT9x9-QTkWMLxK+Ntkb=3Z1fWcM6N=7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGp9Lzp8NjVwkn2atNqT9x9-QTkWMLxK+Ntkb=3Z1fWcM6N=7A@mail.gmail.com>

Hello,

On Sat, Jan 3, 2026 at 8:10 AM Sean Wang <sean.wang@kernel.org> wrote:
> Hi moosager90,
>
> Could you please share more details on how this issue can be
> reproduced?

I have found a (somewhat hacky) way to reliably reproduce the issue.
Just run this script for 3-5 seconds:

#!/bin/sh
echo 0x7c060010 > /sys/kernel/debug/ieee80211/phy0/mt76/regidx
while true; do echo 0xffffffff > /sys/kernel/debug/ieee80211/phy0/mt76/regval ; done

Running this script results in the same "driver own failed" messages and system 
slowdowns observed when the issue naturally occurs.

I have investigated the bug a little and found how it manifests in the driver 
code:

During normal usage, the function __mt792xe_mcu_drv_pmctrl writes to a register 
like this:
mt76_wr(dev, MT_CONN_ON_LPCTL, PCIE_LPCR_HOST_CLR_OWN);

and it expects to find 0x00000004 (which is PCIE_LPCR_HOST_OWN_SYNC). Instead, 
when the issue happens, it finds 0xffffffff, which does not change even after 
the driver attempts to write to it.

In essence, the above script recreates those conditions by writing 0xffffffff 
to the MT_CONN_ON_LPCTL register (at address 0x7c060010).

In addition, the failure of __mt792xe_mcu_drv_pmctrl returns -5 as an error 
code; this is not checked by the caller, mt7921e_mac_reset, which calls 
mt792xe_mcu_drv_pmctrl without checking its return value.

This issue still happens and is still reproducible on my build of the vanilla 
7.2.0-rc4 kernel, as it has been for every past kernel version.
This is my best attempt at investigating it, but i believe it is ultimately 
down to the firmware rather than the driver.

> Also, please confirm which firmware version you are using.

Here is the firmware version reported in dmesg:

[   15.848101] mt7921e 0000:62:00.0: enabling device (0000 -> 0002)
[   15.849369] mt7921e 0000:62:00.0: disabling ASPM  L1
[   15.865381] mt7921e 0000:62:00.0: ASIC revision: 79220010
[   15.958433] mt7921e 0000:62:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260605203307a
[   16.352504] mt7921e 0000:62:00.0: WM Firmware Version: ____000000, Build Time: 20260605203411

> As a debugging step, could you also try disabling PCIe ASPM and check
> whether the issue still occurs?

The issue happens whether ASPM is on or off.
