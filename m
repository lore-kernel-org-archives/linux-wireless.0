Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2KSNrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 08:47:10 -0500
Message-ID: <1353332858.18299.0.camel@jlt4.sipsolutions.net> (sfid-20121119_144725_220460_13330C9C)
Subject: Re: [PATCH] mac80211: check add_chanctx callback before use in
 ieee80211_reconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Mon, 19 Nov 2012 14:47:38 +0100
In-Reply-To: <CAB3XZEcv9kV1TG_CfeK7TeNu+kdhb9TcfsFff9jn7aVLCcz+YA@mail.gmail.com> (sfid-20121119_143634_279923_CC11B10C)
References: <1353322865-7500-1-git-send-email-arend@broadcom.com>
	 <CAB3XZEcv9kV1TG_CfeK7TeNu+kdhb9TcfsFff9jn7aVLCcz+YA@mail.gmail.com>
	 (sfid-20121119_143634_279923_CC11B10C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 15:36 +0200, Eliad Peller wrote:
> hi Arend,
> 
> On Mon, Nov 19, 2012 at 1:01 PM, Arend van Spriel <arend@broadcom.com> wrote:
> > During testing our mac80211 driver a fatal error occurred which was
> > signalled to mac80211. Upon performing the reconfiguration of the
> > device a WARN_ON was triggered. This warning checked the return value
> > of drv_add_chanctx(). However, this returns -EOPNOTSUPP when the
> > driver does not provide the callback. As the callback is optional
> > better check it is defined before calling drv_add_chanctx().
> >
> > Signed-off-by: Arend van Spriel <arend@broadcom.com>
> > ---
> 
> > +       if (local->ops->add_chanctx) {
> > +               mutex_lock(&local->chanctx_mtx);
> > +               list_for_each_entry(ctx, &local->chanctx_list, list)
> > +                       WARN_ON(drv_add_chanctx(local, ctx));
> > +               mutex_unlock(&local->chanctx_mtx);
> > +       }
> 
> i think checking local->use_chanctx is a bit cleaner.

Makes sense, I'll apply with this change.

johannes

