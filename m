Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1HJUCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 16:02:45 -0400
Subject: Re: [PATCH 1/2] mac80211: make ieee80211_send_bar available for
 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
In-Reply-To: <1313005527-83182-1-git-send-email-nbd@openwrt.org>
References: <1313005527-83182-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 22:02:39 +0200
Message-ID: <1313006559.4016.1.camel@jlt3.sipsolutions.net> (sfid-20110810_220249_216739_EC9BEB90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 13:45 -0600, Felix Fietkau wrote:
> To properly maintain the peer's block ack window, the driver needs to be
> able to control the new starting sequence number that is sent along with
> the BlockAckReq frame.

I guess with the ath9k patch I understand ... I believe iwlwifi
processes all of the TX status and only sets the BAR flag on the last
one?

> +/**
> + * ieee80211_send_bar - send a BlockAckReq frame
> + *
> + * can be used to flush pending frames from the peer's aggregation reorder
> + * buffer.
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + * @ra: the peer's destination address
> + * @tid: the TID of the aggregation session
> + * @ssn: the new starting sequence number for the receiver
> + */
> +void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);

You might want to note the locking rules, it's a little strange here
since it calls right back into the driver's tx(). Though of course the
same also happens with tx_status(), it might be less expected here,
especially if you use tx_status_irqsafe() and this doesn't yet have an
irqsafe version.

johannes

