Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47613 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3ACJyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 04:54:22 -0500
Message-ID: <1357206883.9741.0.camel@jlt4.sipsolutions.net> (sfid-20130103_105429_342076_E16CF8B0)
Subject: Re: [PATCH V4 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 03 Jan 2013 10:54:43 +0100
In-Reply-To: <50E51B7F.7000607@qca.qualcomm.com>
References: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>
	   <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com>
	   <1356694308.9922.1.camel@jlt4.sipsolutions.net>
	   (sfid-20121228_123135_896103_E2B28BED) <1356699373.9922.2.camel@jlt4.sipsolutions.net>
	  <50E11F43.4010006@qca.qualcomm.com>
	 <1357131412.9839.17.camel@jlt4.sipsolutions.net>
	 <50E51B7F.7000607@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-03 at 11:17 +0530, Vasanthakumar Thiagarajan wrote:

> > Basically we would have two modes:
> >   * whitelist
> >   * blacklist
> >
> > (each might or might not be supported by the driver)
> >
> > When a station is on the blacklist it's ignored. When it's on the
> > whitelist it's allowed. When it's on neither, but a list is configured,
> > an event might be sent. When there's a black-&  whitelist, the blacklist
> > is this an optimisation to suppress the event, so we don't need a third
> > mode "black- and whitelist supported".
> 
> Thanks!, I was really confused with this optimization part.
> If I get it correctly, there needs to be a mechanism for
> driver to advertise its dual list capability to user space.

No, because that's subsumed by just the whitelist -- the blacklist in
addition to the whitelist is just an optimisation which we can always
pass to the driver but it may ignore.

johannes

