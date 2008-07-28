Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38797 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbYG1OBC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 10:01:02 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Luis Carlos Cobo <luisca@cozybit.com>
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
Date: Mon, 28 Jul 2008 16:00:38 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <48763814.27052c0a.1794.2095@mx.google.com> <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost>
In-Reply-To: <1217253397.6364.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807281600.39103.mb@bu3sch.de> (sfid-20080728_160105_327795_D749D980)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 July 2008 15:56:37 Luis Carlos Cobo wrote:
> On Mon, 2008-07-28 at 15:44 +0200, Michael Buesch wrote:
> > Well, I think that really is pretty weird and it is confusing to the
> > user to see that pseudo random MAC that changes suddenly when the device is
> > initialized. For the human user (so everybody but me), it would be better
> > to have the MAC all-zeros until the firmware loaded. So it would be obvious
> > that the MAC is not set, yet. I think userspace
> 
> The problem is that all-zeroes is actually a valid mac address, owned by
> Xerox (http://standards.ieee.org/regauth/oui/oui.txt) Not that it will
> probably cause us any problem, but a multicast address is afaik an
> invalid mac for a device. Should we go for 01:allzeros?

If that's really a problem, yes. 01:00:00:00:00:00 is still better
than a pseudo random MAC, IMO. It's immediately obvious to the user
that the MAC currently is not set.

-- 
Greetings Michael.
