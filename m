Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B080DC282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CCB218A6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 19:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfAYTfC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 14:35:02 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:37378 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfAYTfC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 14:35:02 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn7Fj-0003GU-9h; Fri, 25 Jan 2019 20:34:59 +0100
Message-ID: <c3b87e72436aaae24facd2d329982ef09b9a60df.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] netlink: reduce NLA_POLICY_NESTED{,_ARRAY}
 arguments
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 25 Jan 2019 20:34:57 +0100
In-Reply-To: <20190125.110403.1859522316620338548.davem@davemloft.net>
References: <20190125090828.26361-1-johannes@sipsolutions.net>
         <20190125.110403.1859522316620338548.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-01-25 at 11:04 -0800, David Miller wrote:
> 
> > Dave, it looks like we're the only users of this right now,
> > so let me know if you'd prefer I take it through my tree.
> > Also, this conflicts with the fix I just made to the place
> > where I got it wrong, but obviously the resolution is to
> > just take the version without the maxattr argument.
> 
> Please take it through your tree in that case.  It'll probably
> be the more painless way to merge this.

Will do. The most painless would be if you'd merge net into net-next,
then I could pull net-next into mac80211-next and resolve the conflict
before I even apply the patch. In fact, I think either way I'll just
wait until you do that, I suppose you will eventually anyway?

johannes

