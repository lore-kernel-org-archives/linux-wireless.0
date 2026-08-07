Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413B13793DC
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786118878; cv=none; b=Pp9ud0vPTEWj7/JVpLaWtFKeUiYVXGf7sSbO6zXwPxVi2NMA+/lMZ/ylbMvze//cwmaJdIHfDLxc/6X/Ly5B7r0AVSn3FVMgwO23XYcf87/wazmuVXQmUeUskw+UPmZi4SELsMCD5vG3i6Ku2gfnB0HbETZoEYvV1YLYVNoxzUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786118878; c=relaxed/simple;
	bh=291X25EMsM5xe4YtxhnDQmoI99qBB/TB2Fm7iJV9SUM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Pjei37dMkyu1tBGOTJXBikoWtnredx1sZ4Dt5/V0o12Dt5IV1uypB7dQsEqXoYBOre22JfBj3GokJpxMZdr2QibWgGsRZPN4NEO1GxZg/qws66Obe1TOKjw5Zg/oCl+AKUATGhGyUeia8O8JqZ/H1D455QHLouv/z0blJeL9MFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=grYZvSYN; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="grYZvSYN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786118877; x=1817654877;
  h=date:from:to:cc:subject:message-id;
  bh=291X25EMsM5xe4YtxhnDQmoI99qBB/TB2Fm7iJV9SUM=;
  b=grYZvSYNQJACc3oKBSnGZ6JEd3UBqpYeYBIsq9VWnM899OhnJhwKGilG
   1fDkHk68Vlqq+Qm7JjCxDyI9X5v0u/c+HoaiyLgQCJBg9wNV1yPoOfSZ4
   XrxWzONlplqkn37opAiPnscoM/v6WMsD9Cji3WTqQIcm2haVY6Xd+DU5Z
   gShQ5Lyv0dEm1tzIS4v7IbuQkkR+TBAjSEUwkLZ4dEml65Hm8pSBXm0K8
   +ScC3fy/oQhkYZ6mU3us6pWsQdMSbrCuTOfy8v07zU+Zp/wpuM1yxDZFM
   sxAF+1AYwtheNXJF0QaM1wiRsBwvUcaBIr/t2mMg6+RbbVAVGFQ7FAlM1
   w==;
X-CSE-ConnectionGUID: dNp0cq7FRB+fZ6P+WO1qXg==
X-CSE-MsgGUID: 9YsiUNn9ToyuMfvOk6KqHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11868"; a="90610737"
X-IronPort-AV: E=Sophos;i="6.25,210,1779174000"; 
   d="scan'208";a="90610737"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 09:07:56 -0700
X-CSE-ConnectionGUID: otn1amxxToiwSe0Ki8wubg==
X-CSE-MsgGUID: klhfvhqcT/m8yrQpqTFU6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,210,1779174000"; 
   d="scan'208";a="300636234"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 07 Aug 2026 09:07:55 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wsN6u-00000000Ifn-2Prg;
	Fri, 07 Aug 2026 16:07:52 +0000
Date: Sat, 08 Aug 2026 00:07:33 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD SUCCESS
 ca800a9302764c445de0da0e84d2252400a770ee
Message-ID: <202608080020.dfB9G3jn-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: ca800a9302764c445de0da0e84d2252400a770ee  wifi: nxpwifi: bound uAP association event IEs to the event buffer

elapsed time: 1482m

configs tested: 134
configs skipped: 60

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             alldefconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arm                  randconfig-001-20260807    clang-17
arm                  randconfig-002-20260807    gcc-12.5.0
arm                  randconfig-003-20260807    gcc-10.5.0
arm                  randconfig-004-20260807    gcc-16.1.0
arm64                randconfig-001-20260807    clang-24
arm64                randconfig-001-20260807    gcc-16.1.0
arm64                randconfig-002-20260807    clang-24
arm64                randconfig-002-20260807    gcc-16.1.0
arm64                randconfig-003-20260807    gcc-16.1.0
arm64                randconfig-004-20260807    clang-17
arm64                randconfig-004-20260807    gcc-16.1.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260807    gcc-16.1.0
csky                 randconfig-002-20260807    gcc-16.1.0
hexagon              randconfig-001-20260807    clang-18
hexagon              randconfig-001-20260807    clang-24
hexagon              randconfig-002-20260807    clang-18
hexagon              randconfig-002-20260807    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260807    gcc-13
i386       buildonly-randconfig-001-20260807    gcc-14
i386       buildonly-randconfig-002-20260807    gcc-13
i386       buildonly-randconfig-002-20260807    gcc-14
i386       buildonly-randconfig-003-20260807    clang-22
i386       buildonly-randconfig-003-20260807    gcc-13
i386       buildonly-randconfig-004-20260807    clang-22
i386       buildonly-randconfig-004-20260807    gcc-13
i386       buildonly-randconfig-005-20260807    clang-22
i386       buildonly-randconfig-005-20260807    gcc-13
i386       buildonly-randconfig-006-20260807    gcc-13
i386                 randconfig-001-20260807    clang-22
i386                 randconfig-001-20260807    gcc-14
i386                 randconfig-002-20260807    clang-22
i386                 randconfig-002-20260807    gcc-14
i386                 randconfig-003-20260807    clang-22
i386                 randconfig-003-20260807    gcc-14
i386                 randconfig-004-20260807    gcc-14
i386                 randconfig-005-20260807    clang-22
i386                 randconfig-005-20260807    gcc-14
i386                 randconfig-006-20260807    gcc-14
i386                 randconfig-007-20260807    gcc-14
i386                 randconfig-011-20260807    clang-22
i386                 randconfig-012-20260807    clang-22
i386                 randconfig-012-20260807    gcc-14
i386                 randconfig-013-20260807    clang-22
i386                 randconfig-014-20260807    clang-22
i386                 randconfig-014-20260807    gcc-14
i386                 randconfig-015-20260807    clang-22
i386                 randconfig-016-20260807    clang-22
i386                 randconfig-017-20260807    clang-22
i386                 randconfig-017-20260807    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260807    clang-18
loongarch            randconfig-001-20260807    clang-24
loongarch            randconfig-002-20260807    clang-18
m68k                      m5275evb_defconfig    gcc-16.1.0
mips                       qi_lb60_defconfig    clang-17
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260807    clang-18
nios2                randconfig-001-20260807    gcc-8.5.0
nios2                randconfig-002-20260807    clang-18
nios2                randconfig-002-20260807    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260807    gcc-8.5.0
parisc               randconfig-002-20260807    gcc-8.5.0
powerpc              randconfig-001-20260807    gcc-8.5.0
powerpc              randconfig-002-20260807    gcc-8.5.0
powerpc64            randconfig-001-20260807    gcc-8.5.0
powerpc64            randconfig-002-20260807    gcc-8.5.0
riscv                         randconfig-001    gcc-12.5.0
riscv                randconfig-001-20260807    gcc-12.5.0
riscv                randconfig-002-20260807    gcc-12.5.0
s390                 randconfig-001-20260807    gcc-12.5.0
s390                 randconfig-002-20260807    gcc-12.5.0
sh                                 defconfig    gcc-16.1.0
sh                           migor_defconfig    gcc-16.1.0
sh                   randconfig-001-20260807    gcc-12.5.0
sh                   randconfig-002-20260807    gcc-12.5.0
sparc                           alldefconfig    gcc-16.1.0
sparc                         randconfig-001    gcc-16.1.0
sparc                randconfig-001-20260807    gcc-16.1.0
sparc                randconfig-002-20260807    gcc-16.1.0
sparc64              randconfig-001-20260807    gcc-16.1.0
sparc64              randconfig-002-20260807    gcc-16.1.0
um                              alldefconfig    clang-24
um                   randconfig-001-20260807    gcc-16.1.0
um                   randconfig-002-20260807    gcc-16.1.0
x86_64     buildonly-randconfig-001-20260807    clang-22
x86_64     buildonly-randconfig-002-20260807    clang-22
x86_64     buildonly-randconfig-002-20260807    gcc-14
x86_64     buildonly-randconfig-003-20260807    clang-22
x86_64     buildonly-randconfig-003-20260807    gcc-14
x86_64     buildonly-randconfig-004-20260807    clang-22
x86_64     buildonly-randconfig-005-20260807    clang-22
x86_64     buildonly-randconfig-006-20260807    clang-22
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260807    clang-22
x86_64               randconfig-002-20260807    clang-22
x86_64               randconfig-002-20260807    gcc-14
x86_64               randconfig-003-20260807    clang-22
x86_64               randconfig-004-20260807    clang-22
x86_64               randconfig-005-20260807    clang-22
x86_64               randconfig-006-20260807    clang-22
x86_64               randconfig-006-20260807    gcc-14
x86_64                        randconfig-011    clang-22
x86_64               randconfig-011-20260807    clang-22
x86_64               randconfig-012-20260807    clang-22
x86_64               randconfig-013-20260807    clang-22
x86_64               randconfig-014-20260807    clang-22
x86_64               randconfig-014-20260807    gcc-14
x86_64               randconfig-015-20260807    clang-22
x86_64               randconfig-015-20260807    gcc-14
x86_64               randconfig-016-20260807    clang-22
x86_64               randconfig-016-20260807    gcc-14
x86_64               randconfig-071-20260807    clang-22
x86_64               randconfig-071-20260807    gcc-13
x86_64               randconfig-072-20260807    clang-22
x86_64               randconfig-073-20260807    clang-22
x86_64               randconfig-074-20260807    clang-22
x86_64               randconfig-075-20260807    clang-22
x86_64               randconfig-075-20260807    gcc-14
x86_64               randconfig-076-20260807    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260807    gcc-16.1.0
xtensa               randconfig-002-20260807    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
