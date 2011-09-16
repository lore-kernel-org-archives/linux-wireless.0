Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm6-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.234]:34078 "HELO
	nm6-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751037Ab1IPL14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 07:27:56 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: don't allow zero mac bssid to be configured
Date: Fri, 16 Sep 2011 13:27:50 +0200
Cc: linux-wireless@vger.kernel.org
References: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de> <201109160514.16603.lindner_marek@yahoo.de> <1316153956.4130.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316153956.4130.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201109161327.50915.lindner_marek@yahoo.de> (sfid-20110916_132759_086219_F5D3869D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, September 16, 2011 08:19:16 Johannes Berg wrote:
> On Fri, 2011-09-16 at 05:14 +0200, Marek Lindner wrote:
> > On Thursday, September 15, 2011 18:21:38 Johannes Berg wrote:
> > > How is this related to configuration?
> > 
> > These 'sdata->u.ibss' values are initialized by ieee80211_ibss_join()
> > which is called when a user invokes "iw dev wlan0 ibss join".
> 
> Right. So that means you shouldn't be rejecting the configuration when
> actually using it. You should be rejecting it when it's actually set.

I'd like to remind you that it was not me who designed the original check (my 
patch does not add anything new). If you are looking for somebody to beautify 
your code you'll have to look somewhere else.


> It should be in cfg80211, so NACK for this patch.

As I said: Feel free to propose an alternative patch. I certainly won't.


> Also, this patch is wrong -- at that point, checking for zero address serves
> a difference purpose I think, it means more something along the lines of
> "did we previously find an IBSS".

Can't agree here. This check was conceived to hinder a fixed-bssid 
configuration of 00:00:00:00:00:00.

Cheers,
Marek
