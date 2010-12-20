Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42403 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab0LTQc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 11:32:59 -0500
Received: by iyi12 with SMTP id 12so2343731iyi.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 08:32:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimZaYX+YPUJF9PG5_fbopuSPBH_bFUkH=MabNXb@mail.gmail.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
 <1292556197-4820-4-git-send-email-lrodriguez@atheros.com> <1292579457.3715.2.camel@jlt3.sipsolutions.net>
 <AANLkTimseBRXix3sFsHnCVBjZh6=Jfum8MGUqq1Uf6z0@mail.gmail.com> <AANLkTimZaYX+YPUJF9PG5_fbopuSPBH_bFUkH=MabNXb@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 20 Dec 2010 08:32:38 -0800
Message-ID: <AANLkTi=L66Pj6hU9FirXY0K3CzH2UJ-iuahHf6w0wDV4@mail.gmail.com>
Subject: Re: [RFC 3/8] cfg80211: pass DFS region to drivers through reg_notifier()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 20, 2010 at 8:16 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Dec 17, 2010 at 11:40 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Fri, Dec 17, 2010 at 1:50 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Thu, 2010-12-16 at 19:23 -0800, Luis R. Rodriguez wrote:
>>>
>>>>       /* Lets us get back the wiphy on the callback */
>>>>       int (*reg_notifier)(struct wiphy *wiphy,
>>>> -                         struct regulatory_request *request);
>>>> +                         struct regulatory_request *request,
>>>> +                         u8 dfs_region);
>>>
>>> So does that mean we need to implement a reg_notifier if we want to have
>>> radar detection? Doesn't an empty reg_notifier already alter behaviour
>>
>> An empty reg_notifier() should not do anything. Its either through the
>> reg_notifier() or we add a new callback specifically for DFS. A new
>> callback may give more flexibility later if we want to pass up more
>> data.
>
> After some more thought I think its best to keep this within the
> reg_notifier() instead of adding a new callback, the reason being that
> we are already passing some regulatory data on it, no point in
> splitting up the calls and having those synch up on themselves later
> on the driver. But we are missing the alpha2 which I suspect drivers
> may need to request_firmware() some DFS data for the specific chipset,
> or do their own lookup on local static data. We don't currently pass
> the cfg80211_regdomain but I think it makes sense in this case, then
> the user can just check the alpha2 from it and in case other users
> need any other data from the regulatory domain they can have at it.
>
> I'm going to make this change and submit as PATCH form next. I haven't
> seen any more feeback on this so I take it that we're OK with this.

Actually, the alpha2 is already part of the struct regulatory_request
which is passed and come to think of it I can just peg the dfs_region
onto this so we do not have to extend the callbacks anywhere.

  Luis
