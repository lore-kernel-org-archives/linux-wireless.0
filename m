Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37227 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbcECUks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 16:40:48 -0400
Message-ID: <1462308044.10444.19.camel@sipsolutions.net> (sfid-20160503_224110_363527_1FAE6E86)
Subject: Re: [PATCH] fix infoleak in wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Kangjie Lu <kangjielu@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Kangjie Lu <kjlu@gatech.edu>
Date: Tue, 03 May 2016 22:40:44 +0200
In-Reply-To: <1462308013-6032-1-git-send-email-kjlu@gatech.edu> (sfid-20160503_223714_829563_B6EE96BB)
References: <1462308013-6032-1-git-send-email-kjlu@gatech.edu>
	 (sfid-20160503_223714_829563_B6EE96BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-03 at 16:40 -0400, Kangjie Lu wrote:
> The 6-bytes array “mac_addr” is not initialized in the dump_station
> implementations of
> “drivers/staging/wilc1000/wilc_wfi_cfgoperations.c”
> and “drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c”, so all 6
> bytes may be leaked.

Like I said to you before, this makes those implementations completely
broken. I'm not going to apply this patch. If you want, feel free to
send patches to Greg to remove those dump_station implementations that
are completely broken and that can never do anything useful.

johannes
