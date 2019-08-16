Return-Path: <SRS0=l5SL=WM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89B0C3A59C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 13:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 898F82064A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 13:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="n3vxXvv3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfHPNE3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Aug 2019 09:04:29 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:48060 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfHPNE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Aug 2019 09:04:28 -0400
Received: from [192.168.1.47] (unknown [50.34.200.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id DD83213C2B8;
        Fri, 16 Aug 2019 06:04:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DD83213C2B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1565960668;
        bh=YUeGXcuvmlmmbdu+FPhhkiVI63heFaQq9wdiG4/bs3Q=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=n3vxXvv3lbNdUD9V2yUAlnbgZN6O8yR9XNjVzTzwsBenI94fzcHx6TOVMIRp6tHSE
         s8M4qvn6doLxHadK14LDxNjVZuCqH6xYsWRs9gbb5CU4CTJjNMBXiuat0iPCdYa34l
         k1AejRsE4s6TTM1oZocx1/dm2wzDBFA8s6oaM8KQ=
Subject: Re: [PATCH 2/2] mac80211: add assoc-at support.
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        linux-wireless@vger.kernel.org
References: <20190809174656.20872-1-greearb@candelatech.com>
 <20190809174656.20872-2-greearb@candelatech.com>
 <0fc19972-385e-084e-144d-d5bf41a21ca5@newmedia-net.de>
Cc:     johannes@sipsolutions.net
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <538cc1cd-7e72-d5d1-431d-332378413d99@candelatech.com>
Date:   Fri, 16 Aug 2019 06:04:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <0fc19972-385e-084e-144d-d5bf41a21ca5@newmedia-net.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 08/15/2019 09:09 PM, Sebastian Gottschall wrote:
> is this feature neccessary? we already have the information of the assoc duration time. so its easy to calculate the assoc timestamp using the current time without any patch
> do i miss something here?

The current reported timer is 1-sec resolution, and I need better precision so I can
know exactly how long a station was off the air while trying to roam, for instance.

Thanks,
Ben

>
> Am 09.08.2019 um 19:46 schrieb greearb@candelatech.com:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Report timestamp for when sta becomes associated.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   net/mac80211/sta_info.c | 3 +++
>>   net/mac80211/sta_info.h | 2 ++
>>   2 files changed, 5 insertions(+)
>>
>> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
>> index cd88c8872372..f0820f058b5f 100644
>> --- a/net/mac80211/sta_info.c
>> +++ b/net/mac80211/sta_info.c
>> @@ -1995,6 +1995,7 @@ int sta_info_move_state(struct sta_info *sta,
>>       case IEEE80211_STA_ASSOC:
>>           if (sta->sta_state == IEEE80211_STA_AUTH) {
>>               set_bit(WLAN_STA_ASSOC, &sta->_flags);
>> +            sta->assoc_at_ms = ktime_to_ms(ktime_get_real());
>>               ieee80211_recalc_min_chandef(sta->sdata);
>>               if (!sta->sta.support_p2p_ps)
>>                   ieee80211_recalc_p2p_go_ps_allowed(sta->sdata);
>> @@ -2224,6 +2225,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
>>                BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
>>                BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
>>                BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME) |
>> +             BIT_ULL(NL80211_STA_INFO_ASSOC_AT_MS) |
>>                BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
>>         if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>> @@ -2232,6 +2234,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
>>       }
>>         sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
>> +    sinfo->assoc_at_ms = sta->assoc_at_ms;
>>       sinfo->inactive_time =
>>           jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta));
>>   diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
>> index bb02d5fac7ba..906b11acb0e8 100644
>> --- a/net/mac80211/sta_info.h
>> +++ b/net/mac80211/sta_info.h
>> @@ -468,6 +468,7 @@ struct ieee80211_sta_rx_stats {
>>    *    the station when it leaves powersave or polls for frames
>>    * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
>>    * @txq_buffered_tids: bitmap of TIDs that mac80211 has txq data buffered on
>> + * @assoc_at_ms: time (in ms) of last association
>>    * @last_connected: time (in seconds) when a station got connected
>>    * @last_seq_ctrl: last received seq/frag number from this STA (per TID
>>    *    plus one for non-QoS frames)
>> @@ -565,6 +566,7 @@ struct sta_info {
>>       unsigned long driver_buffered_tids;
>>       unsigned long txq_buffered_tids;
>>   +    unsigned long assoc_at_ms;
>>       long last_connected;
>>         /* Updated from RX path only, no locking requirements */
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
