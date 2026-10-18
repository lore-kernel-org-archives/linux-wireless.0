Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF5D1CAA6C;
	Sun, 18 Oct 2026 07:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792307066; cv=none; b=d0l8P4WTJIxfQSwWWYEM01W2+5UTQs4ew40Y9AwOH/G8XCPEAUrTYlk6wkwrX1Sft8nSLd07Fqz6rVsf9eAF6iXyQ+Dh9m2b7DlZ38uCGqqZDQo3OL7f4gMQ6iazPcLQPaJHZTpv5cHrWA5vjfb2T7fp3iH/KlNjCcrTuj2bZwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792307066; c=relaxed/simple;
	bh=aMaS2RzqBspWDoLnSOlIzZikUYyiN7HpCUnFYTqtx/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGfDWNyOxFyX8JAH3AQWLv4AcXcn+Lv9cL5F4RjY7Smt+nwNQleMPWRiOY6yJ0v37bHp4cGOVSlWSl++ZlgnS3Xqa/T82J8/Dk81FMm5yGyEnWA4Ai0hYfjobjBQOY3D/ShhSqHvV1PmQTGadh+oesgIf5vtXvR8ACetEPfryNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PVUM9F2R; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PVUM9F2R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792307065; x=1823843065;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aMaS2RzqBspWDoLnSOlIzZikUYyiN7HpCUnFYTqtx/0=;
  b=PVUM9F2RP4SVAEreiqGnKp8tvvi16u0WGMZuKzScipl3c9lF/FockH8P
   QjOLR8SSi8DhDxyIAx1vr5zBDNtydjIgSswlXBbhPvmrq+SZ/Om3oA77T
   md7u4CyctSw/erUb9ZvLXmB5oBV2BdPDCCZ72m0EeRT2Bnlne60ljble5
   o7v/tsMwuisxL0R36ZFJLLfKBXU3vrwcfB8TD57XaAsFPwqGV0xyTV3K3
   qS0lE43+DiVhVQXkWGaGhslGapk+rgeZpT3dQVEY5YD7QCvYdc+DK6EtK
   8Z5eKuu4NK0I8Cwsx/2uB21XNIbLJJbv6fLCAR/WbBSj5lh4k+/1PUVZd
   w==;
X-CSE-ConnectionGUID: Irabib5WQJG782KHG/LC6A==
X-CSE-MsgGUID: SNT/wfVJSdeYKl2fsID6nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11938"; a="1057734"
X-IronPort-AV: E=Sophos;i="6.27,165,1787036400"; 
   d="scan'208";a="1057734"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2026 00:04:25 -0700
X-CSE-ConnectionGUID: yv+wtpsrRBaO/3RzXFSFnw==
X-CSE-MsgGUID: faXAPn5gQfGkQ0LwieHvzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,165,1787036400"; 
   d="scan'208";a="2266683"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 18 Oct 2026 00:04:23 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIKwO-00000000KDW-2Dsd;
	Sun, 18 Oct 2026 07:04:20 +0000
Date: Sun, 18 Oct 2026 15:04:04 +0800
From: kernel test robot <lkp@intel.com>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: b43: keep the N-PHY TX power control from
 drifting while idle
Message-ID: <202610181522.20QDqray-lkp@intel.com>
References: <20261017005156.1260496-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017005156.1260496-1-rosenp@gmail.com>

Hi Rosen,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Rosen-Penev/wifi-b43-keep-the-N-PHY-TX-power-control-from-drifting-while-idle/20261016-175156
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git main
patch link:    https://lore.kernel.org/r/20261017005156.1260496-1-rosenp%40gmail.com
patch subject: [PATCH wireless] wifi: b43: keep the N-PHY TX power control from drifting while idle
config: x86_64-randconfig-1010-20261018 (https://download.01.org/0day-ci/archive/20261018/202610181522.20QDqray-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261018/202610181522.20QDqray-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610181522.20QDqray-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: drivers/net/wireless/broadcom/b43/b43.ko: symbol 'b43_nphy_txpctl_ofdm_tx' undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
