Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78993B5841;
	Mon, 10 Aug 2026 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786355892; cv=none; b=V9FFNFrZCOqsiL6fbVihrqSqGQxwYwP2AjLe1bozqX58CHWPoLPO2dhGrjgnguzPAD1SOsCamAGAI1oQrgb1JNxIvn5IhiXkMoVawLilbaNBrddza24ucaMTfiXxtGaKzkPYXfi1pHHjTsoZeDra8H7nQfNWa8QL1VP2sDTExK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786355892; c=relaxed/simple;
	bh=OIBLn+vI6UtjzTR690g/0/DqXLgizFSN5e6xNFRiIQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBzoYaKqwHd5HPsX7fQsh3mCy0ObYwqmVHmG2waafjTMy/mIhEV0532IoJAkA462kANvLqIMyiG8XA/r42aM/DNlR9+k5frGZf4OFLaluYtoJtQatqANO407ATQO8/2o+v+fWT0cdA9+W36ubV0+7l/NrL4cUnkDenAw5Zph+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P043AHYZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P043AHYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786355887; x=1817891887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OIBLn+vI6UtjzTR690g/0/DqXLgizFSN5e6xNFRiIQY=;
  b=P043AHYZOWripuvjotgNunh45t3GH2X1xQu6NDJB/UstrSVx0SwQ5flT
   QKDVCa86vMC3jHyre8TWhXUoKiwFCLPFX7BtDrz8xHGgcmahmOY+9IZPI
   mCsr0t7rkhGhIb9B3bsNXdPr9y/TbkqRIvSyhLkHHSj8cfRiNvv1VVRcO
   vdkHRrbbKqvrD48q9jFcX9i1Ost9zgj7SnADgub1Wdu8j4uTV8NrRt32g
   gQArl9RYe27SrlCTQ4v0WHUS+rAC85CmLocrdkuORUqYNooTbaajKszbF
   /45bsK2cpHAmlZiIqepc68LdBkk7HU5yGsWMOWEGhWQP2FuUTwpNTAHvs
   A==;
X-CSE-ConnectionGUID: 33RjamcmQqKVWrVpxF8Yhg==
X-CSE-MsgGUID: UeBG106hT7uMh3gvIT/iMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="86941073"
X-IronPort-AV: E=Sophos;i="6.25,215,1779174000"; 
   d="scan'208";a="86941073"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 02:58:01 -0700
X-CSE-ConnectionGUID: 1s6lpu4bQyymJDs4F82TDA==
X-CSE-MsgGUID: PFzlndWpT9OR6jAyiitIZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,215,1779174000"; 
   d="scan'208";a="261708904"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 10 Aug 2026 02:57:58 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wtMlX-00000000N6k-1EnS;
	Mon, 10 Aug 2026 09:57:55 +0000
Date: Mon, 10 Aug 2026 17:57:15 +0800
From: kernel test robot <lkp@intel.com>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, bhelgaas@google.com,
	alex@shazbot.org, mani@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	jjohnson@kernel.org, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	ath12k@lists.infradead.org, mhi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: Re: [PATCH v11] PCI: Add device-specific reset for Qualcomm devices
Message-ID: <202608101710.4bALXXJf-lkp@intel.com>
References: <20260626055023.197470-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626055023.197470-1-jtornosm@redhat.com>

Hi Jose,

kernel test robot noticed the following build warnings:

[auto build test WARNING on pci/next]
[also build test WARNING on pci/for-linus linus/master v7.2-rc6 next-20260807]
[cannot apply to linux-review/Jose-Ignacio-Tornos-Martinez/Add-device-specific-reset-for-Qualcomm-devices/20260804-001013]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jose-Ignacio-Tornos-Martinez/PCI-Add-device-specific-reset-for-Qualcomm-devices/20260810-131417
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/20260626055023.197470-1-jtornosm%40redhat.com
patch subject: [PATCH v11] PCI: Add device-specific reset for Qualcomm devices
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20260810/202608101710.4bALXXJf-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 12df34b8469b8095359de8c249cb1b2753fadeea)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260810/202608101710.4bALXXJf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608101710.4bALXXJf-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/pci/quirks.c:4278:11: warning: result of comparison of constant 18446744073709551615 with expression of type 'u32' (aka 'unsigned int') is always true [-Wtautological-constant-out-of-range-compare]
    4278 |                 if (val != PCI_ERROR_RESPONSE) {
         |                     ~~~ ^  ~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +4278 drivers/pci/quirks.c

  4234	
  4235	/*
  4236	 * Qualcomm WiFi device-specific reset using SoC global reset via BAR0
  4237	 * registers.
  4238	 */
  4239	static int reset_qualcomm_wifi(struct pci_dev *pdev, bool probe)
  4240	{
  4241		bool link_recovered = false;
  4242		unsigned long timeout;
  4243		void __iomem *bar;
  4244		u32 val;
  4245		u16 cmd;
  4246	
  4247		if (probe)
  4248			return 0;
  4249	
  4250		if (pdev->current_state != PCI_D0)
  4251			return -EINVAL;
  4252	
  4253		pci_read_config_word(pdev, PCI_COMMAND, &cmd);
  4254		pci_write_config_word(pdev, PCI_COMMAND, cmd | PCI_COMMAND_MEMORY);
  4255	
  4256		bar = pci_iomap(pdev, 0, 0);
  4257		if (!bar) {
  4258			pci_write_config_word(pdev, PCI_COMMAND, cmd);
  4259			return -ENODEV;
  4260		}
  4261	
  4262		val = ioread32(bar + QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET);
  4263		val |= QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET_V;
  4264		iowrite32(val, bar + QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET);
  4265		ioread32(bar + QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET);
  4266	
  4267		msleep(10);
  4268	
  4269		val &= ~QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET_V;
  4270		iowrite32(val, bar + QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET);
  4271		ioread32(bar + QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET);
  4272	
  4273		msleep(10);
  4274	
  4275		timeout = jiffies + msecs_to_jiffies(5000);
  4276		while (time_before(jiffies, timeout)) {
  4277			val = ioread32(bar + QUALCOMM_WIFI_PCIE_SOC_GLOBAL_RESET);
> 4278			if (val != PCI_ERROR_RESPONSE) {
  4279				link_recovered = true;
  4280				break;
  4281			}
  4282			msleep(20);
  4283		}
  4284	
  4285		if (!link_recovered) {
  4286			pci_err(pdev, "PCIe link failed to recover after reset\n");
  4287			goto out_restore;
  4288		}
  4289	
  4290		/* After SOC_GLOBAL_RESET, MHISTATUS may still have SYSERR bit set
  4291		 * and thus need to set MHICTRL_RESET to clear SYSERR.
  4292		 */
  4293		iowrite32(QUALCOMM_WIFI_MHICTRL_RESET_MASK, bar + QUALCOMM_WIFI_MHICTRL);
  4294		ioread32(bar + QUALCOMM_WIFI_MHICTRL);
  4295	
  4296		msleep(10);
  4297	
  4298	out_restore:
  4299		pci_iounmap(pdev, bar);
  4300		pci_write_config_word(pdev, PCI_COMMAND, cmd);
  4301	
  4302		return link_recovered ? 0 : -ETIMEDOUT;
  4303	}
  4304	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
