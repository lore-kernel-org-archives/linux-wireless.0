Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:47307 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbbA0KuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 05:50:06 -0500
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	"'Vladimir Kondratiev'" <qca_vkondrat@qca.qualcomm.com>
References: <1422345312-2963-1-git-send-email-dlansky@codeaurora.org> <1422347067.1890.49.camel@sipsolutions.net>
In-Reply-To: <1422347067.1890.49.camel@sipsolutions.net>
Subject: RE: [PATCH] cfg80211: PBSS basic support
Date: Tue, 27 Jan 2015 12:50:00 +0200
Message-ID: <002501d03a1f$024d1e30$06e75a90$@codeaurora.org> (sfid-20150127_115018_927937_09B058B8)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Tuesday, January 27, 2015 10:24 AM

> On Tue, 2015-01-27 at 09:55 +0200, Dedy Lansky wrote:
> 
> > --- a/include/linux/ieee80211.h
> > +++ b/include/linux/ieee80211.h
> > @@ -1602,6 +1602,15 @@ enum {
> >  	IEEE80211_BANDID_60G   = 5, /* 60 GHz */
> >  };
> >  
> > +/* BSS Type, 802.11ad #6.3.3.2 */
> > +enum ieee80211_bsstype {
> > +	IEEE80211_BSS_TYPE_ESS,
> > +	IEEE80211_BSS_TYPE_PBSS,
> > +	IEEE80211_BSS_TYPE_IBSS,
> > +	IEEE80211_BSS_TYPE_MBSS,
> > +	IEEE80211_BSS_TYPE_ANY
> > +};
> 
> Technically the standard defines this, but not as over the air bits as everything else in this file. I think this should therefore be moved into cfg80211.h as a local enum, we don't use the exact definitions from clause 6 anywhere anyway.

OK. Will take care of that.

> 
> > @@ -4007,6 +4009,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
> >  				      struct ieee80211_channel *channel,
> >  				      const u8 *bssid,
> >  				      const u8 *ssid, size_t ssid_len,
> > +				      enum ieee80211_bsstype bss_type,
> >  				      u16 capa_mask, u16 capa_val);
> 
> As far as I can tell, the only remaining use for capa_mask/val is the privacy -- for some reason some drivers like ath6kl don't specify it and don't care (which is odd) but it'd be nicer to remove capa_mask/val now and add a privacy enum allowing UNSPEC, ON and OFF or so. That'll make the callers clearer.

Sure. I guess this enum should go into cfg80211.h as well.

> 
> >  
> >  	list_for_each_entry(bss, &rdev->bss_list, list) {
> > +		if (!cfg80211_bss_type_to_capa(bss_type,
> > +					       bss->pub.channel->band,
> > +					       &capa_val, &capa_mask))
> > +			continue;
> 
> This doesn't make any sense - you're also storing the bss_type in the bss struct, so why translate here to match?

See below.

> 
> > @@ -896,6 +949,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
> >  	struct cfg80211_bss_ies *ies;
> >  	struct ieee80211_channel *channel;
> >  	struct cfg80211_internal_bss tmp = {}, *res;
> > +	int bss_type;
> 
> enum.
> 
> Except that you actually forgot to store the BSS type ...
> 
> Actually - you didn't add it to the bss struct, but to wdev? Why is it needed there?? I don't see you using it?

wdev->bss_type refers to the BSS that we are connecting/connected to (Maybe rename to "conn_bss_type"?).
This member is used in sme.c. It was introduced because once the connect is complete and driver calls cfg80211_connect_result(), cfg needs to find the BSS being connected to.

> 
johannes



