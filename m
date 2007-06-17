Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXFQPJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2007 11:09:16 -0400
Subject: Re: nl/cfg80211 scan result/event handling
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1182023372.9058.68.camel@johannes.berg>
References: <1182023372.9058.68.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 11:13:44 -0400
Message-Id: <1182093224.14209.7.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-06-16 at 21:49 +0200, Johannes Berg wrote:
> Hey,
> 
> Just a few notes as I'm thinking about these things. I probably won't be
> implementing this quickly so I'm telling you, but who knows, maybe I'll
> get around to it and then... Here's hoping for some feedback :)
> 
> Right now I'm thinking along the lines of:
> void cfg80211_key_threshold_notify(struct wireless_dev *wdev,
> 				   int txrx_count,
> 				   u8 *mac);
> 
> or
> void cfg80211_radar_notify(struct wireless_dev *wdev,
> 			   phymode, channel, ...)
> 
> and then cfg80211 is responsible for sending the appropriate nl80211
> messages or doing whatever else to notify userspace.
> 
> As for scan results, we want those broadcast as well. I was thinking
> that we have basically these choices:
>  1) drivers (stack) aggregate data
>  2) drivers (stack) call a function for each result
>  3) hybrid
> 
> I tend towards 3 because it allows both, in a fashion like this:
> 
> cfg80211_add_scan_result(struct wireless_dev *wdev,
> 			 int n_results,
> 			 struct scan_result **sr);

Just to be clear, 'struct wireless_dev' isn't tied to mac80211 at all,
right?  Cause we're going to need to use these functions in fullmac
drivers too.  And is the n_results/**sr stuff supposed to allow multiple
scan results to be added?  If that's the case, you might want to make
the function end with an 's' too, just to be clear.  "add_scan_result"
makes it sound like it should just add one scan result.

> cfg80211_scan_finished(struct wireless_dev *wdev);
> 
> and for the add_scan_result calls cfg80211 simply starts creating the
> nl80211 message and then multicasts it to those who want it
> (NL80211_GROUP_SCAN or such) on _scan_finished()
> 
> Thoughts?

Sounds fine to me; this is essentially what we've got now and I think it
works ok.  There's two cases where this would be used: (a) a triggered
scan, and (b) background scan.  Should work fine in both cases.

Dan


