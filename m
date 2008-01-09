Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:5737 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYAIRHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 12:07:49 -0500
Received: by wa-out-1112.google.com with SMTP id v27so516917wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2008 09:07:48 -0800 (PST)
Message-ID: <1ba2fa240801090907w7ce2e0d5w2fc257c1ab9f84fc@mail.gmail.com> (sfid-20080109_170752_915662_4E20679A)
Date: Wed, 9 Jan 2008 19:07:48 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH v2] mac80211: Add radio led trigger
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801091750.47672.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200801061410.12862.IvDoorn@gmail.com>
	 <200801071945.24793.IvDoorn@gmail.com>
	 <1ba2fa240801081618u1ba01720rbd89a4c4b8d80a8c@mail.gmail.com>
	 <200801091750.47672.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 9, 2008 6:50 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
> > > @@ -651,6 +652,7 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
> > >         if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
> > >                 local->hw.conf.radio_enabled = !(data->txpower.disabled);
> > >                 need_reconfig = 1;
> > > +               ieee80211_led_radio(local, local->hw.conf.radio_enabled);
> >
> > Not sure but isn't it cleaner to push it to ieee80211_hw_config().
> > This will cover also ieee80211_open and maybe in the future also
> > cfg80211
> > Will it be so bad to call led_radio even the led is already lit?
>
> Well that means it will be called quite often, and although it would perhaps
> not matter that much, I don't consider it a clean solution.

If you have one physical  led mapped to few triggers as it is on
current  laptops it will be probably  complicate few things so after
all I'm fine with how it is now.

> We could move it to ieee80211_hw_config() eventually, but I think we should
> first implement some kind of "what config option changed" handling. That
> would benefit drivers as well since they should now handle that to prevent
> configuring _everything_ when hw_config() is called.

You are talking from my heart.

Tomas

> Ivo
>
