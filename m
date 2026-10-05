Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8861A6839
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 04:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791173943; cv=none; b=eRX4G3WFuZe0KV2c2FZaLUEGZ/UMhT140oUZBZjzSeQA6ew2gJbeohyL+q8NHUWyh/kKfOnLoKzvqymPNoopLLJslRkECtFpIZPYYOmDJZcHGyyOxD3t/eW+Owve5FQTRjGZOS1n0S2Ph/2eOkPwyti1cwt/Bzo5Rme2BwMZalw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791173943; c=relaxed/simple;
	bh=7lDBluEQR4X2g1geuIZMoMOgJ0rUI2zR2nUyugoyHN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=br3mCRYS9nlMSd8isEqI23sLYqlB3nY/n660X8gcdJ3Jc5pEo6163gUlxTvWroQJury6QM0LLzyxlE8iaLq/0HIQdCQDy2DeLRmQIVyw/drJuugKsdwlnSEtUeNH+ak/SQ1Qo/NzyhuC5HITvFudd8hhxH65PXNSnNginE+Yb7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KGUqmQfn; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KGUqmQfn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791173940; x=1822709940;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7lDBluEQR4X2g1geuIZMoMOgJ0rUI2zR2nUyugoyHN0=;
  b=KGUqmQfn2owhEAbY0e15iEXTjdzya4CVMsGpzOoDnYS3DFW8fVtjw17N
   cmI8GKqcHhlWUBDiCMflzTQJu+WQNIeZFIikywQJgW18QTuX9uMyQZYvF
   bv43BS2zB9uD/5RLrATXWGETscPJBiHXhWsGmcvKYiz8sNffojXdMhmXD
   DftA1RSIcNo2NwJma3qf+CiVcOo7BVR80uXHw9K1z1EY8jG8k6HzMmx5y
   N673+2ESsZtBAgPkPZhya7A/TooxHCE7t2djhtYL1nyKMfPfgX2ZaSFHC
   xf7OtPJmCQyiRFOjeI/Onf9T9vEOayHRPr6972PBzhpfVsDndqDmhCAV4
   g==;
X-CSE-ConnectionGUID: k8H4dcdiSA6eMnCIOlTfRw==
X-CSE-MsgGUID: zxc+9fKVRhK3zRaFsKSzlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="91943811"
X-IronPort-AV: E=Sophos;i="6.27,141,1787036400"; 
   d="scan'208";a="91943811"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 21:18:59 -0700
X-CSE-ConnectionGUID: kmWAmnpeRLSwkXfPzVbrpA==
X-CSE-MsgGUID: OjYZV8VITb6nddj6FPF7ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,141,1787036400"; 
   d="scan'208";a="284797723"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 04 Oct 2026 21:18:57 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDaAB-00000000VKj-14Qh;
	Mon, 05 Oct 2026 04:18:55 +0000
Date: Mon, 5 Oct 2026 12:18:28 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH wireless-next 03/18] wifi: nl80211: avoid rtnl for
 commands that don't want it
Message-ID: <202610051243.rHmDLV0g-lkp@intel.com>
References: <20261004210122.3b67fb1a6a69.I9c4f85fb60160f377a24c1b8e5173966744e5f09@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004210122.3b67fb1a6a69.I9c4f85fb60160f377a24c1b8e5173966744e5f09@changeid>

Hi Johannes,

kernel test robot noticed the following build warnings:

[auto build test WARNING on wireless-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Johannes-Berg/wifi-cfg80211-track-netdev-running-state-under-wiphy-mutex/20261004-210115
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20261004210122.3b67fb1a6a69.I9c4f85fb60160f377a24c1b8e5173966744e5f09%40changeid
patch subject: [PATCH wireless-next 03/18] wifi: nl80211: avoid rtnl for commands that don't want it
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20261005/202610051243.rHmDLV0g-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 5f609f950d2e80addf5566623013db68394334db)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261005/202610051243.rHmDLV0g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610051243.rHmDLV0g-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/wireless/nl80211.c:244:7: warning: variable 'wdev' is uninitialized when used here [-Wuninitialized]
     244 |             (wdev->netdev && !net_eq(dev_net(wdev->netdev), netns))) {
         |              ^~~~
   net/wireless/nl80211.c:238:27: note: initialize the variable 'wdev' to silence this warning
     238 |         struct wireless_dev *wdev;
         |                                  ^
         |                                   = NULL
   1 warning generated.


vim +/wdev +244 net/wireless/nl80211.c

   227	
   228	/*
   229	 * Lock the given wiphy, put the device and double-check it's
   230	 * still valid to use.
   231	 *
   232	 * Returns with wiphy mutex held unless there was an error.
   233	 */
   234	static struct wireless_dev *
   235	nl80211_lock_and_recheck(struct cfg80211_registered_device *rdev,
   236				 struct net *netns, u32 wdev_id)
   237	{
   238		struct wireless_dev *wdev;
   239	
   240		wiphy_lock(&rdev->wiphy);
   241	
   242		if (!rdev->wiphy.registered ||
   243		    !net_eq(wiphy_net(&rdev->wiphy), netns) ||
 > 244		    (wdev->netdev && !net_eq(dev_net(wdev->netdev), netns))) {
   245			wiphy_unlock(&rdev->wiphy);
   246			put_device(&rdev->wiphy.dev);
   247			return ERR_PTR(-ENODEV);
   248		}
   249	
   250		/*
   251		 * unregistration blocks on wiphy mutex,
   252		 * so we don't need this now
   253		 */
   254		put_device(&rdev->wiphy.dev);
   255	
   256		if (!wdev_id)
   257			return NULL;
   258	
   259		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
   260			if (wdev->identifier == wdev_id)
   261				return wdev;
   262		}
   263		wiphy_unlock(&rdev->wiphy);
   264	
   265		return ERR_PTR(-ENODEV);
   266	}
   267	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
