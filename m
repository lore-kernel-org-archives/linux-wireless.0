Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793665350;
	b=HMADLBYZtHZdR81n9UeVVhEPlUa4tqz9KWaDrV481rdXtWlXR5FWWv0ucyMez17g7lnT
	 Ktvbh0ixPvtcjulTniKQUBUAPu+PlsHWvEzU1gTIoHNeHAchta5B95LZPwix5IuNjF51c
	 hpRu63oLcTScNvUVo0JeHOqBixFUC5hef2C19H0dPE3BP+xI7tolYTngwUvUBTFHlO+y7
	 rFLXxD5J5g9Cg+JGSN0Tp2bVl18admytQLiF9sCSpYkRYF4RMHK/cZfRRhEMcNtXkjzSf
	 tm5WE5Y0CVMVXoq+qwLWZThH8X3n2OJa8ccAI8yu8rcis6OumlWay+ZXwfbC8wk9YqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793665350;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Xo23pX0LkqDaqeUDm7pphUOpOZD0A0t29LsZLUd6y+w=;
	b=nflhltSsybsZrfZtjgmuwfR69YXytNpX/myz6cKePdLoySwgDjPT35waQy6xjK85uLlj
	 wtNCVAIis+V86o5A5PhRa/Ew7iHuSLciZeD6GfqPrgjmAvYRbskBJ+I48VxE0VsfJngV1
	 5fPsMWpGrk31cPyp2yPKe3qMzotEKdFl3T6C6+3OeQShXKThpLbNINOUcSKSFEamwY51A
	 2Iu5M34W2ct7MnC0PuTgAzsYgzhe9TrWiyV+UizcWN5Ixv+pMN34GkvbPEi0vTl+cx4Hx
	 eOpLKHRcGZI3mXRu5nmI32RdzB5cNLgIEcmPuprXyFbw8xSVrCxLAypL9N7jGX0ymHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qq+FAJfy;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F9D606D80B;
	Tue,  3 Nov 2026 00:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07F9D606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qq+FAJfy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793665349; x=1825201349;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xBQkxZD2qmYmXTlHQrUaab8BxBJ6qbBDJIm+K6hAggk=;
  b=Qq+FAJfy/Bk26zwisD69o+//daW27vznDV/Xuwap3LjOFUM/DuDsXl5p
   qqikcI4Z2MQ5MvUho+qbPveOVBZyom5/ABi+Hs6N9OH4xBTG01WH7pGuo
   idViaTJGixGa8rFI/AKK4rUJtgBkvK7CpeTlGmh3R0Q61tRqJydWQtSPV
   EOzLycHhkjxXFW3vpkRdw69DpqmxWWfcm7RitDvOgnlTYZdhUD1z52I8Y
   xjPJc6ZXi5Tfv6C3uWuimWGM3fJoPreamp9BqKyn0b+7PhfRFhvtz0tyb
   m+WrTMgWm/3NufKZs2q9UM6LSllnSF5EATA+9MYpwP/vmVlUL4A78umLv
   w==;
X-CSE-ConnectionGUID: oG0hahULQ22lmGQhgrz8tA==
X-CSE-MsgGUID: r3AdOqumTvSEGLXxvior9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2255648"
X-IronPort-AV: E=Sophos;i="6.27,192,1787036400"; 
   d="scan'208";a="2255648"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 16:22:28 -0800
X-CSE-ConnectionGUID: TepHzMvJQ8SEPar/wdwHVA==
X-CSE-MsgGUID: Yb20lfD8Rt6X3iiUOVSHRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,192,1787036400"; 
   d="scan'208";a="6607032"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 02 Nov 2026 16:22:27 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xO2IC-00000000i5I-0ILN;
	Tue, 03 Nov 2026 00:22:24 +0000
Date: Tue, 3 Nov 2026 08:21:25 +0800
From: kernel test robot <lkp@intel.com>
To: Viktor Korsnes <viktor.korsnes@remarkable.no>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Viktor Korsnes <viktor.korsnes@remarkable.no>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless 1/2] wifi: nxpwifi: fix hex parsing in
 nxpwifi_parse_cal_cfg()
Message-ID: <202611030826.7OV08JJo-lkp@intel.com>
References: <20261102121856.1011263-1-viktor.korsnes@remarkable.no>
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
In-Reply-To: <20261102121856.1011263-1-viktor.korsnes@remarkable.no>

Hi Viktor,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Viktor-Korsnes/wifi-nxpwifi-add-missing-header-to-HOST_CMD_CFG_DATA/20261102-131800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git main
patch link:    https://lore.kernel.org/r/20261102121856.1011263-1-viktor.korsnes%40remarkable.no
patch subject: [PATCH wireless 1/2] wifi: nxpwifi: fix hex parsing in nxpwifi_parse_cal_cfg()
config: i386-buildonly-randconfig-1002-20261103 (https://download.01.org/0day-ci/archive/20261103/202611030826.7OV08JJo-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261103/202611030826.7OV08JJo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611030826.7OV08JJo-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/wireless/nxp/nxpwifi/sta_cmd.c:1405:8: error: call to undeclared function 'hex2bin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1405 |                             hex2bin(d, s, 1))
         |                             ^
   1 error generated.


vim +/hex2bin +1405 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c

  1393	
  1394	static u32 nxpwifi_parse_cal_cfg(u8 *src, size_t len, u8 *dst, size_t dst_size)
  1395	{
  1396		u8 *s = src, *d = dst;
  1397	
  1398		while (s - src < len) {
  1399			if (*s && (isspace(*s) || *s == '\t')) {
  1400				s++;
  1401				continue;
  1402			}
  1403			if (isxdigit(*s)) {
  1404				if (d - dst >= dst_size || src + len - s < 2 ||
> 1405				    hex2bin(d, s, 1))
  1406					return 0;
  1407				d++;
  1408				s += 2;
  1409			} else {
  1410				s++;
  1411			}
  1412		}
  1413	
  1414		return d - dst;
  1415	}
  1416	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
