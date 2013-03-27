Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3C0TDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 15:03:13 -0400
Message-ID: <1364410962.8388.19.camel@jlt4.sipsolutions.net> (sfid-20130327_200320_337082_81859CB6)
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 27 Mar 2013 20:02:42 +0100
In-Reply-To: <87ip4cg1qg.fsf@sycorax.lbl.gov>
References: <87li993mug.fsf@sycorax.lbl.gov>
	 <1364390086.8388.7.camel@jlt4.sipsolutions.net>
	 <87r4j021ac.fsf@sycorax.lbl.gov>
	 <1364406085.8388.11.camel@jlt4.sipsolutions.net>
	 <87ip4cg1qg.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-27 at 11:02 -0700, Alex Romosan wrote:

> > Humm, yes, that makes more sense. That commit fixed a bug in another
> > commit though, I'm surprised you ended up there?! Curious ... I'll
> > check over the commit and see if I can find anything wrong with it.
> 
> i just reverted that commit on top of 3.9-rc4 and now i can reconnect
> when resuming from suspend. so whatever bug that commit fixed, it also
> introduced a new one.

Hmm, actually ... I suspect this didn't introduce a bug but rather
unmasked one in iwlwifi/mac80211 interaction.

Are you sure this only happens after suspend/resume? It seems like it
would always happen? At least if there was a beacon in the scan results
already, which should probably always be the case...

Can you enable iwlwifi debugging and set the iwlwifi module parameter
debug=0x40000000 ? I have a feeling you'll see something like
"PASSIVE_NO_RX" in there.

johannes

