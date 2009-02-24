Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:56217 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbZBXSaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 13:30:35 -0500
Received: by bwz5 with SMTP id 5so6036510bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 10:30:32 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
References: <20090223163626.20939.4879.stgit@tikku>
	<20090223163738.20939.25890.stgit@tikku>
	<1235442058.4455.71.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Feb 2009 20:30:13 +0200
In-Reply-To: <1235442058.4455.71.camel@johannes.local> (Johannes Berg's message of "Mon\, 23 Feb 2009 18\:20\:58 -0800")
Message-ID: <87ocwry9fu.fsf@litku.valot.fi> (sfid-20090224_193044_793012_1773506B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2009-02-23 at 18:37 +0200, Kalle Valo wrote:
>
>> +void ieee80211_beacon_loss_work(struct work_struct *work)
>> +{
>> +	struct ieee80211_sub_if_data *sdata =
>> +		container_of(work, struct ieee80211_sub_if_data,
>> +			     u.mgd.beacon_loss_work);
>> +
>> +	printk(KERN_DEBUG "%s: beacon loss from AP %pM "
>> +	       "- disassociating\n", sdata->dev->name, sdata->u.mgd.bssid);
>> +
>> +	ieee80211_set_disassoc(sdata, true, true,
>> +			       WLAN_REASON_PREV_AUTH_NOT_VALID);
>> +}
>
> We used to go through a probe request cycle once to make sure, but I'm
> not sure there's a point in that. Just pointing out the change here.

Good catch, I'll fix this in v2.

I'm also not sure if it's good idea to send a probe request when we
have lost beacons. It slows down the AP lost case quite a lot. But
this can be considered in a separate patch, for now I want to have the
same functionality. Most probably I will revisit when I'll start
working with roaming improvements.

> The code looks pretty good, but this will lead to an interesting
> situation where "iwlist wlan1 scan last" ("iw dev wlan1 scan dump") will
> not show _any_ BSS, which will probably trip up NM; this happens because
> the BSS will not be updated and expire after 10 seconds. I think we need
> a way to "hold on" to the BSS.

I'll take a look at this and try to come up with something. 

Thanks for reviewing the patches.

-- 
Kalle Valo
