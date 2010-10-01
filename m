Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab0JANvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 09:51:20 -0400
Subject: Re: [PATCH] mac80211: Add validity check for beacon_crc value
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1285938151-6306-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1285938151-6306-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 15:51:15 +0200
Message-ID: <1285941075.3739.35.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 16:02 +0300, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> On association to an AP, after receiving beacons, the beacon_crc value is set.
> The beacon_crc value is not reset in disassociation, but the BSS data may be
> expired at a later point. When associating again, it's possible that a
> beacon for the AP is not received, resulting in the beacon_ies to remain NULL.
> 
> After association, further beacons will not update the beacon data, as the
> crc value of the beacon has not changed, and the beacon_crc still holds a
> value matching the beacon. The beacon_ies will remain forever null.
> 
> One of the results of this is that WLAN power save cannot be entered, the STA
> will remain foreven in active mode.
> 
> Fix this by adding a validation flag for the beacon_crc, which is cleared on
> association.

Acked-by: Johannes Berg <johannes@sipsolutions.net>



