Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C390035E1D1
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 20:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639005; cv=none; b=krN/9i3htgVYKjF/+MN3Nr4hMmQkUvoOO9s/bo+qyybslyjsYVM+A7xvfAsF1xv1WeRCSpj3vjiRYeLFdXZ5t5oiYSeuHj+KFT0YmG2r+JY8NY7mCYuLfrOD+Dh34xVNMNNuuQ6BJyPxASb7OerKXEyZis9rV1iJc9OfzqJ+m3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639005; c=relaxed/simple;
	bh=nwT9yDqpDXcGUSuOID+rILOrmqUoS/3GbI8wSaYl5yA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=iTEUOo3JQFDrwYJcJTQNbfMJo3jOSiRaSA9hSoLM6rLkNHvMBmLXV+0jZNzcbAEPk1LTeQCahAfTa0mTTxK1DvAY40DeOgVb4Qf+0s2YQPXmyi5H6DM8jHdgC5sgJXfs96uJ8B129hQax3PvW3XEjdXYJlXKbPwofH4WxLW0g9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mzXQZ0mW; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzXQZ0mW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788639003; x=1820175003;
  h=date:from:to:cc:subject:message-id;
  bh=nwT9yDqpDXcGUSuOID+rILOrmqUoS/3GbI8wSaYl5yA=;
  b=mzXQZ0mWWNpUK+PAQvrQfHl3tYn9nvf4Ky4f7gsOoy9/+2tdV3bSI8mV
   9fKPxgyy1NL7pt+K1AoQZqDg7kyemgL0Mn4FUFPZ+8/F4QfLWOJ0S2wyK
   M6vvZx42R20lkIcqCEwPR2mMXiYEB3UMoQkb4psQ3FydipAXhO6cddnty
   fw2iM31e5kSKM9OrJ9dpb6HcCqp98HLWIEoeKTn+4zKtDj/5udqN/nJqw
   LD19slFV3xlzozU0mcChGmEkKRo9dx/AJPMHY2dT3vgau1zxWDnVVCJei
   0C76KVETgq6K2cc3ZtHtgoh03jvoZVcWxZKolprpv8Dltpu4j7Yqi6rXK
   w==;
X-CSE-ConnectionGUID: x6+qfrckTDitkS+h/98CRg==
X-CSE-MsgGUID: hkU+8CLgTSC8vbOClRpURw==
X-IronPort-AV: E=McAfee;i="6800,10657,11897"; a="100263660"
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="100263660"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2026 13:10:01 -0700
X-CSE-ConnectionGUID: 8kf+ncu9QNOKQ2hwQltGqQ==
X-CSE-MsgGUID: eWq/wcPQQVq47TK3QjApzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="272290862"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 05 Sep 2026 13:10:00 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2wi6-0000000014B-1bRt;
	Sat, 05 Sep 2026 20:09:58 +0000
Date: Sun, 06 Sep 2026 04:09:34 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD SUCCESS
 1b60ed34f712e9f606d80951f1586f4274ebadf1
Message-ID: <202609060432.aDPv6VVT-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: 1b60ed34f712e9f606d80951f1586f4274ebadf1  wifi: mac80211: serialize debugfs netdev rename with recreate

elapsed time: 1965m

configs tested: 55
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2         allnoconfig    clang-24
openrisc     allmodconfig    clang-20
openrisc      allnoconfig    clang-24
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc       allyesconfig    clang-17
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh           allyesconfig    clang-17
sparc         allnoconfig    clang-24
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa       allyesconfig    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
