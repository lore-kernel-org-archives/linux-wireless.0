Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0HaG5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 02:57:08 -0400
Subject: Re: What extra functionality does a driver need to support for
 access point functionality?
From: Johannes Berg <johannes@sipsolutions.net>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=R88jHqCkajD4kW=BGStCskBGMLvL1rNErC_71@mail.gmail.com>
References: <AANLkTi=R88jHqCkajD4kW=BGStCskBGMLvL1rNErC_71@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 08:58:49 +0200
Message-ID: <1283237929.3733.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-30 at 16:40 -0400, Charles Gordon wrote:

> I'm trying to understand what additional features are needed in
> drivers to support AP mode.  I took a look at the mac80211
> documentation on the web site and all it says is that:

[...]

> This makes it seem like the driver doesn't have to do that much more
> than it does normally.  Somehow, I don't believe that's it can be that
> easy.  What else does the driver need to do to support something like
> hostapd?

That really is all it needs to do, assuming it is a mac80211 based
driver. There are some minor details like not filtering the frames,
obviously, but those aren't usually a problem. The most common issue is
not being able to implement multicast-after-DTIM correctly.

johannes

