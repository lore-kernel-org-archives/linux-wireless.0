Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15157C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 20:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9AB2206B7
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 20:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbfDDUU3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 16:20:29 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41426 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729184AbfDDUU2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 16:20:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hC8qV-0005b7-3S; Thu, 04 Apr 2019 22:20:23 +0200
Message-ID: <a432ffb79a23dcc9276cdec15f156189de4518ea.camel@sipsolutions.net>
Subject: Re: [PATCH 0/6] stricter netlink validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, dsa@cumulusnetworks.com
Date:   Thu, 04 Apr 2019 22:20:20 +0200
In-Reply-To: <20190404.102850.631122626573856353.davem@davemloft.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
         <20190404.102850.631122626573856353.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-04-04 at 10:28 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu,  4 Apr 2019 08:54:02 +0200
> 
> > Here's a version that has passed build testing ;-)
> 
> :-)

Actually it passed more than that - I did test the nl80211 bits etc.,
but I hadn't build-tested everything before so some missing function
renames were caught by the full build testing.

> I really like the approach taken here, and done in such a way that
> new attributes added get strict checking by default.

It's two things really

 * new commands (aka new instances of nla_parse/nlmsg_parse and friends)
   --> strict checking for everything, including existing attributes
       because we reason that you're writing some new userspace code,
       and even if that might use some existing functionality, which
       might even be wrong, you're going to fix it here

 * new attributes on existing commands (in the policy)
   --> can be set up (with the strict_start_type from patch 4) to be
       strictly checked

> I'll let David Ahern et al. have time to review this.

Sure.

FWIW, I wasn't really entirely sure I liked doing a cross-tree rename,
but ultimately I felt that we should discourage uses of what I now
called *_deprecated() and *_strict_deprecated() APIs, and having sort of
the "default" names do the thing we believe is right (strict checking)
helps with that - in a sort of 'social engineering' way, people will not
want to type out "_deprecated" all the time ;-)

I do realize that this may be a bit controversial and am certainly open
to other suggestions on this.

Similarly, I engineered the generic netlink stuff in a way that adding
non-strict behaviour needs extra work, so that hopefully new stuff will
not do that extra work.

Also, both of these are then easier to see in reviews, since you can see
"deprecated" in the function names, or "DONT_VALIDATE" in the generic
netlink things.

johannes

