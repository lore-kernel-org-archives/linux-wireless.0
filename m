Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793742016;
	b=nHH6TnvvlS63/AyoXIng3ey2vv6HhaH8E97rQio8eSIVYYVZncgaj/GQVumPp6jWRJFw
	 2H3GORHPyaSLP51OLGxnWBHYkviVx30MVDnxHAU+km58aAjP7odtW0FEQfK3oNsVEz5DG
	 uGkmoSveFxfcLzSmSMebaqLcB8MtBwPczARUc4hf/vSKVyOpIrvZnPNiL1aDvd41LApBx
	 9eUAnD9PWnBDJCulMuozb9AxvOa3cGJ2mWI7khvOmL33mo6KpFdYsKMkKP2JPlMoghVzO
	 +Ml4noaI50sv7XoRNPavxy4qDcyZwKVEx1QXrE7A9zUi/Wfi9IreLSRWcNlZesjUg/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793742016;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7qdQAQlhYSGkSsru5xzM4l+rz4yEEX16znLOL4Dtw9Y=;
	b=srfPICHkwIqykWkIsWqDbea3XWZMx0M2D9XmBPVl1kJ79GZNyKyB3RQWVJJQd1GpbNbf
	 k8WzBsjxI4k0MaB2A++sYlo6lfH4I2K18n7j9jBlXdQLhebwFq0DPlAhNridDb+5zcO7y
	 +S3KXtxBIvdR5QZyyaxRP5fXVSuVI9vmlAnDh6Tt95hOiP6/y4QkpiLfGkOnZPV+1FPuu
	 XEYKYAH/zl5T8+EQQ820Kel1NbDFUrxWSKiW/Gr/O34iDpJjtQSMj6UPxuEtzE8MFN9rf
	 ZV5z9uNisXa/xdfYYlOpb/8PR6vQYoJ627fLXgHnO6243ZNsaYBSAmUSdvVIcFiGRCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VkDiXNTv;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0B2606EE90
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 21:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F0B2606EE90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VkDiXNTv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793742015; x=1825278015;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y4YAlZY0RXJwYh3PhGqq/Qx+nx2lAG04O5fFb22NsvQ=;
  b=VkDiXNTv4bmjJxZuoDXJ0duzOxwcf7Cm/+iZA4QLne2WY0/5odQi8tCY
   kiQ4Can+xqM0160wB8ey4sgxIW7J8Q0ywwY/wODmMPvQ9s7w2FFSSVO6q
   878a2KeTX5NqUfCblBizwLkMaXpIxgA3QTYKwjk0q6YvQLS9ZNJnAbs/p
   STNnRxuA/DXPKsArXs/wSIRgQ9RNPfXrCcjPsZUdkMhFLkJUUwGYwIYhE
   uZ6tQjCuxlju7HBkNkoD+zwnyu2vyuJXzmsB0Nmv/s+SAR1I40P/DZigf
   AxezEjaWY22uRHEmtE480N2Jt2o/0JZ5pu59MWeASSshY3df7rsPyQ6CF
   A==;
X-CSE-ConnectionGUID: J/20QGfNRbuey3tFzKT9nw==
X-CSE-MsgGUID: Wb2Is4IsSlG7/i30LWY9FA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2497421"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2497421"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:40:15 -0800
X-CSE-ConnectionGUID: 3q/bqUoxQEGnjFOxkImdGQ==
X-CSE-MsgGUID: Khhneg+CRO2GVgsbFxh4LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6362809"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 03 Nov 2026 13:40:13 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOMEk-00000000jMR-2J7L;
	Tue, 03 Nov 2026 21:40:10 +0000
Date: Wed, 4 Nov 2026 05:40:00 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH wireless-next 7/7] wifi: mac80211: use sta->active_links
 in for_each_sta_active_link()
Message-ID: <202611040513.kvvNKVDo-lkp@intel.com>
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
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20261104/202611040513.kvvNKVDo-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261104/202611040513.kvvNKVDo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611040513.kvvNKVDo-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/wireless/intel/iwlwifi/mld/sta.c: In function 'iwl_mld_remove_sta':
>> drivers/net/wireless/intel/iwlwifi/mld/sta.c:913:21: error: 'vif' undeclared (first use in this function)
     913 |                 if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
         |                     ^~~
   drivers/net/wireless/intel/iwlwifi/mld/sta.c:913:21: note: each undeclared identifier is reported only once for each function it appears in


vim +/vif +913 drivers/net/wireless/intel/iwlwifi/mld/sta.c

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
