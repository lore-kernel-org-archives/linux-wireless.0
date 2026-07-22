Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEA91E9B37
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 12:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784722569; cv=none; b=WfDMSILSeA6xzkdWivweSdwW8GwtBDWj38kRaSP/ZRmujsA+kXh/az4DmhH6Z5bNarMXNM16b260zfmk/dfNLuruyLJnFfUKGwqjIo892T6VIN51l3vh9Yj42pp6nv5Rj/ut/DzieWvoTLHp2t1ZundRgOJlZvpsv0Q0DzjBbuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784722569; c=relaxed/simple;
	bh=/MKsBhXz6skQ4uOm6nHvulXcK5YZlMV/rCMsS0MdV+U=;
	h=Date:From:To:Cc:Subject:Message-ID; b=rNXWR5JYSJTUX9JxwZbjE+XFSwirdlT/Ds50oywS9Hcf4bz98DFg3h674a/VbnQ/m+RcfLshYU8T3CDrXi9tevFYZtaTtkuHEEGivm/grfZqJluoEHem/VDa4TsLQErSS2EjwlliZF7E0qRFCWVb3IB/aZZTUIl9lKglqP8jQ1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BIkREZrm; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BIkREZrm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784722568; x=1816258568;
  h=date:from:to:cc:subject:message-id;
  bh=/MKsBhXz6skQ4uOm6nHvulXcK5YZlMV/rCMsS0MdV+U=;
  b=BIkREZrmDs03e3cZuMz8coemRdLapUGhj3n3UxK+g7ZXU1/odxKi8Dml
   E5yL3nL8mvN2yjOOElA2Qq1bz5rXeBbzvix6URh9SZvGkcz/Ywb3SUl2j
   OttG/DI63/Iunj6vyRjXD/aBQAvMlBl8S+roHik/Uo0ZpQWj/56XXvkRS
   ZxIxW7OQifiSjhqYKEY3fzyteKMH5EE2nTge6XjzGUXyEYoCrtUhcihYG
   1Idvyvq53Lx7qXB4+Wwz820HgQJZ20EJMrbP6V6D80yFAJzwq5G8+DKiE
   Dyao0rwG8QfVQaZr/KdXYFA6Li4KjeH0BdGjyk8/3iWAOE7nfb43Rf3Yn
   g==;
X-CSE-ConnectionGUID: GR49eRzkSACnHj8SJiqcPA==
X-CSE-MsgGUID: XmI3Mv8tQLKS1xMd9ppewQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="85301090"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="85301090"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 05:16:07 -0700
X-CSE-ConnectionGUID: lWA9l11nR1y6dX/5lJJNQA==
X-CSE-MsgGUID: 6/Fqsm4SQWi5GcCD+Mlukg==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 22 Jul 2026 05:16:06 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wmVrn-00000000YhV-3gMh;
	Wed, 22 Jul 2026 12:16:03 +0000
Date: Wed, 22 Jul 2026 20:15:21 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:main] BUILD REGRESSION
 69bd85e933c617a84fa54fcc80e628e98afdc45d
Message-ID: <202607222006.EQjQtCJa-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
branch HEAD: 69bd85e933c617a84fa54fcc80e628e98afdc45d  wifi: brcmfmac: add DPP support

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/net/wireless/nxp/nxpwifi/scan.c:2034:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    `-- drivers-net-wireless-nxp-nxpwifi-scan.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 780m

configs tested: 86
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260722    gcc-12.5.0
arc                  randconfig-002-20260722    gcc-14.3.0
arm                  randconfig-001-20260722    clang-19
arm                  randconfig-002-20260722    clang-24
arm                  randconfig-003-20260722    clang-24
arm                  randconfig-004-20260722    clang-24
arm64                randconfig-001-20260722    clang-18
arm64                randconfig-002-20260722    clang-18
arm64                randconfig-003-20260722    gcc-16.1.0
arm64                randconfig-004-20260722    clang-17
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260722    gcc-10.5.0
csky                 randconfig-002-20260722    gcc-16.1.0
hexagon              randconfig-001-20260722    clang-24
hexagon              randconfig-002-20260722    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260722    clang-22
i386       buildonly-randconfig-002-20260722    clang-22
i386       buildonly-randconfig-003-20260722    clang-22
i386       buildonly-randconfig-004-20260722    gcc-13
i386       buildonly-randconfig-005-20260722    clang-22
i386       buildonly-randconfig-006-20260722    clang-22
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260722    gcc-14
i386                 randconfig-002-20260722    gcc-14
i386                 randconfig-003-20260722    clang-22
i386                 randconfig-004-20260722    clang-22
i386                 randconfig-005-20260722    gcc-14
i386                 randconfig-006-20260722    clang-22
i386                 randconfig-007-20260722    clang-22
i386                 randconfig-011-20260722    clang-22
i386                 randconfig-012-20260722    gcc-14
i386                 randconfig-013-20260722    clang-22
i386                 randconfig-014-20260722    clang-22
i386                 randconfig-015-20260722    gcc-14
i386                 randconfig-016-20260722    clang-22
i386                 randconfig-017-20260722    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260722    gcc-16.1.0
loongarch            randconfig-002-20260722    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260722    gcc-8.5.0
nios2                randconfig-002-20260722    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260722    gcc-9.5.0
parisc               randconfig-002-20260722    gcc-8.5.0
powerpc              randconfig-001-20260722    gcc-8.5.0
powerpc              randconfig-002-20260722    clang-18
powerpc                    tqm8555_defconfig    gcc-16.1.0
powerpc64            randconfig-001-20260722    gcc-8.5.0
powerpc64            randconfig-002-20260722    clang-24
riscv                randconfig-001-20260722    clang-24
riscv                randconfig-002-20260722    gcc-10.5.0
s390                 randconfig-001-20260722    gcc-13.4.0
s390                 randconfig-002-20260722    gcc-11.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260722    gcc-16.1.0
sh                   randconfig-002-20260722    gcc-16.1.0
sparc                randconfig-001-20260722    gcc-15.2.0
sparc                randconfig-002-20260722    gcc-16.1.0
sparc64              randconfig-001-20260722    gcc-11.5.0
sparc64              randconfig-002-20260722    gcc-9.5.0
um                   randconfig-001-20260722    gcc-14
um                   randconfig-002-20260722    clang-24
x86_64     buildonly-randconfig-001-20260722    clang-22
x86_64     buildonly-randconfig-002-20260722    gcc-14
x86_64     buildonly-randconfig-003-20260722    gcc-14
x86_64     buildonly-randconfig-004-20260722    clang-22
x86_64     buildonly-randconfig-005-20260722    gcc-14
x86_64     buildonly-randconfig-006-20260722    clang-22
x86_64               randconfig-001-20260722    clang-22
x86_64               randconfig-002-20260722    gcc-14
x86_64               randconfig-003-20260722    gcc-14
x86_64               randconfig-004-20260722    gcc-14
x86_64               randconfig-005-20260722    gcc-14
x86_64               randconfig-006-20260722    clang-22
xtensa               randconfig-001-20260722    gcc-8.5.0
xtensa               randconfig-002-20260722    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
