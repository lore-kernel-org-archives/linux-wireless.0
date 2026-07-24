Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D580244163D;
	Fri, 24 Jul 2026 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906089; cv=none; b=lmQL2s/KhVFdPo0AxUP9zLTpbh5sgqbTjCDKTRjfQiCyQAdxa9xPvTmjwY+MpI/6+dcvxfs0XFJZP1M/okPaqCQ1PJpynxH3xUcrAS09oa7wSNVFFVkkA2cCMMH7QkvMi0+BDPms/E5XIy+VqS2QjKmBtxZ5G/iMQtcwAUp4rWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906089; c=relaxed/simple;
	bh=JdSyClpuJ8Rch/NR8MGVNW7c/VIqy3seqViQ9BpFdfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEj2eV42JIEkBbbjCjw+2j/mid2w1uAW6zEC2+05rQ4B3JEEx+hMFSKVUbQ64KOmvSxifuH0NOZDFHb+duPOJoY9/rn9tg3yuEnVJpghIWOS+CVfa4Xg5t3eqiYVxy9nj37vYy1PeabpIDMtzwHXj2/emdUhro8V/j/bo7/K8ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b=JZKtIBid; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b="JZKtIBid"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1784906061; x=1785510861; i=spasswolf@web.de;
	bh=m8CpHjTwlWzbdvJf4ktY9WwzJkRyzi7WFbcKxGcO7XI=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JZKtIBidvzT3MGUfrPGiOF6RFeDUmqJOmFraw2CG8INY4gr/ipWhyJKZ/fk4m321
	 Ku372TncQbf5dyepkt1IzXMQdpqSIn0evBOyvKArL2E+zBYUqLlCrPeC8UXe3XXQg
	 ZFdqi4upkkJFDEZZ8VNSUIVHlu61fz98jQu/gs2UyirZvPspG1K+j7jBrCFEd68gY
	 XThq4XXKm6PUHHHt54ptoHR0rC3bEv0Y0fWv9Zvha5qp1uId2G9WBPONNW4FWdxyV
	 f5F9DkJ4Q5rAbluR422QmVEDF73FFR9H8sgRjfAY7qOA3gDpKifZYJwrAu4LuB5gk
	 aqlnYvtYLK4Wq6J2dw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M8Bw1-1wqsNK1lxL-00Ft7E; Fri, 24
 Jul 2026 17:14:21 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Cc: Bert Karwatzki <spasswolf@web.de>,
	linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	ryder.lee@mediatek.com,
	lorenzo@kernel.org,
	legale.legale@gmail.com,
	sean.wang@mediatek.com,
	shayne.chen@mediatek.com
Subject: hang during shutdown in next-20260722+ with MT7925
Date: Fri, 24 Jul 2026 17:14:17 +0200
Message-ID: <20260724151419.26014-1-spasswolf@web.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708144615.24092-1-nicolas.cavallari@green-communications.fr>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:L0o6vs2M3X+OfLlySQDCjUl8hA/JMhBiDPdXPHWIdNQY9PJ6g7N
 k2Y4JPIcnqvB1GN9nfHYKQxyYe1SSPaos8h/H/Xa9bkGjyj2HEsKhjQbkQz8sWKB/+Qw3p8
 ucW0OYcoN31GsgTJImNRyHOXU8wOJygTUVAZ2GcFmsZ0RarMLi9O1m3w/uMnRxXLbpnWpG8
 7ACj+xStBVwGSj9Hymb2Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jwnulZxzJ48=;zn2kulkkuNngZQfPZt3beLnaYzW
 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
 jhTE3LUv0=

Since next-20260722 my debian sid system hangs when shutting down or
rebooting (No error message when monitoring the shutdown process via
netconsole). I bisected the error to commit
13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
and reverting this commit in next-20260723 makes shutting down or
rebooting work normally again.

Wifi device:
09:00.0 Network controller [0280]: MEDIATEK Corp. MT7925 802.11be 160MHz 2x=
2 PCIe Wireless Network Adapter [Filogic 360] [14c3:7925]

Cpu:
$ cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 26
model		: 68
model name	: AMD Ryzen 9 9950X 16-Core Processor
stepping	: 0
microcode	: 0xb404035
cpu MHz		: 624.194
cache size	: 1024 KB
physical id	: 0
siblings	: 32
core id		: 0
cpu cores	: 16
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 16
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtsc=
p lm constant_tsc rep_good amd_lbr_v2 nopl xtopology nonstop_tsc cpuid extd=
_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 =
movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_l=
egacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext p=
erfctr_core perfctr_nb bpext perfctr_llc mwaitx cpuid_fault cpb cat_l3 cdp_=
l3 hw_pstate ssbd mba perfmon_v2 ibrs ibpb stibp ibrs_enhanced vmmcall fsgs=
base tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a avx512f avx512dq=
 rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw avx512=
vl xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_m=
bm_local user_shstk avx_vnni avx512_bf16 clzero irperf xsaveerptr rdpru wbn=
oinvd cppc arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasi=
d decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif x2avic v_=
spec_ctrl vnmi avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq =
avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid bus_lock_detect movdiri mo=
vdir64b overflow_recov succor smca fsrm avx512_vp2intersect flush_l1d amd_l=
br_pmc_freeze
bugs		: sysret_ss_attrs spectre_v1 spectre_v2 spec_store_bypass srso spectr=
e_v2_user vmscape
bogomips	: 8599.52
TLB size	: 192 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate cpb eff_freq_ro [13] [14]

Other pci hardware:
$ lspci
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Root Complex
00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridge IOM=
MU
00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e GPP Bridge
00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e GPP Bridge
00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:02.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e GPP Bridge
00:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Dummy Host Bridge
00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e Internal GPP Bridge to Bus [C:A]
00:08.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Ridg=
e Internal GPP Bridge to Bus [C:A]
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev=
 71)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev =
51)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 0
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 1
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 2
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 3
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 4
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 5
00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 6
00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Raphael/Granite Rid=
ge Data Fabric; Function 7
01:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Upstr=
eam Port of PCI Express Switch (rev 25)
02:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Downs=
tream Port of PCI Express Switch (rev 25)
03:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] N=
avi 44 [Radeon RX 9060 XT] (rev c0)
03:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Navi 48 HDMI/D=
P Audio Controller
04:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD=
 9100 PRO [PM9E1]
05:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Upstream Port (rev 01)
06:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:08.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:0c.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
06:0d.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] 600 Series Chipset P=
CIe Switch Downstream Port (rev 01)
08:00.0 Ethernet controller: Intel Corporation Ethernet Controller I226-V (=
rev 06)
09:00.0 Network controller: MEDIATEK Corp. MT7925 802.11be 160MHz 2x2 PCIe =
Wireless Network Adapter [Filogic 360]
0b:00.0 USB controller: Advanced Micro Devices, Inc. [AMD] 800 Series Chips=
et USB 3.x XHCI Controller (rev 01)
0c:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD] 600 Series Chip=
set SATA Controller (rev 01)
0d:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. =
[AMD] Raphael/Granite Ridge PCIe Dummy Function (rev c1)
0d:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 19=
h PSP/CCP
0d:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Raphael/Granite =
Ridge USB 3.1 xHCI
0d:00.4 USB controller: Advanced Micro Devices, Inc. [AMD] Raphael/Granite =
Ridge USB 3.1 xHCI
0e:00.0 USB controller: Advanced Micro Devices, Inc. [AMD] Raphael/Granite =
Ridge USB 2.0 xHCI


Bert Karwatzki
