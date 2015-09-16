Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:58381 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbbIPK04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 06:26:56 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Matthias May'" <matthias.may@neratec.com>,
	<linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@venema.h4ckr.net>, <ath9k-devel@qca.qualcomm.com>
References: <773DB8A82AB6A046AE0195C68612A31901A720F6@sbs2003.acksys.local> <55F7EB74.30701@neratec.com>
In-Reply-To: <55F7EB74.30701@neratec.com>
Subject: RE: [RFC v2] [resend] ath9k: allow up to 8 access point vifs on DFS channels
Date: Wed, 16 Sep 2015 10:01:57 +0200
Message-ID: <000901d0f055$f5c46680$e14d3380$@acksys.fr> (sfid-20150916_122659_580201_E5CD6F64)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matthias,

The patch is working for me, and I am using it, but I could not test
Much further since real-life radar situations are hard to produce.

Before DFS integration, combinations were less limited. I submitted
the patch as a RFC only, because I suspected the DFS people had a
hidden reason for limiting the combinations on radar channels.

However I received no comments.

Maybe I was on the wrong list. I will CC the ath9k maintainer now,
and try to submit a patch in a week or two.

Best regards
Jean-Pierre

> -----Message d'origine-----
> De : Matthias May [mailto:matthias.may@neratec.com]
> Envoyé : mardi 15 septembre 2015 11:57
> À : Jean-Pierre TOSONI; linux-wireless@vger.kernel.org
> Objet : Re: [RFC v2] [resend] ath9k: allow up to 8 access point vifs on
> DFS channels
> 
> On 09/06/15 18:26, Jean-Pierre TOSONI wrote:
> > Allow the combination of 8 (AP + mesh) interfaces on radar channels
> >
> > Tested with hostapd, 2 and 8 BSSIDs, 1 or 2 DFS channels, BW 20 MHz
> > TODO: test AP+mesh combination
> > TODO: test 40 MHz BW
> > ---
> > This patch was done with quilt on Openwrt against compat-wireless
> > 2014-11-04
> >
> > Any feedback?
> >
> > --- a/drivers/net/wireless/ath/ath9k/init.c
> > +++ b/drivers/net/wireless/ath/ath9k/init.c
> > @@ -723,6 +723,14 @@ static const struct ieee80211_iface_limi
> >   				 BIT(NL80211_IFTYPE_ADHOC) },
> >   };
> >
> > +static const struct ieee80211_iface_limit if_dfs_limits_mvap[] = {
> > +	{ .max = 8,	.types =
> > +#ifdef CONFIG_MAC80211_MESH
> > +				 BIT(NL80211_IFTYPE_MESH_POINT) | #endif
> > +				 BIT(NL80211_IFTYPE_AP) },
> > +};
> > +
> >   static const struct ieee80211_iface_combination if_comb[] = {
> >   	{
> >   		.limits = if_limits,
> > @@ -746,6 +754,16 @@ static const struct ieee80211_iface_comb
> >   		.num_different_channels = 1,
> >   		.beacon_int_infra_match = true,
> >   		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT)
> > |
> > +					BIT(NL80211_CHAN_WIDTH_20) |
> > +					BIT(NL80211_CHAN_WIDTH_40),
> > +	},
> > +	{
> > +		.limits = if_dfs_limits_mvap,
> > +		.n_limits = ARRAY_SIZE(if_dfs_limits_mvap),
> > +		.max_interfaces = 8,
> > +		.num_different_channels = 1,
> > +		.beacon_int_infra_match = true,
> > +		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT)
> > |
> >   					BIT(NL80211_CHAN_WIDTH_20) |
> >   					BIT(NL80211_CHAN_WIDTH_40),
> >   	}
> Hi
> This mail is in my list of "potentially interesting changes".
> Do you plan to send this as patch at some point?
> Or are you still testing something?
> 
> Best regards
> Matthias

