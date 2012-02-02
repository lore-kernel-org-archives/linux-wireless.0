Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:34499 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2BBQG1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 11:06:27 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi8so2042789wib.26
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 08:06:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F277F29.2080205@sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-3-git-send-email-victorg@ti.com>
	<4F277F29.2080205@sipsolutions.net>
Date: Thu, 2 Feb 2012 18:06:25 +0200
Message-ID: <CAK80WHYxJ8zRECnHeYXZtpPO0p7DU1nCLn9c7gzQzEdkouwkrg@mail.gmail.com> (sfid-20120202_170630_629454_8D24E3AF)
Subject: Re: [RFC 2/9] mac80211: add radar detection command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 7:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This name is getting ridiculously long -- no need for the hw_ prefix either.
>

will remove it

>
>> +void ieee80211_radar_detected_notify(struct ieee80211_vif *vif,
>> +                                    u16 freq, gfp_t gfp);
>
>
> Btw, why not a channel pointer? Most APIs use that.
>

I can't find any use for other ieee80211_channel parameters, moreover
the freq parameter is also not required for single channel platforms
because the usermode knows his own operational channel. The freq is
here for future multi-channel DFS support.

>
>> +static int ieee80211_dfs_start_radar_detection(struct wiphy *wiphy,
>> +                                              struct net_device *dev)
>> +{
>> +       struct ieee80211_sub_if_data *sdata =
>> IEEE80211_DEV_TO_SUB_IF(dev);
>> +       struct ieee80211_local *local = sdata->local;
>> +       int ret = -ENOENT;
>
>
> ??? No need for a default value.
>

right, will remove it.

>
>> +       if (!local->ops->hw_dfs_start_radar_detection)
>> +               return -EOPNOTSUPP;
>> +
>> +       mutex_lock(&local->mtx);
>> +       ret = drv_dfs_en_radar_detection(local, sdata);
>> +       mutex_unlock(&local->mtx);
>
>
> Why even lock here? That's not protecting anything.
>

will remove it.


>
>> +static inline int drv_dfs_en_radar_detection(struct ieee80211_local
>> *local,
>> +                                        struct ieee80211_sub_if_data
>> *sdata)
>> +{
>> +       int ret;
>> +
>> +       might_sleep();
>> +
>> +       trace_drv_dfs_en_radar_detection(local, sdata);
>> +       ret =
>> local->ops->hw_dfs_start_radar_detection(&local->hw,&sdata->vif);
>
>
> trace_drv_ret_int()


will change the trace to trace_drv_return_int()


-- 
Thanks,
Victor.
