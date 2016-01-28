Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54990 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935428AbcA1MfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 07:35:21 -0500
Message-ID: <1453984512.2217.15.camel@sipsolutions.net> (sfid-20160128_133542_535617_B8A766EF)
Subject: Re: [PATCH] net/mac80211/agg-rx.c: fix use of uninitialised values
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	aryabinin@virtuozzo.com, Julia Lawall <Julia.Lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>
Date: Thu, 28 Jan 2016 13:35:12 +0100
In-Reply-To: <20160128123022.GB13219@mwanda>
References: <20160126111730.GA6765@localhost>
	 <20160127154618.GA5717@localhost>
	 <CAGRGNgXkvNfzM9Q1RO5kFwUWpFZbQ3mNQi3aVHcPTCw0A9fyFA@mail.gmail.com>
	 <20160128123022.GB13219@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-28 at 15:30 +0300, Dan Carpenter wrote:
> It's not the return where we should trigger the warning it's at the
> 
> 	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
> 
> line.  That's for correctness, but also it should be slightly easier.
> Or it should cut down on false positives if we ignored returns and
> only looked global scope type assignements.

That's a good idea! But even that will probably get you a lot of false
positives. For example, in this structure, the rcu_head is never
initialized until we need it for kfree_rcu() or call_rcu(). I'm sure
there are other places like it.

johannes
