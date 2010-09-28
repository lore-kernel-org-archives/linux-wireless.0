Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0I1RsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 13:48:14 -0400
Subject: Re: RFC:  Store premable and g-mode flags in ieee80211_tx_info
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CA224FF.3030103@candelatech.com>
References: <4CA224FF.3030103@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 19:48:09 +0200
Message-ID: <1285696089.32597.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 10:25 -0700, Ben Greear wrote:
> This way, you don't need to pass vif to ieee80211_rts_duration.


> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1264,6 +1264,14 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>          }
>          info->flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;
> 
> +       /* Set this here so drivers don't need to reference vif
> +        * when calling ieee80211_rts_duration
> +        */
> +       if (sdata->vif.bss_conf.use_short_preamble)
> +               tx.flags |= IEEE80211_TX_SHORT_PREABLE;
> +       if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
> +               tx.flags |= IEEE80211_TX_GMODE

Don't understand -- tx.flags? Drivers don't reference that? How would a
driver use this?

johannes

