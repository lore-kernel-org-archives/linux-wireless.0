Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48056 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbYFWJVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 05:21:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Ivo Van Doorn" <ivdoorn@gmail.com>
Subject: Re: mac80211: workqueue & RTNL lock
Date: Mon, 23 Jun 2008 11:20:41 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <200806230042.41219.IvDoorn@gmail.com> <200806230030.42776.mb@bu3sch.de> <a32f33a40806230130t11022b31p3d9997ab5e449fe6@mail.gmail.com>
In-Reply-To: <a32f33a40806230130t11022b31p3d9997ab5e449fe6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806231120.41519.mb@bu3sch.de> (sfid-20080623_112112_379070_8F41F9E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 June 2008 10:30:47 Ivo Van Doorn wrote:
> On 6/23/08, Michael Buesch <mb@bu3sch.de> wrote:
> > On Monday 23 June 2008 00:42:41 Ivo van Doorn wrote:
> >> That function calls flush_workqueue()
> >
> > Uh wait. It shouldn't call that. Where exactly is this function called?
> 
> It is called right before local->ops->remove_interface() which means the
> workqueue is flushed when it isn't even guaranteed that all interfaces are gone.
> 
> net/mac80211/main.c:553
> 
> static int ieee80211_stop(struct net_device *dev)
> {
> <snip>
>   switch (sdata->vif.type) {
> 	case IEEE80211_IF_TYPE_MESH_POINT:
> 	case IEEE80211_IF_TYPE_STA:
> 	case IEEE80211_IF_TYPE_IBSS:
>         <snip>
>         flush_workqueue(local->hw.workqueue);
>        <snip>
>   }
> <snip>
> }

Oh right. I see. This is actually OK. I thought it would flush the global wq.
The local mac80211 wq was introduced to workaround this rtnl deadlock,
so I'm surprised it happens again.


-- 
Greetings Michael.
