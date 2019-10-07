Return-Path: <SRS0=BfPD=YA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D720C47404
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Oct 2019 19:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDD472070B
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Oct 2019 19:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfJGTnu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Oct 2019 15:43:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45336 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbfJGTnu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Oct 2019 15:43:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iHYv4-00088e-7l; Mon, 07 Oct 2019 21:43:46 +0200
Message-ID: <600f64e1e673fff25d2be71ac767d7332db0452a.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: Implement Airtime-based Queue Limit (AQL)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kan Yan <kyan@google.com>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Yibo Zhao <yiboz@codeaurora.org>
Date:   Mon, 07 Oct 2019 21:43:45 +0200
In-Reply-To: <878spwmjif.fsf@toke.dk>
References: <20191004062151.131405-1-kyan@google.com>
         <20191004062151.131405-2-kyan@google.com> <87imp4o6qp.fsf@toke.dk>
         <CA+iem5vJFRxskyHOKf5K73X8aGH965P4hoiCj-wQtK-Z-47pdg@mail.gmail.com>
         <87pnj9n55y.fsf@toke.dk>
         <aa40e945adfbeb52890afb2de493142e82ecf69d.camel@sipsolutions.net>
         <878spwmjif.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-10-07 at 21:40 +0200, Toke Høiland-Jørgensen wrote:

> > > So if and when we start supporting true multi-band devices we'll have to
> > > change these things anyway. So might as well keep everything together so
> > > it all gets fixed :)
> > 
> > I guess I'm OK with that, but I'm pretty sure this will come up sooner
> > rather than later ...
> > 
> > What else is there though?
> 
> By "it all" I meant "all the airtime fairness stuff". Other than that, I
> didn't have anything in particular in mind. I just kinda assumed there
> would be lots of places that had an implicit assumption that all devices
> on the same phy shares a channel...

Not _that_ much - we do have the channel contexts after all. But except
for hwsim (*cough cough* I was lazy) nothing actually implements real
concurrent multi-channel yet, obviously, but uses a single radio with
channel hopping...

johannes

