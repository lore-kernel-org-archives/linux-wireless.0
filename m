Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:10181 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbXLYKIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 05:08:35 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1856938rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2007 02:08:34 -0800 (PST)
Message-ID: <c85cb4470712250208y29318fb6w2d140d00c3e02933@mail.gmail.com> (sfid-20071225_100840_136686_9EB466F0)
Date: Tue, 25 Dec 2007 12:08:33 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8 v2] mac80211: A-MPDU Rx handling aggregation reordering
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198170867.16241.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
	 <11981435613464-git-send-email-ron.rindjunsky@intel.com>
	 <1198170867.16241.56.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > @@ -1212,7 +1212,8 @@ void ieee80211_sta_stop_rx_BA_session(struct net_device *dev, u8 *ra, u16 tid,
> >       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> >       struct ieee80211_hw *hw = &local->hw;
> >       struct sta_info *sta;
> > -     int ret;
> > +     struct ieee80211_rx_status status;
> > +     int ret, i;
> >
> >       sta = sta_info_get(local, ra);
> >       if (!sta)
> > @@ -1254,6 +1255,20 @@ void ieee80211_sta_stop_rx_BA_session(struct net_device *dev, u8 *ra, u16 tid,
> >               ieee80211_send_delba(dev, ra, tid, 0, reason);
> >
> >       /* free the reordering buffer */
> > +     for (i = 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {
>
> Something I just thought of but probably simply missed: where's the
> session torn down when we ifdown an interface while an A-MPDU session is
> active? I didn't go through all the patches again, did I miss that
> somewhere?
>

No, and it should be done.
were would you recommend to put this tear down? i need a flow were i
can be sta specific, and is called only once per ifdown.
sta_info_release related flow, were i thought to put it, is risking me
with endless loops of kref_put calls.

> johannes
>
>
