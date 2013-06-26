Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3FZHbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 03:31:31 -0400
Message-ID: <1372231882.8157.0.camel@jlt4.sipsolutions.net> (sfid-20130626_093133_906362_434B7761)
Subject: Re: regression after, " ath9k_htc: Add support for mesh interfaces"
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Date: Wed, 26 Jun 2013 09:31:22 +0200
In-Reply-To: <CAG6hwVMa+i=wXRyfcwaXH8NesCXgKXW6Ad4dzgd9DZONGYA=xQ@mail.gmail.com> (sfid-20130625_220609_973590_1D631910)
References: <51C52E79.30104@rempel-privat.de>
	 <CAG6hwVOCfDK9nkh3e0fFMGcWp8XLQnPC8TzQb9eET2fwFPq3SA@mail.gmail.com>
	 <51C93538.4050304@rempel-privat.de>
	 <CAG6hwVMa+i=wXRyfcwaXH8NesCXgKXW6Ad4dzgd9DZONGYA=xQ@mail.gmail.com>
	 (sfid-20130625_220609_973590_1D631910)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-25 at 13:05 -0700, Thomas Pedersen wrote:

> That warning is triggered by wiphy_verify_combinations():
> 
>                         if (WARN_ON((wiphy->interface_modes & types) != types))
>                                 return -EINVAL;
> 
> But before that, the mesh iftype bit is cleared in ieee80211_register_hw():
> 
> #ifndef CONFIG_MAC80211_MESH
>         /* mesh depends on Kconfig, but drivers should set it if they want */
>         local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
> #endif
> 
> It seems the intention was to avoid an #ifdef CONFIG_MAC80211_MESH in
> every driver, but then mac80211 also has to clear the MESH_POINT bit
> for each ieee80211_iface_limit? I don't really see a cleaner way of
> resolving this.

The problem is that the data structures there are const, so we can't
modify them. I think the other drivers just have an #ifdef on
MAC80211_MESH or so in there.

johannes

