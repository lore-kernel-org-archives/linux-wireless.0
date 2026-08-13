Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8EE3DF000;
	Thu, 13 Aug 2026 21:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786655733; cv=none; b=QCywOKa85o6/q7nAl23XctN5WlHOHWrrnQ6N5UO1Rm2G9y5U8n07qBXgz3/wVVhZehZUThOVMTe2Q4cjeHFMXD/3FGUIvCwLoBvyQw1dXomZxr/pn/1mx2YBnvVwIs4JfIvDePoeRUKkS9wSQnbLUBx79ndX+iMNrryBx3L7s4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786655733; c=relaxed/simple;
	bh=brUVEV2YYPn4O/fRobquBV2mYMEjl7eMOR6CFz0kQFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RR4HY6R6QqZ0KzpqsurFzwG4iuPF1ty9FzTW5P3KQcOE62I9VKWXp4HE4rI6cXyheq/UzsG4+Oq3NaF5X+7TxjKLImgsNhX6LpqTtzWB1+rBcDoZLoxVcqR3ZAsr5eiCu4qCzfvBw2xEzXbnaxJwMxv1BENCsl+oSjmEWlNt6aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHzOe1Ks; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHzOe1Ks"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786655731; x=1818191731;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=brUVEV2YYPn4O/fRobquBV2mYMEjl7eMOR6CFz0kQFc=;
  b=FHzOe1KsI0YgbHAxDYHBk3rVEnWng9vGfgFrG8nixhL0oSS/KsS7ggqO
   he45PKzgGvSWgRV5FwDU8e+UjrCoY27NgevVZe2HuvoTpO7FhqJrSTYo6
   q39UNNv3SABt6yiULL14ERac9g1+HNaxepNePOCr3iMQcdJV6FuEFCXCp
   HrLY5iexyWGg67qCB5VlQza8QPmZamFRD/adN+2m87nPvvsXMb0lunAR8
   Gk31UYiqQhm+DHL33XJ/A9eHi/BFXMoTRXrME3raV6vSTiVj55FyQiBbH
   3kcUjd6w2mqfo80dcRcp8I27st+0Zar9/mt2zqFrZxMlCrx9zyfZyEJw6
   A==;
X-CSE-ConnectionGUID: Bzi7YsVaQnmOrYPGAByWMg==
X-CSE-MsgGUID: jukUK3ypSGadibyfH22s7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="87000917"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="87000917"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 14:15:28 -0700
X-CSE-ConnectionGUID: LgE5J6FKQQqklkRfqT5m9Q==
X-CSE-MsgGUID: SCoPT7ClRsGipqENgJbesg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="261407574"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 13 Aug 2026 14:15:26 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wucln-00000000Wfq-1gLl;
	Thu, 13 Aug 2026 21:15:23 +0000
Date: Fri, 14 Aug 2026 05:15:12 +0800
From: kernel test robot <lkp@intel.com>
To: Stefan Hansson <newbie13xd@gmail.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
	~postmarketos/upstreaming@lists.sr.ht
Cc: oe-kbuild-all@lists.linux.dev,
	Stefan Hansson <newbyte@postmarketos.org>
Subject: Re: [PATCH] wifi: rsi: Fix types to appease CFI
Message-ID: <202608140519.Tt0pjFLu-lkp@intel.com>
References: <20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org>

Hi Stefan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 95d6a9ccef99117115e41e9adb271243bd5e985b]

url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Hansson/wifi-rsi-Fix-types-to-appease-CFI/20260814-020048
base:   95d6a9ccef99117115e41e9adb271243bd5e985b
patch link:    https://lore.kernel.org/r/20260802-rsi-cfi-fix-v1-1-5821d2cb54ee%40postmarketos.org
patch subject: [PATCH] wifi: rsi: Fix types to appease CFI
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20260814/202608140519.Tt0pjFLu-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260814/202608140519.Tt0pjFLu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608140519.Tt0pjFLu-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/net/wireless/rsi/rsi_91x_usb_ops.c:28 function parameter 'data' not described in 'rsi_usb_rx_thread'
>> Warning: drivers/net/wireless/rsi/rsi_91x_usb_ops.c:28 Excess function parameter 'common' description in 'rsi_usb_rx_thread'
>> Warning: drivers/net/wireless/rsi/rsi_91x_usb_ops.c:28 function parameter 'data' not described in 'rsi_usb_rx_thread'
>> Warning: drivers/net/wireless/rsi/rsi_91x_usb_ops.c:28 Excess function parameter 'common' description in 'rsi_usb_rx_thread'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
