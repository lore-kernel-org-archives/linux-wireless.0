Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792568036;
	b=JdFni/aupEZM1EPq5Jvt252yh+G84NjesFsHYxstkXtTb/RhrfglYxkecLeZ62yWkRIA
	 yGfC/yopVobjxu90upD9EvJ/jy79oKNTjarqd1XMHEKyr7ZTCv1Jm4S8/aN4jW7QB8vQ4
	 cbtWOEN+zTjgeO+3UDMrl0oPaLLzl3x4gf0/zEq9T4ZRntVGSK67RpqYuMO+FLaT5FlLx
	 jgbSUJbr19bR5d5mdPzoYJSbLef++bwmGXAtoiq2k+95QahvaKK90E5qOPvoESRUhOazN
	 EF5ughm1KR7R9N2xgBsFyfOYQL4gXt8zRYXTGy91AVgRCOUm6sQlD1ufjgX2V6WiVHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792568036;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:CC:Subject:User-Agent:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=S/WUWG78WudYvh8ovm7Px4vUVyJzHUUoo0t8APESyAg=;
	b=ws+kC5xGJa4QlITkTLjzMZa9OZdJ/lEajc1HSnP7Ix5XGFntVDk/yemAraBIihgwV7kf
	 gLBK2IPbQEPHcOtKldESVoGdOIl4cOnpzhS3/iWaUnTHyLYmCu8GN3NiawhDpiAeDoeil
	 uvLa3zJS+dB21xm+RREK7iOLLykFFrdZKL8PiI/EaYexHcGHPvahIHxXdG1Z6d5kmgy5p
	 ymwyloKe34whiiM9KCwnbsYSfGSlYPx8e+0r+FF+dcXqq/joyjSDG7DnhdwNBWgKGMsmZ
	 iXZaXYFafCR0ff/BkqyRxz5gVGrvcQoN4lu6fUbkSsYBFbx1oc/74CJaTrIqk2V/XMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ofIySrqr;
	arc=none smtp.remote-ip=209.85.128.176
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33253606A31C
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 07:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33253606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ofIySrqr
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b06c0794cfso4531537b3.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 00:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792568035; x=1793172835; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=S/WUWG78WudYvh8ovm7Px4vUVyJzHUUoo0t8APESyAg=;
        b=ofIySrqrCtqqd8aOQOd99xJJ48UPJjT1bck9w1eOJsEE9D4DLiCp/1reEdCW09OZ9J
         cNeOA7uACcrUNq6zB2EscWL5WNRsz65m1ezX7aEKtr5A+RbSk3ailohV7lxqP165nrQj
         ohQZQJpbif6C2kvnxt1f1ApAhsJDfVL0u+yF7lwrUpRDno8qBB/GKfqrmVHW1zyeaGHH
         VJvpj0sWbqLzlxPv1yssMiJqmvbYHoyBJL+mGmFxmRdfP5Ql9Yg1oqu9VcX88bwPI3QV
         0JYHk0LRZ0jwYkmVGbhvv7ZXduSq0I1G7A6hSHh/crWkKvhaFR2KiPalLx2oILV+UaYu
         ew/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792568035; x=1793172835;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S/WUWG78WudYvh8ovm7Px4vUVyJzHUUoo0t8APESyAg=;
        b=EadPpomIuXhZWHqSdpI0YnEUmapRghuQvovgoQ3j3AeP3C8Rkb6MPvsfEwcXQ6bYU6
         TIgT2XU6w949fyJYO0NAa1lTq3mkm0XCl2Nn8TKQzEZRj+JuYRKQqgKjkwIXAbt3w396
         qyjpP/6OCTwEsTt05HAeh6a2zfIvQZ93c5LprPDT7H0nYcgLGZehZKsN5av6kdBxtTf2
         tp2dKxoOxdjnjn0zGECTATpl2TMnH8H+4VZPYFk97xftECZqkcn4rwnwMxyupFBfKRJQ
         p5PMWbTpq/8njWx/mx7y9E7Dk9QkFFpUgUREQoUmY+okkGEBXCjhzdR9XSrBrWofbXlJ
         ZOFA==
X-Forwarded-Encrypted: i=1; AKwUvBzH2h+yrELVthD5QWm3N+zZSsTsN6RmmSXuUAfJDEVb5QPRKnQ5gEhL0ZKbWnhkk8wB8Dmt32x1y1F0SNMPQg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKHIbAhJeB/RU6WRTECSphE0q3bpfWJWTUwDEPfNjRKi5F5sRfF
	zj2+E67UvGiIHhKcz/E4PIKDA5A4N0I0ggbbMa/JNgmOLFjMKXe2Or+8
X-Gm-Gg: AYBFou0v/iJmk5RhzvjGJu1AD7C8MWIpmXZWnu4cC/0Jr+uHVHs5oBk+CnmkL3QepfM
	qt490a6W6LvrJvGIv8hyiZlc7fUg5J+I60NNgjvm0kWEC0Ex8KiM8xUTik3XNW2V48XfmbmpVCj
	r9q1lbHB3QdVYNbhw2Hx186ObKX+r0WfPotQmyFaJMOZ0hbShCzTaxjIc5j+iBEwn67fnkm/TJU
	ELo9DCI+K4l5HBmkiRJcM+QmaRk6TA3q/sXmfjWQyFA1k4CZoVBNK0Kaxeu+sBuNPdNJ5ezdxq1
	sHrBu3ZBpMWAgAB3ayuggNb0DBSWBKh84k2vvhEKLlFDUIU2itpNN2kgnPT2pwNJSfffOwef9VA
	pYviisqCzz1OPXOI8iQABEKQtLaQ1WJ4cTSmRAXsyUpc/rhsg/j0dHQe+hCNyS9TkdCNdRSXXB6
	qZEvMrvAVzdLkIOY4LdG0bicq9P6/zym4jJfP4m3DhtP8D6MeLsUZZw2mOUWPvAV8ILonimaEiO
	nudnvq2SsvSclBt5O/Ve49H0dHuTwltEbCGmxOb//PklM87hFOxwu5gskR7zgmqJwBjwm3HjHPT
	6Fl2M3ut5MMbmlOAUHH7H7/CEcfMS9Y63UUY51c+Gsrw93eEW+EzEbKlytOfXbA4mclpyKF2TfF
	IHWvnIjbNVmyX+gkwIZ588VB00yVyDTmVBVC5ks0SG5s6Uo6fSy2CE54nrgUnoXw=
X-Received: by 2002:a05:690c:698a:b0:8b0:9e27:fcd0 with SMTP id 00721157ae682-8b133caac65mr6808817b3.21.1792568035078;
        Wed, 21 Oct 2026 00:33:55 -0700 (PDT)
Received: from ehlo.thunderbird.net (212.153.88.200.l.sta.codetel.net.do. [200.88.153.212])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300715cfsm7838277b3.14.2026.10.21.00.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 00:33:53 -0700 (PDT)
Date: Wed, 21 Oct 2026 03:33:28 -0400
From: Jason Perlow <jperlow@gmail.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, Aditya Garg <aditya.garg@linux.dev>,
 dwmw2@infradead.org
CC: iommu@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
 linux-pci@vger.kernel.org, arend.vanspriel@broadcom.com,
 linux-wireless@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_intel-iommu=3A_DMAR_PTE_Read_fault?=
 =?US-ASCII?Q?_crash-loops_a_PCIe_wifi_device=2C_v7=2E?=
 =?US-ASCII?Q?3-rc7_-=3E_v7=2E3_final_regression=2C_repr?=
 =?US-ASCII?Q?oduces_on_one_unit_out_of_five_tested?=
User-Agent: Thunderbird for Android
In-Reply-To: <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com>
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com> <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com>
Message-ID: <74570358-8085-4767-BF76-D865CA95853E@gmail.com>
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

Yes, done=2E rc7 with intel_iommu=3Don on the same MacBookPro16,1 shows
the same fault: 95 DMAR faults, each followed by brcmf_fw_crashed, in
one boot=2E So no rc7 -> final regression in the IOMMU code=2E

It is a v7=2E2 -> v7=2E3-rc1 regression in brcmfmac, from f0ba5fd51ff2
("wifi: brcmfmac: Set DMA direction for msgbuf packet IDs")=2E RX
buffers are now mapped DMA_FROM_DEVICE (prot 0x6, no IOMMU_READ) and
the BCM4364 firmware reads them:

  36=2E512689 map   iova=3D0xffeff2c0 size=3D2048 prot=3D0x6 (brcmf_msgbuf=
_rxbuf_data_post)
  41=2E110125 DMAR: [DMA Read NO_PASID] Request device [0000:05:00=2E0] fa=
ult addr 0xffeff000 [fault reason 0x06] PTE Read access is not set
  41=2E139317 brcmf_fw_crashed: Firmware has halted or crashed

The fault comes before the crash=2E Before that commit the direction
stayed 0 (DMA_BIDIRECTIONAL)=2E=20

Thanks for the pointer=2E

On October 21, 2026 2:13:40 AM AST, Baolu Lu <baolu=2Elu@linux=2Eintel=2Ec=
om> wrote:
>On 10/20/26 22:40, Perlow, Jason wrote:
>> Hardware: Intel CoffeeLake-H platforms, various=2E The affected device =
is a Broadcom BCM4364 802=2E11ac PCIe wifi adapter (14e4:4464) at 0000:05:0=
0=2E0 on an Apple MacBookPro16,1 (T2 Mac)=2E Aditya, including you directly=
 since this is T2 hardware; copying iommu/pci/wireless because the fault si=
gnature and the fact that it reproduces on only one of five tested machines=
 looks like it needs eyes on the core IOMMU/PCI path, not the driver=2E
>>=20
>> SYMPTOM
>>=20
>> Between a locally-built v7=2E3-rc7 kernel and a v7=2E3 final kernel (sa=
me =2Econfig template, same patch series beyond one T2-specific AER quirk t=
hat is upstream in final and therefore held out of our patch set), the BCM4=
364 wifi firmware on ONE affected unit crash-loops continuously:
>>=20
>> brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4364b3-pcie for ch=
ip BCM4364/4
>> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4364/4 wl0: =2E=2E=2E
>> ieee80211 phy0: brcmf_fw_crashed: Firmware has halted or crashed
>>=20
>> repeating every ~6s, indefinitely=2E dmesg shows the actual mechanism -=
- a real IOMMU DMAR page fault on the wifi device, timed to the same cadenc=
e as the firmware crash:
>>=20
>> DMAR: DRHD: handling fault status reg 3
>> DMAR: [DMA Read NO_PASID] Request device [0000:05:00=2E0] fault addr 0x=
ffeff000 [fault reason 0x06] PTE Read access is not set
>>=20
>> Four such faults logged at uptime 13=2E4s/19=2E4s/25=2E3s/31=2E2s, each=
 immediately followed by a brcmf_fw_crashed event=2E intel_iommu=3Doff remo=
ves the fault and the crash entirely (8+ minutes stable, single clean firmw=
are load, stable AP association)=2E The prior v7=2E3-rc7 kernel on the SAME=
 unit has zero DMAR faults and zero firmware crashes with IOMMU on by defau=
lt, so this is a regression introduced somewhere in the rc7->final window o=
n this unit, not a long-standing issue=2E
>
>Can you confirm that the IOMMU is actually enabled and translating on
>the rc7 boot? Please check that boot's kernel log for:
>
>DMAR: IOMMU enabled
>iommu: Default domain type: Translated
>
>>=20
>> REPRODUCES ON 1 OF 5 MACHINES TESTED
>>=20
>> We ran the identical kernel build (and, where applicable, the identical=
 firmware blob) across five machines and only one faults:
>>=20
>> * Affected unit (MacBookPro16,1, T2, BCM4364 wifi): faults as above=2E
>> * Second MacBookPro16,1 (same generation, different configuration withi=
n the 16,1 line -- we have not enumerated every hardware delta): same kerne=
l binary, same firmware blob, IOMMU also active by default (iommu: Default =
domain type: Translated, identical to the affected unit) -- zero DMAR fault=
s, brcmfmac stable=2E
>> * Three non-Mac x86_64 machines spanning three more wifi vendors (Intel=
 iwlwifi AX201, Intel iwlwifi Centrino 2230, Realtek rtw89 8852BE) -- IOMMU=
 active and translating on all three, zero DMAR faults, all three wifi chip=
s loaded firmware and ran cleanly=2E
>>=20
>> So across four different wifi silicon vendors and five physical machine=
s, IOMMU is actively translating DMA on every one of them and only the sing=
le affected unit faults=2E This looks like a host-specific or hardware-conf=
iguration-specific trigger rather than a blanket rc7->final regression that=
 would hit every machine with this kernel=2E We do not yet know what distin=
guishes the affected unit (ACPI RMRR table contents, exact PCIe link traini=
ng time, and IOMMU group/domain-attach ordering are the candidates we have =
not yet isolated)=2E
>>=20
>> WHAT WE RULED OUT BEFORE WRITING IN
>>=20
>> * AER/ANFE quirk on the T2 Secure Enclave device: its PCI ID match is e=
xact (Apple SEP, 106b:1802) and does not touch the wifi device (14e4:4464);=
 real PCI topology on the affected unit also shows SEP and wifi on separate=
 root ports (00:1b=2E0 -> [04] vs 00:1c=2E0 -> [05] off the PCH), so there'=
s no shared-root-port mechanism either=2E
>> * brcmfmac driver source: git diff v7=2E3-rc7=2E=2Ev7=2E3 -- drivers/ne=
t/ wireless/broadcom/brcm80211/ is empty=2E
>> * Our own config template: byte-identical between the rc7 and final bui=
lds=2E
>> * The upstream Kconfig stanza for INTEL_IOMMU_DEFAULT_ON (drivers/iommu=
/ intel/Kconfig): byte-identical text between v7=2E3-rc7 and v7=2E3 (defaul=
t y, no depends on)=2E
>>=20
>> THE ONE ANOMALY WE CAN'T YET EXPLAIN
>>=20
>> Despite the last two items above being unchanged, the actual generated =
=2Econfig has CONFIG_INTEL_IOMMU_DEFAULT_ON unset after make olddefconfig a=
gainst the rc7 source tree, but =3Dy after the same process against the fin=
al source tree, even though our template explicitly answers "# CONFIG_INTEL=
_IOMMU_DEFAULT_ON is not set" in both cases=2E Our
>
>If CONFIG_INTEL_IOMMU_DEFAULT_ON was not set in your rc7 build, and
>intel_iommu=3Don was not on the command line, the Intel IOMMU was
>disabled by default on rc7=2E In that case, rc7 could never report a
>DMAR fault, and the "regression" is only that v7=2E3 final enabled the
>IOMMU=2E
>
>Could you boot the rc7 kernel on the affected unit with intel_iommu=3Don
>and see whether the same fault shows up? If it does, there is no
>rc7->final regression in the IOMMU code=2E It would be an existing DMA
>issue with brcmfmac/BCM4364=2E
>
>> working theory is that some other symbol started selecting/implying INT=
EL_IOMMU_DEFAULT_ON between rc7 and final -- which would override an explic=
itly-seeded "not set" answer during olddefconfig resolution -- but we have =
not identified which one=2E Happy to bisect further, or provide the full =
=2Econfig / additional dmesg, if that would help narrow it=2E
>>=20
>> CURRENT STATUS
>>=20
>> intel_iommu=3Doff on the affected unit's kernel command line is our acc=
epted fix for this specific machine while the root cause is unresolved; we =
are not disabling IOMMU fleet-wide, since four of the five test machines sh=
ow no problem with it on=2E Posting here in case this fault signature is re=
cognized, or in case others on different T2 or non- T2 hardware see the sam=
e thing on v7=2E3 final=2E
>
>Thanks,
>baolu
