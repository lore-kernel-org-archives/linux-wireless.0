Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42917 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0KDFeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 01:34:17 -0400
Received: by ywc21 with SMTP id 21so1076295ywc.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 22:34:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288836908.4083.2.camel@jlt3.sipsolutions.net>
References: <1288821053-19013-1-git-send-email-arik@wizery.com>
 <1288821053-19013-4-git-send-email-arik@wizery.com> <1288836908.4083.2.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 4 Nov 2010 07:34:01 +0200
Message-ID: <AANLkTimXwopqOUcBWxwAmEH1tJbtLQisW7dmm+XDWHPe@mail.gmail.com>
Subject: Re: [PATCH 3/4] mac80211: don't fragment packets when
 HW-fragmentation is on
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 04:15, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed, 2010-11-03 at 23:50 +0200, Arik Nemtsov wrote:
> > If the driver supports hardware TX fragmentation, don't fragment
> > packets in the stack.
>
> I'm not sure why you have three patches? Seems like it could all be a
> single mac80211 patch.

Sure. I'll send a v2 with the mac80211 patches bundled into a single one.

>
> > @@ -1181,8 +1183,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
> >       /*
> >        * Set this flag (used below to indicate "automatic fragmentation"),
> >        * it will be cleared/left by radiotap as desired.
> > +      * Only valid when fragmentation is done by the stack.
> >        */
> > -     tx->flags |= IEEE80211_TX_FRAGMENTED;
> > +     if (!(local->hw.flags & IEEE80211_HW_TX_FRAGMENTATION))
> > +             tx->flags |= IEEE80211_TX_FRAGMENTED;
>
> Do we really need the hw flag? Couldn't we go off the callback, like we
> used to? I'm not really sure which one would perform better though, I
> guess the flag might ...

I think the flag may be less confusing for new driver writers.
Someone can implement the callback as a no-op and have a bug in his
code as a result.

Regards,
Arik
