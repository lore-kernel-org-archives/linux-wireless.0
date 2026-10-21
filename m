Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792563225;
	b=Ju1iJFNj7P9NQb8NeUpTQdGhIg3qHQvV7aosj+qwEWKRFIotUq6zp0bqvkJ7IbH32sUa
	 zUwGEZMpPAxNsYQGS1Qx86Yu8ehDzwNdxO2fvDg8LuuNBJllqA3Gqz0SXitQ/PwyS7J63
	 egXjxlCc4ratHR75sF+m8fxuZRQpQjSb5dmOha+Snm62UEfzZeQH8wXEsnkFOuni1g/Cs
	 eH1bsWoTzB+jjAI+MNHmZ2lNiEOZqeO2BimLayYkw95WGgpF547yM0oU1MAD0PRvOGrSa
	 ZpcDytHlInCcsppBczHGARbGf5fZOYRrCJPNGHZaPC1wQboT1VEJtxobqw8VFd6Yfpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792563225;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=POTt6D1OgauRrY8k1vEWEZeF2cYhNnrrsYVlV43I0WA=;
	b=sPHmLwKxVvdCXrvUy/VbbbbDhS7vpC+G0Shu1DwLvYVzjzeqcmi0RiwLMv9kK3yi5nGY
	 j5CcY1iYDoJlf2xtSCaGewh81Thfp+owGOI2JlNoeVIRyOp9WxCbVjO/AIPktDcNqdz3M
	 Qi5BnhQWEvyNVx3Hx2MwmdJWPuMdAghY2wo9b4GCJeGxHIwWAhe/JOFs2CoGNTVKxJOVj
	 8kFmC+x278w2gICnvZYgvfRj0hdB0unoJuPKPuOnD0rYuO3ZffRbA8ZQPE3vwMOB2eiT8
	 OP3GWbVEl6IBcw/FjruBsCl8C1hPmu6tV9Eb4UFxaJZ3azWZ/SOkEe13Zz+EtaJN3Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Dz7CgAHA;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B45606A325;
	Wed, 21 Oct 2026 06:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47B45606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Dz7CgAHA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792563225; x=1824099225;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zoRAmnpBls2Nylk53pHmCqUXQ+xNgPqiQAFCKXRHWUU=;
  b=Dz7CgAHA95NsIn3nkFUb+8jUL7WoUt9bVQoq4JWe9h1fAXsR8Fy/fc9X
   35n2EASQMdi4A4o01GR6xs+T9OMN8rlHcd0DaeCg0qmSW/PQMp1XWccVM
   cV1qaUBcgdEUxJEtrVHEHPujejsL/hcVJlH5JwuLIi/TYX4o4/u0ZKDJa
   3rZQfOSrR21RZMWCmRIUusBbQ+Qp9xhm3d1aTnaag6BJn2IcUEzMcweM6
   iWupuQdX6oacllJ+u9q//Ndf1X5WB1i9PHEbZjYMtbsATbsfkK5EiFWWH
   fzh7cn5qYZkORGdprUvFXM0t6lgcjl2YzGk5X2fEDAHXTaH0tIHV/tvNo
   Q==;
X-CSE-ConnectionGUID: Ji/Rw3dbSgqG7TzSz+cCSg==
X-CSE-MsgGUID: 3BB1bHMSRte6axfiSIo7cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1281495"
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="1281495"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 23:13:44 -0700
X-CSE-ConnectionGUID: q9De8LF1Tz+6m/1zFAuAlg==
X-CSE-MsgGUID: cWHIF8jUQ1+92Y77y8Qvzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="2946911"
Received: from blu2-desk.sh.intel.com (HELO [10.239.156.26]) ([10.239.156.26])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 23:13:42 -0700
Message-ID: <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com>
Date: Wed, 21 Oct 2026 14:13:40 +0800
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
Subject: Re: intel-iommu: DMAR PTE Read fault crash-loops a PCIe wifi device,
 v7.3-rc7 -> v7.3 final regression, reproduces on one unit out of five tested
To: "Perlow, Jason" <jperlow@gmail.com>, Aditya Garg <aditya.garg@linux.dev>,
 dwmw2@infradead.org
Cc: iommu@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
 linux-pci@vger.kernel.org, arend.vanspriel@broadcom.com,
 linux-wireless@vger.kernel.org
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 22:40, Perlow, Jason wrote:
> Hardware: Intel CoffeeLake-H platforms, various. The affected device is 
> a Broadcom BCM4364 802.11ac PCIe wifi adapter (14e4:4464) at 
> 0000:05:00.0 on an Apple MacBookPro16,1 (T2 Mac). Aditya, including you 
> directly since this is T2 hardware; copying iommu/pci/wireless because 
> the fault signature and the fact that it reproduces on only one of five 
> tested machines looks like it needs eyes on the core IOMMU/PCI path, not 
> the driver.
> 
> SYMPTOM
> 
> Between a locally-built v7.3-rc7 kernel and a v7.3 final kernel 
> (same .config template, same patch series beyond one T2-specific AER 
> quirk that is upstream in final and therefore held out of our patch 
> set), the BCM4364 wifi firmware on ONE affected unit crash-loops 
> continuously:
> 
> brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4364b3-pcie for 
> chip BCM4364/4
> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4364/4 wl0: ...
> ieee80211 phy0: brcmf_fw_crashed: Firmware has halted or crashed
> 
> repeating every ~6s, indefinitely. dmesg shows the actual mechanism -- a 
> real IOMMU DMAR page fault on the wifi device, timed to the same cadence 
> as the firmware crash:
> 
> DMAR: DRHD: handling fault status reg 3
> DMAR: [DMA Read NO_PASID] Request device [0000:05:00.0] fault addr 
> 0xffeff000 [fault reason 0x06] PTE Read access is not set
> 
> Four such faults logged at uptime 13.4s/19.4s/25.3s/31.2s, each 
> immediately followed by a brcmf_fw_crashed event. intel_iommu=off 
> removes the fault and the crash entirely (8+ minutes stable, single 
> clean firmware load, stable AP association). The prior v7.3-rc7 kernel 
> on the SAME unit has zero DMAR faults and zero firmware crashes with 
> IOMMU on by default, so this is a regression introduced somewhere in the 
> rc7->final window on this unit, not a long-standing issue.

Can you confirm that the IOMMU is actually enabled and translating on
the rc7 boot? Please check that boot's kernel log for:

DMAR: IOMMU enabled
iommu: Default domain type: Translated

> 
> REPRODUCES ON 1 OF 5 MACHINES TESTED
> 
> We ran the identical kernel build (and, where applicable, the identical 
> firmware blob) across five machines and only one faults:
> 
> * Affected unit (MacBookPro16,1, T2, BCM4364 wifi): faults as above.
> * Second MacBookPro16,1 (same generation, different configuration within 
> the 16,1 line -- we have not enumerated every hardware delta): same 
> kernel binary, same firmware blob, IOMMU also active by default (iommu: 
> Default domain type: Translated, identical to the affected unit) -- zero 
> DMAR faults, brcmfmac stable.
> * Three non-Mac x86_64 machines spanning three more wifi vendors (Intel 
> iwlwifi AX201, Intel iwlwifi Centrino 2230, Realtek rtw89 8852BE) -- 
> IOMMU active and translating on all three, zero DMAR faults, all three 
> wifi chips loaded firmware and ran cleanly.
> 
> So across four different wifi silicon vendors and five physical 
> machines, IOMMU is actively translating DMA on every one of them and 
> only the single affected unit faults. This looks like a host-specific or 
> hardware-configuration-specific trigger rather than a blanket rc7->final 
> regression that would hit every machine with this kernel. We do not yet 
> know what distinguishes the affected unit (ACPI RMRR table contents, 
> exact PCIe link training time, and IOMMU group/domain-attach ordering 
> are the candidates we have not yet isolated).
> 
> WHAT WE RULED OUT BEFORE WRITING IN
> 
> * AER/ANFE quirk on the T2 Secure Enclave device: its PCI ID match is 
> exact (Apple SEP, 106b:1802) and does not touch the wifi device 
> (14e4:4464); real PCI topology on the affected unit also shows SEP and 
> wifi on separate root ports (00:1b.0 -> [04] vs 00:1c.0 -> [05] off the 
> PCH), so there's no shared-root-port mechanism either.
> * brcmfmac driver source: git diff v7.3-rc7..v7.3 -- drivers/net/ 
> wireless/broadcom/brcm80211/ is empty.
> * Our own config template: byte-identical between the rc7 and final builds.
> * The upstream Kconfig stanza for INTEL_IOMMU_DEFAULT_ON (drivers/iommu/ 
> intel/Kconfig): byte-identical text between v7.3-rc7 and v7.3 (default 
> y, no depends on).
> 
> THE ONE ANOMALY WE CAN'T YET EXPLAIN
> 
> Despite the last two items above being unchanged, the actual 
> generated .config has CONFIG_INTEL_IOMMU_DEFAULT_ON unset after make 
> olddefconfig against the rc7 source tree, but =y after the same process 
> against the final source tree, even though our template explicitly 
> answers "# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set" in both cases. Our

If CONFIG_INTEL_IOMMU_DEFAULT_ON was not set in your rc7 build, and
intel_iommu=on was not on the command line, the Intel IOMMU was
disabled by default on rc7. In that case, rc7 could never report a
DMAR fault, and the "regression" is only that v7.3 final enabled the
IOMMU.

Could you boot the rc7 kernel on the affected unit with intel_iommu=on
and see whether the same fault shows up? If it does, there is no
rc7->final regression in the IOMMU code. It would be an existing DMA
issue with brcmfmac/BCM4364.

> working theory is that some other symbol started selecting/implying 
> INTEL_IOMMU_DEFAULT_ON between rc7 and final -- which would override an 
> explicitly-seeded "not set" answer during olddefconfig resolution -- but 
> we have not identified which one. Happy to bisect further, or provide 
> the full .config / additional dmesg, if that would help narrow it.
> 
> CURRENT STATUS
> 
> intel_iommu=off on the affected unit's kernel command line is our 
> accepted fix for this specific machine while the root cause is 
> unresolved; we are not disabling IOMMU fleet-wide, since four of the 
> five test machines show no problem with it on. Posting here in case this 
> fault signature is recognized, or in case others on different T2 or non- 
> T2 hardware see the same thing on v7.3 final.

Thanks,
baolu
