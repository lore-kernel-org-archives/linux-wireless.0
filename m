Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F241C71123
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 01:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9E020895
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 01:30:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F9E020895
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbeJMJFs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 05:05:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:21810 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbeJMJFr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 05:05:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Oct 2018 18:27:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,374,1534834800"; 
   d="gz'50?scan'50,208,50";a="87990400"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Oct 2018 18:27:35 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gB8iM-000BLm-Pz; Sat, 13 Oct 2018 09:27:34 +0800
Date:   Sat, 13 Oct 2018 09:26:55 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] bitfield: use BUILD_BUG_ON_ZERO()
Message-ID: <201810130909.D5Iqs2tt%fengguang.wu@intel.com>
References: <20181012092104.2361-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20181012092104.2361-1-johannes@sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Johannes,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.19-rc7 next-20181012]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Johannes-Berg/bitfield-use-BUILD_BUG_ON_ZERO/20181013-081047
config: i386-randconfig-x0-10130855 (attached as .config)
compiler: gcc-5 (Debian 5.5.0-3) 5.4.1 20171010
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from include/linux/kernel.h:15:0,
                    from drivers/crypto/ccree/cc_driver.c:4:
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_din_type':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
>> drivers/crypto/ccree/cc_hw_queue_defs.h:226:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[5] |= FIELD_PREP(WORD5_DIN_ADDR_HIGH, ((u16)(addr >> 32)));
                       ^
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:228:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[1] |= FIELD_PREP(WORD1_DIN_DMA_MODE, dma_mode) |
                       ^
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:229:5: note: in expansion of macro 'FIELD_PREP'
        FIELD_PREP(WORD1_DIN_SIZE, size) |
        ^
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:230:5: note: in expansion of macro 'FIELD_PREP'
        FIELD_PREP(WORD1_NS_BIT, axi_sec);
        ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_din_no_dma':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:244:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size);
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_din_sram':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:260:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size) |
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_din_const':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:276:4: note: in expansion of macro 'FIELD_PREP'
       FIELD_PREP(WORD1_DIN_SIZE, size);
       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_dout_type':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:304:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[5] |= FIELD_PREP(WORD5_DOUT_ADDR_HIGH, ((u16)(addr >> 32)));
                       ^
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:306:20: note: in expansion of macro 'FIELD_PREP'
--
   In file included from include/asm-generic/atomic-instrumented.h:16:0,
                    from arch/x86/include/asm/atomic.h:265,
                    from include/linux/atomic.h:7,
                    from include/linux/crypto.h:20,
                    from include/crypto/aead.h:16,
                    from include/crypto/internal/aead.h:16,
                    from drivers/crypto/ccree/cc_buffer_mgr.c:4:
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_din_type':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
>> drivers/crypto/ccree/cc_hw_queue_defs.h:226:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[5] |= FIELD_PREP(WORD5_DIN_ADDR_HIGH, ((u16)(addr >> 32)));
                       ^
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:228:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[1] |= FIELD_PREP(WORD1_DIN_DMA_MODE, dma_mode) |
                       ^
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:229:5: note: in expansion of macro 'FIELD_PREP'
        FIELD_PREP(WORD1_DIN_SIZE, size) |
        ^
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:230:5: note: in expansion of macro 'FIELD_PREP'
        FIELD_PREP(WORD1_NS_BIT, axi_sec);
        ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_din_no_dma':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:244:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size);
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_din_sram':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:260:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size) |
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_din_const':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:276:4: note: in expansion of macro 'FIELD_PREP'
       FIELD_PREP(WORD1_DIN_SIZE, size);
       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_dout_type':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:304:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[5] |= FIELD_PREP(WORD5_DOUT_ADDR_HIGH, ((u16)(addr >> 32)));
                       ^
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:306:20: note: in expansion of macro 'FIELD_PREP'
--
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:455:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_MODE, mode);
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_cipher_config0':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:467:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF0, mode);
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_cipher_config1':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:479:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF1, config);
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_hw_crypto_key':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:493:4: note: in expansion of macro 'FIELD_PREP'
       FIELD_PREP(WORD4_CIPHER_CONF2,
       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_bytes_swap':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:505:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[4] |= FIELD_PREP(WORD4_BYTES_SWAP, config);
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_key_size':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:526:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[4] |= FIELD_PREP(WORD4_KEY_SIZE, size);
                       ^
   drivers/crypto/ccree/cc_hw_queue_defs.h: In function 'set_setup_mode':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_hw_queue_defs.h:560:20: note: in expansion of macro 'FIELD_PREP'
     pdesc->word[4] |= FIELD_PREP(WORD4_SETUP_OPERATION, mode);
                       ^
   drivers/crypto/ccree/cc_lli_defs.h: In function 'cc_lli_set_addr':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
>> drivers/crypto/ccree/cc_lli_defs.h:49:29: note: in expansion of macro 'FIELD_PREP'
     lli_p[LLI_WORD1_OFFSET] |= FIELD_PREP(LLI_HADDR_MASK, (addr >> 32));
                                ^
   drivers/crypto/ccree/cc_lli_defs.h: In function 'cc_lli_set_size':
   include/linux/build_bug.h:29:45: error: bit-field '<anonymous>' width not an integer constant
    #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
                                                ^
   include/linux/bitfield.h:57:2: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     BUILD_BUG_ON_ZERO(__builtin_constant_p(_val) ?   \
     ^
   include/linux/bitfield.h:82:3: note: in expansion of macro '__BF_FIELD_CHECK'
     (__BF_FIELD_CHECK(_mask, 0ULL, _val) +    \
      ^
   drivers/crypto/ccree/cc_lli_defs.h:56:29: note: in expansion of macro 'FIELD_PREP'
     lli_p[LLI_WORD1_OFFSET] |= FIELD_PREP(LLI_SIZE_MASK, size);
                                ^
..

vim +/FIELD_PREP +226 drivers/crypto/ccree/cc_hw_queue_defs.h

4c3f9727 Gilad Ben-Yossef 2018-01-22  210  
4c3f9727 Gilad Ben-Yossef 2018-01-22  211  /*
4c3f9727 Gilad Ben-Yossef 2018-01-22  212   * Set the DIN field of a HW descriptors
4c3f9727 Gilad Ben-Yossef 2018-01-22  213   *
4c3f9727 Gilad Ben-Yossef 2018-01-22  214   * @pdesc: pointer HW descriptor struct
4c3f9727 Gilad Ben-Yossef 2018-01-22  215   * @dma_mode: dmaMode The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
4c3f9727 Gilad Ben-Yossef 2018-01-22  216   * @addr: dinAdr DIN address
4c3f9727 Gilad Ben-Yossef 2018-01-22  217   * @size: Data size in bytes
4c3f9727 Gilad Ben-Yossef 2018-01-22  218   * @axi_sec: AXI secure bit
4c3f9727 Gilad Ben-Yossef 2018-01-22  219   */
4c3f9727 Gilad Ben-Yossef 2018-01-22  220  static inline void set_din_type(struct cc_hw_desc *pdesc,
4c3f9727 Gilad Ben-Yossef 2018-01-22  221  				enum cc_dma_mode dma_mode, dma_addr_t addr,
4c3f9727 Gilad Ben-Yossef 2018-01-22  222  				u32 size, enum cc_axi_sec axi_sec)
4c3f9727 Gilad Ben-Yossef 2018-01-22  223  {
4c3f9727 Gilad Ben-Yossef 2018-01-22  224  	pdesc->word[0] = (u32)addr;
4c3f9727 Gilad Ben-Yossef 2018-01-22  225  #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
4c3f9727 Gilad Ben-Yossef 2018-01-22 @226  	pdesc->word[5] |= FIELD_PREP(WORD5_DIN_ADDR_HIGH, ((u16)(addr >> 32)));
4c3f9727 Gilad Ben-Yossef 2018-01-22  227  #endif
4c3f9727 Gilad Ben-Yossef 2018-01-22  228  	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_DMA_MODE, dma_mode) |
4c3f9727 Gilad Ben-Yossef 2018-01-22  229  				FIELD_PREP(WORD1_DIN_SIZE, size) |
4c3f9727 Gilad Ben-Yossef 2018-01-22  230  				FIELD_PREP(WORD1_NS_BIT, axi_sec);
4c3f9727 Gilad Ben-Yossef 2018-01-22  231  }
4c3f9727 Gilad Ben-Yossef 2018-01-22  232  

:::::: The code at line 226 was first introduced by commit
:::::: 4c3f97276e156820a0433bf7b59a4df1100829ae crypto: ccree - introduce CryptoCell driver

:::::: TO: Gilad Ben-Yossef <gilad@benyossef.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--liOOAslEiF7prFVr
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
0A+KKlkP7jPOJlXJXkVUMa8n/gdB6MZSkc0BAA==

--liOOAslEiF7prFVr--
