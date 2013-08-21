Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3HUIjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 04:39:14 -0400
Message-ID: <1377074351.15268.7.camel@jlt4.sipsolutions.net> (sfid-20130821_103918_932556_5ADC62C3)
Subject: Re: [PATCH 01/16] wcn36xx: Add main.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 21 Aug 2013 10:39:11 +0200
In-Reply-To: <CAFSJ42ZH3ZJ+-+6wUbqQvaM8D2t6oWqyqkGiGRRx4o2NA60EjA@mail.gmail.com> (sfid-20130821_103623_576237_81778620)
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	 <1377020479-16935-2-git-send-email-k.eugene.e@gmail.com>
	 <1377032397.13829.40.camel@jlt4.sipsolutions.net>
	 <CAFSJ42ZH3ZJ+-+6wUbqQvaM8D2t6oWqyqkGiGRRx4o2NA60EjA@mail.gmail.com>
	 (sfid-20130821_103623_576237_81778620)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[remove wcn list, it annoys me with moderator messages]


> >> +             if (IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags) {
> >> +                     sta_priv->is_data_encrypted = true;
> >> +                     /* Reconfigure bss with encrypt_type */
> >> +                     if (NL80211_IFTYPE_STATION == vif->type)
> >> +                             wcn36xx_smd_config_bss(wcn,
> >> +                                                    vif,
> >> +                                                    sta,
> >> +                                                    sta->addr,
> >> +                                                    true);
> >
> > It seems to me this should not be here but you should have mac80211 set
> > something in e.g. bss_conf that indicates encryption?
> >
> 
> It's a good idea and I tried to find anything encryption related in
> bss_conf but without luck. I do not like this line myself so I would
> really appreciate if you can point where exactly in
> bss_conf/bss_info_changed information about encryption is located.

There isn't anything, but you could always add it.

> >> +     static const u32 cipher_suites[] = {
> >> +             WLAN_CIPHER_SUITE_TKIP,
> >> +             WLAN_CIPHER_SUITE_CCMP,
> >> +     };
> >
> > You actually don't want to support WEP, not even in software? Otherwise
> > just leave this out and mac80211 will add it.
> 
> WEP is supported by HW but wcn36xx does not configure it yet. Is that
> ok to add HW WEP encryption in nearest future after wcn36xx is pushed
> to upstream?

I don't see why you'd even bother - why not just use software encryption
for WEP for the time being? Then you don't need this code.

> >> +     wcn->hw->wiphy->iface_combinations = &if_comb;
> >> +     wcn->hw->wiphy->n_iface_combinations = 1;
> >
> > Your code with "wcn->current_vif = " etc. *really* doesn't look like you
> > support combinations. Are you positive this is OK?
> 
> So far wcn36xx supports only one interface at once. But in the nearest
> future it will definitely support more than one. So how about keeping
> this for future?;)

It's *wrong* though - you're saying two interfaces are supported and
then they aren't. Don't do that.

johannes

