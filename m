Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1DRJVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 05:21:30 -0400
Subject: Re: [PATCH] mac80211: add a function for setting the TIM bit for a
 specific station
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4DAC0026.5020905@openwrt.org>
References: <1303055100-38307-1-git-send-email-nbd@openwrt.org>
	 <1303114525.3588.2.camel@jlt3.sipsolutions.net>
	 <4DAC0026.5020905@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 11:21:24 +0200
Message-ID: <1303118484.3588.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-18 at 11:11 +0200, Felix Fietkau wrote:

> > The only question I have is how will PS-Poll be handled while an
> > aggregation session is active?? Is it even allowed to poll a-MPDUs?

> Not sure - polling A-MPDUs may not be allowed, the standard only 
> mentions polling MSDU and A-MSDU. We could add a driver callback later 
> that mac80211 calls upon receiving a PS-Poll when WLAN_STA_PS_DRIVER_BUF 
> is set, which will trigger the release of a single packet and indicate 
> in the return status whether it was the last one (from the driver's 
> point of view).

Yeah I just looked at it too -- seems not allowed, and I don't even see
a way to implement it. I suppose for any long-term sleep (rather than
for things like scanning) the aggregation sessions should just be torn
down.

johannes

