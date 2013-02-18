Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3BRP35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 10:29:57 -0500
Message-ID: <1361201387.8555.32.camel@jlt4.sipsolutions.net> (sfid-20130218_163000_275057_2DA4E32E)
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Mon, 18 Feb 2013 16:29:47 +0100
In-Reply-To: <20130218144622.GA4162@open-mesh.com>
References: <20130215171938.GA4140@pandem0nium>
	 <1361197831.8555.23.camel@jlt4.sipsolutions.net>
	 <1361197982.8555.24.camel@jlt4.sipsolutions.net>
	 <20130218144622.GA4162@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 15:46 +0100, Antonio Quartulli wrote:

> In my current implementation I created a "twin hash-table". It contains
> statistics for *all* the stations (peer and non-peer).
> 
> I think that instead of embedding this new struct (let's call it sta_stats) into
> the sta_info one, it would be easier to let them be independent (this is why I
> created the twin hash) and then create
> a pointer from the sta_info to the related sta_stats.

I don't really see value in that, it would only make the implementation
less efficient, because either you follow another pointer (sta->stats)
or you have to look in the other hash table. That's why I prefer
embedding it, we have to do the station hash table lookup anyway.

> For the API I think we should create a new nl80211 command.
> If we simply add a
> flag to the normal "station dump" command, we would not have all the attributes
> to print (keep in mind station dump prints attributes that are in sta_info and
> that are not in sta_stats).

station dump can just print all attributes that exist, some stations
would have more/different attributes than other stations. But I don't
really think it makes a big difference either way, reusing it would be
fine if the default is to not include the stats-only entries.

johannes

