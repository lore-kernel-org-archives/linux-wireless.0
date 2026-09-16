Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD4B3BBFAD
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789573970; cv=none; b=ptzeU//X5yxusnZyy7k1SzOHjKVapl+mauXtdOc0l8dt1wiwVWQ74VTBhDua3NC8xrFvOOLzNz2ZN67P56VAPJXG1a6ni5q98BURzaFqufaZ8QLK33WHMQ6t3Hz9t4pZg0iTHZdW/LuC//NPIl4sTPwMJiedDQqihO+VQFdtbMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789573970; c=relaxed/simple;
	bh=aTiFAOeGxWczNSqjOVeu7BcwnouX2ukNXR40TRT5dUc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=esmck1BeoIAFbK7UwzA59NrqOhQRO9zSfQk+Gdl92QvEdE6uqXq47srmPyU6SpaMxLStNzRLBcaZdwO8ydHtrIHlGYGn4Gb96cmcwsG9i/EWT1rtiPHhgfRYzp7MP5S0YfR3WCqqHwMsR95viDwDO6MW1m5jVFAXXLHRKK0z0CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KaJbSmhc; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KaJbSmhc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789573967; x=1821109967;
  h=date:from:to:cc:subject:message-id;
  bh=aTiFAOeGxWczNSqjOVeu7BcwnouX2ukNXR40TRT5dUc=;
  b=KaJbSmhc4+oVdop9fTFTKUDE+QhoF/PilkZw0Les3yrJxlg6/Aea1LL9
   XXcqr9LbELJg16o42dJTHqXl5zffDcjDX4vJGgW/Dd1gNQm9Bn2PiUPdC
   2n50TIbeOmHq3wimf4VS7ekM32I8cyNBKALTISaPD0uYHTCWd3tWNRXdR
   4SVZBMvlc6P1FYjTbq6PgcL02vNQ3pVkqEDPT+Ohp8KBokhf9fenKDxpw
   yOdwKRtR15IXSpJc9kgi0+4ZdLlFKecm0pO+7dY3IzS/1vPUj7zfEOyHv
   ZSRop5DvvGwamnCNWTL9f8IA4nj0DJlrj5MijKWSoQ0T4lU8+9MWV+SZm
   g==;
X-CSE-ConnectionGUID: BS4dghGJQRCA1coAUyzfPA==
X-CSE-MsgGUID: TaoT5+RqR4W26yCifpYr/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89091012"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89091012"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 08:52:45 -0700
X-CSE-ConnectionGUID: FRiDvLVgRgSH5BfO1/rfkQ==
X-CSE-MsgGUID: THjUAjssQAic3MqDMaLTZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="296859892"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 16 Sep 2026 08:52:44 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6rwA-000000006JF-1Qb5;
	Wed, 16 Sep 2026 15:52:42 +0000
Date: Wed, 16 Sep 2026 23:51:38 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless:for-next] BUILD SUCCESS
 1eeca1d5e0920fbdad6449768fd2d4364e714180
Message-ID: <202609162325.3BTCUAAi-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git for-next
branch HEAD: 1eeca1d5e0920fbdad6449768fd2d4364e714180  wifi: brcmsmac: fix UAF in brcms_free_timer()

elapsed time: m

configs tested: 354
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                 randconfig-r063-20260915    gcc-13.4.0
alpha                 randconfig-r073-20260915    gcc-14.3.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                  nsimosci_hs_smp_defconfig    clang-20
arc                    randconfig-001-20260916    clang-24
arc                    randconfig-002-20260916    clang-24
arc                   randconfig-1000-20260916    gcc-10.5.0
arc                   randconfig-1001-20260916    gcc-10.5.0
arc                  randconfig-r1307-20260916    gcc-16.1.0 sparse
arc                  randconfig-r1308-20260916    gcc-16.1.0 sparse
arc                         vdk_hs38_defconfig    clang-22
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                        aspeed_g4_defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                            h3600_defconfig    clang-20
arm                             hisi_defconfig    clang-20
arm                       jornada720_defconfig    clang-24
arm                              mxs_defconfig    clang-20
arm                              pxa_defconfig    clang-22
arm                    randconfig-001-20260916    clang-24
arm                    randconfig-002-20260916    clang-24
arm                    randconfig-003-20260916    clang-24
arm                    randconfig-004-20260916    clang-24
arm                   randconfig-1000-20260916    gcc-10.5.0
arm                   randconfig-1001-20260916    gcc-10.5.0
arm                   randconfig-1002-20260916    gcc-10.5.0
arm                   randconfig-1003-20260916    gcc-10.5.0
arm                   randconfig-r061-20260915    clang-22
arm                   randconfig-r071-20260916    clang-19
arm                   randconfig-r072-20260915    clang-17
arm                  randconfig-r1306-20260916    gcc-13.4.0 sparse
arm                         realview_defconfig    clang-24
arm                            spitz_defconfig    clang-24
arm                            tegra_defconfig    clang-20
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                  randconfig-001-20260916    gcc-16.1.0
arm64                  randconfig-002-20260916    gcc-16.1.0
arm64                  randconfig-003-20260916    gcc-16.1.0
arm64                  randconfig-004-20260916    gcc-16.1.0
arm64                 randconfig-1000-20260916    gcc-14.3.0
arm64                 randconfig-1001-20260916    gcc-14.3.0
arm64                 randconfig-1002-20260916    gcc-14.3.0
arm64                 randconfig-1003-20260916    gcc-14.3.0
arm64                 randconfig-r053-20260916    clang-24
arm64                 randconfig-r064-20260915    clang-22
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                   randconfig-001-20260916    gcc-16.1.0
csky                   randconfig-002-20260916    gcc-16.1.0
csky                  randconfig-1000-20260916    gcc-14.3.0
csky                  randconfig-1001-20260916    gcc-14.3.0
csky                  randconfig-r062-20260915    gcc-13.4.0
csky                  randconfig-r111-20260916    clang-24   sparse
csky                 randconfig-r1307-20260916    gcc-13.4.0 sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon                randconfig-001-20260916    gcc-16.1.0
hexagon                randconfig-002-20260916    gcc-16.1.0
hexagon               randconfig-1000-20260916    gcc-16.1.0
hexagon               randconfig-1001-20260916    gcc-16.1.0
hexagon               randconfig-r052-20260916    clang-24
hexagon               randconfig-r054-20260915    clang-17
i386                              alldefconfig    gcc-16.1.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386         buildonly-randconfig-001-20260916    clang-22
i386         buildonly-randconfig-002-20260916    clang-22
i386         buildonly-randconfig-003-20260916    clang-22
i386         buildonly-randconfig-004-20260916    clang-22
i386         buildonly-randconfig-005-20260916    clang-22
i386         buildonly-randconfig-006-20260916    clang-22
i386        buildonly-randconfig-1000-20260916    clang-22
i386        buildonly-randconfig-1001-20260916    clang-22
i386        buildonly-randconfig-1002-20260916    clang-22
i386        buildonly-randconfig-1003-20260916    clang-22
i386        buildonly-randconfig-1004-20260916    clang-22
i386        buildonly-randconfig-1005-20260916    clang-22
i386                                 defconfig    gcc-16.1.0
i386                   randconfig-001-20260916    gcc-14
i386                   randconfig-002-20260916    gcc-14
i386                   randconfig-003-20260916    gcc-14
i386                   randconfig-004-20260916    gcc-14
i386                   randconfig-005-20260916    gcc-14
i386                   randconfig-006-20260916    gcc-14
i386                   randconfig-007-20260916    gcc-14
i386                   randconfig-011-20260916    clang-22
i386                   randconfig-012-20260916    clang-22
i386                   randconfig-013-20260916    clang-22
i386                   randconfig-014-20260916    clang-22
i386                   randconfig-015-20260916    clang-22
i386                   randconfig-016-20260916    clang-22
i386                   randconfig-017-20260916    clang-22
i386                   randconfig-051-20260915    clang-22
i386                   randconfig-051-20260916    gcc-14
i386                   randconfig-052-20260915    clang-22
i386                   randconfig-052-20260916    gcc-14
i386                   randconfig-053-20260915    clang-22
i386                   randconfig-053-20260916    gcc-14
i386                   randconfig-054-20260915    clang-22
i386                   randconfig-054-20260916    gcc-14
i386                  randconfig-1000-20260916    gcc-14
i386                  randconfig-1001-20260916    gcc-14
i386                  randconfig-1002-20260916    gcc-14
i386                  randconfig-1003-20260916    gcc-14
i386                  randconfig-1004-20260916    gcc-14
i386                  randconfig-1005-20260916    gcc-14
i386                  randconfig-1006-20260916    gcc-14
i386                  randconfig-1007-20260916    clang-22
i386                  randconfig-1008-20260916    clang-22
i386                  randconfig-1009-20260916    clang-22
i386                  randconfig-1010-20260916    clang-22
i386                  randconfig-1011-20260916    clang-22
i386                  randconfig-1012-20260916    clang-22
i386                  randconfig-1013-20260916    clang-22
i386                   randconfig-141-20260915    clang-22
i386                   randconfig-141-20260916    gcc-14
i386                  randconfig-r051-20260915    clang-17
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch                 loongson64_defconfig    clang-24
loongarch              randconfig-001-20260916    gcc-16.1.0
loongarch              randconfig-002-20260916    gcc-16.1.0
loongarch             randconfig-1000-20260916    gcc-16.1.0
loongarch             randconfig-1001-20260916    gcc-16.1.0
loongarch             randconfig-r054-20260915    clang-22
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                           amiga_defconfig    clang-22
m68k                           atari_defconfig    clang-20
m68k                                 defconfig    clang-24
m68k                        m5329evb_defconfig    clang-20
m68k                         m5407c3_defconfig    clang-24
m68k                  randconfig-r064-20260916    gcc-8.5.0
m68k                  randconfig-r072-20260916    gcc-14.3.0
m68k                 randconfig-r1306-20260916    gcc-15.2.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze            randconfig-r053-20260915    clang-22
microblaze            randconfig-r054-20260916    clang-24
microblaze            randconfig-r073-20260915    gcc-8.5.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           eyeq5_defconfig    gcc-16.1.0
mips                         maltaup_defconfig    clang-24
mips                  randconfig-r113-20260916    clang-24   sparse
mips                         vocore2_defconfig    clang-20
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                  randconfig-001-20260916    gcc-16.1.0
nios2                  randconfig-002-20260916    gcc-16.1.0
nios2                 randconfig-1000-20260916    gcc-16.1.0
nios2                 randconfig-1001-20260916    gcc-16.1.0
nios2                 randconfig-r053-20260915    clang-17
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1309-20260916    gcc-15.2.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                 generic-32bit_defconfig    clang-24
parisc                 randconfig-001-20260916    clang-24
parisc                 randconfig-002-20260916    clang-24
parisc                randconfig-1000-20260916    gcc-10.5.0
parisc                randconfig-1001-20260916    gcc-10.5.0
parisc                randconfig-r052-20260915    clang-17
parisc                randconfig-r062-20260916    gcc-8.5.0
parisc                randconfig-r072-20260915    gcc-8.5.0
parisc               randconfig-r1309-20260916    gcc-13.4.0 sparse
parisc                randconfig-r132-20260916    gcc-11.5.0 sparse
parisc64                          alldefconfig    clang-20
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                  canyonlands_defconfig    clang-22
powerpc                  canyonlands_defconfig    gcc-16.1.0
powerpc                    currituck_defconfig    clang-20
powerpc                      ep8248e_defconfig    clang-22
powerpc                           g5_defconfig    clang-20
powerpc                      mpc512x_defconfig    clang-20
powerpc                      mpc512x_defconfig    clang-22
powerpc                  mpc837x_rdb_defconfig    clang-22
powerpc                   mpc885_ads_defconfig    gcc-16.1.0
powerpc                     mvme5100_defconfig    clang-20
powerpc                       ppc6xx_defconfig    gcc-16.1.0
powerpc                randconfig-001-20260916    clang-24
powerpc                randconfig-002-20260916    clang-24
powerpc               randconfig-1000-20260916    gcc-10.5.0
powerpc               randconfig-1001-20260916    gcc-10.5.0
powerpc               randconfig-r122-20260916    clang-24   sparse
powerpc                      redwood_defconfig    gcc-16.1.0
powerpc64              randconfig-001-20260916    clang-24
powerpc64              randconfig-002-20260916    clang-24
powerpc64             randconfig-1000-20260916    gcc-10.5.0
powerpc64             randconfig-1001-20260916    gcc-10.5.0
powerpc64             randconfig-r073-20260916    gcc-10.5.0
powerpc64            randconfig-r1307-20260916    gcc-15.2.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                  randconfig-001-20260916    gcc-16.1.0
riscv                  randconfig-002-20260916    gcc-16.1.0
riscv                 randconfig-1000-20260916    gcc-8.5.0
riscv                 randconfig-1001-20260916    gcc-8.5.0
s390                              alldefconfig    clang-20
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                   randconfig-001-20260916    gcc-16.1.0
s390                   randconfig-002-20260916    gcc-16.1.0
s390                  randconfig-1000-20260916    gcc-8.5.0
s390                  randconfig-1001-20260916    gcc-8.5.0
s390                  randconfig-r063-20260915    clang-22
s390                  randconfig-r063-20260916    gcc-8.5.0
s390                  randconfig-r133-20260916    gcc-11.5.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                          apsh4a3a_defconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                           lboxre2_defconfig    gcc-16.1.0
sh                     randconfig-001-20260916    gcc-16.1.0
sh                     randconfig-002-20260916    gcc-16.1.0
sh                    randconfig-1000-20260916    gcc-8.5.0
sh                    randconfig-1001-20260916    gcc-8.5.0
sh                    randconfig-r051-20260915    clang-22
sh                    randconfig-r061-20260915    gcc-13.4.0
sh                    randconfig-r123-20260916    clang-24   sparse
sh                   randconfig-r1306-20260916    gcc-16.1.0 sparse
sh                   randconfig-r1308-20260916    gcc-15.2.0 sparse
sh                           sdk7786_defconfig    clang-20
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                  randconfig-001-20260916    gcc-14.3.0
sparc                  randconfig-002-20260916    gcc-14.3.0
sparc                 randconfig-1000-20260916    clang-24
sparc                 randconfig-1001-20260916    clang-24
sparc                 randconfig-r051-20260916    clang-24
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64                randconfig-001-20260916    gcc-14.3.0
sparc64                randconfig-002-20260916    gcc-14.3.0
sparc64               randconfig-1000-20260916    clang-24
sparc64               randconfig-1001-20260916    clang-24
sparc64               randconfig-r112-20260916    clang-24   sparse
sparc64              randconfig-r1308-20260916    gcc-13.4.0 sparse
sparc64              randconfig-r1309-20260916    gcc-16.1.0 sparse
sparc64               randconfig-r134-20260916    gcc-11.5.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                     randconfig-001-20260916    gcc-14.3.0
um                     randconfig-002-20260916    gcc-14.3.0
um                    randconfig-1000-20260916    clang-24
um                    randconfig-1001-20260916    clang-24
um                    randconfig-r061-20260916    gcc-8.5.0
um                    randconfig-r121-20260916    clang-24   sparse
um                            x86_64_defconfig    clang-22
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260916    gcc-14
x86_64      buildonly-randconfig-1001-20260916    gcc-14
x86_64      buildonly-randconfig-1002-20260916    gcc-14
x86_64      buildonly-randconfig-1003-20260916    gcc-14
x86_64      buildonly-randconfig-1004-20260916    gcc-14
x86_64      buildonly-randconfig-1005-20260916    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                 randconfig-011-20260916    gcc-14
x86_64                 randconfig-012-20260916    gcc-14
x86_64                 randconfig-013-20260916    gcc-14
x86_64                 randconfig-014-20260916    gcc-14
x86_64                 randconfig-015-20260916    gcc-14
x86_64                 randconfig-016-20260916    gcc-14
x86_64                 randconfig-071-20260916    gcc-14
x86_64                 randconfig-072-20260916    gcc-14
x86_64                 randconfig-073-20260916    gcc-14
x86_64                 randconfig-074-20260916    gcc-14
x86_64                 randconfig-075-20260916    gcc-14
x86_64                 randconfig-076-20260916    gcc-14
x86_64                randconfig-1000-20260916    clang-22
x86_64                randconfig-1001-20260916    clang-22
x86_64                randconfig-1002-20260916    clang-22
x86_64                randconfig-1003-20260916    clang-22
x86_64                randconfig-1004-20260916    clang-22
x86_64                randconfig-1005-20260916    clang-22
x86_64                randconfig-1006-20260916    clang-22
x86_64                randconfig-1007-20260916    clang-22
x86_64                randconfig-1008-20260916    clang-22
x86_64                randconfig-1009-20260916    clang-22
x86_64                 randconfig-101-20260915    clang-22
x86_64                 randconfig-101-20260916    clang-22
x86_64                randconfig-1010-20260916    clang-22
x86_64                randconfig-1011-20260916    clang-22
x86_64                randconfig-1012-20260916    gcc-14
x86_64                randconfig-1013-20260916    gcc-14
x86_64                randconfig-1014-20260916    gcc-14
x86_64                randconfig-1015-20260916    gcc-14
x86_64                randconfig-1016-20260916    gcc-14
x86_64                randconfig-1017-20260916    gcc-14
x86_64                 randconfig-102-20260915    clang-22
x86_64                 randconfig-102-20260916    clang-22
x86_64                 randconfig-103-20260915    clang-22
x86_64                 randconfig-103-20260916    clang-22
x86_64                 randconfig-104-20260915    clang-22
x86_64                 randconfig-104-20260916    clang-22
x86_64                 randconfig-161-20260915    clang-22
x86_64                 randconfig-161-20260916    gcc-14
x86_64                randconfig-r052-20260915    clang-22
x86_64                randconfig-r062-20260915    clang-22
x86_64                randconfig-r064-20260915    gcc-13.4.0
x86_64                randconfig-r071-20260915    clang-22
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                 randconfig-001-20260916    gcc-14.3.0
xtensa                 randconfig-002-20260916    gcc-14.3.0
xtensa                randconfig-1000-20260916    clang-24
xtensa                randconfig-1001-20260916    clang-24
xtensa                randconfig-r131-20260916    gcc-11.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
