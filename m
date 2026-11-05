Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886620;
	b=vPmor7WnDJeBVp68WWehEYcCM35VrsyoOrcI6qXGV6eo4uhzwgPv+Qk5sQx+33ZxFLiP
	 ecN9OUMsh+n48/nm/mYazhyhM3PfeTjiMK0Cnq28W/0a9Uy9vCpi4L/Be5pMWJv9XVT5e
	 sDc3n4htrtGvRjiSYDMN3xUv1ks90tmEwdmZwMigcZyyrWdQ0AbugrKT3bVXpKlP8DEYQ
	 n1msgDcDxon9tZp/SzninsvothB0SenKu1exIyN5ewd30aI8sYCr1oFtDBd/wBL5wQrDD
	 O0RuIPaGrH7fnkFQWdyDsUtcUHRuVehHUZ5HSRcWMM0TFgP9Fi/x6atBD+U4EDbg63A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=CUYO797ecyaAY5ezmWtNmHDiCTxxUya8Xsn7AmGhol8=;
	b=eHo1spEG/ZZYoLjbRC7I/rEkg6h/bGXmFLhS8BGJdmnimTJTIdIJ53L9z0BOLI5fMu+I
	 5AZQgpzWwqi/zK+IFbRqrx3cKG+NLWdR1VThmMZHW7jfpeQ8K+gp0Bctt/1UaV/IBPFXQ
	 TWzfeepJ6uO7iWsMLVf4g02LN29xZRBiAcOwLGoxX6gCbTB7ZgVDwc2R6a8/etzWy5jzR
	 zOX/a4mB6LEFmieS37nUnepKgii9vHq4Umu9mZL+Tui02jOEOuxSNMMg686t3xNsOZKNX
	 ilA81eKhoriZr4HXtdTEOTujEwMJInCto5XeF4WX7PX8bncsWTf99LIvlMG4dzVXsDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uqn4IB0x;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00414606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 13:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00414606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uqn4IB0x
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so15057005e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 05:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793886618; x=1794491418; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CUYO797ecyaAY5ezmWtNmHDiCTxxUya8Xsn7AmGhol8=;
        b=uqn4IB0xiQFAzci6rOG3bb6LYVAwMvFkYdzoyseeMOGv8T8mx96qgpAE9UjFOkIqBb
         ISAwTuD9NZF6yl0Ou0eIsBLFnvxXwd+DQ6wjNzgubqsHFWQfvlYUMxT/RIazmawaYtem
         HdJVof+n6mvlh74cbbt7MF6TvRqxIV/q8prenP7HVxGDYS5Ik+ls9T6Nk03rPF6MHNRs
         kiRdZC1B0rURkQW11e6GQ9o5pZ74/KW7AdjJACeRazE6ds3bcRORfMLj2ts10OtHhDwj
         6vmT5UwcWIgr+M+Z//wJWMII0FRLMV0zchfNBiquOhS4/0+51uz8ssfhr7f4hcvbhM4L
         reyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793886618; x=1794491418;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CUYO797ecyaAY5ezmWtNmHDiCTxxUya8Xsn7AmGhol8=;
        b=VQzHTkE1mhhlUTuaEUr1BFpZITyTH9UMXgdHJdgO3+ct/Dr/1Ix9A2bwq6Rh1fS3HB
         nFfsLNS2vSLo0R49PKNtnpbbM9tSy10hqHRPZe/T4x33MOi6DM39jaVHbX5Vy6Ydh1VW
         81pduQrENSwO3sngAf/Ps02TFY3/RQ4/EMv3R7AjKRTlv3Q/MTgk1qmHmJxXsqzBW5Wh
         iGDm+9NK/6oA5i9xwS4yqN1O2TLX8VAARnPVuxFObiPw8x5HoJJpUaSyeSvOCFbZQtnv
         J03IhwH8f3oOvGf3GmjplyGTi0IsDt9YPTZM/wVu4tR2EGgSQ7bkzcM+yThaLBTIkAdM
         fILA==
X-Gm-Message-State: APuU4Z9Yr4rniA6e0+4MfdOFeSU2pQC2tN7XNWhvPn33yviEe3zEWPfV
	JTE7Xp8437x63CimGKGxIfgJGmOjQZgMlsLB2eKGXeptYpOy16Qyy1QyipiKlV4mjFw=
X-Gm-Gg: AYBFou1xG+AZYqfbylqRzH7Khr/nvyTI/L9TB3fiGAJrFNRgLP3ZGTFfJuVPn5dTRyZ
	Ztnlls7RyyzGxATIStOsIQUR+gtPMHgynLR+qKNZ6agm/WMXV/6EwZitEgYO4Lt0F2Uz/W+Ywu5
	L73ilRyLgK6FIoCU6YKY82V6ZGV73wiCgdGRvwWkMWcgCjC1ChxUz9cPWMP5Sx/m04BGku4yS5O
	GHKSRcebJyxylVm0S+a/+x5dhLVZ63mb2xfCKtcjFbWMhl2mhTCJW/BwInfdSZz6r6Amb9wItn+
	khdkn5Ffxgttpzf/jfQe2iY3NyBzBtfOqXoqMybTfF4wTaA8u5DGpcePF/dFKqj/Rk7sDug40M6
	HUzgcnFqs5xTpyUfpVY4yr+TkBBiTahlqDvC2FElkXzHv1c4045Z/fvOnO7sk6sGa1bPIfKeSFO
	JTtEqnFRfMAVom6hMi/UqQkuwaEz645yUddbhUoqPA2YocT4573bMI58pYjugoTP5B+fjtRz/wE
	i3RiYpLW7fHcA5FXtj1mmM17l4JJJFIuBnfanlmmjHDLxLe/tyAmVaF0y9NHxF4HMUFyazrri1S
	wbUC8+tA2uZjNo+rqdszJbA47T1KxeP0Pn2Ik6tvBvGj3Qpdub0TfXeIMIo1Hrh9reLyfI4=
X-Received: by 2002:a05:600c:34cf:b0:4a1:dbdf:17a8 with SMTP id 5b1f17b1804b1-4ac150b3d01mr439631985e9.2.1793886617770;
        Thu, 05 Nov 2026 05:50:17 -0800 (PST)
Received: from freddies-laptop (nat-184-229.net.cam.ac.uk. [131.111.184.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4527fed5bsm184140495e9.3.2026.11.05.05.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 05:50:17 -0800 (PST)
Date: Thu, 5 Nov 2026 13:50:15 +0000
From: Frederick Watkins <freddiewatkins6@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org
Subject: [BUG] wifi: rtw89: RTL8922AE fails to resume from s2idle
Message-ID: <auyIxMg3r767ud7z@freddies-laptop>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

RTL8922AE fails to resume from s2idle

After resuming from s2idle, the rtw89_8922ae driver fails to reinitialize the
RTL8922AE adapter, reporting a WLAN timeout. The adapter functions correctly on
startup, and rebooting fixes the issue, however unloading and reloading the
driver with modprobe does not.

System information:
Laptop: Lenovo Yoga Slim 7 14ILL11
Kernel version: 7.4.0-0.rc1.261104.05441d69.412.vanilla.fc45.x86_64
Processor: Intel(R) Core(TM) Ultra 7 256V
PCI information:
00:00.0 Host bridge: Intel Corporation Core Ultra 200V Series Processors with 4 P-Cores 4 E-Cores Host Bridge (rev 04)
00:02.0 VGA compatible controller: Intel Corporation Core Ultra 200V Series Processors Arc Graphics 130V/140V GPU (rev 04)
00:04.0 Signal processing controller: Intel Corporation Core Ultra 200V Series Processors Dynamic Tuning Technology (DTT) (rev 04)
00:0a.0 Signal processing controller: Intel Corporation Core Ultra 200V Series Processors Crash Log and Telemetry (rev 04)
00:0b.0 Processing accelerators: Intel Corporation Core Ultra 200V Series Processors NPU (rev 04)
00:0d.0 USB controller: Intel Corporation Core Ultra 200V Series Processors Type-C Subsystem xHCI (rev 10)
00:13.0 Communication controller: Intel Corporation Core Ultra 200V Series Processors CSME HECI #1 (rev 10)
00:14.0 USB controller: Intel Corporation Core Ultra 200V Series Processors Standalone xHCI Controller (rev 10)
00:14.2 RAM memory: Intel Corporation Core Ultra 200V Series Processors Shared SRAM (rev 10)
00:15.0 Serial bus controller: Intel Corporation Core Ultra 200V Series Processors I2C #0 (rev 10)
00:15.1 Serial bus controller: Intel Corporation Core Ultra 200V Series Processors I2C #1 (rev 10)
00:15.3 Serial bus controller: Intel Corporation Core Ultra 200V Series Processors I2C #3 (rev 10)
00:16.0 Communication controller: Intel Corporation Core Ultra 200V Series Processors CSME HECI #1 (CSE) (rev 10)
00:19.0 Serial bus controller: Intel Corporation Core Ultra 200V Series Processors I2C #4 (rev 10)
00:19.1 Serial bus controller: Intel Corporation Core Ultra 200V Series Processors I2C #5 (rev 10)
00:1c.0 PCI bridge: Intel Corporation Core Ultra 200V Series Processors PCIe Root Port #3 (rev 10)
00:1c.4 PCI bridge: Intel Corporation Core Ultra 200V Series Processors PCIe Root Port #5 (rev 10)
00:1f.0 ISA bridge: Intel Corporation Core Ultra 200V Series Processors eSPI Controller (rev 10)
00:1f.3 Multimedia audio controller: Intel Corporation Core Ultra 200V Series Processors HD Audio (rev 10)
00:1f.4 SMBus: Intel Corporation Lunar Lake-M SMbus Controller (rev 10)
00:1f.5 Serial bus controller: Intel Corporation Core Ultra 200V Series Processors SPI (flash) Controller (rev 10)
01:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8922AE 802.11be PCIe Wireless Network Adapter (rev 01)
02:00.0 Non-Volatile memory controller: Sandisk Corp PC SN5100S M.2 2242 NVMe SSD (DRAM-less)

Logs on first boot (successfull initialization:
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: loaded firmware rtw89/rtw8922a_fw-4.bin
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: enabling device (0000 -> 0003)
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware version 0.35.80.3 (8ef4f0cf), cmd version 1, type 1
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware version 0.35.80.3 (8ef4f0cf), cmd version 1, type 3
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware version 0.1.0.0 (7b393818), cmd version 0, type 64
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware element BB version: 00 49 00 00
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware element radio A version: 00 33 00 00
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware element NCTL version: 00 0f 00 00
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware element TXPWR version: 00 46 00 00
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware element TXPWR version: 00 46 00 00
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware element TXPWR version: 00 46 00 00
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware element PWR_TRK version: 00 33 00 00
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: Firmware element REGD version: 00 49 00 08
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: chip info CID: 71, CV: 2, AID: 6933, ACV: 1, RFE: 1
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: rfkill hardware state changed to enable
Nov 05 11:55:15 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0 wlp1s0: renamed from wlan0

Logs on resume (failed initialization):
Nov 05 12:00:37 freddies-laptop kernel: PM: suspend entry (s2idle)
Nov 05 12:01:04 freddies-laptop kernel: printk: Suspending console(s) (use no_console_suspend to debug)
Nov 05 12:01:04 freddies-laptop kernel: PM: suspend devices took 0.167 seconds
Nov 05 12:01:04 freddies-laptop kernel: ACPI Error: No handler for Region [RCM0] (00000000b5169a23) [SystemCMOS] (20260408/evregion-131)
Nov 05 12:01:04 freddies-laptop kernel: ACPI Error: Region SystemCMOS (ID=5) has no handler (20260408/exfldio-261)
Nov 05 12:01:04 freddies-laptop kernel: ACPI Error: Aborting method \CPEP due to previous error (AE_NOT_EXIST) (20260408/psparse-543)
Nov 05 12:01:04 freddies-laptop kernel: ACPI Error: Aborting method \_SB.PEPD._DSM due to previous error (AE_NOT_EXIST) (20260408/psparse-543)
Nov 05 12:01:04 freddies-laptop kernel: ACPI: \_SB_.PEPD: failed to evaluate _DSM a040ebc4-d26c-e211-bcfd-0800200c9a66 rev:1 func:4 (0x6)
Nov 05 12:01:04 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: [ERR] PCIE SER clear polling fail
Nov 05 12:01:04 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: failed to read PCI cap, ret=134
Nov 05 12:01:04 freddies-laptop kernel: usb 3-6: reset full-speed USB device number 3 using xhci_hcd
Nov 05 12:01:04 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: [ERR]Polling WLAN PMC timeout= 1FF
Nov 05 12:01:04 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: xtal si not ready(W): offset=90 val=10 mask=10
Nov 05 12:01:04 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: [ERR]Polling WLAN PMC timeout= 1FF
Nov 05 12:01:04 freddies-laptop kernel: rtw89_8922ae 0000:01:00.0: mac preinit fail, ret: -110
Nov 05 12:01:04 freddies-laptop kernel: Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.
Nov 05 12:01:04 freddies-laptop kernel: WARNING: net/mac80211/util.c:1979 at ieee80211_reconfig+0xb1/0x1360 [mac80211], CPU#5: kworker/u34:11/1271

Attempted workarounds:
Disabling PCIe CLKREQ and ASPM L1/L1SS through the rtw89_pci module parameters.
Disabling rtw89_core power saving with disable_ps_mode=1.
Unloading and reloading rtw89_8922ae after the failure.
Unloading rtw89_8922ae before the suspend and reloading it after resume.

None of the above had any effect.

Sorry if there's any important information I've missed, this is my first time
interacting with the kernel mailing lists. I'm happy to test any patches/other
kernel versions.

