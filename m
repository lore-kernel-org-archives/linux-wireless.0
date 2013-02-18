Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3BRLL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 06:11:59 -0500
Message-ID: <1361185913.8555.6.camel@jlt4.sipsolutions.net> (sfid-20130218_121202_160075_39158588)
Subject: Re: patch : mac80211:Multicast patch for linux-2.6.28.1 (wl12xx
 drivers)
From: Johannes Berg <johannes@sipsolutions.net>
To: Girish Bn <Girish.BN@lnties.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 18 Feb 2013 12:11:53 +0100
In-Reply-To: <45566970CF58C74CB52107862E0541CD1D1F72A2@POCITMSEXMB02.LntUniverse.com> (sfid-20130218_120856_334947_2BD0FBB7)
References: <45566970CF58C74CB52107862E0541CD1D1F72A2@POCITMSEXMB02.LntUniverse.com>
	 (sfid-20130218_120856_334947_2BD0FBB7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 11:09 +0000, Girish Bn wrote:
> Hi All,
> 
> The below patch file is required in order for the multicasting to work properly on Linux kernel below 3.2 for wl12xx drivers
> diff -Naur a/net/mac80211/iface.c b/net/mac80211/iface.c
> --- a/net/mac80211/iface.c          2012-09-22 22:59:15.000000000 +0530
> +++ b/net/mac80211/iface.c      2013-02-07 12:06:03.958268798 +0530
> @@ -811,6 +811,9 @@
>                .ndo_uninit                        = ieee80211_teardown_sdata,
>                .ndo_start_xmit                               = ieee80211_subif_start_xmit,
>                .ndo_set_rx_mode        = ieee80211_set_multicast_list,
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0))
> +             .ndo_set_multicast_list = ieee80211_set_multicast_list,
> +#endif

LOL.

johannes

