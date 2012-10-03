Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:49934 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755904Ab2JCNyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 09:54:01 -0400
Received: by obbuo13 with SMTP id uo13so7274144obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 06:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347276337.4272.19.camel@jlt4.sipsolutions.net>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-7-git-send-email-victorg@ti.com>
	<1347276337.4272.19.camel@jlt4.sipsolutions.net>
Date: Wed, 3 Oct 2012 15:54:00 +0200
Message-ID: <CAK80WHZCkj2GHe_b1ofGjdw3SWbibONb05uaJfFntAR+tx7X9g@mail.gmail.com> (sfid-20121003_155459_687039_30934F33)
Subject: Re: [PATCH v3 6/7] mac80211: add ap channel switch command/event
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

On Mon, Sep 10, 2012 at 2:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +static int
>> +ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
>> +                             struct net_device *dev,
>> +                             struct ieee80211_ap_ch_switch *ap_ch_switch)
>> +{
>> +     struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +     struct ieee80211_local *local = sdata->local;
>> +
>> +     if (!local->ops->channel_switch)
>> +             return -EOPNOTSUPP;
>> +
>> +     if (!ap_ch_switch || !ap_ch_switch->channel)
>> +             return -EINVAL;
>> +
>> +     drv_ap_channel_switch(local, ap_ch_switch);
>> +     return 0;
>
> errors are not possible?
>

driver is not allowed to fail here.

>> +void ieee80211_ap_ch_switch_done(struct ieee80211_vif *vif,
>> +                              struct ieee80211_channel *new_channel,
>> +                              enum nl80211_channel_type type)
>> +{
>> +     struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
>> +     struct ieee80211_local *local = sdata->local;
>> +
>> +     if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
>> +             return;
>> +
>> +     /* update the device channel directly */
>> +     mutex_lock(&local->mtx);
>> +     local->oper_channel = local->hw.conf.channel = new_channel;
>> +     local->_oper_channel_type = type;
>> +     mutex_unlock(&local->mtx);
>> +
>> +     cfg80211_ch_switch_notify(sdata->dev, new_channel->center_freq, type);
>> +     trace_api_ap_ch_switch_done(sdata, new_channel->center_freq);
>
> tracing last seems very strange
>

will reorder.

-- 
Thanks,
Victor.
