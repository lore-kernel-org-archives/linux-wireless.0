Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54212 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbcA1JsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 04:48:18 -0500
Message-ID: <1453974492.2217.2.camel@sipsolutions.net> (sfid-20160128_104844_895973_1F80D210)
Subject: Re: [PATCH] net/mac80211/agg-rx.c: fix use of uninitialised values
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	aryabinin@virtuozzo.com, Julia Lawall <Julia.Lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>
Date: Thu, 28 Jan 2016 10:48:12 +0100
In-Reply-To: <CAGRGNgXkvNfzM9Q1RO5kFwUWpFZbQ3mNQi3aVHcPTCw0A9fyFA@mail.gmail.com> (sfid-20160128_002736_648758_DED52DA5)
References: <20160126111730.GA6765@localhost>
	 <20160127154618.GA5717@localhost>
	 <CAGRGNgXkvNfzM9Q1RO5kFwUWpFZbQ3mNQi3aVHcPTCw0A9fyFA@mail.gmail.com>
	 (sfid-20160128_002736_648758_DED52DA5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-28 at 10:27 +1100, Julian Calaby wrote:
> 
> This looks like a "big hammer" solution to this problem.

It is, in a way, but it also avoids future errors like it.

> I'd prefer to just set ->removed to false right after we set
> ->auto_seq as that should be faster, however I don't know if
> __ieee80211_start_rx_ba_session() is a fast path so I don't know if
> this is saving anything.

It's not supposed to be called frequently, no.

> On another note, this is an error that should be pretty easy to spot.
> Could any of the automated tools find cases where a struct containing
> a bool variable is kmalloc'd and returned without assigning all the
> bools?

I think you'd quickly drown in false positives, since "return" isn't
necessarily something that means it needs to have been fully
initialized.

johannes
