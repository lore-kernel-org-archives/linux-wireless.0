Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A35415F3E
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785777263; cv=none; b=NsbXFOkN0lTOr6Ox0/7UvIUqOtTeJqRMD8zWCe4QlAG60V/PO4+75uYWu032/VX8XaKYGYUFXTKeCk9fzDd+CFeq+rqbN/2CMC4B8QzTRrLfpmB6lFe7bBKhzw8bGT/mvItwsA9DJ+nt20ok1F76Hn2/xKDkrFlYkzjuOnrFkEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785777263; c=relaxed/simple;
	bh=O6I5z+hO9I5U5pxhNDiVlajwFCyfjfEyaeAjsSR9uE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rw66FX8M+3INnR0nWbx/WEiK4Pptg5OonTXm4yQIbjNmGMnEQ1KbQ/IIYS2DRyHHmFJDJk3CDz443D66ctNvVtqNE0owimFU9oN4A3KZ4PLlCXtUXCnM3wiLvdAz1sUJzxK/eIYyr4pMEJnHG8prSKiERBsrE6QLRb+QQEcVtCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fOn4l/ON; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fOn4l/ON"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785777262; x=1817313262;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O6I5z+hO9I5U5pxhNDiVlajwFCyfjfEyaeAjsSR9uE8=;
  b=fOn4l/ON1XYZ+j8DzTRBEyJV3zaz8H+kZDXujgxqbZeca2EG0AQipUqk
   AFym8ZuhV3/5LhoS/037T0a98CoAyURVYlrkoC1hT7S7qfmzpov24MCJ0
   NYCNeZ+xEQ9RBK4A2rJcTl3UzA8hkUn3fzMWYdsLx8astkMSKFISn56mB
   b5RLF4L9NNCFeYXmToe92+N3+VS7ucAGbXm+BP2Pj8lF39pjvZF8q/mQf
   +C9B9CIgEEA7U270iaqOc8FlWFHYL2KkqsqtUr6QcWcxQpCmfEdlTZtmS
   PZyHlPx92994S+m/97zCw3TcgqECDGef0bWshMoHE4ET4T8/cPEJzph6T
   A==;
X-CSE-ConnectionGUID: y9VRWenRQWKk5xDE914X8A==
X-CSE-MsgGUID: uDnA06DiRe6MEEUQcIdsAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="90131975"
X-IronPort-AV: E=Sophos;i="6.25,202,1779174000"; 
   d="scan'208";a="90131975"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 10:14:20 -0700
X-CSE-ConnectionGUID: SfkezNeKQryRg3JKVUBY/A==
X-CSE-MsgGUID: tXZxqbhQSQCR0GDI2mYb9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,202,1779174000"; 
   d="scan'208";a="260681371"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 03 Aug 2026 10:14:18 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wqwEw-000000007RX-3s5x;
	Mon, 03 Aug 2026 17:14:14 +0000
Date: Tue, 4 Aug 2026 01:13:44 +0800
From: kernel test robot <lkp@intel.com>
To: JB Tsai <jb.tsai@mediatek.com>, nbd@nbd.name, lorenzo@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org, Sean.Wang@mediatek.com,
	Quan.Zhou@mediatek.com, Ryder.Lee@mediatek.com,
	litien.chang@mediatek.com, Charlie-cy.Wu@mediatek.com,
	jb.tsai@mediatek.com
Subject: Re: [PATCH] wifi: mt76: connac3: implement 6GHz power type detection
 and dynamic CLC filtering
Message-ID: <202608040156.lx0926Ek-lkp@intel.com>
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
[cannot apply to wireless/main linus/master v7.2-rc6 next-20260731]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/JB-Tsai/wifi-mt76-connac3-implement-6GHz-power-type-detection-and-dynamic-CLC-filtering/20260803-215116
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260724085103.3155942-1-jb.tsai%40mediatek.com
patch subject: [PATCH] wifi: mt76: connac3: implement 6GHz power type detection and dynamic CLC filtering
config: alpha-allmodconfig (https://download.01.org/0day-ci/archive/20260804/202608040156.lx0926Ek-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260804/202608040156.lx0926Ek-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608040156.lx0926Ek-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/wireless/mediatek/mt76/mt7925/main.c: In function 'mt7925_set_sar_specs':
>> drivers/net/wireless/mediatek/mt76/mt7925/main.c:1986:15: error: too few arguments to function 'mt7925_mcu_set_clc'; expected 4, have 3
    1986 |         err = mt7925_mcu_set_clc(dev, dev->mt76.alpha2,
         |               ^~~~~~~~~~~~~~~~~~
   In file included from drivers/net/wireless/mediatek/mt76/mt7925/main.c:10:
   drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h:387:5: note: declared here
     387 | int mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
         |     ^~~~~~~~~~~~~~~~~~


vim +/mt7925_mcu_set_clc +1986 drivers/net/wireless/mediatek/mt76/mt7925/main.c

c948b5da6bbec7 Deren Wu    2023-09-18  1978  
c948b5da6bbec7 Deren Wu    2023-09-18  1979  static int mt7925_set_sar_specs(struct ieee80211_hw *hw,
c948b5da6bbec7 Deren Wu    2023-09-18  1980  				const struct cfg80211_sar_specs *sar)
c948b5da6bbec7 Deren Wu    2023-09-18  1981  {
c948b5da6bbec7 Deren Wu    2023-09-18  1982  	struct mt792x_dev *dev = mt792x_hw_dev(hw);
c948b5da6bbec7 Deren Wu    2023-09-18  1983  	int err;
c948b5da6bbec7 Deren Wu    2023-09-18  1984  
c948b5da6bbec7 Deren Wu    2023-09-18  1985  	mt792x_mutex_acquire(dev);
8a27c5c764040f Jared.Huang 2026-06-17 @1986  	err = mt7925_mcu_set_clc(dev, dev->mt76.alpha2,
8a27c5c764040f Jared.Huang 2026-06-17  1987  			 dev->country_ie_env);
8a27c5c764040f Jared.Huang 2026-06-17  1988  	if (err < 0)
8a27c5c764040f Jared.Huang 2026-06-17  1989  		goto out;
8a27c5c764040f Jared.Huang 2026-06-17  1990  
c948b5da6bbec7 Deren Wu    2023-09-18  1991  	err = mt7925_set_tx_sar_pwr(hw, sar);
c948b5da6bbec7 Deren Wu    2023-09-18  1992  
8a27c5c764040f Jared.Huang 2026-06-17  1993  out:
8a27c5c764040f Jared.Huang 2026-06-17  1994  	mt792x_mutex_release(dev);
c948b5da6bbec7 Deren Wu    2023-09-18  1995  	return err;
c948b5da6bbec7 Deren Wu    2023-09-18  1996  }
c948b5da6bbec7 Deren Wu    2023-09-18  1997  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
