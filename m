Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48252C282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B4E218A6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfAYTgb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 14:36:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfAYTga (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 14:36:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 456A4145A92E0;
        Fri, 25 Jan 2019 11:36:30 -0800 (PST)
Date:   Fri, 25 Jan 2019 11:36:27 -0800 (PST)
Message-Id: <20190125.113627.2203898610397855035.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: reduce NLA_POLICY_NESTED{,_ARRAY}
 arguments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c3b87e72436aaae24facd2d329982ef09b9a60df.camel@sipsolutions.net>
References: <20190125090828.26361-1-johannes@sipsolutions.net>
        <20190125.110403.1859522316620338548.davem@davemloft.net>
        <c3b87e72436aaae24facd2d329982ef09b9a60df.camel@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Jan 2019 11:36:30 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 25 Jan 2019 20:34:57 +0100

> On Fri, 2019-01-25 at 11:04 -0800, David Miller wrote:
>> 
>> > Dave, it looks like we're the only users of this right now,
>> > so let me know if you'd prefer I take it through my tree.
>> > Also, this conflicts with the fix I just made to the place
>> > where I got it wrong, but obviously the resolution is to
>> > just take the version without the maxattr argument.
>> 
>> Please take it through your tree in that case.  It'll probably
>> be the more painless way to merge this.
> 
> Will do. The most painless would be if you'd merge net into net-next,
> then I could pull net-next into mac80211-next and resolve the conflict
> before I even apply the patch. In fact, I think either way I'll just
> wait until you do that, I suppose you will eventually anyway?

Yeah I will probably send Linus a pull request today which means the
net --> net-next merge should occur in the next 24 hours.
