Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793809140;
	b=eH7f7yiw8/2OrSZRsHz8KQUKgYoAjbIxWDoalkYdY72knHd+g0gxmj7653mJnIGygIa3
	 0KId6nOu3e8EXv3VsZ6mR8+emDDDWmb3alXA2m92R2oc4f/CneJJCix8ICtYOedrMcqu4
	 NAHiOFEWsSdHUrfHwAS8JrctP3K1bsr4xRB833ThdBeDXdaH/zgrV+SkMgsjTm+BDA+Hn
	 bu/25YNW3B1SwjvrNvd37KsNJU3iuL158b2jz0EZzA5Cc5M4hKMjl8qeG2cThmepOtjUj
	 2ml/JWcpQMyRzhiUPZJyUxkLVw6a76STeIIsfYLa2TKPWaL4IfvKiok+V87RHClzH+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809140;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=hWt8Nh5aa/NAaAQcdUS3NCzDpZ9vbHpEVRswZNG5YNg=;
	b=CH2abzLL4tZXtyWnG19OD/SQVSakJDd/cJMNIOoAzf2ZzHnwsMzD8uXvBgTqNP58ydEl
	 is15rwsCjAneV2+PsBLloEcAclIjgpber6zRtNh9QWCSj9u4wyuOE4UVZiQqEU4+KmupL
	 tal8zLWJrYyx3MgMidefP7Y2iMJxd7xJ1gxe9/fVSH4wOFhLIHl3xrhsyjo02wYXFi0i1
	 wN67Ku7nMnKytM4LgU76BjHyOoePbNzsep0Vh2e6CbM7HDbPSISuZiw6X2dQY48MGXsxJ
	 PByOfSULda3KR77KumpNOkTcfW1LKTnU1i97fOy72oGcJDzFYFJy2KyyUoXrG1YJsxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZKVwi9iN;
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5D7606AADF
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 16:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC5D7606AADF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZKVwi9iN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793809139; x=1825345139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sYiOQuBYqid09I+mMVkZpI/PoAwNsfLnhRc6uGZfzTU=;
  b=ZKVwi9iNWJK4F0oC4m3JzpRE53vryChTBqSXw7WSTzr4apv32lW7D/FT
   fFrMjR+/fpovgdLV964RQGzkgXlz11Bj5nmq4vhLbCb5Itnxd1caWlkWJ
   Sc3EIHbuTXAN2iXonZ+xHBkVCWT7JnGuy7PmwrQIrA5pFjLFAyTu6Rhxg
   cJ4I6tEPcJjeV2srk/W+CrJn2yRdnbgSin5dJt4zCs1pq89jNejetATNi
   JrM5Iwj5/PIL86du1DbcOlyqQiT9wFrcB21eUToAMo6S4M5mtAkhVgKwv
   5X6zbYGtZu+xLGsBntc8LBmxVKGdKlHryRM/Gn0TZ4FZ4eMF8HVsh6tiP
   w==;
X-CSE-ConnectionGUID: GJlPtKqwQyOqLDUz7hGVMQ==
X-CSE-MsgGUID: XHFfbOK7RNa3DgOj8pIx4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2448591"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2448591"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 08:18:59 -0800
X-CSE-ConnectionGUID: +1oYTMjAQwCDn4EDRbS2uA==
X-CSE-MsgGUID: PGkM6NguSFaT5yeXHJhF9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="6639445"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 04 Nov 2026 08:18:57 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOdhO-00000000keZ-27lq;
	Wed, 04 Nov 2026 16:18:54 +0000
Date: Thu, 5 Nov 2026 00:18:00 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH wireless-next 7/7] wifi: mac80211: use sta->active_links
 in for_each_sta_active_link()
Message-ID: <202611042348.ZiFAbrdl-lkp@intel.com>
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
config: openrisc-allmodconfig (https://download.01.org/0day-ci/archive/20261104/202611042348.ZiFAbrdl-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261104/202611042348.ZiFAbrdl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611042348.ZiFAbrdl-lkp@intel.com/

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
4fa80ba223dd72 Johannes Berg  2026-11-02  908  	for_each_sta_active_link(sta, link_sta, link_id) {
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
