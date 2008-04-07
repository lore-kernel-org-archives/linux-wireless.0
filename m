Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:40272 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYDGHJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 03:09:06 -0400
Date: Mon, 7 Apr 2008 10:07:48 +0300
From: Jouni Malinen <j@w1.fi>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 hardware encryption
Message-ID: <20080407070748.GM2025@jm.kir.nu> (sfid-20080407_080910_870216_6858B793)
References: <200804051931.58895.IvDoorn@gmail.com> <200804061844.14166.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200804061844.14166.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 06, 2008 at 06:44:14PM +0200, Ivo van Doorn wrote:

> After some more research I have a similar question for the RX path.
> The device will strip the IV out of the ieee80211 frame but provides
> the IV/EIV seperately in the descriptor.
> 
> Would it be any added value to instead of setting the RX_FLAG_IV_STRIPPED
> flag the IV is reinserted into the frame, provide the IV/EIV seperately in
> struct ieee80211_rx_status, or simply set RX_FLAG_IV_STRIPPED and ignore
> the entire field?

Yes, I would highly recommend delivering IV/EIV to mac80211 so that
replay protection can be implemented properly. This is required if the
hardware/firmware does not have full implementation of replay protection
(including support for multiple access categories in case QoS is used).

-- 
Jouni Malinen                                            PGP id EFC895FA
