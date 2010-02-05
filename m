Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34659 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab0BEMZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 07:25:18 -0500
Received: by ewy28 with SMTP id 28so4202933ewy.28
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 04:25:16 -0800 (PST)
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 2/2] mac80211: Reset dynamic ps timer in Rx path.
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
	<1265266442-6273-2-git-send-email-vnatarajan@atheros.com>
	<87pr4ljs0j.fsf@purkki.valot.fi>
	<8e92b4101002040212k6a8e594ao6191fda61ca867b4@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 05 Feb 2010 14:25:14 +0200
In-Reply-To: <8e92b4101002040212k6a8e594ao6191fda61ca867b4@mail.gmail.com> (Vivek Natarajan's message of "Thu\, 4 Feb 2010 15\:42\:00 +0530")
Message-ID: <87sk9fj2dx.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

>>> +     if ((local->hw.flags & IEEE80211_HW_NEEDS_RX_PS_RESET) &&
>>> +         ieee80211_is_data(hdr->frame_control) &&
>>> +         !is_multicast_ether_addr(hdr->addr1)) {
>>> +             if (local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
>>> +                     mod_timer(&local->dynamic_ps_timer, jiffies +
>>> +                      msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
>>> +             }
>>> +     }
>>
>> What if CONF_PS is set? You need to take that into account here and
>> disable powersave when it's enabled.
>
> With ath9k, for a data frame(non-multicast) to reach mac80211,
> CONF_PS should have been disabled. in other words,a data packet will
> not reach mac80211 when CONF_PS is set. Hence that check might be
> redundant here.

I checked this now, and that indeed is the case. So no need to check
CONF_PS here.

-- 
Kalle Valo
