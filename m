Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39742 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab2BHTiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 14:38:04 -0500
Message-ID: <4F32CF18.4010300@openwrt.org> (sfid-20120208_203808_532275_E6520F31)
Date: Wed, 08 Feb 2012 20:38:00 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	arend@broadcom.com
Subject: Re: [PATCH] mac80211: do not call rate control .tx_status before
 .rate_init
References: <1328725031-35464-1-git-send-email-nbd@openwrt.org> <20120208192536.GB2929@tuxdriver.com>
In-Reply-To: <20120208192536.GB2929@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-08 8:25 PM, John W. Linville wrote:
> On Wed, Feb 08, 2012 at 07:17:11PM +0100, Felix Fietkau wrote:
>> Most rate control implementations assume .get_rate and .tx_status are only
>> called once the per-station data has been fully initialized.
>> minstrel_ht crashes if this assumption is violated.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Tested-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>  net/mac80211/rate.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
>> index 5fc3135..fbb1efd 100644
>> --- a/net/mac80211/rate.h
>> +++ b/net/mac80211/rate.h
>> @@ -37,7 +37,7 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
>>  	struct ieee80211_sta *ista = &sta->sta;
>>  	void *priv_sta = sta->rate_ctrl_priv;
>>  
>> -	if (!ref)
>> +	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
>>  		return;
>>  
>>  	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
> 
> Any reason not to apply this for 3.3?  Or stable?
I think 3.3 doesn't have that sta flag, the issue was probably
introduced with the 3.4 changes.
I don't remember something like this appearing in earlier versions.

- Felix
