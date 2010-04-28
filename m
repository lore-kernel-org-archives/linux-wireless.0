Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39700 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0D1VVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 17:21:04 -0400
Message-ID: <4BD8A6B4.20603@hauke-m.de>
Date: Wed, 28 Apr 2010 23:20:52 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-04-15
References: <20100415200331.GD3020@tuxdriver.com> <20100415.142907.68448693.davem@davemloft.net>
In-Reply-To: <20100415.142907.68448693.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

in your merge in 5c01d5669356e13f0fb468944c1dd4c6a7e978ad you added "int
i;" into wl1271_main.c which is unused in that function.

This patch fixes the merge problem:

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1311,7 +1311,6 @@
 	struct wl1271_filter_params *fp;
 	struct netdev_hw_addr *ha;
 	struct wl1271 *wl = hw->priv;
-	int i;

 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		return 0;

David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Thu, 15 Apr 2010 16:03:31 -0400
> 
>> Another fix intended for 2.6.34...without it some firmware wierdness can
>> induce the driver into hanging the box... :-(
>>
>> Please let me know if there are problems!
> 
> Pulled, thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
