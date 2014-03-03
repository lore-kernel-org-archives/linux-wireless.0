Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaCCNSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:18:08 -0500
Message-ID: <1393852684.10039.11.camel@jlt4.sipsolutions.net> (sfid-20140303_141811_992954_847A3E9E)
Subject: Re: [PATCH] cfg80211: fix cfg80211_leave() locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 03 Mar 2014 14:18:04 +0100
In-Reply-To: <CA+BoTQk96KiL11N6X_8vx8S380vyaLMu0hU0P=dDUV4_fjw5fw@mail.gmail.com> (sfid-20140303_140715_936464_F062B634)
References: <1393599480-27908-1-git-send-email-michal.kazior@tieto.com>
	 <1393851336.10039.1.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk96KiL11N6X_8vx8S380vyaLMu0hU0P=dDUV4_fjw5fw@mail.gmail.com>
	 (sfid-20140303_140715_936464_F062B634)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 14:07 +0100, Michal Kazior wrote:
> On 3 March 2014 13:55, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-02-28 at 15:58 +0100, Michal Kazior wrote:
> >> The beacon_interval was set unprotected by
> >> wdev.mtx. This could possibly lead to inconsistent
> >> cfg80211 states.
> >
> > Why not just this patch? The beacon_interval is already set to 0 in
> > stop_ap(), and is irrelevant for the other modes.
> >
> > diff --git a/net/wireless/core.c b/net/wireless/core.c
> > index 010892b81a06..a3bf18d11609 100644
> > --- a/net/wireless/core.c
> > +++ b/net/wireless/core.c
> > @@ -788,8 +788,6 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
> >         default:
> >                 break;
> >         }
> > -
> > -       wdev->beacon_interval = 0;
> >  }
> >
> >  static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
> >
> >
> > johannes
> 
> Good point. I was focused on locking changes (for my other patch) and
> noticed the beacon_interval being unprotected and didn't look more
> into it. Should I respin or are you going to apply your patch
> yourself? Either way is fine with me.

I've got it.

johannes

