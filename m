Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaCKNQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 09:16:13 -0400
Message-ID: <1394543770.30155.4.camel@jlt4.sipsolutions.net> (sfid-20140311_141616_668175_92173D8D)
Subject: Re: [PATCH 3/3] mac80211: compute chanctx refcount dynamically
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 11 Mar 2014 15:16:10 +0200
In-Reply-To: <CA+BoTQkke050EMs0Nnz3O3XM6U2uRRVrxffVdwKJrWua+iapFw@mail.gmail.com> (sfid-20140311_084612_507774_354C0D0C)
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	 <1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
	 <CA+BoTQkke050EMs0Nnz3O3XM6U2uRRVrxffVdwKJrWua+iapFw@mail.gmail.com>
	 (sfid-20140311_084612_507774_354C0D0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 08:46 +0100, Michal Kazior wrote:

> Self-NACK.

Heh.

> I totally missed how ieee80211_remove_interfaces() works. It removes
> all interfaces from the list in one go before each is actually
> stopped. This means refcount computes 0. IOW If you unload a driver
> with multiple interfaces running you get a nice general protection
> fault (multiple ieee80211_free_chanctx calls).

Ok, that seems like a problem :)

> I'm planning on adding `struct list_head` to sdata and chanctx to be
> able to iterate over assigned (and reserved, in the future) chanctx.
> What do you think? Do you have other ideas?

I guess that seems reasonable - not sure why you'd want the reserved
one? Some of the maintenance there might be tricky?

johannes

