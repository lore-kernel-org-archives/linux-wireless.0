Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338F9373BFE
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 07:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787644551; cv=none; b=qyFcdRSftK+RzU6s6U1rKA5Kh/sW6vTYzlWMDP9QonoT2qFsV/YF+5Oh8KEVdh5axM+/ytjPBnjP7EfsoERR4iA4qNPdxyLWj7VClHxH+9GKOb5y6VMXaCBMim1EyzwML54oSO+TgjyTRcGRD60Nkf9TkSGOkwJL6yTRBaMpy2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787644551; c=relaxed/simple;
	bh=cEEg94RxDrjn+V/9mMrTEw7XG6ZVjtZXmvPUbdJ0qvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeAIb/rRBIFH3qcCVdSa6GsPkRKG8SRq7YPk/GF6VcYa2CcjVUqXTx6KJskK3IdCQf7Xn0ZdldzBqXwLDmQwvKaqootQcJar+th25XpryEpctTM3ebzUoT0DAdgdB+ARZXY8z7bmJUg5N2K6MrUFq1IKLRQcofr2y6AsK94621s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rl9katNx; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rl9katNx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787644550; x=1819180550;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cEEg94RxDrjn+V/9mMrTEw7XG6ZVjtZXmvPUbdJ0qvQ=;
  b=Rl9katNxyMBlMuIedthTXGqyX5tR9q2PtjTeVgErEkLLxWiAy4r+9tqS
   5izR5g3YMUp+oQKGqY2MxWNvhjaygeOqQq76p+XvNiMvHs+eb6C0UZYOR
   1uoeR8ZjhXAqUwMMtjH3SBEG+Gf8MNelHH+mo378yXHZWp8eXPaBdj53S
   5f6QzYjrcXeLNjCQmVLY1zXJO66KX+85t4nVwhJLyKEUQRMYiWlgbcOQT
   VYQY2oJT/aEOC9aMwQOc+WWi/3/zrgCYSceNLPDcZLhTQAe4xGmf21uW7
   6w5pec76GCJkIHMlYx4Bs0grxAdk1qa9qetYaQyqt+gkUp+7A0ZO27yoP
   Q==;
X-CSE-ConnectionGUID: 26vTnrS7S2qygUHzOZoQXA==
X-CSE-MsgGUID: f9jsjj9zS4CYDPQgs01kbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="91785852"
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="91785852"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 00:55:49 -0700
X-CSE-ConnectionGUID: hN3GQjCqQlG5afb4P/iBHw==
X-CSE-MsgGUID: abvU8nloQ8iQxVDMl3slLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="271424992"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 25 Aug 2026 00:55:46 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wym0V-000000005FD-2WKr;
	Tue, 25 Aug 2026 07:55:43 +0000
Date: Tue, 25 Aug 2026 15:55:22 +0800
From: kernel test robot <lkp@intel.com>
To: Eason Lai <eason.lai@mediatek.com>, nbd@nbd.name, lorenzo@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org, kun.wu@mediatek.com,
	deren.wu@mediatek.com, sean.wang@mediatek.com,
	quan.zhou@mediatek.com, ryder.lee@mediatek.com,
	leon.yen@mediatek.com, litien.chang@mediatek.com,
	jb.tsai@mediatek.com, michael.shih@mediatek.com,
	eason.lai@mediatek.com
Subject: Re: [PATCH v1] wifi: mt76: mt7928: Add debugfs for stats to provide
 debug purpose
Message-ID: <202608251526.VgKMT8Lv-lkp@intel.com>
References: <20260824030746.60706-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824030746.60706-1-eason.lai@mediatek.com>

Hi Eason,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on linus/master next-20260821]
[cannot apply to wireless/main v7.2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eason-Lai/wifi-mt76-mt7928-Add-debugfs-for-stats-to-provide-debug-purpose/20260824-110746
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260824030746.60706-1-eason.lai%40mediatek.com
patch subject: [PATCH v1] wifi: mt76: mt7928: Add debugfs for stats to provide debug purpose
config: parisc-allyesconfig (https://download.01.org/0day-ci/archive/20260825/202608251526.VgKMT8Lv-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260825/202608251526.VgKMT8Lv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608251526.VgKMT8Lv-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/wireless/mediatek/mt76/mt7996/init.c:13:
>> drivers/net/wireless/mediatek/mt76/mt7996/mcu.h:1000:9: error: redeclaration of enumerator 'UNI_CMD_MIB_DATA'
    1000 |         UNI_CMD_MIB_DATA,
         |         ^~~~~~~~~~~~~~~~
   In file included from drivers/net/wireless/mediatek/mt76/mt7996/mcu.h:9:
   drivers/net/wireless/mediatek/mt76/mt7996/../mt76_connac_mcu.h:1511:9: note: previous definition of 'UNI_CMD_MIB_DATA' with type 'enum <anonymous>'
    1511 |         UNI_CMD_MIB_DATA,
         |         ^~~~~~~~~~~~~~~~


vim +/UNI_CMD_MIB_DATA +1000 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h

98686cd21624c7 Shayne Chen 2022-11-22   998  
98686cd21624c7 Shayne Chen 2022-11-22   999  enum {
98686cd21624c7 Shayne Chen 2022-11-22 @1000  	UNI_CMD_MIB_DATA,
98686cd21624c7 Shayne Chen 2022-11-22  1001  };
98686cd21624c7 Shayne Chen 2022-11-22  1002  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
