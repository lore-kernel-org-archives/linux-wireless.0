Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F424AA588;
	Wed, 23 Sep 2026 11:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163739; cv=none; b=e6Qrr08xTSUgfAYhSNkFzOVN8E9WaLM6mKg8LgXGwyjIA4qgLVwGOpdYD+Ww3c+R2N3V279aGiJt9ABBxR7s8wDick2Dmm+HWf2Hrsqi+FWb3yqUDhJw9NKVHVXTTTzFIltEwyrQXwiyg+es/YNKrYrWPiXXQaFQ1WRkfR2eKBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163739; c=relaxed/simple;
	bh=DT3d8VVBrsk52mv8P/WxKyUIJjV8+JcCHMM/0fuulS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6/y7yXEqPNf0/qoXqsxpQ3yIuqvPsoxPzGKeAfHOA/rZHuqRfXgPubAKm0D9eR/lJeakgUmD/abdUjVnXX+Or9dmJCxwp5XFx1RRrQ5JS1YxEBAnd5dqq4b42E8C0xyOuWnFSZSEaoo0ZzyHr+dr3LOzPm4ArHjyDSdb67MFB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lQJupDQH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQJupDQH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790163734; x=1821699734;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DT3d8VVBrsk52mv8P/WxKyUIJjV8+JcCHMM/0fuulS0=;
  b=lQJupDQHMqRD4z5nIoq0Vgdh2j8mvf3aDkeyWZ+iV1DoCjM5Y0u2GlFf
   Kg62ozKg0Bi3rCv9RE33MJWV8XgOVwJJykKSGE9bI5LTXKvHuoKCBSroB
   NeNgm/kgb9vKSTjQrm/7HqBcwC6jpx7Wbwgk01xIA3wg1XUJ1ICadYZnE
   yP9ImkDPbuvkl49xX7J5GlTUyIyjjtBeF7q4pwLIO+qiyBU7UEkU6CuvA
   uZOgzSydG+rF6mPFUIitaIUL7ePH9pUSciWWsoFV0LOTEA/i88HEw2FnH
   1STf9xK6RbYwZy6Y8kxS4scQwcpcgs4zBLDxhN4Ski7bvi/oUk/TWV8+T
   Q==;
X-CSE-ConnectionGUID: A+Qq+BUSTJO0eCOphxBVug==
X-CSE-MsgGUID: 3I6eHdyUSr6fj8cx9nAdjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="116371353"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="116371353"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 04:42:04 -0700
X-CSE-ConnectionGUID: ymTK+g3sSLODOQfsHINRTg==
X-CSE-MsgGUID: SHhtzGGFTSCPf8NAVjok3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="301488644"
Received: from igk-lkp-server01.igk.intel.com (HELO 1bbc298b9a73) ([10.211.93.152])
  by fmviesa001.fm.intel.com with ESMTP; 23 Sep 2026 04:42:02 -0700
Received: from kbuild by 1bbc298b9a73 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9LMM-000000000db-2fyP;
	Wed, 23 Sep 2026 11:41:58 +0000
Date: Wed, 23 Sep 2026 13:41:53 +0200
From: kernel test robot <lkp@intel.com>
To: Andre Eikmeyer <dev@deq.rocks>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org, Andre Eikmeyer <dev@deq.rocks>
Subject: Re: [PATCH] wifi: brcmfmac: handle missing D3 ACK on BCM4377 T2 Macs
Message-ID: <202609231342.UV1sSEzG-lkp@intel.com>
References: <20260918213014.1890677-1-dev@deq.rocks>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918213014.1890677-1-dev@deq.rocks>

Hi Andre,

kernel test robot noticed the following build warnings:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on wireless/main linus/master v7.3-rc4 next-20260922]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Andre-Eikmeyer/wifi-brcmfmac-handle-missing-D3-ACK-on-BCM4377-T2-Macs/20260918-233014
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260918213014.1890677-1-dev%40deq.rocks
patch subject: [PATCH] wifi: brcmfmac: handle missing D3 ACK on BCM4377 T2 Macs
config: parisc-allyesconfig (https://download.01.org/0day-ci/archive/20260923/202609231342.UV1sSEzG-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260923/202609231342.UV1sSEzG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609231342.UV1sSEzG-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:80:13: warning: 'brcmf_pcie_quirk_no_d3_ack' defined but not used [-Wunused-function]
      80 | static bool brcmf_pcie_quirk_no_d3_ack(struct pci_dev *pdev)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/brcmf_pcie_quirk_no_d3_ack +80 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c

    79	
  > 80	static bool brcmf_pcie_quirk_no_d3_ack(struct pci_dev *pdev)
    81	{
    82		return pdev->vendor == PCI_VENDOR_ID_BROADCOM &&
    83		       pdev->device == BRCM_PCIE_4377_DEVICE_ID &&
    84		       dmi_check_system(brcmf_pcie_no_d3_ack_quirk);
    85	}
    86	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
