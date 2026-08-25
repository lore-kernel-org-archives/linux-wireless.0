Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5673A4F51
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 04:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787630479; cv=none; b=fTHqs+D4qfirdnzhdXfy/368GtAOVR8AI4ho3Tz3IqcheRKpziC6hmcGdNTjW6xCCN37uaM4AZyFWiVVAJY/RIAZbxbBrbkE5S1DG6UxyhMEFR6VNf6K7RtxuIb5Rgqc+g3vHB9qQIfzruKq7IDpL5cjdmlt+kj480rQFbRwK0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787630479; c=relaxed/simple;
	bh=Gh+pSTm1eJqAGsxTDf+HA1VyfwjDpHLw1p3lbEhG5LI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MM45GeE2QwkzZ/uevsdQHrEB5/EnoYEeZLIr6RTksh5dhi6dvuVhQ52TVyrCDqAvf6bfTfdcgv3MzS6N0LWTfyQnAIWMhJiK4UbykOrWvYN6lkLxtdvNWL3DNlJP/g1UGtXR04L/wQH3xpROlLKRG3PazLABuO2r6tJW7fEWvAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WI0wjAZA; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WI0wjAZA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787630476; x=1819166476;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gh+pSTm1eJqAGsxTDf+HA1VyfwjDpHLw1p3lbEhG5LI=;
  b=WI0wjAZA6ZaKjSAqPk7wZcLdpmb62cVHQi2Q+SLTzYVhARGznVJDF0D0
   a0PjTe8yhohV9P1fjVUMG7KCxEm6n2zyxRxr0gf31JPJGBlHf/T23NS2y
   gXNRPeZjywMX5lywOpbcGESJlBd7CSD8aln95dGLBr0JA8VmPEjNaqMt1
   KZ+6lOzrPFc6Uf3/fnsy6K0kMnPS+UtnjoG4OjwjhoPLMRMpYs7O/g+nw
   cjdeyHR8JTjUiMnJLazLXwbWJxI2CdbCva1dPDFh+VnUh0Q6lZ0LVDBoA
   GIigviTQ8Xi372Bw5z7HnhZEyGTnfL7Dj/+mJNKIYQTKgXovF08Oul6QX
   w==;
X-CSE-ConnectionGUID: RC3iK5+NTnedQo4RVLRiqQ==
X-CSE-MsgGUID: 5ialjCTRSsieannhADoiWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="91959489"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="91959489"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 21:01:15 -0700
X-CSE-ConnectionGUID: WgwCLmS8QpeG+WDh3R7eIw==
X-CSE-MsgGUID: PexPCI7dSVG+8p5wG4b28g==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 24 Aug 2026 21:01:10 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wyiLT-000000004uR-3QqK;
	Tue, 25 Aug 2026 04:01:07 +0000
Date: Tue, 25 Aug 2026 12:00:30 +0800
From: kernel test robot <lkp@intel.com>
To: Eason Lai <eason.lai@mediatek.com>, nbd@nbd.name, lorenzo@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org, kun.wu@mediatek.com,
	deren.wu@mediatek.com, sean.wang@mediatek.com,
	quan.zhou@mediatek.com, ryder.lee@mediatek.com,
	leon.yen@mediatek.com, litien.chang@mediatek.com,
	jb.tsai@mediatek.com, michael.shih@mediatek.com,
	eason.lai@mediatek.com
Subject: Re: [PATCH v1] wifi: mt76: mt7928: Add debugfs for stats to provide
 debug purpose
Message-ID: <202608251101.iQGUrSd0-lkp@intel.com>
References: <20260824030746.60706-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824030746.60706-1-eason.lai@mediatek.com>

Hi Eason,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on linus/master next-20260821]
[cannot apply to wireless/main v7.2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eason-Lai/wifi-mt76-mt7928-Add-debugfs-for-stats-to-provide-debug-purpose/20260824-110746
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260824030746.60706-1-eason.lai%40mediatek.com
patch subject: [PATCH v1] wifi: mt76: mt7928: Add debugfs for stats to provide debug purpose
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20260825/202608251101.iQGUrSd0-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260825/202608251101.iQGUrSd0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608251101.iQGUrSd0-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_fixedrate_set':
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:312:16: error: variable 'rate' has initializer but incomplete type
     312 |         struct mt7925_ra_fixed_rate_v1 rate = {};
         |                ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:312:40: error: storage size of 'rate' isn't known
     312 |         struct mt7925_ra_fixed_rate_v1 rate = {};
         |                                        ^~~~
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:314:12: error: 'struct mt792x_dev' has no member named 'fixed_rate'
     314 |         dev->fixed_rate = val;
         |            ^~
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:329:9: error: implicit declaration of function 'mt7925_mcu_set_fixed_rate'; did you mean 'mt7925_mcu_get_rx_rate'? [-Werror=implicit-function-declaration]
     329 |         mt7925_mcu_set_fixed_rate(dev, &rate);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
         |         mt7925_mcu_get_rx_rate
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:312:40: warning: unused variable 'rate' [-Wunused-variable]
     312 |         struct mt7925_ra_fixed_rate_v1 rate = {};
         |                                        ^~~~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_fixedrate_get':
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:340:19: error: 'struct mt792x_dev' has no member named 'fixed_rate'
     340 |         *val = dev->fixed_rate;
         |                   ^~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_autorate_set':
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:364:12: error: 'struct mt792x_dev' has no member named 'auto_rate'
     364 |         dev->auto_rate = val;
         |            ^~
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:367:9: error: implicit declaration of function 'mt7925_mcu_set_auto_rate'; did you mean 'mt7925_mcu_get_rx_rate'? [-Werror=implicit-function-declaration]
     367 |         mt7925_mcu_set_auto_rate(dev, wlan_idx, enable, mode);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
         |         mt7925_mcu_get_rx_rate
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_autorate_get':
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:378:19: error: 'struct mt792x_dev' has no member named 'auto_rate'
     378 |         *val = dev->auto_rate;
         |                   ^~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_wtbl_idx_set':
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:400:12: error: 'struct mt792x_dev' has no member named 'wtbl_dump_idx'
     400 |         dev->wtbl_dump_idx = (u32)val;
         |            ^~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_wtbl_idx_get':
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:410:19: error: 'struct mt792x_dev' has no member named 'wtbl_dump_idx'
     410 |         *val = dev->wtbl_dump_idx;
         |                   ^~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_wtbl_read':
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:422:22: error: 'struct mt792x_dev' has no member named 'wtbl_dump_idx'
     422 |         u32 idx = dev->wtbl_dump_idx;
         |                      ^~
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:443:16: error: implicit declaration of function 'mt7925_mac_wtbl_lmac_addr'; did you mean 'mt7925_mac_wtbl_update'? [-Werror=implicit-function-declaration]
     443 |         base = mt7925_mac_wtbl_lmac_addr(dev, idx, 0);
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~
         |                mt7925_mac_wtbl_update
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_vefuse_read':
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:474:23: error: 'struct mt792x_dev' has no member named 'vefuse_cap'
     474 |         u16 size = dev->vefuse_cap.size;
         |                       ^~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:479:17: error: 'struct mt792x_dev' has no member named 'vefuse_cap'
     479 |         if (!dev->vefuse_cap.present || !size) {
         |                 ^~
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:492:23: error: implicit declaration of function 'mt7925_mcu_read_vefuse'; did you mean 'mt7925_mcu_del_dev'? [-Werror=implicit-function-declaration]
     492 |                 ret = mt7925_mcu_read_vefuse(dev, off, chunk, buf + off);
         |                       ^~~~~~~~~~~~~~~~~~~~~~
         |                       mt7925_mcu_del_dev
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_perf_ind_set':
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:520:16: error: implicit declaration of function 'mt792x_perf_ind_trigger'; did you mean 'mt7925_perf_ind_set'? [-Werror=implicit-function-declaration]
     520 |         return mt792x_perf_ind_trigger(dev, val);
         |                ^~~~~~~~~~~~~~~~~~~~~~~
         |                mt7925_perf_ind_set
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_perf_ind_enable_get':
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:529:19: error: 'struct mt792x_dev' has no member named 'perf'
     529 |         *val = dev->perf.enabled;
         |                   ^~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_perf_ind_enable_set':
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:538:12: error: 'struct mt792x_dev' has no member named 'perf'
     538 |         dev->perf.enabled = !!val;
         |            ^~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_coex_info':
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:555:15: error: implicit declaration of function 'mt7925_mcu_chip_config_query'; did you mean 'mt7925_mcu_chip_config'? [-Werror=implicit-function-declaration]
     555 |         ret = mt7925_mcu_chip_config_query(dev, "coexBwcGetModeInfo 0",
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |               mt7925_mcu_chip_config
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:564:31: error: 'CHIP_CONFIG_TYPE_ASCII' undeclared (first use in this function)
     564 |         else if (resp_type == CHIP_CONFIG_TYPE_ASCII)
         |                               ^~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:564:31: note: each undeclared identifier is reported only once for each function it appears in
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c: In function 'mt7925_dmashdl_read':
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:603:45: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'long unsigned int' [-Wformat=]
     603 |         seq_printf(s, "\t\tPLE pkt max=0x%03x, PSE pkt max=0x%03x\n",
         |                                          ~~~^
         |                                             |
         |                                             unsigned int
         |                                          %03lx
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:603:65: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int' [-Wformat=]
     603 |         seq_printf(s, "\t\tPLE pkt max=0x%03x, PSE pkt max=0x%03x\n",
         |                                                              ~~~^
         |                                                                 |
         |                                                                 unsigned int
         |                                                              %03lx
   In file included from drivers/net/wireless/mediatek/mt76/mt7925/../mt76_connac.h:7,
                    from drivers/net/wireless/mediatek/mt76/mt7925/../mt76_connac_mcu.h:7,
                    from drivers/net/wireless/mediatek/mt76/mt7925/../mt792x.h:10,
                    from drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h:7,
                    from drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:4:
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:607:28: error: 'MT_DMASHDL_ERROR_FLAG_CTRL' undeclared (first use in this function)
     607 |         val = mt76_rr(dev, MT_DMASHDL_ERROR_FLAG_CTRL);
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/../mt76.h:1196:69: note: in definition of macro 'mt76_rr'
    1196 | #define mt76_rr(dev, ...)       (dev)->mt76.bus->rr(&((dev)->mt76), __VA_ARGS__)
         |                                                                     ^~~~~~~~~~~
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:613:43: error: implicit declaration of function 'MT_DMASHDL_STATUS_RD_GP' [-Werror=implicit-function-declaration]
     613 |                 u32 status = mt76_rr(dev, MT_DMASHDL_STATUS_RD_GP(i));
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/../mt76.h:1196:69: note: in definition of macro 'mt76_rr'
    1196 | #define mt76_rr(dev, ...)       (dev)->mt76.bus->rr(&((dev)->mt76), __VA_ARGS__)
         |                                                                     ^~~~~~~~~~~
   In file included from <command-line>:
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:614:37: error: 'MT_DMASHDL_STATUS_RD_GP_RSV' undeclared (first use in this function)
     614 |                 u32 rsv = FIELD_GET(MT_DMASHDL_STATUS_RD_GP_RSV, status);
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
      40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:79:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      79 |         BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
         |         ^~~~~~~~~~~~~~~~
   include/linux/bitfield.h:63:43: note: in expansion of macro '__unsigned_scalar_typeof'
      63 | #define __bf_cast_unsigned(type, x)     ((__unsigned_scalar_typeof(type))(x))
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:79:26: note: in expansion of macro '__bf_cast_unsigned'
      79 |         BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
         |                          ^~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:177:17: note: in expansion of macro '__BF_FIELD_CHECK_REG'
     177 |                 __BF_FIELD_CHECK_REG(_mask, _reg, "FIELD_GET: ");       \
         |                 ^~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:614:27: note: in expansion of macro 'FIELD_GET'
     614 |                 u32 rsv = FIELD_GET(MT_DMASHDL_STATUS_RD_GP_RSV, status);
         |                           ^~~~~~~~~
>> drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:615:37: error: 'MT_DMASHDL_STATUS_RD_GP_SRC' undeclared (first use in this function)
     615 |                 u32 src = FIELD_GET(MT_DMASHDL_STATUS_RD_GP_SRC, status);
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
      40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:79:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      79 |         BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
         |         ^~~~~~~~~~~~~~~~
   include/linux/bitfield.h:63:43: note: in expansion of macro '__unsigned_scalar_typeof'
      63 | #define __bf_cast_unsigned(type, x)     ((__unsigned_scalar_typeof(type))(x))
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:79:26: note: in expansion of macro '__bf_cast_unsigned'
      79 |         BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
         |                          ^~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:177:17: note: in expansion of macro '__BF_FIELD_CHECK_REG'
     177 |                 __BF_FIELD_CHECK_REG(_mask, _reg, "FIELD_GET: ");       \
         |                 ^~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:615:27: note: in expansion of macro 'FIELD_GET'
     615 |                 u32 src = FIELD_GET(MT_DMASHDL_STATUS_RD_GP_SRC, status);
         |                           ^~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:617:65: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int' [-Wformat=]
     617 |                 seq_printf(s, "\tGroup %2d: quota(min/max)=0x%03x/0x%03x, used/rsv=0x%03x/0x%03x\n",
         |                                                              ~~~^
         |                                                                 |
         |                                                                 unsigned int
         |                                                              %03lx
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:617:72: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'long unsigned int' [-Wformat=]
     617 |                 seq_printf(s, "\tGroup %2d: quota(min/max)=0x%03x/0x%03x, used/rsv=0x%03x/0x%03x\n",
         |                                                                     ~~~^
         |                                                                        |
         |                                                                        unsigned int
         |                                                                     %03lx
   In file included from drivers/net/wireless/mediatek/mt76/mt7925/../mt76_connac.h:7,
                    from drivers/net/wireless/mediatek/mt76/mt7925/../mt76_connac_mcu.h:7,
                    from drivers/net/wireless/mediatek/mt76/mt7925/../mt792x.h:10,
                    from drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h:7,
                    from drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:4:
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:626:28: error: 'MT_DMASHDL_STATUS_RD' undeclared (first use in this function)
     626 |         val = mt76_rr(dev, MT_DMASHDL_STATUS_RD);
         |                            ^~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/../mt76.h:1196:69: note: in definition of macro 'mt76_rr'
    1196 | #define mt76_rr(dev, ...)       (dev)->mt76.bus->rr(&((dev)->mt76), __VA_ARGS__)
         |                                                                     ^~~~~~~~~~~
   In file included from <command-line>:
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:627:33: error: 'MT_DMASHDL_STATUS_RD_FREE_PG' undeclared (first use in this function)
     627 |         free_pg_cnt = FIELD_GET(MT_DMASHDL_STATUS_RD_FREE_PG, val);
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
      40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:79:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      79 |         BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
         |         ^~~~~~~~~~~~~~~~
   include/linux/bitfield.h:63:43: note: in expansion of macro '__unsigned_scalar_typeof'
      63 | #define __bf_cast_unsigned(type, x)     ((__unsigned_scalar_typeof(type))(x))
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:79:26: note: in expansion of macro '__bf_cast_unsigned'
      79 |         BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
         |                          ^~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:177:17: note: in expansion of macro '__BF_FIELD_CHECK_REG'
     177 |                 __BF_FIELD_CHECK_REG(_mask, _reg, "FIELD_GET: ");       \
         |                 ^~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:627:23: note: in expansion of macro 'FIELD_GET'
     627 |         free_pg_cnt = FIELD_GET(MT_DMASHDL_STATUS_RD_FREE_PG, val);
         |                       ^~~~~~~~~
   drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:628:29: error: 'MT_DMASHDL_STATUS_RD_FFA' undeclared (first use in this function)
     628 |         ffa_cnt = FIELD_GET(MT_DMASHDL_STATUS_RD_FFA, val);
         |                             ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
      40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:79:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      79 |         BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
         |         ^~~~~~~~~~~~~~~~
   include/linux/bitfield.h:63:43: note: in expansion of macro '__unsigned_scalar_typeof'
      63 | #define __bf_cast_unsigned(type, x)     ((__unsigned_scalar_typeof(type))(x))
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:79:26: note: in expansion of macro '__bf_cast_unsigned'
      79 |         BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
         |                          ^~~~~~~~~~~~~~~~~~
   include/linux/bitfield.h:177:17: note: in expansion of macro '__BF_FIELD_CHECK_REG'
     177 |                 __BF_FIELD_CHECK_REG(_mask, _reg, "FIELD_GET: ");       \


vim +/rate +312 drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c

   289	
   290	/* fixedrate input format (12 hex digits):
   291	 * 0x[WCID(2)][Mode][BW][MCS][Nss][SGI][Preamble][STBC][LDPC][SPE_EN][HeLtf]
   292	 * The RA tag is fixed to SET_FIXED_RATE internally.
   293	 * WCID is 2 nibbles, all others are 1 nibble.
   294	 *
   295	 * [WCID]    Wireless Client ID
   296	 * [Mode]    CCK=0, OFDM=1, HT=2, GF=3, VHT=4, PLR=5, HE_SU=8, HE_ER_SU=9,
   297	 *           HE_TRIG=10, HE_MU=11, EHT_ER=13, EHT_TB=14, EHT_SU and EHT_MU=15
   298	 * [BW]      BW20=0, BW40=1, BW80=2, BW160=3, BW320=4
   299	 * [MCS]     CCK=0~3, OFDM=0~7, HT=0~32, VHT=0~9, HE=0~11, EHT=0~13, EHT_ER=14~15
   300	 * [Nss]     1~8
   301	 * [GI]      HT/VHT: 0=Long, 1=Short; HE/EHT: 0=0.8us, 1=1.6us, 2=3.2us
   302	 * [Preamble] Long=0, Short=other
   303	 * [STBC]    Enable=1, Disable=0
   304	 * [LDPC]    BCC=0, LDPC=1 (driver sends the FW's "on" value 7)
   305	 * [SPE_EN]  spatial extension index
   306	 * [HeLtf]   1X=0, 2X=1, 4X=2 (NOTE: EHT modes require HeLtf=1)
   307	 */
   308	static int
   309	mt7925_fixedrate_set(void *data, u64 val)
   310	{
   311		struct mt792x_dev *dev = data;
 > 312		struct mt7925_ra_fixed_rate_v1 rate = {};
   313	
 > 314		dev->fixed_rate = val;
   315	
   316		rate.wlan_idx       = cpu_to_le16((val >> 40) & 0xff);
   317		rate.phy_mode       = (val >> 36) & 0xf;
   318		rate.bw             = (val >> 32) & 0xf;
   319		rate.mcs            = (val >> 28) & 0xf;
   320		rate.nss            = (val >> 24) & 0xf;
   321		rate.short_gi       = cpu_to_le16((val >> 20) & 0xf);
   322		rate.short_preamble = (val >> 16) & 0xf;
   323		rate.stbc           = (val >> 12) & 0xf;
   324		rate.ecc            = ((val >> 8) & 0xf) ? 7 : 0;
   325		rate.spe            = (val >> 4) & 0xf;
   326		rate.he_ltf         = cpu_to_le16((val >> 0) & 0xf);
   327	
   328		mt792x_mutex_acquire(dev);
 > 329		mt7925_mcu_set_fixed_rate(dev, &rate);
   330		mt792x_mutex_release(dev);
   331	
   332		return 0;
   333	}
   334	
   335	static int
   336	mt7925_fixedrate_get(void *data, u64 *val)
   337	{
   338		struct mt792x_dev *dev = data;
   339	
   340		*val = dev->fixed_rate;
   341	
   342		return 0;
   343	}
 > 344	DEFINE_DEBUGFS_ATTRIBUTE(fops_fixedrate, mt7925_fixedrate_get,
   345				 mt7925_fixedrate_set, "0x%llx\n");
   346	
   347	/* autorate input format (6 hex digits):
   348	 * 0x[Tag(2)][WCID(2)][En][Mode]
   349	 * The RA tag is fixed to SET_AUTO_RATE internally.
   350	 * WCID is 2 nibbles, En and Mode are 1 nibble each.
   351	 *
   352	 * [WCID] Wireless Client ID
   353	 * [En]   Auto rate: Enable=1, Disable=0
   354	 * [Mode] don't care (RA picks the rate)
   355	 */
   356	static int
   357	mt7925_autorate_set(void *data, u64 val)
   358	{
   359		struct mt792x_dev *dev = data;
   360		u16 wlan_idx = (val >> 8) & 0xff;
   361		bool enable = (val >> 4) & 0xf;
   362		u8 mode = val & 0xf;
   363	
 > 364		dev->auto_rate = val;
   365	
   366		mt792x_mutex_acquire(dev);
 > 367		mt7925_mcu_set_auto_rate(dev, wlan_idx, enable, mode);
   368		mt792x_mutex_release(dev);
   369	
   370		return 0;
   371	}
   372	
   373	static int
   374	mt7925_autorate_get(void *data, u64 *val)
   375	{
   376		struct mt792x_dev *dev = data;
   377	
   378		*val = dev->auto_rate;
   379	
   380		return 0;
   381	}
 > 382	DEFINE_DEBUGFS_ATTRIBUTE(fops_autorate, mt7925_autorate_get,
   383				 mt7925_autorate_set, "0x%llx\n");
   384	
   385	/* WTBL dump
   386	 *
   387	 * Usage:
   388	 *   echo <idx> > /sys/kernel/debug/ieee80211/phy1/mt76/wtbl_idx
   389	 *   cat  /sys/kernel/debug/ieee80211/phy1/mt76/get_wtbl
   390	 *
   391	 * LMAC WTBL has 36 dwords per entry (connac3x).
   392	 */
   393	#define MT792x_WTBL_LMAC_DWORDS	36
   394	
   395	static int
   396	mt7925_wtbl_idx_set(void *data, u64 val)
   397	{
   398		struct mt792x_dev *dev = data;
   399	
 > 400		dev->wtbl_dump_idx = (u32)val;
   401	
   402		return 0;
   403	}
   404	
   405	static int
   406	mt7925_wtbl_idx_get(void *data, u64 *val)
   407	{
   408		struct mt792x_dev *dev = data;
   409	
   410		*val = dev->wtbl_dump_idx;
   411	
   412		return 0;
   413	}
   414	
 > 415	DEFINE_DEBUGFS_ATTRIBUTE(fops_wtbl_idx, mt7925_wtbl_idx_get,
   416				 mt7925_wtbl_idx_set, "%llu\n");
   417	
   418	static int
 > 419	mt7925_wtbl_read(struct seq_file *s, void *data)
   420	{
   421		struct mt792x_dev *dev = dev_get_drvdata(s->private);
   422		u32 idx = dev->wtbl_dump_idx;
   423		u32 wdu_cr, wducr_val, base;
   424		u32 dw0, dw1;
   425		int i;
   426	
   427		if (!mt76_is_mmio(&dev->mt76)) {
   428			seq_puts(s, "WTBL direct dump not supported on this interface\n");
   429			return 0;
   430		}
   431	
   432		if (idx >= MT792x_WTBL_SIZE) {
   433			seq_printf(s, "Invalid WTBL idx %u (max %u)\n",
   434				   idx, MT792x_WTBL_SIZE - 1);
   435			return 0;
   436		}
   437	
   438		mt792x_mutex_acquire(dev);
   439	
   440		/* mt7925_mac_wtbl_lmac_addr() writes WDUCR group selection and
   441		 * returns the mapped register address for DW 0 of this WCID.
   442		 */
 > 443		base = mt7925_mac_wtbl_lmac_addr(dev, idx, 0);
   444		wdu_cr = is_mt7928(&dev->mt76) ? MT7928_WTBLON_TOP_WDUCR :
   445						  MT7925_WTBLON_TOP_WDUCR;
   446		wducr_val = mt76_rr(dev, wdu_cr);
   447	
   448		/* DW0[15:0] + DW1[31:0] encode the link address */
   449		dw0 = mt76_rr(dev, base);
   450		dw1 = mt76_rr(dev, base + 4);
   451	
   452		seq_printf(s, "Dump WTBL info of WLAN_IDX: %u\n", idx);
   453		seq_printf(s, "LMAC WTBL Addr: group:0x%08x=0x%08x addr: 0x%08x\n",
   454			   wdu_cr, wducr_val, base);
   455		seq_printf(s, "LinkAddr: %02x:%02x:%02x:%02x:%02x:%02x\n",
   456			   dw1 & 0xff, (dw1 >> 8) & 0xff,
   457			   (dw1 >> 16) & 0xff, (dw1 >> 24) & 0xff,
   458			   dw0 & 0xff, (dw0 >> 8) & 0xff);
   459	
   460		seq_puts(s, "\nLMAC WTBL raw data:\n");
   461		for (i = 0; i < MT792x_WTBL_LMAC_DWORDS; i++)
   462			seq_printf(s, "DW%02d: 0x%08x\n", i,
   463				   mt76_rr(dev, base + i * 4));
   464	
   465		mt792x_mutex_release(dev);
   466	
   467		return 0;
   468	}
   469	
   470	static int
 > 471	mt7925_vefuse_read(struct seq_file *s, void *data)
   472	{
   473		struct mt792x_dev *dev = dev_get_drvdata(s->private);
 > 474		u16 size = dev->vefuse_cap.size;
   475		int off = 0;
   476		u8 *buf;
   477		int ret = 0;
   478	
   479		if (!dev->vefuse_cap.present || !size) {
   480			seq_puts(s, "vefuse: no region in FW image\n");
   481			return 0;
   482		}
   483	
   484		buf = kzalloc(size, GFP_KERNEL);
   485		if (!buf)
   486			return -ENOMEM;
   487	
   488		mt792x_mutex_acquire(dev);
   489		while (off < (int)size) {
   490			u16 chunk = min_t(u16, 512, size - off);
   491	
 > 492			ret = mt7925_mcu_read_vefuse(dev, off, chunk, buf + off);
   493			if (ret)
   494				break;
   495			off += chunk;
   496		}
   497		mt792x_mutex_release(dev);
   498	
   499		if (ret) {
   500			seq_printf(s, "vefuse: read failed at 0x%04x (%d)\n", off, ret);
   501			kfree(buf);
   502			return 0;
   503		}
   504	
   505		seq_printf(s, "vefuse content: %u bytes\n", size);
   506		for (off = 0; off < (int)size; off += 16)
   507			seq_printf(s, "%04x: %*ph\n", off,
   508				   (int)min_t(u16, 16, size - off), buf + off);
   509	
   510		kfree(buf);
   511	
   512		return 0;
   513	}
   514	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
