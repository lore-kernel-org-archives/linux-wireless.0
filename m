Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab1CBJYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 04:24:11 -0500
Subject: Re: [PATCH] hostapd: Don't force HT Mixed Mode for non-GF STAs
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: hostap@lists.shmoo.com, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201103021020.54806.helmut.schaa@googlemail.com>
References: <1299055031-25080-1-git-send-email-helmut.schaa@googlemail.com>
	 <201103021013.05798.helmut.schaa@googlemail.com>
	 <1299057521.4076.12.camel@jlt3.sipsolutions.net>
	 <201103021020.54806.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 10:24:08 +0100
Message-ID: <1299057848.4076.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 10:20 +0100, Helmut Schaa wrote:

> > static bool rs_use_green(struct ieee80211_sta *sta)
> > {
> >         struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;   
> >         struct iwl_rxon_context *ctx = sta_priv->common.ctx;
> >   
> >         return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
> >                 !(ctx->ht.non_gf_sta_present);
> > } 
> 
> Hmm, that looks a bit fishy as well. iwlagn should be allowed to use GF
> in that case, it just needs to protect it.

Right. That looks like it'd be a bit more tricky, and I don't think I
care right now.

johannes

