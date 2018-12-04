Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED855C04EBF
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 14:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 642EF2082B
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 14:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="XvaXP/vt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 642EF2082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbeLDOzv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 09:55:51 -0500
Received: from mail.toke.dk ([52.28.52.200]:51299 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbeLDOzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 09:55:51 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543935348; bh=kybGmhGVR/NmcRX+YnMiYnF1I7IBWiY/UtiHCH/7tZs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XvaXP/vtwEio6vOfQ8m4UIEEyQP8CclKzKmAsEVVPzzoG+ZoO3g3QKLguM/dHyd2p
         rtSWwh5bRQrBFLBlQm/ZEPXMhk0GYd+xLlD1lNwEL8cAt04sZkPK8EqntetWNw72Lp
         jbxmnHVx65o9I2tu4NmbgMtLW2KmoZhwJVpNYMhN+MPSpkzN0jAxIHc6tAr5XZ82Id
         oyd3TvqUUyE31VnaxCrRMlnROgf5tJ0Y9RhFPlQQFIcNLxwx1aLkIvdUGBWAWLgw8x
         VLDI5LTSKUFym1Hpidks7Lgq+pwJdSVVQHCQ+EqMeSjIZR8f0jvBr78DKFEEhaqd6l
         njPqCyaUZFBLw==
To:     Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net
Subject: Re: [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name>
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org> <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org> <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name>
Date:   Tue, 04 Dec 2018 16:55:45 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87in09ibny.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>> index aa4afbf0abaf..a1f1256448f5 100644
>> --- a/net/mac80211/status.c
>> +++ b/net/mac80211/status.c
>> @@ -818,6 +818,12 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
>>  			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data,
>>  						acked, info->status.tx_time);
>>  
>> +		if (info->status.tx_time &&
>> +		    wiphy_ext_feature_isset(local->hw.wiphy,
>> +					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
>> +			ieee80211_sta_register_airtime(&sta->sta, tid,
>> +						       info->status.tx_time, 0);
>> +
>>  		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
>>  			if (info->flags & IEEE80211_TX_STAT_ACK) {
>>  				if (sta->status_stats.lost_packets)
> I think the same is needed in ieee80211_tx_status_ext.

So finally circled back to this. In ieee80211_tx_status_ext() we don't
have an skb, so we don't know which TID the packet was sent to; what
airtime information would the driver actually provide in this case? Is
it an aggregate of all ACs, or?

-Toke
