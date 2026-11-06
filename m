Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934116;
	b=ACGCJGh+t8/GpKDZ4q9uVzFtIvQycbbPvK2pJ7ToAjP+lsR5+/KRa1kr2p2d+6QI00Ms
	 LmkmyoPhug7ozSHCjpOgSSDUiRIVNa19ihcHtcvsnDILCIIJfzNzi6kUgB5KYkoXLkUXw
	 u7YNllLOkHTeAhmpEudleloR6k3nnogGsWg+wNZ1vk8acdSSAYkcFwCbA2FYC7WCsyC4K
	 SyGUIxMQHwgP4d/OKOu5gwuDZSGmlKG3Gki7hl+Il8CrDYnoYLE095hVFDr9fmRbBsPH0
	 QVm2N2x5dLyhSE3UOdOSIbJOz9a6tWSYyA+6+romQiiHIEQHJIsyk7SVs7kO79NBfPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934116;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=n90xYOYRecs+yLRqpuRRcGw8wdLml7i48qgV7WcSPdY=;
	b=xpyLOXYtr3O7urasCdLtkAPU+57UJOrqwZTDvBZNjcFS/eRgd/+mzor5YBQiN68icDZ+
	 AtLWWwivhVJWuKxgP6QGx0/Gm9Sia1HCHUh9lac20u1koZ2hnTHdmIKzrrx+QnHwBUGae
	 APtKBFQtTNkoRZraW/ijivHnKNHvd3wk34GkgqRz/gse5R1Ohk2hY+f9izTtannBu8+zB
	 MPfqX2tItecMOD63Td0cKO2UfO6QMgDEh74WMgjh5opQJ0FbgBbvCiZRI3sny3UBCFUXH
	 DuiVX/fBrlZTt9NWcfSImRmC9HDZw4zHx9qYr0uYngOVhNBtupDhAZxrQH7guLpWmsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cYpico84;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F61606A329;
	Fri,  6 Nov 2026 03:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76F61606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cYpico84
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793934115; x=1825470115;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l7Th8NqpzkzSbTd9bubw0RIf0Ptss2DMkEUq3dw8Fl8=;
  b=cYpico8499fNRENTxbDvAZs7AQoV8aJbsxH9I8HkZymlOmn2z7HmsGKU
   YXmvOSxvPMaELhLOEeFjOYiFTVGrHXaPwCLTaqVs8vqSmt92GQJqfZ73E
   R6YV0irKRdcum6z228hGFr7u3K0H223jjhA+xWpUi1rFwZvUUnr+TLCvW
   v3ca1I6NUOocqnrD1xvEOmkLi8SPnVNY2yHY+2LUMcop1cJfkvg2cX6hC
   jRcZ0ZCgopgfntY4ivxWr4Ls1PynGLSyf25djb91/+lWTnhKu6H1+DgAB
   WIjUGfXyUFZWgIVba4vMYXV1KIr6NvFU7HnOkId0evaC6Szg3E1+dNa9F
   A==;
X-CSE-ConnectionGUID: rXGvVeKFRK2aQVrxTFrrJA==
X-CSE-MsgGUID: LaG8NCXDTHai1OhQy/Gwqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2622024"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2622024"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 19:01:55 -0800
X-CSE-ConnectionGUID: EW294U1XSmGsQ9ZUSGqIWA==
X-CSE-MsgGUID: UUKxHlTgQ1OdfRcP2OmXiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7732913"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 05 Nov 2026 19:01:53 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPAD8-00000000nDj-3eZ2;
	Fri, 06 Nov 2026 03:01:50 +0000
Date: Fri, 6 Nov 2026 11:01:48 +0800
From: kernel test robot <lkp@intel.com>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	pooventhiran.g@oss.qualcomm.com
Subject: Re: [PATCH wireless-next v3 15/21] wifi: mac80211: filter uplink and
 downlink frames based on SMD states
Message-ID: <202611061037.MK46LPkJ-lkp@intel.com>
References: <20261106-smd-v3-15-1723950e3cf8@oss.qualcomm.com>
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
In-Reply-To: <20261106-smd-v3-15-1723950e3cf8@oss.qualcomm.com>

Hi Pooventhiran,

kernel test robot noticed the following build warnings:

[auto build test WARNING on b8e5b0ae8ff47240366d38e5d12c65f878724316]

url:    https://github.com/intel-lab-lkp/linux/commits/Pooventhiran-G/wifi-nl80211-define-Seamless-Mobility-Domain-SMD-device-capability/20261106-010836
base:   b8e5b0ae8ff47240366d38e5d12c65f878724316
patch link:    https://lore.kernel.org/r/20261106-smd-v3-15-1723950e3cf8%40oss.qualcomm.com
patch subject: [PATCH wireless-next v3 15/21] wifi: mac80211: filter uplink and downlink frames based on SMD states
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20261106/202611061037.MK46LPkJ-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261106/202611061037.MK46LPkJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611061037.MK46LPkJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/mac80211/tx.c:318:48: warning: overlapping comparisons always evaluate to true [-Wtautological-overlap-compare]
     318 |             (tx->sdata->vif.type != NL80211_IFTYPE_AP ||
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~
     319 |              tx->sdata->vif.type != NL80211_IFTYPE_AP_VLAN) ||
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +318 net/mac80211/tx.c

   310	
   311	static ieee80211_tx_result debug_noinline
   312	ieee80211_tx_h_smd_state(struct ieee80211_tx_data *tx)
   313	{
   314		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
   315		__le16 fc = hdr->frame_control;
   316	
   317		if (!tx->sta ||
 > 318		    (tx->sdata->vif.type != NL80211_IFTYPE_AP ||
   319		     tx->sdata->vif.type != NL80211_IFTYPE_AP_VLAN) ||
   320		    !test_sta_flag(tx->sta, WLAN_STA_ASSOC) ||
   321		    !(tx->flags & IEEE80211_TX_UNICAST))
   322			return TX_CONTINUE;
   323	
   324		switch (tx->sta->smd_state) {
   325		case IEEE80211_STA_SMD_NONE:
   326			break;
   327		case IEEE80211_STA_SMD_PREP:
   328			/* 4a: Class 3 disallowed except ST Execution Response */
   329			if (ieee80211_is_st_exec_resp(tx->skb))
   330				break;
   331			if (ieee80211_is_class3(tx->skb))
   332				return TX_DROP;
   333			break;
   334		case IEEE80211_STA_SMD_EXEC:
   335			/* 4b: no restriction */
   336			break;
   337		case IEEE80211_STA_SMD_DRAIN:
   338			/* 4c: Class 3 disallowed except Data, Control,
   339			 * UHR Reconfiguration Notify
   340			 */
   341			if (ieee80211_is_ctl(fc) || ieee80211_is_data(fc) ||
   342			    ieee80211_is_uhr_link_reconf_notify(tx->skb))
   343				break;
   344			if (ieee80211_is_class3(tx->skb))
   345				return TX_DROP;
   346			break;
   347		}
   348	
   349		return TX_CONTINUE;
   350	}
   351	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
