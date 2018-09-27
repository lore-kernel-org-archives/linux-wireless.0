Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FA7C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 07:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64A9120836
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 07:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64A9120836
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbeI0NdM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 09:33:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:42278 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbeI0NdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 09:33:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 502CCAE8F;
        Thu, 27 Sep 2018 07:16:22 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DB526A1004; Thu, 27 Sep 2018 09:16:21 +0200 (CEST)
Date:   Thu, 27 Sep 2018 09:16:21 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: add policy attribute range validation
Message-ID: <20180927071621.GF30601@unicorn.suse.cz>
References: <20180926200630.23399-1-johannes@sipsolutions.net>
 <1537993066.28767.29.camel@sipsolutions.net>
 <1537994127.28767.39.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537994127.28767.39.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Sep 26, 2018 at 10:35:27PM +0200, Johannes Berg wrote:
> On Wed, 2018-09-26 at 22:17 +0200, Johannes Berg wrote:
> > On Wed, 2018-09-26 at 22:06 +0200, Johannes Berg wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > Without further bloating the policy structs, we can overload
> > > the `validation_data' pointer with a struct of s16 min, max
> > > and use those to validate ranges in NLA_{U,S}{8,16,32,64}
> > > attributes.
> > > 
> > > It may sound strange to validate NLA_U32 with a s16 max, but
> > > in many cases NLA_U32 is used for enums etc. since there's no
> > > size benefit in using a smaller attribute width anyway, due
> > > to netlink attribute alignment; in cases like that it's still
> > > useful, particularly when the attribute really transports an
> > > enum value.
> > 
> > That said, I did find a few places where we could benefit from a larger
> > type here - e.g. having a NLA_U16 that must be non-zero cannot be
> > represented in the policy as is, since you can't set max to 65535.
> 
> We could also fix that, btw, by taking two bits out of the "type" field,
> and letting those indicate "check_min" and "check_max". That would also
> fix the other thing I noted regarding the union, I suppose.
> 
> I didn't really like that too much because it makes the whole thing far
> more complex, but perhaps if we hide it behind macros like
> 
> #define NLA_POLICY_RANGE(tp, _min, _max) {
> 	.type = tp,
> 	.min = _min, .check_min = 1,
> 	.max = _max, .check_max = 1,
> }
> 
> #define NLA_POLICY_MIN(tp, _min) {
> 	.type = tp,
> 	.min = _min, .check_min = 1,
> }
> 
> #define NLA_POLICY_MAX(tp, _max) {
> 	.type = tp,
> 	.max = _max, .check_max = 1,
> }
> 
> it becomes more palatable?

The overloading still feels a bit complicated. Perhaps we could rather
use validation_data in the natural way, i.e. as a pointer to validation
data. That would be a struct (maybe array) of two values of the
corresponding type. It would mean a bit more data and a bit more writing
but it would be IMHO more straightforward.

Michal Kubecek
