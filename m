Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2E2HLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 03:11:03 -0400
Message-ID: <1338275466.4342.21.camel@jlt3.sipsolutions.net> (sfid-20120529_091106_870224_18AB39BC)
Subject: Re: [PATCH] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 09:11:06 +0200
In-Reply-To: <CAK80WHbLfOYgvNqoyZroGC6zvWs8UYNwRP_TzLmzDjVSqJK8XA@mail.gmail.com>
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
	 <1337712022.4470.0.camel@jlt3.sipsolutions.net>
	 <CAK80WHZW8OLs8N9vPhLx8+yVUhOnFU8EGyHQX=Es12gzZ32rNg@mail.gmail.com>
	 <CAK80WHbLfOYgvNqoyZroGC6zvWs8UYNwRP_TzLmzDjVSqJK8XA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-23 at 11:51 +0300, Goldenshtein, Victor wrote:
> On Wed, May 23, 2012 at 9:58 AM, Goldenshtein, Victor <victorg@ti.com> wrote:
> > On Tue, May 22, 2012 at 9:40 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> On Tue, 2012-05-22 at 09:45 +0300, Victor Goldenshtein wrote:
> >>
> >>> @@ -388,7 +389,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
> >>>       if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
> >>>           (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
> >>>               sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
> >>> -             sinfo->signal = (s8)sta->last_signal;
> >>> +             if (local->ops->get_rssi)
> >>> +                     drv_get_rssi(local, sdata, &sinfo->signal);
> >>> +             else
> >>> +                     sinfo->signal = (s8)sta->last_signal;
> >>>               sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
> >>>       }
> >>
> >> So .. you're filling a per-station value with a generic per-interface
> >> callback? What were you thinking? ;-)
> >>
> >
> > This is this is for managed only.
> > I can rename the drv_get_rssi() to drv_get_sta_rssi() and to call it
> > only for NL80211_IFTYPE_STATION, I think it would clarify things?
> >
> 
> Alternatively we could leave it as general callback "drv_get_rssi()",
> add the peer address and let the driver decide if it supports
> retrieval of the rssi for the given peer.  Thus, allowing us to do
> something like:
> 
> if (!local->ops->get_rssi) || (drv_get_rssi(local, sdata,
> sta->sta.addr, &sinfo->signal))
>         sinfo->signal = (s8)sta->last_signal;

That's probably better.

johannes

