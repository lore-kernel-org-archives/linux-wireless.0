Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:35949 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbbGFL5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 07:57:09 -0400
Received: by lagc2 with SMTP id c2so151561487lag.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2015 04:57:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALhHN=oq2WK+YHoW7UG2eLuDPEcxusZ8mpUC3DLyVDJyNhkdzg@mail.gmail.com>
References: <1430918911-14715-1-git-send-email-arik@wizery.com> <CALhHN=oq2WK+YHoW7UG2eLuDPEcxusZ8mpUC3DLyVDJyNhkdzg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 6 Jul 2015 14:56:51 +0300
Message-ID: <CA+XVXfc3OcZm+y9y4DmvKjWHPNX6aQhFQGbptpk4KhMAf9dAYg@mail.gmail.com> (sfid-20150706_135719_195045_2BB911E1)
Subject: Re: [PATCH v2] cfg80211: change GO_CONCURRENT to IR_CONCURRENT for STA
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >         struct wireless_dev *wdev;
> > -       struct wiphy *wiphy = wiphy_idx_to_wiphy(rdev->wiphy_idx);
> > +       struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
> >
> >         ASSERT_RTNL();
> >
> Seems after this patch we hit ASSERT_RTNL() when setup ibss (seems
> same for MONITOR)
> Simplest solution is move this assert after  if (iftype !=
> NL80211_IFTYPE_P2P_GO && ...) check, but I am not sure this is the
> best solution :)
> Anyway cfg80211_reg_can_beacon() need clear description about RTNL
> locking while drivers could call this ...

We actually have a different fix in the internal Intel tree already.
But yea you're right :)
I guess it should be pushed out soon (or maybe I'll push it).

Arik
