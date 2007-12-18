Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:30413 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbXLRNpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:45:54 -0500
Received: by fk-out-0910.google.com with SMTP id z23so2065102fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 05:45:52 -0800 (PST)
Message-ID: <c85cb4470712180545u46dc0a21obdc6d7b6c095b797@mail.gmail.com> (sfid-20071218_134604_740978_97064EBD)
Date: Tue, 18 Dec 2007 15:45:51 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 6/8] mac80211: A-MPDU Rx adding BAR handling capability
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197915884.4885.93.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070783125-git-send-email-ron.rindjunsky@intel.com>
	 <1197915884.4885.93.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> > -u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
> > +u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
> > +                     unsigned int type);
>
> Please use the proper enum.

will do.

> > @@ -1680,6 +1725,7 @@ ieee80211_rx_handler ieee80211_rx_handlers[] =
> >       ieee80211_rx_h_remove_qos_control,
> >       ieee80211_rx_h_amsdu,
> >       ieee80211_rx_h_data,
> > +     ieee80211_rx_h_ctrl,
> >       ieee80211_rx_h_mgmt,
>
> Maybe we should have a single rx_h_frame function that passes it to
> three control/data/mgmt functions depending on the frame type? Not sure
> though since data comes first and that's the hot path.

especially in A-MPDU, data is the most traffic you'll see in these
handlers (lets put aside the AP that bombed me with 749 BARs over 30
seconds ;-) i really think it was a buggy functionality of the AP
there)

>
>
> > @@ -163,6 +164,15 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
> >       case IEEE80211_FTYPE_CTL:
> >               if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
> >                       return hdr->addr1;
> > +             else if ((fc & IEEE80211_FCTL_STYPE) ==
> > +                                             IEEE80211_STYPE_BACK_REQ) {
> > +                     switch (type) {
> > +                     case IEEE80211_IF_TYPE_STA:
> > +                             return hdr->addr2;
> > +                     case IEEE80211_IF_TYPE_AP:
> > +                             return hdr->addr1;
> > +                     }
>
> Doesn't that result in a compiler warning? And what does happen if we
> receive a BACK_REQ when we're an IBSS/MESH?
>

IBSS is not supporting 802.11n currently (spec decision)
MESH i am not familier enough yet to answer. are you sure it supports 11n?
