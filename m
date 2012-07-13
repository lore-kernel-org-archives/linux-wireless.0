Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:41427 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2GMIwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 04:52:39 -0400
Date: Fri, 13 Jul 2012 11:52:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mac80211: optimize ieee80211_rx_status struct layout
Message-ID: <20120713085227.GA16445@elgon.mountain> (sfid-20120713_105245_577228_12927670)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes Berg,

The patch 30f422925c39: "mac80211: optimize ieee80211_rx_status 
struct layout" from Jul 5, 2012, leads to the following warning:
drivers/net/wireless/b43/xmit.c:773 b43_rx()
	 error: status.rate_idx is never equal to -1 (wrong type 0 - 255).

drivers/net/wireless/b43/xmit.c
   768          if (phystat0 & B43_RX_PHYST0_OFDM)
   769                  status.rate_idx = b43_plcp_get_bitrate_idx_ofdm(plcp,
   770                                                  phytype == B43_PHYTYPE_A);
   771          else
   772                  status.rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
   773          if (unlikely(status.rate_idx == -1)) {
   774                  /* PLCP seems to be corrupted.
   775                   * Drop the frame, if we are not interested in corrupted frames. */
   776                  if (!(dev->wl->filter_flags & FIF_PLCPFAIL))
   777                          goto drop;
   778          }

b43_plcp_get_bitrate_idx_ofdm() and b43_plcp_get_bitrate_idx_cck()
return -1 on error.  The "rate_idx" variable used to be an int but now
it's a u8.

regards,
dan carpenter

