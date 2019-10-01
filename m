Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1A6C352AA
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 11:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A52121924
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 11:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfJALBR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 07:01:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59740 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfJALBR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 07:01:17 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFFu5-00064U-9Y; Tue, 01 Oct 2019 13:01:13 +0200
Message-ID: <5bbc9f7d3a01cd578cbf894469734d88c8f59279.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: keep BHs disabled while calling
 drv_tx_wake_queue()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiri Kosina <jikos@kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Aaron Hill <aa1ronham@gmail.com>,
        Lukas Redlinger <rel+kernel@agilox.net>,
        Oleksii Shevchuk <alxchk@gmail.com>
Date:   Tue, 01 Oct 2019 13:01:12 +0200
In-Reply-To: <nycvar.YFH.7.76.1910011256001.13160@cbobk.fhfr.pm>
References: <1569924485-I3e8838c5ecad878e59d4a94eb069a90f6641461a@changeid>
         <87blv0visz.fsf@toke.dk>
         <nycvar.YFH.7.76.1910011256001.13160@cbobk.fhfr.pm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-10-01 at 12:56 +0200, Jiri Kosina wrote:
> On Tue, 1 Oct 2019, Toke Høiland-Jørgensen wrote:
> 
> > > -			spin_unlock_bh(&fq->lock);
> > > +			spin_unlock(&fq->lock);
> > >  			drv_wake_tx_queue(local, txqi);
> > > -			spin_lock_bh(&fq->lock);
> > > +			spin_lock(&fq->lock);
> > 
> > Okay, so this will mean that the drv_wake_tx_queue() entry point will be
> > called with bhs disabled. But there are lots of uses of
> > spin_{,un}lock_bh() in tx.c:
> 
> I am fine with whatever fix for this you guys settle on :) Just for the 
> record, I proposed this back then:
> 
> 	http://lore.kernel.org/r/nycvar.YFH.7.76.1904151300160.9803@cbobk.fhfr.pm
> 
> maybe it could be resurected, as I believe it'd fix this one as well?

Yes, it would, but it wouldn't address any other driver that likely has
the same issue :)

johannes

