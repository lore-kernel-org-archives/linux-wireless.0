Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:54657 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaAFPHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:07:52 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so15440856wes.26
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 07:07:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389020664.5891.18.camel@jlt4.sipsolutions.net>
References: <82A67CC48AF04D43A69EB66645975134107C6285@hbmail01.hb.imgtec.org> <1389020664.5891.18.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 6 Jan 2014 20:37:30 +0530
Message-ID: <CABPxzYKhqMoMS=ONT42-qQ7SBzxViRFtYmn9yahF0-skj9Cedw@mail.gmail.com> (sfid-20140106_160755_223855_93C64C67)
Subject: Re: [PATCH] mac80211: Return untuned timestamp in case of invalid bitrates
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chaitanya Tata <Chaitanya.Tata@imgtec.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 6, 2014 at 8:34 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-12-26 at 13:42 +0000, Chaitanya Tata wrote:
>> In case the driver sends MCS9 and doesn't advertise CBW
>> (or) advertises 20MHz bandwidth, return the timestamp As is,
>> instead of returning 0 as timestamp.
>>
>> Signed-off-by: Chaitanya T K <Chaitanya.mgit@gmail.com>
>> ---
>> net/mac80211/util.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/mac80211/util.c b/net/mac80211/util.c index 06265d7..bc92b25 100644
>> --- a/net/mac80211/util.c
>> +++ b/net/mac80211/util.c
>> @@ -2265,7 +2265,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
>>       if (WARN_ONCE(!rate,
>>                     "Invalid bitrate: flags=0x%x, idx=%d, vht_nss=%d\n",
>>                     status->flag, status->rate_idx, status->vht_nss))
>> -             return 0;
>> +             return ts;
>
> I think this is wrong - we've already warned, we know we have no usable
> timestamp, and this should never happen anyway.

Timestamp is just off by packet length (as we dont have proper MCS rates),
but still we can use it as un-rewinded timestamp.
