Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2C4351C34
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780503230; cv=none; b=Qi9yOBVx6pyTvuevQs5p9MRymM0+HkS/WT9fudE2PIv3hB4CM14YKtXAhlARJ7mVuezA6rYXP/iuKs02kYfiZ8Xz2T25H1MPsRD6w40TyRbhXutlyyAoqM0u9VLn67rZg1AMK4UnsOfLYdPNXN+jJpdTBBVC3Zxm7JFwI57MMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780503230; c=relaxed/simple;
	bh=NQGda+ldp72jCROfqHpVqZFXJq6f6BXsKUN8lXV3OIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e4LRCNKICdmA8JGb60d/w7bfA7ecFlxBQ0QPieR/yA6hV7s/AQcZu7es5GSljZKbQZMuNbCHYja+BME8acaJBsBRTA2ItFXDIklwGp8M45FCNqQTafsLDfXQy1dHdXcaheyQxR2AyGNj5hyJieCSEdSVsr+P5/t0hfjWIMJkU9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bjrjSJc7; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bjrjSJc7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780503228; x=1812039228;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NQGda+ldp72jCROfqHpVqZFXJq6f6BXsKUN8lXV3OIk=;
  b=bjrjSJc7eP0HYzxdTMuM+aGB49gSaKX1cNTqyqQEemF9KVGpC7a1qTfW
   r0hArhmn4oJArYkWEZpd2PAZSTjTekMWLOOBbQ1RgOEAGnMDdF0Yj2Zt/
   y0GJpnFMv3AjOIrqPu37+CcDTbKX6uUP/OHh7OAG/9v1yZMQpakMrgdoH
   L1SzsmD1H3ZswH4qtwK1ulnwHwKjmRZ3SF9xkZwD8Ac6GvXZO7NiE7TE3
   k9vWTm2FdW4o+XK4WEnxGjjL/8NhXtiOyatrDARicFtnQL+9U82TY8zfG
   a3p4s2P1W2Sw2Oorf4USHY+GEM4POa3Bv83zQSHwkjhGCcEe0mvzGEgZZ
   Q==;
X-CSE-ConnectionGUID: 1cEQ9riaQEOlneBDFpmQ2A==
X-CSE-MsgGUID: 4wfphkiISSupEkHSUnrNGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="81225135"
X-IronPort-AV: E=Sophos;i="6.24,185,1774335600"; 
   d="scan'208";a="81225135"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 09:13:47 -0700
X-CSE-ConnectionGUID: k6LN7mBHR++zHn/j+ieAWQ==
X-CSE-MsgGUID: Ux6O5Lk7RXigtCnUbBF23Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,185,1774335600"; 
   d="scan'208";a="241293620"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by fmviesa007.fm.intel.com with ESMTP; 03 Jun 2026 09:13:45 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wUoDv-0000000026z-2aBv;
	Wed, 03 Jun 2026 16:13:43 +0000
Date: Wed, 3 Jun 2026 18:13:06 +0200
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH] wifi: cfg80211: enforce HE/EHT cap/oper consistency
Message-ID: <202606031815.lqRk4eKB-lkp@intel.com>
References: <20260603091812.101894-2-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603091812.101894-2-johannes@sipsolutions.net>

Hi Johannes,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on wireless/main linus/master v7.1-rc6 next-20260602]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Johannes-Berg/wifi-cfg80211-enforce-HE-EHT-cap-oper-consistency/20260603-173706
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260603091812.101894-2-johannes%40sipsolutions.net
patch subject: [PATCH] wifi: cfg80211: enforce HE/EHT cap/oper consistency
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260603/202606031815.lqRk4eKB-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project f43d6834093b19baf79beda8c0337ab020ac5f17)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260603/202606031815.lqRk4eKB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606031815.lqRk4eKB-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/wireless/nl80211.c:12054:8: error: use of undeclared identifier 'params'
    12054 |         if (!!params->he_cap != !!params->he_oper)
          |               ^~~~~~
   net/wireless/nl80211.c:12054:28: error: use of undeclared identifier 'params'
    12054 |         if (!!params->he_cap != !!params->he_oper)
          |                                   ^~~~~~
   net/wireless/nl80211.c:12057:8: error: use of undeclared identifier 'params'
    12057 |         if (!!params->eht_cap != !!params->eht_oper)
          |               ^~~~~~
   net/wireless/nl80211.c:12057:29: error: use of undeclared identifier 'params'
    12057 |         if (!!params->eht_cap != !!params->eht_oper)
          |                                    ^~~~~~
   4 errors generated.


vim +/params +12054 net/wireless/nl80211.c

 12020	
 12021	static int nl80211_parse_counter_offsets(struct cfg80211_registered_device *rdev,
 12022						 const u8 *data, size_t datalen,
 12023						 int first_count, struct nlattr *attr,
 12024						 const u16 **offsets, unsigned int *n_offsets)
 12025	{
 12026		int i;
 12027	
 12028		*n_offsets = 0;
 12029	
 12030		if (!attr)
 12031			return 0;
 12032	
 12033		if (!nla_len(attr) || (nla_len(attr) % sizeof(u16)))
 12034			return -EINVAL;
 12035	
 12036		*n_offsets = nla_len(attr) / sizeof(u16);
 12037		if (rdev->wiphy.max_num_csa_counters &&
 12038		    (*n_offsets > rdev->wiphy.max_num_csa_counters))
 12039			return -EINVAL;
 12040	
 12041		*offsets = nla_data(attr);
 12042	
 12043		/* sanity checks - counters should fit and be the same */
 12044		for (i = 0; i < *n_offsets; i++) {
 12045			u16 offset = (*offsets)[i];
 12046	
 12047			if (offset >= datalen)
 12048				return -EINVAL;
 12049	
 12050			if (first_count != -1 && data[offset] != first_count)
 12051				return -EINVAL;
 12052		}
 12053	
 12054		if (!!params->he_cap != !!params->he_oper)
 12055			return -EINVAL;
 12056	
 12057		if (!!params->eht_cap != !!params->eht_oper)
 12058			return -EINVAL;
 12059	
 12060		return 0;
 12061	}
 12062	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
