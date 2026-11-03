Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732924;
	b=4fvIWXJkiFllhr1uDajFSYIp0NoWz087U2PpG5qdbcd6FyFTe5clNhYRlSdfN/iFE0Eq
	 Y3YxI98JtDvzHPWH9qRI8Af8GGnOoJ4mFEuzq7YeJq5/KhEp9PVW/c556oPGObyQ80hrW
	 nJh/uwztjAcKzvRd8WPkD99Q3dEoEfBQqK8AKATBCs18QeA9gwcuXvYNM4+bFZzO6dlTt
	 CpfCk3uKS+MBzsGiZNYFRwy8qhsgs4gu9xDJOyhKwUizhjJ8BZMegvXt0SIufapzrI2P+
	 dvVl+eZgYfg4DTo/5h5QYK5foNbpiOKHqxrRhRdBiGQxeH5Lz9C3w3U+PJ3r8pNvhvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732924;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=rG3SFa4AAaUg2yvo0TqdTbNQk1NPMrUpBZbx2RLBuAQ=;
	b=3V4jfN5XFRyxnWmy8TTD6DKxX/tD5j62XTZT6wGWVd/JFrzmLP9FXcC71zMqxnFd0lrZ
	 iGT1IjyE2Zdczh0aK1XPPPOJWysYiSc0Rb9C6FUqeBMCpuXYWjdzv6sKsl/k1y+x+AvMp
	 FtNMtgVJRNLL6qE86eG5nxPwrZeBIU7XGkXsvVHHr0pS7kMWT1FjKY3QervCpzVoleytA
	 gtTN212gkLDtzN/4LH2BK1DxUlkPg0RNWg51RqLK1aiQluNnzY1zn3Uyv6uUrmsn8F7X6
	 t/5FyVwffD7jPolu+YTqyTAkxWI0b+G9Hk916ZmNfBTd12ba29+2Gu7jtWHg89eLVYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fcy8bEvC;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48A5606D818
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 19:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C48A5606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fcy8bEvC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793732924; x=1825268924;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VoL+YQJBeqyynDk8BXstNbG+ukHz+EAdZJX3N6FlF5g=;
  b=fcy8bEvCoqYmj3H9qhVoSlD+22/bwiCYZemD2XBQ5iMBeUMVn9Ct8nEn
   BEUEJ123jrefWN+7szX7m9X5Ka3KPNnCsCU6b/Yo6uczz2leoMSvE+dwM
   Y1Z2kJQRyQ93HfrqMnWwUQa9fTls8zHJOnj2N3d+psBnV0UqwUYnPQ/HN
   ksc9pvbu5i7FRDd9RJt7fMiRQfuWcLpvn9nuqnPC4WHuq1aXpStpwC6Ak
   Cei+8kHUZLQfS2J1gs0w9xJPOpGXatncU1W9C/wSEB5OibCOy1fWu6o1f
   wgOU6zhUHofHG0mj6w6+hLf1KUp107bl9jO/mNkMHcy8yScung2bJ9cno
   g==;
X-CSE-ConnectionGUID: SZsM9uU6R/iQDwEbeKCToA==
X-CSE-MsgGUID: zKNvPzgXT3SrxkofEVwgYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2373027"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2373027"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 11:08:44 -0800
X-CSE-ConnectionGUID: UTRlRhiITj6JeXEnNe6kaQ==
X-CSE-MsgGUID: PO3ZogCmTfWAfS567KyzHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="7032025"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 03 Nov 2026 11:08:42 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOJs7-00000000jBX-01lx;
	Tue, 03 Nov 2026 19:08:39 +0000
Date: Wed, 4 Nov 2026 03:08:06 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH wireless-next 7/7] wifi: mac80211: use sta->active_links
 in for_each_sta_active_link()
Message-ID: <202611040250.cGDVGGwA-lkp@intel.com>
References: <20261102224349.e1d1ed2eef37.I0f5c26e0f6a05feaf5c578fa048ca5586530f0ba@changeid>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102224349.e1d1ed2eef37.I0f5c26e0f6a05feaf5c578fa048ca5586530f0ba@changeid>

Hi Johannes,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Johannes-Berg/wifi-mac80211-clarify-station-link-handling/20261102-224238
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20261102224349.e1d1ed2eef37.I0f5c26e0f6a05feaf5c578fa048ca5586530f0ba%40changeid
patch subject: [PATCH wireless-next 7/7] wifi: mac80211: use sta->active_links in for_each_sta_active_link()
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20261104/202611040250.cGDVGGwA-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261104/202611040250.cGDVGGwA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611040250.cGDVGGwA-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/wireless/intel/iwlwifi/mld/sta.c:913:7: error: use of undeclared identifier 'vif'; did you mean 'if'?
     913 |                 if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
         |                     ^~~
         |                     if
>> drivers/net/wireless/intel/iwlwifi/mld/sta.c:913:7: error: expected expression
   drivers/net/wireless/intel/iwlwifi/mld/sta.c:914:32: error: use of undeclared identifier 'vif'; did you mean 'if'?
     914 |                         iwl_mld_remove_ap_keys(mld, vif, sta, link_id);
         |                                                     ^~~
         |                                                     if
   drivers/net/wireless/intel/iwlwifi/mld/sta.c:914:32: error: expected expression
   4 errors generated.


vim +913 drivers/net/wireless/intel/iwlwifi/mld/sta.c

d1e879ec600f9b Miri Korenblit 2025-02-16  890  
d1e879ec600f9b Miri Korenblit 2025-02-16  891  void iwl_mld_remove_sta(struct iwl_mld *mld, struct ieee80211_sta *sta)
d1e879ec600f9b Miri Korenblit 2025-02-16  892  {
d1e879ec600f9b Miri Korenblit 2025-02-16  893  	struct ieee80211_link_sta *link_sta;
d1e879ec600f9b Miri Korenblit 2025-02-16  894  	u8 link_id;
d1e879ec600f9b Miri Korenblit 2025-02-16  895  
d1e879ec600f9b Miri Korenblit 2025-02-16  896  	lockdep_assert_wiphy(mld->wiphy);
d1e879ec600f9b Miri Korenblit 2025-02-16  897  
d1e879ec600f9b Miri Korenblit 2025-02-16  898  	/* Tell the HW to flush the queues */
d1e879ec600f9b Miri Korenblit 2025-02-16  899  	iwl_mld_flush_sta_txqs(mld, sta);
d1e879ec600f9b Miri Korenblit 2025-02-16  900  
d1e879ec600f9b Miri Korenblit 2025-02-16  901  	/* Wait for trans to empty its queues */
d1e879ec600f9b Miri Korenblit 2025-02-16  902  	iwl_mld_wait_sta_txqs_empty(mld, sta);
d1e879ec600f9b Miri Korenblit 2025-02-16  903  
d1e879ec600f9b Miri Korenblit 2025-02-16  904  	/* Now we can remove the queues */
d1e879ec600f9b Miri Korenblit 2025-02-16  905  	for (int i = 0; i < ARRAY_SIZE(sta->txq); i++)
d1e879ec600f9b Miri Korenblit 2025-02-16  906  		iwl_mld_remove_txq(mld, sta->txq[i]);
d1e879ec600f9b Miri Korenblit 2025-02-16  907  
83b0c8b2692d39 Johannes Berg  2026-11-02  908  	for_each_sta_active_link(sta, link_sta, link_id) {
d1e879ec600f9b Miri Korenblit 2025-02-16  909  		/* Mac8011 will remove the groupwise keys after the sta is
d1e879ec600f9b Miri Korenblit 2025-02-16  910  		 * removed, but FW expects all the keys to be removed before
d1e879ec600f9b Miri Korenblit 2025-02-16  911  		 * the STA is, so remove them all here.
d1e879ec600f9b Miri Korenblit 2025-02-16  912  		 */
67128af05c6419 Johannes Berg  2025-03-09 @913  		if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
d1e879ec600f9b Miri Korenblit 2025-02-16  914  			iwl_mld_remove_ap_keys(mld, vif, sta, link_id);
d1e879ec600f9b Miri Korenblit 2025-02-16  915  
d1e879ec600f9b Miri Korenblit 2025-02-16  916  		/* Remove the link_sta */
d1e879ec600f9b Miri Korenblit 2025-02-16  917  		iwl_mld_remove_link_sta(mld, link_sta);
d1e879ec600f9b Miri Korenblit 2025-02-16  918  	}
d1e879ec600f9b Miri Korenblit 2025-02-16  919  
d1e879ec600f9b Miri Korenblit 2025-02-16  920  	iwl_mld_destroy_sta(sta);
d1e879ec600f9b Miri Korenblit 2025-02-16  921  }
d1e879ec600f9b Miri Korenblit 2025-02-16  922  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
