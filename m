Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27882 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2AILju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 06:39:50 -0500
Message-ID: <4F0AD16B.6010709@qca.qualcomm.com> (sfid-20120109_123954_322583_23A4DA1C)
Date: Mon, 9 Jan 2012 13:37:15 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thirumalai <tpachamu@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 0/4] Enable uAPSD support in AP mode
References: <1326095083-1538-1-git-send-email-tpachamu@qca.qualcomm.com>
In-Reply-To: <1326095083-1538-1-git-send-email-tpachamu@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 09:44 AM, Thirumalai wrote:
> In addition to legacy power save, this series of patch adds
> support for uAPSD in AP mode.
> 
> When connected station goes into suspend state, the driver will
> start queuing pkts in the separate queue (called uapsd queue)
> until the station ask for it. 
> 
> The moment driver starting queuing, it will enable traffic indication
> bit for the client connected to indicate data availability. 
> Once station ask for the data (via Trigger frame), the driver will 
> dequeue and send pkt one by one to the station.

I didn't do very thorough review but here are my first comments:

I see that you enable uapsd in patch 2 but add more functionality in
patches 3 and 4. That will break bisect as uapsd will be broken between
patches 2 and 4, no?

It's nice to have small patches, but it's more important to make sure
that bisect works. So you could just fold patches 2-4 into one. You
could even fold patch 1, as it doesn't give any benefit, and just have
one big patch adding the support. Or alternatively you need to enable
uapsd in the last patch so that it won't be used until all the code is
in place.

There are also some sparse warnings:

drivers/net/wireless/ath/ath6kl/wmi.h:232:21: warning: invalid
assignment: |=
drivers/net/wireless/ath/ath6kl/wmi.h:232:21:    left side has type
restricted __le16
drivers/net/wireless/ath/ath6kl/wmi.h:232:21:    right side has type int
drivers/net/wireless/ath/ath6kl/txrx.c:109:36: warning: incorrect type
in assignment (different base types)
drivers/net/wireless/ath/ath6kl/txrx.c:109:36:    expected unsigned
short [unsigned] [usertype] ether_type
drivers/net/wireless/ath/ath6kl/txrx.c:109:36:    got restricted __be16
[usertype] h_proto
drivers/net/wireless/ath/ath6kl/txrx.c:110:29: warning: cast to
restricted __be16
drivers/net/wireless/ath/ath6kl/txrx.c:110:29: warning: cast to
restricted __be16
drivers/net/wireless/ath/ath6kl/txrx.c:110:29: warning: cast to
restricted __be16
drivers/net/wireless/ath/ath6kl/txrx.c:110:29: warning: cast to
restricted __be16
drivers/net/wireless/ath/ath6kl/txrx.c:117:44: warning: incorrect type
in assignment (different base types)
drivers/net/wireless/ath/ath6kl/txrx.c:117:44:    expected unsigned
short [unsigned] [usertype] ether_type
drivers/net/wireless/ath/ath6kl/txrx.c:117:44:    got restricted __be16
[usertype] eth_type
drivers/net/wireless/ath/ath6kl/txrx.c:121:43: warning: restricted
__be16 degrades to integer
drivers/net/wireless/ath/ath6kl/txrx.c:1360:41: warning: restricted
__le16 degrades to integer

And please use your full name in the signed off by line.

Kalle
