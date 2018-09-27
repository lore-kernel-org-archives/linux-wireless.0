Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA9BC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6045E21570
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:51:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6045E21570
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbeI0PJB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:09:01 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53052 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbeI0PJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:09:00 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5S1V-0008Em-Se; Thu, 27 Sep 2018 10:51:50 +0200
Message-ID: <1538038297.14416.25.camel@sipsolutions.net>
Subject: Re: [PATCH] netlink: add policy attribute range validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 27 Sep 2018 10:51:37 +0200
In-Reply-To: <20180927084807.GG30601@unicorn.suse.cz>
References: <20180926200630.23399-1-johannes@sipsolutions.net>
         <1537993066.28767.29.camel@sipsolutions.net>
         <1537994127.28767.39.camel@sipsolutions.net>
         <20180927071621.GF30601@unicorn.suse.cz>
         <1538035929.14416.21.camel@sipsolutions.net>
         <20180927084807.GG30601@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-27 at 10:48 +0200, Michal Kubecek wrote:

> We could still use helper macros so this part could become
> 
> DEFINE_NLA_U8_RANGE(retry_range, 1, 255);
> 
> or
> 
> DEFINE_NLA_RANGE(retry_range, u8, 1, 255);

True.

> > policy[] = {
> > 	...
> > 	[NL80211_ATTR_WIPHY_RETRY_SHORT] = {
> > 		.type = NLA_U8,
> > 		.validation_data = &retry_range,
> > 	},
> > 	...
> > };
> 
> And this could be also shortened using a macro.
> 
> It would still be longer but not that much.

Right. You'd still have to name it, and then we'd probably eventually
want to share some common range definitions, but indeed it would work.

> I didn't mean it as a serious objection, rather a note that the gain may
> not be worth the additional complexity. 

Sure, and suggestions are very welcome. I was just trying to explain why
I chose this direction, more than anything else.

> But if you want to follow in the
> direction you indicated later (in particular, allowing different
> interpretations of validation_data for the same type), overloading does
> indeed make more sense.

I'm just working on the patches - give me a few more minutes.

johannes
