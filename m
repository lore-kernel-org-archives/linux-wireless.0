Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AC42253B0
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 04:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784955424; cv=none; b=mj7SbTGWnwLBrS0FfCClbaICcnjp6z2Uj3NFZ5qtRsmk0JybWASDeLCanaHY3yBjRGJU9/WG0xdE5GDEhs2R4x55RD+TbZjpl/1D5f/Mh/JfEnLiYVI6YvuDHvHo2ZEBCc6kIOhvjFbQOUD5dvXHrU6t5kgufSBnEqAJiWsIEyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784955424; c=relaxed/simple;
	bh=/6k6RTW6m8HaGiYzqVWHSwC5+6uRgX1m8nJCQiJXEZc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=qaNUJLsQBypK7n6EbKmtTFF1xVpWZ6BO2K1ohXPpvtwDGE9aEkzEHTwzHDH2nCCsCkty7M/vF8+G3IJujcNf7lpphNPucwikrmEZxiqKUsZoNGvlj4NcqNt7LIx4kIL7gKMKnIILONo0nU6qLJFyb7JdesLUUQw/TNgzkMg+5A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KxwuqR58; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KxwuqR58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784955423; x=1816491423;
  h=date:from:to:cc:subject:message-id;
  bh=/6k6RTW6m8HaGiYzqVWHSwC5+6uRgX1m8nJCQiJXEZc=;
  b=KxwuqR58zL6jN/RcMdZKi8SjFwkcx0AxldY2Cx+MsOR/J/CPFphtyLwc
   pLCLcvDlI4t8YUH1ke+PveakwYMPVeHioMJnYyLcno1ILzkuUIfKjgNew
   lFBg+BFLffOqRhuaEPd9Hq/l0oPwMJZZjSpVe/qN9opWBBvfU12oBxWy6
   xzzR/X0ewiCjenKU+m0It3HX4YJsc03YYO/IUCnsAgPkYCYJs2Sh6sJi0
   M13hxjWllq67M4+Uzosw6OUj4HEx3pxzgwSwvpcnCSQIu0pbYPf5Uw+7L
   rmgf7kuYIh0QZHy5lQXSCNaoVKyJ9CkoMhxeu/OBUWMnONctyL0y+OKkn
   Q==;
X-CSE-ConnectionGUID: i6zcHyEuQCaYLzu3HGHZUw==
X-CSE-MsgGUID: 69lLFsEWRhmKiB+jRyemOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="85661629"
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="85661629"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 21:57:02 -0700
X-CSE-ConnectionGUID: B8vkrcuERpuNBJH1eiwbNA==
X-CSE-MsgGUID: u5RInWkhQqewhDszuE3zLw==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jul 2026 21:57:01 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnURW-00000000bUg-3pnZ;
	Sat, 25 Jul 2026 04:56:58 +0000
Date: Sat, 25 Jul 2026 12:56:37 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:main] BUILD REGRESSION
 90883c513ca01e77c56b8d94be7de11420c1dacf
Message-ID: <202607251212.6TdnMBFC-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
branch HEAD: 90883c513ca01e77c56b8d94be7de11420c1dacf  Merge tag 'ath-next-20260722' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/net/wireless/nxp/nxpwifi/scan.c:2034:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-allmodconfig
    `-- drivers-net-wireless-nxp-nxpwifi-scan.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc

elapsed time: 802m

configs tested: 59
configs skipped: 1

tested configs:
alpha                  allnoconfig    gcc-16.1.0
alpha                 allyesconfig    gcc-16.1.0
alpha                    defconfig    gcc-16.1.0
arc                   allmodconfig    gcc-16.1.0
arc                   allyesconfig    gcc-16.1.0
arc        randconfig-001-20260725    gcc-11.5.0
arc        randconfig-002-20260725    gcc-8.5.0
arm        randconfig-001-20260725    gcc-8.5.0
arm        randconfig-002-20260725    clang-21
arm        randconfig-003-20260725    gcc-10.5.0
arm        randconfig-004-20260725    gcc-15.2.0
arm64      randconfig-001-20260725    clang-24
arm64      randconfig-002-20260725    gcc-13.4.0
arm64      randconfig-003-20260725    clang-24
arm64      randconfig-004-20260725    clang-24
csky                  allmodconfig    gcc-16.1.0
csky       randconfig-001-20260725    gcc-9.5.0
csky       randconfig-002-20260725    gcc-16.1.0
hexagon             randconfig-001    clang-17
hexagon    randconfig-001-20260725    clang-17
hexagon    randconfig-002-20260725    clang-24
i386                  allmodconfig    gcc-14
loongarch                defconfig    clang-24
loongarch  randconfig-001-20260725    gcc-16.1.0
loongarch  randconfig-002-20260725    gcc-13.4.0
nios2                 allmodconfig    gcc-11.5.0
nios2                  allnoconfig    gcc-11.5.0
nios2      randconfig-001-20260725    gcc-11.5.0
nios2      randconfig-002-20260725    gcc-9.5.0
parisc                allmodconfig    gcc-16.1.0
parisc                allyesconfig    gcc-16.1.0
parisc                   defconfig    gcc-16.1.0
parisc     randconfig-001-20260725    gcc-10.5.0
parisc     randconfig-002-20260725    gcc-12.5.0
powerpc    randconfig-001-20260725    gcc-9.5.0
powerpc    randconfig-002-20260725    gcc-15.2.0
powerpc         sam440ep_defconfig    gcc-16.1.0
powerpc64  randconfig-001-20260725    clang-17
powerpc64  randconfig-002-20260725    clang-24
riscv      randconfig-001-20260725    gcc-8.5.0
riscv      randconfig-002-20260725    gcc-8.5.0
s390       randconfig-001-20260725    gcc-10.5.0
s390       randconfig-002-20260725    gcc-16.1.0
sh                       defconfig    gcc-16.1.0
sh         randconfig-001-20260725    gcc-16.1.0
sh         randconfig-002-20260725    gcc-11.5.0
sparc      randconfig-001-20260725    gcc-16.1.0
sparc      randconfig-002-20260725    gcc-8.5.0
sparc64    randconfig-001-20260725    gcc-8.5.0
sparc64    randconfig-002-20260725    gcc-10.5.0
um         randconfig-001-20260725    gcc-14
um         randconfig-002-20260725    clang-24
x86_64     randconfig-001-20260725    gcc-14
x86_64     randconfig-002-20260725    clang-22
x86_64     randconfig-003-20260725    clang-22
x86_64     randconfig-004-20260725    clang-22
x86_64     randconfig-005-20260725    clang-22
x86_64     randconfig-006-20260725    clang-22
xtensa     randconfig-002-20260725    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
