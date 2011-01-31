Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1AaKxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 05:53:15 -0500
Subject: Re: [BUG] iwlwifi need to correct channels info
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, bruno randolf <br1@einfach.org>
In-Reply-To: <20110131093840.GA20613@redhat.com>
References: <20110128154100.GB2452@redhat.com>
	 <1296237969.5118.12.camel@jlt3.sipsolutions.net>
	 <20110131093840.GA20613@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 11:53:08 +0100
Message-ID: <1296471188.3812.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 10:38 +0100, Stanislaw Gruszka wrote:

> > No, the above commit is buggy -- it assumes sband->band is set when it
> > isn't. 
> But it should be, no? It seems we initialize it nowhere, but it's
> used in iwl-*-rs.c

Yes, but it'll be set by cfg80211 when you register the wiphy as well.
This code is just special because it's before registration.

> BTW:
> Is iwl_eeprom_band_2[] array correct? It have 7, 8, 11, 12 channels entries
> on 5GHz.

Huh, not sure.

> Can we get rid of /* FIXME: might be removed if scan is OK */ ?

Not sure either.

> > Does this fix it?
> 
> I tested on 3945, it fix freq=0 on messages. But what about something
> slightly different? Use ch->band already set in iwl_init_channel_map()
> and initialize sband->band.

Sure, looks fine too.

johannes

