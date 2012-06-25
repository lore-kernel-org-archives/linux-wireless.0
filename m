Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62849 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab2FYGwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 02:52:34 -0400
Message-ID: <4FE80AB1.7030504@tieto.com> (sfid-20120625_085237_969842_5B21F70E)
Date: Mon, 25 Jun 2012 08:52:33 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 1/7] mac80211: introduce channel contexts skeleton code
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>  <1340280216-18807-2-git-send-email-michal.kazior@tieto.com> <1340285064.4489.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340285064.4489.24.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-06-21 at 14:03 +0200, Michal Kazior wrote:
>
>> +++ b/include/net/mac80211.h
>> @@ -143,6 +143,41 @@ struct ieee80211_low_level_stats {
>>   	unsigned int dot11RTSSuccessCount;
>>   };
>>
>> +
>> +/**
>> + * enum ieee80211_chanctx_mode - channel context configuration mode
>> + *
>> + * @IEEE80211_CHANCTX_SHARED: channel context may be used by
>> + *	multiple interfaces
>> + * @IEEE80211_CHANCTX_EXCLUSIVE: channel context can be used
>> + *	only by a single interface. This can be used for example for
>> + *	non-fixed channel IBSS.
>> + */
>> +enum ieee80211_chanctx_mode {
>> +	IEEE80211_CHANCTX_SHARED,
>> +	IEEE80211_CHANCTX_EXCLUSIVE
>> +};
>
> Does the driver ever care about this? It seems mostly internal to
> determine what's going on?

Why did I put it there I wonder.


>> + * @chanctx_conf: channel context vif is bound to, may be NULL
>
> Maybe say "will be %NULL before the interface is assigned to a channel
> context" or so?
>
>> +	INIT_LIST_HEAD(&ctx->interfaces);
>
> Is there really a need for this list? It seems only moderately less
> efficient to iterate all interfaces and filter by channel context, and
> that's probably easier to maintain?
>
>> +static void
>> +__ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
>> +{
>> +	struct ieee80211_chanctx_conf *conf = sdata->vif.chanctx_conf;
>> +	struct ieee80211_chanctx *ctx =
>> +			container_of(conf, struct ieee80211_chanctx, conf);
>> +
>> +	if (!conf)
>> +		return;
>> +
>> +	ieee80211_unassign_vif_chanctx(sdata, ctx);
>> +	if (list_empty(&ctx->interfaces))
>> +		ieee80211_free_chanctx(ctx);
>> +}
>
> Ah, ok. So I guess there's a good use for the list at least here.

Actually you're right. I'll make it a simple refcount. No need to do 
fancy lists.


-- 
Pozdrawiam / Best regards, Michal Kazior.
