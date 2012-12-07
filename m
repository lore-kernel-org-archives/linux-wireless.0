Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47015 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2LGXML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 18:12:11 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so790915lbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 15:12:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-17-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-17-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 7 Dec 2012 15:11:49 -0800
Message-ID: <CAB=NE6VmfjfYeDirc-L-cPMmE6b4f_4iAK+nuDUs1-XUeLCO7w@mail.gmail.com> (sfid-20121208_001217_039963_82CF2774)
Subject: Re: [PATCH 16/24] regulatory: clarify locking rules and assertions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Many places that currently check that cfg80211_mutex
> is held don't actually use any data protected by it.
> The functions that need to hold the cfg80211_mutex
> are the ones using the cfg80211_regdomain variable,
> so add the lock assertion to those and clarify this
> in the comments.
>
> The reason for this is that nl80211 uses the regdom
> without being able to hold reg_mutex.

Hm, do we want to do this or add a caller to reg.c that gets nl80211
to copy over the current regdomain over for it to parse and then send?
In that case we'd only need the cfg80211_mutex for
update_all_wiphy_regulatory(). Thoughts?

  Luis
