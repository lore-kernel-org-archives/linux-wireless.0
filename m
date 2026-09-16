Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E4245C718
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546945; cv=none; b=meqM6uewuP/KPFaUG8m9BngGBejnzheB5wCaoi/z+5S/9lTWy3CM4rjUGmTrsAdVyv0/9J1ur2sB3OMBA0j3yJEp78OwVcTi/ve6aOc+kGL/YhH/FXPdxteHEWHiIDZYBNc4R6BwPZ77gA3WCLA7duKyWzE5QgLZv6XulZ9mLig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546945; c=relaxed/simple;
	bh=wjRBaGvyi1XzQX8G3FV9zqbA3yH/wU0PFr+aKq+4sAA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=B61grYyoe7WZ6NmKnTUMmp6yV3hnXmBUQ/9/1uE1edaiKWsftxtXTl5sGkMFcfIPqashskyEt8ZXjX3n2KCGH0P9G8iRMyzmU1chkIIEGgwjnsUnxlBxIz0a66+pHy0Vp26FzDVzc+Sn3Nu1ctHoVwGKkiTZ82klygQUHGxI7zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=agQnv3R2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="agQnv3R2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789546935; x=1821082935;
  h=date:from:to:cc:subject:message-id;
  bh=wjRBaGvyi1XzQX8G3FV9zqbA3yH/wU0PFr+aKq+4sAA=;
  b=agQnv3R2C65ulaalM+loC0WYOhv1tzbmBTbyMCk7V53sOAaQIG+Z2fDa
   PNjtzzrM0oFIYMMONsZRN8nto7OMQfqYyhYHNbdZPEuGu1HUA6M+Q7iv9
   vjfMmXew4lpevFMOU5k8oHOixnWDCLWldBznpZNRNjfQoN6esp42Af5jN
   AS/Mvfeu6soIYgz+oU1z4C5wCifEO4phdndJs6mz71G6YJC+7TNrMFUeW
   ZHMKGxukSVtIXRTfUj8xTyQR1dOopTFv/OwviC0Z399IkvQsJMnDRaY+G
   6LctmIROdzb+EBtuLXdHWEJgm0KqtZR3YCatrrQJGJ/p3PCduj/JMiTj+
   A==;
X-CSE-ConnectionGUID: idHAijRqQKubsn1o+oOzqg==
X-CSE-MsgGUID: WkHJwKSLSJaeXo0ec6o+JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="107428669"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="107428669"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 01:22:10 -0700
X-CSE-ConnectionGUID: 8fVqNCqNRGGqEZnR5p/bcA==
X-CSE-MsgGUID: 5f0iG/qeRR+Sf7wMymzlIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277389769"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 16 Sep 2026 01:22:08 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6ku5-000000005il-3sbz;
	Wed, 16 Sep 2026 08:22:05 +0000
Date: Wed, 16 Sep 2026 16:21:06 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD SUCCESS WITH WARNING
 27b084bdd009c5c82346d39d7773bab3191dd299
Message-ID: <202609161603.SFOyhPhr-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: 27b084bdd009c5c82346d39d7773bab3191dd299  wifi: rt2x00: Use device-managed register buffers

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609101851.WU5XzlC6-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609121030.ccd0ZWD1-lkp@intel.com

    arch/arm/boot/dts/ti/omap/am335x-boneblack.dtb: lcdc@0 (ti,am33xx-tilcdc): port:endpoint@0: 'reg' is a required property
    arch/arm/boot/dts/ti/omap/am335x-evmsk.dtb: lcdc@0 (ti,am33xx-tilcdc): port:endpoint@0: 'reg' is a required property
    arch/arm/boot/dts/ti/omap/am335x-guardian.dtb: lcdc@0 (ti,am33xx-tilcdc): port:endpoint@0: 'reg' is a required property
    arch/arm/boot/dts/ti/omap/am335x-pdu001.dtb: lcdc@0 (ti,am33xx-tilcdc): 'port' is a required property
    arch/arm/boot/dts/ti/omap/am335x-pepper.dtb: lcdc@0 (ti,am33xx-tilcdc): 'port' is a required property
    arch/arm/boot/dts/ti/omap/am335x-sancloud-bbe.dtb: lcdc@0 (ti,am33xx-tilcdc): port:endpoint@0: 'reg' is a required property
    arch/arm/boot/dts/ti/omap/am3517-craneboard.dtb: am35x_otg_hs@0 (ti,omap3-musb): $nodename:0: 'am35x_otg_hs@0' does not match '^usb(@.*)?'
    arch/arm/boot/dts/ti/omap/am3517-evm.dtb: am35x_otg_hs@0 (ti,omap3-musb): $nodename:0: 'am35x_otg_hs@0' does not match '^usb(@.*)?'
    arch/arm/boot/dts/ti/omap/omap3-cm-t3517.dtb: am35x_otg_hs@0 (ti,omap3-musb): $nodename:0: 'am35x_otg_hs@0' does not match '^usb(@.*)?'

Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-2051-20260914
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|-- arm-randconfig-2052-20260914
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|-- arm-randconfig-2053-20260908
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   `-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|-- arm-randconfig-2053-20260914
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|-- arm-randconfig-2054-20260914
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
`-- arm-randconfig-2055-20260914
    |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
    |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
    |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
    |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
    |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
    |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
    |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
    |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
    `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)

elapsed time: 2442m

configs tested: 262
configs skipped: 124

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                randconfig-r073-20260915    gcc-14.3.0
arc                              allmodconfig    clang-24
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                 nsimosci_hs_smp_defconfig    clang-20
arc                   randconfig-001-20260916    clang-24
arc                   randconfig-002-20260916    clang-24
arc                  randconfig-r054-20260915    gcc-11.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                   randconfig-001-20260916    clang-24
arm                   randconfig-001-20260916    gcc-8.5.0
arm                   randconfig-002-20260916    clang-24
arm                   randconfig-002-20260916    gcc-11.5.0
arm                   randconfig-003-20260916    clang-24
arm                   randconfig-004-20260916    clang-24
arm                  randconfig-r053-20260914    clang-17
arm                  randconfig-r053-20260915    gcc-8.5.0
arm                  randconfig-r061-20260915    clang-22
arm                  randconfig-r071-20260914    gcc-13.4.0
arm                  randconfig-r073-20260915    clang-24
arm                           tegra_defconfig    clang-20
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260916    gcc-16.1.0
arm64                 randconfig-001-20260916    gcc-8.5.0
arm64                 randconfig-002-20260916    clang-24
arm64                 randconfig-002-20260916    gcc-16.1.0
arm64                 randconfig-003-20260916    gcc-16.1.0
arm64                 randconfig-003-20260916    gcc-8.5.0
arm64                 randconfig-004-20260916    gcc-16.1.0
arm64                 randconfig-004-20260916    gcc-9.5.0
arm64                randconfig-r063-20260915    clang-17
arm64                randconfig-r064-20260915    clang-22
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                  randconfig-001-20260916    gcc-16.1.0
csky                  randconfig-002-20260916    gcc-16.1.0
csky                 randconfig-r061-20260915    gcc-9.5.0
csky                 randconfig-r111-20260916    clang-24 sparse
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon               randconfig-001-20260916    gcc-16.1.0
hexagon               randconfig-002-20260916    gcc-16.1.0
hexagon              randconfig-r072-20260915    clang-17
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-001-20260916    clang-22
i386        buildonly-randconfig-002-20260916    clang-22
i386        buildonly-randconfig-002-20260916    gcc-14
i386        buildonly-randconfig-003-20260916    clang-22
i386        buildonly-randconfig-003-20260916    gcc-14
i386        buildonly-randconfig-004-20260916    clang-22
i386        buildonly-randconfig-004-20260916    gcc-14
i386        buildonly-randconfig-005-20260916    clang-22
i386        buildonly-randconfig-006-20260916    clang-22
i386        buildonly-randconfig-006-20260916    gcc-14
i386                                defconfig    clang-22
i386                  randconfig-001-20260916    gcc-14
i386                  randconfig-002-20260916    gcc-14
i386                  randconfig-003-20260916    gcc-14
i386                  randconfig-004-20260916    gcc-14
i386                  randconfig-005-20260916    gcc-14
i386                  randconfig-006-20260916    gcc-14
i386                  randconfig-007-20260916    gcc-14
i386                  randconfig-011-20260916    clang-22
i386                  randconfig-012-20260916    clang-22
i386                  randconfig-013-20260916    clang-22
i386                  randconfig-014-20260916    clang-22
i386                  randconfig-015-20260916    clang-22
i386                  randconfig-015-20260916    gcc-14
i386                  randconfig-016-20260916    clang-22
i386                  randconfig-016-20260916    gcc-14
i386                  randconfig-017-20260916    clang-22
i386                  randconfig-051-20260915    clang-22
i386                  randconfig-052-20260915    clang-22
i386                  randconfig-053-20260915    clang-22
i386                  randconfig-054-20260915    clang-22
i386                  randconfig-054-20260915    gcc-14
i386                  randconfig-061-20260916    clang-22 sparse
i386                  randconfig-062-20260916    clang-22 sparse
i386                  randconfig-063-20260916    gcc-14 sparse
i386                  randconfig-141-20260914    gcc-14
i386                  randconfig-141-20260915    clang-22
i386                 randconfig-r064-20260914    clang-22
i386                 randconfig-r123-20260916    gcc-14 sparse
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260916    gcc-16.1.0
loongarch             randconfig-002-20260916    gcc-16.1.0
loongarch            randconfig-r054-20260915    clang-22
loongarch            randconfig-r062-20260915    gcc-12.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                                defconfig    clang-24
m68k                       m5329evb_defconfig    clang-20
m68k                 randconfig-r051-20260915    gcc-12.5.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
microblaze           randconfig-r053-20260915    clang-22
microblaze           randconfig-r071-20260915    gcc-8.5.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                 randconfig-r071-20260915    clang-17
mips                 randconfig-r113-20260916    clang-24 sparse
mips                        vocore2_defconfig    clang-20
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-24
nios2                               defconfig    clang-24
nios2                 randconfig-001-20260916    gcc-16.1.0
nios2                 randconfig-002-20260916    gcc-16.1.0
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-24
openrisc                            defconfig    gcc-16.1.0
openrisc             randconfig-r064-20260915    gcc-15.2.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260916    clang-24
parisc                randconfig-002-20260916    clang-24
parisc               randconfig-r072-20260915    gcc-8.5.0
parisc               randconfig-r132-20260916    gcc-11.5.0 sparse
parisc64                         alldefconfig    clang-20
parisc64                            defconfig    clang-24
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                   currituck_defconfig    clang-20
powerpc                     mpc512x_defconfig    clang-20
powerpc               randconfig-001-20260916    clang-24
powerpc               randconfig-002-20260916    clang-24
powerpc              randconfig-r122-20260916    clang-24 sparse
powerpc64             randconfig-001-20260916    clang-24
powerpc64             randconfig-002-20260916    clang-24
powerpc64            randconfig-r052-20260915    gcc-8.5.0
powerpc64            randconfig-r073-20260915    gcc-8.5.0
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                            allyesconfig    clang-24
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260916    gcc-16.1.0
riscv                 randconfig-002-20260916    gcc-16.1.0
riscv                randconfig-r051-20260915    gcc-16.1.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260916    gcc-16.1.0
s390                  randconfig-002-20260916    gcc-16.1.0
s390                 randconfig-r063-20260915    clang-22
s390                 randconfig-r072-20260915    gcc-9.5.0
s390                 randconfig-r133-20260916    gcc-11.5.0 sparse
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260916    gcc-16.1.0
sh                    randconfig-002-20260916    gcc-16.1.0
sh                   randconfig-r051-20260915    clang-22
sh                   randconfig-r062-20260915    gcc-15.2.0
sh                   randconfig-r123-20260916    clang-24 sparse
sh                          sdk7786_defconfig    clang-20
sparc                             allnoconfig    clang-24
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260916    gcc-14.3.0
sparc                 randconfig-002-20260916    gcc-14.3.0
sparc                randconfig-r053-20260915    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260916    gcc-14.3.0
sparc64               randconfig-002-20260916    gcc-14.3.0
sparc64              randconfig-r112-20260916    clang-24 sparse
sparc64              randconfig-r134-20260916    gcc-11.5.0 sparse
um                               allmodconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260916    gcc-14.3.0
um                    randconfig-002-20260916    gcc-14.3.0
um                   randconfig-r061-20260915    gcc-14
um                   randconfig-r063-20260915    gcc-14
um                   randconfig-r121-20260916    clang-24 sparse
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64      buildonly-randconfig-002-20260916    gcc-14
x86_64      buildonly-randconfig-003-20260916    gcc-14
x86_64      buildonly-randconfig-005-20260916    gcc-14
x86_64      buildonly-randconfig-006-20260916    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260916    clang-22
x86_64                randconfig-002-20260916    clang-22
x86_64                randconfig-003-20260916    clang-22
x86_64                randconfig-004-20260916    gcc-14
x86_64                randconfig-005-20260916    clang-22
x86_64                randconfig-006-20260916    clang-22
x86_64                randconfig-011-20260916    gcc-14
x86_64                randconfig-012-20260916    gcc-14
x86_64                randconfig-013-20260916    clang-22
x86_64                randconfig-013-20260916    gcc-14
x86_64                randconfig-014-20260916    clang-22
x86_64                randconfig-014-20260916    gcc-14
x86_64                randconfig-015-20260916    clang-22
x86_64                randconfig-015-20260916    gcc-14
x86_64                randconfig-016-20260916    clang-22
x86_64                randconfig-016-20260916    gcc-14
x86_64                randconfig-071-20260916    clang-22
x86_64                randconfig-071-20260916    gcc-14
x86_64                randconfig-072-20260916    gcc-14
x86_64                randconfig-073-20260916    gcc-14
x86_64                randconfig-074-20260916    gcc-14
x86_64                randconfig-075-20260916    clang-22
x86_64                randconfig-075-20260916    gcc-14
x86_64                randconfig-076-20260916    gcc-14
x86_64                randconfig-101-20260914    gcc-14
x86_64                randconfig-101-20260915    clang-22
x86_64                randconfig-102-20260914    clang-22
x86_64                randconfig-102-20260915    clang-22
x86_64                randconfig-102-20260915    gcc-14
x86_64                randconfig-103-20260914    gcc-14
x86_64                randconfig-103-20260915    clang-22
x86_64                randconfig-104-20260914    gcc-14
x86_64                randconfig-104-20260915    clang-22
x86_64                randconfig-104-20260915    gcc-14
x86_64                randconfig-121-20260916    clang-22 sparse
x86_64                randconfig-122-20260916    clang-22 sparse
x86_64                randconfig-123-20260916    clang-22 sparse
x86_64                randconfig-161-20260914    clang-22
x86_64                randconfig-161-20260915    clang-22
x86_64               randconfig-r051-20260914    gcc-14
x86_64               randconfig-r052-20260915    clang-22
x86_64               randconfig-r062-20260915    clang-22
x86_64               randconfig-r064-20260915    clang-22
x86_64               randconfig-r071-20260915    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-24
xtensa                           allyesconfig    clang-20
xtensa                randconfig-001-20260916    gcc-14.3.0
xtensa                randconfig-002-20260916    gcc-14.3.0
xtensa               randconfig-r131-20260916    gcc-11.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
