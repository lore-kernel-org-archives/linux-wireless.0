Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792507582;
	b=tI97tIuAGtyXfMZ/KpAROqsUFOgnEni8MtOycSgjX6T9RoyaNZqZsY2oonsk/JLmAP1H
	 Ch37pAku+ARqmZX6f2IOiPrWduy9eGdlsmG8DQjZwpuW5YwFgXeyvDC77LWIh8GI5wabq
	 zVCFjGmz5/yq7Vq75kC4wpKy2LkteFKa4kdjT5vLHD/CJmWXzhpvcoV8+r0tBOdisge7/
	 GVo2r4ubCVI0FEBLIglOBedzxAsRQWHPYaTwzKz8EyUXfM9A+bYfLD1M3lLFA3FXPMnwV
	 Ka0geMwNcuBqzn2YD8O9bZdDgXt9mwaFU1vwBK8kQg8knDT7I3sbLDe5cvHnY4nr6Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792507582;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:User-Agent:
	 In-Reply-To:References:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=a/YVQ5+8FFxd+OKTrecEbQdO7nAgyOE7j7VKGjXUilE=;
	b=mEWe+cMuLYFP8flt/KTv6VX1JT2Ck5y3DcYlbdD7GEqTU03mkj/dZNZuM+WOC89sX8GA
	 O2qjgQLYvLTFYz9K/EmF2rxXMhHCPvlN9k//JMAh/q7LoirG2f8EW64eud1H7WqoG/eof
	 74UfgH66xfzI45McHp0ScAf85MrSEZYKlXT0Fvg+M/X95qJqIaRg0GyKuoND4H4qXrKMZ
	 4cFZkc2OlzJEwpcWarRtw580fU//XGxfreYCrrGaDCJHdYN6dxWb1eMo00VrOh71KL4RF
	 bE9Y39Pf+i8Vc6IHGTOX0EAPYvkhVMpQy6c34HW/iPsRPRoSEjkFFBd0bROoDR+mu4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xWza2d9o;
	arc=none smtp.remote-ip=91.218.175.84
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E4B606A33A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 14:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27E4B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xWza2d9o
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=a/YVQ5+8FFxd+OKTrecEbQdO7nAgyOE7j7VKGjXUilE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792507579; v=1; x=1793112379;
 b=xWza2d9oFnCd/jCv9ucXVSp6/6inh8afcQ8jHXEwjregesNFevPradRPfAt3JMb2JKhrEbMr
 ieC5e3tLZ24Spfhkn1drCSjUqTpFUwEFAiNbWO0Cu/14Owq+0AtxDfffzeOad3sq0d3lhD36Qp0
 ASrMX1EyZXcF/SiTYiTz38Xg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f82142b7c0acb158;
	Tue, 20 Oct 2026 14:46:18 +0000
X-Mizu-Trace-ID: f82142b7c0acb158
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 20:16:11 +0530
From: Aditya Garg <aditya.garg@linux.dev>
To: "Perlow, Jason" <jperlow@gmail.com>, baolu.lu@linux.intel.com,
 dwmw2@infradead.org
CC: iommu@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
 linux-pci@vger.kernel.org, arend.vanspriel@broadcom.com,
 linux-wireless@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_intel-iommu=3A_DMAR_PTE_Read_fault?=
 =?US-ASCII?Q?_crash-loops_a_PCIe_wifi_device=2C_v7=2E?=
 =?US-ASCII?Q?3-rc7_-=3E_v7=2E3_final_regression=2C_repr?=
 =?US-ASCII?Q?oduces_on_one_unit_out_of_five_tested?=
User-Agent: Thunderbird for Android
In-Reply-To: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com>
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com>
Message-ID: <53BF6325-C030-4280-B21F-4B6C0FF941B0@linux.dev>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 20 October 2026 8:10:21=E2=80=AFpm IST, "Perlow, Jason" <jperlow@gmail=
=2Ecom> wrote:
>Hardware: Intel CoffeeLake-H platforms, various=2E The affected device is=
 a
>Broadcom BCM4364 802=2E11ac PCIe wifi adapter (14e4:4464) at 0000:05:00=
=2E0 on
>an Apple MacBookPro16,1 (T2 Mac)=2E Aditya, including you directly since =
this
>is T2 hardware; copying iommu/pci/wireless because the fault signature an=
d
>the fact that it reproduces on only one of five tested machines looks lik=
e
>it needs eyes on the core IOMMU/PCI path, not the driver=2E

Nice that's the third bug report of this issue today:

1=2E https://www=2Email-archive=2Ecom/ubuntu-bugs@lists=2Eubuntu=2Ecom/msg=
6317918=2Ehtml

2=2E https://lore=2Ekernel=2Eorg/lkml/CA+3E58-2N-uVNsmwvOGDKZvtnDQ1DF=3DGz=
FbTyRLuN8FpAd4qdg@mail=2Egmail=2Ecom/

>
>SYMPTOM
>
>Between a locally-built v7=2E3-rc7 kernel and a v7=2E3 final kernel (same
>=2Econfig template, same patch series beyond one T2-specific AER quirk th=
at
>is upstream in final and therefore held out of our patch set), the BCM436=
4
>wifi firmware on ONE affected unit crash-loops continuously:
>
>brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4364b3-pcie for chip
>BCM4364/4
>brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4364/4 wl0: =2E=2E=2E
>ieee80211 phy0: brcmf_fw_crashed: Firmware has halted or crashed
>
>repeating every ~6s, indefinitely=2E dmesg shows the actual mechanism -- =
a
>real IOMMU DMAR page fault on the wifi device, timed to the same cadence =
as
>the firmware crash:
>
>DMAR: DRHD: handling fault status reg 3
>DMAR: [DMA Read NO_PASID] Request device [0000:05:00=2E0] fault addr
>0xffeff000 [fault reason 0x06] PTE Read access is not set
>
>Four such faults logged at uptime 13=2E4s/19=2E4s/25=2E3s/31=2E2s, each i=
mmediately
>followed by a brcmf_fw_crashed event=2E intel_iommu=3Doff removes the fau=
lt and
>the crash entirely (8+ minutes stable, single clean firmware load, stable
>AP association)=2E The prior v7=2E3-rc7 kernel on the SAME unit has zero =
DMAR
>faults and zero firmware crashes with IOMMU on by default, so this is a
>regression introduced somewhere in the rc7->final window on this unit, no=
t
>a long-standing issue=2E
>
>REPRODUCES ON 1 OF 5 MACHINES TESTED
>
>We ran the identical kernel build (and, where applicable, the identical
>firmware blob) across five machines and only one faults:
>
>* Affected unit (MacBookPro16,1, T2, BCM4364 wifi): faults as above=2E
>* Second MacBookPro16,1 (same generation, different configuration within
>the 16,1 line -- we have not enumerated every hardware delta): same kerne=
l
>binary, same firmware blob, IOMMU also active by default (iommu: Default
>domain type: Translated, identical to the affected unit) -- zero DMAR
>faults, brcmfmac stable=2E
>* Three non-Mac x86_64 machines spanning three more wifi vendors (Intel
>iwlwifi AX201, Intel iwlwifi Centrino 2230, Realtek rtw89 8852BE) -- IOMM=
U
>active and translating on all three, zero DMAR faults, all three wifi chi=
ps
>loaded firmware and ran cleanly=2E
>
>So across four different wifi silicon vendors and five physical machines,
>IOMMU is actively translating DMA on every one of them and only the singl=
e
>affected unit faults=2E This looks like a host-specific or
>hardware-configuration-specific trigger rather than a blanket rc7->final
>regression that would hit every machine with this kernel=2E We do not yet
>know what distinguishes the affected unit (ACPI RMRR table contents, exac=
t
>PCIe link training time, and IOMMU group/domain-attach ordering are the
>candidates we have not yet isolated)=2E
>
>WHAT WE RULED OUT BEFORE WRITING IN
>
>* AER/ANFE quirk on the T2 Secure Enclave device: its PCI ID match is exa=
ct
>(Apple SEP, 106b:1802) and does not touch the wifi device (14e4:4464); re=
al
>PCI topology on the affected unit also shows SEP and wifi on separate roo=
t
>ports (00:1b=2E0 -> [04] vs 00:1c=2E0 -> [05] off the PCH), so there's no
>shared-root-port mechanism either=2E
>* brcmfmac driver source: git diff v7=2E3-rc7=2E=2Ev7=2E3 --
>drivers/net/wireless/broadcom/brcm80211/ is empty=2E
>* Our own config template: byte-identical between the rc7 and final build=
s=2E
>* The upstream Kconfig stanza for INTEL_IOMMU_DEFAULT_ON
>(drivers/iommu/intel/Kconfig): byte-identical text between v7=2E3-rc7 and
>v7=2E3 (default y, no depends on)=2E
>
>THE ONE ANOMALY WE CAN'T YET EXPLAIN
>
>Despite the last two items above being unchanged, the actual generated
>=2Econfig has CONFIG_INTEL_IOMMU_DEFAULT_ON unset after make olddefconfig
>against the rc7 source tree, but =3Dy after the same process against the
>final source tree, even though our template explicitly answers "#
>CONFIG_INTEL_IOMMU_DEFAULT_ON is not set" in both cases=2E Our working th=
eory
>is that some other symbol started selecting/implying INTEL_IOMMU_DEFAULT_=
ON
>between rc7 and final -- which would override an explicitly-seeded "not
>set" answer during olddefconfig resolution -- but we have not identified
>which one=2E Happy to bisect further, or provide the full =2Econfig /
>additional dmesg, if that would help narrow it=2E
>
>CURRENT STATUS
>
>intel_iommu=3Doff on the affected unit's kernel command line is our accep=
ted
>fix for this specific machine while the root cause is unresolved; we are
>not disabling IOMMU fleet-wide, since four of the five test machines show
>no problem with it on=2E Posting here in case this fault signature is
>recognized, or in case others on different T2 or non-T2 hardware see the
>same thing on v7=2E3 final=2E
