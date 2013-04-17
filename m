Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:32971 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3DQQCd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 12:02:33 -0400
Message-ID: <516EC796.8040008@openwrt.org> (sfid-20130417_180236_697235_EEF18CAD)
Date: Wed, 17 Apr 2013 18:02:30 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2 3/5] mac80211: improve the rate control API
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org> <1366112326-92981-3-git-send-email-nbd@openwrt.org> <20130417154640.GC4319@magnum.frso.rivierawaves.com>
In-Reply-To: <20130417154640.GC4319@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-17 5:46 PM, Karl Beldan wrote:
> On Tue, Apr 16, 2013 at 01:38:44PM +0200, Felix Fietkau wrote:
>> @@ -454,40 +666,27 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
> [...]
>> +int rate_control_set_rates(struct ieee80211_hw *hw,
>> +			   struct ieee80211_sta *pubsta,
>> +			   struct ieee80211_sta_rates *rates)
>> +{
>> +	struct ieee80211_sta_rates *old = rcu_dereference(pubsta->rates);
>> +
>> +	rcu_assign_pointer(pubsta->rates, rates);
>> +	if (old)
>> +		kfree_rcu(old, rcu_head);
> 
> This means the rate control module must allocate a different
> ieee80211_sta_rates right ?
Right.

- Felix

