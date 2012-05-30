Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:59411 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757210Ab2E3Ou7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 10:50:59 -0400
Message-ID: <1338385736.32113.8.camel@joe2Laptop> (sfid-20120530_165102_212282_66CB88DD)
Subject: Re: [PATCH] mac80211: print info when disabling HT
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 30 May 2012 06:48:56 -0700
In-Reply-To: <1338379000.4511.12.camel@jlt3.sipsolutions.net>
References: <1338379000.4511.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 13:56 +0200, Johannes Berg wrote:
> Make mac80211 print a message when it disables
> HT due to the connection using WEP/TKIP or due
> to the AP not supporting WMM/QoS.

trivia: please use:
	netdev_<level>(
not
	netdev_printk(KERN_<LEVEL>, 
[]
> +			netdev_printk(KERN_INFO, sdata->dev,
> +				      "disabling HT due to WEP/TKIP use\n");

			netdev_info(sdata->dev, etc...)

etc...

