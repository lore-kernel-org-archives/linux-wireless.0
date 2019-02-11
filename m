Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BFCC282D7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7FA821B26
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389032AbfBKO5z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 09:57:55 -0500
Received: from mail.w1.fi ([212.71.239.96]:36186 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389432AbfBKO5w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 09:57:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by li674-96.members.linode.com (Postfix) with ESMTP id B702611C62;
        Mon, 11 Feb 2019 14:57:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from li674-96.members.linode.com ([127.0.0.1])
        by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vyyx8IFe40up; Mon, 11 Feb 2019 14:57:49 +0000 (UTC)
Received: by jm (sSMTP sendmail emulation); Mon, 11 Feb 2019 16:57:47 +0200
Date:   Mon, 11 Feb 2019 16:57:47 +0200
From:   Jouni Malinen <j@w1.fi>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     kbuild test robot <lkp@intel.com>, Peng Xu <pxu@codeaurora.org>,
        kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: Re: [mac80211-next:cfg80211-mac80211-multi-bssid 8/20] ERROR:
 "__umoddi3" [net/wireless/cfg80211.ko] undefined!
Message-ID: <20190211145747.GA30703@w1.fi>
References: <201902091559.zMnqaexs%fengguang.wu@intel.com>
 <9e586a147fa94995b06011d74ab6ee1a082f4b94.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e586a147fa94995b06011d74ab6ee1a082f4b94.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Feb 09, 2019 at 09:08:20AM +0100, Johannes Berg wrote:

> but maybe the whole thing is more readable as
> 
> static inline void cfg80211_gen_new_bssid(const u8 *bssid_addr, u8 max_bssid,
>                                           u8 mbssid_index, u8 *new_bssid_addr)
> {
>         u64 bssid = ether_addr_to_u64(bssid_addr);
>         u64 mask = GENMASK_ULL(max_bssid - 1, 0);
>         u64 new_bssid;
> 
>         new_bssid &= bssid & ~mask;

That should be "=" not "&="..

>         new_bssid |= ((bssid & mask) + mbssid_index) & mask;
> 
>         u64_to_ether_addr(new_bssid, new_bssid_addr);
> }

but other than that, this version looks much nicer than the other
alternatives.

> However, isn't it true that 0 <= mbssid_index < max_bssid? Then the
> whole masking isn't really needed at all?

0 <= mbssid_index < 2^max_bssid. The transmitted BSSID (i.e., that
bssid_addr argument) is not required to be the first BSSID in the range,
so the masking is needed to cover wraparound for addition modulo
2^mbssid_index when max_bssid LSBs of bssid are not zeros.

-- 
Jouni Malinen                                            PGP id EFC895FA
