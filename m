Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:51805 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZBXSkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 13:40:36 -0500
Received: by fxm11 with SMTP id 11so3038347fxm.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 10:40:33 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/3] mac80211: decrease execution of the associated timer
References: <20090223163626.20939.4879.stgit@tikku>
	<20090223163724.20939.22893.stgit@tikku>
	<1235441633.4455.61.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Feb 2009 20:40:12 +0200
In-Reply-To: <1235441633.4455.61.camel@johannes.local> (Johannes Berg's message of "Mon\, 23 Feb 2009 18\:13\:53 -0800")
Message-ID: <87fxi3y8z7.fsf@litku.valot.fi> (sfid-20090224_194039_386996_4AB42EE4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -1078,6 +1078,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data);
>>  void ieee80211_send_nullfunc(struct ieee80211_local *local,
>>  			     struct ieee80211_sub_if_data *sdata,
>>  			     int powersave);
>> +void ieee80211_rx_trigger(struct ieee80211_sub_if_data *sdata);
>
> I think that could have a better name maybe? _sta_rx_notify?

That's a lot better name, I'll rename it.

>> +void ieee80211_rx_trigger(struct ieee80211_sub_if_data *sdata)
>> +{
>> +	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>> +		mod_timer(&sdata->u.mgd.timer,
>> +			  jiffies + IEEE80211_MONITORING_INTERVAL);
>> +	}
>
> Should we have the sta check outside the function? Seems a little odd to
> have a check in a file that only contains STATION mode code.

Actually I first had the check in rx.c, then moved it to mlme.c just
to have less changes in rx.c. But you have a point, I'll move the
check back to rx.c.

> Other than that, looks good to me. I'd have thought this would be more
> complicated :)

Luckily it wasn't, I prefer having simple patches :)

-- 
Kalle Valo
