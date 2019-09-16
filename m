Return-Path: <SRS0=mNgj=XL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114B5C49ED7
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Sep 2019 15:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3B43214AF
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Sep 2019 15:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfIPP1y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 Sep 2019 11:27:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47928 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfIPP1x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Sep 2019 11:27:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i9sug-0006AE-Jf; Mon, 16 Sep 2019 17:27:38 +0200
Message-ID: <6684ceecde399edeb31c594f889a403440c78142.camel@sipsolutions.net>
Subject: Re: [PATCH 3/4] mac80211: fix low throughput in push pull mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yibo Zhao <yiboz@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date:   Mon, 16 Sep 2019 17:27:37 +0200
In-Reply-To: <1568639388-27291-3-git-send-email-yiboz@codeaurora.org> (sfid-20190916_151039_049848_BE125514)
References: <1568639388-27291-1-git-send-email-yiboz@codeaurora.org>
         <1568639388-27291-3-git-send-email-yiboz@codeaurora.org>
         (sfid-20190916_151039_049848_BE125514)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Without really looking at the code - 

> If station is ineligible for transmission in ieee80211_txq_may_transmit(),
> no packet will be delivered to FW. During the tests in push-pull mode with
> many clients, after several seconds, not a single station is an eligible
> candidate for transmission since global time is smaller than all the
> station's virtual airtime. As a consequence, the Tx has been blocked and
> throughput is quite low.

You should rewrite this to be, erm, a bit more understandable in
mac80211 context. I assume you're speaking (mostly?) about ath10k, but I
have very little context there. "push pull mode"? "firmware"? These
things are not something mac80211 knows about.

> Co-developed-by: Yibo Zhao <yiboz@codeaurora.org>

That also seems wrong, should be Toke I guess, unless you intended for a
From: Toke to be present?

johannes


