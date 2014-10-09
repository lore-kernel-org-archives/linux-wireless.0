Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57218 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaJIJkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:40:10 -0400
Message-ID: <1412847604.1828.38.camel@jlt4.sipsolutions.net> (sfid-20141009_114013_921425_9693C9F2)
Subject: Re: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 09 Oct 2014 11:40:04 +0200
In-Reply-To: <21530.29268.867868.46188@gargle.gargle.HOWL>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	 <21529.5141.845629.86918@gargle.gargle.HOWL>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
	 <21529.8110.26388.664223@gargle.gargle.HOWL>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com>
	 <21529.9155.323515.987489@gargle.gargle.HOWL>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com>
	 <21529.10109.308613.563543@gargle.gargle.HOWL>
	 <CANUX_P3hdFeCPmqHCdP8JKwqvUUnjgp3SNy1GQDrQd0bG+WKng@mail.gmail.com>
	 <21530.19430.782437.984290@gargle.gargle.HOWL>
	 <21530.23545.178915.653622@gargle.gargle.HOWL>
	 <CANUX_P3o6=sdjHPp2L7tGAeXRW0v4xqSV-2q27Neetu75bDc1A@mail.gmail.com>
	 <21530.29268.867868.46188@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-18 at 11:19 +0530, Sujith Manoharan wrote:

> I can see your point and agree that the original intention of the mgd_prepare_tx()
> callback is as described in the documentation. But with multiple active
> contexts, flush() becomes a big hammer rather than a simple emptying of
> the queues. :-)

I'm a bit conflicted about this. If we add mgd_prepare_tx() here, what's
to say that we don't need to also do this for a variety of other frames?
Like sending delBA action frames? I guess the difference would be that
we don't disassoc immediately in those case.

However, if you consider deauth/flush while you're on a different
context, then mgd_prepare_tx() would potentially not really be
sufficient either. If that forces or waits for a context switch, you
really have no guarantee that the deauth frame went out because it might
be waiting behind other frames, and there's nothing that guarantees
enough time in the context slice to actually send out all of them ...

In that sense, I think you still have to implement flush.

But I also think you see it wrongly - you don't have to force a context
switch in flush, flush can essentially be "wait for queue to be empty"
and the context switching etc. happens in the background.

mgd_prepare_tx() is, the way I see it, really more for the case where
you really have no context scheduling *at all* and have to somehow send
a frame anyway. In the case we're talking about you have regular context
scheduling, and there shouldn't be a need to add a special scheduling on
top.

johannes

