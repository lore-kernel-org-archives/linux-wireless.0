Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34490 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083Ab0CBJm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 04:42:59 -0500
Date: Tue, 2 Mar 2010 11:42:38 +0200
From: Jouni Malinen <j@w1.fi>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, netrolller.3d@gmail.com,
	benoit.papillault@free.fr
Subject: Re: [PATCH v2] ath5k: fix injection in monitor mode
Message-ID: <20100302094238.GA24391@jm.kir.nu>
References: <20100302025158.9527.43764.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100302025158.9527.43764.stgit@void>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 02, 2010 at 11:51:58AM +0900, Bruno Randolf wrote:
> injected frames have to use AR5K_PKT_TYPE_NORMAL, otherwise the hardware thinks
> it can mess with the contents of the frame - e.g. update the TSF of an injected
> beacon. injected frames should be sent as they are provided.

Why would we never want the hardware to update fields in injected
frames? Unless I missed something, this seems to break hostapd use cases
where the hardware is indeed expected to update the timestamp in Probe
Response frames and set up seq# and duration etc. as appropriate for the
frames (the latter may be driver/mac80211 work; the timestamp needs to
come from hardware/firmware).

If we want to have an option to prevent hardware from touching the frame
payload, that really should be an option (a radiotap and TX control
flags, etc.), not default functionality for monitor interface. The use
case for this seems to be some kind of testing purpose and that should
not really break more common functionality.


> +	/* we don't want the hardware to mess with injected frames in monitor
> +	 * mode (e.g. update TSF in beacons) */
> +	if (info->flags & IEEE80211_TX_CTL_INJECTED)
> +		pkt_type = AR5K_PKT_TYPE_NORMAL;

This is the part I object to. IEEE80211_TX_CTL_INJECTED should not be
used for this.

-- 
Jouni Malinen                                            PGP id EFC895FA
