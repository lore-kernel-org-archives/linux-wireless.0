Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40803 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab1HTS0I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 14:26:08 -0400
Message-ID: <4E4FFC3A.8070706@openwrt.org> (sfid-20110820_202624_613339_5948E0C7)
Date: Sat, 20 Aug 2011 20:26:02 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: make ieee80211_send_bar available for drivers
References: <1313848435-45702-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1313848435-45702-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-20 3:53 PM, Felix Fietkau wrote:
> To properly maintain the peer's block ack window, the driver needs to be
> able to control the new starting sequence number that is sent along with
> the BlockAckReq frame.
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> ---
> turns out that I will need this change in mac80211 anyway to properly
> handle a few corner cases wrt. aggregation and off-channel activity.
>
> When ath9k goes off-channel it may need to drop some packets that are
> still part of the BAW, but at that point in time it would be a very
> bad idea to try to send BAR frames. Instead I want to send the BAR
> after switching back to the primary channel as a kind of barrier before
> sending more packets.
Johannes, do you think it would make the driver API better if instead of 
exporting this function, I add an ieee80211_bar_get function (similar to 
ieee80211_nullfunc_get or ieee80211_probereq_get) to avoid concerns over 
the missing _ni variant or the weird callchain from the driver back into 
the tx function?

- Felix
