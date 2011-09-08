Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1IHGtT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 02:49:19 -0400
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Johannes Berg <johannes@sipsolutions.net>
To: victorg@ti.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4E686125.5050208@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>
	 <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Sep 2011 08:49:16 +0200
Message-ID: <1315464556.3948.0.camel@jlt3.sipsolutions.net> (sfid-20110908_084922_586552_F12B3D01)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-08 at 09:31 +0300, Victor Goldenshtein wrote:
> On 07/09/2011 12:26, Johannes Berg wrote:
> >> The intermediate scan event is not HW dependent, so there is no need to
> >> advertise it..
> >
> > Not with mac80211 drivers, but with cfg80211 drivers?
> >
> > johannes
> >
> 
> You're right, cfg80211 drivers will not support it. As I couldn't find a 
> way to know whether it mac or cfg based driver, I can add also 
> IEEE80211_HW_SUPPORTS_IM_RESULT" flag (as with cancel_scan) and then 
> will advertise the nl80211 command if it set, is it OK?

I'd prefer not advertising the command, since so far we've only
advertised supported commands as supported -- a new nl80211 flag would
be nicer I think.

Come to think of it, maybe it's time to bundle capability flags
together. We seem to acquire new ones all the time, so maybe we should
have a HW_CAPABILITY nl80211 attribute that can simply grow as
needed ...

johannes

