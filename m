Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3BROai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 09:30:38 -0500
Message-ID: <1361197831.8555.23.camel@jlt4.sipsolutions.net> (sfid-20130218_153041_336693_8960F747)
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>, antonio@open-mesh.com,
	marek@open-mesh.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Mon, 18 Feb 2013 15:30:31 +0100
In-Reply-To: <20130215171938.GA4140@pandem0nium>
References: <20130215171938.GA4140@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 18:19 +0100, Simon Wunderlich wrote:

> Commands we would like to propose are:
>  * start collecting - this feature should not run by default to avoid bloating memory for users who
>    don't even need this
>  * stop collecting
>  * read - dumps the data for all stations
>  * read + reset - dump the data and reset information for all stations. This should also clean up stations,
>    at least those which are not connected to the BSS, to not bloat the station table.
> 
> I guess the right position to implement this is mac80211 receive path. Our intended platform
> is ath9k/ath5k, but that feature should work with any mac80211 driver. We don't care if sta_info
> structs are allocated or custom structures are used, as long as we can receive a list of stations
> which includes peer and non-peer stations, along with their statistics.
> 
> We are looking forward to your thoughts. :)

I would argue that since most of the sta_info struct is used for
operational stuff, you shouldn't use it, but have a separate struct and
maybe embed that separate struct in sta_info for its statistics.

I'd also not use the existing nl80211 station APIs since this could be
an optional feature for many things, and it will likely break existing
expectations, e.g. that all stations listed by "iw wlan0 station dump"
are clients connected to an AP interface.

It could be argued that this API then should also not even include the
connected stations when listing ones, i.e. explicitly be non-connected
stations.

johannes

