Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59549 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab3LDLzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 06:55:43 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so23416735pbb.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 03:55:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386081014.4393.31.camel@jlt4.sipsolutions.net>
References: <1385883096-7143-1-git-send-email-royujjal@gmail.com>
	<1386081014.4393.31.camel@jlt4.sipsolutions.net>
Date: Wed, 4 Dec 2013 17:25:43 +0530
Message-ID: <CAE2MWk=_9cqG1_w8cvsDrusMOrMY2R9DO5q-ZNN-G-MWwGx8gA@mail.gmail.com> (sfid-20131204_125546_829997_3AADFCBE)
Subject: Re: [PATCH] cfg80211: fix WARN_ON for re-association to the expired BSS
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kernel <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 3, 2013 at 8:00 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2013-12-01 at 13:01 +0530, Ujjal Roy wrote:
>
>> +     if (!bss)
>> +             save_bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
>> +                                         wdev->ssid, wdev->ssid_len,
>> +                                         WLAN_CAPABILITY_ESS,
>> +                                         WLAN_CAPABILITY_ESS);
>>       if (wdev->current_bss) {
>>               cfg80211_unhold_bss(wdev->current_bss);
>>               cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
>> @@ -651,10 +657,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>>
>>       if (!bss) {
>>               WARN_ON_ONCE(!wiphy_to_dev(wdev->wiphy)->ops->connect);
>> -             bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
>> -                                    wdev->ssid, wdev->ssid_len,
>> -                                    WLAN_CAPABILITY_ESS,
>> -                                    WLAN_CAPABILITY_ESS);
>> +             bss = save_bss;
>
> In an unsuccessful result case, this leaks the BSS struct. I'd prefer to
> reshuffle the code a bit to not need a separate save_bss variable, but I
> don't immediately see an easy way to do that.
>
> johannes
>

Thanks for pointing out the leak of BSS. I have reshuffled the code to
avoid an extra
variable. Please have a look at this code which I am sending through
git send-mail.

-- 
Thanks,
UjjaL Roy
