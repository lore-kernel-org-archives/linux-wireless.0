Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364C3C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 08:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB2A720652
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 08:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB2A720652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbeJWQlc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 12:41:32 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:35766 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbeJWQlc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 12:41:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gEruB-0007Yi-Ov; Tue, 23 Oct 2018 10:19:11 +0200
Message-ID: <0ead002730ad2902d87c77cc3abeb9c21c4a0930.camel@sipsolutions.net>
Subject: Re: mac80211 keeps trying to start ampdu session??
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <aspriel@gmail.com>
Date:   Tue, 23 Oct 2018 10:18:54 +0200
In-Reply-To: <20181023104404.795619aa@manjaro> (sfid-20181023_094412_429654_F9659EF4)
References: <20181023104404.795619aa@manjaro>
         (sfid-20181023_094412_429654_F9659EF4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-23 at 10:44 +0300, Ali MJ Al-Nasrawy wrote:
> Hi,
> 
> I am trying to debug brcmsmac wireless driver for spamming the log with
> the message:
> [...] START: tid 2 is not agg'able
> for it does not support AMPDU aggreggation for TID 2.
> 
> And after quick tracing, I found that mac80211 keeps trying to start
> AMPDU session for the _same TID and STA_ despite that the driver returns
> non-zero code via its ampdu_action callback and that non-zero return
> codes are recognized as the "HW unavailable" for such session
> (agg-tx.c:ieee80211_tx_ba_session_handle_start)
> 
> So, Is that an expected behaviour from mac80211 or not??

This depends on the rate control algorithm, it triggers this.

I think - perhaps depending on the return value - mac80211 *does* give
up eventually, but not really sure.

Perhaps just remove the message?

johannes

