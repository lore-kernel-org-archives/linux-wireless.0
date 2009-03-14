Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:53107 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZCNRz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:55:27 -0400
Message-ID: <49BBEF78.4030306@nokia.com> (sfid-20090314_185546_318483_80E8BFF3)
Date: Sat, 14 Mar 2009 19:55:04 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
References: <20090314171234.11126.21125.stgit@tikku>	 <20090314171452.11126.11618.stgit@tikku> <1237051725.5235.104.camel@johannes.local>
In-Reply-To: <1237051725.5235.104.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:
> 
>> +void ieee80211_beacon_loss(struct ieee80211_hw *hw)
>> +{
>> +	struct ieee80211_local *local = hw_to_local(hw);
>> +	struct ieee80211_sub_if_data *sdata;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry(sdata, &local->interfaces, list) {
>> +		if (sdata->vif.type != NL80211_IFTYPE_STATION)
>> +			continue;
>> +
>> +		queue_work(local->hw.workqueue,
>> +			   &sdata->u.mgd.beacon_loss_work);
>> +	}
>> +	rcu_read_unlock();
>> +}
>> +EXPORT_SYMBOL(ieee80211_beacon_loss);
> 
> Shouldn't the driver just pass the relevant vif pointer?

Nice, that way the implementation would be a lot simpler and consistent 
with the rest of the driver interface. Yes, I'll change it to use vif 
pointer.

Kalle
