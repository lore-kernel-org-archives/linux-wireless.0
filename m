Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:45311 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab2CZUKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 16:10:54 -0400
Received: by mail-lpp01m010-f42.google.com with SMTP id l5so9123788lah.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 13:10:53 -0700 (PDT)
Message-ID: <1332792650.1347.27.camel@cumari> (sfid-20120326_221059_208544_C2B6BEA6)
Subject: Re: [PATCH] mac80211: don't always advertise remain-on-channel
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Sujith <Sujith.Manoharan@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Mar 2012 23:10:50 +0300
In-Reply-To: <1332780438.5435.53.camel@jlt3.sipsolutions.net>
References: <1332780438.5435.53.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-26 at 18:47 +0200, Johannes Berg wrote: 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Not all devices are really capable of implementing
> remain-on-channel, even if it is implemented in SW,
> as they can't necessarily deal with channel changes
> while associated.
> 
> Remove the WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL and add
> it only if either the driver has remain_on_channel
> implemented in the driver/device.
> 
> Also add it to all drivers that advertise P2P right
> now since those definitely have to have it working.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> I think e.g. wl1251 would completely get fucked up by this .. let's not
> go there. Also iwlegacy wouldn't like offchannel much, and doesn't need
> it since it'll never have P2P anyway.

Yes, I'm pretty sure it wouldn't work as is with wl1251.  So, let's
leave it out.

Otherwise, for the wl12xx part:

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

