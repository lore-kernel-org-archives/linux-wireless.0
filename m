Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:57407 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756061Ab2JCNxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 09:53:54 -0400
Received: by obbuo13 with SMTP id uo13so7274031obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 06:53:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347276044.4272.14.camel@jlt4.sipsolutions.net>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-5-git-send-email-victorg@ti.com>
	<1347276044.4272.14.camel@jlt4.sipsolutions.net>
Date: Wed, 3 Oct 2012 15:53:53 +0200
Message-ID: <CAK80WHZgaCHcPpV8MqRCozLk7dw1wdaHU2CQcShqeu+rOA1MKw@mail.gmail.com> (sfid-20121003_155500_944109_BC7DEA46)
Subject: Re: [PATCH v3 4/7] mac80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 10, 2012 at 2:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-08-08 at 14:53 +0300, Victor Goldenshtein wrote:
>> Prior starting tx on DFS channels, the DFS master
>> device shall perform a Channel Availability Check
>> to ensure that there is no radar interference on
>> those channels. Once CAC done, the tx can be
>> enabled with ieee80211_dfs_en_tx().
>>
>> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> ---
>>  include/net/mac80211.h    |    4 ++++
>>  net/mac80211/cfg.c        |   15 +++++++++++++++
>>  net/mac80211/driver-ops.h |   14 ++++++++++++++
>>  net/mac80211/trace.h      |    6 ++++++
>>  4 files changed, 39 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index d29c99a..ecdfb6a 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -2266,6 +2266,8 @@ enum ieee80211_rate_control_changed {
>>  * @start_radar_detection: Start radar detection on current operational
>>   *   channel, once started it will continuously monitor for radars as long
>>   *   as the channel active.
>> + * @dfs_en_tx: Once channel pass the DFS initial channel availability check,
>> + *   initiate the tx on the channel with this command.
>
> Please also document (for both!) the fact that they can sleep.
>

ok.

>
>> +DEFINE_EVENT(local_sdata_evt, drv_dfs_en_tx,
>> +     TP_PROTO(struct ieee80211_local *local,
>> +              struct ieee80211_sub_if_data *sdata),
>> +     TP_ARGS(local, sdata)
>> +);
>
> Again, parameters.
>

will add channel frequency.

-- 
Thanks,
Victor.
