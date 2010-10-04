Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0JDQjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 12:39:55 -0400
Subject: Re: [PATCH v2 2/3] mac80211: wait until completely disassociated
 before new association
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
In-Reply-To: <20101004163605.GC2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
	 <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
	 <1286198080.3620.34.camel@jlt3.sipsolutions.net>
	 <20101004163605.GC2105@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 18:39:52 +0200
Message-ID: <1286210392.3620.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 09:36 -0700, Luis R. Rodriguez wrote:

> > > +wait:
> > >  	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
> > >  	run_again(local, wk->timeout);
> > 
> > But you'll be staying off-channel for the wait period, so what does this
> > really help?
> 
> I totally missed this what locks us offchannel here, I though we just re-arm
> the timer, and come back offchannel at a later time. What is it that locks
> us offchannel until the timer runs again?

I believe we stay off-channel as long as the work item is active, after
it has been activated, no?

johannes

