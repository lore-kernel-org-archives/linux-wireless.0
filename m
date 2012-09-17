Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab2IQOxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 10:53:53 -0400
Message-ID: <1347893667.4975.1.camel@jlt4.sipsolutions.net> (sfid-20120917_165357_323971_2A50A1B9)
Subject: Re: [PATCH 01/10] mac80211: introduce channel context skeleton code
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>,
	Arend van Spriel <arend@broadcom.com>
Date: Mon, 17 Sep 2012 16:54:27 +0200
In-Reply-To: <CAB3XZEdAX8=BU5QQaQpS=OF-5XXDH=k3rO7C2z2F+sZpaCNK1Q@mail.gmail.com> (sfid-20120915_234241_109266_3C0AE5C7)
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
	 <1347626233-21916-2-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEdAX8=BU5QQaQpS=OF-5XXDH=k3rO7C2z2F+sZpaCNK1Q@mail.gmail.com>
	 (sfid-20120915_234241_109266_3C0AE5C7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-16 at 00:42 +0300, Eliad Peller wrote:

> > +       ctx = ieee80211_find_chanctx(local, channel, channel_type, mode);
> since you might use an existing ctx here...
> 
> > +       if (!ctx)
> > +               ctx = ieee80211_new_chanctx(local, channel, channel_type, mode);
> > +       if (IS_ERR(ctx)) {
> > +               ret = PTR_ERR(ctx);
> > +               goto out;
> > +       }
> > +
> > +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> > +       if (ret) {
> > +               ieee80211_free_chanctx(local, ctx);
> i think you should check ctx->refcount before freeing it.

Oops, good catch! I think I'll just add a test here rather than Arend's
suggestion because nothing it's called _free_chanctx(), and it's already
very indirectly used via the vif. Not that it's a bad suggestion, it
just doesn't seem to fit with the code as it is now.

Thanks guys!

johannes

