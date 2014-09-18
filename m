Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43004 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbaIRDEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 23:04:45 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21530.19430.782437.984290@gargle.gargle.HOWL> (sfid-20140918_050448_669426_D81F094E)
Date: Thu, 18 Sep 2014 08:35:10 +0530
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
In-Reply-To: <CANUX_P3hdFeCPmqHCdP8JKwqvUUnjgp3SNy1GQDrQd0bG+WKng@mail.gmail.com>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
	<21529.8110.26388.664223@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com>
	<21529.9155.323515.987489@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com>
	<21529.10109.308613.563543@gargle.gargle.HOWL>
	<CANUX_P3hdFeCPmqHCdP8JKwqvUUnjgp3SNy1GQDrQd0bG+WKng@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach wrote:
> mac80211 will not wait until the context switch happen specifically,
> but if you can wait
> in the driver in the flush() callback until the deauth is being sent -
> whatever you need to
> happen to have that done, context switch, TX queues to move etc... -
> then you should be good?
> IIRC, mac80211 sends the deauth to the driver and then calls flush() -
> only then, it'll remove the
> contexts.
> 
> So I guess that we agree - the solution for you I guess is to wait
> until you have context switch
> in the flush() callback.

I don't think trying to switch channel contexts in the flush() callback
is a good idea. We would be changing the meaning of the callback if
we do that. Moreover flush() is called from many other places too, like the
PS code.

It seems appropriate to instruct a driver to make the necessary
preparations before sending a deauth frame. Do you see any problems
if mgd_prepare_tx() is called before initiating deauth ?

Sujith

