Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38756 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab0EYWy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 18:54:57 -0400
Received: by fxm5 with SMTP id 5so3801825fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 15:54:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274775071.3635.4.camel@jlt3.sipsolutions.net>
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
	<1274775071.3635.4.camel@jlt3.sipsolutions.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 26 May 2010 00:54:35 +0200
Message-ID: <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>
Subject: Re: Path for fixed channel issue in aircrack-ng suite
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 25, 2010 at 10:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-05-25 at 01:07 -0400, Joker Joker wrote:
>> Below is a patch to fix monitor mode channel issue for aircrack-ng suit
>> (fixed channel mon0: -1)
>>
>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>> index d92d088..93f6c19 100644
>> --- a/net/wireless/chan.c
>> +++ b/net/wireless/chan.c
>> @@ -48,6 +48,7 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>>                       enum nl80211_channel_type channel_type)
>>  {
>>         struct ieee80211_channel *chan;
>> +       struct wireless_dev *old_wdev = wdev;
>>         int result;
>>
>>         if (wdev->iftype == NL80211_IFTYPE_MONITOR)
>> @@ -73,8 +74,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>>         if (result)
>>                 return result;
>>
>> -       if (wdev)
>> -               wdev->channel = chan;
>> +       wdev = old_wdev;
>> +       wdev->channel = chan;
>
> NACK. That will crash when there really is no interface being passed in.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Well, the original version already dereferences wdev in "if
(wdev->iftype...", so the crash is nothing new if it exists.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
