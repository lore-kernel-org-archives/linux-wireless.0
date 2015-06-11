Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35175 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbbFKJqp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 05:46:45 -0400
Message-ID: <1434016002.1915.7.camel@sipsolutions.net> (sfid-20150611_114648_121723_4E771214)
Subject: Re: Exposing enum ieee80211_channel_flags to user
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 11 Jun 2015 11:46:42 +0200
In-Reply-To: <1434015922.1915.6.camel@sipsolutions.net> (sfid-20150611_114527_922690_7AF6C2D9)
References: <CACna6rwHXzGTZ+NS9PpZENJATVzRzm1Wkija0_CrveMoM05d5g@mail.gmail.com>
	 (sfid-20150611_113544_857208_070F0480) <1434015922.1915.6.camel@sipsolutions.net>
	 (sfid-20150611_114527_922690_7AF6C2D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 11:45 +0200, Johannes Berg wrote:
> On Thu, 2015-06-11 at 11:35 +0200, Rafał Miłecki wrote:
> 
> > iw also wasn't helpful:
> > Frequencies:
> >         * 5180 MHz [36] (30.0 dBm)
> >         * 5200 MHz [40] (30.0 dBm)
> >         * 5220 MHz [44] (30.0 dBm)
> >         * 5240 MHz [48] (30.0 dBm)
> > 
> > After some in-kernel debugging (nl80211_set_wiphy,
> > cfg80211_chandef_usable, cfg80211_secondary_chans_ok) I finally
> > realized it was because of:
> > IEEE80211_CHAN_NO_80MHZ
> > 
> > Do you have any idea how we could handle such cases nicely? To let
> > user find out what's going on (wrong)?
> > 
> > Should "iw" be extended to print flag names? Or should hostapd check
> > for channels in some smarter way? Any other ideas?
> 
> We already have the flags exposed to iw, it's just not printing them.
> There was a patch to print them, but it wasn't complete, and the
> submitter kinda went away. You can see the discussion here:
> 
> http://mid.gmane.org/1425452686-28196-1-git-send-email-arnagara@qti.qualcomm.com

Upon rereading, I think my preference would be to remove much of the
channel list information and add a separate iw command.

johannes

