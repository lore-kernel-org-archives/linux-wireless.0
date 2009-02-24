Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:49554 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbZBXSxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 13:53:02 -0500
Received: by bwz5 with SMTP id 5so6056734bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 10:52:59 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/3] mac80211: track beacons separately from the rx path activity
References: <20090223163626.20939.4879.stgit@tikku>
	<20090223163731.20939.62567.stgit@tikku>
	<1235441758.4455.64.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Feb 2009 20:52:51 +0200
In-Reply-To: <1235441758.4455.64.camel@johannes.local> (Johannes Berg's message of "Mon\, 23 Feb 2009 18\:15\:58 -0800")
Message-ID: <87bpsry8e4.fsf@litku.valot.fi> (sfid-20090224_195308_011624_C208C42A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2009-02-23 at 18:37 +0200, Kalle Valo wrote:
>
>> @@ -1356,6 +1359,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
>>  	bss_conf->assoc_capability = capab_info;
>>  	ieee80211_set_associated(sdata, changed);
>>  
>> +	ifmgd->last_beacon = jiffies;
>> +
>
> That looks a little misplaced; I think it's actually intended
> anyway?

Yes, it's intended. We need to initialise the variable after a
successful association, otherwise this test in ieee80211_associated()
will trigger immediately:

	if (time_after(jiffies,
		       ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {
		printk(KERN_DEBUG "%s: beacon loss from AP %pM "
		       "- sending probe request\n",
		       sdata->dev->name, ifmgd->bssid);

> Maybe add a comment?

I will.

>> -		sta->last_rx = jiffies;
>> +		if (rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
>> +		    ieee80211_is_beacon(hdr->frame_control)) {
>> +			rx->sdata->u.mgd.last_beacon = jiffies;
>> +		} else
>> +			sta->last_rx = jiffies;
>
> would it be more appropriate to do that in the function that processes
> the beacon in mlme.c? Or does that not work because of the workqueue and
> timing?

The test is there because I didn't want to include beacons to
sta->last_rx timestamp. That way I can send probe requests only during
data path idle period:

	if (time_after(jiffies, sta->last_rx + IEEE80211_PROBE_IDLE_TIME)) {
		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
					 ifmgd->ssid_len, NULL, 0);
	}

sta->last_rx is used in master mode as well, so I might have to do
some trickery if I move the code to mlme.c. But I do share your
view of having mlme related code in mlme.c, it makes life a lot
easier. I need to think this a bit more.

-- 
Kalle Valo
