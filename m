Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBFEC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32C9020881
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="owd2jLzc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfA2JU0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:20:26 -0500
Received: from mail.toke.dk ([52.28.52.200]:51719 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbfA2JU0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 04:20:26 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1548753623; bh=Ani2N4TLvbjG0OatgymzPLITBR2YxR72IQAB0+pZyfE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=owd2jLzcOXe13rn9Yn+L0JOUTlYQNPr8toz9LUYncGtT2jdOq3d+dqMngwBIn+wjz
         szxexqX8a+Ri2GBKpDH3+jmRhIayKU2D/pp13cIt1Ugke3QPQX+xwqk4uzr46/QYyD
         15Nvh/OLfA6rbkqqhL7riM6/ry1xuNKZvsgaiFTeOiEIBEsyA7Sn5tXSGOG5OZRiuX
         phv+PXyS7hlHBuhTmZOj9Bq0M0b9FvwWIp/G6/fKbsYgnlOT+iNo25IwumhvA9rsWl
         27xopdyIEWi635eLj0Gdd9vJZFFfKkaG5uHPix8RQZhD0UsUVORqFwRd5LFThBsC9U
         esE4WG/gIGGqw==
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Louie Lu <git@louie.lu>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [mac80211-next:master 3/17] htmldocs: include/net/mac80211.h:2403: warning: Function parameter or member 'weight_multiplier' not described in 'ieee80211_hw'
In-Reply-To: <201901291755.Wdu7zEih%fengguang.wu@intel.com>
References: <201901291755.Wdu7zEih%fengguang.wu@intel.com>
Date:   Tue, 29 Jan 2019 10:20:20 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87munjkegb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

kbuild test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
> head:   6c900360e7c0df6a4846ac97d7b548d72cd801b0
> commit: b4809e9484da147dc82a31b961df111eee72201a [3/17] mac80211: Add airtime accounting and scheduling to TXQs
> reproduce: make htmldocs
>
> All warnings (new ones prefixed by >>):

[...]

>>> include/net/mac80211.h:2403: warning: Function parameter or member 'weight_multiplier' not described in 'ieee80211_hw'

This one is there, but typo'ed.

[...]

>>> net/mac80211/sta_info.h:603: warning: Function parameter or member 'airtime' not described in 'sta_info'
>>> net/mac80211/sta_info.h:603: warning: Function parameter or member 'airtime_weight' not described in 'sta_info'

Whereas these are actually missing...



I'll send a patch fixing both issues :)

-Toke
