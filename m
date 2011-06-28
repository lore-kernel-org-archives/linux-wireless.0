Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:54236 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab1F1QMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 12:12:12 -0400
Received: by fxd18 with SMTP id 18so389097fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 09:12:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309009093.4317.9.camel@jlt3.sipsolutions.net>
References: <BANLkTimfrcrqVxNXj_5qDYYJoz6Exnzw+w@mail.gmail.com>
	<1309009093.4317.9.camel@jlt3.sipsolutions.net>
Date: Tue, 28 Jun 2011 12:12:11 -0400
Message-ID: <BANLkTinUO9PA4dN8JWUox2nXRu25R3J4ew@mail.gmail.com> (sfid-20110628_184454_231881_B36881C0)
Subject: Re: [PATCH] chan.c: fix chan.c to return channel number when in
 monitor mode and on a fixed channel.
From: Nicholas Hockey <nhockey@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If this has been discussed before, could you please point me to a
resource? if this solution is not correct, then id like to read why
its not correct, and formulate another solution for the problem. i am
an amateur radio tech and i have to apply this patch every single
build in order to use some custom software i have developed over the
years.

On Sat, Jun 25, 2011 at 9:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-06-23 at 16:49 -0400, Nicholas Hockey wrote:
>> (sorry if this is not right, its been nearly 10 years since i
>> submitted a kernel patch)
>
> Listing cfg80211 isntead of "chan.c" would have been useful :-)
>
>> Fixes: When monitoring a fixed channel, chan.c does not report what
>> channel it is on.
>>
>> Signed-off-by: Nicholas Hockey <nhockey@gmail.com>
>> ---
>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>> index 17cd0c0..261ee32 100644
>> --- a/net/wireless/chan.c
>> +++ b/net/wireless/chan.c
>> @@ -82,10 +82,12 @@ int cfg80211_set_freq(struct
>> cfg80211_registered_device *rdev,
>>  {
>>         struct ieee80211_channel *chan;
>>         int result;
>> +    struct wireless_dev *mon_dev = NULL;
>>
>> -       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
>> +       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
>> +        mon_dev = wdev;
>>                 wdev = NULL;
>> -
>> +    }
>>         if (wdev) {
>>                 ASSERT_WDEV_LOCK(wdev);
>>
>> @@ -131,5 +133,8 @@ int cfg80211_set_freq(struct
>> cfg80211_registered_device *rdev,
>>         if (wdev)
>>                 wdev->channel = chan;
>>
>> +    if (mon_dev)
>> +        mon_dev->channel = chan;
>> +
>
> This has been discussed numerous times, this change still isn't right
> because monitors are slaved to others.
>
> johannes
>
>



-- 
Nicholas (Tilt) Hockey
