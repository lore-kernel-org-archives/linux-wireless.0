Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34526 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbaBMKAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 05:00:47 -0500
Received: by mail-pb0-f46.google.com with SMTP id um1so10547632pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 02:00:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392282362.4150.4.camel@jlt4.sipsolutions.net>
References: <1392237482-18172-1-git-send-email-johannes@sipsolutions.net>
 <CA+XVXffxt5A_EOMJqMA6hHzZBaCy46ctdXL6R4k+QY_oVTAC7g@mail.gmail.com> <1392282362.4150.4.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 13 Feb 2014 12:00:30 +0200
Message-ID: <CA+XVXfc+chWOPuJ5A61+yrJDbUTqb+8-kWZG6ZG4SOONMJJi8g@mail.gmail.com> (sfid-20140213_110057_871012_38ECA6CF)
Subject: Re: [PATCH] mac80211: add NAPI support back
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 13, 2014 at 11:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2014-02-13 at 10:55 +0200, Arik Nemtsov wrote:
>
>> > +       netif_napi_add(napi_dev, napi, poll, weight);
>> > +       local->napi = napi;
>>
>> I'm not really familiar with NAPI, but shouldn't netif_napi_del be
>> called at some point? And if so, it will leave mac80211 in an
>> inconsistent state.
>
> Oops. I totally forgot about that, since we use a fake netdev it doesn't
> seem to have hurt, but it could leak memory.
>
>> Maybe if we make it part of ieee80211_register/unregister_hw the
>> scoping of local->napi will be nicer?
>
> But then we'd have to have a whole bunch of new arguments to
> _register_hw(), would we really want to go there? I don't think so -
> also in iwlwifi we'd have to go through some contortions to do that
> (rather than just call this function we'd have to store the stuff coming
> in from below.)
>
> I think we can just require that the driver calls netif_napi_del()
> itself, and for now it'd only be allowed to do it after unregister_hw(),
> but that seems reasonable, no?

It's fine. But I guess it's nicer to add a small ieee80211 wrapper for
it that also clears local->napi? not sure.

In general can we even add/remove napi when an interface is up or is
it a bad idea? if it is, maybe it should be warned/blocked? I guess
the scoping wasn't really clear for me, but maybe it is for anyone
familiar with napi.
