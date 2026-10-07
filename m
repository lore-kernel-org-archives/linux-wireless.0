Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9070A369997
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 15:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388374; cv=none; b=nNB3WV0tVFr6DwGcwhfB9ZvKUrQHJYDX23UGkPlouFEBH4xuwiUOzfh5RxzoECxYhoGqc/pvAncg/d0uVpTOrNXKsuFz6FzaijKDJQcAkOVRXQle3XQokmlwwklMF+c9c1/dqKgGi2BtusIkbSea4fy6J4DD+W1RYbHTcggRbeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388374; c=relaxed/simple;
	bh=epSbrZTHWjvHCPnOCp5uSlL/pJfklDdOUOq0p7T6BnU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=lfqw3ww5R273Bth0vWCyHnOfgvgt+dLQKH7E6ZQWUEq6GZEsmd05N5PIkA+4kRLsbSf34Qi06DRg0n2rQj33fDrPfsGRE6VaI2eueLaS06Vdgsc58hCqjkpRc9vPcQCvL0t/9Em+ZVEZzHjFNYGZhZzmPzoeAfQzaAdXcnB2ua4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CzSoQKbU; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CzSoQKbU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791388373; x=1822924373;
  h=date:from:to:cc:subject:message-id;
  bh=epSbrZTHWjvHCPnOCp5uSlL/pJfklDdOUOq0p7T6BnU=;
  b=CzSoQKbUI+mIhuKcZ5gJCvmVCqKPjeewt3pulhs1eM++7yJaIKwVBR3D
   Wi9lm4XzbVomo+mbLuUAojOjXCWB4yp9vOkWJfjlY/ow+BF62ibovL2P4
   W6MJmUaPFuzsGmJDNwhCPqR3kWKsxBGW1bA3xzAQpUwPywlGGjPzvxkam
   FRT1VQxlID3jIJojXjPBRU8dAvvjyCPF+/0EM/xhIWIP4t2Cgs7p02Kdi
   eom5xw+6hDziipV4toPgPXWXbHvie9Q/+Lqvjes49Ysg92elS5N4FkicD
   /fjLA43AJoHvdWp7OaSaZVafvsxVrqXc3kZH6r0LWISCcdPXZ9+9/iZ8u
   A==;
X-CSE-ConnectionGUID: CSurD0FGQ56xXjj00DlRWQ==
X-CSE-MsgGUID: mCgMJrgySIezcsf4t3+69Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="150953"
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="150953"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 08:52:50 -0700
X-CSE-ConnectionGUID: ntO78X1oRlqDzzsgRO4wTA==
X-CSE-MsgGUID: GS5JXlwsTJebsVBWp5rpaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="1565992"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 07 Oct 2026 08:52:49 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xETwk-000000003Bw-04aN;
	Wed, 07 Oct 2026 15:52:46 +0000
Date: Wed, 07 Oct 2026 23:51:57 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD SUCCESS WITH WARNING
 b6f009284138884c4b07bbef7b07d780aa9b5daf
Message-ID: <202610072353.tmw1W69N-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: b6f009284138884c4b07bbef7b07d780aa9b5daf  wifi: mac80211: use the AP address as RA for a 4-addr MLO station

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609101851.WU5XzlC6-lkp@intel.com

    arch/arm/boot/dts/ti/omap/am3517-craneboard.dtb: am35x_otg_hs@0 (ti,omap3-musb): $nodename:0: 'am35x_otg_hs@0' does not match '^usb(@.*)?'

Unverified Warning (likely false positive, kindly check if interested):

    drivers/hid/hid-steam.c:557 steam_send_report_id() warn: check sign expansion for '__UNIQUE_ID_x__615'

Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-2400-20261007
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|-- arm-randconfig-2401-20261007
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|-- arm-randconfig-2402-20261007
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|-- arm-randconfig-2403-20261007
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|-- arm-randconfig-2404-20261007
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-craneboard.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
`-- arm64-randconfig-r2202-20261007
    `-- drivers-hid-hid-steam.c-steam_send_report_id()-warn:check-sign-expansion-for-__UNIQUE_ID_x__615

elapsed time: 1242m

configs tested: 343
configs skipped: 44

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2104-20261007    gcc-10.5.0 cocci
alpha                randconfig-r2202-20261007    gcc-8.5.0  smatch
alpha                randconfig-r2302-20261007    clang-24   sparse
alpha                randconfig-r2305-20261007    clang-17   sparse
alpha                randconfig-r2306-20261007    clang-24   sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261007    clang-24
arc                   randconfig-1001-20261007    clang-24
arc                  randconfig-r2100-20261007    clang-20   cocci
arc                  randconfig-r2102-20261007    gcc-10.5.0 cocci
arc                  randconfig-r2103-20261007    gcc-11.5.0 cocci
arc                  randconfig-r2107-20261007    gcc-10.5.0 cocci
arc                  randconfig-r2107-20261007    gcc-8.5.0  cocci
arc                  randconfig-r2200-20261006    gcc-13.4.0 smatch
arc                  randconfig-r2202-20261007    gcc-8.5.0  smatch
arc                  randconfig-r2309-20261007    gcc-8.5.0  sparse
arm                               alldefconfig    gcc-16.1.0
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                          bcm2835_defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                            omap1_defconfig    gcc-16.1.0
arm                             qcom_defconfig    clang-24
arm                   randconfig-1000-20261007    clang-24
arm                   randconfig-1001-20261007    clang-24
arm                   randconfig-1002-20261007    clang-24
arm                   randconfig-1003-20261007    clang-24
arm                  randconfig-r2100-20261007    clang-17   cocci
arm                  randconfig-r2104-20261007    gcc-12.5.0 cocci
arm                  randconfig-r2104-20261007    gcc-8.5.0  cocci
arm                  randconfig-r2105-20261007    gcc-16.1.0 cocci
arm                  randconfig-r2107-20261007    gcc-8.5.0  cocci
arm                  randconfig-r2202-20261007    gcc-12.5.0 smatch
arm                  randconfig-r2304-20261007    clang-20   sparse
arm                         shmobile_defconfig    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261007    gcc-13.4.0
arm64                 randconfig-1001-20261007    gcc-13.4.0
arm64                 randconfig-1002-20261007    gcc-13.4.0
arm64                 randconfig-1003-20261007    gcc-13.4.0
arm64                randconfig-r2100-20261007    gcc-10.5.0 cocci
arm64                randconfig-r2102-20261007    gcc-8.5.0  cocci
arm64                randconfig-r2104-20261007    gcc-8.5.0  cocci
arm64                randconfig-r2106-20261007    clang-22   cocci
arm64                randconfig-r2106-20261007    gcc-16.1.0 cocci
arm64                randconfig-r2107-20261007    gcc-8.5.0  cocci
arm64                randconfig-r2202-20261007    gcc-16.1.0 smatch
arm64                randconfig-r2301-20261007    clang-17   sparse
arm64                randconfig-r2301-20261007    clang-24   sparse
arm64                randconfig-r2303-20261007    clang-17   sparse
arm64                randconfig-r2305-20261007    clang-20   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261007    gcc-13.4.0
csky                  randconfig-1001-20261007    gcc-13.4.0
csky                 randconfig-r2102-20261007    gcc-8.5.0  cocci
csky                 randconfig-r2104-20261007    gcc-16.1.0 cocci
csky                 randconfig-r2201-20261007    gcc-16.1.0 smatch
csky                 randconfig-r2301-20261007    gcc-8.5.0  sparse
csky                 randconfig-r2305-20261007    clang-24   sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261007    gcc-12.5.0
hexagon               randconfig-1001-20261007    gcc-12.5.0
hexagon              randconfig-r2101-20261007    gcc-8.5.0  cocci
hexagon              randconfig-r2102-20261007    clang-20   cocci
hexagon              randconfig-r2103-20261007    gcc-8.5.0  cocci
hexagon              randconfig-r2106-20261007    gcc-8.5.0  cocci
hexagon              randconfig-r2107-20261007    clang-22   cocci
hexagon              randconfig-r2107-20261007    gcc-16.1.0 cocci
hexagon              randconfig-r2200-20261007    clang-24   smatch
hexagon              randconfig-r2201-20261007    clang-24   smatch
hexagon              randconfig-r2304-20261007    clang-17   sparse
hexagon              randconfig-r2309-20261007    clang-17   sparse
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20261007    gcc-14
i386        buildonly-randconfig-1001-20261007    gcc-14
i386        buildonly-randconfig-1002-20261007    gcc-14
i386        buildonly-randconfig-1003-20261007    gcc-14
i386        buildonly-randconfig-1004-20261007    gcc-14
i386        buildonly-randconfig-1005-20261007    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261007    clang-22
i386                  randconfig-1001-20261007    clang-22
i386                  randconfig-1002-20261007    clang-22
i386                  randconfig-1003-20261007    clang-22
i386                  randconfig-1004-20261007    clang-22
i386                  randconfig-1005-20261007    clang-22
i386                  randconfig-1006-20261007    clang-22
i386                  randconfig-1007-20261007    gcc-14
i386                  randconfig-1008-20261007    gcc-14
i386                  randconfig-1009-20261007    gcc-14
i386                  randconfig-1010-20261007    gcc-14
i386                  randconfig-1011-20261007    gcc-14
i386                  randconfig-1012-20261007    gcc-14
i386                  randconfig-1013-20261007    gcc-14
i386                  randconfig-2100-20261007    clang-22   cocci
i386                  randconfig-2101-20261007    clang-22   cocci
i386                  randconfig-2102-20261007    clang-22   cocci
i386                  randconfig-2103-20261007    clang-22   cocci
i386                  randconfig-2103-20261007    gcc-13     cocci
i386                  randconfig-2200-20261007    gcc-14     smatch
i386                  randconfig-2300-20261007    clang-22   sparse
i386                  randconfig-2301-20261007    clang-22   sparse
i386                  randconfig-2302-20261007    clang-22   sparse
i386                 randconfig-r2106-20261007    gcc-12.5.0 cocci
i386                 randconfig-r2106-20261007    gcc-8.5.0  cocci
i386                 randconfig-r2201-20261007    clang-22   smatch
i386                 randconfig-r2300-20261007    gcc-8.5.0  sparse
i386                 randconfig-r2302-20261007    clang-20   sparse
i386                 randconfig-r2307-20261007    clang-17   sparse
i386                 randconfig-r2307-20261007    gcc-13.4.0 sparse
i386                 randconfig-r2307-20261007    gcc-8.5.0  sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261007    gcc-12.5.0
loongarch             randconfig-1001-20261007    gcc-12.5.0
loongarch            randconfig-r2300-20261007    clang-17   sparse
loongarch            randconfig-r2302-20261006    gcc-10.5.0 sparse
loongarch            randconfig-r2305-20261007    gcc-8.5.0  sparse
loongarch            randconfig-r2307-20261007    clang-24   sparse
loongarch            randconfig-r2309-20261007    clang-17   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                 randconfig-r2100-20261007    gcc-11.5.0 cocci
m68k                 randconfig-r2106-20261007    gcc-10.5.0 cocci
m68k                 randconfig-r2303-20261007    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2104-20261007    gcc-10.5.0 cocci
microblaze           randconfig-r2200-20261007    gcc-8.5.0  smatch
microblaze           randconfig-r2301-20261006    gcc-10.5.0 sparse
microblaze           randconfig-r2306-20261007    gcc-13.4.0 sparse
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                   maltasmvp_eva_defconfig    gcc-16.1.0
mips                 randconfig-r2306-20261007    clang-17   sparse
mips                 randconfig-r2308-20261007    gcc-8.5.0  sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261007    gcc-12.5.0
nios2                 randconfig-1001-20261007    gcc-12.5.0
nios2                randconfig-r2101-20261007    gcc-11.5.0 cocci
nios2                randconfig-r2105-20261007    gcc-10.5.0 cocci
nios2                randconfig-r2300-20261006    gcc-10.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2101-20261007    gcc-10.5.0 cocci
openrisc             randconfig-r2107-20261007    gcc-12.5.0 cocci
openrisc             randconfig-r2200-20261007    gcc-12.5.0 smatch
openrisc             randconfig-r2303-20261007    clang-20   sparse
openrisc             randconfig-r2308-20261007    gcc-11.5.0 sparse
openrisc             randconfig-r2309-20261007    gcc-13.4.0 sparse
openrisc                        virt_defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261007    gcc-15.2.0
parisc                randconfig-1001-20261007    gcc-15.2.0
parisc               randconfig-r2100-20261007    gcc-8.5.0  cocci
parisc               randconfig-r2106-20261007    gcc-10.5.0 cocci
parisc               randconfig-r2201-20261007    gcc-8.5.0  smatch
parisc               randconfig-r2306-20261007    gcc-11.5.0 sparse
parisc               randconfig-r2309-20261007    clang-24   sparse
parisc64                             defconfig    clang-24
powerpc                            allnoconfig    clang-24
powerpc                         fsp2_defconfig    clang-24
powerpc                     ge_imp3a_defconfig    gcc-16.1.0
powerpc                  mpc832x_rdb_defconfig    clang-24
powerpc               randconfig-1000-20261007    gcc-15.2.0
powerpc               randconfig-1001-20261007    gcc-15.2.0
powerpc              randconfig-r2101-20261007    gcc-8.5.0  cocci
powerpc              randconfig-r2306-20261007    clang-17   sparse
powerpc              randconfig-r2307-20261007    gcc-11.5.0 sparse
powerpc              randconfig-r2308-20261007    gcc-13.4.0 sparse
powerpc                      tqm8555_defconfig    clang-24
powerpc                  xes_mpc85xx_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20261007    gcc-15.2.0
powerpc64             randconfig-1001-20261007    gcc-15.2.0
powerpc64            randconfig-r2103-20261007    gcc-10.5.0 cocci
powerpc64            randconfig-r2200-20261007    clang-24   smatch
powerpc64            randconfig-r2201-20261007    clang-24   smatch
powerpc64            randconfig-r2202-20261007    gcc-10.5.0 smatch
powerpc64            randconfig-r2303-20261007    clang-24   sparse
powerpc64            randconfig-r2305-20261006    gcc-10.5.0 sparse
powerpc64            randconfig-r2306-20261007    gcc-8.5.0  sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261007    clang-24
riscv                 randconfig-1001-20261007    clang-24
riscv                 randconfig-2000-20261006    gcc-16.1.0
riscv                 randconfig-2000-20261007    gcc-12.5.0
riscv                 randconfig-2001-20261006    gcc-16.1.0
riscv                 randconfig-2001-20261007    gcc-12.5.0
riscv                randconfig-r2101-20261007    clang-17   cocci
riscv                randconfig-r2105-20261007    gcc-8.5.0  cocci
riscv                randconfig-r2201-20261007    clang-24   smatch
riscv                randconfig-r2304-20261006    gcc-10.5.0 sparse
riscv                randconfig-r2304-20261007    gcc-8.5.0  sparse
riscv                randconfig-r2308-20261007    clang-17   sparse
s390                               allnoconfig    clang-24
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261007    clang-24
s390                  randconfig-1001-20261007    clang-24
s390                  randconfig-2000-20261006    gcc-16.1.0
s390                  randconfig-2000-20261007    gcc-12.5.0
s390                  randconfig-2001-20261006    gcc-16.1.0
s390                  randconfig-2001-20261007    gcc-12.5.0
s390                 randconfig-r2101-20261007    clang-20   cocci
s390                 randconfig-r2302-20261007    gcc-8.5.0  sparse
s390                 randconfig-r2308-20261007    gcc-8.5.0  sparse
s390                 randconfig-r2309-20261007    gcc-8.5.0  sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261007    clang-24
sh                    randconfig-1001-20261007    clang-24
sh                    randconfig-2000-20261006    gcc-16.1.0
sh                    randconfig-2000-20261007    gcc-12.5.0
sh                    randconfig-2001-20261006    gcc-16.1.0
sh                    randconfig-2001-20261007    gcc-12.5.0
sh                   randconfig-r2105-20261007    clang-22   cocci
sh                   randconfig-r2105-20261007    gcc-10.5.0 cocci
sh                   randconfig-r2306-20261007    gcc-8.5.0  sparse
sh                   randconfig-r2307-20261007    gcc-8.5.0  sparse
sh                           rsk7264_defconfig    gcc-16.1.0
sh                            se7751_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261007    clang-17
sparc                 randconfig-1001-20261007    clang-17
sparc                 randconfig-2000-20261007    clang-24
sparc                 randconfig-2001-20261007    clang-24
sparc                randconfig-r2103-20261007    clang-17   cocci
sparc                randconfig-r2105-20261007    gcc-12.5.0 cocci
sparc                randconfig-r2301-20261007    clang-20   sparse
sparc                randconfig-r2303-20261006    gcc-10.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261007    clang-17
sparc64               randconfig-1001-20261007    clang-17
sparc64               randconfig-2000-20261007    clang-24
sparc64               randconfig-2001-20261007    clang-24
sparc64              randconfig-r2100-20261007    gcc-8.5.0  cocci
sparc64              randconfig-r2102-20261007    gcc-11.5.0 cocci
sparc64              randconfig-r2103-20261007    clang-20   cocci
sparc64              randconfig-r2201-20261007    gcc-16.1.0 smatch
sparc64              randconfig-r2300-20261007    clang-20   sparse
sparc64              randconfig-r2304-20261007    clang-24   sparse
sparc64              randconfig-r2309-20261007    gcc-11.5.0 sparse
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261007    clang-17
um                    randconfig-1001-20261007    clang-17
um                    randconfig-2000-20261007    clang-24
um                    randconfig-2001-20261007    clang-24
um                   randconfig-r2202-20261007    clang-24   smatch
um                   randconfig-r2300-20261007    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261007    gcc-14
x86_64      buildonly-randconfig-1001-20261007    gcc-14
x86_64      buildonly-randconfig-1002-20261007    gcc-14
x86_64      buildonly-randconfig-1003-20261007    gcc-14
x86_64      buildonly-randconfig-1004-20261007    gcc-14
x86_64      buildonly-randconfig-1005-20261007    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261007    clang-22
x86_64                randconfig-1001-20261007    clang-22
x86_64                randconfig-1002-20261007    clang-22
x86_64                randconfig-1003-20261007    clang-22
x86_64                randconfig-1004-20261007    clang-22
x86_64                randconfig-1005-20261007    clang-22
x86_64                randconfig-1006-20261007    clang-22
x86_64                randconfig-1007-20261007    clang-22
x86_64                randconfig-1008-20261007    clang-22
x86_64                randconfig-1009-20261007    clang-22
x86_64                randconfig-1010-20261007    clang-22
x86_64                randconfig-1011-20261007    clang-22
x86_64                randconfig-1012-20261007    gcc-12
x86_64                randconfig-1013-20261007    gcc-12
x86_64                randconfig-1014-20261007    gcc-12
x86_64                randconfig-1015-20261007    gcc-12
x86_64                randconfig-1016-20261007    gcc-12
x86_64                randconfig-1017-20261007    gcc-12
x86_64                randconfig-2100-20261007    clang-22   cocci
x86_64                randconfig-2101-20261007    clang-22   cocci
x86_64                randconfig-2102-20261007    clang-22   cocci
x86_64                randconfig-2103-20261007    clang-22   cocci
x86_64                randconfig-2200-20261006    clang-22   smatch
x86_64                randconfig-2200-20261007    gcc-14     smatch
x86_64                randconfig-2300-20261007    clang-22   sparse
x86_64                randconfig-2301-20261007    clang-22   sparse
x86_64                randconfig-2302-20261007    clang-22   sparse
x86_64               randconfig-r2104-20261007    clang-22   cocci
x86_64               randconfig-r2107-20261007    gcc-10.5.0 cocci
x86_64               randconfig-r2202-20261007    clang-22   smatch
x86_64               randconfig-r2308-20261007    clang-24   sparse
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
xtensa                randconfig-1000-20261007    clang-17
xtensa                randconfig-1001-20261007    clang-17
xtensa                randconfig-2000-20261007    clang-24
xtensa                randconfig-2001-20261007    clang-24
xtensa               randconfig-r2102-20261007    clang-17   cocci
xtensa               randconfig-r2103-20261007    gcc-8.5.0  cocci
xtensa               randconfig-r2201-20261007    gcc-8.5.0  smatch
xtensa               randconfig-r2302-20261007    clang-17   sparse
xtensa               randconfig-r2307-20261007    clang-17   sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
