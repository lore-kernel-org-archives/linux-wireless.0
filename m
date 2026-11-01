Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793554094;
	b=D6eMUQ3ZwR4miQaCKaVXBlI+LDB7eWlVPZL+uj4R9/G3t4JNH6rVrhkR5Mxzll5C8vVt
	 HkPhiKvdAIkA9wfnGpcrGXCtsMkdhb7YxPb72kGcaGBuTM7gZTbBr9v0FnLyh9JbZ+xu0
	 LJvSoEEoA2tgOd2aaQaU/uilkIa/DvgzoTuZBOykhns2kALUWpfwzkkxTcJIIHvwqFyAC
	 3NA+4S46sYhwxPDC0GUJB0pES3lcLc24C2a5PbZsrE5GCGc/CBUJ8bB8AcSAzTwFlpG63
	 wZsMBegjHuOoaeKj416wLrWJz0ONu3Fy7Q64w6kd0NCaSueHZz9fm6juoWBkW8dE61Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793554094;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=CRAStBrU7ApA8b0JvN2FNrVXp14rENnJVveUPHEE8KA=;
	b=v451//RBRcCqV/TDIaNZRX35JmHqzMZ/E5npJz9QxJinh5xUiZTQRdGjpr1d0PM355zv
	 mnkoxmOiC73Lf9IynlRQKs0qBLDG6f5x4V0PfllIhnJGGKzHB2Cdl6PeVaMYfm0nIFQbz
	 H44aCKeEkn2ftyAeABUUkXE75PjQo1qwIjj/ni/J1ZAUNzW7yeUxt29+l8g5bAXgXdXP+
	 N7OZNQCWQcoGeSFyZA777zG2DpcXR91Ik1nTKkaYcjlw71lZbfj5ssEYaiJoytya+VXeV
	 qFJuql9A0dVTtmjqpVgeMSo/ygwntrVKTG9my5tpyh2YE3Uh0dB0dAqQ5VedTvVvyEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XJJqDXM3;
	arc=none smtp.remote-ip=198.175.65.14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE34606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 17:28:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EE34606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XJJqDXM3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793554094; x=1825090094;
  h=date:from:to:cc:subject:message-id;
  bh=WNDPBQ2o+qztve8BU0bpwTw9jTmoIoQoAE3KP93KP+0=;
  b=XJJqDXM3nNmqMVmx5MounNIyRI/NyDPcCRcBBzE6SW7ks+ygo2oCEDJ+
   PktQ4BaaZguayXO0Q4ABJY1QzG7hrWOBcGPK6V88cyEXhPXyZw9nzc2K8
   Po20EKMHxZFPM0p+apSxTmFcvbcwo/A+7uQlrxgfCihBtkfga9Ozw6flT
   vk5Y2fwmnh16rNA+FoMIXSmWw/6ENSLCcx0QUMdaWxtPI4IR8IHp7fcJz
   HL7Xbv913ydqULT674JmB+xBp1byRe2VoZbvPv04OLlmbGNK48zHUPdae
   4zQL9ApYv+071d4NCylY2yqMciDBGCCZRKEgl0cGlUmhvaAMPgUgVHsjS
   Q==;
X-CSE-ConnectionGUID: jThxTxBNQnu6LRlgKQ9PVQ==
X-CSE-MsgGUID: IRFJpNJwT2+ir9mjvepYXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11953"; a="2129128"
X-IronPort-AV: E=Sophos;i="6.27,190,1787036400"; 
   d="scan'208";a="2129128"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2026 09:28:13 -0800
X-CSE-ConnectionGUID: 1KMobIpiT8O78nH/GPDtqQ==
X-CSE-MsgGUID: hwr5WfMORHKmLdl/RPGQ/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,190,1787036400"; 
   d="scan'208";a="6013234"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 01 Nov 2026 09:28:11 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xNZLl-00000000eY4-1i5x;
	Sun, 01 Nov 2026 17:28:09 +0000
Date: Mon, 02 Nov 2026 01:27:11 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless:main] BUILD SUCCESS
 25e73f1d6868c759c8eb56cad4e411692c5341b4
Message-ID: <20261102012711.PtYlygWp-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git main
branch HEAD: 25e73f1d6868c759c8eb56cad4e411692c5341b4  wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()

elapsed time: 8388m

configs tested: 763
configs skipped: 31

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    clang-24
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-19
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                             hsdk_defconfig    clang-24
arc                      nsimosci_hs_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261027    gcc-10.5.0
arc                   randconfig-1000-20261028    gcc-8.5.0
arc                   randconfig-1000-20261029    clang-24
arc                   randconfig-1000-20261030    gcc-12.5.0
arc                   randconfig-1000-20261031    gcc-9.5.0
arc                   randconfig-1000-20261101    clang-22
arc                   randconfig-1001-20261027    gcc-10.5.0
arc                   randconfig-1001-20261028    gcc-8.5.0
arc                   randconfig-1001-20261029    clang-24
arc                   randconfig-1001-20261030    gcc-12.5.0
arc                   randconfig-1001-20261031    gcc-9.5.0
arc                   randconfig-1001-20261101    clang-22
arc                            tb10x_defconfig    gcc-16.2.0
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                          assabet_defconfig    clang-24
arm                          axm55xx_defconfig    gcc-16.2.0
arm                           collie_defconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                       footbridge_defconfig    gcc-16.2.0
arm                           gemini_defconfig    gcc-16.2.0
arm                            h3600_defconfig    clang-24
arm                        imx_v4_v5_defconfig    clang-24
arm                        imx_v4_v5_defconfig    gcc-16.2.0
arm                            imxrt_defconfig    gcc-16.2.0
arm                    milbeaut_m10v_defconfig    gcc-16.2.0
arm                             mps2_defconfig    clang-24
arm                         multi_v5_defconfig    clang-24
arm                          mv78xx0_defconfig    gcc-16.2.0
arm                         mvebu_v5_defconfig    clang-17
arm                              mxs_defconfig    clang-17
arm                          nhk8815_defconfig    clang-24
arm                        omap2plus_defconfig    gcc-14
arm                           pxa168_defconfig    gcc-16.2.0
arm                           pxa3xx_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261027    gcc-10.5.0
arm                   randconfig-1000-20261028    gcc-8.5.0
arm                   randconfig-1000-20261029    clang-24
arm                   randconfig-1000-20261030    gcc-12.5.0
arm                   randconfig-1000-20261031    gcc-9.5.0
arm                   randconfig-1000-20261101    clang-22
arm                   randconfig-1001-20261027    gcc-10.5.0
arm                   randconfig-1001-20261028    gcc-8.5.0
arm                   randconfig-1001-20261029    clang-24
arm                   randconfig-1001-20261030    gcc-12.5.0
arm                   randconfig-1001-20261031    gcc-9.5.0
arm                   randconfig-1001-20261101    clang-22
arm                   randconfig-1002-20261027    gcc-10.5.0
arm                   randconfig-1002-20261028    gcc-8.5.0
arm                   randconfig-1002-20261029    clang-24
arm                   randconfig-1002-20261030    gcc-12.5.0
arm                   randconfig-1002-20261031    gcc-9.5.0
arm                   randconfig-1002-20261101    clang-22
arm                   randconfig-1003-20261027    gcc-10.5.0
arm                   randconfig-1003-20261028    gcc-8.5.0
arm                   randconfig-1003-20261029    clang-24
arm                   randconfig-1003-20261030    gcc-12.5.0
arm                   randconfig-1003-20261031    gcc-9.5.0
arm                   randconfig-1003-20261101    clang-22
arm                         realview_defconfig    gcc-16.2.0
arm                              rpc_defconfig    gcc-16.2.0
arm                          s3c6400_defconfig    gcc-16.2.0
arm                          s5pv210_defconfig    clang-24
arm                            sama7_defconfig    clang-24
arm                          socfpga_defconfig    gcc-16.2.0
arm                        spear13xx_defconfig    clang-24
arm                         spear3xx_defconfig    gcc-16.2.0
arm                            spitz_defconfig    gcc-16.2.0
arm                            tegra_defconfig    gcc-16.2.0
arm                     vt8500_v6_v7_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261027    gcc-8.5.0
arm64                 randconfig-1000-20261028    clang-22
arm64                 randconfig-1000-20261029    gcc-8.5.0
arm64                 randconfig-1000-20261030    gcc-13.5.0
arm64                 randconfig-1000-20261031    clang-24
arm64                 randconfig-1000-20261101    clang-22
arm64                 randconfig-1001-20261027    gcc-8.5.0
arm64                 randconfig-1001-20261028    clang-22
arm64                 randconfig-1001-20261029    gcc-8.5.0
arm64                 randconfig-1001-20261030    gcc-13.5.0
arm64                 randconfig-1001-20261031    clang-24
arm64                 randconfig-1001-20261101    clang-22
arm64                 randconfig-1002-20261027    gcc-8.5.0
arm64                 randconfig-1002-20261028    clang-22
arm64                 randconfig-1002-20261029    gcc-8.5.0
arm64                 randconfig-1002-20261030    gcc-13.5.0
arm64                 randconfig-1002-20261031    clang-24
arm64                 randconfig-1002-20261101    clang-22
arm64                 randconfig-1003-20261027    gcc-8.5.0
arm64                 randconfig-1003-20261028    clang-22
arm64                 randconfig-1003-20261029    gcc-8.5.0
arm64                 randconfig-1003-20261030    gcc-13.5.0
arm64                 randconfig-1003-20261031    clang-24
arm64                 randconfig-1003-20261101    clang-22
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261027    gcc-8.5.0
csky                  randconfig-1000-20261028    clang-22
csky                  randconfig-1000-20261029    gcc-8.5.0
csky                  randconfig-1000-20261030    gcc-13.5.0
csky                  randconfig-1000-20261031    clang-24
csky                  randconfig-1000-20261101    clang-22
csky                  randconfig-1001-20261027    gcc-8.5.0
csky                  randconfig-1001-20261028    clang-22
csky                  randconfig-1001-20261029    gcc-8.5.0
csky                  randconfig-1001-20261030    gcc-13.5.0
csky                  randconfig-1001-20261031    clang-24
csky                  randconfig-1001-20261101    clang-22
hexagon                           alldefconfig    clang-17
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261027    clang-24
hexagon               randconfig-1000-20261028    clang-17
hexagon               randconfig-1000-20261029    clang-24
hexagon               randconfig-1000-20261030    gcc-11.5.0
hexagon               randconfig-1000-20261031    gcc-11.5.0
hexagon               randconfig-1000-20261101    gcc-16.2.0
hexagon               randconfig-1001-20261027    clang-24
hexagon               randconfig-1001-20261028    clang-17
hexagon               randconfig-1001-20261029    clang-24
hexagon               randconfig-1001-20261030    gcc-11.5.0
hexagon               randconfig-1001-20261031    gcc-11.5.0
hexagon               randconfig-1001-20261101    gcc-16.2.0
i386                              alldefconfig    clang-24
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261027    clang-22
i386        buildonly-randconfig-1000-20261028    clang-22
i386        buildonly-randconfig-1000-20261029    gcc-14
i386        buildonly-randconfig-1000-20261030    clang-22
i386        buildonly-randconfig-1000-20261031    clang-22
i386        buildonly-randconfig-1000-20261101    gcc-14
i386        buildonly-randconfig-1001-20261027    clang-22
i386        buildonly-randconfig-1001-20261028    clang-22
i386        buildonly-randconfig-1001-20261029    gcc-14
i386        buildonly-randconfig-1001-20261030    clang-22
i386        buildonly-randconfig-1001-20261031    clang-22
i386        buildonly-randconfig-1001-20261101    gcc-14
i386        buildonly-randconfig-1002-20261027    clang-22
i386        buildonly-randconfig-1002-20261028    clang-22
i386        buildonly-randconfig-1002-20261029    gcc-14
i386        buildonly-randconfig-1002-20261030    clang-22
i386        buildonly-randconfig-1002-20261031    clang-22
i386        buildonly-randconfig-1002-20261101    gcc-14
i386        buildonly-randconfig-1003-20261027    clang-22
i386        buildonly-randconfig-1003-20261028    clang-22
i386        buildonly-randconfig-1003-20261029    gcc-14
i386        buildonly-randconfig-1003-20261030    clang-22
i386        buildonly-randconfig-1003-20261031    clang-22
i386        buildonly-randconfig-1003-20261101    gcc-14
i386        buildonly-randconfig-1004-20261027    clang-22
i386        buildonly-randconfig-1004-20261028    clang-22
i386        buildonly-randconfig-1004-20261029    gcc-14
i386        buildonly-randconfig-1004-20261030    clang-22
i386        buildonly-randconfig-1004-20261031    clang-22
i386        buildonly-randconfig-1004-20261101    gcc-14
i386        buildonly-randconfig-1005-20261027    clang-22
i386        buildonly-randconfig-1005-20261028    clang-22
i386        buildonly-randconfig-1005-20261029    gcc-14
i386        buildonly-randconfig-1005-20261030    clang-22
i386        buildonly-randconfig-1005-20261031    clang-22
i386        buildonly-randconfig-1005-20261101    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261027    gcc-14
i386                  randconfig-1000-20261028    gcc-14
i386                  randconfig-1000-20261029    clang-22
i386                  randconfig-1000-20261030    clang-22
i386                  randconfig-1000-20261031    clang-22
i386                  randconfig-1000-20261101    gcc-14
i386                  randconfig-1001-20261027    gcc-14
i386                  randconfig-1001-20261028    gcc-14
i386                  randconfig-1001-20261029    clang-22
i386                  randconfig-1001-20261030    clang-22
i386                  randconfig-1001-20261031    clang-22
i386                  randconfig-1001-20261101    gcc-14
i386                  randconfig-1002-20261027    gcc-14
i386                  randconfig-1002-20261028    gcc-14
i386                  randconfig-1002-20261029    clang-22
i386                  randconfig-1002-20261030    clang-22
i386                  randconfig-1002-20261031    clang-22
i386                  randconfig-1002-20261101    gcc-14
i386                  randconfig-1003-20261027    gcc-14
i386                  randconfig-1003-20261028    gcc-14
i386                  randconfig-1003-20261029    clang-22
i386                  randconfig-1003-20261030    clang-22
i386                  randconfig-1003-20261031    clang-22
i386                  randconfig-1003-20261101    gcc-14
i386                  randconfig-1004-20261027    gcc-14
i386                  randconfig-1004-20261028    gcc-14
i386                  randconfig-1004-20261029    clang-22
i386                  randconfig-1004-20261030    clang-22
i386                  randconfig-1004-20261031    clang-22
i386                  randconfig-1004-20261101    gcc-14
i386                  randconfig-1005-20261027    gcc-14
i386                  randconfig-1005-20261028    gcc-14
i386                  randconfig-1005-20261029    clang-22
i386                  randconfig-1005-20261030    clang-22
i386                  randconfig-1005-20261031    clang-22
i386                  randconfig-1005-20261101    gcc-14
i386                  randconfig-1006-20261027    gcc-14
i386                  randconfig-1006-20261028    gcc-14
i386                  randconfig-1006-20261029    clang-22
i386                  randconfig-1006-20261030    clang-22
i386                  randconfig-1006-20261031    clang-22
i386                  randconfig-1006-20261101    gcc-14
i386                  randconfig-1007-20261027    gcc-14
i386                  randconfig-1007-20261028    clang-22
i386                  randconfig-1007-20261029    clang-22
i386                  randconfig-1007-20261030    clang-22
i386                  randconfig-1007-20261031    gcc-14
i386                  randconfig-1007-20261101    clang-22
i386                  randconfig-1008-20261027    gcc-14
i386                  randconfig-1008-20261028    clang-22
i386                  randconfig-1008-20261029    clang-22
i386                  randconfig-1008-20261030    clang-22
i386                  randconfig-1008-20261031    gcc-14
i386                  randconfig-1008-20261101    clang-22
i386                  randconfig-1009-20261027    gcc-14
i386                  randconfig-1009-20261028    clang-22
i386                  randconfig-1009-20261029    clang-22
i386                  randconfig-1009-20261030    clang-22
i386                  randconfig-1009-20261031    gcc-14
i386                  randconfig-1009-20261101    clang-22
i386                  randconfig-1010-20261027    gcc-14
i386                  randconfig-1010-20261028    clang-22
i386                  randconfig-1010-20261029    clang-22
i386                  randconfig-1010-20261030    clang-22
i386                  randconfig-1010-20261031    gcc-14
i386                  randconfig-1010-20261101    clang-22
i386                  randconfig-1011-20261027    gcc-14
i386                  randconfig-1011-20261028    clang-22
i386                  randconfig-1011-20261029    clang-22
i386                  randconfig-1011-20261030    clang-22
i386                  randconfig-1011-20261031    gcc-14
i386                  randconfig-1011-20261101    clang-22
i386                  randconfig-1012-20261027    gcc-14
i386                  randconfig-1012-20261028    clang-22
i386                  randconfig-1012-20261029    clang-22
i386                  randconfig-1012-20261030    clang-22
i386                  randconfig-1012-20261031    gcc-14
i386                  randconfig-1012-20261101    clang-22
i386                  randconfig-1013-20261027    gcc-14
i386                  randconfig-1013-20261028    clang-22
i386                  randconfig-1013-20261029    clang-22
i386                  randconfig-1013-20261030    clang-22
i386                  randconfig-1013-20261031    gcc-14
i386                  randconfig-1013-20261101    clang-22
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch                 loongson64_defconfig    gcc-16.2.0
loongarch             randconfig-1000-20261027    clang-24
loongarch             randconfig-1000-20261028    clang-17
loongarch             randconfig-1000-20261029    clang-24
loongarch             randconfig-1000-20261030    gcc-11.5.0
loongarch             randconfig-1000-20261031    gcc-11.5.0
loongarch             randconfig-1000-20261101    gcc-16.2.0
loongarch             randconfig-1001-20261027    clang-24
loongarch             randconfig-1001-20261028    clang-17
loongarch             randconfig-1001-20261029    clang-24
loongarch             randconfig-1001-20261030    gcc-11.5.0
loongarch             randconfig-1001-20261031    gcc-11.5.0
loongarch             randconfig-1001-20261101    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                          amcore_defconfig    gcc-16.2.0
m68k                           amiga_defconfig    clang-17
m68k                           amiga_defconfig    clang-22
m68k                           amiga_defconfig    gcc-16.2.0
m68k                          apollo_defconfig    clang-24
m68k                        bvme6000_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5208evb_defconfig    clang-17
m68k                         m5272c3_defconfig    clang-24
m68k                         m5272c3_defconfig    gcc-16.2.0
m68k                        m5275evb_defconfig    clang-22
m68k                        m5282evb_defconfig    clang-24
m68k                         m5307c3_defconfig    clang-17
m68k                       m54418evb_defconfig    clang-17
m68k                        m5475evb_defconfig    clang-24
m68k                         mvme147_defconfig    clang-17
m68k                          nettel_defconfig    clang-17
m68k                          nettel_defconfig    gcc-16.2.0
m68k                         stmark2_defconfig    clang-24
m68k                            sun3_defconfig    clang-24
m68k                            sun3_defconfig    gcc-16.2.0
m68k                            virt_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                          bigsur_defconfig    clang-24
mips                          bigsur_defconfig    gcc-16.2.0
mips                        bmips_be_defconfig    gcc-16.2.0
mips                          cobalt_defconfig    gcc-16.2.0
mips                          db1xxx_defconfig    gcc-16.2.0
mips                   decstation_64_defconfig    gcc-16.2.0
mips                      decstation_defconfig    gcc-16.2.0
mips                  decstation_r4k_defconfig    gcc-16.2.0
mips                            ip32_defconfig    gcc-16.2.0
mips                        lemote2f_defconfig    clang-22
mips                       loongson1_defconfig    gcc-14
mips                      loongson2k_defconfig    gcc-16.2.0
mips                       malta_kvm_defconfig    gcc-14
mips                       maltaaprp_defconfig    clang-17
mips                       maltasmvp_defconfig    gcc-16.2.0
mips                         maltaup_defconfig    gcc-14
mips                         maltaup_defconfig    gcc-16.2.0
mips                     maltaup_xpa_defconfig    gcc-16.2.0
mips                            mtx1_defconfig    gcc-16.2.0
mips                         qi_lb60_defconfig    clang-17
mips                           rb532_defconfig    clang-24
mips                           rm200_defconfig    clang-24
nios2                          3c120_defconfig    clang-24
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261027    clang-24
nios2                 randconfig-1000-20261028    clang-17
nios2                 randconfig-1000-20261029    clang-24
nios2                 randconfig-1000-20261030    gcc-11.5.0
nios2                 randconfig-1000-20261031    gcc-11.5.0
nios2                 randconfig-1000-20261101    gcc-16.2.0
nios2                 randconfig-1001-20261027    clang-24
nios2                 randconfig-1001-20261028    clang-17
nios2                 randconfig-1001-20261029    clang-24
nios2                 randconfig-1001-20261030    gcc-11.5.0
nios2                 randconfig-1001-20261031    gcc-11.5.0
nios2                 randconfig-1001-20261101    gcc-16.2.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc          de0_nano_multicore_defconfig    clang-17
openrisc          de0_nano_multicore_defconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc                     or1ksim_defconfig    clang-24
openrisc                        virt_defconfig    clang-24
parisc                            alldefconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261027    clang-22
parisc                randconfig-1000-20261028    clang-19
parisc                randconfig-1000-20261029    clang-17
parisc                randconfig-1000-20261030    gcc-16.2.0
parisc                randconfig-1000-20261031    gcc-13.5.0
parisc                randconfig-1000-20261101    gcc-8.5.0
parisc                randconfig-1001-20261027    clang-22
parisc                randconfig-1001-20261028    clang-19
parisc                randconfig-1001-20261029    clang-17
parisc                randconfig-1001-20261030    gcc-16.2.0
parisc                randconfig-1001-20261031    gcc-13.5.0
parisc                randconfig-1001-20261101    gcc-8.5.0
parisc64                             defconfig    clang-24
powerpc                     adder875_defconfig    gcc-16.2.0
powerpc                      akebono_defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                     amigaone_defconfig    gcc-16.2.0
powerpc                      asp8347_defconfig    clang-24
powerpc                       bamboo_defconfig    clang-24
powerpc                       bamboo_defconfig    gcc-16.2.0
powerpc                  canyonlands_defconfig    clang-17
powerpc                  canyonlands_defconfig    clang-22
powerpc                       cm5200_defconfig    clang-24
powerpc                    currituck_defconfig    clang-17
powerpc                    currituck_defconfig    gcc-16.2.0
powerpc                      ep8248e_defconfig    clang-22
powerpc                           g5_defconfig    clang-24
powerpc                           g5_defconfig    gcc-16.2.0
powerpc                     ge_imp3a_defconfig    clang-24
powerpc                     ge_imp3a_defconfig    gcc-16.2.0
powerpc                        holly_defconfig    clang-17
powerpc                        holly_defconfig    clang-24
powerpc                         icon_defconfig    gcc-16.2.0
powerpc                   iss476-smp_defconfig    gcc-16.2.0
powerpc                    lite5200b_defconfig    gcc-16.2.0
powerpc                    microwatt_defconfig    clang-24
powerpc                    microwatt_defconfig    gcc-16.2.0
powerpc                    motionpro_defconfig    clang-24
powerpc                      mpc5200_defconfig    clang-24
powerpc                  mpc8313_rdb_defconfig    clang-24
powerpc                  mpc8315_rdb_defconfig    gcc-16.2.0
powerpc                  mpc834x_itx_defconfig    clang-24
powerpc                mpc834x_itxgp_defconfig    gcc-16.2.0
powerpc                   mpc885_ads_defconfig    clang-17
powerpc                   mpc885_ads_defconfig    gcc-16.2.0
powerpc                     mvme5100_defconfig    clang-24
powerpc                       pasemi_defconfig    clang-24
powerpc                       pcm030_defconfig    clang-17
powerpc                       pmac32_defconfig    gcc-16.2.0
powerpc                      powernv_defconfig    gcc-16.2.0
powerpc                       ppc44x_defconfig    clang-24
powerpc                       ppc64e_defconfig    clang-24
powerpc               randconfig-1000-20261027    clang-22
powerpc               randconfig-1000-20261028    clang-19
powerpc               randconfig-1000-20261029    clang-17
powerpc               randconfig-1000-20261030    gcc-16.2.0
powerpc               randconfig-1000-20261031    gcc-13.5.0
powerpc               randconfig-1000-20261101    gcc-8.5.0
powerpc               randconfig-1001-20261027    clang-22
powerpc               randconfig-1001-20261028    clang-19
powerpc               randconfig-1001-20261029    clang-17
powerpc               randconfig-1001-20261030    gcc-16.2.0
powerpc               randconfig-1001-20261031    gcc-13.5.0
powerpc               randconfig-1001-20261101    gcc-8.5.0
powerpc                     sam440ep_defconfig    clang-22
powerpc                     sam440ep_defconfig    clang-24
powerpc                      skiroot_defconfig    clang-24
powerpc                     socrates_defconfig    gcc-16.2.0
powerpc                   storcenter_defconfig    clang-24
powerpc                   storcenter_defconfig    gcc-16.2.0
powerpc                      stx_gp3_defconfig    clang-17
powerpc                      stx_gp3_defconfig    gcc-14
powerpc                      tqm8548_defconfig    gcc-16.2.0
powerpc                      tqm8555_defconfig    clang-24
powerpc                      tqm8560_defconfig    clang-17
powerpc                         warp_defconfig    gcc-16.2.0
powerpc                          wii_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261027    clang-22
powerpc64             randconfig-1000-20261028    clang-19
powerpc64             randconfig-1000-20261029    clang-17
powerpc64             randconfig-1000-20261030    gcc-16.2.0
powerpc64             randconfig-1000-20261031    gcc-13.5.0
powerpc64             randconfig-1000-20261101    gcc-8.5.0
powerpc64             randconfig-1001-20261027    clang-22
powerpc64             randconfig-1001-20261028    clang-19
powerpc64             randconfig-1001-20261029    clang-17
powerpc64             randconfig-1001-20261030    gcc-16.2.0
powerpc64             randconfig-1001-20261031    gcc-13.5.0
powerpc64             randconfig-1001-20261101    gcc-8.5.0
riscv                             alldefconfig    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261027    gcc-16.2.0
riscv                 randconfig-1000-20261028    gcc-11.5.0
riscv                 randconfig-1000-20261029    gcc-10.5.0
riscv                 randconfig-1000-20261030    gcc-11.5.0
riscv                 randconfig-1000-20261031    gcc-8.5.0
riscv                 randconfig-1000-20261101    gcc-8.5.0
riscv                 randconfig-1001-20261027    gcc-16.2.0
riscv                 randconfig-1001-20261028    gcc-11.5.0
riscv                 randconfig-1001-20261029    gcc-10.5.0
riscv                 randconfig-1001-20261030    gcc-11.5.0
riscv                 randconfig-1001-20261031    gcc-8.5.0
riscv                 randconfig-1001-20261101    gcc-8.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                           debug_defconfig    clang-17
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261027    gcc-16.2.0
s390                  randconfig-1000-20261028    gcc-11.5.0
s390                  randconfig-1000-20261029    gcc-10.5.0
s390                  randconfig-1000-20261030    gcc-11.5.0
s390                  randconfig-1000-20261031    gcc-8.5.0
s390                  randconfig-1000-20261101    gcc-8.5.0
s390                  randconfig-1001-20261027    gcc-16.2.0
s390                  randconfig-1001-20261028    gcc-11.5.0
s390                  randconfig-1001-20261029    gcc-10.5.0
s390                  randconfig-1001-20261030    gcc-11.5.0
s390                  randconfig-1001-20261031    gcc-8.5.0
s390                  randconfig-1001-20261101    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                          ap325rxa_defconfig    gcc-16.2.0
sh                          apsh4a3a_defconfig    gcc-14
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    clang-22
sh                         dreamcast_defconfig    gcc-16.2.0
sh                          ecovec24_defconfig    gcc-16.2.0
sh                             hp6xx_defconfig    clang-24
sh                                j2_defconfig    clang-24
sh                  kfr2r09-romimage_defconfig    clang-24
sh                      magicpanelr2_defconfig    clang-17
sh                           polaris_defconfig    gcc-16.2.0
sh                           r7780mp_defconfig    clang-24
sh                    randconfig-1000-20261027    gcc-16.2.0
sh                    randconfig-1000-20261028    gcc-11.5.0
sh                    randconfig-1000-20261029    gcc-10.5.0
sh                    randconfig-1000-20261030    gcc-11.5.0
sh                    randconfig-1000-20261031    gcc-8.5.0
sh                    randconfig-1000-20261101    gcc-8.5.0
sh                    randconfig-1001-20261027    gcc-16.2.0
sh                    randconfig-1001-20261028    gcc-11.5.0
sh                    randconfig-1001-20261029    gcc-10.5.0
sh                    randconfig-1001-20261030    gcc-11.5.0
sh                    randconfig-1001-20261031    gcc-8.5.0
sh                    randconfig-1001-20261101    gcc-8.5.0
sh                           rsk7201_defconfig    clang-22
sh                           rsk7201_defconfig    gcc-16.2.0
sh                           rsk7203_defconfig    gcc-16.2.0
sh                           rsk7264_defconfig    gcc-16.2.0
sh                            se7206_defconfig    gcc-16.2.0
sh                            se7619_defconfig    clang-24
sh                            se7712_defconfig    gcc-16.2.0
sh                            se7721_defconfig    gcc-16.2.0
sh                            se7751_defconfig    gcc-16.2.0
sh                            se7780_defconfig    clang-24
sh                    secureedge5410_defconfig    clang-24
sh                              sh03_defconfig    gcc-14
sh                    sh7724_generic_defconfig    gcc-16.2.0
sh                         sh7785lcr_defconfig    gcc-16.2.0
sh                             titan_defconfig    clang-24
sh                           urquell_defconfig    clang-17
sh                           urquell_defconfig    gcc-16.2.0
sparc                             alldefconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261027    clang-20
sparc                 randconfig-1000-20261028    gcc-12
sparc                 randconfig-1000-20261029    clang-24
sparc                 randconfig-1000-20261030    gcc-10.5.0
sparc                 randconfig-1000-20261031    gcc-11.5.0
sparc                 randconfig-1000-20261101    gcc-8.5.0
sparc                 randconfig-1001-20261027    clang-20
sparc                 randconfig-1001-20261028    gcc-12
sparc                 randconfig-1001-20261029    clang-24
sparc                 randconfig-1001-20261030    gcc-10.5.0
sparc                 randconfig-1001-20261031    gcc-11.5.0
sparc                 randconfig-1001-20261101    gcc-8.5.0
sparc                        sparc64_defconfig    clang-24
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261027    clang-20
sparc64               randconfig-1000-20261028    gcc-12
sparc64               randconfig-1000-20261029    clang-24
sparc64               randconfig-1000-20261030    gcc-10.5.0
sparc64               randconfig-1000-20261031    gcc-11.5.0
sparc64               randconfig-1000-20261101    gcc-8.5.0
sparc64               randconfig-1001-20261027    clang-20
sparc64               randconfig-1001-20261028    gcc-12
sparc64               randconfig-1001-20261029    clang-24
sparc64               randconfig-1001-20261030    gcc-10.5.0
sparc64               randconfig-1001-20261031    gcc-11.5.0
sparc64               randconfig-1001-20261101    gcc-8.5.0
um                                alldefconfig    gcc-16.2.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                              i386_defconfig    gcc-16.2.0
um                    randconfig-1000-20261027    clang-20
um                    randconfig-1000-20261028    gcc-12
um                    randconfig-1000-20261029    clang-24
um                    randconfig-1000-20261030    gcc-10.5.0
um                    randconfig-1000-20261031    gcc-11.5.0
um                    randconfig-1000-20261101    gcc-8.5.0
um                    randconfig-1001-20261027    clang-20
um                    randconfig-1001-20261028    gcc-12
um                    randconfig-1001-20261029    clang-24
um                    randconfig-1001-20261030    gcc-10.5.0
um                    randconfig-1001-20261031    gcc-11.5.0
um                    randconfig-1001-20261101    gcc-8.5.0
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261027    gcc-14
x86_64      buildonly-randconfig-1000-20261028    clang-22
x86_64      buildonly-randconfig-1000-20261029    gcc-14
x86_64      buildonly-randconfig-1000-20261030    gcc-14
x86_64      buildonly-randconfig-1000-20261031    clang-22
x86_64      buildonly-randconfig-1000-20261101    clang-22
x86_64      buildonly-randconfig-1001-20261027    gcc-14
x86_64      buildonly-randconfig-1001-20261028    clang-22
x86_64      buildonly-randconfig-1001-20261029    gcc-14
x86_64      buildonly-randconfig-1001-20261030    gcc-14
x86_64      buildonly-randconfig-1001-20261031    clang-22
x86_64      buildonly-randconfig-1001-20261101    clang-22
x86_64      buildonly-randconfig-1002-20261027    gcc-14
x86_64      buildonly-randconfig-1002-20261028    clang-22
x86_64      buildonly-randconfig-1002-20261029    gcc-14
x86_64      buildonly-randconfig-1002-20261030    gcc-14
x86_64      buildonly-randconfig-1002-20261031    clang-22
x86_64      buildonly-randconfig-1002-20261101    clang-22
x86_64      buildonly-randconfig-1003-20261027    gcc-14
x86_64      buildonly-randconfig-1003-20261028    clang-22
x86_64      buildonly-randconfig-1003-20261029    gcc-14
x86_64      buildonly-randconfig-1003-20261030    gcc-14
x86_64      buildonly-randconfig-1003-20261031    clang-22
x86_64      buildonly-randconfig-1003-20261101    clang-22
x86_64      buildonly-randconfig-1004-20261027    gcc-14
x86_64      buildonly-randconfig-1004-20261028    clang-22
x86_64      buildonly-randconfig-1004-20261029    gcc-14
x86_64      buildonly-randconfig-1004-20261030    gcc-14
x86_64      buildonly-randconfig-1004-20261031    clang-22
x86_64      buildonly-randconfig-1004-20261101    clang-22
x86_64      buildonly-randconfig-1005-20261027    gcc-14
x86_64      buildonly-randconfig-1005-20261028    clang-22
x86_64      buildonly-randconfig-1005-20261029    gcc-14
x86_64      buildonly-randconfig-1005-20261030    gcc-14
x86_64      buildonly-randconfig-1005-20261031    clang-22
x86_64      buildonly-randconfig-1005-20261101    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261027    gcc-14
x86_64                randconfig-1000-20261028    clang-22
x86_64                randconfig-1000-20261029    clang-22
x86_64                randconfig-1000-20261030    clang-22
x86_64                randconfig-1000-20261031    gcc-14
x86_64                randconfig-1000-20261101    gcc-14
x86_64                randconfig-1001-20261027    gcc-14
x86_64                randconfig-1001-20261028    clang-22
x86_64                randconfig-1001-20261029    clang-22
x86_64                randconfig-1001-20261030    clang-22
x86_64                randconfig-1001-20261031    gcc-14
x86_64                randconfig-1001-20261101    gcc-14
x86_64                randconfig-1002-20261027    gcc-14
x86_64                randconfig-1002-20261028    clang-22
x86_64                randconfig-1002-20261029    clang-22
x86_64                randconfig-1002-20261030    clang-22
x86_64                randconfig-1002-20261031    gcc-14
x86_64                randconfig-1002-20261101    gcc-14
x86_64                randconfig-1003-20261027    gcc-14
x86_64                randconfig-1003-20261028    clang-22
x86_64                randconfig-1003-20261029    clang-22
x86_64                randconfig-1003-20261030    clang-22
x86_64                randconfig-1003-20261031    gcc-14
x86_64                randconfig-1003-20261101    gcc-14
x86_64                randconfig-1004-20261027    gcc-14
x86_64                randconfig-1004-20261028    clang-22
x86_64                randconfig-1004-20261029    clang-22
x86_64                randconfig-1004-20261030    clang-22
x86_64                randconfig-1004-20261031    gcc-14
x86_64                randconfig-1004-20261101    gcc-14
x86_64                randconfig-1005-20261027    gcc-14
x86_64                randconfig-1005-20261028    clang-22
x86_64                randconfig-1005-20261029    clang-22
x86_64                randconfig-1005-20261030    clang-22
x86_64                randconfig-1005-20261031    gcc-14
x86_64                randconfig-1005-20261101    gcc-14
x86_64                randconfig-1006-20261027    clang-22
x86_64                randconfig-1006-20261028    gcc-14
x86_64                randconfig-1006-20261029    gcc-14
x86_64                randconfig-1006-20261030    gcc-14
x86_64                randconfig-1006-20261031    clang-22
x86_64                randconfig-1006-20261101    clang-22
x86_64                randconfig-1007-20261027    clang-22
x86_64                randconfig-1007-20261028    gcc-14
x86_64                randconfig-1007-20261029    gcc-14
x86_64                randconfig-1007-20261030    gcc-14
x86_64                randconfig-1007-20261031    clang-22
x86_64                randconfig-1007-20261101    clang-22
x86_64                randconfig-1008-20261027    clang-22
x86_64                randconfig-1008-20261028    gcc-14
x86_64                randconfig-1008-20261029    gcc-14
x86_64                randconfig-1008-20261030    gcc-14
x86_64                randconfig-1008-20261031    clang-22
x86_64                randconfig-1008-20261101    clang-22
x86_64                randconfig-1009-20261027    clang-22
x86_64                randconfig-1009-20261028    gcc-14
x86_64                randconfig-1009-20261029    gcc-14
x86_64                randconfig-1009-20261030    gcc-14
x86_64                randconfig-1009-20261031    clang-22
x86_64                randconfig-1009-20261101    clang-22
x86_64                randconfig-1010-20261027    clang-22
x86_64                randconfig-1010-20261028    gcc-14
x86_64                randconfig-1010-20261029    gcc-14
x86_64                randconfig-1010-20261030    gcc-14
x86_64                randconfig-1010-20261031    clang-22
x86_64                randconfig-1010-20261101    clang-22
x86_64                randconfig-1011-20261027    clang-22
x86_64                randconfig-1011-20261028    gcc-14
x86_64                randconfig-1011-20261029    gcc-14
x86_64                randconfig-1011-20261030    gcc-14
x86_64                randconfig-1011-20261031    clang-22
x86_64                randconfig-1011-20261101    clang-22
x86_64                randconfig-1012-20261027    clang-22
x86_64                randconfig-1012-20261028    gcc-12
x86_64                randconfig-1012-20261029    clang-22
x86_64                randconfig-1012-20261030    clang-22
x86_64                randconfig-1012-20261031    gcc-14
x86_64                randconfig-1012-20261101    gcc-14
x86_64                randconfig-1013-20261027    clang-22
x86_64                randconfig-1013-20261028    gcc-12
x86_64                randconfig-1013-20261029    clang-22
x86_64                randconfig-1013-20261030    clang-22
x86_64                randconfig-1013-20261031    gcc-14
x86_64                randconfig-1013-20261101    gcc-14
x86_64                randconfig-1014-20261027    clang-22
x86_64                randconfig-1014-20261028    gcc-12
x86_64                randconfig-1014-20261029    clang-22
x86_64                randconfig-1014-20261030    clang-22
x86_64                randconfig-1014-20261031    gcc-14
x86_64                randconfig-1014-20261101    gcc-14
x86_64                randconfig-1015-20261027    clang-22
x86_64                randconfig-1015-20261028    gcc-12
x86_64                randconfig-1015-20261029    clang-22
x86_64                randconfig-1015-20261030    clang-22
x86_64                randconfig-1015-20261031    gcc-14
x86_64                randconfig-1015-20261101    gcc-14
x86_64                randconfig-1016-20261027    clang-22
x86_64                randconfig-1016-20261028    gcc-12
x86_64                randconfig-1016-20261029    clang-22
x86_64                randconfig-1016-20261030    clang-22
x86_64                randconfig-1016-20261031    gcc-14
x86_64                randconfig-1016-20261101    gcc-14
x86_64                randconfig-1017-20261027    clang-22
x86_64                randconfig-1017-20261028    gcc-12
x86_64                randconfig-1017-20261029    clang-22
x86_64                randconfig-1017-20261030    clang-22
x86_64                randconfig-1017-20261031    gcc-14
x86_64                randconfig-1017-20261101    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                   cadence_csp_defconfig    clang-24
xtensa                   cadence_csp_defconfig    gcc-16.2.0
xtensa                        common_defconfig    gcc-16.2.0
xtensa                   nommu_kc705_defconfig    clang-24
xtensa                randconfig-1000-20261027    clang-20
xtensa                randconfig-1000-20261028    gcc-12
xtensa                randconfig-1000-20261029    clang-24
xtensa                randconfig-1000-20261030    gcc-10.5.0
xtensa                randconfig-1000-20261031    gcc-11.5.0
xtensa                randconfig-1000-20261101    gcc-8.5.0
xtensa                randconfig-1001-20261027    clang-20
xtensa                randconfig-1001-20261028    gcc-12
xtensa                randconfig-1001-20261029    clang-24
xtensa                randconfig-1001-20261030    gcc-10.5.0
xtensa                randconfig-1001-20261031    gcc-11.5.0
xtensa                randconfig-1001-20261101    gcc-8.5.0
xtensa                     smp_lx200_defconfig    gcc-16.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
