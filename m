Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF52C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 16:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05C7820828
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 16:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbfCYQSP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:18:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44610 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfCYQSO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 12:18:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h8SIe-0006oI-Q4; Mon, 25 Mar 2019 17:18:13 +0100
Message-ID: <9c7d400791aee24497f33fd1695770a88bb82fc8.camel@sipsolutions.net>
Subject: Re: [RFC PATCH] mac80211/cfg80211: update bss channel on channel
 switch
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Date:   Mon, 25 Mar 2019 17:18:10 +0100
In-Reply-To: <20190325154443.elzp5n6nfngtg5vk@bars>
References: <20190321151915.16826-1-sergey.matyukevich.os@quantenna.com>
         <3d76d0d033609fff4e72448a9fd7d63ad1365cb2.camel@sipsolutions.net>
         <20190325154443.elzp5n6nfngtg5vk@bars>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-03-25 at 15:44 +0000, Sergey Matyukevich wrote:
> > > 
> > I worry slightly about locking too, since there's no protection on the
> > wdev->current_bss pointer here.
> 
> Ok, I will add WARN_ON. As for locking, this function is supposed to be
> called with wdev->mtx held, see ASSERT_WDEV_LOCK. Do you think this may
> not be enough ? 

Oops, no, that's definitely sufficient. I missed it.

> I need to check mwifiex more carefully, but other cfg80211_ch_switch_notify
> users (mac80211, ath6kl, qtnfmac) seem to do that locking properly.

Well I guess they'd assert and then do something unsafe, so wouldn't
worry about it.

johannes

