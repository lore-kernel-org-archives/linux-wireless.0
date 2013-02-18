Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3BRP6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 10:58:24 -0500
Message-ID: <1361203098.8555.35.camel@jlt4.sipsolutions.net> (sfid-20130218_165827_884628_E1A959DB)
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Mon, 18 Feb 2013 16:58:18 +0100
In-Reply-To: <20130218154906.GC4162@open-mesh.com>
References: <20130215171938.GA4140@pandem0nium>
	 <1361197831.8555.23.camel@jlt4.sipsolutions.net>
	 <1361197982.8555.24.camel@jlt4.sipsolutions.net>
	 <20130218144622.GA4162@open-mesh.com>
	 <1361201387.8555.32.camel@jlt4.sipsolutions.net>
	 <20130218153833.GB4162@open-mesh.com>
	 <1361202206.8555.34.camel@jlt4.sipsolutions.net>
	 <20130218154906.GC4162@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 16:49 +0100, Antonio Quartulli wrote:
> On Mon, Feb 18, 2013 at 07:43:26 -0800, Johannes Berg wrote:
> > > I did not like this approach because the sta_info struct is so big that
> > > when we want to fill the stats substruct only we will waste a lot of bytes.
> > 
> > I don't understand your point.
> > 
> > struct sta_info {
> >    ...
> >    struct stats stats;
> > };
> 
> My concern is about those "..." that we are allocating within the sta_info struct
> that we will never use for every non-peer station.
> 
> While if we used the struct below (with its own hash table), we would allocate
> only the space needed for the stats.
> 
> > 
> > struct stats_entry {
> >    struct hash/list/whatever;
> >    struct stats stats;
> > };
> > 
> 
> 
> no?
> Maybe I misunderstood your idea?

But I'm not saying that these are mutually exclusive, I'm saying both
should exist.

johannes

