Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64566 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932407AbcLBVsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Dec 2016 16:48:23 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Luca Coelho <luca@coelho.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Vamsi, Krishna" <vamsin@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] cfg80211: Add support to sched scan to report better
 BSSs
Date: Fri, 2 Dec 2016 21:48:15 +0000
Message-ID: <20161202214812.GA31476@jouni.qca.qualcomm.com> (sfid-20161202_224827_010916_3B4BAE66)
References: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
 <1479938857-1788-2-git-send-email-jouni@qca.qualcomm.com>
 <1480065675.2517.109.camel@coelho.fi>
In-Reply-To: <1480065675.2517.109.camel@coelho.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 25, 2016 at 11:21:15AM +0200, Luca Coelho wrote:
> On Thu, 2016-11-24 at 00:07 +0200, Jouni Malinen wrote:
> > From: vamsi krishna <vamsin@qti.qualcomm.com>
> > @@ -9670,6 +9689,15 @@ static int nl80211_send_wowlan_nd(struct sk_buff=
 *msg,
> >  	if (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_DELAY, req->delay))
> >  		return -ENOBUFS;
> > =20
> > +	if (wiphy_ext_feature_isset(
> > +		    wiphy, NL80211_EXT_FEATURE_SCHED_SCAN_BETTER_BSS) &&
> > +	    (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
> > +			 req->relative_rssi) ||
> > +	     nla_put_u32(msg,
> > +			 NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF,
> > +			 req->relative_rssi_5g_pref)))
> > +		return -ENOBUFS;
> > +
>=20
> Why did you add this to nl80211_send_wowlan_nd() function?

Rest of the feedback will be addressed in PATCH v2, but I'm not sure
what to do with this part. I don't think we have any use case for this,
i.e., the addition here for NL80211_CMD_GET_WOWLAN response attributes
is based on how other sched_scan attributes were already included in the
response. Any new attribute atted to nl80211_parse_sched_scan() (like
these two new attributes) get parsed into
rdev->wiphy.wowlan_config->nd_config in nl80211_wowlan_nd(), so they can
end up being set here when using NL80211_CMD_SET_WOWLAN.
=20
--=20
Jouni Malinen                                            PGP id EFC895FA=
