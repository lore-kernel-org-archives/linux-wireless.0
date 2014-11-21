Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbaKUXiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 18:38:25 -0500
Date: Sat, 22 Nov 2014 00:38:23 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Subject: Re: [PATCH v2 4/4] cfg80211: Allow usermode to query wiphy
	specific regd info
Message-ID: <20141121233823.GF25677@wotan.suse.de> (sfid-20141122_003829_019192_9BFE9C67)
References: <1415895219-19848-1-git-send-email-arik@wizery.com> <1415895219-19848-4-git-send-email-arik@wizery.com> <20141113231323.GG24486@wotan.suse.de> <CA+XVXfeqfHHDh6AcgkuBW9BwUo-s77+pnbDtP_y=e0dZQVBitg@mail.gmail.com> <1416496922.8557.7.camel@sipsolutions.net> <CA+XVXffq5h-5=wvPQ1PY0CoSa5zgi9j-kNCw5RbWjd0zDLigfA@mail.gmail.com> <20141120205459.GR24486@wotan.suse.de> <CA+XVXfc2-9Q+2AYj_GwyYN_agawk3LqLGssibzaxA6taszo4NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfc2-9Q+2AYj_GwyYN_agawk3LqLGssibzaxA6taszo4NQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2014 at 11:33:43AM +0200, Arik Nemtsov wrote:
> On Thu, Nov 20, 2014 at 10:54 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> >>
> >> Then it gets the global one, and it knows it via a wiphy attribute:
> >>
> >>       (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
> >> +                   (nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG)))
> >> +                       goto nla_put_failure;
> >>
> >> (we won't do this put_flag if it's global)
> >
> > You can still follow this on wpa_s for REGULATORY_WIPHY_SELF_MANAGED, and
> > the other type that uses wiphy->regd would still follow the global regdomain.
> > The other flag I'm looking for is more informational for userspace in particular
> > 'iw reg get' (for central and all devices) or 'iw reg get dev wlan0'.
> 
> I'm not sure why another flag is needed for userspace.

wiphy->regd will be used for REGULATORY_WIPHY_SELF_MANAGED and also on
devices that regulatory_hint() is called. Even though users of regulatory_hint()
will still abide by an intersection its useful to display that device's
regulatory domain in userspace, for that you'd need to distinguish it from
REGULATORY_WIPHY_SELF_MANAGED so another flag is needed. Showing that
regulatory domain will be informational.

> If we have
> SELF_MANAGED, we'll return the per-wiphy one (if a wiphy_idx is given
> to us of course). For validation purposes, the global one is used in
> other cases. And for CUSTOM_REG, we'll return the global one (we don't
> have the per-wiphy information in cfg80211).

Atheros cards always use CUSTOM_REG first, then later if they determine
the card was programmed with an alpha2 regulatory_hint() is called and
the CUSTOM_REG flag cleared. Regardless if wiphy->regd is set it would
be useful to have that information available.

  Luis
