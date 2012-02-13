Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2BMK2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:28:15 -0500
Subject: Re: [RFC 7/9] nl80211/cfg80211: add DFS feature flag
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: "Goldenshtein, Victor" <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
In-Reply-To: <CAB=NE6WkArbBkiT6A4eEKEo6k2EJ2SsxjoNoPHp5BDWZNR3t8g@mail.gmail.com> (sfid-20120210_001212_463456_F8632DEE)
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	 <1327581484-22047-8-git-send-email-victorg@ti.com>
	 <4F27819A.1030200@sipsolutions.net>
	 <CAK80WHZpAAG_NWcuGUK2FJ_UwOhFXraVVkugR3W5FZEHCb6Z0A@mail.gmail.com>
	 <CAB=NE6WkArbBkiT6A4eEKEo6k2EJ2SsxjoNoPHp5BDWZNR3t8g@mail.gmail.com>
	 (sfid-20120210_001212_463456_F8632DEE)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Feb 2012 11:28:08 +0100
Message-ID: <1329128888.3365.3.camel@jlt3.sipsolutions.net> (sfid-20120213_112819_041417_2FC6285F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-09 at 15:11 -0800, Luis R. Rodriguez wrote:
> On Thu, Feb 2, 2012 at 8:08 AM, Goldenshtein, Victor <victorg@ti.com> wrote:
> > On Tue, Jan 31, 2012 at 7:52 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
> >>>
> >>> +static int nl80211_put_feature_flags(struct wiphy *wiphy,
> >>> +                                    struct sk_buff *msg)
> >>> +{
> >>> +       if (wiphy->flags&  WIPHY_FLAG_SUPPORTS_DFS)
> >>>
> >>> +               wiphy->features |= NL80211_FEATURE_DFS;
> >>> +
> >>> +
> >>> +       NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, wiphy->features);
> >>> +
> >>> +       return 0;
> >>> +nla_put_failure:
> >>> +       return -ENOBUFS;
> >>> +}
> >>
> >>
> >> I think you misunderstood the new feature flags -- they're supposed to be
> >> set by the driver directly, not indirectly via wiphy->flags.
> >>
> >
> > yep, I guess you're right.
> 
> While a it, consider adding one for the requirement of sending the
> channel switch announcement within mac80211, not the driver. In that
> case, although a DFS feature may be available in the driver, DFS
> should not be enabled on the driver through nl80211 unless that
> feature gets implemented in mac80211.

That, however, should be feature flag in mac80211, not cfg80211 (wiphy),
and in fact I think it can probably be done by checking if the low-level
function is there instead.

johannes

