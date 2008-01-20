Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:8223 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYATPfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 10:35:10 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1473486rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 07:35:09 -0800 (PST)
Message-ID: <c85cb4470801200735v6cdc4642k7b500b6202e9b346@mail.gmail.com> (sfid-20080120_153514_067134_2396209F)
Date: Sun, 20 Jan 2008 17:35:09 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 09/12 v2] iwlwifi: A-MPDU Tx conform API to mac80211
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1200616570.5716.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
	 <12005088643404-git-send-email-ron.rindjunsky@intel.com>
	 <1200616570.5716.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >  int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
> >                            enum ieee80211_ampdu_mlme_action action,
> > -                          const u8 *addr, u16 tid, u16 ssn)
> > +                          u8 *addr, u16 tid, u16 *ssn)
> >  {
> >       struct iwl4965_priv *priv = hw->priv;
> >       int sta_id;
> > @@ -4733,12 +4733,18 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
> >       switch (action) {
> >       case IEEE80211_AMPDU_RX_START:
> >               IWL_DEBUG_HT("start Rx\n");
> > -             iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, ssn);
> > +             iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
> >               break;
> >       case IEEE80211_AMPDU_RX_STOP:
> >               IWL_DEBUG_HT("stop Rx\n");
> >               iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
> >               break;
>
>
> >  extern int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
> >                                   enum ieee80211_ampdu_mlme_action action,
> > -                                 const u8 *addr, u16 tid, u16 ssn);
> > +                                 u8 *addr, u16 tid, u16 *ssn);
> >  #ifdef CONFIG_IWL4965_HT_AGG
>
> These changes need to be in patch 1 so that has a chance of compiling.
>

ok. I usually prefer not to mix mac80211 and iwlwifi changes on the
same patch, this is why i didn't put them in patch #1, but as this
code is already inside the tree i'll put them together.

> johannes
>
>
