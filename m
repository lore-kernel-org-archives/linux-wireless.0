Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47952 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbeHMMvs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 08:51:48 -0400
Message-ID: <1534154953.3093.1.camel@sipsolutions.net> (sfid-20180813_121016_773495_E743241E)
Subject: Re: [PATCH] cfg80211: allow to build without
 CFG80211_REQUIRE_SIGNED_REGDB
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 13 Aug 2018 12:09:13 +0200
In-Reply-To: <1533898547-14449-1-git-send-email-sgruszka@redhat.com> (sfid-20180810_125902_042211_A5A70028)
References: <1533898547-14449-1-git-send-email-sgruszka@redhat.com>
         (sfid-20180810_125902_042211_A5A70028)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-10 at 12:55 +0200, Stanislaw Gruszka wrote:
> According to kconfig-language.txt conditional dependency should be
> expressed 2 times:
> 
>         bool "foo" if BAR
>         default y if BAR
> 
> Indeed, without additional if expression we always build with
> CFG80211_REQUIRE_SIGNED_REGDB even when CFG80211_CERTIFICATION_ONUS
> is not set.

That's the intent. If you do set CERTIFICATION_ONUS, then you can
disable this (presumably because you have external OS image verification
mechanisms, or similar).

If you don't set CERTIFICATION_ONUS, this should always be set.

Perhaps it should be renamed to CFG80211_REQUIRE_REGDB_SIGNATURE or so,
which might be clearer? And a case has been made before for adding
CFG80211_FIRMWARE_REGDB_SUPPORT that controls the whole feature, but
this patch is clearly wrong.

johannes
