Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab1DDUoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 16:44:06 -0400
Subject: Re: [PATCH v6 00/10] {mac|nl}80211: mesh security enhancements
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com
In-Reply-To: <BANLkTim8wWf08fqRzG3F9KfMiq0WGzq0WQ@mail.gmail.com>
References: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
	 <1301919673.3870.10.camel@jlt3.sipsolutions.net>
	 <BANLkTim8wWf08fqRzG3F9KfMiq0WGzq0WQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 22:44:04 +0200
Message-ID: <1301949844.3795.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-04 at 13:38 -0700, Thomas Pedersen wrote:

> > I don't believe this patchset works, since mac80211 doesn't set
> > @WIPHY_FLAG_MESH_AUTH afaict.
> >
> 
> in patch 10/10:
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 0ae9b22..55cc521 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -761,6 +761,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>        /* mesh depends on Kconfig, but drivers should set it if they want */
>        local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
>  #endif
> +       /* if the underlying driver supports mesh, mac80211 will (at least)
> +        * provide routing of mesh authentication frames to userspace */
> +       if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_MESH_POINT))
> +               local->hw.wiphy->flags |= WIPHY_FLAG_MESH_AUTH;

Ah, well, clearly that shouldn't be in an nl80211 patch :-)

johannes

