Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20764 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbZBDXTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:19:21 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:19:21 -0800
Date: Wed, 4 Feb 2009 15:18:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kishore Ramachandran <kishore@winlab.rutgers.edu>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Setting 11n MCS TX bitrate
Message-ID: <20090204231840.GL5581@tesla> (sfid-20090205_001926_471424_1B04BCBF)
References: <604f6e750902041408k7335234bs565e8fe6868f0f54@mail.gmail.com> <20090204222203.GJ5581@tesla> <604f6e750902041451x340e0b14x4561125c1f7163c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <604f6e750902041451x340e0b14x4561125c1f7163c6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 02:51:13PM -0800, Kishore Ramachandran wrote:
> "Not yet, but please feel free to give a shot at hacking it up. It would require
> a new cfg80211 command but keep in mind the way I believe we want this is to
> use the 802.11 MLME SAP interface for this."
> 
> I thought as much to start looking at the iw source but thought would check with you guys first. Would the implementation be similar to the "set channel" and/or the "set frequency" commands? Is there is another function using the 802.11 MLME SAP interface that I can use as a guideline?

Well in general I was talking about IEEE-802.11 section 10.3 stuff.
In cfg80211/nl80211 we don't want to allow things like "set essid"
as iwconfig has, instead we want to break things down a bit more,
which can really help debugging. The MLME SAP already has some
decent layout of commands/responses but after a quick glance
I do not see anything for setting a static rate. May want to review
that a bit before implementing set rate though. Just remember
post early and review early. If you have an idea of how you want
to do it let us know to get feedback.

  Luis
