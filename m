Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:36435 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbcLALcb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 06:32:31 -0500
Received: by mail-yw0-f181.google.com with SMTP id a10so183390761ywa.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 03:32:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480424369.10012.6.camel@sipsolutions.net>
References: <1479887968-17473-1-git-send-email-chiu@endlessm.com> <1480424369.10012.6.camel@sipsolutions.net>
From: Chris Chiu <chiu@endlessm.com>
Date: Thu, 1 Dec 2016 19:24:54 +0800
Message-ID: <CAB4CAwfJeE15nhXuLi_V-FYeCj4wj=1ojij+pwZ8V7=gdER76Q@mail.gmail.com> (sfid-20161201_123235_165246_7D2AA2DD)
Subject: Re: [PATCH] mac80211: fix Tx BA session stuck issue during sw scanning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux@endlessm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 29, 2016 at 8:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2016-11-23 at 15:59 +0800, Chris Chiu wrote:
>> ieee80211_iface_work() will check if sw scanning is in progress
>> before handling block ack session. In our case, the RTL8821AE
>> operate in station mode, when tx session expired, DELBA packet
>> stuck during sw scanning and so do other data packets.
>>
>> ieee80211_scan_state_decision() will take lots of time in
>> SCAN_SUSPEND/SCAN_RESUME state due to !tx_empty or bad_latency.
>> Then the sw scanning mostly take > 20 seconds to finish or even
>> worse in our case RTL8821AE have 37 channels for 2G+5G to scan
>> and tx stalls ~300 seconds. AP side still thinks the connection
>> is alive because it still receives the QoS NULL packet from STA.
>> So the link state will never change but actually no data tx/rx
>> during this long time.
>>
>> This commit tries to send out packet in SCAN_SUSPEND state so the
>> sw scanning can complete more efficiently and less affect on Block
>> Ack session handling. Verified on RTL8821AE for > 30000 pings and
>> no Tx BA session stuck observed.
>
> The premise seems fairly reasonable, although I'm a little worried that
> if so much new traffic is coming in we never finish the scan suspend?
> Actually, the queues are still stopped, so it's only management frames
> that can come in, so that should be ok?
>

Actually it will finish scan eventually and back to SCAN_DECISION
state but almost 20~30 seconds elapsed. The local->scanning should be
cleared after all channels been scanned. However, from the debug
messages I added in ieee80211_iface_work(), it still returns when
check local->scanning and the DELBA still has no chance to be
transferred then stuck again at the next scan state machine. Supposed
to be another scan request issued but I don't know who's the killer.
Except to find who issue the next scan request, BA session have no
chance to reset in this long scan period (>20s) still need to be taken
care.

>> +     test_and_clear_bit(SCAN_SUSPEND_SCANNING, &local->scanning);
>>
>
> That makes no sense, you're not checking the return value, just clear
> the bit without test.
>
>> @@ -844,6 +846,8 @@ static void ieee80211_scan_state_suspend(struct
>> ieee80211_local *local,
>>       /* disable PS */
>>       ieee80211_offchannel_return(local);
>>
>> +     __set_bit(SCAN_SUSPEND_SCANNING, &local->scanning);
>
> Why are you using the non-atomic version here, vs. the atomic one
> above?
>
You're right. I just want to clear_bit and set_bit in this case, sorry
for that confusing. Or any better suggestion?

> johannes
