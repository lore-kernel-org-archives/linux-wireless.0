Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab1ERWqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 18:46:30 -0400
Subject: Re: [PATCH v2] 802.11n frame injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <matteo@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTinp0Hy3yhfxAEAX9jeKSaYRMddDew@mail.gmail.com> (sfid-20110515_000810_416041_D36F7A6B)
References: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com>
	 <1305133583.17892.3.camel@jlt3.sipsolutions.net>
	 <BANLkTinp0Hy3yhfxAEAX9jeKSaYRMddDew@mail.gmail.com>
	 (sfid-20110515_000810_416041_D36F7A6B)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 15:49:08 -0700
Message-ID: <1305758948.8827.4.camel@jlt3.sipsolutions.net> (sfid-20110519_004633_098598_CBD4D55F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-05-15 at 00:07 +0200, Matteo Croce wrote:
> >> +             rthdr->ht_mcs = info->status.rates[0].idx;
> >> +             if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
> >> +                     rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_BW_40;
> >> +             if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
> >> +                     rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_SGI;
> >> +     }
> >
> > I think you should also split the patch -- this part isn't really only
> > injection.

> After injecting a frame I have a TX feedback, why shouldn't it have
> correct MCS informations?

... yeah but I said it's not _only_ injection, you also have TX feedback
w/o injection, so this isn't injection related.

johannes


