Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B518EC282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84DE7218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfAXSIV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:08:21 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35600 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbfAXSIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 13:08:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmjQG-0005KC-2S; Thu, 24 Jan 2019 19:08:16 +0100
Message-ID: <2b8b377a84883db1a45afb42204d8fb5a7d5ccf9.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Remove attribute packed from struct 'action'
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mathieu Malaterre <malat@debian.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 24 Jan 2019 19:08:14 +0100
In-Reply-To: <20190124180535.20216-1-malat@debian.org> (sfid-20190124_190610_293460_EB105BCB)
References: <20190124180535.20216-1-malat@debian.org>
         (sfid-20190124_190610_293460_EB105BCB)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-24 at 19:05 +0100, Mathieu Malaterre wrote:
> During refactor in commit 9e478066eae4 ("mac80211: fix MU-MIMO
> follow-MAC mode") a new struct 'action' was declared with packed
> attribute as:
> 
>   struct {
>           struct ieee80211_hdr_3addr hdr;
>           u8 category;
>           u8 action_code;
>   } __packed action;
> 
> But since struct 'ieee80211_hdr_3addr' is declared with an aligned
> keyword as:
> 
>   struct ieee80211_hdr {
>   	__le16 frame_control;
>   	__le16 duration_id;
>   	u8 addr1[ETH_ALEN];
>   	u8 addr2[ETH_ALEN];
>   	u8 addr3[ETH_ALEN];
>   	__le16 seq_ctrl;
>   	u8 addr4[ETH_ALEN];
>   } __packed __aligned(2);
> 
> Solve the ambiguity of placing aligned structure in a packed one by
> removing the packed attribute from struct. This seems to be the behavior
> of gcc anyway, since the following is still compiling:
> 
>   BUILD_BUG_ON(sizeof(action) != IEEE80211_MIN_ACTION_SIZE + 1);

I'm not sure this will work on all platforms, didn't something like
alpha pad out u8's to u32 when not requiring packing?

I guess I'd feel better about using __packed __aligned(2) here as well,
which should solve the warning too?

johannes


