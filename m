Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38742 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760133AbZLOTCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 14:02:50 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 11:02:50 -0800
Date: Tue, 15 Dec 2009 11:02:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?utf-8?B?THVrw6HFoQ==?= Turek <8an@praha12.net>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute
 COVERAGE_CLASS
Message-ID: <20091215190248.GE2123@tux>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
 <1260899813-17585-2-git-send-email-8an@praha12.net>
 <20091215190051.GC2123@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20091215190051.GC2123@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 11:00:51AM -0800, Luis Rodriguez wrote:
> On Tue, Dec 15, 2009 at 09:56:48AM -0800, Lukáš Turek wrote:
> > The new attribute NL80211_ATTR_WIPHY_COVERAGE_CLASS sets IEEE 802.11
> > Coverage Class, which depends on maximum distance of nodes in a
> > wireless network. It's required for long distance links (more than a few
> > hundred meters).
> >
> > The attribute is now ignored by two non-mac80211 drivers, rndis and
> > iwmc3200wifi, together with WIPHY_PARAM_RETRY_SHORT and
> > WIPHY_PARAM_RETRY_LONG. If it turns out to be a problem, we could split
> > set_wiphy_params callback or add new capability bits.
> >
> > Signed-off-by: Lukas Turek <8an@praha12.net>
> > @@ -803,9 +807,16 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
> >                 changed |= WIPHY_PARAM_RTS_THRESHOLD;
> >         }
> >
> > +       if (info->attrs[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
> > +               coverage_class = nla_get_u8(
> > +                       info->attrs[NL80211_ATTR_WIPHY_COVERAGE_CLASS]);
> > +               changed |= WIPHY_PARAM_COVERAGE_CLASS;
> > +       }
> > +
> 
> Does setting the coverage class make sense for all modes of operation?
> 
> If not it'd be good to catch those early and avoid setting them and also
> properly document them.
> 
> The AP seems to pass the coverage class on country IE, so I guess
> this means we can support this for AP mode and IBSS and only through the
> country IE for STA.

And if your IBSS and the AP already sent the coverage class through the
country IE I am not sure if we should allow overriding it.

> Mind you that would mean hostapd would need to kick
> the coverage class as well and some new code on cfg80211 reg.c
> country_ie_2_rd() to parse it.
> 
> Doesn't seem to make sense to set this for monitor interfaces.

  Luis
