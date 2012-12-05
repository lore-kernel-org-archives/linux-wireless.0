Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2LEJNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 04:13:18 -0500
Message-ID: <1354698823.9972.6.camel@jlt4.sipsolutions.net> (sfid-20121205_101324_327776_A01BFF75)
Subject: Re: [RFC v2 14/18] regulatory: clarify locking rules and assertions
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Dec 2012 10:13:43 +0100
In-Reply-To: <20121204190730.GC29880@localhost> (sfid-20121204_200810_702954_7565575D)
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
	 <1354632540-21207-15-git-send-email-johannes@sipsolutions.net>
	 <20121204190730.GC29880@localhost> (sfid-20121204_200810_702954_7565575D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-04 at 14:07 -0500, Bob Copeland wrote:
> On Tue, Dec 04, 2012 at 03:48:56PM +0100, Johannes Berg wrote:
> > Many places that currently check that cfg80211_
> > The function needs to hold the cfg80211_mutex as
> > it uses the global cfg80211_regdomain variable, so
> > add the lock assertion to it and fix one of the
> > callers that doesn't hold that mutex.
> 
> Something missing in the description there?

Completely wrong ... looks like I got interrupted while writing it or
something ...

Here's what I changed it to now:

    Many places that currently check that cfg80211_mutex
    is held don't actually use any data protected by it.
    The functions that need to hold the cfg80211_mutex
    are the ones using the cfg80211_regdomain variable,
    so add the lock assertion to those and clarify this
    in the comments.
    
    The reason for this is that nl80211 uses the regdom
    without being able to hold reg_mutex.


johannes

