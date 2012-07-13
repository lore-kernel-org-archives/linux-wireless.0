Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2GMIyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 04:54:52 -0400
Message-ID: <1342169684.4983.0.camel@jlt3.sipsolutions.net> (sfid-20120713_105510_996521_75C9F5A5)
Subject: Re: mac80211: optimize ieee80211_rx_status struct layout
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Jul 2012 10:54:44 +0200
In-Reply-To: <20120713085227.GA16445@elgon.mountain> (sfid-20120713_105245_577228_12927670)
References: <20120713085227.GA16445@elgon.mountain>
	 (sfid-20120713_105245_577228_12927670)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yay... Thanks Dan.


> drivers/net/wireless/b43/xmit.c
>    768          if (phystat0 & B43_RX_PHYST0_OFDM)
>    769                  status.rate_idx = b43_plcp_get_bitrate_idx_ofdm(plcp,
>    770                                                  phytype == B43_PHYTYPE_A);
>    771          else
>    772                  status.rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
>    773          if (unlikely(status.rate_idx == -1)) {
>    774                  /* PLCP seems to be corrupted.
>    775                   * Drop the frame, if we are not interested in corrupted frames. */
>    776                  if (!(dev->wl->filter_flags & FIF_PLCPFAIL))
>    777                          goto drop;

Looks like it should have a temporary variable, I'll post a fix.

johannes

