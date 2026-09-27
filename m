Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7F83BBFBA
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 07:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790495632; cv=none; b=WgCtSY9hFhyejfbn8P9mowRVVfH+M2Jimv+Dk+R/QhgPWFjf5n4HcNQM7SPhDS7JaMKLOjE6B78JN5vZWYLBRe844UcvbTH8R0TPrMu0eUMmgCxVKq5t2EzCd/BLj6AKBRX8cJUP8nJCtrPwHsg5onsf72wMN5K/V973t0Y5qAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790495632; c=relaxed/simple;
	bh=i0gVTo78RnMPRPCUk42sdMcFRnhjHvgVlZJrD4sV2Hc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=rNFoLkXMEC97mWTCpnRU3J+A+98NwfddMhLMbqCpvjRp0IFZuG3622+VqqpK7dnuCC+i5DrCyjtaI6RVdDhqaKFNuxr0GyPeXXYRHb3hfCxZ4TBCKnR3bUY5VV8U8a7VyXauZGl8ZdrCdO5lSj5PLuPSncQJoO32zc/UtiOfZeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ag2dZrjN; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ag2dZrjN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790495627; x=1822031627;
  h=date:from:to:cc:subject:message-id;
  bh=i0gVTo78RnMPRPCUk42sdMcFRnhjHvgVlZJrD4sV2Hc=;
  b=ag2dZrjNyjYVpIoX+Q2GtpravSgcbPjxOfeQfmSDBpu/+cO9LnE3RuRi
   AweKqOTxm9lZ5Kw4TdaLLA+g0QoTKUl5h7f7qV23Wbo+5xtcZy6g5nVO6
   RtAQQ2XW9RUt7s2kG22HrtJNaspRokXylWUaOnWYW8E28lvPiIeFbk21j
   iFfbeMLH/KMlrO7UfGNtosPTYnJSmTUC7QXeujTkh3JrC7eIexGy4B1lz
   Um0I0JbtjK9Knapd6vC0TE6arx5KlPw8BVzMbCIJEMCMU8WI2JhGld7Do
   jKTvj4AKhWlcnuOzSdIwomH423JdBQnbQVxtSVoIui3gv6pihRq6Ndg3u
   g==;
X-CSE-ConnectionGUID: UqZDqIDOREW9AIowOL6QjQ==
X-CSE-MsgGUID: U6nmr4iNQQC/gZEkcOIjAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="101793429"
X-IronPort-AV: E=Sophos;i="6.27,125,1787036400"; 
   d="scan'208";a="101793429"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 00:53:44 -0700
X-CSE-ConnectionGUID: EnrGgkKhQvuyr4lnP3WdWw==
X-CSE-MsgGUID: jzE66FlTQa6rGqmQQM3Y3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,125,1787036400"; 
   d="scan'208";a="279486490"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 27 Sep 2026 00:53:43 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAjhc-00000000Mf9-1eTb;
	Sun, 27 Sep 2026 07:53:40 +0000
Date: Sun, 27 Sep 2026 15:53:04 +0800
From: kernel test robot <lkp@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD SUCCESS
 42a9fb3382fc2573e92f41d203b095d9a372cfc9
Message-ID: <202609271501.qajwY6nU-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: 42a9fb3382fc2573e92f41d203b095d9a372cfc9  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

elapsed time: 1456m

configs tested: 349
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2201-20260925    gcc-13.4.0 smatch
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260926    clang-24
arc                   randconfig-1000-20260927    gcc-11.5.0
arc                   randconfig-1001-20260926    clang-24
arc                   randconfig-1001-20260927    gcc-11.5.0
arc                  randconfig-r2100-20260925    gcc-9.5.0  cocci
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                          assabet_defconfig    gcc-16.1.0
arm                          bcm2835_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                           exynos_defconfig    clang-24
arm                            h3600_defconfig    clang-24
arm                         keystone_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260926    clang-24
arm                   randconfig-1000-20260927    gcc-11.5.0
arm                   randconfig-1001-20260926    clang-24
arm                   randconfig-1001-20260927    gcc-11.5.0
arm                   randconfig-1002-20260926    clang-24
arm                   randconfig-1002-20260927    gcc-11.5.0
arm                   randconfig-1003-20260926    clang-24
arm                   randconfig-1003-20260927    gcc-11.5.0
arm                  randconfig-r2201-20260926    clang-20   smatch
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260926    gcc-8.5.0
arm64                 randconfig-1000-20260927    clang-17
arm64                 randconfig-1001-20260926    gcc-8.5.0
arm64                 randconfig-1001-20260927    clang-17
arm64                 randconfig-1002-20260926    gcc-8.5.0
arm64                 randconfig-1002-20260927    clang-17
arm64                 randconfig-1003-20260926    gcc-8.5.0
arm64                 randconfig-1003-20260927    clang-17
arm64                randconfig-r2104-20260925    gcc-15.2.0 cocci
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260926    gcc-8.5.0
csky                  randconfig-1000-20260927    clang-17
csky                  randconfig-1001-20260926    gcc-8.5.0
csky                  randconfig-1001-20260927    clang-17
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260926    gcc-10.5.0
hexagon               randconfig-1000-20260927    gcc-11.5.0
hexagon               randconfig-1001-20260926    gcc-10.5.0
hexagon               randconfig-1001-20260927    gcc-11.5.0
hexagon              randconfig-r2101-20260925    gcc-9.5.0  cocci
hexagon              randconfig-r2102-20260925    gcc-9.5.0  cocci
hexagon              randconfig-r2106-20260925    clang-17   cocci
i386                              alldefconfig    gcc-16.1.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20260926    gcc-14
i386        buildonly-randconfig-1000-20260927    clang-22
i386        buildonly-randconfig-1001-20260926    gcc-14
i386        buildonly-randconfig-1001-20260927    clang-22
i386        buildonly-randconfig-1002-20260926    gcc-14
i386        buildonly-randconfig-1002-20260927    clang-22
i386        buildonly-randconfig-1003-20260926    gcc-14
i386        buildonly-randconfig-1003-20260927    clang-22
i386        buildonly-randconfig-1004-20260926    gcc-14
i386        buildonly-randconfig-1004-20260927    clang-22
i386        buildonly-randconfig-1005-20260926    gcc-14
i386        buildonly-randconfig-1005-20260927    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260927    clang-22
i386                  randconfig-1001-20260927    clang-22
i386                  randconfig-1002-20260927    clang-22
i386                  randconfig-1003-20260927    clang-22
i386                  randconfig-1004-20260927    clang-22
i386                  randconfig-1005-20260927    clang-22
i386                  randconfig-1006-20260927    clang-22
i386                  randconfig-1007-20260926    gcc-14
i386                  randconfig-1007-20260927    gcc-14
i386                  randconfig-1008-20260926    gcc-14
i386                  randconfig-1008-20260927    gcc-14
i386                  randconfig-1009-20260926    gcc-14
i386                  randconfig-1009-20260927    gcc-14
i386                  randconfig-1010-20260926    gcc-14
i386                  randconfig-1010-20260927    gcc-14
i386                  randconfig-1011-20260926    gcc-14
i386                  randconfig-1011-20260927    gcc-14
i386                  randconfig-1012-20260926    gcc-14
i386                  randconfig-1012-20260927    gcc-14
i386                  randconfig-1013-20260926    gcc-14
i386                  randconfig-1013-20260927    gcc-14
i386                  randconfig-2100-20260925    clang-22   cocci
i386                  randconfig-2100-20260925    gcc-14     cocci
i386                  randconfig-2100-20260926    gcc-14     cocci
i386                  randconfig-2101-20260925    clang-22   cocci
i386                  randconfig-2101-20260926    gcc-14     cocci
i386                  randconfig-2102-20260925    clang-22   cocci
i386                  randconfig-2102-20260926    gcc-14     cocci
i386                  randconfig-2103-20260925    clang-22   cocci
i386                  randconfig-2103-20260926    gcc-14     cocci
i386                  randconfig-2200-20260925    gcc-14     smatch
i386                 randconfig-r2103-20260925    gcc-14     cocci
i386                 randconfig-r2202-20260925    clang-22   smatch
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260926    gcc-10.5.0
loongarch             randconfig-1000-20260927    gcc-11.5.0
loongarch             randconfig-1001-20260926    gcc-10.5.0
loongarch             randconfig-1001-20260927    gcc-11.5.0
loongarch            randconfig-r2308-20260926    clang-22   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                          amcore_defconfig    clang-24
m68k                                 defconfig    clang-24
m68k                       m54418evb_defconfig    gcc-16.1.0
m68k                 randconfig-r2102-20260926    clang-24   cocci
m68k                            sun3_defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                   cavium_octeon_defconfig    gcc-16.1.0
mips                          cobalt_defconfig    gcc-16.1.0
mips                          db1xxx_defconfig    gcc-16.1.0
mips                           eyeq6_defconfig    gcc-16.1.0
mips                      eyeq6lplus_defconfig    gcc-16.1.0
mips                 malta_qemu_32r6_defconfig    gcc-16.1.0
mips                   maltasmvp_eva_defconfig    gcc-16.1.0
mips                 randconfig-r2105-20260925    gcc-11.5.0 cocci
mips                 randconfig-r2200-20260926    gcc-15.2.0 smatch
mips                 randconfig-r2202-20260926    clang-17   smatch
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260926    gcc-10.5.0
nios2                 randconfig-1000-20260927    gcc-11.5.0
nios2                 randconfig-1001-20260926    gcc-10.5.0
nios2                 randconfig-1001-20260927    gcc-11.5.0
nios2                randconfig-r2101-20260925    gcc-8.5.0  cocci
nios2                randconfig-r2307-20260926    clang-22   sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc                   or1klitex_defconfig    gcc-16.1.0
openrisc                     or1ksim_defconfig    gcc-16.1.0
openrisc                  simple_smp_defconfig    clang-24
openrisc                  simple_smp_defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260926    clang-24
parisc                randconfig-1000-20260927    clang-24
parisc                randconfig-1001-20260926    clang-24
parisc                randconfig-1001-20260927    clang-24
parisc               randconfig-r2104-20260926    gcc-8.5.0  cocci
parisc               randconfig-r2106-20260925    gcc-15.2.0 cocci
parisc               randconfig-r2201-20260925    gcc-12.5.0 smatch
parisc               randconfig-r2309-20260926    clang-22   sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                      asp8347_defconfig    clang-24
powerpc                  canyonlands_defconfig    gcc-16.1.0
powerpc                     ge_imp3a_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260926    clang-24
powerpc               randconfig-1000-20260927    clang-24
powerpc               randconfig-1001-20260926    clang-24
powerpc               randconfig-1001-20260927    clang-24
powerpc              randconfig-r2100-20260926    clang-24   cocci
powerpc                       tqm8xx_defconfig    clang-24
powerpc                          wii_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260926    clang-24
powerpc64             randconfig-1000-20260927    clang-24
powerpc64             randconfig-1001-20260926    clang-24
powerpc64             randconfig-1001-20260927    clang-24
powerpc64            randconfig-r2104-20260925    gcc-11.5.0 cocci
powerpc64            randconfig-r2202-20260925    clang-24   smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260927    gcc-16.1.0
riscv                 randconfig-1001-20260927    gcc-16.1.0
riscv                 randconfig-2000-20260925    gcc-11.5.0
riscv                 randconfig-2000-20260926    gcc-12.5.0
riscv                 randconfig-2001-20260925    gcc-11.5.0
riscv                 randconfig-2001-20260925    gcc-9.5.0
riscv                 randconfig-2001-20260926    gcc-12.5.0
riscv                randconfig-r2103-20260926    clang-24   cocci
riscv                randconfig-r2107-20260926    gcc-8.5.0  cocci
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260927    gcc-16.1.0
s390                  randconfig-1001-20260927    gcc-16.1.0
s390                  randconfig-2000-20260925    gcc-11.5.0
s390                  randconfig-2000-20260925    gcc-8.5.0
s390                  randconfig-2000-20260926    gcc-12.5.0
s390                  randconfig-2001-20260925    clang-24
s390                  randconfig-2001-20260925    gcc-11.5.0
s390                  randconfig-2001-20260926    gcc-12.5.0
s390                 randconfig-r2200-20260925    clang-24   smatch
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                           polaris_defconfig    gcc-16.1.0
sh                           r7785rp_defconfig    clang-24
sh                    randconfig-1000-20260927    gcc-16.1.0
sh                    randconfig-1001-20260927    gcc-16.1.0
sh                    randconfig-2000-20260925    gcc-11.5.0
sh                    randconfig-2000-20260925    gcc-14.3.0
sh                    randconfig-2000-20260926    gcc-12.5.0
sh                    randconfig-2001-20260925    gcc-11.5.0
sh                    randconfig-2001-20260925    gcc-16.1.0
sh                    randconfig-2001-20260926    gcc-12.5.0
sh                   randconfig-r2100-20260925    gcc-14.3.0 cocci
sh                   randconfig-r2105-20260925    gcc-15.2.0 cocci
sh                   randconfig-r2105-20260926    gcc-8.5.0  cocci
sh                           rsk7203_defconfig    clang-24
sh                           sdk7780_defconfig    gcc-16.1.0
sh                              sh03_defconfig    gcc-16.1.0
sh                             titan_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260926    gcc-14
sparc                 randconfig-1000-20260927    clang-24
sparc                 randconfig-1001-20260926    gcc-14
sparc                 randconfig-1001-20260927    clang-24
sparc                 randconfig-2000-20260925    gcc-14.3.0
sparc                 randconfig-2000-20260925    gcc-16.1.0
sparc                 randconfig-2001-20260925    gcc-16.1.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260926    gcc-14
sparc64               randconfig-1000-20260927    clang-24
sparc64               randconfig-1001-20260926    gcc-14
sparc64               randconfig-1001-20260927    clang-24
sparc64               randconfig-2000-20260925    gcc-15.2.0
sparc64               randconfig-2000-20260925    gcc-16.1.0
sparc64               randconfig-2001-20260925    clang-20
sparc64               randconfig-2001-20260925    gcc-16.1.0
sparc64              randconfig-r2101-20260926    clang-24   cocci
sparc64              randconfig-r2103-20260925    gcc-9.5.0  cocci
sparc64              randconfig-r2106-20260926    gcc-8.5.0  cocci
sparc64              randconfig-r2200-20260925    gcc-8.5.0  smatch
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260926    gcc-14
um                    randconfig-1000-20260927    clang-24
um                    randconfig-1001-20260926    gcc-14
um                    randconfig-1001-20260927    clang-24
um                    randconfig-2000-20260925    gcc-14
um                    randconfig-2000-20260925    gcc-16.1.0
um                    randconfig-2001-20260925    gcc-14
um                    randconfig-2001-20260925    gcc-16.1.0
um                   randconfig-r2102-20260925    gcc-14     cocci
um                   randconfig-r2107-20260925    clang-24   cocci
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260927    gcc-14
x86_64      buildonly-randconfig-1001-20260927    gcc-14
x86_64      buildonly-randconfig-1002-20260927    gcc-14
x86_64      buildonly-randconfig-1003-20260927    gcc-14
x86_64      buildonly-randconfig-1004-20260927    gcc-14
x86_64      buildonly-randconfig-1005-20260927    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260926    gcc-14
x86_64                randconfig-1000-20260927    clang-22
x86_64                randconfig-1001-20260926    gcc-14
x86_64                randconfig-1001-20260927    clang-22
x86_64                randconfig-1002-20260926    gcc-14
x86_64                randconfig-1002-20260927    clang-22
x86_64                randconfig-1003-20260926    gcc-14
x86_64                randconfig-1003-20260927    clang-22
x86_64                randconfig-1004-20260926    gcc-14
x86_64                randconfig-1004-20260927    clang-22
x86_64                randconfig-1005-20260926    gcc-14
x86_64                randconfig-1005-20260927    clang-22
x86_64                randconfig-1006-20260926    gcc-14
x86_64                randconfig-1006-20260927    clang-22
x86_64                randconfig-1007-20260926    gcc-14
x86_64                randconfig-1007-20260927    clang-22
x86_64                randconfig-1008-20260926    gcc-14
x86_64                randconfig-1008-20260927    clang-22
x86_64                randconfig-1009-20260926    gcc-14
x86_64                randconfig-1009-20260927    clang-22
x86_64                randconfig-1010-20260926    gcc-14
x86_64                randconfig-1010-20260927    clang-22
x86_64                randconfig-1011-20260926    gcc-14
x86_64                randconfig-1011-20260927    clang-22
x86_64                randconfig-1012-20260927    clang-22
x86_64                randconfig-1013-20260927    clang-22
x86_64                randconfig-1014-20260927    clang-22
x86_64                randconfig-1015-20260927    clang-22
x86_64                randconfig-1016-20260927    clang-22
x86_64                randconfig-1017-20260927    clang-22
x86_64                randconfig-2100-20260925    clang-22   cocci
x86_64                randconfig-2100-20260925    gcc-14     cocci
x86_64                randconfig-2100-20260926    clang-22   cocci
x86_64                randconfig-2101-20260925    clang-22   cocci
x86_64                randconfig-2101-20260926    clang-22   cocci
x86_64                randconfig-2102-20260925    clang-22   cocci
x86_64                randconfig-2102-20260926    clang-22   cocci
x86_64                randconfig-2103-20260925    clang-22   cocci
x86_64                randconfig-2103-20260926    clang-22   cocci
x86_64                randconfig-2200-20260925    gcc-14     smatch
x86_64                randconfig-2200-20260926    clang-22   smatch
x86_64               randconfig-r2306-20260926    clang-22   sparse
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
xtensa                randconfig-1000-20260926    gcc-14
xtensa                randconfig-1000-20260927    clang-24
xtensa                randconfig-1001-20260926    gcc-14
xtensa                randconfig-1001-20260927    clang-24
xtensa                randconfig-2000-20260925    gcc-12.5.0
xtensa                randconfig-2000-20260925    gcc-16.1.0
xtensa                randconfig-2001-20260925    gcc-16.1.0
xtensa                randconfig-2001-20260925    gcc-8.5.0
xtensa               randconfig-r2107-20260925    gcc-15.2.0 cocci

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
