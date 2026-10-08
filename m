Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5956B443C27
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 08:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448740; cv=none; b=uBRFftEkXb7tYHkFzbZ1SufF1aYiJ0Y9GPLbzp0NTGXGk4mUYQf8l64IqlVWlLU/r+ABenYPRQpyfB8oUDK82LP3Z6P5JrfcoWybfm5aSTmIB7oK6DNc10LhOVn9d2ODyn25C6yoqXx9LGGh4rDrGe3P6vS1sJiF6vpHYylCkwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448740; c=relaxed/simple;
	bh=GblcdbZKeYp5qNEZNB2RrtJUugRE9E6Zb4MEMze7YVA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rKdyQ1zkRNXA0G2/iRFNL4Y2C0FAhbtlrvlRYfv9GiZHposYkB+eP7Kmu8Szo7HrX50qPpJy0ETzGvR7t+tHOPzPS0L0KFKV86CJzHjpf00+RiYdeZdsMKzfMEGQjVtuNudrfKd+Y9zxFvuZA8LHb/mQ/vCZFJnNumEKCUmg5j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBLCjVDm; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBLCjVDm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791448740; x=1822984740;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=GblcdbZKeYp5qNEZNB2RrtJUugRE9E6Zb4MEMze7YVA=;
  b=WBLCjVDmocDnT0gFNmK+fD2jvm93dPzXd2trWE+uZzjM4j0JlaYXN35u
   DrYDkwIbSxnz6uhiTnIUYRwmrGB0Qb+Vd6eADRVLBz6WYXSUnQxX6f7fK
   kdabj3HQsBCIH867pjmY9CQC5BQKwzTFkDdDd3TiDcV/HWVkt2XThUEPN
   OOitK+05NGo8XJJta3dZj1NrKg69aH9MRjlkhbhCjT4l56LWjXkIe1XgX
   UpyNe/o+10O1uFcbv1SNY3hWY6yRaEcWtNVB1KgFX4iA7kD/Bx7t0aOS7
   FU7fRCl8ewqGCm8gTdvw5M8Hr6J8X21u4g6aR8vjh9vbAXnW9eKcuiv1+
   Q==;
X-CSE-ConnectionGUID: 4yCC7B90SKGUEr2WW2683g==
X-CSE-MsgGUID: JofSBjVuSSGsHCGiu0jEAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="232949"
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="232949"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 01:39:00 -0700
X-CSE-ConnectionGUID: jhNVz3OxS5ObehKpYRcG/A==
X-CSE-MsgGUID: OCgbpf71QTmADOfGqOlgPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="1720738"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 01:38:56 -0700
Date: Thu, 8 Oct 2026 16:38:52 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Benjamin Berg <benjamin.berg@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, yi1.lai@intel.com
Subject: [linux-next:master] [wifi]  6d531b9af1:
 hwsim.ap_pmf_ap_dropping_sa.fail
Message-ID: <202610081606.2e786210-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Hello,

kernel test robot noticed "hwsim.ap_pmf_ap_dropping_sa.fail" on:

commit: 6d531b9af16ea84aab72db573384fa94bfa0f2f7 ("wifi: mac80211: rework RX packet handling")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 6474fa070f2b8013b4b87350b775b8c3be6e8aac]

in testcase: hwsim
version: hwsim-x86_64-542b8fd43-1_20260927
with following parameters:

	test: group-28

config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790 v3 @ 3.60GHz (Haswell) with 6G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202610081606.2e786210-lkp@intel.com

2026-09-29 22:22:47 ./run-tests.py ap_pmf_ap_dropping_sa
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ap_pmf_ap_dropping_sa 1/1
Test: WPA2-PSK PMF AP dropping SA
Starting AP wlan3
Connect STA wlan0 to AP
Exception during test execution: Locally generated disconnection not reported
Traceback (most recent call last):
  File "/lkp/benchmarks/hwsim/tests/hwsim/./run-tests.py", line 635, in main
    t(dev, apdev)
    ~^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_ap_pmf.py", line 440, in test_ap_pmf_ap_dropping_sa
    raise Exception("Locally generated disconnection not reported")
Exception: Locally generated disconnection not reported
FAIL ap_pmf_ap_dropping_sa 6.459052 2026-09-29 22:22:54.598333
passed 0 test case(s)
skipped 0 test case(s)
failed tests: ap_pmf_ap_dropping_sa

The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261008/202610081606.2e786210-lkp@intel.com

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

