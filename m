Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:49059 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1F2DhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 23:37:15 -0400
Received: by fxd18 with SMTP id 18so803016fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 20:37:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTiktJ3L3Nw+wHbJt9mkVSRBU8JGwoA@mail.gmail.com>
References: <BANLkTimfrcrqVxNXj_5qDYYJoz6Exnzw+w@mail.gmail.com>
	<1309009093.4317.9.camel@jlt3.sipsolutions.net>
	<BANLkTinUO9PA4dN8JWUox2nXRu25R3J4ew@mail.gmail.com>
	<BANLkTiktJ3L3Nw+wHbJt9mkVSRBU8JGwoA@mail.gmail.com>
Date: Tue, 28 Jun 2011 23:37:13 -0400
Message-ID: <BANLkTi=_zXSdO20Q3ZhRJ_XDLkWbo6G6+w@mail.gmail.com> (sfid-20110629_053721_483230_70DE3251)
Subject: Re: [PATCH] chan.c: fix chan.c to return channel number when in
 monitor mode and on a fixed channel.
From: Nicholas Hockey <nhockey@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thank you very much, that is very helpful information. im sure it will
be a resource for not only me, but a host of others frustrated by the
current state. in order that they will/should be able to research and
modify their software accordingly. i originally wrote my software in
the madwifi days, and didnt pay enough attention to the changes, all i
knew was that the patch i posted solved my problem. i still dont see
whats wrong with my method, but im hoping the direction you have
pointed me in will help answer that,

On Tue, Jun 28, 2011 at 10:53 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> Take a look at how monitor mode is used by other bits of software, eg
> I think hostapd in Linux uses a monitor mode interface.
>
> If I understand the Linux wifi stack use of monitor mode correctly,
> it's not designed like the "classic" monitor mode from days gone by
> (eg madwifi) (And this is what BSD still does..); it's a slave device
> to a currently configured, non-monitor interface. The normal interface
> gets the 'normal' traffic; the slave monitor mode interface sees the
> management traffic so hostapd can do MLME, etc.
>
> So you likely need to look at what hostapd does and create/use a
> monitor mode interface in the same way. Ie, as a slave to a normal
> interface, rather than a stand-alone interface.
>
> Adrian
>
> On 29 June 2011 00:12, Nicholas Hockey <nhockey@gmail.com> wrote:
>> If this has been discussed before, could you please point me to a
>> resource? if this solution is not correct, then id like to read why
>> its not correct, and formulate another solution for the problem. i am
>> an amateur radio tech and i have to apply this patch every single
>> build in order to use some custom software i have developed over the
>> years.
>>
>> On Sat, Jun 25, 2011 at 9:38 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Thu, 2011-06-23 at 16:49 -0400, Nicholas Hockey wrote:
>>>> (sorry if this is not right, its been nearly 10 years since i
>>>> submitted a kernel patch)
>>>
>>> Listing cfg80211 isntead of "chan.c" would have been useful :-)
>>>
>>>> Fixes: When monitoring a fixed channel, chan.c does not report what
>>>> channel it is on.
>>>>
>>>> Signed-off-by: Nicholas Hockey <nhockey@gmail.com>
>>>> ---
>>>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>>>> index 17cd0c0..261ee32 100644
>>>> --- a/net/wireless/chan.c
>>>> +++ b/net/wireless/chan.c
>>>> @@ -82,10 +82,12 @@ int cfg80211_set_freq(struct
>>>> cfg80211_registered_device *rdev,
>>>>  {
>>>>         struct ieee80211_channel *chan;
>>>>         int result;
>>>> +    struct wireless_dev *mon_dev = NULL;
>>>>
>>>> -       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
>>>> +       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
>>>> +        mon_dev = wdev;
>>>>                 wdev = NULL;
>>>> -
>>>> +    }
>>>>         if (wdev) {
>>>>                 ASSERT_WDEV_LOCK(wdev);
>>>>
>>>> @@ -131,5 +133,8 @@ int cfg80211_set_freq(struct
>>>> cfg80211_registered_device *rdev,
>>>>         if (wdev)
>>>>                 wdev->channel = chan;
>>>>
>>>> +    if (mon_dev)
>>>> +        mon_dev->channel = chan;
>>>> +
>>>
>>> This has been discussed numerous times, this change still isn't right
>>> because monitors are slaved to others.
>>>
>>> johannes
>>>
>>>
>>
>>
>>
>> --
>> Nicholas (Tilt) Hockey
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Nicholas (Tilt) Hockey
