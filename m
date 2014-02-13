Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaBMJGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 04:06:10 -0500
Message-ID: <1392282362.4150.4.camel@jlt4.sipsolutions.net> (sfid-20140213_100632_375072_45260FEB)
Subject: Re: [PATCH] mac80211: add NAPI support back
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 13 Feb 2014 10:06:02 +0100
In-Reply-To: <CA+XVXffxt5A_EOMJqMA6hHzZBaCy46ctdXL6R4k+QY_oVTAC7g@mail.gmail.com> (sfid-20140213_095534_238287_C5B5B703)
References: <1392237482-18172-1-git-send-email-johannes@sipsolutions.net>
	 <CA+XVXffxt5A_EOMJqMA6hHzZBaCy46ctdXL6R4k+QY_oVTAC7g@mail.gmail.com>
	 (sfid-20140213_095534_238287_C5B5B703)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-13 at 10:55 +0200, Arik Nemtsov wrote:

> > +       netif_napi_add(napi_dev, napi, poll, weight);
> > +       local->napi = napi;
> 
> I'm not really familiar with NAPI, but shouldn't netif_napi_del be
> called at some point? And if so, it will leave mac80211 in an
> inconsistent state.

Oops. I totally forgot about that, since we use a fake netdev it doesn't
seem to have hurt, but it could leak memory.

> Maybe if we make it part of ieee80211_register/unregister_hw the
> scoping of local->napi will be nicer?

But then we'd have to have a whole bunch of new arguments to
_register_hw(), would we really want to go there? I don't think so -
also in iwlwifi we'd have to go through some contortions to do that
(rather than just call this function we'd have to store the stuff coming
in from below.)

I think we can just require that the driver calls netif_napi_del()
itself, and for now it'd only be allowed to do it after unregister_hw(),
but that seems reasonable, no?

johannes

