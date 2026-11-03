Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735390;
	b=eG1aVgYUd64Oz7fmuYn0zfDfX49Py+DGI1J4ioEQKcOjD17DyoUAcME+edC0zyBSjQH+
	 zFKt3EV4bu5gXult4i9ZM2tn/iF2J2hq1suyWo7ypIFp0CJTpey07MbDh8HlOaKoEgV5T
	 BLYokbOX48HCO+HSf9bbGt8B9TsW8Zzawn4sLRfAu2lsSCbuQVfidcVnIi55BBvzSuxL6
	 wG//3v/uqMDml0cdHibAfGANclqUkwWtLQrx2u/OoRClHxsxK31mCnIrNS2TZU/gN6BAA
	 g4cMHl6X9Q4jh3BxTUoQx8g0Zk/qbYs6nDTk0h3bEjw0aw1GFBu82w5TNtCre+VUk2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735390;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=9P+E53yKlDmqXM3P0gvNQJjIJEomFqG3poCHUiZ6Bi0=;
	b=rToaIOicllhNgPHlPf489039pTpD4Kxm+j0rBonOq5c8GJa/WVzZuaPNSa4musjxqJBV
	 u3wsq8wxKUUNuJI4fbNvPyRvums2xnRGyAV9+UPp9+G+MBAAepgDrQOSc3Km20Yscf5nv
	 GpEKXolQX9Ra46E5N74jAPM4GENvIgDJOjN8DSdYg/qI1G7lYUPDNkn8eG9wei2vkfD6p
	 OZ96/5fr41M0XGaJNtr4IKpYHN0Jvgn87cKc9U82Mt9kyJgxrJtv4X2BQngEULPpG2SKK
	 26IRuuDzuxanyf6z8cWL1ZD/F7Idu1DJtuhuEGJFWoC/5hkJF+pNTi41qvGNvU/XGRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=X59HlbTz;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE146606A335;
	Tue,  3 Nov 2026 19:49:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE146606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=X59HlbTz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793735389; x=1825271389;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rCERoXWCfBu35r5RRg7xmnqKjETJErwBKzmm+LfUQgQ=;
  b=X59HlbTzuf7T9sTkMexVJVALXyzRA4JBN0tC3F2BDPk8T5yLTFsMN9ZN
   IYYeM1/AfY0/Y7lMkTwaiiyRStTxECllESq7IDf9tPPdc9PwcT5nUxXan
   hB4cckVCnW96mFB0LUwFT2mDwFTAgCkLAD92WmxEblDFPwZ3Etmhc9LnG
   2VAgATcLiAcOpjoFgS2+MJn1HIs46V3OarcPgeI3ZSVzvvok+tmfgfbS9
   x0OJJo4oEMZ1EvNqvfM1GFamGhdpVBrRkRIS/N6igg2QxfyBwVr0uXqY8
   sKsPtR7V/4VILvU7QvIPTA6jy9UDkup26NkvMo2rAof8FGOZcqdMb/XW0
   g==;
X-CSE-ConnectionGUID: /v57nx9NSlO9oKLsrgGeBA==
X-CSE-MsgGUID: Ue0TikruR0ifo1Xouh04jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2568222"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2568222"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 11:49:49 -0800
X-CSE-ConnectionGUID: +nzjp0bdSYCWNsVVsQUiqQ==
X-CSE-MsgGUID: M2Twv/xtSl6go+XODMWfkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6364910"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 03 Nov 2026 11:49:47 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOKVt-00000000jFH-18IU;
	Tue, 03 Nov 2026 19:49:45 +0000
Date: Wed, 4 Nov 2026 03:48:54 +0800
From: kernel test robot <lkp@intel.com>
To: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	jjohnson@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
	sibi.sankar@oss.qualcomm.com,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: ath12k: skip hardware rfkill setup on Surface
 Laptop 8th Edition
Message-ID: <202611040318.qlss0Yol-lkp@intel.com>
References: <20261103094024.1764151-1-gopikrishna.garmidi@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261103094024.1764151-1-gopikrishna.garmidi@oss.qualcomm.com>

Hi Gopikrishna,

kernel test robot noticed the following build errors:

[auto build test ERROR on ath/ath-next]
[also build test ERROR on wireless-next/main linus/master next-20261030]
[cannot apply to wireless/main v7.3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Gopikrishna-Garmidi/wifi-ath12k-skip-hardware-rfkill-setup-on-Surface-Laptop-8th-Edition/20261103-014024
base:   https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git ath-next
patch link:    https://lore.kernel.org/r/20261103094024.1764151-1-gopikrishna.garmidi%40oss.qualcomm.com
patch subject: [PATCH] wifi: ath12k: skip hardware rfkill setup on Surface Laptop 8th Edition
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20261104/202611040318.qlss0Yol-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261104/202611040318.qlss0Yol-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611040318.qlss0Yol-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/wireless/ath/ath12k/core.c:91:9: error: expected '}' before '{' token
      91 |         { /* Sentinel */ }
         |         ^
   drivers/net/wireless/ath/ath12k/core.c:86:39: note: to match this '{'
      86 | } ath12k_core_broken_rfkill_table[] = {
         |                                       ^


vim +91 drivers/net/wireless/ath/ath12k/core.c

defae535dd63b1 Aaradhana Sahu      2025-07-08  76  
5949d1910f13c2 François Roux       2026-10-06  77  /*
5949d1910f13c2 François Roux       2026-10-06  78   * On these machines the OS cannot control the WCN7850 hardware rfkill
5949d1910f13c2 François Roux       2026-10-06  79   * input, which reads as "radio off", so hardware rfkill must stay
5949d1910f13c2 François Roux       2026-10-06  80   * disabled. Ideally this would come from the connector node of the board
5949d1910f13c2 François Roux       2026-10-06  81   * DT, but that binding does not exist yet.
5949d1910f13c2 François Roux       2026-10-06  82   */
5949d1910f13c2 François Roux       2026-10-06  83  static const struct ath12k_core_broken_rfkill_table {
5949d1910f13c2 François Roux       2026-10-06  84  	enum ath12k_hw_rev hw_rev;
5949d1910f13c2 François Roux       2026-10-06  85  	const char *compatible;
5949d1910f13c2 François Roux       2026-10-06  86  } ath12k_core_broken_rfkill_table[] = {
5949d1910f13c2 François Roux       2026-10-06  87  	{ ATH12K_HW_WCN7850_HW20, "microsoft,denali" },
5949d1910f13c2 François Roux       2026-10-06  88  	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus13" },
5949d1910f13c2 François Roux       2026-10-06  89  	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus15" },
2d169d089ae8e1 Gopikrishna Garmidi 2026-11-03  90  	{ ATH12K_HW_WCN7850_HW20, "microsoft,surface-laptop-8-13p8" }
5949d1910f13c2 François Roux       2026-10-06 @91  	{ /* Sentinel */ }
5949d1910f13c2 François Roux       2026-10-06  92  };
5949d1910f13c2 François Roux       2026-10-06  93  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
