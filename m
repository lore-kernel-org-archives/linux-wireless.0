Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317B319EED3
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 06:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785737356; cv=none; b=seBXziYDK5Cft+E41OkEhFZClP/CQ5uc3fW9wroO/Ddcm7rfUWsI6onsgO5FIRR5ri3O/b50imVCIoJegufZSSN05RkHmpA5qjh7qatbOnNQ5krkH+o5y0hbQvmiYuNt716wC40uvRxckLd+MKnh8VAKYXz998grw/70vpYjECo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785737356; c=relaxed/simple;
	bh=99V7caP6QP/UMxzDFZgPmEPZaiX3JkPM/JYdzqOK09c=;
	h=Date:From:To:Cc:Subject:Message-ID; b=nuU0b/gghjqCv9vE+75c3nLjXvLKKdcWACEuwSRqkqca4hYByrjke7ianc4HjU4KOXZ66Lpe3/+A86f5VE4xdF//iNJV8XxOs05sDLK/wbw0a7c1vB7HIWZdkSx39s5tJ+a5ATuQWPAXZZTXyksLgF9828X05hR8lFnQMhDglto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dqudDAl1; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dqudDAl1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785737354; x=1817273354;
  h=date:from:to:cc:subject:message-id;
  bh=99V7caP6QP/UMxzDFZgPmEPZaiX3JkPM/JYdzqOK09c=;
  b=dqudDAl1b+FJDIoYKWV/6hmkDGR70VFssMsF59zOG6uWJuzzr0gz2hub
   O5RpBQhc2YEcDKrdtECY56rpafFCOI1onc+kjwLLoZhs1ejvDXEk7ksaJ
   J/rfy6xpoyn2o2jmAG7ZAviBopAohq/dnYygTXikAi2MOXrhk9ZZbVQHx
   L/GnI7gTK5byc9b74tvLhpHH5pY4b3s3TCHseMc0073kcSwS0AViLz085
   KUMawBXnGwsruad8rjl6B3xIldqwSECuMqlbUjg8lnZPCVmG/0cf3ph55
   l1Nz2QL7FfmpJnMuCSDihNkPP+8OtYSd6iDixBRBbq8ri30bhzwLyQM0b
   Q==;
X-CSE-ConnectionGUID: Tv62qpCZThy/reW7czsFuw==
X-CSE-MsgGUID: /DiTFjv5TZu1KUZOQQndRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11863"; a="96626097"
X-IronPort-AV: E=Sophos;i="6.25,201,1779174000"; 
   d="scan'208";a="96626097"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2026 23:09:13 -0700
X-CSE-ConnectionGUID: 7w+umH5hRxSo3jJJCVgxZA==
X-CSE-MsgGUID: 0xOfoc0YQm+yChDS2DhiJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,201,1779174000"; 
   d="scan'208";a="257787398"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 02 Aug 2026 23:09:11 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wqlrJ-000000006Ep-1BNs;
	Mon, 03 Aug 2026 06:09:09 +0000
Date: Mon, 03 Aug 2026 14:08:33 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD REGRESSION
 6c5fc504d0d6934132637aa3db4b9b58148eaa78
Message-ID: <202608031418.iEFPFMg8-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: 6c5fc504d0d6934132637aa3db4b9b58148eaa78  wifi: cfg80211: stop PMSR before P2P and NAN teardown

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/net/wireless/nxp/nxpwifi/scan.c:2037:1: internal compiler error: in final_scan_insn_1, at final.cc:2823
    net/wireless/nl80211.c:19015:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    |-- drivers-net-wireless-nxp-nxpwifi-scan.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
    `-- net-wireless-nl80211.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 738m

configs tested: 100
configs skipped: 0

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260803    gcc-16.1.0
arc                  randconfig-002-20260803    gcc-8.5.0
arm                  randconfig-001-20260803    gcc-10.5.0
arm                  randconfig-002-20260803    gcc-12.5.0
arm                  randconfig-003-20260803    clang-24
arm                  randconfig-004-20260803    clang-21
arm                          tegra_defconfig    gcc-16.1.0
arm64                randconfig-001-20260803    gcc-8.5.0
arm64                randconfig-002-20260803    clang-24
arm64                randconfig-003-20260803    clang-24
arm64                randconfig-004-20260803    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260803    gcc-10.5.0
csky                 randconfig-002-20260803    gcc-12.5.0
hexagon              randconfig-001-20260803    clang-22
hexagon              randconfig-002-20260803    clang-20
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-14
i386       buildonly-randconfig-001-20260803    clang-22
i386       buildonly-randconfig-002-20260803    clang-22
i386       buildonly-randconfig-003-20260803    gcc-13
i386       buildonly-randconfig-004-20260803    clang-22
i386       buildonly-randconfig-005-20260803    gcc-14
i386       buildonly-randconfig-006-20260803    clang-22
i386                 randconfig-001-20260803    clang-22
i386                 randconfig-002-20260803    clang-22
i386                 randconfig-003-20260803    clang-22
i386                 randconfig-004-20260803    gcc-14
i386                 randconfig-005-20260803    clang-22
i386                 randconfig-006-20260803    gcc-13
i386                 randconfig-007-20260803    clang-22
i386                 randconfig-011-20260803    gcc-14
i386                 randconfig-012-20260803    clang-22
i386                 randconfig-013-20260803    gcc-14
i386                 randconfig-014-20260803    gcc-14
i386                 randconfig-015-20260803    gcc-14
i386                 randconfig-016-20260803    clang-22
i386                 randconfig-017-20260803    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260803    gcc-16.1.0
loongarch            randconfig-002-20260803    clang-18
mips                           gpr_defconfig    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260803    gcc-11.5.0
nios2                randconfig-002-20260803    gcc-10.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260803    gcc-13.4.0
parisc               randconfig-002-20260803    gcc-15.2.0
powerpc              randconfig-001-20260803    gcc-10.5.0
powerpc              randconfig-002-20260803    gcc-16.1.0
powerpc64            randconfig-001-20260803    gcc-12.5.0
powerpc64            randconfig-002-20260803    gcc-8.5.0
riscv                randconfig-001-20260803    gcc-8.5.0
riscv                randconfig-002-20260803    clang-24
s390                 randconfig-001-20260803    gcc-13.4.0
s390                 randconfig-002-20260803    clang-22
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260803    gcc-16.1.0
sh                   randconfig-002-20260803    gcc-12.5.0
sparc                         randconfig-001    gcc-16.1.0
sparc                randconfig-001-20260803    gcc-8.5.0
sparc                randconfig-002-20260803    gcc-16.1.0
sparc64              randconfig-001-20260803    gcc-15.2.0
sparc64              randconfig-002-20260803    clang-24
um                   randconfig-001-20260803    gcc-13
um                   randconfig-002-20260803    clang-24
x86_64     buildonly-randconfig-001-20260803    clang-22
x86_64     buildonly-randconfig-002-20260803    clang-22
x86_64     buildonly-randconfig-003-20260803    gcc-13
x86_64     buildonly-randconfig-004-20260803    gcc-14
x86_64     buildonly-randconfig-005-20260803    gcc-14
x86_64     buildonly-randconfig-006-20260803    gcc-14
x86_64               randconfig-001-20260803    gcc-14
x86_64               randconfig-002-20260803    gcc-14
x86_64               randconfig-003-20260803    gcc-14
x86_64               randconfig-004-20260803    gcc-14
x86_64               randconfig-005-20260803    gcc-14
x86_64               randconfig-006-20260803    gcc-14
x86_64               randconfig-011-20260803    clang-22
x86_64               randconfig-012-20260803    gcc-14
x86_64               randconfig-013-20260803    gcc-14
x86_64               randconfig-014-20260803    clang-22
x86_64               randconfig-015-20260803    clang-22
x86_64               randconfig-016-20260803    gcc-14
x86_64               randconfig-071-20260803    gcc-14
x86_64               randconfig-072-20260803    clang-22
x86_64               randconfig-073-20260803    clang-22
x86_64               randconfig-074-20260803    clang-22
x86_64               randconfig-075-20260803    clang-22
x86_64               randconfig-076-20260803    clang-22
xtensa               randconfig-001-20260803    gcc-8.5.0
xtensa               randconfig-002-20260803    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
