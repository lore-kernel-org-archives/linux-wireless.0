Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:53233 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756500Ab2EaM2E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 08:28:04 -0400
Received: by lbbgg6 with SMTP id gg6so938308lbb.36
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 05:28:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC76176.4030700@broadcom.com>
References: <1338463991-7741-1-git-send-email-victorg@ti.com>
	<4FC76176.4030700@broadcom.com>
Date: Thu, 31 May 2012 15:28:01 +0300
Message-ID: <CAK80WHYYLS-YiVRHiOog9287qYoco=O3yaoNTnAqQok3LxgWfQ@mail.gmail.com> (sfid-20120531_142833_516245_C2EC1E36)
Subject: Re: [PATCH v2] mac80211: add command to get current rssi
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 31, 2012 at 3:17 PM, Arend van Spriel <arend@broadcom.com> wrote:
> This documentation is provided for the driver. mac80211 already allows
> this callback to sleep. So rephrase 'must be allowed to sleep' to 'is
> allowed to sleep' or 'can sleep'.
>

I will change it, thanks.

>> @@ -517,7 +520,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
>>        * network device.
>>        */
>>
>> -     rcu_read_lock();
>> +     mutex_lock(&local->sta_mtx);
>>
>>       if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>>               sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
>> @@ -546,7 +549,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
>>                       data[i] = (u8)sinfo.signal_avg;
>>               i++;
>>       } else {
>> -             list_for_each_entry_rcu(sta, &local->sta_list, list) {
>> +             list_for_each_entry(sta, &local->sta_list, list) {
>>                       /* Make sure this station belongs to the proper dev */
>>                       if (sta->sdata->dev != dev)
>>                               continue;
>
> Just for my curiosity/learning: How are these related to the new
> callback? Is it because you are now doing the callback in sta_set_sinfo()?
>

Yes, since sta_set_sinfo now might sleep we must replace rcu locks
around it with sta_mtx.


Thanks for the review,
Victor.
