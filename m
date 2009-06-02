Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38928 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbZFBUIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:08:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT 3/3] b43/legacy: port to cfg80211 rfkill
Date: Tue, 2 Jun 2009 22:08:46 +0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20090602111027.460530075@sipsolutions.net> <200906021641.11019.mb@bu3sch.de> <1243973079.6461.3.camel@johannes.local>
In-Reply-To: <1243973079.6461.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906022208.46288.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 June 2009 22:04:39 Johannes Berg wrote:
> On Tue, 2009-06-02 at 16:41 +0200, Michael Buesch wrote:
> 
> > > --- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2009-06-02 12:53:36.000000000 +0200
> > > +++ wireless-testing/drivers/net/wireless/b43/Kconfig	2009-06-02 12:56:11.000000000 +0200
> > > @@ -98,13 +98,6 @@ config B43_LEDS
> > >  	depends on B43 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43)
> > >  	default y
> > >  
> > > -# This config option automatically enables b43 RFKILL support,
> > > -# if it's possible.
> > > -config B43_RFKILL
> > > -	bool
> > > -	depends on B43 && (RFKILL = y || RFKILL = B43)
> > > -	default y
> > 
> > Don't you need to add a new "depends on" to "B43", if you remove this?
> > Or is rfkill always compiled in if wireless is present?
> 
> Well, rfkill isn't always present but the APIs are always present.

Ok, makes sense, so I guess you rewrote the API. ;)

I'll ack this, if somebody with rfkill device tests it.
Unfortunately I don't have such a device.

-- 
Greetings, Michael.
