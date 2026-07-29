Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F322A306754
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 05:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785302552; cv=none; b=RU4bQw8JEQZ3kqyxlGfF3nq4us/vzO2glwXxZSzxkzpISdOWyyW7Fy6Ik0Vm/5Ww5BqEMjqVNsCSFTgdkeN9AYeh4jLBlIBBa3RTsSOcQMSi6eyfP2n48zRBkeWNdQPngVsJsuOG+KaWfz5oX8EccJjiGGIBg5zuPIZ2iV/XkP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785302552; c=relaxed/simple;
	bh=qnm8EsVtTo1aTzaC1+ZJk+U2j6fIL7nB6cC9/rLzQdo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=BuFP9FMHD4yx97kpc0R6jbnIWJCG7mAwjsSHBujRc/4qB4tVCq40h9aOm6m918+wB3Q/fLCDyR2NoZBkrS7+x368+JZTvRuDQfz3ivIKpqzSqMA+ahy8fTGc0aWu/AnLxu9GmDM1tU52Yx5Eqr4HKvcYHf7UqOFtvoecc59yqso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GpLqOhZN; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GpLqOhZN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785302551; x=1816838551;
  h=date:from:to:cc:subject:message-id;
  bh=qnm8EsVtTo1aTzaC1+ZJk+U2j6fIL7nB6cC9/rLzQdo=;
  b=GpLqOhZNXllwLnDci5mjCcq2D6TYMWq+EOEW1ogosG1GwciaglvE/c0h
   GDA6fQtjn97TB3mYX4bA0jL4RNn9/osl5fwHxOAmINnGJGQV5auiX+79/
   Z0dyPaLIhEnEisfBS9BN3r65UAQnbCxEpCjqXcN9hatGgad84IA+7UKQT
   5CITSK/jY3+EpmtN5mdy6M65lkDXDkbCfPT2zPsFKF/McLA0p75I5HoVI
   JNtU+4mexReyBip/GPR4pBMxCQJbiFmb53cC3LKf3pn1DZEZ/Z466btv9
   HR3M8RXMiACmNbjdCzbb4oqdFkf4/jsubvH0FYi8vsSh3GdY5iHajqwyS
   Q==;
X-CSE-ConnectionGUID: PCZLQL42QuKxh6rZOD9Yow==
X-CSE-MsgGUID: CYLhdq1MRHWqhn45B1Seow==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="108696443"
X-IronPort-AV: E=Sophos;i="6.25,191,1779174000"; 
   d="scan'208";a="108696443"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2026 22:22:31 -0700
X-CSE-ConnectionGUID: Ntx5CntKSaKfcuUFDeeeaw==
X-CSE-MsgGUID: e+Goi6q/S9yadYjWjZjtog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,191,1779174000"; 
   d="scan'208";a="263402296"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 28 Jul 2026 22:22:29 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wowkN-00000000f4E-1dkD;
	Wed, 29 Jul 2026 05:22:27 +0000
Date: Wed, 29 Jul 2026 13:21:51 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:main] BUILD REGRESSION
 4a0bd262df757b25fc4e2a53c947317c119ced4e
Message-ID: <202607291338.WTxUyXOP-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
branch HEAD: 4a0bd262df757b25fc4e2a53c947317c119ced4e  wifi: mac80211: fix per-STA profile length in cross-link CSA parsing

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/net/wireless/nxp/nxpwifi/scan.c:2037:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    `-- drivers-net-wireless-nxp-nxpwifi-scan.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 803m

configs tested: 106
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260729    gcc-8.5.0
arc                  randconfig-002-20260729    gcc-8.5.0
arm                  randconfig-001-20260729    gcc-8.5.0
arm                  randconfig-002-20260729    gcc-8.5.0
arm                  randconfig-003-20260729    gcc-8.5.0
arm                  randconfig-004-20260729    gcc-8.5.0
arm64                randconfig-001-20260729    clang-17
arm64                randconfig-002-20260729    clang-17
arm64                randconfig-003-20260729    clang-17
arm64                randconfig-004-20260729    clang-17
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260729    clang-17
csky                 randconfig-002-20260729    clang-17
hexagon              randconfig-001-20260729    gcc-9.5.0
hexagon              randconfig-002-20260729    gcc-9.5.0
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260729    gcc-14
i386       buildonly-randconfig-002-20260729    gcc-14
i386       buildonly-randconfig-003-20260729    gcc-14
i386       buildonly-randconfig-004-20260729    gcc-14
i386       buildonly-randconfig-005-20260729    gcc-14
i386       buildonly-randconfig-006-20260729    gcc-14
i386                 randconfig-001-20260729    clang-22
i386                 randconfig-002-20260729    clang-22
i386                 randconfig-003-20260729    clang-22
i386                 randconfig-004-20260729    clang-22
i386                 randconfig-005-20260729    clang-22
i386                 randconfig-006-20260729    clang-22
i386                 randconfig-007-20260729    clang-22
i386                 randconfig-011-20260729    gcc-14
i386                 randconfig-012-20260729    gcc-14
i386                 randconfig-013-20260729    gcc-14
i386                 randconfig-014-20260729    gcc-14
i386                 randconfig-015-20260729    gcc-14
i386                 randconfig-016-20260729    gcc-14
i386                 randconfig-017-20260729    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260729    gcc-9.5.0
loongarch            randconfig-002-20260729    gcc-9.5.0
m68k                       m5272c3_defconfig    gcc-16.1.0
mips                       bcm63xx_defconfig    clang-24
mips                     maltaaprp_defconfig    clang-17
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260729    gcc-9.5.0
nios2                randconfig-002-20260729    gcc-9.5.0
parisc                          alldefconfig    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260729    clang-24
parisc               randconfig-002-20260729    clang-24
powerpc                    ksi8560_defconfig    gcc-16.1.0
powerpc                mpc8313_rdb_defconfig    gcc-16.1.0
powerpc              randconfig-001-20260729    clang-24
powerpc              randconfig-002-20260729    clang-24
powerpc64            randconfig-001-20260729    clang-24
powerpc64            randconfig-002-20260729    clang-24
riscv            nommu_k210_sdcard_defconfig    gcc-16.1.0
riscv                randconfig-001-20260729    gcc-15.2.0
riscv                randconfig-002-20260729    gcc-15.2.0
s390                 randconfig-001-20260729    gcc-15.2.0
s390                 randconfig-002-20260729    gcc-15.2.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260729    gcc-15.2.0
sh                   randconfig-002-20260729    gcc-15.2.0
sparc                randconfig-001-20260729    gcc-10.5.0
sparc                randconfig-002-20260729    gcc-10.5.0
sparc64              randconfig-001-20260729    gcc-10.5.0
sparc64              randconfig-002-20260729    gcc-10.5.0
um                   randconfig-001-20260729    gcc-10.5.0
um                   randconfig-002-20260729    gcc-10.5.0
x86_64     buildonly-randconfig-001-20260729    clang-22
x86_64     buildonly-randconfig-002-20260729    clang-22
x86_64     buildonly-randconfig-003-20260729    clang-22
x86_64     buildonly-randconfig-004-20260729    clang-22
x86_64     buildonly-randconfig-005-20260729    clang-22
x86_64     buildonly-randconfig-006-20260729    clang-22
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    clang-22
x86_64               randconfig-001-20260729    clang-22
x86_64               randconfig-002-20260729    clang-22
x86_64               randconfig-003-20260729    clang-22
x86_64               randconfig-004-20260729    clang-22
x86_64               randconfig-005-20260729    clang-22
x86_64               randconfig-006-20260729    clang-22
x86_64               randconfig-011-20260729    gcc-14
x86_64               randconfig-012-20260729    gcc-14
x86_64               randconfig-013-20260729    gcc-14
x86_64               randconfig-014-20260729    gcc-14
x86_64               randconfig-015-20260729    gcc-14
x86_64               randconfig-016-20260729    gcc-14
x86_64               randconfig-071-20260729    gcc-12
x86_64               randconfig-072-20260729    gcc-12
x86_64               randconfig-073-20260729    gcc-12
x86_64               randconfig-074-20260729    gcc-12
x86_64               randconfig-075-20260729    gcc-12
x86_64               randconfig-076-20260729    gcc-12
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260729    gcc-10.5.0
xtensa               randconfig-002-20260729    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
