Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40178 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaCaLtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:49:13 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so5671782wgh.15
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 04:49:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396266320.6794.6.camel@dubbel>
References: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	<1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	<1396259841-6359-5-git-send-email-michal.kazior@tieto.com>
	<1396266320.6794.6.camel@dubbel>
Date: Mon, 31 Mar 2014 13:49:11 +0200
Message-ID: <CA+BoTQnOh8nRot1=vTkQ0bW2rkxxiDDF4PJm4q9ryY5FvO3Hiw@mail.gmail.com> (sfid-20140331_134916_799877_9B35CF1B)
Subject: Re: [PATCH v3 4/4] mac80211: disconnect iface if CSA unexpectedly fails
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2014 13:45, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2014-03-31 at 11:57 +0200, Michal Kazior wrote:
>> It doesn't make much sense to leave a cripled
>> interface running.
>>
>> As a side effect this will unblock tx queues with
>> CSA reason immediately after failure instead of
>> until after userspace requests interface to stop.
>>
>> This also gives userspace an opportunity to
>> indirectly see CSA failure.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>
> [...]
>
>> @@ -3100,7 +3100,7 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>>       sdata->radar_required = sdata->csa_radar_required;
>>       err = ieee80211_vif_change_channel(sdata, &changed);
>>       if (WARN_ON(err < 0))
>> -             return;
>> +             return err;
>
> Didn't we agree to remove the WARN_ON() from here?

I forgot, sorry. Now I definitely need to respin, again :)


Michał
