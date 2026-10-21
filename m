Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792562279;
	b=hgUXo5srvRQAZAq5doJ2FleCYhjJCoMHqxiJOUHrCEH4LXFNpAU5+UFGYH0qdxHkKHTc
	 18Tgxm7J3qxeoOlgoKSMRhZ9xw4+TlyvK9DXA85i/dFtcXMEaT5rnCKM7FA+t/2g8nwwR
	 3RhRPa64GYJSUGFaV/k0RHVok0mRwKx1B83DxbppOtu4K+1wTNb3ZWT5HmGKG3KAssbDM
	 oZELp41QBMM7X01UbiqX03xbYLeUwg8av+1seDaxSQP2Gh6vnQfdRlpHemlC7GfOHjdca
	 AQ44GlvXuUF6+IPa3PlzYoL6NnLGWoOKZE6g05rxoAbvHNmYO4nEmtqzI2zxK+WU8HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562279;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=G8dYOpxn7MC+ZuaGnfx+ivHYE4BwvuIFkRKXEM8ocss=;
	b=Az8MXIkf2PDVMcKVXSD1Nsi+dV+beE8dcs+WjdiJOHnhCF5FGMHyK3SsMiEHhiWE6Q0i
	 Q+OrPdmPlK7M8lCplkfiKTPZzWwMFelvId9R3q2/PRHXNLwENoIlG/w2shw7pjNoiQ68m
	 qlwBtNSVp1dmuauX2c+zzLEdvs22Z7KM5cnmEl6aeMRJQnR9pJOcGK9jmPFu7cwHmhYcO
	 PfH84iIhJ4Z9t9kZ3Ywx3IB3Ul4Gh+hP3+UCg0Wsz5XTU0K1GVhgs34jt0QwJxukDJm2L
	 adC8cHhDMvC7cz2ph42HiTttg9qaUVHwKUWj8HMBkMlrD2NmMTKcPB3YN4xQ4PnQf5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T5Wk1+WC;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38851606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:57:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38851606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T5Wk1+WC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792562280; x=1824098280;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H7Us3csM7KlqfmOQtYVzQN6z5KTrQAj7QwzbfGFGHNY=;
  b=T5Wk1+WCQT5QqdOIvHlcfbIuesT/Svk1Ecw+Cg+HYdAIs+PiumPSeaPJ
   RacyYYf6MEh2XfvlmenBSgn0nd4+liEQ2nkC+RIZlHgyrr5nTLyLpgTZG
   DV/SUwsUh97rqBsjwLCG1s9wf/h1VOltJBvwhQiTLFYi6nOlCcJQikycd
   vb1452D/xw2+EpgOKZr+lGfF2JaSFTv3jg7VRTryS9S4PxReQeU/ewbNd
   pIwqqizSSHZHrvWitlMPeF8CIwad0bwXO8dXLqrspfO3tp8VjVva2f0WI
   Syh8TPCsra9OUjWnMaJpoSGffXZCNLYMYEQS2N2bktgJfP1AQBB41IWdG
   g==;
X-CSE-ConnectionGUID: mMzj7f9XSeecdPM8PFxklQ==
X-CSE-MsgGUID: VxPUJzOaQQeTguW8qtZbtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1293952"
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="1293952"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 22:57:59 -0700
X-CSE-ConnectionGUID: doxQZF4GRc2o6suR8aK/ng==
X-CSE-MsgGUID: Off98YcyQr2i3X7DBKcVGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="3067035"
Received: from blu2-desk.sh.intel.com (HELO [10.239.156.26]) ([10.239.156.26])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 22:57:56 -0700
Message-ID: <50cac102-9b50-4d0d-af58-8aac51a6d51c@linux.intel.com>
Date: Wed, 21 Oct 2026 13:57:53 +0800
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
 arend.vanspriel@broadcom.com, regressions@lists.linux.dev
References: <CA+3E589O46nj=c1Y+Rwk_nPZZKEUjFvMfWaAFmQ2-7De9iUxFw@mail.gmail.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <CA+3E589O46nj=c1Y+Rwk_nPZZKEUjFvMfWaAFmQ2-7De9iUxFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 19:32, Peter Kiddier wrote:
> Hello,
> 
> I am reporting a Wi-Fi regression on a 2018 Apple MacBook Air with a
> T2 chip, running Linux Mint Zena based on Ubuntu 24.04.
> 
> The Broadcom BCM4355 Wi-Fi device works with kernel 7.2.11-3-t2-noble
> but fails with 7.3.0-2-t2-noble. Disabling the Intel IOMMU using
> intel_iommu=off restores Wi-Fi on 7.3.0-2.
> 
> Hardware:
> - Apple MacBook Air 2018 (MacBookAir8,1)
> - Wi-Fi: Broadcom BCM4355 802.11ac Wireless LAN SoC
> - PCI ID: 14e4:43dc (subsystem 106b:0843)
> - Driver: brcmfmac
> - Interface: wlp2s0
> 
> Test results:
> 
> - 7.2.11-3-t2-noble, default kernel command line: Wi-Fi works.
> - 7.3.0-2-t2-noble, default kernel command line: Wi-Fi fails.
> - 7.3.0-2-t2-noble with intel_iommu=off: Wi-Fi works.
> - Reloading brcmfmac on the failing configuration does not restore Wi-Fi.
> 
> On the failing 7.3.0-2 boot, the driver detects the device, loads its
> firmware and creates wlp2s0:
> 
> brcmfmac 0000:02:00.0: enabling device (0000 -> 0002)
> brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4355c1-pcie for
> chip BCM4355/12
> brcmfmac: brcmf_c_process_txcap_blob: TxCap blob found, loading
> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4355/12 wl0: Jul  8 2023
> 17:49:51 version 9.30.503.0.32.5.87 FWID 01-e74b9cb0
> brcmfmac 0000:02:00.0 wlp2s0: renamed from wlan0
> 
> However, Wi-Fi subsequently stops responding. The kernel log reports
> errors including:
> 
> brcmf_msgbuf_query_dcmd: Timeout on response for query command
> brcmf_cfg80211_scan: scan error (-5)
> brcmf_run_escan: error (-5)
> brcmf_msgbuf_tx_ioctl: Failed to reserve space in commonring
> brcmf_cfg80211_get_channel: chanspec failed (-5)
> 
> There is also an error creating the P2P interface:
> 
> brcmf_cfg80211_add_iface: add iface p2p-dev-wlp2s0 type 10 failed: err=-52
> 
> I tried reloading the driver using:
> 
> sudo modprobe -r brcmfmac_wcc
> sudo modprobe -r brcmfmac
> sudo modprobe brcmfmac
> 
> The driver and firmware loaded again, but Wi-Fi remained unusable.
> 
> The firmware files are present under /lib/firmware/brcm/, and the
> firmware version reported by the driver is the same on the working and
> failing kernels.
> 
> The brcmfmac module metadata differs between the kernels:
> 
> Working kernel 7.2.11-3-t2-noble:
> srcversion: 3B6176FDB720DDE8E7C596B
> 
> Failing kernel 7.3.0-2-t2-noble:
> srcversion: 3DCA38D52402541701276CF
> 
> I did not find obvious PCIe AER or fatal errors in the failing boot's
> kernel log.
> 
> It has been suggested testing intel_iommu=off after reloading
> brcmfmac. The driver reload did not help, but booting with
> intel_iommu=off restored Wi-Fi.
> 
> This strongly suggests an interaction between Intel IOMMU handling and
> the BCM4355/brcmfmac driver in the 7.3.0-2-t2-noble kernel.
> 
> I have not tested a vanilla upstream kernel, so I cannot yet confirm
> whether this reproduces outside the T2 kernel packages. Unfortunately,
> I have limited time available for further testing, so I may not be
> able to investigate additional requests promptly. I wanted to report
> the reproducible behaviour and the intel_iommu=off workaround in case
> it helps identify the regression.
> 
> Could you advise on further diagnostics, or whether this should be
> investigated as an IOMMU or brcmfmac regression?
> 
> Thank you.
> 

Can you reproduce this issue with the mainline kernel?

Do you see any IOMMU fault messages in the kernel log? You can check
by running:

   # dmesg | grep DMAR

Have you tried narrowing down the cause with boot options such as
iommu=pt or intel_iommu=on,sm_off?

Thanks,
baolu
