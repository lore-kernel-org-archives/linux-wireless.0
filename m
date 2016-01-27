Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48628 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729AbcA0OgG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 09:36:06 -0500
Message-ID: <1453905364.2351.9.camel@sipsolutions.net> (sfid-20160127_153611_393815_E2216BF7)
Subject: Re: [PATCH v2] mac80211: expose txq queue depth and size to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jan 2016 15:36:04 +0100
In-Reply-To: <CA+BoTQn0AhDg628XF2+0gBBPM+8krTnTdeE6FiEBz-ZT+0k6Kg@mail.gmail.com> (sfid-20160127_153354_704081_0BA69A80)
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
	 <1453904772-25289-1-git-send-email-michal.kazior@tieto.com>
	 <1453904819.2351.7.camel@sipsolutions.net>
	 <CA+BoTQn0AhDg628XF2+0gBBPM+8krTnTdeE6FiEBz-ZT+0k6Kg@mail.gmail.com>
	 (sfid-20160127_153354_704081_0BA69A80)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 15:33 +0100, Michal Kazior wrote:
> On 27 January 2016 at 15:26, Johannes Berg <johannes@sipsolutions.net
> > wrote:
> > On Wed, 2016-01-27 at 15:26 +0100, Michal Kazior wrote:
> > > 
> > > @@ -1294,6 +1298,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct
> > > ieee80211_hw *hw,
> > >       if (!skb)
> > >               goto out;
> > > 
> > > +     txqi->byte_cnt -= skb->len;
> > > +
> > >       atomic_dec(&sdata->txqs_len[ac]);
> > > 
> > This *looks* a bit worrying - you have an atomic dec for the # of
> > packets and a non-atomic one for the bytes.
> > 
> > You probably thought about it and I guess it's fine, but can you
> > explain it?
> 
> The atomic was used because it accesses per-vif counters. You can't
> use txqi->queue.lock for that.
> 

Ah. I completely missed that distinction, thanks.

johannes
