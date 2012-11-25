Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2KYTQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 14:16:39 -0500
Message-ID: <1353871018.9875.7.camel@jlt4.sipsolutions.net> (sfid-20121125_201642_836073_1082A23B)
Subject: Re: Multi-bss operation issue with rt2x00 and hostapd on rt305x
 platform
From: Johannes Berg <johannes@sipsolutions.net>
To: Petr =?UTF-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Date: Sun, 25 Nov 2012 20:16:58 +0100
In-Reply-To: <20121125190019.GQ8292@ibawizard.net> (sfid-20121125_201043_358797_A470E889)
References: <20121125190019.GQ8292@ibawizard.net>
	 (sfid-20121125_201043_358797_A470E889)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-11-25 at 20:00 +0100, Petr Štetiar wrote:

> 	nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
> 	nl80211: Frame TX command accepted; cookie 0x81937c00
> 	Add randomness: count=39 entropy=38
> 	nl80211: Event message available
> -->	nl80211: MLME event 60 (NL80211_CMD_REGISTER_FRAME)

That command string is wrong. 60 really is NL80211_CMD_FRAME_TX_STATUS.
How did you print that string? The other one, 59, is NL80211_CMD_FRAME,
not NL80211_CMD_SET_TX_BITRATE_MASK.

It seems to me that you've messed up the nl80211.h header in either
hostapd or the kernel.

johannes

