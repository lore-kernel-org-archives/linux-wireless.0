Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49352 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbeHMOat (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 10:30:49 -0400
Message-ID: <1534160873.3093.9.camel@sipsolutions.net> (sfid-20180813_134856_128708_44463718)
Subject: Re: [PATCH] cfg80211: allow to build without
 CFG80211_REQUIRE_SIGNED_REGDB
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Aug 2018 13:47:53 +0200
In-Reply-To: <20180813114443.GA2153@redhat.com>
References: <1533898547-14449-1-git-send-email-sgruszka@redhat.com>
         <1534154953.3093.1.camel@sipsolutions.net>
         <20180813114443.GA2153@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-08-13 at 13:44 +0200, Stanislaw Gruszka wrote:
> On Mon, Aug 13, 2018 at 12:09:13PM +0200, Johannes Berg wrote:
> > On Fri, 2018-08-10 at 12:55 +0200, Stanislaw Gruszka wrote:
> > > According to kconfig-language.txt conditional dependency should be
> > > expressed 2 times:
> > > 
> > >         bool "foo" if BAR
> > >         default y if BAR
> > > 
> > > Indeed, without additional if expression we always build with
> > > CFG80211_REQUIRE_SIGNED_REGDB even when CFG80211_CERTIFICATION_ONUS
> > > is not set.
> 
> Err, I meant "is set"

Ok, but still?

> > That's the intent. If you do set CERTIFICATION_ONUS, then you can
> > disable this (presumably because you have external OS image verification
> > mechanisms, or similar).
> > 
> > If you don't set CERTIFICATION_ONUS, this should always be set.
> 
> Patch allow to build without CFG80211_REQUIRE_SIGNED_REGDB. This option
> is not configurable (allways y) no matter of CERTIFICATION_ONUS setting.

How so? The default is y, but if CERTIFICATION_ONUS is set, you should
be able to change it.

> With the patch and with CERTIFICATION_ONUS,
> CFG80211_REQUIRE_SIGNED_REGDB is still default y, but can be set to n
> during "make oldconfig".

I don't think your patch changes anything there since it just changes
when the default is applied.

> > Perhaps it should be renamed to CFG80211_REQUIRE_REGDB_SIGNATURE or so,
> > which might be clearer? And a case has been made before for adding
> > CFG80211_FIRMWARE_REGDB_SUPPORT that controls the whole feature, but
> > this patch is clearly wrong.
> 
> Patch is fine, there is just typo in the changelog :-)

Disagree, if anything should be changed, it should be changed to

  default y if !CERTIFICATION_ONUS

but I prefer the way it works now, since it means setting certification
onus won't immediately change this setting.

johannes
