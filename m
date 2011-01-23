Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1AWJXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 04:23:13 -0500
Subject: Re: [PATCH 1/3] nl80211: allow passing SSID in nl80211_set_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTinZwZbnzbT2UvOg7PgUsCRAR-+Hx+Je0zgoRYHd@mail.gmail.com>
References: <1295555306-20005-1-git-send-email-arik@wizery.com>
	 <1295556734.3693.53.camel@jlt3.sipsolutions.net>
	 <AANLkTinZwZbnzbT2UvOg7PgUsCRAR-+Hx+Je0zgoRYHd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 10:23:10 +0100
Message-ID: <1295774590.3639.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-21 at 20:01 +0200, Arik Nemtsov wrote:
> On Thu, Jan 20, 2011 at 22:52, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > As I also just commented on the corresponding hostapd patch, I'm not
> > sure this is sufficient. If this is necessary for probe response
> > offloading, I'm tempted to say that we should be honest about it and let
> > userspace determine the entire probe response (which will contain the
> > correct SSID) since it can be different from the beacon which presumably
> > you're now using to generate probe responses.
> >
> 
> Well the SSID is still needed in its pure form (i.e. not bundled up
> inside some skb).

Technically you can easily parse it out but I agree.

> You're talking about adding another set_probe_resp() callback from
> hostapd. That makes sense. I'll look into it.
> 
> In the meanwhile are there any comments for this portion?

Not really, except that I think that by itself it's insufficient. I
might add that depending on how the probe response thing works out in
the supplicant, it might make sense to add a capability flag that makes
the driver request this behaviour, since it would also disable
multi-SSID operation on a single BSSID (if that gets ever implemented)
for example since only a single probe request can be transmitted.

Also, P2P GO might be quite tricky with this, but I'm not exactly sure.

johannes

