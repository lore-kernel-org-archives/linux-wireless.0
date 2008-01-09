Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:54362 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYAIQvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 11:51:11 -0500
Received: by fk-out-0910.google.com with SMTP id z23so187983fkz.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2008 08:51:10 -0800 (PST)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH v2] mac80211: Add radio led trigger
Date: Wed, 9 Jan 2008 17:50:47 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200801061410.12862.IvDoorn@gmail.com> <200801071945.24793.IvDoorn@gmail.com> <1ba2fa240801081618u1ba01720rbd89a4c4b8d80a8c@mail.gmail.com>
In-Reply-To: <1ba2fa240801081618u1ba01720rbd89a4c4b8d80a8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801091750.47672.IvDoorn@gmail.com> (sfid-20080109_165120_067486_9DEA958A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > @@ -651,6 +652,7 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
> >         if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
> >                 local->hw.conf.radio_enabled = !(data->txpower.disabled);
> >                 need_reconfig = 1;
> > +               ieee80211_led_radio(local, local->hw.conf.radio_enabled);
> 
> Not sure but isn't it cleaner to push it to ieee80211_hw_config().
> This will cover also ieee80211_open and maybe in the future also
> cfg80211
> Will it be so bad to call led_radio even the led is already lit?

Well that means it will be called quite often, and although it would perhaps
not matter that much, I don't consider it a clean solution.

We could move it to ieee80211_hw_config() eventually, but I think we should
first implement some kind of "what config option changed" handling. That
would benefit drivers as well since they should now handle that to prevent
configuring _everything_ when hw_config() is called.

Ivo
