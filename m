Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33081 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbcBWOW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 09:22:56 -0500
Message-ID: <1456237373.9910.18.camel@sipsolutions.net> (sfid-20160223_152300_024918_B78CBD6F)
Subject: Re: [PATCH] mac80211:  Let VHT work on 2.4Ghz
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Date: Tue, 23 Feb 2016 15:22:53 +0100
In-Reply-To: <56CC6A35.5000900@candelatech.com>
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
	 <1456236627.9910.10.camel@sipsolutions.net>
	 <56CC6A35.5000900@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 06:18 -0800, Ben Greear wrote:

> [root@ben-ota2 lanforge]# iw phy wiphy0 info
> Wiphy wiphy0
> 
> 	Band 1:
[...]
> 		VHT Capabilities (0x338001b2):
> 			Max MPDU length: 11454
> 			Supported Channel Width: neither 160 nor 80+80
> 			RX LDPC
> 			short GI (80 MHz)
> 			TX STBC
> 			RX antenna pattern consistency
> 			TX antenna pattern consistency
> 		VHT RX MCS set:
> 			1 streams: MCS 0-9
> 			2 streams: MCS 0-9
> 			3 streams: MCS 0-9
> 			4 streams: not supported
> 			5 streams: not supported
> 			6 streams: not supported
> 			7 streams: not supported
> 			8 streams: not supported
> 		VHT RX highest supported: 0 Mbps
> 		VHT TX MCS set:
> 			1 streams: MCS 0-9
> 			2 streams: MCS 0-9
> 			3 streams: MCS 0-9
> 			4 streams: not supported
> 			5 streams: not supported
> 			6 streams: not supported
> 			7 streams: not supported
> 			8 streams: not supported
> 		VHT TX highest supported: 0 Mbps

> 		Frequencies:
> 			* 2412 MHz [1] (30.0 dBm)
> 
[...]

Oops. Well, the driver isn't supposed to do that, this is certainly
non-spec behaviour.

johannes
