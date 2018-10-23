Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13742C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 20:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAB6C205F4
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 20:29:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAB6C205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbeJXEyw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 00:54:52 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44920 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbeJXEyw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 00:54:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gF3JH-00054s-I0; Tue, 23 Oct 2018 22:29:51 +0200
Message-ID: <7cf4a77e61aa1b48e750bb84fa12952ea648f10e.camel@sipsolutions.net>
Subject: Re: mac80211 keeps trying to start ampdu session??
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <aspriel@gmail.com>, nbd@nbd.name
Date:   Tue, 23 Oct 2018 22:29:32 +0200
In-Reply-To: <20181023151312.65df98c4@manjaro> (sfid-20181023_142316_161504_FE6DE0E4)
References: <20181023104404.795619aa@manjaro>
         <0ead002730ad2902d87c77cc3abeb9c21c4a0930.camel@sipsolutions.net>
         <20181023151312.65df98c4@manjaro> (sfid-20181023_142316_161504_FE6DE0E4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-23 at 15:22 +0300, Ali MJ Al-Nasrawy wrote:

> > This depends on the rate control algorithm, it triggers this.
> 
> In this case, it is minstrel_ht.
> 
> > 
> > I think - perhaps depending on the return value - mac80211 *does* give
> > up eventually, but not really sure.
> 
> The return value is handled only in
> agg-tx.c:ieee80211_tx_ba_session_handle_start and it doesn't pass it
> down or recognize difference between non-zero return values.

Indeed.

> And I don't think that it gives up retrying: I already have 800MB of
> compressed logs for the last four days only full of this message and
> additionally I ran a simple test for the last hour and found that it
> tries to start ampdu session for every frame to be sent with that TID!

Indeed, but that does seem excessive. Perhaps minstrel_ht should learn
to back off, Felix what do you think? In this case the driver basically
says "I don't want to do agg on this TID" and that repeats for every
packet.

> > Perhaps just remove the message?
> 
> OK, I report this just in case of it being unintended behavior with
> probably a negative performance impact.

It might actually, yeah ...

johannes

