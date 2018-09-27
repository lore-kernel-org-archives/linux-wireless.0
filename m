Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C754C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E136521580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:48:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E136521580
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbeI0PFR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:05:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:57904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726929AbeI0PFR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:05:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D119AF53;
        Thu, 27 Sep 2018 08:48:08 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B25F3A1004; Thu, 27 Sep 2018 10:48:07 +0200 (CEST)
Date:   Thu, 27 Sep 2018 10:48:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: add policy attribute range validation
Message-ID: <20180927084807.GG30601@unicorn.suse.cz>
References: <20180926200630.23399-1-johannes@sipsolutions.net>
 <1537993066.28767.29.camel@sipsolutions.net>
 <1537994127.28767.39.camel@sipsolutions.net>
 <20180927071621.GF30601@unicorn.suse.cz>
 <1538035929.14416.21.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538035929.14416.21.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 10:12:09AM +0200, Johannes Berg wrote:
> On Thu, 2018-09-27 at 09:16 +0200, Michal Kubecek wrote:
> 
> > The overloading still feels a bit complicated. Perhaps we could rather
> > use validation_data in the natural way, i.e. as a pointer to validation
> > data. That would be a struct (maybe array) of two values of the
> > corresponding type. It would mean a bit more data and a bit more writing
> > but it would be IMHO more straightforward.
> 
> I considered that, but I didn't really like it either. The memory
> wasting isn't *that* bad (even if we go to s64 that'd only be ~20x16
> bytes for nl80211, eating up 320 out of the 550 saved, but still); I'm
> more worried about making this really hard to actually *do*.
> 
> Consider
> 
> policy[] = {
> 	...
> 	[NL80211_ATTR_WIPHY_RETRY_SHORT] =
> 		NLA_POLICY_RANGE(NLA_U8, 1, 255),
> 	...
> };
> 
> vs.
> 
> static const struct netlink_policy_range retry_range = {
> 	.min = 1,
> 	.max = 255,
> };

We could still use helper macros so this part could become

DEFINE_NLA_U8_RANGE(retry_range, 1, 255);

or

DEFINE_NLA_RANGE(retry_range, u8, 1, 255);

> 
> policy[] = {
> 	...
> 	[NL80211_ATTR_WIPHY_RETRY_SHORT] = {
> 		.type = NLA_U8,
> 		.validation_data = &retry_range,
> 	},
> 	...
> };

And this could be also shortened using a macro.

It would still be longer but not that much.

> That's significantly more to type, to the point where I'd seriously
> consider doing this only for attributes that are used and checked in
> many places - it doesn't feel like a big win over manual range-checking.
> 
> But I want it to be a win over manual range-checking so it gets used
> more because it's more efficient, less prone to getting messed up if
> multiple places use the same attribute and validates attributes even if
> they're ignored by an operation.
> 
> 
> I'd also say that we're certainly no strangers to union/overloading, so
> I don't feel like this is a big argument. One doesn't even really have
> to be *aware* of it for the most part: if it were a struct instead of a
> union, it'd actually have the same effect since the .type field
> indicates which part gets used. That it's overloaded in a union is
> basically just a space saving measure, I don't think it makes the
> reasoning much more complex?

I didn't mean it as a serious objection, rather a note that the gain may
not be worth the additional complexity. But if you want to follow in the
direction you indicated later (in particular, allowing different
interpretations of validation_data for the same type), overloading does
indeed make more sense.

Michal Kubecek
