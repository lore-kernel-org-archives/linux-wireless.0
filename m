Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaAOUIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 15:08:54 -0500
Message-ID: <1389816527.4338.23.camel@jlt4.sipsolutions.net> (sfid-20140115_210858_342611_5634F957)
Subject: Re: [RFC 2/2] cfg80211: DFS get CAC time from regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 15 Jan 2014 21:08:47 +0100
In-Reply-To: <CALhHN=q=r-X_tk56NFZSrhscvnFRhMzbUh41pEHThq4gKf7bYw@mail.gmail.com> (sfid-20140115_171032_072417_D4536F00)
References: <1389788210-7246-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389788210-7246-2-git-send-email-janusz.dziedzic@tieto.com>
	 <1389792475.4338.11.camel@jlt4.sipsolutions.net>
	 <CALhHN=q=r-X_tk56NFZSrhscvnFRhMzbUh41pEHThq4gKf7bYw@mail.gmail.com>
	 (sfid-20140115_171032_072417_D4536F00)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 17:10 +0100, Janusz Dziedzic wrote:
> On 15 January 2014 14:27, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-01-15 at 13:16 +0100, Janusz Dziedzic wrote:
> >
> >> @@ -3211,6 +3212,7 @@ struct wireless_dev {
> >>
> >>       bool cac_started;
> >>       unsigned long cac_start_time;
> >> +     unsigned int cac_time_ms;
> >
> > Why would that need to be stored here? Isn't it just a pretty much local
> > parameter of the radar detection startup?
> >
> Because of this WARN_ON
> 
> @@ -778,7 +778,7 @@ void cfg80211_cac_event(struct net_device *netdev,
>         switch (event) {
>         case NL80211_RADAR_CAC_FINISHED:
>                 timeout = wdev->cac_start_time +
> -                         msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
> +                         msecs_to_jiffies(wdev->cac_time_ms);
>                 WARN_ON(!time_after_eq(jiffies, timeout));
> 
> We have to know this if we need this warning.

Oh, ok. Is it guaranteed to not be overwritten in the meantime though? I
guess you can't start two CACs at the same time, so I guess that's ok.

johannes

