Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:41021 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbYAGSoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 13:44:24 -0500
Received: by fk-out-0910.google.com with SMTP id z23so8659518fkz.5
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2008 10:44:22 -0800 (PST)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] mac80211: Add radio led trigger
Date: Mon, 7 Jan 2008 19:44:04 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200801061410.12862.IvDoorn@gmail.com> <200801061925.44484.IvDoorn@gmail.com> <1ba2fa240801061514m9c58b15g1ed1455e807a28b6@mail.gmail.com>
In-Reply-To: <1ba2fa240801061514m9c58b15g1ed1455e807a28b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801071944.05063.IvDoorn@gmail.com> (sfid-20080107_184431_851609_9A25911D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 January 2008, Tomas Winkler wrote:
> On Jan 6, 2008 8:25 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> >
> > On Sunday 06 January 2008, Tomas Winkler wrote:
> > > On Jan 6, 2008 3:10 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > > Some devices have a seperate LED which indicates if the radio is
> > > > enabled or not. This adds a LED trigger to mac80211 where drivers
> > > > can hook into when they are interested in radio status changes.
> > > >
> > > >
> > > I wonder how this go together with RF KILL led?
> >
> > They would be competing I fear, but not all devices have a rfkill button,
> > which makes the mac80211 radio led trigger more usefull I think.
> >
> What inquires me is  in the following snippet is  would you lit the
> led if even if rfkill HW switch is on?
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -219,6 +219,7 @@ static int ieee80211_open(struct net_device *dev)
>                if (res)
>                        return res;
>                ieee80211_hw_config(local);
> +               ieee80211_led_radio(local, 1);
>        }
> 

Good point. I have updated the patch to make it check the radio_enabled
configuration parameter.

Ivo
