Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3556C282D7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8320E21B1A
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfBKP16 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:27:58 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44646 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389702AbfBKO6x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 09:58:53 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gtD2o-00084U-Mf; Mon, 11 Feb 2019 15:58:50 +0100
Message-ID: <dc292127c59e286bbd246f3166debfc39cc4a38f.camel@sipsolutions.net>
Subject: Re: [mac80211-next:cfg80211-mac80211-multi-bssid 8/20] ERROR:
 "__umoddi3" [net/wireless/cfg80211.ko] undefined!
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jouni Malinen <j@w1.fi>
Cc:     kbuild test robot <lkp@intel.com>, Peng Xu <pxu@codeaurora.org>,
        kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Jouni Malinen <jouni@codeaurora.org>
Date:   Mon, 11 Feb 2019 15:58:48 +0100
In-Reply-To: <20190211145747.GA30703@w1.fi>
References: <201902091559.zMnqaexs%fengguang.wu@intel.com>
         <9e586a147fa94995b06011d74ab6ee1a082f4b94.camel@sipsolutions.net>
         <20190211145747.GA30703@w1.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-02-11 at 16:57 +0200, Jouni Malinen wrote:
> On Sat, Feb 09, 2019 at 09:08:20AM +0100, Johannes Berg wrote:
> 
> > but maybe the whole thing is more readable as
> > 
> > static inline void cfg80211_gen_new_bssid(const u8 *bssid_addr, u8 max_bssid,
> >                                           u8 mbssid_index, u8 *new_bssid_addr)
> > {
> >         u64 bssid = ether_addr_to_u64(bssid_addr);
> >         u64 mask = GENMASK_ULL(max_bssid - 1, 0);
> >         u64 new_bssid;
> > 
> >         new_bssid &= bssid & ~mask;
> 
> That should be "=" not "&="..

Yes, good point.

> > However, isn't it true that 0 <= mbssid_index < max_bssid? Then the
> > whole masking isn't really needed at all?
> 
> 0 <= mbssid_index < 2^max_bssid. 

True, sorry.

> The transmitted BSSID (i.e., that
> bssid_addr argument) is not required to be the first BSSID in the range,
> so the masking is needed to cover wraparound for addition modulo
> 2^mbssid_index when max_bssid LSBs of bssid are not zeros.

Ah ok.

Alright, I'll send out a proper patch.

Thanks!

johannes

