Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597AbaCSNzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 09:55:52 -0400
Message-ID: <1395237348.4142.6.camel@jlt4.sipsolutions.net> (sfid-20140319_145556_525623_F274BDB2)
Subject: Re: [PATCH] mac80211: fix WPA with VLAN on AP side with ps-sta again
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linville@tuxdriver.com, stable@vger.kernel.org,
	linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 19 Mar 2014 14:55:48 +0100
In-Reply-To: <1394114923-6380-1-git-send-email-michael-dev@fami-braun.de> (sfid-20140306_151702_591608_F07B3386)
References: <1394114923-6380-1-git-send-email-michael-dev@fami-braun.de>
	 (sfid-20140306_151702_591608_F07B3386)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-03-06 at 15:08 +0100, Michael Braun wrote:
> commit de74a1d9032f4d37ea453ad2a647e1aff4cd2591
>   "mac80211: fix WPA with VLAN on AP side with ps-sta"
> fixed an issue where queued multicast packets would
> be sent out encrypted with the key of an other bss.
> 
> commit "7cbf9d017dbb5e3276de7d527925d42d4c11e732"
>   "mac80211: fix oops on mesh PS broadcast forwarding"
> essentially reverted it, because vif.type cannot be AP_VLAN
> due to the check to vif.type in ieee80211_get_buffered_bc before.
> 
> As the later commit intended to fix the MESH case, fix it
> by checking for IFTYPE_AP instead of IFTYPE_AP_VLAN.

Applied.

> Fixes: 7cbf9d017dbb

I added the commit subject to this.

johannes

