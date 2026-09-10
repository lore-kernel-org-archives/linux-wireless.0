Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D1D23A9BD
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 15:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053948; cv=none; b=dhuDn3nrElEDGdK+6sh/qp0sbmz47I25Ksu0U9gWXKOKYLrDWeRvJuz0BJSOexCiTaI3NJziVVMbqGRkK5xPxL1H4zWNF6yj86/jeT2cDAQw8RBIrSCEt+FcxcRNdqczqFK3Qcg3//sXukRgpG6mw3dFm+qYiM1ERlu1RwGwlCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053948; c=relaxed/simple;
	bh=okoBNY1dNCHS8woOvrVNB1fM21D5Vc1L6/rFDr7mHB4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=RdAfx+ACdX0HgkZyBQBkl0YeATXEB1ehVEdFbk3YixAGmnrRGmUhjCcZTE5VJyiRj+zY0IdSk6gUo2Kl//okgBKFqJl9e00axDJybpNkM/FJGhbdUr0R0lKmSuSHBPTF6pizemXdJDoj/RAYBAJY5DagSCSHClmNHAHqK3vwCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nDxzaoCh; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nDxzaoCh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789053946; x=1820589946;
  h=date:from:to:cc:subject:message-id;
  bh=okoBNY1dNCHS8woOvrVNB1fM21D5Vc1L6/rFDr7mHB4=;
  b=nDxzaoChb+WcVckNt070U7x26MgE/57pAIz1aSaSZ1Wx9npr/OBsa4B9
   gb/kLbCbtxy9mX22bJfC6OgF9akJiVRkGflcPkMGLED0icSDxJRHBNBB/
   z6EXlirnWErir+rSSlua1lxBzvKgy/LLlHjDHGZP28Gt0af3PnG3LMUjC
   L37tRL2GxhPkcHKgkg5I42TTd+M4KYSmJXEx1XbRtH1Gnd0AVSftnN6wW
   tLdW1yz+goaoUhT/Uo04MCHdPeu27xGkrR7w47CESk2kQq+9IGF6zyytz
   y6+2qtUaUqHJmFQ/NqePgdBUdNe9aJKxSRcMNzkI/PmFTlvJ3xAiBduGL
   w==;
X-CSE-ConnectionGUID: 8y73ej0oQXynTYfezjNK+g==
X-CSE-MsgGUID: 80jagAMMTu+OAtco4oYB6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="101025502"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="101025502"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:25:41 -0700
X-CSE-ConnectionGUID: rEl7Q/zGQleu+B6WI/CayA==
X-CSE-MsgGUID: yT6SxDT7TkawQCGFzdcS2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="275189632"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 10 Sep 2026 08:25:40 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4ge0-000000000Dt-2YTJ;
	Thu, 10 Sep 2026 15:25:18 +0000
Date: Thu, 10 Sep 2026 23:01:51 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless:for-next] BUILD SUCCESS
 50d3d79dc0743b616afb00d01a626c76758721f7
Message-ID: <202609102349.nE4RbaoH-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git for-next
branch HEAD: 50d3d79dc0743b616afb00d01a626c76758721f7  wifi: mac80211: set up the TX info early to fix failure paths

elapsed time: 1563m

configs tested: 84
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha          allnoconfig    gcc-16.1.0
alpha         allyesconfig    gcc-16.1.0
arc           allmodconfig    clang-24
arc           allmodconfig    gcc-16.1.0
arc            allnoconfig    gcc-16.1.0
arc           allyesconfig    clang-24
arc           allyesconfig    gcc-16.1.0
arm            allnoconfig    clang-17
arm            allnoconfig    gcc-16.1.0
arm           allyesconfig    clang-24
arm           allyesconfig    gcc-16.1.0
arm64         allmodconfig    clang-24
arm64          allnoconfig    gcc-16.1.0
csky          allmodconfig    gcc-16.1.0
csky           allnoconfig    gcc-16.1.0
hexagon       allmodconfig    clang-24
hexagon       allmodconfig    gcc-16.1.0
hexagon        allnoconfig    clang-24
hexagon        allnoconfig    gcc-16.1.0
i386          allmodconfig    clang-22
i386          allmodconfig    gcc-14
i386           allnoconfig    gcc-14
i386           allnoconfig    gcc-16.1.0
i386          allyesconfig    clang-22
i386          allyesconfig    gcc-14
loongarch     allmodconfig    clang-19
loongarch     allmodconfig    clang-24
loongarch      allnoconfig    clang-20
loongarch      allnoconfig    gcc-16.1.0
m68k          allmodconfig    gcc-16.1.0
m68k           allnoconfig    gcc-16.1.0
m68k          allyesconfig    clang-24
m68k          allyesconfig    gcc-16.1.0
microblaze     allnoconfig    gcc-16.1.0
microblaze    allyesconfig    gcc-16.1.0
mips          allmodconfig    gcc-16.1.0
mips           allnoconfig    gcc-16.1.0
mips          allyesconfig    gcc-16.1.0
nios2         allmodconfig    clang-20
nios2         allmodconfig    gcc-11.5.0
nios2          allnoconfig    clang-24
nios2          allnoconfig    gcc-11.5.0
openrisc      allmodconfig    clang-20
openrisc      allmodconfig    gcc-16.1.0
openrisc       allnoconfig    clang-24
openrisc       allnoconfig    gcc-16.1.0
parisc        allmodconfig    gcc-16.1.0
parisc         allnoconfig    clang-24
parisc         allnoconfig    gcc-16.1.0
parisc        allyesconfig    gcc-16.1.0
powerpc       allmodconfig    gcc-16.1.0
powerpc        allnoconfig    clang-24
powerpc        allnoconfig    gcc-16.1.0
riscv         allmodconfig    clang-24
riscv          allnoconfig    clang-24
riscv          allnoconfig    gcc-16.1.0
riscv         allyesconfig    clang-24
s390          allmodconfig    clang-24
s390           allnoconfig    clang-24
s390          allyesconfig    gcc-16.1.0
sh            allmodconfig    gcc-16.1.0
sh             allnoconfig    clang-24
sh             allnoconfig    gcc-16.1.0
sh            allyesconfig    gcc-16.1.0
sparc          allnoconfig    clang-24
sparc          allnoconfig    gcc-16.1.0
sparc64       allmodconfig    clang-20
um            allmodconfig    clang-17
um             allnoconfig    clang-17
um             allnoconfig    clang-24
um            allyesconfig    gcc-14
um            allyesconfig    gcc-16.1.0
x86_64        allmodconfig    clang-22
x86_64         allnoconfig    clang-22
x86_64         allnoconfig    clang-24
x86_64        allyesconfig    clang-22
x86_64        rhel-9.4-bpf    gcc-14
x86_64      rhel-9.4-kunit    gcc-14
x86_64        rhel-9.4-ltp    gcc-14
x86_64       rhel-9.4-rust    clang-22
xtensa         allnoconfig    clang-24
xtensa         allnoconfig    gcc-16.1.0
xtensa        allyesconfig    clang-20
xtensa        allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
