Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78A630BBBF
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 23:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846261; cv=none; b=b/tOAXbtBmsJXuDhgiy251gH/2LaXFnTzq3M2FoBmlmDZx9lkYEcJkxVKF1f1g7NukJ1GK+RLsrvw9QVLO05sdR/6nANpIJH2UmVTf6wAJs73yLtKjhJvJ3tpYTHIe+OpFo/ZUDEZu/0yeQ0Qprg/XhWt9B/F6ShBPO+3hcjqYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846261; c=relaxed/simple;
	bh=2PannBXghSZ7LE/JU2Fb/x7OML2wDi+4zr9XoJ3B5LE=;
	h=Date:From:To:Cc:Subject:Message-ID; b=oJHUBcl9FhQpt+JzcXp4IaWuaNs0jURY//G+QtW/AiJeHfUb3A5RpNqlaZHTd/BsistjdybwHY/wTaDmk8aYJV+/V5fwealfQspxWFHAxv0Vy2AIeo71JKGnFyJWzMecuGiTC5I/hd6qwN8oZUAkqRGlXfLWON95xfixIMwZexk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jQ8shwV4; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jQ8shwV4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791846258; x=1823382258;
  h=date:from:to:cc:subject:message-id;
  bh=2PannBXghSZ7LE/JU2Fb/x7OML2wDi+4zr9XoJ3B5LE=;
  b=jQ8shwV49c8S6CTsiVzp0P7MrbJQoyY10z8v2CQxmZiTJ8VKxirkGV1P
   jJhA7/JRanDC8o+JVcFls2SFnwFER33Qa6d4Nhj42eeTTdX8jACqzpaED
   DjHlNkCgIzzD/+2mEbtFxLU3ZmNmRAm5/Elv7erPTIYUkO/Oq+NGwyRV1
   5bv8AAZbGi7aDMOE5tH/96fjaVWuAifVrdy62OaA1QEt1mPuHZp/OwHxf
   7O/YBP4aXAGI22TpX2LH9S7YZBN7DZqtyTGC8Jh3idAjZLshxEYKsCVtq
   TJSdbvLKwLVfNAwUCmkTytfBNxG95dSopoAhhtzMXxul3OuA0wXoMLkQu
   g==;
X-CSE-ConnectionGUID: tiCmT7oES1a61K0Apeofkw==
X-CSE-MsgGUID: 7aFwDcoESga17lOIktLK2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="551297"
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="551297"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 16:04:18 -0700
X-CSE-ConnectionGUID: EqNz8qW4R/SxjttCGIGduQ==
X-CSE-MsgGUID: trafdrBnRdm/V22vT1BDnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,154,1787036400"; 
   d="scan'208";a="997826"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 12 Oct 2026 16:04:16 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGP42-00000000CCs-0A53;
	Mon, 12 Oct 2026 23:04:14 +0000
Date: Tue, 13 Oct 2026 07:03:55 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [wireless-next:for-next] BUILD SUCCESS WITH UNVERIFIED
 WARNING fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
Message-ID: <202610130753.8HoFQzTD-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next
branch HEAD: fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a  Merge tag 'mm81x-next-2026-10-09' of https://github.com/MorseMicroLabs/linux-wireless

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202610111016.9wexeSaG-lkp@intel.com

    drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:4067:18-19: WARNING opportunity for min()
    net/wireless/nl80211.c:267 nl80211_lock_and_recheck() warn: inconsistent returns '&rdev->wiphy.mtx'.

Warning ids grouped by kconfigs:

recent_errors
|-- arm-allnoconfig
|   |-- arch-arm-boot-dts-ti-omap-am335x-boneblack.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-evmsk.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-guardian.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pdu001.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-pepper.dtb:lcdc-(ti-am33xx-tilcdc):port-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am335x-sancloud-bbe.dtb:lcdc-(ti-am33xx-tilcdc):port:endpoint:reg-is-a-required-property
|   |-- arch-arm-boot-dts-ti-omap-am3517-evm.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|   `-- arch-arm-boot-dts-ti-omap-omap3-cm-t3517.dtb:am35x_otg_hs-(ti-omap3-musb):nodename:am35x_otg_hs-does-not-match-usb(-.-)
|-- x86_64-randconfig-2105-20261010
|   `-- drivers-net-wireless-mediatek-mt76-mt7996-mcu.c:WARNING-opportunity-for-min()
`-- x86_64-randconfig-r2202-20261011
    `-- net-wireless-nl80211.c-nl80211_lock_and_recheck()-warn:inconsistent-returns-rdev-wiphy.mtx-.

elapsed time: 1584m

configs tested: 652
configs skipped: 67

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2101-20261011    gcc-14.3.0 cocci
alpha                randconfig-r2102-20261010    gcc-12.5.0 cocci
alpha                randconfig-r2103-20261011    gcc-8.5.0  cocci
alpha                randconfig-r2104-20261010    gcc-16.1.0 cocci
alpha                randconfig-r2106-20261011    clang-24   cocci
alpha                randconfig-r2107-20261011    gcc-11.5.0 cocci
alpha                randconfig-r2111-20261010    clang-20   cocci
alpha                randconfig-r2201-20261011    gcc-8.5.0  smatch
alpha                randconfig-r2202-20261010    gcc-8.5.0  smatch
alpha                randconfig-r2202-20261011    gcc-16.1.0 smatch
alpha                randconfig-r2300-20261010    clang-17   sparse
alpha                randconfig-r2303-20261010    gcc-13.4.0 sparse
alpha                randconfig-r2303-20261010    gcc-16.1.0 sparse
alpha                randconfig-r2304-20261011    gcc-16.1.0 sparse
alpha                randconfig-r2306-20261010    gcc-13.4.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261012    gcc-8.5.0
arc                   randconfig-1000-20261013    clang-24
arc                   randconfig-1001-20261012    gcc-8.5.0
arc                   randconfig-1001-20261013    clang-24
arc                   randconfig-2000-20261010    gcc-8.5.0
arc                   randconfig-2000-20261011    gcc-8.5.0
arc                   randconfig-2001-20261010    gcc-8.5.0
arc                   randconfig-2001-20261011    gcc-8.5.0
arc                  randconfig-r2102-20261011    gcc-14.3.0 cocci
arc                  randconfig-r2103-20261010    clang-24   cocci
arc                  randconfig-r2103-20261010    gcc-8.5.0  cocci
arc                  randconfig-r2104-20261010    gcc-8.5.0  cocci
arc                  randconfig-r2105-20261011    gcc-11.5.0 cocci
arc                  randconfig-r2107-20261010    gcc-8.5.0  cocci
arc                  randconfig-r2108-20261010    gcc-8.5.0  cocci
arc                  randconfig-r2201-20261011    gcc-8.5.0  smatch
arc                  randconfig-r2202-20261010    gcc-8.5.0  smatch
arc                  randconfig-r2303-20261010    clang-17   sparse
arc                  randconfig-r2303-20261010    gcc-16.1.0 sparse
arc                  randconfig-r2306-20261010    gcc-14     sparse
arc                  randconfig-r2306-20261011    gcc-8.5.0  sparse
arc                  randconfig-r2308-20261010    gcc-13.4.0 sparse
arc                  randconfig-r2309-20261011    gcc-13     sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                   randconfig-1000-20261012    gcc-8.5.0
arm                   randconfig-1000-20261013    clang-24
arm                   randconfig-1001-20261012    gcc-8.5.0
arm                   randconfig-1001-20261013    clang-24
arm                   randconfig-1002-20261012    gcc-8.5.0
arm                   randconfig-1002-20261013    clang-24
arm                   randconfig-1003-20261012    gcc-8.5.0
arm                   randconfig-1003-20261013    clang-24
arm                   randconfig-2000-20261010    gcc-14.3.0
arm                   randconfig-2000-20261010    gcc-8.5.0
arm                   randconfig-2000-20261011    gcc-8.5.0
arm                   randconfig-2001-20261010    gcc-16.1.0
arm                   randconfig-2001-20261010    gcc-8.5.0
arm                   randconfig-2001-20261011    gcc-8.5.0
arm                  randconfig-r2105-20261010    gcc-16.1.0 cocci
arm                  randconfig-r2107-20261011    gcc-9.5.0  cocci
arm                  randconfig-r2109-20261011    clang-24   cocci
arm                  randconfig-r2200-20261011    gcc-11.5.0 smatch
arm                  randconfig-r2300-20261011    clang-17   sparse
arm                  randconfig-r2300-20261011    gcc-8.5.0  sparse
arm                  randconfig-r2302-20261010    clang-17   sparse
arm                  randconfig-r2303-20261011    gcc-8.5.0  sparse
arm                  randconfig-r2309-20261010    clang-24   sparse
arm                  randconfig-r2310-20261010    clang-24   sparse
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261012    clang-24
arm64                 randconfig-1000-20261013    gcc-9.5.0
arm64                 randconfig-1001-20261012    clang-24
arm64                 randconfig-1001-20261013    gcc-9.5.0
arm64                 randconfig-1002-20261012    clang-24
arm64                 randconfig-1002-20261013    gcc-9.5.0
arm64                 randconfig-1003-20261012    clang-24
arm64                 randconfig-1003-20261013    gcc-9.5.0
arm64                 randconfig-2000-20261010    gcc-16.1.0
arm64                 randconfig-2000-20261010    gcc-8.5.0
arm64                 randconfig-2000-20261011    gcc-16.1.0
arm64                 randconfig-2001-20261010    clang-17
arm64                 randconfig-2001-20261010    gcc-16.1.0
arm64                 randconfig-2001-20261011    gcc-16.1.0
arm64                randconfig-r2100-20261010    clang-24   cocci
arm64                randconfig-r2100-20261011    clang-21   cocci
arm64                randconfig-r2101-20261010    clang-22   cocci
arm64                randconfig-r2105-20261010    clang-20   cocci
arm64                randconfig-r2107-20261010    gcc-16.1.0 cocci
arm64                randconfig-r2108-20261011    clang-24   cocci
arm64                randconfig-r2109-20261010    gcc-8.5.0  cocci
arm64                randconfig-r2110-20261011    clang-22   cocci
arm64                randconfig-r2111-20261011    clang-24   cocci
arm64                randconfig-r2303-20261011    clang-17   sparse
arm64                randconfig-r2303-20261011    gcc-8.5.0  sparse
arm64                randconfig-r2307-20261010    gcc-13.4.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261012    clang-24
csky                  randconfig-1000-20261013    gcc-9.5.0
csky                  randconfig-1001-20261012    clang-24
csky                  randconfig-1001-20261013    gcc-9.5.0
csky                  randconfig-2000-20261010    gcc-16.1.0
csky                  randconfig-2000-20261011    gcc-16.1.0
csky                  randconfig-2001-20261010    gcc-16.1.0
csky                  randconfig-2001-20261011    gcc-16.1.0
csky                 randconfig-r2102-20261010    gcc-13.4.0 cocci
csky                 randconfig-r2103-20261010    gcc-11.5.0 cocci
csky                 randconfig-r2104-20261010    gcc-12     cocci
csky                 randconfig-r2105-20261011    clang-24   cocci
csky                 randconfig-r2106-20261011    clang-22   cocci
csky                 randconfig-r2107-20261010    gcc-16.1.0 cocci
csky                 randconfig-r2109-20261010    gcc-16.1.0 cocci
csky                 randconfig-r2110-20261011    gcc-9.5.0  cocci
csky                 randconfig-r2111-20261010    gcc-16.1.0 cocci
csky                 randconfig-r2201-20261011    gcc-11.5.0 smatch
csky                 randconfig-r2202-20261011    gcc-9.5.0  smatch
csky                 randconfig-r2300-20261010    gcc-16.1.0 sparse
csky                 randconfig-r2301-20261011    gcc-8.5.0  sparse
csky                 randconfig-r2306-20261010    clang-24   sparse
csky                 randconfig-r2307-20261011    gcc-11.5.0 sparse
csky                 randconfig-r2308-20261010    clang-24   sparse
csky                 randconfig-r2308-20261010    gcc-14     sparse
csky                 randconfig-r2309-20261011    clang-17   sparse
csky                 randconfig-r2309-20261011    gcc-8.5.0  sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261012    clang-17
hexagon               randconfig-1000-20261013    clang-24
hexagon               randconfig-1001-20261012    clang-17
hexagon               randconfig-1001-20261013    clang-24
hexagon               randconfig-2000-20261010    gcc-16.1.0
hexagon               randconfig-2000-20261011    gcc-16.1.0
hexagon               randconfig-2001-20261010    gcc-16.1.0
hexagon               randconfig-2001-20261011    gcc-16.1.0
hexagon              randconfig-r2100-20261011    clang-24   cocci
hexagon              randconfig-r2103-20261010    clang-24   cocci
hexagon              randconfig-r2103-20261010    gcc-16.1.0 cocci
hexagon              randconfig-r2103-20261011    clang-24   cocci
hexagon              randconfig-r2104-20261010    gcc-16.1.0 cocci
hexagon              randconfig-r2104-20261011    clang-24   cocci
hexagon              randconfig-r2108-20261011    clang-21   cocci
hexagon              randconfig-r2110-20261010    clang-20   cocci
hexagon              randconfig-r2110-20261010    gcc-12     cocci
hexagon              randconfig-r2111-20261011    clang-24   cocci
hexagon              randconfig-r2305-20261010    clang-17   sparse
hexagon              randconfig-r2310-20261010    clang-24   sparse
hexagon              randconfig-r2311-20261011    clang-17   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261012    clang-22
i386        buildonly-randconfig-1001-20261012    clang-22
i386        buildonly-randconfig-1002-20261012    clang-22
i386        buildonly-randconfig-1003-20261012    clang-22
i386        buildonly-randconfig-1004-20261012    clang-22
i386        buildonly-randconfig-1005-20261012    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261012    gcc-14
i386                  randconfig-1001-20261012    gcc-14
i386                  randconfig-1002-20261012    gcc-14
i386                  randconfig-1003-20261012    gcc-14
i386                  randconfig-1004-20261012    gcc-14
i386                  randconfig-1005-20261012    gcc-14
i386                  randconfig-1006-20261012    gcc-14
i386                  randconfig-1007-20261012    clang-22
i386                  randconfig-1008-20261012    clang-22
i386                  randconfig-1009-20261012    clang-22
i386                  randconfig-1010-20261012    clang-22
i386                  randconfig-1011-20261012    clang-22
i386                  randconfig-1012-20261012    clang-22
i386                  randconfig-1013-20261012    clang-22
i386                  randconfig-2000-20261010    gcc-14
i386                  randconfig-2000-20261010    gcc-8.5.0
i386                  randconfig-2000-20261011    gcc-8.5.0
i386                  randconfig-2001-20261010    clang-22
i386                  randconfig-2001-20261010    gcc-8.5.0
i386                  randconfig-2001-20261011    gcc-8.5.0
i386                  randconfig-2100-20261010    clang-22   cocci
i386                  randconfig-2100-20261010    gcc-13     cocci
i386                  randconfig-2100-20261010    gcc-14     cocci
i386                  randconfig-2100-20261011    gcc-14     cocci
i386                  randconfig-2101-20261010    clang-22   cocci
i386                  randconfig-2101-20261010    gcc-13     cocci
i386                  randconfig-2101-20261010    gcc-14     cocci
i386                  randconfig-2101-20261011    gcc-14     cocci
i386                  randconfig-2102-20261010    clang-22   cocci
i386                  randconfig-2102-20261010    gcc-13     cocci
i386                  randconfig-2102-20261011    gcc-14     cocci
i386                  randconfig-2103-20261010    clang-22   cocci
i386                  randconfig-2103-20261010    gcc-13     cocci
i386                  randconfig-2103-20261011    gcc-14     cocci
i386                  randconfig-2104-20261010    gcc-13     cocci
i386                  randconfig-2104-20261010    gcc-14     cocci
i386                  randconfig-2104-20261011    gcc-14     cocci
i386                  randconfig-2105-20261010    gcc-13     cocci
i386                  randconfig-2105-20261011    gcc-14     cocci
i386                  randconfig-2200-20261010    gcc-12     smatch
i386                  randconfig-2200-20261011    clang-22   smatch
i386                  randconfig-2300-20261010    gcc-14     sparse
i386                  randconfig-2300-20261011    gcc-14     sparse
i386                  randconfig-2301-20261010    gcc-14     sparse
i386                  randconfig-2301-20261011    gcc-14     sparse
i386                  randconfig-2302-20261010    clang-22   sparse
i386                  randconfig-2302-20261010    gcc-14     sparse
i386                  randconfig-2302-20261011    gcc-14     sparse
i386                 randconfig-r2101-20261011    clang-24   cocci
i386                 randconfig-r2102-20261010    gcc-16.1.0 cocci
i386                 randconfig-r2106-20261010    gcc-14     cocci
i386                 randconfig-r2108-20261011    gcc-14     cocci
i386                 randconfig-r2110-20261011    gcc-11.5.0 cocci
i386                 randconfig-r2111-20261011    clang-22   cocci
i386                 randconfig-r2200-20261011    clang-22   smatch
i386                 randconfig-r2201-20261011    clang-22   smatch
i386                 randconfig-r2300-20261011    gcc-8.5.0  sparse
i386                 randconfig-r2301-20261010    gcc-8.5.0  sparse
i386                 randconfig-r2301-20261011    gcc-8.5.0  sparse
i386                 randconfig-r2302-20261011    gcc-8.5.0  sparse
i386                 randconfig-r2307-20261010    clang-24   sparse
i386                 randconfig-r2311-20261011    gcc-11.5.0 sparse
i386                 randconfig-r2311-20261011    gcc-13     sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261012    clang-17
loongarch             randconfig-1000-20261013    clang-24
loongarch             randconfig-1001-20261012    clang-17
loongarch             randconfig-1001-20261013    clang-24
loongarch             randconfig-2000-20261010    gcc-8.5.0
loongarch             randconfig-2000-20261011    gcc-8.5.0
loongarch             randconfig-2001-20261010    gcc-8.5.0
loongarch             randconfig-2001-20261011    gcc-8.5.0
loongarch            randconfig-r2102-20261011    gcc-14     cocci
loongarch            randconfig-r2105-20261010    gcc-8.5.0  cocci
loongarch            randconfig-r2108-20261010    gcc-12.5.0 cocci
loongarch            randconfig-r2301-20261011    gcc-8.5.0  sparse
loongarch            randconfig-r2304-20261010    gcc-8.5.0  sparse
loongarch            randconfig-r2311-20261010    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                 randconfig-r2100-20261010    gcc-12.5.0 cocci
m68k                 randconfig-r2101-20261011    gcc-14     cocci
m68k                 randconfig-r2104-20261011    gcc-9.5.0  cocci
m68k                 randconfig-r2110-20261010    gcc-16.1.0 cocci
m68k                 randconfig-r2200-20261010    gcc-9.5.0  smatch
m68k                 randconfig-r2303-20261010    gcc-8.5.0  sparse
m68k                 randconfig-r2304-20261010    gcc-8.5.0  sparse
m68k                 randconfig-r2310-20261011    gcc-13     sparse
m68k                 randconfig-r2310-20261011    gcc-8.5.0  sparse
m68k                 randconfig-r2311-20261011    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2103-20261011    gcc-14     cocci
microblaze           randconfig-r2104-20261010    clang-20   cocci
microblaze           randconfig-r2105-20261011    clang-24   cocci
microblaze           randconfig-r2107-20261011    clang-22   cocci
microblaze           randconfig-r2108-20261011    clang-24   cocci
microblaze           randconfig-r2307-20261011    gcc-11.5.0 sparse
microblaze           randconfig-r2308-20261011    gcc-8.5.0  sparse
microblaze           randconfig-r2309-20261010    gcc-14     sparse
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2100-20261011    clang-24   cocci
mips                 randconfig-r2101-20261010    gcc-9.5.0  cocci
mips                 randconfig-r2102-20261011    clang-24   cocci
mips                 randconfig-r2106-20261010    gcc-8.5.0  cocci
mips                 randconfig-r2106-20261011    clang-24   cocci
mips                 randconfig-r2107-20261011    clang-24   cocci
mips                 randconfig-r2109-20261011    gcc-12.5.0 cocci
mips                 randconfig-r2200-20261010    gcc-14.3.0 smatch
mips                 randconfig-r2202-20261011    gcc-15.2.0 smatch
mips                 randconfig-r2302-20261010    gcc-13.4.0 sparse
mips                 randconfig-r2302-20261011    clang-17   sparse
mips                 randconfig-r2302-20261011    gcc-8.5.0  sparse
mips                 randconfig-r2305-20261011    gcc-8.5.0  sparse
mips                 randconfig-r2306-20261011    gcc-11.5.0 sparse
mips                 randconfig-r2306-20261011    gcc-13     sparse
mips                 randconfig-r2307-20261011    gcc-8.5.0  sparse
mips                 randconfig-r2308-20261011    gcc-11.5.0 sparse
mips                 randconfig-r2309-20261010    clang-24   sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261012    clang-17
nios2                 randconfig-1000-20261013    clang-24
nios2                 randconfig-1001-20261012    clang-17
nios2                 randconfig-1001-20261013    clang-24
nios2                 randconfig-2000-20261010    gcc-8.5.0
nios2                 randconfig-2000-20261011    gcc-8.5.0
nios2                 randconfig-2001-20261010    gcc-8.5.0
nios2                 randconfig-2001-20261011    gcc-8.5.0
nios2                randconfig-r2101-20261010    gcc-16.1.0 cocci
nios2                randconfig-r2104-20261011    gcc-9.5.0  cocci
nios2                randconfig-r2105-20261011    clang-24   cocci
nios2                randconfig-r2105-20261011    gcc-9.5.0  cocci
nios2                randconfig-r2106-20261010    gcc-16.1.0 cocci
nios2                randconfig-r2107-20261011    clang-24   cocci
nios2                randconfig-r2200-20261011    gcc-8.5.0  smatch
nios2                randconfig-r2202-20261011    gcc-8.5.0  smatch
nios2                randconfig-r2301-20261010    gcc-8.5.0  sparse
nios2                randconfig-r2301-20261011    gcc-16.1.0 sparse
nios2                randconfig-r2302-20261010    gcc-16.1.0 sparse
nios2                randconfig-r2304-20261010    gcc-16.1.0 sparse
nios2                randconfig-r2304-20261011    clang-17   sparse
nios2                randconfig-r2306-20261010    gcc-13.4.0 sparse
nios2                randconfig-r2307-20261011    clang-17   sparse
nios2                randconfig-r2308-20261011    gcc-11.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2102-20261010    clang-22   cocci
openrisc             randconfig-r2105-20261011    clang-22   cocci
openrisc             randconfig-r2110-20261011    gcc-9.5.0  cocci
openrisc             randconfig-r2200-20261011    gcc-16.1.0 smatch
openrisc             randconfig-r2201-20261010    gcc-16.1.0 smatch
openrisc             randconfig-r2300-20261011    gcc-16.1.0 sparse
openrisc             randconfig-r2300-20261011    gcc-8.5.0  sparse
openrisc             randconfig-r2306-20261011    clang-17   sparse
openrisc             randconfig-r2306-20261011    gcc-8.5.0  sparse
openrisc             randconfig-r2310-20261011    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261012    gcc-8.5.0
parisc                randconfig-1001-20261012    gcc-8.5.0
parisc                randconfig-2000-20261010    gcc-8.5.0
parisc                randconfig-2000-20261011    gcc-8.5.0
parisc                randconfig-2001-20261010    gcc-8.5.0
parisc                randconfig-2001-20261011    gcc-8.5.0
parisc               randconfig-r2101-20261010    gcc-8.5.0  cocci
parisc               randconfig-r2104-20261011    clang-22   cocci
parisc               randconfig-r2108-20261011    gcc-12.5.0 cocci
parisc               randconfig-r2110-20261011    clang-24   cocci
parisc               randconfig-r2202-20261010    gcc-8.5.0  smatch
parisc               randconfig-r2307-20261010    clang-24   sparse
parisc               randconfig-r2311-20261011    gcc-8.5.0  sparse
parisc64                             defconfig    clang-24
powerpc                            allnoconfig    clang-24
powerpc                     amigaone_defconfig    gcc-16.1.0
powerpc                       ep88xc_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261012    gcc-8.5.0
powerpc               randconfig-1001-20261012    gcc-8.5.0
powerpc               randconfig-2000-20261010    gcc-14
powerpc               randconfig-2000-20261011    clang-22
powerpc               randconfig-2001-20261010    gcc-14
powerpc               randconfig-2001-20261011    clang-22
powerpc              randconfig-r2100-20261010    clang-22   cocci
powerpc              randconfig-r2100-20261010    gcc-8.5.0  cocci
powerpc              randconfig-r2102-20261011    gcc-12.5.0 cocci
powerpc              randconfig-r2106-20261010    gcc-12     cocci
powerpc              randconfig-r2107-20261010    clang-20   cocci
powerpc              randconfig-r2109-20261011    gcc-14     cocci
powerpc              randconfig-r2109-20261011    gcc-14.3.0 cocci
powerpc              randconfig-r2201-20261010    gcc-16.1.0 smatch
powerpc              randconfig-r2300-20261010    gcc-16.1.0 sparse
powerpc              randconfig-r2300-20261010    gcc-8.5.0  sparse
powerpc              randconfig-r2301-20261010    gcc-16.1.0 sparse
powerpc              randconfig-r2304-20261010    gcc-13.4.0 sparse
powerpc              randconfig-r2304-20261011    gcc-8.5.0  sparse
powerpc              randconfig-r2305-20261010    gcc-13.4.0 sparse
powerpc              randconfig-r2308-20261011    gcc-8.5.0  sparse
powerpc              randconfig-r2309-20261010    clang-24   sparse
powerpc              randconfig-r2311-20261011    gcc-11.5.0 sparse
powerpc64             randconfig-1000-20261012    gcc-8.5.0
powerpc64             randconfig-1001-20261012    gcc-8.5.0
powerpc64             randconfig-2000-20261010    gcc-14
powerpc64             randconfig-2000-20261011    clang-22
powerpc64             randconfig-2001-20261010    gcc-14
powerpc64             randconfig-2001-20261011    clang-22
powerpc64            randconfig-r2100-20261011    gcc-8.5.0  cocci
powerpc64            randconfig-r2102-20261010    gcc-8.5.0  cocci
powerpc64            randconfig-r2105-20261010    gcc-16.1.0 cocci
powerpc64            randconfig-r2109-20261011    clang-21   cocci
powerpc64            randconfig-r2202-20261011    gcc-10.5.0 smatch
powerpc64            randconfig-r2301-20261010    clang-17   sparse
powerpc64            randconfig-r2304-20261010    clang-17   sparse
powerpc64            randconfig-r2304-20261011    gcc-8.5.0  sparse
powerpc64            randconfig-r2306-20261010    clang-24   sparse
powerpc64            randconfig-r2307-20261010    gcc-13.4.0 sparse
powerpc64            randconfig-r2311-20261010    gcc-13.4.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261012    clang-24
riscv                 randconfig-1000-20261013    gcc-9.5.0
riscv                 randconfig-1001-20261012    clang-24
riscv                 randconfig-1001-20261013    gcc-9.5.0
riscv                 randconfig-2000-20261010    gcc-16.1.0
riscv                 randconfig-2000-20261010    gcc-9.5.0
riscv                 randconfig-2000-20261011    gcc-13.4.0
riscv                 randconfig-2001-20261010    clang-24
riscv                 randconfig-2001-20261010    gcc-16.1.0
riscv                 randconfig-2001-20261011    gcc-13.4.0
riscv                randconfig-r2100-20261010    clang-17   cocci
riscv                randconfig-r2107-20261010    gcc-16.1.0 cocci
riscv                randconfig-r2110-20261010    gcc-16.1.0 cocci
riscv                randconfig-r2110-20261011    clang-24   cocci
riscv                randconfig-r2201-20261010    clang-21   smatch
riscv                randconfig-r2300-20261010    gcc-8.5.0  sparse
riscv                randconfig-r2305-20261011    gcc-8.5.0  sparse
riscv                randconfig-r2306-20261010    clang-24   sparse
riscv                randconfig-r2308-20261010    clang-24   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261012    clang-24
s390                  randconfig-1000-20261013    gcc-9.5.0
s390                  randconfig-1001-20261012    clang-24
s390                  randconfig-1001-20261013    gcc-9.5.0
s390                  randconfig-2000-20261010    clang-17
s390                  randconfig-2000-20261010    gcc-16.1.0
s390                  randconfig-2000-20261011    gcc-13.4.0
s390                  randconfig-2001-20261010    gcc-15.2.0
s390                  randconfig-2001-20261010    gcc-16.1.0
s390                  randconfig-2001-20261011    gcc-13.4.0
s390                 randconfig-r2101-20261010    clang-24   cocci
s390                 randconfig-r2101-20261011    clang-24   cocci
s390                 randconfig-r2103-20261011    gcc-14.3.0 cocci
s390                 randconfig-r2105-20261011    gcc-9.5.0  cocci
s390                 randconfig-r2106-20261010    clang-20   cocci
s390                 randconfig-r2106-20261010    gcc-16.1.0 cocci
s390                 randconfig-r2111-20261011    gcc-9.5.0  cocci
s390                 randconfig-r2200-20261010    clang-24   smatch
s390                 randconfig-r2301-20261010    gcc-13.4.0 sparse
s390                 randconfig-r2305-20261010    gcc-16.1.0 sparse
s390                 randconfig-r2308-20261011    clang-17   sparse
s390                 randconfig-r2310-20261011    gcc-8.5.0  sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261012    clang-24
sh                    randconfig-1000-20261013    gcc-9.5.0
sh                    randconfig-1001-20261012    clang-24
sh                    randconfig-1001-20261013    gcc-9.5.0
sh                    randconfig-2000-20261010    gcc-16.1.0
sh                    randconfig-2000-20261011    gcc-13.4.0
sh                    randconfig-2001-20261010    gcc-16.1.0
sh                    randconfig-2001-20261011    gcc-13.4.0
sh                   randconfig-r2100-20261011    gcc-14.3.0 cocci
sh                   randconfig-r2102-20261010    gcc-12.5.0 cocci
sh                   randconfig-r2105-20261010    gcc-12     cocci
sh                   randconfig-r2105-20261010    gcc-16.1.0 cocci
sh                   randconfig-r2106-20261011    clang-24   cocci
sh                   randconfig-r2106-20261011    gcc-11.5.0 cocci
sh                   randconfig-r2108-20261010    gcc-16.1.0 cocci
sh                   randconfig-r2111-20261010    gcc-16.1.0 cocci
sh                   randconfig-r2200-20261010    gcc-9.5.0  smatch
sh                   randconfig-r2200-20261011    gcc-12.5.0 smatch
sh                   randconfig-r2201-20261010    gcc-15.2.0 smatch
sh                   randconfig-r2202-20261010    gcc-9.5.0  smatch
sh                   randconfig-r2301-20261010    gcc-16.1.0 sparse
sh                   randconfig-r2301-20261011    gcc-8.5.0  sparse
sh                   randconfig-r2303-20261011    gcc-16.1.0 sparse
sh                   randconfig-r2304-20261011    gcc-8.5.0  sparse
sh                   randconfig-r2305-20261011    clang-17   sparse
sh                   randconfig-r2310-20261010    clang-24   sparse
sh                           rsk7201_defconfig    gcc-16.1.0
sh                           sdk7780_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261012    clang-20
sparc                 randconfig-1001-20261012    clang-20
sparc                 randconfig-2000-20261010    gcc-16.1.0
sparc                 randconfig-2000-20261011    gcc-8.5.0
sparc                 randconfig-2001-20261010    gcc-16.1.0
sparc                 randconfig-2001-20261011    gcc-8.5.0
sparc                randconfig-r2100-20261011    gcc-14     cocci
sparc                randconfig-r2101-20261011    gcc-12.5.0 cocci
sparc                randconfig-r2102-20261010    clang-24   cocci
sparc                randconfig-r2102-20261011    clang-24   cocci
sparc                randconfig-r2103-20261011    clang-24   cocci
sparc                randconfig-r2103-20261011    gcc-12.5.0 cocci
sparc                randconfig-r2106-20261011    gcc-9.5.0  cocci
sparc                randconfig-r2107-20261011    clang-24   cocci
sparc                randconfig-r2109-20261010    gcc-12.5.0 cocci
sparc                randconfig-r2110-20261010    gcc-16.1.0 cocci
sparc                randconfig-r2111-20261011    clang-24   cocci
sparc                randconfig-r2201-20261011    gcc-14.3.0 smatch
sparc                randconfig-r2300-20261011    gcc-8.5.0  sparse
sparc                randconfig-r2304-20261010    gcc-16.1.0 sparse
sparc                randconfig-r2308-20261011    gcc-13     sparse
sparc                randconfig-r2309-20261011    gcc-11.5.0 sparse
sparc                randconfig-r2309-20261011    gcc-8.5.0  sparse
sparc                randconfig-r2310-20261010    gcc-13.4.0 sparse
sparc                randconfig-r2310-20261010    gcc-14     sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261012    clang-20
sparc64               randconfig-1001-20261012    clang-20
sparc64               randconfig-2000-20261010    gcc-16.1.0
sparc64               randconfig-2000-20261011    gcc-8.5.0
sparc64               randconfig-2001-20261010    gcc-16.1.0
sparc64               randconfig-2001-20261011    gcc-8.5.0
sparc64              randconfig-r2100-20261010    gcc-16.1.0 cocci
sparc64              randconfig-r2100-20261011    gcc-12.5.0 cocci
sparc64              randconfig-r2101-20261010    clang-24   cocci
sparc64              randconfig-r2102-20261011    clang-21   cocci
sparc64              randconfig-r2103-20261011    clang-21   cocci
sparc64              randconfig-r2104-20261010    gcc-16.1.0 cocci
sparc64              randconfig-r2104-20261011    clang-24   cocci
sparc64              randconfig-r2108-20261011    gcc-14.3.0 cocci
sparc64              randconfig-r2109-20261011    gcc-8.5.0  cocci
sparc64              randconfig-r2301-20261011    clang-17   sparse
sparc64              randconfig-r2302-20261011    gcc-8.5.0  sparse
sparc64              randconfig-r2305-20261011    gcc-16.1.0 sparse
sparc64              randconfig-r2307-20261011    gcc-8.5.0  sparse
sparc64              randconfig-r2308-20261010    clang-24   sparse
sparc64              randconfig-r2308-20261010    gcc-13.4.0 sparse
sparc64              randconfig-r2309-20261010    gcc-13.4.0 sparse
sparc64              randconfig-r2311-20261010    gcc-14     sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261012    clang-20
um                    randconfig-1001-20261012    clang-20
um                    randconfig-2000-20261010    gcc-16.1.0
um                    randconfig-2000-20261011    gcc-8.5.0
um                    randconfig-2001-20261010    gcc-16.1.0
um                    randconfig-2001-20261011    gcc-8.5.0
um                   randconfig-r2101-20261011    clang-21   cocci
um                   randconfig-r2101-20261011    gcc-8.5.0  cocci
um                   randconfig-r2106-20261010    gcc-16.1.0 cocci
um                   randconfig-r2106-20261011    gcc-9.5.0  cocci
um                   randconfig-r2107-20261010    gcc-12     cocci
um                   randconfig-r2200-20261011    gcc-14     smatch
um                   randconfig-r2201-20261010    clang-17   smatch
um                   randconfig-r2202-20261010    clang-17   smatch
um                   randconfig-r2202-20261011    gcc-14     smatch
um                   randconfig-r2300-20261010    gcc-13.4.0 sparse
um                   randconfig-r2302-20261011    gcc-16.1.0 sparse
um                   randconfig-r2302-20261011    gcc-8.5.0  sparse
um                   randconfig-r2305-20261011    gcc-8.5.0  sparse
um                   randconfig-r2306-20261011    gcc-11.5.0 sparse
um                   randconfig-r2309-20261010    gcc-13.4.0 sparse
um                   randconfig-r2310-20261011    clang-17   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261012    clang-22
x86_64      buildonly-randconfig-1001-20261012    clang-22
x86_64      buildonly-randconfig-1002-20261012    clang-22
x86_64      buildonly-randconfig-1003-20261012    clang-22
x86_64      buildonly-randconfig-1004-20261012    clang-22
x86_64      buildonly-randconfig-1005-20261012    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261012    clang-22
x86_64                randconfig-1001-20261012    clang-22
x86_64                randconfig-1002-20261012    clang-22
x86_64                randconfig-1003-20261012    clang-22
x86_64                randconfig-1004-20261012    clang-22
x86_64                randconfig-1005-20261012    clang-22
x86_64                randconfig-1006-20261012    clang-22
x86_64                randconfig-1007-20261012    clang-22
x86_64                randconfig-1008-20261012    clang-22
x86_64                randconfig-1009-20261012    clang-22
x86_64                randconfig-1010-20261012    clang-22
x86_64                randconfig-1011-20261012    clang-22
x86_64                randconfig-1012-20261012    gcc-14
x86_64                randconfig-1013-20261012    gcc-14
x86_64                randconfig-1014-20261012    gcc-14
x86_64                randconfig-1015-20261012    gcc-14
x86_64                randconfig-1016-20261012    gcc-14
x86_64                randconfig-1017-20261012    gcc-14
x86_64                randconfig-2000-20261010    clang-22
x86_64                randconfig-2000-20261010    gcc-14
x86_64                randconfig-2000-20261011    clang-22
x86_64                randconfig-2001-20261010    gcc-14
x86_64                randconfig-2001-20261011    clang-22
x86_64                randconfig-2100-20261010    clang-22   cocci
x86_64                randconfig-2100-20261011    gcc-14     cocci
x86_64                randconfig-2101-20261010    clang-22   cocci
x86_64                randconfig-2101-20261011    gcc-14     cocci
x86_64                randconfig-2102-20261010    clang-22   cocci
x86_64                randconfig-2102-20261011    gcc-14     cocci
x86_64                randconfig-2103-20261010    clang-22   cocci
x86_64                randconfig-2103-20261011    gcc-14     cocci
x86_64                randconfig-2104-20261010    clang-22   cocci
x86_64                randconfig-2104-20261011    gcc-14     cocci
x86_64                randconfig-2105-20261010    clang-22   cocci
x86_64                randconfig-2105-20261011    gcc-14     cocci
x86_64                randconfig-2200-20261010    gcc-14     smatch
x86_64                randconfig-2200-20261011    clang-22   smatch
x86_64                randconfig-2300-20261010    clang-22   sparse
x86_64                randconfig-2300-20261010    gcc-14     sparse
x86_64                randconfig-2300-20261011    gcc-14     sparse
x86_64                randconfig-2301-20261010    clang-22   sparse
x86_64                randconfig-2301-20261010    gcc-14     sparse
x86_64                randconfig-2301-20261011    gcc-14     sparse
x86_64                randconfig-2302-20261010    clang-22   sparse
x86_64                randconfig-2302-20261010    gcc-14     sparse
x86_64                randconfig-2302-20261011    gcc-14     sparse
x86_64               randconfig-r2103-20261010    clang-22   cocci
x86_64               randconfig-r2104-20261011    gcc-11.5.0 cocci
x86_64               randconfig-r2108-20261011    gcc-8.5.0  cocci
x86_64               randconfig-r2109-20261011    clang-24   cocci
x86_64               randconfig-r2110-20261011    clang-24   cocci
x86_64               randconfig-r2111-20261010    gcc-12     cocci
x86_64               randconfig-r2111-20261011    gcc-11.5.0 cocci
x86_64               randconfig-r2302-20261010    gcc-8.5.0  sparse
x86_64               randconfig-r2305-20261010    gcc-16.1.0 sparse
x86_64               randconfig-r2305-20261010    gcc-8.5.0  sparse
x86_64               randconfig-r2307-20261010    gcc-14     sparse
x86_64               randconfig-r2307-20261011    gcc-13     sparse
x86_64               randconfig-r2311-20261010    clang-24   sparse
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
xtensa                randconfig-1000-20261012    clang-20
xtensa                randconfig-1001-20261012    clang-20
xtensa                randconfig-2000-20261010    gcc-16.1.0
xtensa                randconfig-2000-20261011    gcc-8.5.0
xtensa                randconfig-2001-20261010    gcc-16.1.0
xtensa                randconfig-2001-20261011    gcc-8.5.0
xtensa               randconfig-r2101-20261010    gcc-12.5.0 cocci
xtensa               randconfig-r2102-20261011    gcc-8.5.0  cocci
xtensa               randconfig-r2104-20261011    clang-24   cocci
xtensa               randconfig-r2107-20261011    gcc-9.5.0  cocci
xtensa               randconfig-r2111-20261011    gcc-9.5.0  cocci
xtensa               randconfig-r2202-20261010    gcc-8.5.0  smatch
xtensa               randconfig-r2302-20261010    gcc-16.1.0 sparse
xtensa               randconfig-r2302-20261010    gcc-8.5.0  sparse
xtensa               randconfig-r2303-20261011    gcc-8.5.0  sparse
xtensa               randconfig-r2305-20261010    gcc-8.5.0  sparse
xtensa               randconfig-r2307-20261010    clang-24   sparse
xtensa               randconfig-r2309-20261011    gcc-11.5.0 sparse
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
