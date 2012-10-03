Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:51555 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab2JCNxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 09:53:51 -0400
Received: by obbuo13 with SMTP id uo13so7273966obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 06:53:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347275852.4272.12.camel@jlt4.sipsolutions.net>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-3-git-send-email-victorg@ti.com>
	<1347275852.4272.12.camel@jlt4.sipsolutions.net>
Date: Wed, 3 Oct 2012 15:53:50 +0200
Message-ID: <CAK80WHbVJqqrd0dJ559XZ2XFcK9BG7NOqjxKA3fBVDgHjOAtFA@mail.gmail.com> (sfid-20121003_155355_956286_3B307B06)
Subject: Re: [PATCH v3 2/7] mac80211: add radar detection command/event
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

On Mon, Sep 10, 2012 at 2:17 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-08-08 at 14:53 +0300, Victor Goldenshtein wrote:
>> Add command to trigger radar detection in the driver/FW.
>> Once radar detection is started it should continuously
>> monitor for radars as long as the channel active.
>> If radar is detected usermode notified with 'radar
>> detected' event.
>
>> +     if (!local->ops->start_radar_detection)
>> +             return -EOPNOTSUPP;
>> +
>> +     ret = drv_start_radar_detection(local, sdata, chan);
>> +     return ret;
>
> Remove the ret variable please.
>

ok.

>> +++ b/net/mac80211/iface.c
>> @@ -731,6 +731,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>>               /* free all potentially still buffered bcast frames */
>>               local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps_bc_buf);
>>               skb_queue_purge(&sdata->u.ap.ps_bc_buf);
>> +
>> +             /* reset DFS channel availability check */
>> +             if (local->oper_channel && sdata->wdev.preset_chan) {
>> +                     local->oper_channel->cac_type = 0;
>> +                     /* in case AP hasn't started yet */
>> +                     sdata->wdev.preset_chan->cac_type = 0;
>> +             }
>
> Why is mac80211 modifying cfg80211 fields? cfg80211 also uses this, no?
> This seems strange to me.
>
I will remove the "...preset_chan->cac_type = 0;" line.
We can reset the "preset_chan->cac_type" (or the new cac_started flag)
in __nl80211_set_channel().

>> +DEFINE_EVENT(local_sdata_evt, drv_start_radar_detection,
>> +     TP_PROTO(struct ieee80211_local *local,
>> +              struct ieee80211_sub_if_data *sdata),
>> +     TP_ARGS(local, sdata)
>> +);
>
> Umm, parameters?
>

will add here also the channel frequency.

-- 
Thanks,
Victor.
