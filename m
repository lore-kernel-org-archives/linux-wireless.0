Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58260 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0INPIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 11:08:22 -0400
Received: by gwj17 with SMTP id 17so2394010gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 08:08:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284442237-24425-1-git-send-email-lrodriguez@atheros.com>
References: <1284442237-24425-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 14 Sep 2010 08:07:55 -0700
Message-ID: <AANLkTikazs3A+=BXVm9+VZaOsRD2YFSkRSDJKQ4qGBfB@mail.gmail.com>
Subject: Re: [PATCH 00/10] ath9k / mac80211: power save fixes
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 13, 2010 at 10:30 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Here are a bundle of joy of fixes for power save. Some of
> these are regressions, which sucks ass to find out about them
> so late. We *really* need a regression testbed for mac80211 and
> ath9k. Some stable fixes trickle down to 2.6.32 even.
>
> I'll soon send links for the respective ports of these patches to each
> kernels. For now I'd just like them merged upstream and ensure we get
> this out for 2.6.36-rc stuff.
>
> The offchannel needs more work to be really useful, for example
> we should just be sending nullunc frames prior to actualloy probing
> the AP. We can work on this later for 37.
>
> Luis R. Rodriguez (9):
>  ath9k: fix power save race conditions
>  ath9k: fix regression on beacon loss after bgscan
>  mac80211: add helper for reseting the connection monitor
>  mac80211: reset probe send counter upon connection timer reset
>  mac80211: reset connection idle when going offchannel
>  mac80211: make the beacon monitor available externally
>  mac80211: disable beacon monitor while going offchannel
>  mac80211: send last 3/5 probe requests as unicast
>  ath9k: fix regression which disabled ps on ath9k
>
> Senthil Balasubramanian (1):
>  ath9k: fix regression which prevents chip sleep after CAB data

The all in one git am'able file can be downloaded here:

http://bombadil.infradead.org/~mcgrof/patches/ath9k/2010/09/all-ps-fixes-09-14-v1.patch

  Luis
