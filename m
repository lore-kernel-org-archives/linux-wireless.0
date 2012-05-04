Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41824 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2EDIoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 04:44:23 -0400
Received: by lbbgm6 with SMTP id gm6so1860213lbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 May 2012 01:44:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336071617.5167.9.camel@jlt3.sipsolutions.net>
References: <1335357955-28089-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<1336071617.5167.9.camel@jlt3.sipsolutions.net>
Date: Fri, 4 May 2012 11:44:21 +0300
Message-ID: <CAMXE1-qniMzGi97U2oDPxyvSsms7nZpy6QfZVZPpnrC0WcNMqQ@mail.gmail.com> (sfid-20120504_104427_206513_62AE1807)
Subject: Re: [PATCH] cfg80211: Remove compile warnings
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, May 3, 2012 at 10:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-04-25 at 15:45 +0300, Andrei Emeltchenko wrote:
>> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>>
>> Use default key to handle similar iface types. This removes compile warnings:
>>
>> net/wireless/util.c: In function ‘cfg80211_change_iface’:
>> net/wireless/util.c:846:3: warning: enumeration value ‘NL80211_IFTYPE_MAX’
>>       not handled in switch [-Wswitch]
>>
>> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>> ---
>>  net/wireless/util.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/net/wireless/util.c b/net/wireless/util.c
>> index 1b7a08d..468dc8b 100644
>> --- a/net/wireless/util.c
>> +++ b/net/wireless/util.c
>> @@ -862,8 +862,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
>>               case NL80211_IFTYPE_MONITOR:
>>                       /* monitor can't bridge anyway */
>>                       break;
>> -             case NL80211_IFTYPE_UNSPECIFIED:
>> -             case NUM_NL80211_IFTYPES:
>> +             default:
>
> When did this warning start occurring? I was pretty sure it didn't use
> to? I think we should explicitly list the cases here though because we
> want the compiler to warn here when we add something to the interface
> type list so we catch this place that may have to be modified.

I think warning occurs when I added new interface type since it is
also not handled.

Regards,
Andrei
