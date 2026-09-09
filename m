Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523AB54EEB3
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 12:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788956100; cv=none; b=cztW6TghuB0qMqgQwJlE3+3nENRAE885XAy2stnTz0aFszdVFNuV0/u6DnxzcgZopSs0+FAJKu+Mvaz79/75ld2Lw4ngQGnNKgHLnI9jlUJzqAyXsI0UdLblGQ7sXxueTo29Y7T8JEmr/d9mIIoEsC05nBvKjamtFwtfDDd+j1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788956100; c=relaxed/simple;
	bh=gYvuRUGi5vuZCVuYcO4yU+K40+l0p2gz4Srqu6596OM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ReWbQm8rC+TODqEHK/F6rO2TVbs4LCnCypf92MInrdLWsXUhxVpXZyWII6gkNSRXfN+B+qvimbEj+tEvyNtPGlu0miRAEu9slqxovzJVGXU+32WbwKWOqIk8edS5L1Ij/LTPpYQjhHupBohzWgAh9zJ+wovdM15Oad7Luxy5eHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fPEY5cMc; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fPEY5cMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788956098; x=1820492098;
  h=date:from:to:cc:subject:message-id;
  bh=gYvuRUGi5vuZCVuYcO4yU+K40+l0p2gz4Srqu6596OM=;
  b=fPEY5cMcFh0yXpC0HFAvARzJey0Hy/e8fXQV8NdYE0L5JVzBBcGb/9+h
   Q0elurxzGA3m4BP6nzvQx93bSjr8mSN421HEgkv+5RmAtrwHcCxMtMQaf
   Woz45xPqgu+j/JZah34a2AspwY5h6rLHDXgiTLvzQm+ewhbEWkWmgy2bv
   WGophc2C5HKoVGnJ1zxKF6fXHNtybyKywXnXp/Loah2hEc4zeeYdcHzLk
   lIIOVbqkjsRxARxVT6+Fq48KqjfXNbHro8m78mLUbIdXeXcFEBBEhbuy6
   ZQPIYhknjoZgyFks1XVeu09OsI7LrW3ng/oe6jurarNbtF0YHm53S8lrB
   A==;
X-CSE-ConnectionGUID: IcxX6DwHRFO2baLjcXhrfg==
X-CSE-MsgGUID: uj4GEVY8RhKo4BAWdA9y4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89306004"
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="89306004"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 05:14:57 -0700
X-CSE-ConnectionGUID: /pEXc3pHSXOe2+3FH0nVDA==
X-CSE-MsgGUID: 43MDc08PQOGZsieWKhnmgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="269543944"
Received: from lkp-server01.sh.intel.com (HELO a3e91e2cf319) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 09 Sep 2026 05:14:56 -0700
Received: from kbuild by a3e91e2cf319 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4HCY-000000000JS-2Pb4;
	Wed, 09 Sep 2026 12:14:54 +0000
Date: Wed, 09 Sep 2026 20:14:15 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD SUCCESS
 13e51269b6656768dc595ed6025e4974f2026543
Message-ID: <202609092011.X1pvObPo-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: 13e51269b6656768dc595ed6025e4974f2026543  wifi: mac80211: queue frames while off-channel

elapsed time: 1325m

configs tested: 69
configs skipped: 48

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
