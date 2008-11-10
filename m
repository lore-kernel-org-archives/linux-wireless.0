Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:56700 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbYKJJg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 04:36:56 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] mac80211: enable IEEE80211_CONF_PS only when associated
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	<1226245439-30329-2-git-send-email-kalle.valo@nokia.com>
	<1226309301.4004.8.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 10 Nov 2008 11:36:06 +0200
In-Reply-To: <1226309301.4004.8.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 10 Nov 2008 10\:28\:21 +0100")
Message-ID: <87r65jzzw9.fsf@nokia.com> (sfid-20081110_103700_575419_9D405B2D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sun, 2008-11-09 at 17:43 +0200, Kalle Valo wrote:
>
>
>> @@ -865,8 +870,14 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>>  	sta_info_destroy(sta);
>>  
>>  	local->hw.conf.ht.enabled = false;
>> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
>> +	config_changed |= IEEE80211_CONF_CHANGE_HT;
>> +
>> +	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
>> +		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
>> +		config_changed |= IEEE80211_CONF_PS;
>> +	}
>
> That latter flag should be CONF_CHANGED_PS.

Oops, I'll fix it. Thanks for finding this.

-- 
Kalle Valo
