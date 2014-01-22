Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaAVS2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 13:28:55 -0500
Message-ID: <1390415331.4334.37.camel@jlt4.sipsolutions.net> (sfid-20140122_192859_724744_1711838A)
Subject: Re: [PATCH] nl80211: check channel switch validity better
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 19:28:51 +0100
In-Reply-To: <CAHmEv86saxzZzy-qS6C_6k48EXFh2GVb8gVEcwJcBKQtj1Cv7Q@mail.gmail.com> (sfid-20140122_190244_490139_0BA936C0)
References: <1390382185.4334.19.camel@jlt4.sipsolutions.net>
	 <CAHmEv86saxzZzy-qS6C_6k48EXFh2GVb8gVEcwJcBKQtj1Cv7Q@mail.gmail.com>
	 (sfid-20140122_190244_490139_0BA936C0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 10:02 -0800, Thomas Pedersen wrote:

> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -5799,10 +5799,15 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)

> >         case NL80211_IFTYPE_MESH_POINT:
> > +               if (!wdev->mesh_id_len)
> > +                       return -ENOTCONN;
> 
> Hmmm. I'm pretty sure there are some users which set the channel prior
> to mesh join. This would break that and only allow sending the channel
> with mesh join?

I don't think channel_switch() is invoked for that? That's done only for
run-time switching of the channel with CSA etc.

johannes

