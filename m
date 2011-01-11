Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54326 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1AKEjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 23:39:54 -0500
Message-ID: <4D2BDF0E.8000808@candelatech.com>
Date: Mon, 10 Jan 2011 20:39:42 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/4] ath9k: fix bogus sequence number increases on aggregation
 tid flush
References: <1294704350-50621-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1294704350-50621-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2011 04:05 PM, Felix Fietkau wrote:
> When a tid pointer is passed to ath_tx_send_normal(), it increases the
> starting sequence number for the next AMPDU action frame, which should
> only be done if the sequence number assignment is fresh. In this case
> it is clearly not.

I added these to my system.  It doesn't seem any worse, but I'm
still seeing my tx-hang logic kick off, so at least some of the
pending queue stuff still has issues I think:

ath: txq: ec731e78 axq_qnum: 2, mac80211_qnum: 2 axq_link:   (null) pending frames: 73 axq_acq empty: 0 stopped: 0 axq_depth: 0  Attempting to restart tx logic.

In general though, my testing is finally starting to surprise with good results
instead of bugs, so I'm quite optimistic these days!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
