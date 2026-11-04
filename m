Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814503;
	b=vvi23XfEZerXMPZvHkonw212SGvqvj+o1whj8nJ8q8e0zCVH95rf8JIDsWwRXv1+54qi
	 Mx41D+Iez/ftCgsYhUvgtz5L81XP7mrpFNwOeq2TTKHSxLsgUbBEeajG1nPlgpWRNnZhl
	 DQVIQPmDLyyW2L5oslyNzGQya+cnyeZ/LB7Fesa/8wWGXaRJGgXys555tquNOt9uIW/x7
	 5lhuY0iiaVdoSLcdwoi9uwi9RWZ1pEmF0yS7Notd3kLhwfOs4OtAZY5pO/WbDa8+WK5O3
	 emGwtBDOh26qhLgT/opHa1atVd0hiMcsuWg1YiGZDqHVO/N90HXG72R3v9HcpGqfEug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814503;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=tq7IoD6yji3CA3UfNNagARQUoCp3JvhYDQlnNNTxN8M=;
	b=A3uSyNRHiZu1rGt4bCzmZEr4DoVsWFwgu/Wp5W3L+Ntmo9wRmjaf/qXUgz6Mhq5AOohS
	 FOkO/x8xlm9ctLmtUnMT/Gq7pb7PPtYzas+Qu4pJ9tSU7hNaEXo8Jd2Df+u406qnuf4wz
	 e+FiEwkaL7wZk/Hzi3+nZzfkoSH+nOmNJHo7OvBseIgfDlmHICwEkCIBuE1yy7virXPXn
	 SE9JklA6g5IUTrZke/wFBhlBhghOm32PRTJeaJdn/X3hY43q2k5Jav4ukSflPPRIhIMji
	 Z5S7EpeG8ulYcQZNBeEBGjFlTt0Zjtl7CNrv2sAEzkoJ3ARze+G6CMYAALT62qrFPSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Zgmzsxe6;
	arc=none smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF90E606A331
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 17:48:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF90E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Zgmzsxe6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793814502; x=1825350502;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=icpdKJ+0niq0nYCtA2vfEffSOgXeLUS0eW9q5qpYy3g=;
  b=Zgmzsxe633hVy3wBh2TB0SyyuX6yxW8CAPFHXnTqn2UTWLYFssO2LU/Z
   Zmju4TA2dseMZqzOwFCR3g94TzOaEjdNNd65ebO7MkeHI2JHMcDifQYdL
   1MmnGKtYwnB4bgbJveNGrbQ0KbO19rCJsmosy0Yt4vwUxP9KbhvNM+O+1
   //WOatY4oAgINo/dCcwi/BCAlnAY5h5Hx1osWbLpM1wGwb206bfuuXiwK
   h48retZ+LFH6z2hcaKrJxGaeGxa9IdCuk4Yn9BhVY1NfpS3h5/xXkE8W3
   OARVGJBnOJXP4aEgGvzLxtnZ/7rGEUNwyQ04eLla4zHSFfr3cMyMLyRDq
   w==;
X-CSE-ConnectionGUID: I1Y1qlodT2Ky4a5QBO9a5g==
X-CSE-MsgGUID: vMo71TsISIGeK/s6Fqj46A==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2613997"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2613997"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 09:48:21 -0800
X-CSE-ConnectionGUID: FVoAJvDaShGaiBQw/PTi+A==
X-CSE-MsgGUID: e1y7x+ebSaOaXSGNPUYquQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="7138092"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 04 Nov 2026 09:48:21 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOf5t-00000000knv-3fqd;
	Wed, 04 Nov 2026 17:48:17 +0000
Date: Thu, 5 Nov 2026 01:47:26 +0800
From: kernel test robot <lkp@intel.com>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, johannes@sipsolutions.net
Subject: Re: [PATCH wireless-next 08/18] wifi: cfg80211: add KUnit tests for
 the SCS classifier
Message-ID: <202611050107.DAV4Z5Au-lkp@intel.com>
References: <86f50b8e75254418218c0c32399d272dea638cac.1793722802.git-series.nbd@nbd.name>
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
In-Reply-To: <86f50b8e75254418218c0c32399d272dea638cac.1793722802.git-series.nbd@nbd.name>

Hi Felix,

kernel test robot noticed the following build errors:

[auto build test ERROR on 991a73f4909f1348ffb4b38765cdb522a775e4c2]

url:    https://github.com/intel-lab-lkp/linux/commits/Felix-Fietkau/wifi-cfg80211-add-the-TCLAS-element-parsers/20261103-172334
base:   991a73f4909f1348ffb4b38765cdb522a775e4c2
patch link:    https://lore.kernel.org/r/86f50b8e75254418218c0c32399d272dea638cac.1793722802.git-series.nbd%40nbd.name
patch subject: [PATCH wireless-next 08/18] wifi: cfg80211: add KUnit tests for the SCS classifier
config: x86_64-randconfig-1015-20261104 (https://download.01.org/0day-ci/archive/20261105/202611050107.DAV4Z5Au-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261105/202611050107.DAV4Z5Au-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611050107.DAV4Z5Au-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: net/wireless/tests/cfg80211-tests.ko: symbol 'cfg80211_mscs_desc_valid' undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
