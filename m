Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D324C282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1FBA218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfAYTEF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 14:04:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45696 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfAYTEE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 14:04:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EF54105D1C14;
        Fri, 25 Jan 2019 11:04:04 -0800 (PST)
Date:   Fri, 25 Jan 2019 11:04:03 -0800 (PST)
Message-Id: <20190125.110403.1859522316620338548.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com
Subject: Re: [PATCH net-next] netlink: reduce NLA_POLICY_NESTED{,_ARRAY}
 arguments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190125090828.26361-1-johannes@sipsolutions.net>
References: <20190125090828.26361-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Jan 2019 11:04:04 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 25 Jan 2019 10:08:28 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> In typical cases, there's no need to pass both the maxattr
> and the policy array pointer, as the maxattr should just be
> ARRAY_SIZE(policy) - 1. Therefore, to be less error prone,
> just remove the maxattr argument from the default macros
> and deduce the size accordingly.
> 
> Leave the original macros with a leading underscore to use
> here and in case somebody needs to pass a policy pointer
> where the policy isn't declared in the same place and thus
> ARRAY_SIZE() cannot be used.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Dave, it looks like we're the only users of this right now,
> so let me know if you'd prefer I take it through my tree.
> Also, this conflicts with the fix I just made to the place
> where I got it wrong, but obviously the resolution is to
> just take the version without the maxattr argument.

Please take it through your tree in that case.  It'll probably
be the more painless way to merge this.
