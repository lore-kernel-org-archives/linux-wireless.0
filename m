Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.134
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792498145;
	b=HDEXDTqY+xcgwSydf6vbL6qlVuQ/IHSmVTPlhZl1tJ1qpIIEsvF79jNGbMMyEedEU9bk
	 Mq6Jl53nSzldT3ac38UtsnaBiyBv0jRv5mn9RFlAqZQIIRdGhzsuXDhu12g427FgGrmsk
	 +DMdI+BZYDq6tryzndnX+WdGY1Tzl162GQ4agrOsF8C1T1AkOnakLxyIIdnVViOYHwdDN
	 p6NcXqPMzugH3AMFPU2W6SUyVfZrjTaKPOGlx6Ku9zrgaco1ox3phJqMUYAMoiqgHEt4i
	 yJRH+ALn2T3/PblDZmsqmRZkCq2uK8WWD7e4lwhY5gT6AOOgtAmYw763eBeeRMgDtRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792498145;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=2oAYJPU4rS/B67nm2olDeHtopzXuD57QG29t513sHn8=;
	b=OxaUG6HjF8rjaX9ccw4WPybGi3pKaP7EW8oke/0svznSzLk52xbBoUue0Qc85QOLSruX
	 Ji6coAY0d9kLpi5PFiYpWrPciWkxu9C90deH8UtZlX9+ZTAt3Giyylt0VuZVBRgvu7YPF
	 xFp671wD8ipY5NWDMj6TGiHaDIvNKQKeMjuYX+3BGhsN4kkKTc1wZDQboenxUgjz/M9Pa
	 DcZia1YvdhIdITEpLdJ2w8xztnvWHGIoZ46jRT/SgdAM3JGaLmy4jjKcB0Pkp3rHK6GYF
	 M+mcER5/70BCqBhnb97+SbZvGMKju49+JiYC1rGlSb7apwPoTnsU80DdJly+s+jEmfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M+7uNKlk;
	arc=none smtp.remote-ip=91.218.175.134
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE2E606A325
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 12:08:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACE2E606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M+7uNKlk
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NHvbn3ue2nkgb328laFkEqNkxDgGzunCyN1UR3R7YQU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792498137; v=1; x=1793102937;
 b=M+7uNKlkKoX7RObvP2s1ErlPC3SXJKgoI5mhc+dVsQucAfnZ7p0hFStgvI4PQIG0zg3ZaXUJ
 mnf2X2kVupOb9V5zUa0nZC46vyb/7n54WVky3aeQSTtu0UMUQLejzv/ERU35Fl4klH53WoIYL/C
 zkOYUg95KIvHCfrKDWXCYd60=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cac925beb0231a6d;
	Tue, 20 Oct 2026 12:08:57 +0000
X-Mizu-Trace-ID: cac925beb0231a6d
X-Migadu-Flow: FLOW_OUT
Message-ID: <b75feca5-6025-44ff-8b82-b1da48cc5ced@linux.dev>
Date: Tue, 20 Oct 2026 17:38:44 +0530
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
Subject: Re: [REGRESSION] BCM4355 Wi-Fi fails with Intel IOMMU on
 7.3.0-2-t2-noble
To: Peter Kiddier <peter@kiddier.org>, linux-wireless@vger.kernel.org
Cc: brcm80211@lists.linux.dev, iommu@lists.linux.dev,
 arend.vanspriel@broadcom.com, regressions@lists.linux.dev, jgg@nvidia.com,
 kevin.tian@intel.com, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
 linux-kernel@vger.kernel.org
References: <CA+3E589O46nj=c1Y+Rwk_nPZZKEUjFvMfWaAFmQ2-7De9iUxFw@mail.gmail.com>
 <CA+3E58-2N-uVNsmwvOGDKZvtnDQ1DF=GzFbTyRLuN8FpAd4qdg@mail.gmail.com>
Content-Language: en-US
From: Aditya Garg <aditya.garg@linux.dev>
In-Reply-To: <CA+3E58-2N-uVNsmwvOGDKZvtnDQ1DF=GzFbTyRLuN8FpAd4qdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 20/10/26 5:19 pm, Peter Kiddier wrote:
> Adding the IOMMU maintainers and linux-kernel.
> 
> The original report and test results are below for context.
> 
> I haven't tested a vanilla upstream kernel, and may have limited time
> for further testing, but wanted to share the findings in case they're
> useful.
> 
> Thank you.

https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/info.html

Similar issue is present in older non T2 Macs, so definitely not a T2 patches issue. Also, T2 patches do not touch IOMMU or brcmfmac

> 
> 
> On Tue, 20 Oct 2026 at 22:32, Peter Kiddier <peter@kiddier.org> wrote:
>>
>> Hello,
>>
>> I am reporting a Wi-Fi regression on a 2018 Apple MacBook Air with a
>> T2 chip, running Linux Mint Zena based on Ubuntu 24.04.
>>
>> The Broadcom BCM4355 Wi-Fi device works with kernel 7.2.11-3-t2-noble
>> but fails with 7.3.0-2-t2-noble. Disabling the Intel IOMMU using
>> intel_iommu=off restores Wi-Fi on 7.3.0-2.
>>
>> Hardware:
>> - Apple MacBook Air 2018 (MacBookAir8,1)
>> - Wi-Fi: Broadcom BCM4355 802.11ac Wireless LAN SoC
>> - PCI ID: 14e4:43dc (subsystem 106b:0843)
>> - Driver: brcmfmac
>> - Interface: wlp2s0
>>
>> Test results:
>>
>> - 7.2.11-3-t2-noble, default kernel command line: Wi-Fi works.
>> - 7.3.0-2-t2-noble, default kernel command line: Wi-Fi fails.
>> - 7.3.0-2-t2-noble with intel_iommu=off: Wi-Fi works.
>> - Reloading brcmfmac on the failing configuration does not restore Wi-Fi.
>>
>> On the failing 7.3.0-2 boot, the driver detects the device, loads its
>> firmware and creates wlp2s0:
>>
>> brcmfmac 0000:02:00.0: enabling device (0000 -> 0002)
>> brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4355c1-pcie for
>> chip BCM4355/12
>> brcmfmac: brcmf_c_process_txcap_blob: TxCap blob found, loading
>> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4355/12 wl0: Jul  8 2023
>> 17:49:51 version 9.30.503.0.32.5.87 FWID 01-e74b9cb0
>> brcmfmac 0000:02:00.0 wlp2s0: renamed from wlan0
>>
>> However, Wi-Fi subsequently stops responding. The kernel log reports
>> errors including:
>>
>> brcmf_msgbuf_query_dcmd: Timeout on response for query command
>> brcmf_cfg80211_scan: scan error (-5)
>> brcmf_run_escan: error (-5)
>> brcmf_msgbuf_tx_ioctl: Failed to reserve space in commonring
>> brcmf_cfg80211_get_channel: chanspec failed (-5)
>>
>> There is also an error creating the P2P interface:
>>
>> brcmf_cfg80211_add_iface: add iface p2p-dev-wlp2s0 type 10 failed: err=-52
>>
>> I tried reloading the driver using:
>>
>> sudo modprobe -r brcmfmac_wcc
>> sudo modprobe -r brcmfmac
>> sudo modprobe brcmfmac
>>
>> The driver and firmware loaded again, but Wi-Fi remained unusable.
>>
>> The firmware files are present under /lib/firmware/brcm/, and the
>> firmware version reported by the driver is the same on the working and
>> failing kernels.
>>
>> The brcmfmac module metadata differs between the kernels:
>>
>> Working kernel 7.2.11-3-t2-noble:
>> srcversion: 3B6176FDB720DDE8E7C596B
>>
>> Failing kernel 7.3.0-2-t2-noble:
>> srcversion: 3DCA38D52402541701276CF
>>
>> I did not find obvious PCIe AER or fatal errors in the failing boot's
>> kernel log.
>>
>> It has been suggested testing intel_iommu=off after reloading
>> brcmfmac. The driver reload did not help, but booting with
>> intel_iommu=off restored Wi-Fi.
>>
>> This strongly suggests an interaction between Intel IOMMU handling and
>> the BCM4355/brcmfmac driver in the 7.3.0-2-t2-noble kernel.
>>
>> I have not tested a vanilla upstream kernel, so I cannot yet confirm
>> whether this reproduces outside the T2 kernel packages. Unfortunately,
>> I have limited time available for further testing, so I may not be
>> able to investigate additional requests promptly. I wanted to report
>> the reproducible behaviour and the intel_iommu=off workaround in case
>> it helps identify the regression.
>>
>> Could you advise on further diagnostics, or whether this should be
>> investigated as an IOMMU or brcmfmac regression?
>>
>> Thank you.

