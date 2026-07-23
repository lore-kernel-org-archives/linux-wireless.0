Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA233E51DE
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 21:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784843015; cv=none; b=dYxnPDX6palHFZfAAeqjVUQq74HN4MM441yChIbGqnnoXHN9CeaSKqty6eXUvvprpwkKJXP7MpBQUQSJx2VrsVXqWsQiotyuV23++NynME96ecgTQzkVkY62qcDiECgL31SO/PAG3pzmEZjOBukBAq5ZvRLhoXkrt/co1a7qHrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784843015; c=relaxed/simple;
	bh=t+rGoCZY2sHqccaAiALTddytC1TpKIZn0a5q2pJrh+A=;
	h=Date:From:To:Cc:Subject:Message-ID; b=lDhCoLF4Zu2ojCc/ZIUSp/5DK/YM9EMjWPYFzDaWo6B+ypk36by+dB3CtP4MO3JGybzCoh9VxuZVQW8Bw0+7BbGvlImYzfut5TSN/vhEA7hxhyfcnqS3yQD6Mei94/WxLkCXDWDHDLlqT3JJhRUhBc6cy8UOb4Dt+L9soT89uMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XFyobQmL; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XFyobQmL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784843012; x=1816379012;
  h=date:from:to:cc:subject:message-id;
  bh=t+rGoCZY2sHqccaAiALTddytC1TpKIZn0a5q2pJrh+A=;
  b=XFyobQmLXp6AePUYKmL9+HJ9idLsrFycQz2fQF2C29iPfPVCLwHW0lGW
   eNm7z0U8ittN3/LOoA6hOj1Jjg9boMOhalSASLxmrTlNK+yPTU2DS4dgA
   j8Ct7FywPn9WUI6ND/ILPeMpr9aLMhA4CuNW8CCXSkjLSN9xhUH8SntKT
   UmN9ARZm62Qi5lUBfW+ObtwhF/yYULxwxLsOHvf9Fbl+r9pcmKuUVLLW2
   0XuzT/HOWiijvB/01QGxTSFV87PboL5+lUjyZ02ZHQ7NNtvwZACFKJqo4
   wyYQcbMYJ7odG4SnckOUmx+Wqh32NBDZnU7ALpXgxims6GanTpqZMPo5H
   Q==;
X-CSE-ConnectionGUID: 3KBT7nLxSZeYaukR4EapDw==
X-CSE-MsgGUID: hVIigcL2Sfy9AFkJRfzHNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85271150"
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="85271150"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 14:43:30 -0700
X-CSE-ConnectionGUID: dmSTZz36QuablvY17kezMQ==
X-CSE-MsgGUID: K7KpBpj6RzahT6VbdtUBNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="258599189"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 23 Jul 2026 14:43:29 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wn1CQ-00000000a60-38NF;
	Thu, 23 Jul 2026 21:43:26 +0000
Date: Fri, 24 Jul 2026 05:42:42 +0800
From: kernel test robot <lkp@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org
Subject: [wireless:for-next] BUILD SUCCESS
 fec15bb3dab0c88dd513a5198173de66f830f289
Message-ID: <202607240501.dyxnO89i-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git for-next
branch HEAD: fec15bb3dab0c88dd513a5198173de66f830f289  Merge tag 'wireless-2026-07-22' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless

elapsed time: 803m

configs tested: 65
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260723    gcc-8.5.0
arc                  randconfig-002-20260723    gcc-11.5.0
arm                  randconfig-002-20260723    gcc-13.4.0
arm                  randconfig-003-20260723    gcc-8.5.0
arm                  randconfig-004-20260723    gcc-13.4.0
arm64                randconfig-002-20260723    gcc-15.2.0
arm64                randconfig-003-20260723    gcc-13.4.0
arm64                randconfig-004-20260723    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260723    gcc-15.2.0
csky                 randconfig-002-20260723    gcc-16.1.0
i386                            allmodconfig    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-002-20260723    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260723    gcc-8.5.0
nios2                randconfig-002-20260723    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260723    gcc-8.5.0
parisc               randconfig-002-20260723    gcc-10.5.0
powerpc              randconfig-001-20260723    gcc-8.5.0
powerpc              randconfig-002-20260723    clang-24
powerpc                        wii_defconfig    gcc-16.1.0
powerpc64            randconfig-001-20260723    gcc-10.5.0
powerpc64            randconfig-002-20260723    clang-18
riscv                randconfig-001-20260723    clang-24
riscv                randconfig-002-20260723    gcc-15.2.0
s390                 randconfig-001-20260723    gcc-8.5.0
s390                 randconfig-002-20260723    gcc-10.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260723    gcc-15.2.0
sh                   randconfig-002-20260723    gcc-16.1.0
sparc                randconfig-001-20260723    gcc-8.5.0
sparc                randconfig-002-20260723    gcc-8.5.0
sparc64              randconfig-002-20260723    gcc-8.5.0
um                   randconfig-002-20260723    clang-24
x86_64     buildonly-randconfig-001-20260723    gcc-14
x86_64     buildonly-randconfig-002-20260723    gcc-14
x86_64     buildonly-randconfig-003-20260723    clang-22
x86_64     buildonly-randconfig-004-20260723    gcc-14
x86_64     buildonly-randconfig-005-20260723    gcc-14
x86_64     buildonly-randconfig-006-20260723    gcc-12
x86_64               randconfig-001-20260723    clang-22
x86_64               randconfig-002-20260723    clang-22
x86_64               randconfig-003-20260723    clang-22
x86_64               randconfig-004-20260723    clang-22
x86_64               randconfig-005-20260723    clang-22
x86_64               randconfig-006-20260723    gcc-14
x86_64                        randconfig-011    gcc-14
x86_64               randconfig-011-20260723    gcc-14
x86_64               randconfig-012-20260723    gcc-14
x86_64               randconfig-013-20260723    clang-22
x86_64               randconfig-014-20260723    gcc-14
x86_64               randconfig-015-20260723    gcc-14
x86_64               randconfig-016-20260723    gcc-14
xtensa               randconfig-001-20260723    gcc-8.5.0
xtensa               randconfig-002-20260723    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
