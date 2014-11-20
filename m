Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbaKTUzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:55:01 -0500
Date: Thu, 20 Nov 2014 21:54:59 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Subject: Re: [PATCH v2 4/4] cfg80211: Allow usermode to query wiphy
	specific regd info
Message-ID: <20141120205459.GR24486@wotan.suse.de> (sfid-20141120_215506_544112_0E6D9B75)
References: <1415895219-19848-1-git-send-email-arik@wizery.com> <1415895219-19848-4-git-send-email-arik@wizery.com> <20141113231323.GG24486@wotan.suse.de> <CA+XVXfeqfHHDh6AcgkuBW9BwUo-s77+pnbDtP_y=e0dZQVBitg@mail.gmail.com> <1416496922.8557.7.camel@sipsolutions.net> <CA+XVXffq5h-5=wvPQ1PY0CoSa5zgi9j-kNCw5RbWjd0zDLigfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXffq5h-5=wvPQ1PY0CoSa5zgi9j-kNCw5RbWjd0zDLigfA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2014 at 06:47:24PM +0200, Arik Nemtsov wrote:
> On Thu, Nov 20, 2014 at 5:22 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2014-11-16 at 13:06 +0200, Arik Nemtsov wrote:
> >
> >> We intend to add a patch to wpa_s to always add the wiphy_idx to
> >> NL80211_CMD_GET_REG. With the current approach only drivers with
> >> SELF_MANAGED_REG will get wiphy->regd back. This is ok since these are
> >> new drivers, which are familiar with this API.
> >>
> >> But if we use your suggestion and always return wiphy->regd, then some
> >> driver like ath9k that uses regulatory_hint() will now get it's
> >> private regd returned to the wpa_s that manages it. I'm not saying
> >> it's necessarily bad, but it's different than what was returned
> >> before. The cfg80211 regdomain is intersected with wiphy->regd, so now
> >> ath9k will start getting more permissive channels in usermode.
> >>
> >> So we thought it's best to enable the new behavior only if the driver
> >> explicitly wants it, using a new regulatory flag.
> >
> > How does this work the other way around - i.e. a newer wpa_s requesting
> > per-wiphy information but it not being present?
> 
> Then it gets the global one, and it knows it via a wiphy attribute:
> 
>       (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
> +                   (nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG)))
> +                       goto nla_put_failure;
> 
> (we won't do this put_flag if it's global)

You can still follow this on wpa_s for REGULATORY_WIPHY_SELF_MANAGED, and
the other type that uses wiphy->regd would still follow the global regdomain.
The other flag I'm looking for is more informational for userspace in particular
'iw reg get' (for central and all devices) or 'iw reg get dev wlan0'.

> The supplicant patches are not up yet, but I think for now we will
> just act according to the global one. Anyway it has the option to
> change policy, since it knows.
> 
> >
> > It seems to me that either way what the kernel should return is the
> > information that will actually be applied when validated, which is of
> > course not possible when there are wiphy-specific regdomains and a
> > global one is requested (unless there's just one wiphy, which might be
> > something to consider making work?)
> 
> Well the cfg80211 regdomain is always intersected with all wiphy->regd
> in the system, so the global one is always less permissive.
> This is of course true before REGULATORY_WIPHY_SELF_MANAGED - in this
> case wiphy->regd will not affect the global regd.

The discrepancy is a long term issue when device combing but it seems folks
dealing with REGULATORY_WIPHY_SELF_MANAGED are OK with supporting whatever
issues come up.

> With CUSTOM_REG we have a special case, since the regulatory code
> doesn't set wiphy->regd, it just applies a user supplied regd to the
> wiphy channels (which get validated).

Its a custom world regdom, its a minimum base set. New information is
always welcomed to help it comply further, and that's what happens.

> If the user also happens to set  wiphy->regd himself with CUSTOM_REG,
> then it makes sense to return the per-wiphy one. The global regd is
> meaningless anyway for CUSTOM_REG, and the per-wiphy one might be too.
> But I guess we can return it if it's there?

When CUSTOM_REG is used we already have code that deals with what is
allowed or now given new hints from different sources, wpa_s can
and should rely on the channel information state it is in already.
All the intersection logic is already dealt for the device. The only
thing wpa_s could probably care more about from the regulatory data is
the actual ISO3166 alpha2 used for country IEs.

  Luis
