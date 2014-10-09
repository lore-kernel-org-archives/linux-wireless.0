Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38814 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaJIKWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 06:22:19 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21558.25050.964527.31471@gargle.gargle.HOWL> (sfid-20141009_122222_707936_864EF523)
Date: Thu, 9 Oct 2014 15:52:18 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
In-Reply-To: <1412847604.1828.38.camel@jlt4.sipsolutions.net>
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
	<1412847604.1828.38.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I'm a bit conflicted about this. If we add mgd_prepare_tx() here, what's
> to say that we don't need to also do this for a variety of other frames?
> Like sending delBA action frames? I guess the difference would be that
> we don't disassoc immediately in those case.

Deauth was the main problem with ath9k, I didn't check delba or other
mgmt frames.

> However, if you consider deauth/flush while you're on a different
> context, then mgd_prepare_tx() would potentially not really be
> sufficient either. If that forces or waits for a context switch, you
> really have no guarantee that the deauth frame went out because it might
> be waiting behind other frames, and there's nothing that guarantees
> enough time in the context slice to actually send out all of them ...

It works with ath9k now because all non-data frames are sent immediately,
without being added to the internal SW queue.

> In that sense, I think you still have to implement flush.

Yes, I think we might have to. :)

> But I also think you see it wrongly - you don't have to force a context
> switch in flush, flush can essentially be "wait for queue to be empty"
> and the context switching etc. happens in the background.

flush() implementation in ath9k currently waits for the HW queues
and the SW queues assigned to the current channel context to become empty.

A context switch can be forced to expedite the process of draining
the queues in all contexts and we probably have to send out a new
NoA if a GO is active to accommodate the longer absence period
when flushing. The fact that, in ath9k,  the same flush routine is called
from the main context scheduler and the mac80211 callback makes things
hairy. :)

But, I agree (and Emmanuel was right), flush() in ath9k needs
to be reworked. Please drop this patch, I'll carry it internally until
flush is fixed.

Sujith
