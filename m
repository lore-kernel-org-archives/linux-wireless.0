Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C884A344D9F
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 22:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785796611; cv=none; b=eDOuZljgn2RHm60ofbfEiWaZA0FNkcKmZoWYZVpGbYN2au0nh5PLF71mxnXfM7IalwEWgf2HC6ZiUbiHpY6X5HqvI+kI8Dt7RgTtyBSfNzuC80/RarTW5uYdtlBqFeCbB+ZRUNOwRYmgpnq/D3nqT5eXrhO/AWQoynZ+gmR6CCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785796611; c=relaxed/simple;
	bh=SMhjVdU2ZDAmJkhf9Tg7h3l0ADU6HH3S2XK+03kIQNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=argdx+ZSiKfehDOwH/AztunCfCZnyLAWsK9c2I7G4e01U4xU3iJK2YG5Jv+436XWCgkOgE+TeRr85qmPbTeUAhsG3pQDpcUpjPNBWP60HNyGkPihGLlgj8Ee9/mCEr2AVlzVXtPMEgEwZqYJGI84XrhfWdmKqzC7/zNTyvy71ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nzd5nc3R; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nzd5nc3R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785796610; x=1817332610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SMhjVdU2ZDAmJkhf9Tg7h3l0ADU6HH3S2XK+03kIQNw=;
  b=Nzd5nc3R+CaOSqWaJ3toWoRZ01lsZ16tuIRMjDEmPTcUOk9Nh9rFKMHP
   tVpjuS10PAN3ZFjnBeScMIl8TstTzhCw32TrGRnrOy65KFLyWkX7X1SjX
   caO+gHNLNfJ3zsoJ88RbWN4VHTIVnvVkXkWKwkw+d4hDHBq5rwtSqNtTC
   Ma161qZdxorOPSm03xrv4SwrIg87JJY9BpsYeyIhNNlS1jEtQ4ycqSJxL
   gD9xvHGczSSFJ/MUs+P8EiA7ymQ48gwpHHB+BGn8tei2A2vgC1tMCl74i
   RSZ9DsFpOvCD6uafMyx8Q5dVqIv7YNpbhvHYxjpUNBDY3RxK670hOkVNa
   w==;
X-CSE-ConnectionGUID: Ep7qjcd9RW6lsxqp9lokuA==
X-CSE-MsgGUID: Q92UgkN6RUezYu//UYxuxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="85474330"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="85474330"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 15:36:49 -0700
X-CSE-ConnectionGUID: Mzxjk8tvTWqrXS+MdLLxUA==
X-CSE-MsgGUID: /gGtqyWdQXaebCJpfJmvfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="263324267"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 03 Aug 2026 15:36:47 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wr1H2-000000008AD-0x9z;
	Mon, 03 Aug 2026 22:36:44 +0000
Date: Tue, 4 Aug 2026 06:36:03 +0800
From: kernel test robot <lkp@intel.com>
To: JB Tsai <jb.tsai@mediatek.com>, nbd@nbd.name, lorenzo@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org, Sean.Wang@mediatek.com,
	Quan.Zhou@mediatek.com, Ryder.Lee@mediatek.com,
	litien.chang@mediatek.com, Charlie-cy.Wu@mediatek.com,
	jb.tsai@mediatek.com
Subject: Re: [PATCH] wifi: mt76: connac3: implement 6GHz power type detection
 and dynamic CLC filtering
Message-ID: <202608040641.uKGpvScD-lkp@intel.com>
References: <20260724085103.3155942-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724085103.3155942-1-jb.tsai@mediatek.com>

Hi JB,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on next-20260803]
[cannot apply to wireless/main linus/master v7.2-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/JB-Tsai/wifi-mt76-connac3-implement-6GHz-power-type-detection-and-dynamic-CLC-filtering/20260803-215116
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260724085103.3155942-1-jb.tsai%40mediatek.com
patch subject: [PATCH] wifi: mt76: connac3: implement 6GHz power type detection and dynamic CLC filtering
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20260804/202608040641.uKGpvScD-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260804/202608040641.uKGpvScD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608040641.uKGpvScD-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/wireless/mediatek/mt76/mt7925/main.c: In function 'mt7925_set_sar_specs':
>> drivers/net/wireless/mediatek/mt76/mt7925/main.c:1986:15: error: too few arguments to function 'mt7925_mcu_set_clc'
    1986 |         err = mt7925_mcu_set_clc(dev, dev->mt76.alpha2,
         |               ^~~~~~~~~~~~~~~~~~
   In file included from drivers/net/wireless/mediatek/mt76/mt7925/main.c:10:
   drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h:387:5: note: declared here
     387 | int mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
         |     ^~~~~~~~~~~~~~~~~~


vim +/mt7925_mcu_set_clc +1986 drivers/net/wireless/mediatek/mt76/mt7925/main.c

c948b5da6bbec74 Deren Wu    2023-09-18  1978  
c948b5da6bbec74 Deren Wu    2023-09-18  1979  static int mt7925_set_sar_specs(struct ieee80211_hw *hw,
c948b5da6bbec74 Deren Wu    2023-09-18  1980  				const struct cfg80211_sar_specs *sar)
c948b5da6bbec74 Deren Wu    2023-09-18  1981  {
c948b5da6bbec74 Deren Wu    2023-09-18  1982  	struct mt792x_dev *dev = mt792x_hw_dev(hw);
c948b5da6bbec74 Deren Wu    2023-09-18  1983  	int err;
c948b5da6bbec74 Deren Wu    2023-09-18  1984  
c948b5da6bbec74 Deren Wu    2023-09-18  1985  	mt792x_mutex_acquire(dev);
8a27c5c764040fb Jared.Huang 2026-06-17 @1986  	err = mt7925_mcu_set_clc(dev, dev->mt76.alpha2,
8a27c5c764040fb Jared.Huang 2026-06-17  1987  			 dev->country_ie_env);
8a27c5c764040fb Jared.Huang 2026-06-17  1988  	if (err < 0)
8a27c5c764040fb Jared.Huang 2026-06-17  1989  		goto out;
8a27c5c764040fb Jared.Huang 2026-06-17  1990  
c948b5da6bbec74 Deren Wu    2023-09-18  1991  	err = mt7925_set_tx_sar_pwr(hw, sar);
c948b5da6bbec74 Deren Wu    2023-09-18  1992  
8a27c5c764040fb Jared.Huang 2026-06-17  1993  out:
8a27c5c764040fb Jared.Huang 2026-06-17  1994  	mt792x_mutex_release(dev);
c948b5da6bbec74 Deren Wu    2023-09-18  1995  	return err;
c948b5da6bbec74 Deren Wu    2023-09-18  1996  }
c948b5da6bbec74 Deren Wu    2023-09-18  1997  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
