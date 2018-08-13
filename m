Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728055AbeHMO0l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 10:26:41 -0400
Date: Mon, 13 Aug 2018 13:44:44 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: allow to build without
 CFG80211_REQUIRE_SIGNED_REGDB
Message-ID: <20180813114443.GA2153@redhat.com> (sfid-20180813_134503_382959_37386FF5)
References: <1533898547-14449-1-git-send-email-sgruszka@redhat.com>
 <1534154953.3093.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534154953.3093.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2018 at 12:09:13PM +0200, Johannes Berg wrote:
> On Fri, 2018-08-10 at 12:55 +0200, Stanislaw Gruszka wrote:
> > According to kconfig-language.txt conditional dependency should be
> > expressed 2 times:
> > 
> >         bool "foo" if BAR
> >         default y if BAR
> > 
> > Indeed, without additional if expression we always build with
> > CFG80211_REQUIRE_SIGNED_REGDB even when CFG80211_CERTIFICATION_ONUS
> > is not set.

Err, I meant "is set"

> That's the intent. If you do set CERTIFICATION_ONUS, then you can
> disable this (presumably because you have external OS image verification
> mechanisms, or similar).
> 
> If you don't set CERTIFICATION_ONUS, this should always be set.

Patch allow to build without CFG80211_REQUIRE_SIGNED_REGDB. This option
is not configurable (allways y) no matter of CERTIFICATION_ONUS setting.
With the patch and with CERTIFICATION_ONUS,
CFG80211_REQUIRE_SIGNED_REGDB is still default y, but can be set to n
during "make oldconfig".

> Perhaps it should be renamed to CFG80211_REQUIRE_REGDB_SIGNATURE or so,
> which might be clearer? And a case has been made before for adding
> CFG80211_FIRMWARE_REGDB_SUPPORT that controls the whole feature, but
> this patch is clearly wrong.

Patch is fine, there is just typo in the changelog :-)

Cheers
Stanislaw
