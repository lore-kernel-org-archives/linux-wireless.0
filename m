Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:61724 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZG3VAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 17:00:20 -0400
Received: by gxk9 with SMTP id 9so3075448gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 14:00:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248974386-8168-1-git-send-email-lrodriguez@atheros.com>
References: <1248974386-8168-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 30 Jul 2009 13:59:57 -0700
Message-ID: <43e72e890907301359o1f0c759age7c8df834f0b4d1d@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] wireless: fix 11d lockdep and move 11d hint to
	cfg80211
To: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 10:19 AM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> This cures the lockdep warning, now with a mutex instead of a spin_lock
> to allow sleeping during the driver reg notifier, and we finish the
> move of the regulatory_hint_11d() to cfg80211. We also add some missing
> lock calls and remove the cfg80211 mutex usage from the driver custom
> regulatory settings wiphy_apply_custom_regulatory(). This caller is now
> used internally within cfg80211 automatically for all cfg80211 drivers.
>
> Luis R. Rodriguez (3):
>  cfg80211: use goto out on 11d reg hint failure
>  cfg80211: decouple regulatory variables from cfg80211_mutex
>  cfg80211: enable country IE support to all cfg80211 drivers

Just hit a snag, will try to fix and respin. We were still trying to
get the rdev for the last country ie request when we plug in a second
card. Will try to use the wiphy_idx only.

  Luis
