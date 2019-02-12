Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2611C282CA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 19:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9818A222C0
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 19:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbfBLTDZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 14:03:25 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:54396 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfBLTDY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 14:03:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gtdKx-0007SD-Gh; Tue, 12 Feb 2019 20:03:19 +0100
Message-ID: <ea6479e089dffc46bb9b09e28d364db4c071998f.camel@sipsolutions.net>
Subject: Re: [PATCH v2] rhashtable: make walk safe from softirq context
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, herbert@gondor.apana.org.au,
        Bob Copeland <me@bobcopeland.com>
Date:   Tue, 12 Feb 2019 20:03:17 +0100
In-Reply-To: <20190212.104339.1794719792249723582.davem@davemloft.net>
References: <20190206090721.8001-1-johannes@sipsolutions.net>
         <20190212.104339.1794719792249723582.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-02-12 at 10:43 -0800, David Miller wrote:

> Herbert and Johannes, I need some guidance.
> 
> It seems Herbert wants the softirq usage of rhashtables removed, 

Well, specifically of rhashtable walkers. I can only concede that he's
right in that a hashtable walk during softirq (or even with softirqs
disabled) was maybe a bad idea.

At the same time, it's likely going to be pretty deep surgery in this
code, and I'm not sure I can do that right now. Maybe Bob has some
thoughts if it can be achieved more easily, but I think it'd require
adding a new list to each station that tracks which mesh paths it is the
next_hop for, and making sure that's maintained correctly, which feels
tricky but maybe it's not (I could be more familiar with mesh ...)


Evidently this goes back to 

commit 60854fd94573f0d3b80b55b40cf0140a0430f3ab
Author: Bob Copeland <me@bobcopeland.com>
Date:   Wed Mar 2 10:09:20 2016 -0500

    mac80211: mesh: convert path table to rhashtable

which is kinda old. Not sure why this didn't surface before, because the
spinlock was introduced *before*, otherwise certainly the mutex would've
caused us to not be able to do this code to start with (commit
c6ff5268293 - rhashtable: Fix walker list corruption).

That commit also just converted an existing hashtable walk to
rhashtable, so not sure that counts as having introduced the problem :-)


I guess that's not really guidance. If it were my call I'd apply the
patch and issue a stern warning to myself to remove this ASAP ;-) But
sadly, mesh isn't exactly a priority to most, so not sure when that "P"
would be.


But I guess we should also ask Bob first:
1) do you think it'd be easy to maintain a separate list or avoid the
   iteration in some otherway, and make that a small enough patch to be
   applicable for stable?
2) or do you think maybe the mesh_plink_broken() call could just be
   lifted into a workqueue instead?

johannes

