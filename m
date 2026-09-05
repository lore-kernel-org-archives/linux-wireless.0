Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2854D345EC6
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 20:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639003; cv=none; b=ArMzau2ZRFel51ZGI7AhfT/OgpHp/c+QMA79hIrwc8HlrsNyVnziRmyhPferyG9DYwFAKOwA96q/cLGSfY9JO0FcynMGaGYjWHxNusgzT7iYYMmgejmxpQB4DIGq/jjlPkkpIYrAw4EfuM9oqrV/r02o5fqw/PO+WlRIfLJ0Wg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639003; c=relaxed/simple;
	bh=r69cd/xOH5IoJ+VWKkqwfoBNAP/s3A0j6bL6CYCoKOQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=WgaY/6C4eAlZ4Es8cGwrMoGvhSJ9nKntVcG2HMPpQL+9Ddn/esk6g3ALE1ZrmUQnwcvTT14aAEXT/5KjBXl+sja+XlR5cOK7r04B6YGSnLFzxvOozQiJrrEXNVEUEW6zCT4EiON5+AkblbdI/rs0p5n7esAPGTuon/z4ocHeUr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jpZK9qbt; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jpZK9qbt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788639002; x=1820175002;
  h=date:from:to:cc:subject:message-id;
  bh=r69cd/xOH5IoJ+VWKkqwfoBNAP/s3A0j6bL6CYCoKOQ=;
  b=jpZK9qbtCAahRqL0bNDSW2/L/mVrb9t56bwTDvP7+7zYQWEqvs6/WzpU
   yeFC6eO1OfHfibbmVnAqRUvDdH6/UVcNXJwJa2WpHlsbH9XSZSaABairQ
   Ft9SCrf1LLmye4KDEsrBXrfS8IiRVStREExnIf5CywYhEZLYV0mw92I+D
   ZQgGpyBEYkHIN0sf+/shO8H/NILFLjbkEmJuuz01VVhepGRTbglsqaLOC
   bKfQSEQd8OWzLDJYeM/zj8lfwaSMsQ1NAjGp90w+/37utDbUaQb39Xup2
   MVFD9Y2rYDR5F1BYkl34AqZi+etPpCvfpXcPE09Yo3SkurUl3SardyVQf
   Q==;
X-CSE-ConnectionGUID: Ty7G/V26QBiuA99AJtc3Ug==
X-CSE-MsgGUID: eRxwvSrtRCitSBleEHgjhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11897"; a="100263659"
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="100263659"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2026 13:10:01 -0700
X-CSE-ConnectionGUID: G1ld8m6IQaa5GJaTjHGq5Q==
X-CSE-MsgGUID: 8AoJfCUzQO21IdA2G3xzWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="272290859"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 05 Sep 2026 13:10:00 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2wi6-0000000014D-1gs1;
	Sat, 05 Sep 2026 20:09:58 +0000
Date: Sun, 06 Sep 2026 04:09:26 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless:for-next] BUILD SUCCESS
 da2ca406f45a6e21760243152ed8d2e8e72915c2
Message-ID: <202609060424.bN6zFvWs-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git for-next
branch HEAD: da2ca406f45a6e21760243152ed8d2e8e72915c2  wifi: mac80211: avoid WARN in set_bitrate_mask when sdata not in driver

elapsed time: 1965m

configs tested: 55
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2         allnoconfig    clang-24
openrisc     allmodconfig    clang-20
openrisc      allnoconfig    clang-24
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc       allyesconfig    clang-17
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh           allyesconfig    clang-17
sparc         allnoconfig    clang-24
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa       allyesconfig    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
