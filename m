Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42214 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab1EFNUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 09:20:23 -0400
Message-ID: <4DC3F58F.4010007@openwrt.org> (sfid-20110506_152026_402492_95C1F8BF)
Date: Fri, 06 May 2011 15:20:15 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, greearb@candelatech.com
Subject: Re: [PATCH 2.6.39] mac80211: always clear PS filtering for non-AP
 interfaces
References: <1304642474-32935-1-git-send-email-nbd@openwrt.org> <201105061508.20010.chunkeey@googlemail.com>
In-Reply-To: <201105061508.20010.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-06 3:08 PM, Christian Lamparter wrote:
> On Friday 06 May 2011 02:41:14 Felix Fietkau wrote:
>>  PS filtering is only useful in AP mode and by setting the flags in mac80211,
>>  vif mode checks do not have to be added to every single driver supporting
>>  this.
>>  Fixes part of a regression introduced in commit 93ae2dd2
>>  "ath9k: assign keycache slots to unencrypted stations"
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  Reported-by: Ben Greear<greearb@candelatech.com>
>>  ---
>>   net/mac80211/tx.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>>  diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>>  index e1a39ed..b301216 100644
>>  --- a/net/mac80211/tx.c
>>  +++ b/net/mac80211/tx.c
>>  @@ -1267,6 +1267,9 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>>   		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>   	else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
>>   		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>  +	else if (sdata->vif.type != NL80211_IFTYPE_AP&&
>>  +	         sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
>>  +		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>
>>   	hdrlen = ieee80211_hdrlen(hdr->frame_control);
>>   	if (skb->len>  hdrlen + sizeof(rfc1042_header) + 2) {
>>
> uh, I think this will break p54* powersave in station mode.
> But why do we set it anyway? It's not like the AP is in PS mode, right?
PS filtering is not meant for station mode at all. It's meant for 
suppressing lots of consecutive excessive retries when in AP mode 
sending traffic to a STA that just entered powersave.

- Felix
