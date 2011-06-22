Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43919 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab1FVUQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 16:16:32 -0400
Date: Wed, 22 Jun 2011 16:04:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix rx->key NULL dereference during mic failure
Message-ID: <20110622200419.GD13533@tuxdriver.com> (sfid-20110622_221635_405345_A4E310DC)
References: <1308422749-16939-1-git-send-email-arik@wizery.com>
 <87ips11tc3.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ips11tc3.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 19, 2011 at 11:04:12PM +0300, Kalle Valo wrote:
> Arik Nemtsov <arik@wizery.com> writes:
> 
> > Sometimes when reporting a MIC failure rx->key may be unset. This
> > code path is hit when receiving a packet meant for a multicast
> > address, and decryption is performed in HW.
> >
> > Fortunately, the failing key_idx is not used for anything up to
> > (and including) usermode, so we allow ourselves to set a bogus one
> > when a key cannot be retrieved.
> 
> [...]
> 
> > -	mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
> > +	mac80211_ev_michael_mic_failure(rx->sdata,
> > +					rx->key ? rx->key->conf.keyidx : -1,
> >  					(void *) skb->data, NULL, GFP_ATOMIC);
> 
> In special cases like this a comment in the code would be nice.

Repost with a comment, as Kalle requested?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
