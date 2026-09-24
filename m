Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2336283142
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 13:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258271; cv=none; b=AdPhl031KoScKxDWs26yHpzjZS14He2RB/sBzsGN7Sk8972QmTRDGNsz4vfTVFarqra+oRQAQFLYz33oH1vBoYxYHDhNKHTt6R4Cs+UBxE1GCjuNixuRmZp7Z93tfnK+xiEUkM+82QTqLDlec9uk7VBO5RNB8z3vvmxWe0NKk9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258271; c=relaxed/simple;
	bh=lXAHGFLmbcXwrwmqZWdV93zM4vk4p0KhnUr1VFAA2Nw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=gFIUxwh9LDXgSdNA/2cJAoN9NeGF7fTlTs5SV44naJh6m+sPZTnSl1QKDvfEnVE7Ys+PKpwbOECl+fNMB3m3SyHPEFssujvROYbkPPaK906RMfwH5mCZw+SumN3hL2tErZ3zqNJX+SBelmTykerHLV7G1up56P2SmHvycdZBCKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C4iwKxLF; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C4iwKxLF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790258269; x=1821794269;
  h=date:from:to:cc:subject:message-id;
  bh=lXAHGFLmbcXwrwmqZWdV93zM4vk4p0KhnUr1VFAA2Nw=;
  b=C4iwKxLFhW+Hnh9BS8HN0wAjln0E5kC0vox//m1Ms79XyOl52peEKKMh
   Sg44ddDzVxAOQ6W7Awc5oQBJrryuxyfUjOkx4uOxMbMvmPqe2RAYipe8T
   qWeELCCDWik/My3MDwcFu4nPaouZ170QERfSzHU8zNq1232Z2UjRvUvrW
   HxMIZs+luW3AcmfLgmpTQ2UTV1B1jSk8OuV/oFZC7vvgR9xPqa5jGUVOs
   hEWHNUN7P+vFVdidsVtIcL1xkWK4UXRkdXi6HarE2sVmCuM24L3BS8SKq
   /VoIyhbd0tNjuwzj7LX8idy/C5j/re1jEziDdlqLj9EBU7Hqfqe1QUyOs
   Q==;
X-CSE-ConnectionGUID: s1AvKxY1QxSbrgRn0Y+Pcw==
X-CSE-MsgGUID: 0BCVNn7TTyClBMnA2oAjyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="93747612"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="93747612"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 06:57:48 -0700
X-CSE-ConnectionGUID: qOskvRXYThKMFi1+BhEAKQ==
X-CSE-MsgGUID: 25s1garSQr+xi4mQDBLYxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="273609080"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 24 Sep 2026 06:57:47 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9jxJ-00000000Iu8-0BJj;
	Thu, 24 Sep 2026 13:57:45 +0000
Date: Thu, 24 Sep 2026 21:56:54 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:merge-2026-09-21] BUILD SUCCESS
 3b136ea0e92d6243753f1a5d91fd917dfd7bd9fc
Message-ID: <202609242152.MoVM5lfH-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git merge-2026-09-21
branch HEAD: 3b136ea0e92d6243753f1a5d91fd917dfd7bd9fc  Merge remote-tracking branch 'wireless-next/main'

elapsed time: 4126m

configs tested: 276
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r1305-20260924    gcc-14.3.0 sparse
alpha                randconfig-r2104-20260923    gcc-12.5.0 cocci
alpha                randconfig-r2107-20260923    gcc-10.5.0 cocci
alpha                randconfig-r2107-20260923    gcc-12.5.0 cocci
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                           axs103_defconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                      haps_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-1000-20260924    clang-24
arc                   randconfig-1001-20260924    clang-24
arc                  randconfig-r1306-20260924    clang-24   sparse
arc                  randconfig-r2202-20260923    gcc-14.3.0 smatch
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                       integrator_defconfig    gcc-16.1.0
arm                         mvebu_v7_defconfig    gcc-16.1.0
arm                            omap1_defconfig    clang-20
arm                   randconfig-1000-20260924    clang-24
arm                   randconfig-1001-20260924    clang-24
arm                   randconfig-1002-20260924    clang-24
arm                   randconfig-1003-20260924    clang-24
arm                  randconfig-r1302-20260924    gcc-14.3.0 sparse
arm                  randconfig-r2100-20260923    gcc-8.5.0  cocci
arm                  randconfig-r2101-20260923    gcc-8.5.0  cocci
arm                  randconfig-r2201-20260923    gcc-16.1.0 smatch
arm                         spear3xx_defconfig    clang-20
arm                            spitz_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260924    gcc-11.5.0
arm64                 randconfig-1001-20260924    gcc-11.5.0
arm64                 randconfig-1002-20260924    gcc-11.5.0
arm64                 randconfig-1003-20260924    gcc-11.5.0
arm64                randconfig-r1307-20260924    gcc-11.5.0 sparse
arm64                randconfig-r2200-20260923    clang-24   smatch
arm64                randconfig-r2202-20260923    clang-24   smatch
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260924    gcc-11.5.0
csky                  randconfig-1001-20260924    gcc-11.5.0
csky                 randconfig-r1303-20260924    gcc-14.3.0 sparse
csky                 randconfig-r2103-20260923    gcc-8.5.0  cocci
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260924    gcc-8.5.0
hexagon               randconfig-1001-20260924    gcc-8.5.0
hexagon              randconfig-r2202-20260923    clang-24   smatch
i386                              alldefconfig    gcc-16.1.0
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260924    gcc-14
i386        buildonly-randconfig-1001-20260924    gcc-14
i386        buildonly-randconfig-1002-20260924    gcc-14
i386        buildonly-randconfig-1003-20260924    gcc-14
i386        buildonly-randconfig-1004-20260924    gcc-14
i386        buildonly-randconfig-1005-20260924    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260924    gcc-12
i386                  randconfig-1001-20260924    gcc-12
i386                  randconfig-1002-20260924    gcc-12
i386                  randconfig-1003-20260924    gcc-12
i386                  randconfig-1004-20260924    gcc-12
i386                  randconfig-1005-20260924    gcc-12
i386                  randconfig-1006-20260924    gcc-12
i386                  randconfig-1007-20260924    clang-22
i386                  randconfig-1008-20260924    clang-22
i386                  randconfig-1009-20260924    clang-22
i386                  randconfig-1010-20260924    clang-22
i386                  randconfig-1011-20260924    clang-22
i386                  randconfig-1012-20260924    clang-22
i386                  randconfig-1013-20260924    clang-22
i386                  randconfig-1300-20260924    clang-22   sparse
i386                  randconfig-1301-20260924    clang-22   sparse
i386                  randconfig-1302-20260924    clang-22   sparse
i386                  randconfig-2100-20260923    clang-22   cocci
i386                  randconfig-2101-20260923    clang-22   cocci
i386                  randconfig-2102-20260923    clang-22   cocci
i386                  randconfig-2103-20260923    clang-22   cocci
i386                  randconfig-2200-20260923    gcc-12     smatch
i386                 randconfig-r1306-20260924    gcc-11.5.0 sparse
i386                 randconfig-r2107-20260923    clang-22   cocci
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260924    gcc-8.5.0
loongarch             randconfig-1001-20260924    gcc-8.5.0
loongarch            randconfig-r1307-20260924    gcc-11.5.0 sparse
loongarch            randconfig-r2104-20260923    gcc-10.5.0 cocci
loongarch            randconfig-r2105-20260923    gcc-14     cocci
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                           amiga_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                        m5249evb_defconfig    gcc-16.1.0
m68k                         m5307c3_defconfig    gcc-16.1.0
m68k                           multi_defconfig    clang-20
m68k                         mvme16x_defconfig    clang-20
m68k                             q40_defconfig    clang-20
m68k                 randconfig-r1300-20260924    gcc-14.3.0 sparse
m68k                 randconfig-r2105-20260923    gcc-10.5.0 cocci
m68k                 randconfig-r2201-20260923    gcc-11.5.0 smatch
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2104-20260923    clang-22   cocci
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                        bmips_be_defconfig    gcc-16.1.0
mips                 randconfig-r1309-20260924    gcc-11.5.0 sparse
mips                 randconfig-r2201-20260923    clang-22   smatch
mips                         vocore2_defconfig    clang-20
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260924    gcc-8.5.0
nios2                 randconfig-1001-20260924    gcc-8.5.0
nios2                randconfig-r1306-20260924    gcc-11.5.0 sparse
nios2                randconfig-r2100-20260923    gcc-15.2.0 cocci
nios2                randconfig-r2103-20260923    gcc-8.5.0  cocci
nios2                randconfig-r2105-20260923    clang-22   cocci
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260924    gcc-8.5.0
parisc                randconfig-1001-20260924    gcc-8.5.0
parisc               randconfig-r1301-20260924    gcc-14.3.0 sparse
parisc               randconfig-r1307-20260924    clang-24   sparse
parisc               randconfig-r2100-20260923    gcc-8.5.0  cocci
parisc               randconfig-r2104-20260923    gcc-14     cocci
parisc               randconfig-r2106-20260923    gcc-10.5.0 cocci
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                      ksi8560_defconfig    gcc-16.1.0
powerpc                       mgcoge_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260924    gcc-8.5.0
powerpc               randconfig-1001-20260924    gcc-8.5.0
powerpc              randconfig-r2102-20260923    gcc-15.2.0 cocci
powerpc              randconfig-r2106-20260923    clang-22   cocci
powerpc              randconfig-r2200-20260923    gcc-8.5.0  smatch
powerpc                         warp_defconfig    clang-20
powerpc64             randconfig-1000-20260924    gcc-8.5.0
powerpc64             randconfig-1001-20260924    gcc-8.5.0
powerpc64            randconfig-r1309-20260924    gcc-11.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv              nommu_k210_sdcard_defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260924    gcc-15.2.0
riscv                 randconfig-1001-20260924    gcc-15.2.0
riscv                 randconfig-2000-20260923    gcc-9.5.0
riscv                 randconfig-2001-20260923    gcc-9.5.0
riscv                randconfig-r2105-20260923    gcc-12.5.0 cocci
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260924    gcc-15.2.0
s390                  randconfig-1001-20260924    gcc-15.2.0
s390                  randconfig-2000-20260923    gcc-9.5.0
s390                  randconfig-2001-20260923    gcc-9.5.0
s390                 randconfig-r1308-20260924    gcc-11.5.0 sparse
s390                 randconfig-r2200-20260923    gcc-8.5.0  smatch
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                      magicpanelr2_defconfig    clang-20
sh                    randconfig-1000-20260924    gcc-15.2.0
sh                    randconfig-1001-20260924    gcc-15.2.0
sh                    randconfig-2000-20260923    gcc-9.5.0
sh                    randconfig-2001-20260923    gcc-9.5.0
sh                   randconfig-r1304-20260924    gcc-14.3.0 sparse
sh                   randconfig-r1309-20260924    clang-24   sparse
sh                   randconfig-r2103-20260923    gcc-15.2.0 cocci
sh                         sh7785lcr_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260924    clang-17
sparc                 randconfig-1001-20260924    clang-17
sparc                 randconfig-2000-20260923    gcc-14.3.0
sparc                 randconfig-2001-20260923    gcc-14.3.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260924    clang-17
sparc64               randconfig-1001-20260924    clang-17
sparc64               randconfig-2000-20260923    gcc-14.3.0
sparc64               randconfig-2001-20260923    gcc-14.3.0
sparc64              randconfig-r1308-20260924    gcc-11.5.0 sparse
sparc64              randconfig-r2101-20260923    gcc-15.2.0 cocci
sparc64              randconfig-r2102-20260923    gcc-8.5.0  cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260924    clang-17
um                    randconfig-1001-20260924    clang-17
um                    randconfig-2000-20260923    gcc-14.3.0
um                    randconfig-2001-20260923    gcc-14.3.0
um                   randconfig-r1308-20260924    clang-24   sparse
um                   randconfig-r2200-20260923    gcc-14     smatch
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20260924    clang-22
x86_64      buildonly-randconfig-1001-20260924    clang-22
x86_64      buildonly-randconfig-1002-20260924    clang-22
x86_64      buildonly-randconfig-1003-20260924    clang-22
x86_64      buildonly-randconfig-1004-20260924    clang-22
x86_64      buildonly-randconfig-1005-20260924    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260924    clang-22
x86_64                randconfig-1001-20260924    clang-22
x86_64                randconfig-1002-20260924    clang-22
x86_64                randconfig-1003-20260924    clang-22
x86_64                randconfig-1004-20260924    clang-22
x86_64                randconfig-1005-20260924    clang-22
x86_64                randconfig-1006-20260924    clang-22
x86_64                randconfig-1007-20260924    clang-22
x86_64                randconfig-1008-20260924    clang-22
x86_64                randconfig-1009-20260924    clang-22
x86_64                randconfig-1010-20260924    clang-22
x86_64                randconfig-1011-20260924    clang-22
x86_64                randconfig-1012-20260924    clang-22
x86_64                randconfig-1013-20260924    clang-22
x86_64                randconfig-1014-20260924    clang-22
x86_64                randconfig-1015-20260924    clang-22
x86_64                randconfig-1016-20260924    clang-22
x86_64                randconfig-1017-20260924    clang-22
x86_64                randconfig-1300-20260924    clang-22   sparse
x86_64                randconfig-1301-20260924    clang-22   sparse
x86_64                randconfig-1302-20260924    clang-22   sparse
x86_64                randconfig-2100-20260923    clang-22   cocci
x86_64                randconfig-2101-20260923    clang-22   cocci
x86_64                randconfig-2102-20260923    clang-22   cocci
x86_64                randconfig-2103-20260923    clang-22   cocci
x86_64                randconfig-2200-20260923    gcc-14     smatch
x86_64               randconfig-r2101-20260923    gcc-8.5.0  cocci
x86_64               randconfig-r2106-20260923    gcc-14     cocci
x86_64               randconfig-r2107-20260923    gcc-14     cocci
x86_64               randconfig-r2201-20260923    clang-22   smatch
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                            alldefconfig    gcc-16.1.0
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20260924    clang-17
xtensa                randconfig-1001-20260924    clang-17
xtensa                randconfig-2000-20260923    gcc-14.3.0
xtensa                randconfig-2001-20260923    gcc-14.3.0
xtensa               randconfig-r2102-20260923    gcc-8.5.0  cocci
xtensa               randconfig-r2106-20260923    gcc-12.5.0 cocci
xtensa               randconfig-r2202-20260923    gcc-10.5.0 smatch

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
