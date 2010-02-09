Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab0BIIg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 03:36:58 -0500
Received: by vws12 with SMTP id 12so210318vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 00:36:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265702244.3783.16.camel@johannes.berg>
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
	 <1265702244.3783.16.camel@johannes.berg>
Date: Tue, 9 Feb 2010 14:06:57 +0530
Message-ID: <8e92b4101002090036g5f672005mda7389da8db1e322@mail.gmail.com>
Subject: Re: [PATCH v3] mac80211: Retry null data frame for power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 9, 2010 at 1:27 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2010-02-08 at 17:47 +0530, Vivek Natarajan wrote:
>> +     if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
>> +             (local->hw.flags & IEEE80211_HW_TX_STATUS) &&
>> +             local->ps_sdata && !(local->scanning)) {
>> +             if (info->flags & IEEE80211_TX_STAT_ACK) {
>> +                     local->ps_sdata->u.mgd.flags |=
>> +                                     IEEE80211_STA_NULLFUNC_ACKED;
>> +                     ieee80211_queue_work(&local->hw,
>> +                                      &local->dynamic_ps_enable_work);
>> +             } else
>> +                     mod_timer(&local->dynamic_ps_timer, jiffies +
>> +                                     msecs_to_jiffies(10));
>> +     }
>
> I think this needs to check against injected frames as well
Any monitor mode injected frame should be dropped by the
check of ps_sdata which is set only during the station mode.

> personally, I'd prefer if you only indented the stuff belonging into the
> first if by 4 spaces to match up with the "if ("].
Thanks. I will modify it.

> Also, you're still missing documentation on IEEE80211_HW_TX_STATUS.
I think you missed the v4 with the name changed as
IEEE80211_HW_REPORTS_TX_ACK_STATUS.
I will send it once again with modified indentation.

Thanks
Vivek.
