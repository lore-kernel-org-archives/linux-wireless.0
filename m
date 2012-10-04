Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:50209 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965618Ab2JDPmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 11:42:15 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so600184oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2012 08:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK80WHZCkj2GHe_b1ofGjdw3SWbibONb05uaJfFntAR+tx7X9g@mail.gmail.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-7-git-send-email-victorg@ti.com>
	<1347276337.4272.19.camel@jlt4.sipsolutions.net>
	<CAK80WHZCkj2GHe_b1ofGjdw3SWbibONb05uaJfFntAR+tx7X9g@mail.gmail.com>
Date: Thu, 4 Oct 2012 17:42:14 +0200
Message-ID: <CAK80WHZ6ZgJP7c_YTX2EXjn42KgpeZ62VYKSJNeP-yujTnCG1Q@mail.gmail.com> (sfid-20121004_174219_152859_FC378E07)
Subject: Re: [PATCH v3 6/7] mac80211: add ap channel switch command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 3, 2012 at 3:54 PM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Mon, Sep 10, 2012 at 2:25 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>>
>>> +static int
>>> +ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
>>> +                             struct net_device *dev,
>>> +                             struct ieee80211_ap_ch_switch *ap_ch_switch)
>>> +{
>>> +     struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>>> +     struct ieee80211_local *local = sdata->local;
>>> +
>>> +     if (!local->ops->channel_switch)
>>> +             return -EOPNOTSUPP;
>>> +
>>> +     if (!ap_ch_switch || !ap_ch_switch->channel)
>>> +             return -EINVAL;
>>> +
>>> +     drv_ap_channel_switch(local, ap_ch_switch);
>>> +     return 0;
>>
>> errors are not possible?
>>
>
> driver is not allowed to fail here.
>
on second thought ;) can't see why we can't propagate driver's return
value to userspace, which will deal with the error code.

-- 
Thanks,
Victor.
