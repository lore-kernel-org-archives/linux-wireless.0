Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793853671;
	b=ya62tE8cB8C+HcP7YdmUEFFEhCkiNpQ6OYoA8uiy6xuHVBsWBe3FfcEFoO92Y/jRiJZ/
	 EAgdaQYAdeLMARxz3ThnAWpm0k+7TcBxC/yY19QejsNssk3+038e6GAe2I034yojGGfbA
	 G3tdoqyOZlz9dcUZTyVK33Qp55vKhRyotLshY7j1ZoYWUo4L75Lqc9MUoMyprQ5Tb2W7x
	 fYFe64HOLBuoG6bLrwd3XkD9ObM7vGmal+P2ZEB2VHr0S8AVFG2cIoFqEy9DaZ6i+LnMl
	 poW5Lpp4afa7tHxFm5oXPevc1V3vB5bajGherVCLi6lh27yE7XJPxWn1QkMHQ9Hb1Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793853671;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=+1z1jl80S8glHcdv0ktjwdzA9HN/8y19ZMNtYgwb7/c=;
	b=RduPgqjz4He3F+cxTV1s+wr4miDPCGicKN9g+oEj67tFy4p5yk7H1dSevWfiiOcfL0mT
	 tSDhTVIDZDKINijn3+Xt9RUH4upfYaq/s9rT02oTCLEZI2Wb469lDSp+YsJCKgLSJcaVc
	 n4O31PM7LgpKKIPQibrhqTjwhSU8lQlmU/5d47y+d16aK/DiRcDVlOhDNYnEGaLQfPimy
	 r+lxMuZ3n6x/RYyN/+mmFc6NRy2kEQTW2KKSwEqOSZdrHXDt6D2kFk7AfoFabydp2iKpM
	 YG8zhEh5d+iLfTU+RIK055QgYpRxDq5GZ463FfdKZX79S6SZlUDqVjthx1kAlfG7w2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZhHv3BRC;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9F0606D81E
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 04:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C9F0606D81E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZhHv3BRC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793853670; x=1825389670;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NgMGLhx47NQh2mjCkIp/Ij/G0ICuGhK+dixWqndtdDA=;
  b=ZhHv3BRCJzEpOgklcXY6CLbXgWXvX0aYeSDRFHa8w/eajHKFIvL0YzQB
   1ahWs7ncP0l/A4sxzfxM342vTsPQFW9IfG0BtIVBqhqYAZ0QfRNdvu9IT
   9VROjW5H0OU1QiVuKvrVCedUI3kXh4nGlIZoIhyxCSp3KoT1e1pJMBDIQ
   EiB5vt6He73m1RPGQtwnkW1GkWD5Y4zRMpRU6FejptzY8sPgjZJ3c75It
   4DwK3dmNCkqmwUu1majxGxggyF5IjjNMXKpi0neG95iIjqNHgTZ3DrWfM
   ORZXLvmkAoCFEO7k5AL9pHeED1/5EK8bm7qfvji6suDF/amQgF7w7/6s3
   w==;
X-CSE-ConnectionGUID: 500UuJ0PQF2PLl4z+xtWQg==
X-CSE-MsgGUID: bTwchfPHSw6sIA5U6/LR9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2721493"
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="2721493"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 20:40:52 -0800
X-CSE-ConnectionGUID: 6dZqlJRuSHi0nAMgB+eckw==
X-CSE-MsgGUID: XtY4Ma9ZQ2i8a1be1nrUyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="8670508"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 04 Nov 2026 20:40:50 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOpHK-00000000leN-3q2k;
	Thu, 05 Nov 2026 04:40:46 +0000
Date: Thu, 5 Nov 2026 12:39:47 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH wireless-next 7/7] wifi: mac80211: use sta->active_links
 in for_each_sta_active_link()
Message-ID: <202611051257.yN72uAKg-lkp@intel.com>
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

url:    https://github.com/intel-lab-lkp/linux/commits/Johannes-Berg/wifi-mac80211-rename-ieee80211_sta_activate_link/20261102-224237
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20261102224349.e1d1ed2eef37.I0f5c26e0f6a05feaf5c578fa048ca5586530f0ba%40changeid
patch subject: [PATCH wireless-next 7/7] wifi: mac80211: use sta->active_links in for_each_sta_active_link()
config: um-allmodconfig (https://download.01.org/0day-ci/archive/20261105/202611051257.yN72uAKg-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261105/202611051257.yN72uAKg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611051257.yN72uAKg-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/wireless/intel/iwlwifi/mld/sta.c:6:
   In file included from include/linux/ieee80211.h:19:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:24:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
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
   1 warning and 4 errors generated.


vim +913 drivers/net/wireless/intel/iwlwifi/mld/sta.c

d1e879ec600f9b3 Miri Korenblit 2025-02-16  890  
d1e879ec600f9b3 Miri Korenblit 2025-02-16  891  void iwl_mld_remove_sta(struct iwl_mld *mld, struct ieee80211_sta *sta)
d1e879ec600f9b3 Miri Korenblit 2025-02-16  892  {
d1e879ec600f9b3 Miri Korenblit 2025-02-16  893  	struct ieee80211_link_sta *link_sta;
d1e879ec600f9b3 Miri Korenblit 2025-02-16  894  	u8 link_id;
d1e879ec600f9b3 Miri Korenblit 2025-02-16  895  
d1e879ec600f9b3 Miri Korenblit 2025-02-16  896  	lockdep_assert_wiphy(mld->wiphy);
d1e879ec600f9b3 Miri Korenblit 2025-02-16  897  
d1e879ec600f9b3 Miri Korenblit 2025-02-16  898  	/* Tell the HW to flush the queues */
d1e879ec600f9b3 Miri Korenblit 2025-02-16  899  	iwl_mld_flush_sta_txqs(mld, sta);
d1e879ec600f9b3 Miri Korenblit 2025-02-16  900  
d1e879ec600f9b3 Miri Korenblit 2025-02-16  901  	/* Wait for trans to empty its queues */
d1e879ec600f9b3 Miri Korenblit 2025-02-16  902  	iwl_mld_wait_sta_txqs_empty(mld, sta);
d1e879ec600f9b3 Miri Korenblit 2025-02-16  903  
d1e879ec600f9b3 Miri Korenblit 2025-02-16  904  	/* Now we can remove the queues */
d1e879ec600f9b3 Miri Korenblit 2025-02-16  905  	for (int i = 0; i < ARRAY_SIZE(sta->txq); i++)
d1e879ec600f9b3 Miri Korenblit 2025-02-16  906  		iwl_mld_remove_txq(mld, sta->txq[i]);
d1e879ec600f9b3 Miri Korenblit 2025-02-16  907  
4fa80ba223dd728 Johannes Berg  2026-11-02  908  	for_each_sta_active_link(sta, link_sta, link_id) {
d1e879ec600f9b3 Miri Korenblit 2025-02-16  909  		/* Mac8011 will remove the groupwise keys after the sta is
d1e879ec600f9b3 Miri Korenblit 2025-02-16  910  		 * removed, but FW expects all the keys to be removed before
d1e879ec600f9b3 Miri Korenblit 2025-02-16  911  		 * the STA is, so remove them all here.
d1e879ec600f9b3 Miri Korenblit 2025-02-16  912  		 */
67128af05c6419e Johannes Berg  2025-03-09 @913  		if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
d1e879ec600f9b3 Miri Korenblit 2025-02-16  914  			iwl_mld_remove_ap_keys(mld, vif, sta, link_id);
d1e879ec600f9b3 Miri Korenblit 2025-02-16  915  
d1e879ec600f9b3 Miri Korenblit 2025-02-16  916  		/* Remove the link_sta */
d1e879ec600f9b3 Miri Korenblit 2025-02-16  917  		iwl_mld_remove_link_sta(mld, link_sta);
d1e879ec600f9b3 Miri Korenblit 2025-02-16  918  	}
d1e879ec600f9b3 Miri Korenblit 2025-02-16  919  
d1e879ec600f9b3 Miri Korenblit 2025-02-16  920  	iwl_mld_destroy_sta(sta);
d1e879ec600f9b3 Miri Korenblit 2025-02-16  921  }
d1e879ec600f9b3 Miri Korenblit 2025-02-16  922  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
