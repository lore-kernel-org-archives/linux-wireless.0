Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:59412 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2C1HFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 03:05:16 -0400
Message-ID: <4F72B829.4040105@tieto.com> (sfid-20120328_090521_068454_6F0DC80C)
Date: Wed, 28 Mar 2012 09:05:13 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] mac80211: prepare ieee80211_sta_get_rates to per-vif
References: <1332856558-5708-1-git-send-email-michal.kazior@tieto.com>	 <1332856558-5708-3-git-send-email-michal.kazior@tieto.com> <1332860821.3501.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332860821.3501.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2012-03-27 at 15:55 +0200, Michal Kazior wrote:
>
>> -u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
>> +u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
>>   			    struct ieee802_11_elems *elems,
>>   			    enum ieee80211_band band)
>>   {
>> +	struct ieee80211_local *local = sdata->local;
>>   	struct ieee80211_supported_band *sband;
>>   	struct ieee80211_rate *bitrates;
>>   	size_t num_rates;
>
> Ditto here, though I actually got confused even further ... we shouldn't
> remove the local/sdata arguments, we should only remove the use of
> local->hw.conf.channel! IOW simply something like this:
>
> -       if (!sband) {
> -               WARN_ON(1);
> -               sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
> -       }
> +       if (WARN_ON(!sband))
> +               return 1;
>
> should be sufficient instead of doing all the prototype changes?

You're right. I'll resend a new patchset.


-- Pozdrawiam / Best regards, Michal Kazior.
