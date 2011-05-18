Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48361 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777Ab1ERUi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 16:38:27 -0400
Subject: Re: net-next-2.6 wireless build failure
From: Luciano Coelho <coelho@ti.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ido@wizery.com, eliad@wizery.com
In-Reply-To: <20110518.155501.486816316237445149.davem@davemloft.net>
References: <20110518.155501.486816316237445149.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 23:38:22 +0300
Message-ID: <1305751102.12586.1546.camel@cumari> (sfid-20110518_223835_919316_5781027F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

On Wed, 2011-05-18 at 15:55 -0400, David Miller wrote:
> The suspend op member of ieee80211_ops is only available when
> CONFIG_PM is enabled.
> 
> drivers/net/wireless/wl12xx/main.c:3653:2: error: unknown field ‘suspend’ specified in initializer
> drivers/net/wireless/wl12xx/main.c:3653:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/wireless/wl12xx/main.c:3653:2: warning: (near initialization for ‘wl1271_ops.config’) [enabled by default]
> drivers/net/wireless/wl12xx/main.c:3654:2: error: unknown field ‘resume’ specified in initializer
> drivers/net/wireless/wl12xx/main.c:3654:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/wireless/wl12xx/main.c:3654:2: warning: (near initialization for ‘wl1271_ops.bss_info_changed’) [enabled by default]
> 
> Someone please fix this.

I'm really sorry to let this pass through.  I'll send a patch to fix it
in a second.

-- 
Cheers,
Luca.

