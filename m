Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43591 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaEVH7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:59:17 -0400
Message-ID: <1400745548.4174.9.camel@jlt4.sipsolutions.net> (sfid-20140522_095920_344524_11B28C4F)
Subject: Re: [PATCH] cfg80211: allow RSSI compensation
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 May 2014 09:59:08 +0200
In-Reply-To: <1400397324-8153-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140518_091825_554950_EDE1479D)
References: <1400397324-8153-1-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20140518_091825_554950_EDE1479D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-05-18 at 10:15 +0300, Emmanuel Grumbach wrote:
> Channels in 2.4GHz band overlap, this means that if we
> send a probe request on channel 1 and then move to channel
> 2, we will hear the probe response on channel 2. In this
> case, the RSSI will be lower than if we had heard it on
> the channel on which it was sent (1 in this case).
> 
> The firmware / low level driver can parse the channel in
> the DS IE or HT IE and compensate the RSSI so that it will
> still have a valid value even if we heard the frame on an
> adjacent channel. This can be done up to a certain offset.
> 
> Add this offset as a configuration for the low level driver.
> A low level driver that can compensate the low RSSI in this
> case should assign the maximal offset for which the RSSI
> value is still valid.

Applied.

johannes

