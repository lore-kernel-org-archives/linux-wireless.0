Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB6B1A681E
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 00:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785198742; cv=none; b=mrIFfaRkqW+M8nNI6V3UosPzgjwxvPPTIC8v5qR9rPYeXOZz4VHF1JtyZpm9G9VIoqgkZ7T9jwVRl526UztUZZoKdT6Z503IPQ3m8a/wGQQzgodTMCEUlF/HYrwz3oW5sRXKcZSIDPzAjWsqDSejpry+haidLQINAyxp/as1bf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785198742; c=relaxed/simple;
	bh=Py3NE2dBA9D+wuyEQlhRPEbWAPlOdv9QpTay3xdbJqU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bWbgJXD2uu3zBCpQwJwIDFJnljY5XziHdRfsYlqHWW1l/y8Dtdlfrvr8VM/P7sjsBGBC0LBQsXKt4l6mANh6i3o1y3hz1EqbCm2CDvEx5QtTUosghO8MSJFmkbGJt+DT8CswTm8vR4uxh5IdK2FFaSfCss5WllIE7IAk+TaFzdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ng+LyGdv; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ng+LyGdv"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39c7fd45465so28767731fa.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 17:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785198739; x=1785803539; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sBKaaxjnGO8fOejWs/6cfNqroT5nasVGxgPviHoLMXs=;
        b=Ng+LyGdv2HmLFIykz9nZrOLMmc9/mS0k+vAAA5vCrkqIQ31QUcJZB8Ol1ZNH4Jf8EO
         nYVky4kT7WwQYlbTQhPBCZvxXrYrCfolRJiFnywlgeeZXTNcMJwOXrVfDX+whfsHtUsS
         yue7Gs28C6ywZGOJFTtrUOfbL4rG0SrGYA1dHBGFh28MLWlm2WD+gQRe8u3x++H7Bs88
         B6PC+0wf1jg1UjlRzv8WCsTOYihcHdi284I7nE+FsjoK3LCtidRzgjK5sMX/7vvi/5Kx
         Jk2agsxro6toVzN7Zmk9kx4gLMRpbrdGs4sKy9R5a2YnO8XciNjahYkdlFHqtBE+ODif
         +whQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785198739; x=1785803539;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sBKaaxjnGO8fOejWs/6cfNqroT5nasVGxgPviHoLMXs=;
        b=bALgPgnPYlVT4wyouwEgaZ40YNZHeYZhS5llel/9mxPtEPuy04837mkRjdA2zkHXjW
         WXh7KppjK41hmWFMChqHJbHwQ/rHzYPoc9XKJNeNe5xTvAOk/1+1iV2Fz/cx3t9Ctfb5
         8NNCRsbEg/obQKs//j+rTEolSBTFfra2sJybxX6i7cO4t/GNLJbdpY3ov9FVzr7KNfgh
         Q/scrSCsLCAkYWfGYCO6KuFxzXbivwZg5PLf61RxltVIRoY2XN+We/inYYS0uY1g/fK3
         OfXSotTh7jtpv+63KHTrJ6C3MsuxrEbFf7+t7YOFArsZK+dCBGQ3vOqeOOXS3fLpxBf/
         9qCw==
X-Forwarded-Encrypted: i=1; AHgh+RoV+nsUCweqFmOiws84tDcO0VIsVEbY05JsnauSCPS3o5cy6dOHpJw3qRHiHNnoeMh4nAX/USBa9akBVSiDrw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKHjet4b4nPH0O2V025HcYxjDAc2Nx/je0S61UC5WolBuu+2KN
	jcEMNRiulifOLYcssp2Vod5dz3qAvF5XLZBzNntGXGNrOCIoY3Y+sIfC
X-Gm-Gg: AR+sD12zXUAEESXKAlZ4O6jFPX48sUQtAmn28BJNKb60PGI5W+yKHI8yWEz5bySm1Ll
	+7y8vvWti5lizArn7I7OhhKCRYnVI2VVjHjmkOc0mvJShMjXJNqVYizgGClp3SrSTW7ohmstYJ6
	sEJO/p19PPPO2p+joU4ocAJI1ZKOZhFv6wiFeP6o9pB0NTHq2DqppO/BY9nO2ZMCDWU2elDjJry
	sufL25XxCSeiYBN3aGU3mmEqWNNoIB87EUjDaJ974LcaprNoaClxYfTvHyh/t6Uymc85BqMueUl
	2C4u3NL1uCHHnDWaLdf79C7+CrdoRH4xL1ks13WAc5my/mQNwDVVznfWcupCX4kmxI+OqN5lhBS
	S37PX/9+qjj6UVHYdDwIdwRN0C0qZXBPp86P29n9/5WG3CzEeYRIxYHyQudTvcI8X5Ca6tezG6V
	IqR7GO0r/WV8fZ113ht7el
X-Received: by 2002:a2e:be88:0:b0:39d:b717:622 with SMTP id 38308e7fff4ca-39f51d08b09mr197501fa.12.1785198738328;
        Mon, 27 Jul 2026 17:32:18 -0700 (PDT)
Received: from primary-ws.local ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f22173117sm15700311fa.4.2026.07.27.17.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 17:32:16 -0700 (PDT)
Message-ID: <e62097844d50d8392c44e8f3dc5aed73a64051c6.camel@gmail.com>
Subject: Re: hang during shutdown in next-20260722+ with MT7925
From: "mikhail.v.gavrilov@gmail.com" <mikhail.v.gavrilov@gmail.com>
To: Bert Karwatzki <spasswolf@web.de>, Nicolas Cavallari
	 <nicolas.cavallari@green-communications.fr>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	ryder.lee@mediatek.com, lorenzo@kernel.org, legale.legale@gmail.com, 
	sean.wang@mediatek.com, shayne.chen@mediatek.com
Date: Tue, 28 Jul 2026 05:32:14 +0500
In-Reply-To: <20260724151419.26014-1-spasswolf@web.de>
References: <20260724151419.26014-1-spasswolf@web.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.61.1 (3.61.1-3.fc45) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-07-24 at 17:14 +0200, Bert Karwatzki wrote:
> Since next-20260722 my debian sid system hangs when shutting down or
> rebooting (No error message when monitoring the shutdown process via
> netconsole). I bisected the error to commit
> 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
> and reverting this commit in next-20260723 makes shutting down or
> rebooting work normally again.
>=20
> Wifi device:
> 09:00.0 Network controller [0280]: MEDIATEK Corp. MT7925 802.11be
> 160MHz 2x2 PCIe Wireless Network Adapter [Filogic 360] [14c3:7925]
>=20
> Cpu:
> $ cat /proc/cpuinfo
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 26
> model		: 68
> model name	: AMD Ryzen 9 9950X 16-Core Processor
> stepping	: 0
> microcode	: 0xb404035
> cpu MHz		: 624.194
> cache size	: 1024 KB
> physical id	: 0
> siblings	: 32
> core id		: 0
> cpu cores	: 16
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 16
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good amd_lbr_v2 nopl
> xtopology nonstop_tsc cpuid extd_apicid aperfmperf rapl pni pclmulqdq
> monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c
> rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
> misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext
> perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpuid_fault cpb
> cat_l3 cdp_l3 hw_pstate ssbd mba perfmon_v2 ibrs ibpb stibp
> ibrs_enhanced vmmcall fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms
> invpcid cqm rdt_a avx512f avx512dq rdseed adx smap avx512ifma
> clflushopt clwb avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec
> xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local
> user_shstk avx_vnni avx512_bf16 clzero irperf xsaveerptr rdpru
> wbnoinvd cppc arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean
> flushbyasid decodeassists pausefilter pfthreshold avic
> v_vmsave_vmload vgif x2avic v_spec_ctrl vnmi avx512vbmi umip pku
> ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg
> avx512_vpopcntdq rdpid bus_lock_detect movdiri movdir64b
> overflow_recov succor smca fsrm avx512_vp2intersect flush_l1d
> amd_lbr_pmc_freeze
> bugs		: sysret_ss_attrs spectre_v1 spectre_v2
> spec_store_bypass srso spectre_v2_user vmscape
> bogomips	: 8599.52
> TLB size	: 192 4K pages
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 48 bits physical, 48 bits virtual
> power management: ts ttp tm hwpstate cpb eff_freq_ro [13] [14]
>=20
> Other pci hardware:
> $ lspci
> 00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Root Complex
> 00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Raphael/Granite
> Ridge IOMMU
> 00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Dummy Host Bridge
> 00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge GPP Bridge
> 00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge GPP Bridge
> 00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Dummy Host Bridge
> 00:02.1 PCI bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge GPP Bridge
> 00:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Dummy Host Bridge
> 00:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Dummy Host Bridge
> 00:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Dummy Host Bridge
> 00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Internal GPP Bridge to Bus [C:A]
> 00:08.3 PCI bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Internal GPP Bridge to Bus [C:A]
> 00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus
> Controller (rev 71)
> 00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge
> (rev 51)
> 00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Data Fabric; Function 0
> 00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Data Fabric; Function 1
> 00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Data Fabric; Function 2
> 00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Data Fabric; Function 3
> 00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Data Fabric; Function 4
> 00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Data Fabric; Function 5
> 00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Data Fabric; Function 6
> 00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge Data Fabric; Function 7
> 01:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL
> Upstream Port of PCI Express Switch (rev 25)
> 02:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL
> Downstream Port of PCI Express Switch (rev 25)
> 03:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
> [AMD/ATI] Navi 44 [Radeon RX 9060 XT] (rev c0)
> 03:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Navi 48
> HDMI/DP Audio Controller
> 04:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd
> NVMe SSD 9100 PRO [PM9E1]
> 05:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series
> Chipset PCIe Switch Upstream Port (rev 01)
> 06:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series
> Chipset PCIe Switch Downstream Port (rev 01)
> 06:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series
> Chipset PCIe Switch Downstream Port (rev 01)
> 06:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series
> Chipset PCIe Switch Downstream Port (rev 01)
> 06:08.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series
> Chipset PCIe Switch Downstream Port (rev 01)
> 06:0c.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series
> Chipset PCIe Switch Downstream Port (rev 01)
> 06:0d.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series
> Chipset PCIe Switch Downstream Port (rev 01)
> 08:00.0 Ethernet controller: Intel Corporation Ethernet Controller
> I226-V (rev 06)
> 09:00.0 Network controller: MEDIATEK Corp. MT7925 802.11be 160MHz 2x2
> PCIe Wireless Network Adapter [Filogic 360]
> 0b:00.0 USB controller: Advanced Micro Devices, Inc. [AMD] 800 Series
> Chipset USB 3.x XHCI Controller (rev 01)
> 0c:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD] 600
> Series Chipset SATA Controller (rev 01)
> 0d:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices,
> Inc. [AMD] Raphael/Granite Ridge PCIe Dummy Function (rev c1)
> 0d:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD]
> Family 19h PSP/CCP
> 0d:00.3 USB controller: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge USB 3.1 xHCI
> 0d:00.4 USB controller: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge USB 3.1 xHCI
> 0e:00.0 USB controller: Advanced Micro Devices, Inc. [AMD]
> Raphael/Granite Ridge USB 2.0 xHCI
>=20
>=20
> Bert Karwatzki


Hi Bert,

I hit the same hang on an MT7922 (mt7921e) and bisected it to the same
commit, so it is not MT7925 specific.

The cause is a double napi_disable().  mt7921e_unregister_device() and
mt7925e_unregister_device() already disable all RX NAPI instances, and
since 13b7e6a96a00 mt76_dma_cleanup() disables them a second time.
napi_disable() is not idempotent - it leaves NAPIF_STATE_SCHED set on
return, so the second call spins in usleep_range() forever.  Since
mt7921_pci_shutdown() and mt7925_pci_shutdown() reuse the remove path,
this is hit on every reboot and poweroff.  It is silent because the
stuck task keeps sleeping and rescheduling, so neither the hung task
detector nor the lockup detectors fire; sysrq-w during the hang shows
the task parked in napi_disable() under mt76_dma_cleanup().

I have posted a fix, which is Nicolas' suggestion extended to mt7921e
and with the then unused 'int i' removed:

=20
https://lore.kernel.org/all/20260728002048.19351-1-mikhail.v.gavrilov@gmail=
.com/

I sent it as a separate thread so that patchwork registers it as a
patch instead of a comment on the already applied commit.

Here on MT7922 it is tested with KASAN and lockdep enabled: module
unload and reload, reboot and poweroff all work again.  If you can
confirm it on your MT7925, a Tested-by would be welcome.

--=20
Thanks,
Mikhail
