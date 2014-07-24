Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51873 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784AbaGXToE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 15:44:04 -0400
Received: by mail-pd0-f174.google.com with SMTP id fp1so4250691pdb.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 12:44:03 -0700 (PDT)
Date: Thu, 24 Jul 2014 12:43:58 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user
 hints
Message-ID: <20140724194358.GY1390@garbanzo.do-not-panic.com> (sfid-20140724_214417_218524_7541C197)
References: <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com>
 <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
 <CA+XVXfewhKpsdVo5Yq3RiKWoDe85h1ne_QVUDtFuC4sfECkV7g@mail.gmail.com>
 <20140708025719.GU1390@garbanzo.do-not-panic.com>
 <CA+XVXffMM9W76ysqgs=pyAHubavefgjqW5u8bNSZxTX69j7nzg@mail.gmail.com>
 <20140723004132.GX1390@garbanzo.do-not-panic.com>
 <CA+XVXfd-4jYUy3oz4cOqBprG358X2D9m7Pgq_JrkZKHERm6f3A@mail.gmail.com>
 <CAB=NE6WxUi9J+ODtvojAkT5PN5LsB=SWKhgbzqSkGkbepWeaOg@mail.gmail.com>
 <CA+XVXfcHwOAndEfUo3YtZxbgHtC12qC22QcpVXZFM41WKn0LiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfcHwOAndEfUo3YtZxbgHtC12qC22QcpVXZFM41WKn0LiQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2014 at 10:15:13PM +0300, Arik Nemtsov wrote:
> On Wed, Jul 23, 2014 at 9:06 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> >> I also suggest adding another argument to regulatory_hint_regd() to
> >> allow the driver to specify the intersection policy. It seems that
> >> currently the code (__reg_process_hint_driver()) only allows to
> >> intersect, which is not appropriate to us.
> >> So the final form can look like:
> >>
> >> regulatory_hint_regd(struct wiphy,
> >>                               const struct ieee80211_regdomain *regd,
> >>                               enum nl80211_driver_reg_hint_type,
> >>                               enum nl80211_reg_intersect_policy policy);
> >>
> >> enum nl80211_reg_intersect_policy {
> >>          REG_INTERSECT_POLICY_DEFAULT,
> >>          REG_INTERSECT_POLICY_OVERRIDE,
> >>          REG_INTERSECT_POLICY_INTERSECT,
> >> };
> >
> > We don't want to use the driver regulatory data to help the regulatory
> > core at all because I noted it would get things messy fast. That would
> > mean you never have to deal with any intersection or the cfg80211
> > regulatory domain at all. So none of this would be needed. The hint
> > would just be for the driver. Its sad that driver regulatory data
> > can't contribute to the regulatory core but I think its best this way
> > to keep things clean and simple. If the driver does want to help the
> > best way is to contribute to wireless-regdb and move to that.
> 
> I guess I didn't get that one.
> 
> Isn't that problematic for cell-base hints coming from usermode? I
> mean, what wiphy are they from?

We'd keep the userspace cell base station hint separate from driver
cell base station hint that provides its own regdomain which you are
implementing. The userspace cell base station hint has no wiphy associated
as its coming from userspace, its a general hint and there's a flag that lets
drivers specify they do support this feature (NL80211_FEATURE_CELL_BASE_REG_HINTS)
and if present and if the kernel was also compiled to support this feature
then the core uses the hint for the wiphy.

> It's also problematic because currently usermode uses the
> cfg80211_regdomain for its regulatory data (NL80211_CMD_GET_REG).

What's problematic? What you state is a fact, not an issue.

> Granted, all of this can be changed, but I think it's easier to update
> the global regdomain.

Nothing would be changed, you're adding new feature, how we add that can
vary. Now if you already implemented a solution and supporting it without it
being upstream yet -- that's definitely could change now depending on
what path we take.

I think you're suggesting to add support so that a driver can trigger
the cellular base station hint. That's a one step enhancement that I do
welcome regardless of the outcome of anything. Then there's another enhancement
you seem to want to add, you want to allow drivers to override the regulatory
domain with what they have internally in firmware for the alpha2 upon
application of the regulatory data with the get_regd() callback.
I thought about this and while this is possible this can get complicated
pretty quickly.  For instance consider CRDA not being present, we would
not trigger a setting of regulatory settings as we only do that once we
get back the regulatory domain from userespace. For drivers that have
their own regulatory data that would pose a problem unless CRDA was
present. That can be resolved by extending the routine called upon hitting the
timeout, just go ahead and send the callback to the wiphys that had the
internal regd data... but I suspect this is going to be just one corner case.
This would be complicated the code / paths even more.

Both approaches are certainly possible but I'm trying to ensure that we keep
things as clean and concise as possible. Let's review this below a bit
more.

> The cell-base hints from usermode with the regdomain data coming from
> the FW was the original reason to introduce the get_regd() callback.
> For driver originating hints I agree regulatory_hint_regd() is a
> cleaner solution.

OK. That would only be useful for when drivers have regulatory data
then.

> I feel the case of two different cards, one of which uses get_regd()
> and the other wireless-regdb is a non-existent corner-case.

If you tell that to customers or potential customers I'm going to assume
they'd react pretty negatively. I've seen the oddest combination, not sure
why you are ruling this out.

> And we're
> throwing out the baby with the bathwater.
> Why write extra code for a case that doesn't happen?

I've been told this before for regulatory code and to this day
I've been right, all corner cases I've envisioned have had to be
dealt with one way or another. My role is to help look out for these
cases to allow Linux to be flexible, not restrictive.

> How about adding appropriate regulatory_flags to ensure this can't happen?

That'd be being restrictive and lazy, for instance it'd let a
manufacturer build an image for phones that would not let users
plug in another type of 802.11 device. I think this flag is OK
however if once a device is found that uses wireless-regdb we'd
simply disallow the 802.11 devices that have the internal reg data
solution.

> Overall it seems to be the API you've suggested in the previous email
> with the addition of get_regd() for usermode hints can work well,
> updating the global cfg80211_regdomain.

OK I think we're on the same page, I just want to avoid complicating the
paths. If the above compromise seems reasonable I think that would help
keep things simple.

  Luis
