Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:56883 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYAVUva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 15:51:30 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1867627fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 12:51:28 -0800 (PST)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Tue, 22 Jan 2008 21:51:19 +0100
Cc: "bruno randolf" <bruno@thinktube.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>
References: <20080118125252.6455.41047.stgit@one> <200801222054.23433.IvDoorn@gmail.com> <43e72e890801221232hee414a3ie28d060e823bf28b@mail.gmail.com>
In-Reply-To: <43e72e890801221232hee414a3ie28d060e823bf28b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801222151.19817.IvDoorn@gmail.com> (sfid-20080122_205133_124440_6A368E7E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

<snip>

> > I am not sure if we should print error warning messages when the mactime is
> > not provided. But other then that I agree with the above change, as it would
> > allow rt2x00 to use the IBSS syncing. :)
> 
> Ah yes, ignore my printks and instead replace them with better comments :)
> 
> I still think we should inform the user if the user switches to IBSS
> at some point, perhaps better during interface addition if their
> driver's IBSS mode is going to have some issues. How about we add to
> the enum ieee80211_hw_flags a "IEEE80211_HW_RX_MACTIME". Then we can
> warn accordingly during ieee80211_if_add() if the interface type is
> IBSS"
> 
> * If driver supports IEEE80211_HW_RX_MACTIME we don't warn anything
> * If IEEE80211_HW_RX_MACTIME is not supported and get_tsf() is
> implemented inform user IBSS merge may not behave accurately
> * If IEEE80211_HW_RX_MACTIME is not supported and get_tsf() is not
> implemented warn IBSS merge will not work
> 
> We could add:
> 
> static inline u64 __approx_mactime(struct ieee80211_local *local) {
>    BUG_ON(!local || !local->ops);
>    return (local->ops->get_tsf) ?
> local->ops->get_tsf(local_to_hw(local)) : -1LLU;
> }
> 
> Then in ieee80211_rx_bss_info() we can do something like:
> 
> +               if (local->hw.flags & IEEE80211_HW_RX_MACTIME) {
> +                   if (rx_status->flag & RX_FLAG_TSFT)
> +                       mactime = rx_status->mactime;
> +                   else {
> +                     WARN_ON(1);
> +                     mactime = __approx_mactime(local);
> +                  }
> +              else {
> +                     mactime = __approx_mactime(local);
> +         }

Sounds good to me. :)

Ivo
