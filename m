Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:14127 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYAFXOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 18:14:04 -0500
Received: by wa-out-1112.google.com with SMTP id v27so12118250wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 15:14:04 -0800 (PST)
Message-ID: <1ba2fa240801061514m9c58b15g1ed1455e807a28b6@mail.gmail.com> (sfid-20080106_231412_417901_9E5169AD)
Date: Mon, 7 Jan 2008 01:14:04 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: Add radio led trigger
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801061925.44484.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200801061410.12862.IvDoorn@gmail.com>
	 <1ba2fa240801061019w2cc28082s9084c00a5d14f810@mail.gmail.com>
	 <200801061925.44484.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 6, 2008 8:25 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>
> On Sunday 06 January 2008, Tomas Winkler wrote:
> > On Jan 6, 2008 3:10 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > Some devices have a seperate LED which indicates if the radio is
> > > enabled or not. This adds a LED trigger to mac80211 where drivers
> > > can hook into when they are interested in radio status changes.
> > >
> > >
> > I wonder how this go together with RF KILL led?
>
> They would be competing I fear, but not all devices have a rfkill button,
> which makes the mac80211 radio led trigger more usefull I think.
>
What inquires me is  in the following snippet is  would you lit the
led if even if rfkill HW switch is on?
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -219,6 +219,7 @@ static int ieee80211_open(struct net_device *dev)
               if (res)
                       return res;
               ieee80211_hw_config(local);
+               ieee80211_led_radio(local, 1);
       }


Thanks
Tomas
> Ivo
>
