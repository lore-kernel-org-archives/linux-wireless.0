Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56497 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934017Ab3DPKo2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 06:44:28 -0400
Message-ID: <516D2B80.70704@openwrt.org> (sfid-20130416_124433_647619_B148B05A)
Date: Tue, 16 Apr 2013 12:44:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 3/5] mac80211: improve the rate control API
References: <1365890626-86895-1-git-send-email-nbd@openwrt.org> <1365890626-86895-2-git-send-email-nbd@openwrt.org> <1365890626-86895-3-git-send-email-nbd@openwrt.org> <20130416095949.GA14259@magnum.frso.rivierawaves.com>
In-Reply-To: <20130416095949.GA14259@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-16 12:03 PM, Karl Beldan wrote:
> On Sun, Apr 14, 2013 at 12:03:44AM +0200, Felix Fietkau wrote:
>> Allow rate control modules to pass a rate selection table to mac80211
>> and the driver. This allows drivers to fetch the most recent rate
>> selection from the sta pointer for already buffered frames. This allows
>> rate control to respond faster to sudden link changes and it is also a
>> step towards adding minstrel_ht support to drivers like iwlwifi.
>> 
>> When a driver sets IEEE80211_HW_SUPPORTS_RC_TABLE, mac80211 will not
>> fill info->control.rates with rates from the rate table (to preserve
>> explicit overrides by the rate control module). The driver then
>> explicitly calls ieee80211_get_tx_rates to merge overrides from
>> info->control.rates with defaults from the sta rate table.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> I gave it a try, I hope you won't mind the feedback for the typos.
> It does not compile:
> error: âstruct ieee80211_tx_dataâ has no member named ârateâ
> it likely misses the diff for ieee80211_i.h, however that's what I did
> to quickly run without IEEE80211_HW_SUPPORTS_RC_TABLE so far.
Thanks. Will fix and send v2 later today.

- Felix

