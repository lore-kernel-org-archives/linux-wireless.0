Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55728 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab1IHJIX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 05:08:23 -0400
Message-ID: <4E688601.2020505@openwrt.org> (sfid-20110908_110833_700079_432CEB05)
Date: Thu, 08 Sep 2011 11:08:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211: Don't aggregate rate probe frames in minstrel_ht
References: <1315472282-21051-1-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1315472282-21051-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-08 10:58 AM, Helmut Schaa wrote:
> This is already done by rt2x00 and ath9k by checking the
> IEEE80211_TX_CTL_RATE_CTRL_PROBE flag. Instead we can simply do it in
> minstrel_ht.
>
> Signed-off-by: Helmut Schaa<helmut.schaa@googlemail.com>
> ---
>
> Felix, I didn't have a closer look at the ath9k aggregation code but I guess it
> can also be simplified with this change.
>
> Any objections?
Yes, this probably breaks ath9k. IEEE80211_TX_CTL_AMPDU is used to 
indicate that the packet is part of an aggregation session, so ath9k 
only does block ack window tracking for packets that have this flag set.
I think the drivers should continue to check for 
IEEE80211_TX_CTL_RATE_CTRL_PROBE

- Felix
