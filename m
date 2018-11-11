Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F6BC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 14:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F5C720871
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 14:04:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ePOUva+D";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ePOUva+D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F5C720871
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbeKKXwO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 18:52:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbeKKXwN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 18:52:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DF0D76086B; Sun, 11 Nov 2018 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541945013;
        bh=N4+2d0YLhR7J+kknMhuYc438Cwg5CZ5JKz/ByDy3Rs4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ePOUva+DHB8CDLRrQDFanGL0AtWgJ+zZdEyf5XDnHcUTeB/KwnCVSqF885I4RYagS
         hAl4HaboGOB0b0/lBVSWRORmJcQtXRd05DMBQLHrf1MHFp3AseBHviyxu9+8FlijMX
         TwP0+Q4+TNJjt1Z8RAlX8LPxsSWVawPcFjajD5vM=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 8707260249;
        Sun, 11 Nov 2018 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541945013;
        bh=N4+2d0YLhR7J+kknMhuYc438Cwg5CZ5JKz/ByDy3Rs4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ePOUva+DHB8CDLRrQDFanGL0AtWgJ+zZdEyf5XDnHcUTeB/KwnCVSqF885I4RYagS
         hAl4HaboGOB0b0/lBVSWRORmJcQtXRd05DMBQLHrf1MHFp3AseBHviyxu9+8FlijMX
         TwP0+Q4+TNJjt1Z8RAlX8LPxsSWVawPcFjajD5vM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 11 Nov 2018 19:33:33 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] mac80211: Implement functionality to monitor
 station's signal stregnth
In-Reply-To: <f9be46875c90f00a79f03838944bbf23f05d2c0d.camel@sipsolutions.net>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
 <1539626250-769-4-git-send-email-tamizhr@codeaurora.org>
 <f9be46875c90f00a79f03838944bbf23f05d2c0d.camel@sipsolutions.net>
Message-ID: <46190175cf4e7cf054ee15aef5ea1890@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-09 17:25, Johannes Berg wrote:
> Oh, umm, that patch is still here ...
> 
> I guess we can combine 2 and 3 too.
> 
> 
Sure.

>> +	if (sta->rssi_low && bss_conf->enable_beacon) {
>> +		int last_event =
>> +			sta->last_rssi_event_value;
>> +		int sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
>> +		int low = sta->rssi_low;
>> +		int high = sta->rssi_high;
> 
> This doesn't really support a list, like in patch 2 where you store
> sta_info::rssi_tholds?
> 
rssi_low and rssi_high will have a configured value or zero know ? 
Configured value has been stored in the previous patch.

>> +		if (sig < low &&
>> +		    (last_event == 0 || last_event >= low)) {
>> +			sta->last_rssi_event_value = sig;
>> +			cfg80211_sta_mon_rssi_notify(
>> +				rx->sdata->dev, sta->addr,
>> +				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
>> +				sig, GFP_ATOMIC);
>> +			rssi_cross = true;
>> +		} else if (sig > high &&
>> +			   (last_event == 0 || last_event <= high)) {
>> +			sta->last_rssi_event_value = sig;
>> +			cfg80211_sta_mon_rssi_notify(
>> +				rx->sdata->dev, sta->addr,
>> +				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
>> +				sig, GFP_ATOMIC);
>> +			rssi_cross = true;
>> +		}
>> +	}
>> +
>> +	if (rssi_cross) {
>> +		ieee80211_update_rssi_config(sta);
>> +		rssi_cross = false;
>> +	}
>> +}
> 
> Ah, but it does, just hard to understand.
> 
> However, this does mean what I suspected on the other patch is true -
> you're calling ieee80211_update_rssi_config() here, and that uses the
> sta->rssi_tholds array without any protection, while a concurrent 
> change
> of configuration can free the data.
> 
yes, I'll add a protection mechanism.

> You need to sort that out. I would suggest to stick all the sta->rssi_*
> fields you add into a new struct (you even had an empty one), and
> protect that struct using RCU. That also saves the memory in case it's
> not assigned at all. Something like
> 
> struct sta_mon_rssi_config {
> 	struct rcu_head rcu_head;
> 	int n_thresholds;
> 	s32 low, high;
> 	u32 hyst;
> 	s32 last_value;
> 	s32 thresholds[];
> };
> 
> then you can kfree_rcu() it, and just do a single allocation using
> struct_size() for however many entries you need.
> 
Yes correct. I'll change it.

>> + * @count_rx_signal: Number of data frames used in averaging station 
>> signal.
>> + *	This can be used to avoid generating less reliable station rssi 
>> cross
>> + *	events that would be based only on couple of received frames.
>>   */
>>  struct sta_info {
>>  	/* General information, mostly static */
>> @@ -600,6 +603,7 @@ struct sta_info {
>>  	s32 rssi_high;
>>  	u32 rssi_hyst;
>>  	s32 last_rssi_event_value;
>> +	unsigned int count_rx_signal;
> 
> I guess that would also move into the new struct.
> 
Okay.

Thanks,
Tamizh.
