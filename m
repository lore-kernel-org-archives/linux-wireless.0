Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C03F41DE0A
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792265626; cv=none; b=DVmQKkjY902QZT864IQQK2WbNTSiEuFnWfYUfiwiaPTKN81+ORVqJZEpyxj6tWedoqI/8tZbt5HXf8US++vgKzVH0zCe6liM1YdzvUTpgLjgoMpSMpkcOR0WpjaIXQKJDnPsWb4wCa565iBrS/Zcw0MestF6IjfEt4QB/C7xNJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792265626; c=relaxed/simple;
	bh=8N0U32Pb0kpjER/v/E4dY9Y7+izBY33JBy+Awu+YtRE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=uCu/vNLg4IydIbwZSQL2YrKN2BHR0GyvOEe89OWkhSCMQbg34GSIp/6t8jbfOV/mkwbyFNCK36QsytquJULm9dbCQ9so3C6UViNPrsOo4o/rTwdInWBKENf52gQxBhSdS3zSAEH+TRBzh58E2sgw982xeast3fEvJ7QI5L1muYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=crDBPzVP; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="crDBPzVP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792265623; x=1823801623;
  h=date:from:to:cc:subject:message-id;
  bh=8N0U32Pb0kpjER/v/E4dY9Y7+izBY33JBy+Awu+YtRE=;
  b=crDBPzVPUa/t+bFKatOb2w21cLZ95T0igGogmnZTSAHnenimNx2dGdJL
   Nydqv/3hOyayrkicvb/Jyonn9G0trD27nZRnW0sY6ad78nfNvW8Wsiikx
   CekttDgQb26Pf9V/eHMMkWxgeiYfX1kS1NEAK/woNivUU5Ka9XaE30wLz
   kpDuP70GFyEN7OLvH+IlHiXfqHOgKOU12vy6FLrw/3OyrIDEWAfjk/YVC
   F/ykYLnWw/dQ3YdiZikTeFfBaVmTfIaHuedzuEQAIqiMniiRFqdtSOvLO
   jRtZGeEr890ylbYoDzfTLyD4NVjDvJoLPU0EaNpdOqp6vCFZfIIPwaAvG
   w==;
X-CSE-ConnectionGUID: dm2VIHmMSqCogzQfV9NJoQ==
X-CSE-MsgGUID: wO9QzEpwTYCF97/RPs1A+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11938"; a="897748"
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="897748"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2026 12:33:42 -0700
X-CSE-ConnectionGUID: /x2QwzvDSRC6ebqMoPwcXA==
X-CSE-MsgGUID: am3thbMeQTi/Y2cGdEHDIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="2202291"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 17 Oct 2026 12:33:41 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIA9y-00000000JeN-3kao;
	Sat, 17 Oct 2026 19:33:38 +0000
Date: Sun, 18 Oct 2026 03:33:29 +0800
From: kernel test robot <lkp@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD SUCCESS
 9b0be45d4d52fd223994e151f169743a97abd290
Message-ID: <202610180326.sDfsbNXj-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: 9b0be45d4d52fd223994e151f169743a97abd290  Merge tag 'wireless-next-2026-10-15' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next

elapsed time: 1808m

configs tested: 265
configs skipped: 141

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261017    gcc-10.5.0
arc                   randconfig-1001-20261017    gcc-10.5.0
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.1.0
arm                        aspeed_g4_defconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                       footbridge_defconfig    clang-24
arm                         multi_v5_defconfig    clang-24
arm                        netwinder_defconfig    gcc-16.1.0
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20261017    gcc-10.5.0
arm                   randconfig-1000-20261017    gcc-8.5.0
arm                   randconfig-1001-20261017    clang-20
arm                   randconfig-1001-20261017    gcc-10.5.0
arm                   randconfig-1002-20261017    gcc-10.5.0
arm                   randconfig-1003-20261017    clang-22
arm                   randconfig-1003-20261017    gcc-10.5.0
arm                   randconfig-2000-20261016    gcc-12.5.0
arm                  randconfig-r2202-20261016    clang-18   smatch
arm                          s5pv210_defconfig    gcc-16.1.0
arm                          socfpga_defconfig    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261017    clang-24
arm64                 randconfig-1000-20261017    gcc-11.5.0
arm64                 randconfig-1000-20261018    gcc-14.3.0
arm64                 randconfig-1001-20261017    clang-24
arm64                 randconfig-1001-20261017    gcc-13.4.0
arm64                 randconfig-1001-20261018    gcc-14.3.0
arm64                 randconfig-1002-20261017    clang-24
arm64                 randconfig-1002-20261018    gcc-14.3.0
arm64                 randconfig-1003-20261017    clang-24
arm64                 randconfig-1003-20261017    gcc-8.5.0
arm64                 randconfig-1003-20261018    gcc-14.3.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261017    clang-24
csky                  randconfig-1000-20261018    gcc-14.3.0
csky                  randconfig-1001-20261017    clang-24
csky                  randconfig-1001-20261018    gcc-14.3.0
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261017    clang-21
hexagon               randconfig-1000-20261018    clang-21
hexagon               randconfig-1001-20261017    clang-21
hexagon               randconfig-1001-20261018    clang-21
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261017    clang-22
i386        buildonly-randconfig-1000-20261017    gcc-14
i386        buildonly-randconfig-1001-20261017    gcc-14
i386        buildonly-randconfig-1002-20261017    clang-22
i386        buildonly-randconfig-1002-20261017    gcc-14
i386        buildonly-randconfig-1003-20261017    gcc-14
i386        buildonly-randconfig-1004-20261017    clang-22
i386        buildonly-randconfig-1004-20261017    gcc-14
i386        buildonly-randconfig-1005-20261017    gcc-14
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261017    clang-22
i386                  randconfig-1000-20261017    gcc-14
i386                  randconfig-1001-20261017    clang-22
i386                  randconfig-1002-20261017    clang-22
i386                  randconfig-1002-20261017    gcc-14
i386                  randconfig-1003-20261017    clang-22
i386                  randconfig-1003-20261017    gcc-14
i386                  randconfig-1004-20261017    clang-22
i386                  randconfig-1004-20261017    gcc-14
i386                  randconfig-1005-20261017    clang-22
i386                  randconfig-1005-20261017    gcc-14
i386                  randconfig-1006-20261017    clang-22
i386                  randconfig-1006-20261017    gcc-14
i386                  randconfig-1007-20261017    clang-22
i386                  randconfig-1007-20261017    gcc-14
i386                  randconfig-1008-20261017    clang-22
i386                  randconfig-1008-20261017    gcc-14
i386                  randconfig-1009-20261017    clang-22
i386                  randconfig-1009-20261017    gcc-14
i386                  randconfig-1010-20261017    clang-22
i386                  randconfig-1011-20261017    clang-22
i386                  randconfig-1012-20261017    clang-22
i386                  randconfig-1012-20261017    gcc-14
i386                  randconfig-1013-20261017    clang-22
i386                  randconfig-1013-20261017    gcc-14
i386                 randconfig-r2308-20261016    gcc-14     sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261017    clang-21
loongarch             randconfig-1000-20261018    clang-21
loongarch             randconfig-1001-20261017    clang-21
loongarch             randconfig-1001-20261018    clang-21
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                   cavium_octeon_defconfig    clang-24
mips                   cavium_octeon_defconfig    gcc-16.1.0
mips                            ip30_defconfig    clang-24
mips                      loongson2k_defconfig    clang-24
mips                    sb1250_swarm_defconfig    clang-24
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261017    clang-21
nios2                 randconfig-1000-20261018    clang-21
nios2                 randconfig-1001-20261017    clang-21
nios2                 randconfig-1001-20261018    clang-21
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261017    gcc-15.2.0
parisc                randconfig-1000-20261018    clang-24
parisc                randconfig-1001-20261017    gcc-15.2.0
parisc                randconfig-1001-20261018    clang-24
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                       chrp32_defconfig    clang-24
powerpc                       ep88xc_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261017    gcc-15.2.0
powerpc               randconfig-1000-20261018    clang-24
powerpc               randconfig-1001-20261017    gcc-15.2.0
powerpc               randconfig-1001-20261018    clang-24
powerpc                     socrates_defconfig    gcc-16.1.0
powerpc                      tqm8548_defconfig    clang-24
powerpc64             randconfig-1000-20261017    gcc-15.2.0
powerpc64             randconfig-1000-20261018    clang-24
powerpc64             randconfig-1001-20261017    gcc-15.2.0
powerpc64             randconfig-1001-20261018    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261017    clang-19
riscv                 randconfig-1000-20261018    clang-17
riscv                 randconfig-1001-20261017    clang-19
riscv                 randconfig-1001-20261018    clang-17
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261017    clang-19
s390                  randconfig-1000-20261018    clang-17
s390                  randconfig-1001-20261017    clang-19
s390                  randconfig-1001-20261018    clang-17
sh                                alldefconfig    gcc-16.1.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                  kfr2r09-romimage_defconfig    clang-24
sh                             migor_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261017    clang-19
sh                    randconfig-1000-20261018    clang-17
sh                    randconfig-1001-20261017    clang-19
sh                    randconfig-1001-20261018    clang-17
sh                           rsk7264_defconfig    gcc-16.1.0
sh                           rsk7269_defconfig    clang-24
sh                            sh2007_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261017    gcc-15.2.0
sparc                 randconfig-1000-20261018    clang-24
sparc                 randconfig-1001-20261017    gcc-15.2.0
sparc                 randconfig-1001-20261018    clang-24
sparc                        sparc32_defconfig    clang-24
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261017    gcc-15.2.0
sparc64               randconfig-1000-20261018    clang-24
sparc64               randconfig-1001-20261017    gcc-15.2.0
sparc64               randconfig-1001-20261018    clang-24
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261017    gcc-15.2.0
um                    randconfig-1000-20261018    clang-24
um                    randconfig-1001-20261017    gcc-15.2.0
um                    randconfig-1001-20261018    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261017    gcc-14
x86_64      buildonly-randconfig-1001-20261017    clang-22
x86_64      buildonly-randconfig-1001-20261017    gcc-14
x86_64      buildonly-randconfig-1002-20261017    gcc-14
x86_64      buildonly-randconfig-1003-20261017    gcc-12
x86_64      buildonly-randconfig-1003-20261017    gcc-14
x86_64      buildonly-randconfig-1004-20261017    clang-22
x86_64      buildonly-randconfig-1004-20261017    gcc-14
x86_64      buildonly-randconfig-1005-20261017    clang-22
x86_64      buildonly-randconfig-1005-20261017    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261017    gcc-14
x86_64                randconfig-1001-20261017    clang-22
x86_64                randconfig-1001-20261017    gcc-14
x86_64                randconfig-1002-20261017    clang-22
x86_64                randconfig-1002-20261017    gcc-14
x86_64                randconfig-1003-20261017    gcc-12
x86_64                randconfig-1003-20261017    gcc-14
x86_64                randconfig-1004-20261017    gcc-14
x86_64                randconfig-1005-20261017    gcc-12
x86_64                randconfig-1005-20261017    gcc-14
x86_64                randconfig-1006-20261017    clang-22
x86_64                randconfig-1007-20261017    clang-22
x86_64                randconfig-1008-20261017    clang-22
x86_64                randconfig-1008-20261017    gcc-12
x86_64                randconfig-1009-20261017    clang-22
x86_64                randconfig-1009-20261017    gcc-14
x86_64                randconfig-1010-20261017    clang-22
x86_64                randconfig-1010-20261017    gcc-13
x86_64                randconfig-1011-20261017    clang-22
x86_64                randconfig-1012-20261017    clang-22
x86_64                randconfig-1013-20261017    clang-22
x86_64                randconfig-1014-20261017    clang-22
x86_64                randconfig-1015-20261017    clang-22
x86_64                randconfig-1016-20261017    clang-22
x86_64                randconfig-1017-20261017    clang-22
x86_64                randconfig-2200-20261016    gcc-14     smatch
x86_64               randconfig-r2201-20261016    gcc-14     smatch
x86_64               randconfig-r2304-20261016    gcc-14     sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261017    gcc-15.2.0
xtensa                randconfig-1000-20261018    clang-24
xtensa                randconfig-1001-20261017    gcc-15.2.0
xtensa                randconfig-1001-20261018    clang-24

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
