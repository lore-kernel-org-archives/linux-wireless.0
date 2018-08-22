Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:57972 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbeHVPLX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 11:11:23 -0400
Message-ID: <1534938399.25523.91.camel@sipsolutions.net> (sfid-20180822_134651_176713_1EFF9C9B)
Subject: Re: Use of IEEE80211_VHT_CAP_RXSTBC_* in mac80211_hwsim
From: Johannes Berg <johannes@sipsolutions.net>
To: Danek Duvall <duvall@comfychair.org>,
        linux-wireless@vger.kernel.org
Date: Wed, 22 Aug 2018 13:46:39 +0200
In-Reply-To: <20180817212120.GA16270@lorien.comfychair.org>
References: <20180817212120.GA16270@lorien.comfychair.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-17 at 14:21 -0700, Danek Duvall wrote:
> The mac80211_hwsim driver puts this in its VHT capabilities info field:
> 
>     IEEE80211_VHT_CAP_RXSTBC_1 | 
>     IEEE80211_VHT_CAP_RXSTBC_2 |
>     IEEE80211_VHT_CAP_RXSTBC_3 |
>     IEEE80211_VHT_CAP_RXSTBC_4

Uh, yeah, that's garbage.

> and I don't understand what that's supposed to mean.  According to
> 802.11-2016, the three-bit field isn't a series of boolean values, but a
> single numerical value in its three bits, where the value is the maximum
> number of STBC streams, and the maximum defined value is 4.

Yeah ...

> But the way that the code treats it, we end up with a value of 7.

Indeed.

> There seems to be a similar issue in mac80211/main.c, in the definition of
> mac80211_vht_capa_mod_mask.

I guess this one is sort of fine - you can override here and the 7 is
actually the right result, but we should put there
IEEE80211_VHT_CAP_RXSTBC_MASK.

> Is that a bug in the code, or a misunderstanding on my part?  No other
> (in-tree) drivers use any of the macros other than _1, so I don't have any
> other references for how the other values might be used.

It's a bug.

I think it should be two changes - one, in hwsim, to just set _4 (it's
fake anyway), and in mac80211/main.c to use
IEEE80211_VHT_CAP_RXSTBC_MASK instead of the four values ORed together.

Want to prepare such patches? Otherwise I can too.

johannes
