Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A6AC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 22:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD4E3218A2
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 22:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbfBZWBw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 17:01:52 -0500
Received: from mx2.mailbox.org ([80.241.60.215]:40948 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfBZWBw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 17:01:52 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 0FDBEA1134;
        Tue, 26 Feb 2019 23:01:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id EzYSXfmMk-jU; Tue, 26 Feb 2019 23:01:46 +0100 (CET)
Subject: Re: [PATCH] {nl,mac}80211: allow 4addr AP operation on crypto
 controlled devices
To:     Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>
References: <1542798228-3293-1-git-send-email-mpubbise@codeaurora.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
 IXp4PqR6piQM6Rfbx1enZzFmXVg=
Message-ID: <479f8872-86fe-4976-6005-c590e84a4bf4@hauke-m.de>
Date:   Tue, 26 Feb 2019 23:01:45 +0100
MIME-Version: 1.0
In-Reply-To: <1542798228-3293-1-git-send-email-mpubbise@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/21/18 12:03 PM, Manikanta Pubbisetty wrote:
> As per the current design, for sw crypto controlled devices, it is
> the device which has to advertise the support for AP/VLAN iftype
> based on it's capability to tranmsit packets encrypted in software
> (In VLAN functionality, group traffic generated for a specific
> VLAN group is always encrypted in software). Commit db3bdcb9c3ff
> ("mac80211: allow AP_VLAN operation on crypto controlled devices")
> has introduced this change.
> 
> Since 4addr AP operation also uses AP/VLAN iftype, this conditional
> way of advertising AP/VLAN support has broken 4addr AP mode operation on
> crypto controlled devices which do not support VLAN functionality.
> 
> For example:
> In the case of ath10k driver, not all firmwares have support for VLAN
> functionality but all can support 4addr AP operation. Because AP/VLAN
> support is not advertised for these devices, 4addr AP operations are
> also blocked.
> 
> Fix this by allowing 4addr opertion on devices which do not advertise
> AP/VLAN iftype but which can support 4addr operation (the desicion is
> taken based on the wiphy flag WIPHY_FLAG_4ADDR_AP).
> 
> Fixes: Commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on
> crypto controlled devices")
> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> ---
>  include/net/cfg80211.h |  3 ++-
>  net/mac80211/util.c    |  4 +++-
>  net/wireless/core.c    |  9 +++++++--
>  net/wireless/nl80211.c | 10 ++++++++--
>  4 files changed, 20 insertions(+), 6 deletions(-)
> 
Hi Manikanta,

Will you send an updated version of this patch to mainline?

Multiple people ran into this problem in OpenWrt and it would be nice if
such a fix would be included in upstream kernel.

See here a pull request:
https://github.com/openwrt/openwrt/pull/1640

Hauke
