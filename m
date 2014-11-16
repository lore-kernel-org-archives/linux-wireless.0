Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37901 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbaKPLB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2014 06:01:27 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so22807070wgg.5
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2014 03:01:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141113225528.GE24486@wotan.suse.de>
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
 <1415895219-19848-2-git-send-email-arik@wizery.com> <20141113225528.GE24486@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 16 Nov 2014 13:01:11 +0200
Message-ID: <CA+XVXfeLd9YN6CQFN1aPix4Ee_fWSZAmZP0jqOu98eC7wGBcUQ@mail.gmail.com> (sfid-20141116_120130_659140_490D1246)
Subject: Re: [PATCH v2 2/4] cfg80211: update missing fields in custom
 regulatory path
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2014 at 12:55 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Nov 13, 2014 at 06:13:37PM +0200, Arik Nemtsov wrote:
>> From: Jonathan Doron <jond@wizery.com>
>>
>> Some channels fields were not being updated in the custom regulatory
>> path. Update them according to the code in handle_channel().
>>
>> Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>> ---
>>  net/wireless/reg.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 6459ddd..174d8f82 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -1693,10 +1693,23 @@ static void handle_channel_custom(struct wiphy *wiphy,
>>       if (max_bandwidth_khz < MHZ_TO_KHZ(160))
>>               bw_flags |= IEEE80211_CHAN_NO_160MHZ;
>>
>> +     chan->dfs_state = NL80211_DFS_USABLE;
>
> NL80211_DFS_USABLE is 0 so this is not needed. Being explicit about it
> is OK I suppose though.
>
>> +     chan->dfs_state_entered = jiffies;
>
> OK.
>
>> +
>> +     chan->beacon_found = false;
>
> false is 0 so this is not needed but being explicit about it is OK.
>
>>       chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
>>       chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
>>       chan->max_reg_power = chan->max_power =
>>               (int) MBM_TO_DBM(power_rule->max_eirp);
>> +
>> +     if (chan->flags & IEEE80211_CHAN_RADAR) {
>> +             if (reg_rule->dfs_cac_ms)
>> +                     chan->dfs_cac_ms = reg_rule->dfs_cac_ms;
>> +             else
>> +                     chan->dfs_cac_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
>> +     }
>> +
>> +     chan->max_power = chan->max_reg_power;
>>  }
>
> I rather you split this up into the stuff not required (things which
> are good to be explicit about) Vs possible fixes, these last are
> good fixes. Also put them as part of your first set of patches
> and add my Acked-by so Johannes can already merge them. If you want
> them merged faster just send them separately now.
>
> Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

Thanks.

I'll split into 2 and send then.

Arik
