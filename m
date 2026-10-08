Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FF52BEFEB
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 06:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440584; cv=none; b=K9nirRN0Sw4b9QMjlC7sfXGlX/nn5+PI3cS6Xie/kp2VR89LPu7uMIh6jQv2ltE7r4FssaA2rBpHARvr48oe12EZpNJsd2XTPyTxfbWP7zF0v3pF5s1KtSQpk3pn6MVKPMVRm4LANzvy10iKOLQdj9HOsU2O4k9M0HusK4cDoIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440584; c=relaxed/simple;
	bh=4oBWKOzYUpjIQGFDDySEnk+C2atzJAi7V7k2gpnDtbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PR47NjKlWCXweKWU8MgFqX2iJ1RLaqszUWo0LOLcS8uvaXexYe4zGzGlfKxlPp2pS4QJY4g19/RzWy7652+hWfFUBSTsgkJqTr9TBzhmKb99fhdD2CCFt56oclG8KhphxN4COqTOpGIpGXieXF58u/H96Vkkv9W195pWiwudmd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fqS4tyY9; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fqS4tyY9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791440582; x=1822976582;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4oBWKOzYUpjIQGFDDySEnk+C2atzJAi7V7k2gpnDtbQ=;
  b=fqS4tyY9kHQniEr9a2PfOJK99NXJLo83ICfKYh/F1T7yVwggMpYzEB5K
   Kz45BOkq55BvNkMqvIbkm8Zz/3+fZGhqlZ6TxO6yKSRVL8T7xagToUxhV
   IEeomre+PSqzK7B8cNjib7QiDxIBaLx9UTFy3y3ZdecR0VJn+ZhZqCvQY
   aXk7AZIbRIqJrcT48tuwE/5My4rVjqY9+bqTfHoOiQxAekDEHD/fCT5bh
   OGhz8JdiepVYOkOD0r6iidlfBd56qdL1JjgCBCkhJ3cueHvi6z6+dWqTY
   AjubYCDiGUQBTyvNMd4eLtWhOAf/VQWyxRkVABrYPMMSRXd6B9CU0hBJI
   g==;
X-CSE-ConnectionGUID: w2YFhIbuQR2dHLnGG9RT5w==
X-CSE-MsgGUID: WxV0C9E8Q7mWw4DLfMFLWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="211339"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="211339"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 23:23:02 -0700
X-CSE-ConnectionGUID: OwuzOkOfSwmwyuaOl++B/A==
X-CSE-MsgGUID: S2skxvv9QmOp0mRjvHoZxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="277276"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 23:23:00 -0700
Date: Thu, 8 Oct 2026 14:22:56 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Benjamin Berg <benjamin.berg@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, yi1.lai@intel.com
Subject: [linux-next:master] [wifi]  4db13371e2: hwsim.ap_wds_sta_open.fail
Message-ID: <202610081400.f503743b-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hello,

kernel test robot noticed "hwsim.ap_wds_sta_open.fail" on:

commit: 4db13371e217c360cda76578f9eb5e1bcd10a17a ("wifi: mac80211: refactor RX link_id and station handling")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 6474fa070f2b8013b4b87350b775b8c3be6e8aac]

in testcase: hwsim
version: hwsim-x86_64-542b8fd43-1_20260927
with following parameters:

	test: group-14



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 8G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202610081400.f503743b-lkp@intel.com

2026-09-29 15:51:57 ./run-tests.py ap_wds_sta_open
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_wds_sta_open 1/1
Test: Open AP with STA using 4addr mode
Starting AP wlan3
Connect STA wlan0 to AP
Exception during test execution: sending data without carrier won't work
Traceback (most recent call last):
  File "/lkp/benchmarks/hwsim/tests/hwsim/./run-tests.py", line 635, in main
    t(dev, apdev)
    ~^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_ap_params.py", line 389, in test_ap_wds_sta_open
    hwsim_utils.test_connectivity_iface(dev[0], hapd, "wds-br0",
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^
                                        max_tries=15)
                                        ^^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/hwsim_utils.py", line 223, in test_connectivity_iface
    test_connectivity(dev1, dev2, dscp, tos, ifname2=ifname,
    ~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                      max_tries=max_tries, timeout=timeout)
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/hwsim_utils.py", line 217, in test_connectivity
    raise Exception(last_err)
Exception: sending data without carrier won't work
FAIL ap_wds_sta_open 14.718961 2026-09-29 15:52:12.064446


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261008/202610081400.f503743b-lkp@intel.com


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

