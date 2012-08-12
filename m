Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58642 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab2HLHbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 03:31:31 -0400
Received: by obc16 with SMTP id 16so5261992obc.34
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2012 00:31:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120810163635.GC17559@redhat.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-7-git-send-email-victorg@ti.com>
	<20120810163635.GC17559@redhat.com>
Date: Sun, 12 Aug 2012 10:31:29 +0300
Message-ID: <CAK80WHbVcXtZ0on2Nsfkmj+qQ3jAaPLSc9TvGvuaCoN6P4gAOQ@mail.gmail.com> (sfid-20120812_093206_423531_6BA7F24F)
Subject: Re: [PATCH v3 6/7] mac80211: add ap channel switch command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Why we can not use ->channel_switch calback for this purpose (merge
> ieee80211_channel_switch and ieee80211_ap_ch_switch)?
>

Well at first (see previous threads) it was a single channel switch
for both AP/STA, but later after community reviews it was decided to
split these two.

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
>
> Probably you want to check local->ops->ap_channel_switch.
>

This is the evidence ;).
Good catch and thanks for reviewing.

-- 
Victor.
