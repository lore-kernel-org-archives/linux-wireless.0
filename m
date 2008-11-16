Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:63407 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYKPGVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 01:21:19 -0500
Received: by yx-out-2324.google.com with SMTP id 8so863969yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 22:21:18 -0800 (PST)
Message-ID: <43e72e890811152221r3d2df22eu4b842edb913296be@mail.gmail.com> (sfid-20081116_072122_218197_503E4F05)
Date: Sat, 15 Nov 2008 22:21:18 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: don't assume driver has been attached on registration
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1226702662-29694-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226702662-29694-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 2:44 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> mac80211's ieee80211_register_hw() is often called within the
> probe path so it cannot assume the device's driver structure
> has been attached yet so to create a workqueue instead of
> using driver->name use the wiphy's phy%d name. The name doesn't
> really matter anyway.
>
> This should fix sporadic oopses found when we race to beat the
> driver pointer setting. Not even sure how this was working properly.
>
> http://www.kerneloops.org/search.php?search=ieee80211_register_hw
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

This is not necessary actually, it took a while to wrap my head around
the possible chicken and the egg problem (thanks to Bob for beating my
head to it) but at least I verified this is not an issue at least on
>= 2.6.25 as the device's driver *is* assigned prior to probe. This
patch however should make reading this a bit easier and the since the
naming doesn't matter maybe its best to apply it to make things
simpler. Up to you.

  Luis
