Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5932EC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 08:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25C1E20869
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 08:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfBIIIZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 03:08:25 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40418 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfBIIIZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 03:08:25 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gsNgU-0000Yw-Fp; Sat, 09 Feb 2019 09:08:22 +0100
Message-ID: <9e586a147fa94995b06011d74ab6ee1a082f4b94.camel@sipsolutions.net>
Subject: Re: [mac80211-next:cfg80211-mac80211-multi-bssid 8/20] ERROR:
 "__umoddi3" [net/wireless/cfg80211.ko] undefined!
From:   Johannes Berg <johannes@sipsolutions.net>
To:     kbuild test robot <lkp@intel.com>, Peng Xu <pxu@codeaurora.org>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Jouni Malinen <jouni@codeaurora.org>
Date:   Sat, 09 Feb 2019 09:08:20 +0100
In-Reply-To: <201902091559.zMnqaexs%fengguang.wu@intel.com> (sfid-20190209_084748_191360_57355899)
References: <201902091559.zMnqaexs%fengguang.wu@intel.com>
         (sfid-20190209_084748_191360_57355899)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This should fix it, I think?

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b61b71f369c7..cb0c49b369c4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5488,7 +5488,7 @@ static inline void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
        lsb_n = bssid_tmp & ((1 << max_bssid) - 1);
        new_bssid = bssid_tmp;
        new_bssid &= ~((1 << max_bssid) - 1);
-       new_bssid |= (lsb_n + mbssid_index) % (1 << max_bssid);
+       new_bssid |= (lsb_n + mbssid_index) & GENMASK_ULL(max_bssid - 1, 0);
 
        u64_to_ether_addr(new_bssid, new_bssid_addr);
 }

and we probably should write "(1 << max_bssid) - 1" the line above as
the same GENMASK_ULL():

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5482,13 +5482,14 @@ static inline void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
 {
        u64 bssid_tmp, new_bssid;
        u64 lsb_n;
+       u64 mask = GENMASK_ULL(max_bssid - 1, 0);
 
        bssid_tmp = ether_addr_to_u64(bssid);
 
-       lsb_n = bssid_tmp & ((1 << max_bssid) - 1);
+       lsb_n = bssid_tmp & mask;
        new_bssid = bssid_tmp;
-       new_bssid &= ~((1 << max_bssid) - 1);
-       new_bssid |= (lsb_n + mbssid_index) % (1 << max_bssid);
+       new_bssid &= ~mask;
+       new_bssid |= (lsb_n + mbssid_index) & mask;
 
        u64_to_ether_addr(new_bssid, new_bssid_addr);
 }


but maybe the whole thing is more readable as

static inline void cfg80211_gen_new_bssid(const u8 *bssid_addr, u8 max_bssid,
                                          u8 mbssid_index, u8 *new_bssid_addr)
{
        u64 bssid = ether_addr_to_u64(bssid_addr);
        u64 mask = GENMASK_ULL(max_bssid - 1, 0);
        u64 new_bssid;

        new_bssid &= bssid & ~mask;
        new_bssid |= ((bssid & mask) + mbssid_index) & mask;

        u64_to_ether_addr(new_bssid, new_bssid_addr);
}

However, isn't it true that 0 <= mbssid_index < max_bssid? Then the
whole masking isn't really needed at all?

johannes


On Sat, 2019-02-09 at 15:47 +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git cfg80211-mac80211-multi-bssid
> head:   851ae31d34063deb1eae49f5d797a12a5557e832
> commit: 0b8fb8235be8be99a197e8d948fc0a2df8dc261a [8/20] cfg80211: Parsing of Multiple BSSID information in scanning
> config: i386-randconfig-x0-02091211 (attached as .config)
> compiler: gcc-5 (Debian 5.5.0-3) 5.4.1 20171010
> reproduce:
>         git checkout 0b8fb8235be8be99a197e8d948fc0a2df8dc261a
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
> > > ERROR: "__umoddi3" [net/wireless/cfg80211.ko] undefined!
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

