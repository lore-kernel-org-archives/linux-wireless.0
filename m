Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9267C71123
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 01:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FA7D2098A
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 01:23:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FA7D2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbeJMI6n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 04:58:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:22816 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbeJMI6n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 04:58:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Oct 2018 18:23:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,374,1534834800"; 
   d="gz'50?scan'50,208,50";a="81084964"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 12 Oct 2018 18:23:34 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gB8eT-0006nr-Lq; Sat, 13 Oct 2018 09:23:33 +0800
Date:   Sat, 13 Oct 2018 09:22:44 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] bitfield: use BUILD_BUG_ON_ZERO()
Message-ID: <201810130921.h77LERke%fengguang.wu@intel.com>
References: <20181012092104.2361-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20181012092104.2361-1-johannes@sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Johannes,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.19-rc7 next-20181012]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Johannes-Berg/bitfield-use-BUILD_BUG_ON_ZERO/20181013-081047
config: x86_64-randconfig-s2-10130838 (attached as .config)
compiler: gcc-6 (Debian 6.4.0-9) 6.4.0 20171026
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from include/linux/kernel.h:15:0,
                    from include/linux/list.h:9,
                    from include/linux/resource_ext.h:17,
                    from include/linux/acpi.h:26,
                    from drivers/iio/chemical/bme680_core.c:11:
   drivers/iio/chemical/bme680_core.c: In function 'bme680_chip_config':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
>> drivers/iio/chemical/bme680_core.c:525:12: note: in expansion of macro 'FIELD_PREP'
     u8 osrs = FIELD_PREP(BME680_OSRS_HUMIDITY_MASK,
               ^~~~~~~~~~
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio/chemical/bme680_core.c:547:9: note: in expansion of macro 'FIELD_PREP'
     osrs = FIELD_PREP(BME680_OSRS_TEMP_MASK, data->oversampling_temp + 1) |
            ^~~~~~~~~~
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio/chemical/bme680_core.c:548:9: note: in expansion of macro 'FIELD_PREP'
            FIELD_PREP(BME680_OSRS_PRESS_MASK, data->oversampling_press + 1);
            ^~~~~~~~~~
--
   In file included from drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c:33:0:
   drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c: In function 'st_lsm6dsx_set_fifo_mode':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/regmap.h:77:42: note: in definition of macro 'regmap_update_bits'
     regmap_update_bits_base(map, reg, mask, val, NULL, false, false)
                                             ^~~
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
>> drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c:166:6: note: in expansion of macro 'FIELD_PREP'
         FIELD_PREP(ST_LSM6DSX_FIFO_MODE_MASK,
         ^~~~~~~~~~
   drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c: In function 'st_lsm6dsx_set_fifo_odr':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/regmap.h:77:42: note: in definition of macro 'regmap_update_bits'
     regmap_update_bits_base(map, reg, mask, val, NULL, false, false)
                                             ^~~
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c:185:6: note: in expansion of macro 'FIELD_PREP'
         FIELD_PREP(ST_LSM6DSX_FIFO_ODR_MASK, data));
         ^~~~~~~~~~
   drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c: In function 'st_lsm6dsx_fifo_setup':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/regmap.h:77:42: note: in definition of macro 'regmap_update_bits'
     regmap_update_bits_base(map, reg, mask, val, NULL, false, false)
                                             ^~~
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c:529:6: note: in expansion of macro 'FIELD_PREP'
         FIELD_PREP(ST_LSM6DSX_REG_HLACTIVE_MASK,
         ^~~~~~~~~~
--
   In file included from include/linux/kernel.h:15:0,
                    from include/linux/list.h:9,
                    from include/linux/resource_ext.h:17,
                    from include/linux/acpi.h:26,
                    from drivers/iio//chemical/bme680_core.c:11:
   drivers/iio//chemical/bme680_core.c: In function 'bme680_chip_config':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio//chemical/bme680_core.c:525:12: note: in expansion of macro 'FIELD_PREP'
     u8 osrs = FIELD_PREP(BME680_OSRS_HUMIDITY_MASK,
               ^~~~~~~~~~
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio//chemical/bme680_core.c:547:9: note: in expansion of macro 'FIELD_PREP'
     osrs = FIELD_PREP(BME680_OSRS_TEMP_MASK, data->oversampling_temp + 1) |
            ^~~~~~~~~~
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio//chemical/bme680_core.c:548:9: note: in expansion of macro 'FIELD_PREP'
            FIELD_PREP(BME680_OSRS_PRESS_MASK, data->oversampling_press + 1);
            ^~~~~~~~~~
--
   In file included from drivers/iio//imu/st_lsm6dsx/st_lsm6dsx_buffer.c:33:0:
   drivers/iio//imu/st_lsm6dsx/st_lsm6dsx_buffer.c: In function 'st_lsm6dsx_set_fifo_mode':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/regmap.h:77:42: note: in definition of macro 'regmap_update_bits'
     regmap_update_bits_base(map, reg, mask, val, NULL, false, false)
                                             ^~~
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio//imu/st_lsm6dsx/st_lsm6dsx_buffer.c:166:6: note: in expansion of macro 'FIELD_PREP'
         FIELD_PREP(ST_LSM6DSX_FIFO_MODE_MASK,
         ^~~~~~~~~~
   drivers/iio//imu/st_lsm6dsx/st_lsm6dsx_buffer.c: In function 'st_lsm6dsx_set_fifo_odr':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/regmap.h:77:42: note: in definition of macro 'regmap_update_bits'
     regmap_update_bits_base(map, reg, mask, val, NULL, false, false)
                                             ^~~
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio//imu/st_lsm6dsx/st_lsm6dsx_buffer.c:185:6: note: in expansion of macro 'FIELD_PREP'
         FIELD_PREP(ST_LSM6DSX_FIFO_ODR_MASK, data));
         ^~~~~~~~~~
   drivers/iio//imu/st_lsm6dsx/st_lsm6dsx_buffer.c: In function 'st_lsm6dsx_fifo_setup':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/regmap.h:77:42: note: in definition of macro 'regmap_update_bits'
     regmap_update_bits_base(map, reg, mask, val, NULL, false, false)
                                             ^~~
>> include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^~~~~~~~~~~~~~~~~
>> include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^~~~~~~~~~~~~~~~
   drivers/iio//imu/st_lsm6dsx/st_lsm6dsx_buffer.c:529:6: note: in expansion of macro 'FIELD_PREP'
         FIELD_PREP(ST_LSM6DSX_REG_HLACTIVE_MASK,
         ^~~~~~~~~~

vim +/BUILD_BUG_ON_ZERO +57 include/linux/bitfield.h

    53	
    54	#define __BF_FIELD_CHECK(_mask, _reg, _val)				\
    55		BUILD_BUG_ON_ZERO(!__builtin_constant_p(_mask)) +		\
    56		BUILD_BUG_ON_ZERO((_mask) == 0) +				\
  > 57		BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?			\
    58					~((_mask) >> __bf_shf(_mask)) & (_val) : 0) + \
    59		BUILD_BUG_ON_ZERO((_mask) > (typeof(_reg))~0ull) +		\
    60		__BF_CHECK_POW2((_mask) + (1ULL << __bf_shf(_mask)))
    61	
    62	/**
    63	 * FIELD_FIT() - check if value fits in the field
    64	 * @_mask: shifted mask defining the field's length and position
    65	 * @_val:  value to test against the field
    66	 *
    67	 * Return: true if @_val can fit inside @_mask, false if @_val is too big.
    68	 */
    69	#define FIELD_FIT(_mask, _val)						\
    70		(__BF_FIELD_CHECK(_mask, 0ULL, _val) +				\
    71		 !((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)))
    72	
    73	/**
    74	 * FIELD_PREP() - prepare a bitfield element
    75	 * @_mask: shifted mask defining the field's length and position
    76	 * @_val:  value to put in the field
    77	 *
    78	 * FIELD_PREP() masks and shifts up the value.  The result should
    79	 * be combined with other fields of the bitfield using logical OR.
    80	 */
    81	#define FIELD_PREP(_mask, _val)						\
  > 82		(__BF_FIELD_CHECK(_mask, 0ULL, _val) +				\
    83		 (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask)))
    84	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--/04w6evG8XlLl3ft
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--/04w6evG8XlLl3ft--
