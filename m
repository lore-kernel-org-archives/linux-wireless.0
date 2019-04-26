Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C933BC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25322089E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfDZKDR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 06:03:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55056 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfDZKDR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 06:03:17 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJxhL-0000Za-MC; Fri, 26 Apr 2019 12:03:15 +0200
Message-ID: <07406271ac4426877811439fdf4c75b8e3880105.camel@sipsolutions.net>
Subject: Re: [PATCHv4 0/2] cfg80211/mac80211: Add support to configure and
 monitor station's rssi threshold
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Apr 2019 12:03:14 +0200
In-Reply-To: <1555492880-26457-1-git-send-email-tamizhr@codeaurora.org>
References: <1555492880-26457-1-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-17 at 14:51 +0530, Tamizh chelvam wrote:
> This patchsets introduced new NL command and api to support
> configuring rssi for the connected stations and api to notify
> userspace application upon crossing the configured threshold.
> This will be useful for the application which requires
> station's current signal strength change information.

What is "the application"?

Given all our discussions at the summit and my thinking on all of this
recently, I'm _very_ tempted to just reject this patchset after all, and
ask you to (help) implement appropriate eBPF hooks in the stack that can
be used to implement it instead.

Why is this better than programmable infrastructure for it?

johannes

