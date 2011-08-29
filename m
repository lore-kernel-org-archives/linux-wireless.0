Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42158 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1H2Tnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 15:43:42 -0400
Received: by yie30 with SMTP id 30so3823447yie.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 12:43:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314598866.4562.2.camel@jlt3.sipsolutions.net>
References: <1314265865-20208-1-git-send-email-arik@wizery.com> <1314598866.4562.2.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 29 Aug 2011 22:43:24 +0300
Message-ID: <CA+XVXfeA-8PSwMyib1Sk-EJXDTjJ3hMiRVQExNsumfSc_jS3tA@mail.gmail.com> (sfid-20110829_214350_935306_F1A82117)
Subject: Re: [PATCH 1/2] mac80211: add flag to indicate HW only Tx-agg support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 09:21, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-08-25 at 12:51 +0300, Arik Nemtsov wrote:
>> When this flag is set, Tx aggregations will not be initiated even
>> if the hardware supports A-MPDU aggregation in general. This flag
>> is required for devices supporting (partial) software Rx-aggregation.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>>  include/net/mac80211.h |    4 ++++
>>  net/mac80211/agg-tx.c  |    3 ++-
>>  net/mac80211/debugfs.c |    2 ++
>>  net/mac80211/tx.c      |    3 ++-
>>  4 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 2f01d84..b21a5bb 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -1094,6 +1094,9 @@ enum sta_notify_cmd {
>>   *   stations based on the PM bit of incoming frames.
>>   *   Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
>>   *   the PS mode of connected stations.
>> + *
>> + * @IEEE80211_HW_TX_AMPDU_IN_HW_ONLY: The device handles TX aggregation
>> + *   strictly in HW. Packets should not be aggregated in software.
>
> In addition to the discussion with Helmut -- this is also misleading
> since mac80211 doesn't, right now, aggregate anything in software -- it
> just handles session setup (which is what you don't want).

Sure. I'll rename it to something like
IEEE80211_HW_TX_AMPDU_SETUP_IN_HW (and change the description).

Arik
