Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33757 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab0BEN7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 08:59:31 -0500
Received: by vws20 with SMTP id 20so1271420vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 05:59:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265377296.3613.11.camel@johannes.local>
References: <1265372852-4692-1-git-send-email-vnatarajan@atheros.com>
	 <1265377296.3613.11.camel@johannes.local>
Date: Fri, 5 Feb 2010 19:29:30 +0530
Message-ID: <8e92b4101002050559t2fa3132aiee9397dd4618f0fd@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2 v2] mac80211: Retry null data frame for power
	save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 5, 2010 at 7:11 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> @@ -275,6 +274,19 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>>                       local->dot11FailedCount++;
>>       }
>>
>> +     if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
>> +             (local->hw.flags & IEEE80211_HW_TX_STATUS) &&
>> +             (local->hw.conf.flags & IEEE80211_CONF_PS)) {
>> +             if (info->flags & IEEE80211_TX_STAT_ACK) {
>> +                     local->ps_sdata->u.mgd.flags |=
>> +                                     IEEE80211_STA_NULLFUNC_ACKED;
>> +                     ieee80211_queue_work(&local->hw,
>> +                                      &local->dynamic_ps_enable_work);
>> +             } else
>> +                     mod_timer(&local->dynamic_ps_timer, jiffies +
>> +                                     msecs_to_jiffies(10));
>> +     }
>> +
>>       /* this was a transmitted frame, but now we want to reuse it */
>>       skb_orphan(skb);
> And the mod_timer case is completely useless there anyway, at least the
> way you've done this now.
Ah, right! Thanks for pointing it out.

Vivek.
