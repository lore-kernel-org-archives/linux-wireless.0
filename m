Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45211 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbYIZGve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 02:51:34 -0400
Received: by gxk9 with SMTP id 9so7993552gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 23:51:33 -0700 (PDT)
Message-ID: <43e72e890809252351u48ce9f89q6ec9947044317d6@mail.gmail.com> (sfid-20080926_085137_084871_949EA856)
Date: Thu, 25 Sep 2008 23:51:33 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890809252350n13a04099ne205480201cae26c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net>
	 <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
	 <48DC51AF.6000900@lwfinger.net>
	 <1ba2fa240809252342x4b85b7e3u8341bb96a03b95a7@mail.gmail.com>
	 <43e72e890809252350n13a04099ne205480201cae26c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 11:50 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Sep 25, 2008 at 11:42 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Fri, Sep 26, 2008 at 6:06 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> Tomas Winkler wrote:
>>>> wild guess try to revert:
>>>> 'mac80211: make master iface not wireless'
>>>
>>> You win the prize. Bisection shows that
>>> 84b0ba8ed0423a3c56a28e701b735daae3e15766 is first bad commit
>>>
>>> commit 84b0ba8ed0423a3c56a28e701b735daae3e15766
>>> Author: Johannes Berg <johannes@sipsolutions.net>
>>> Date:   Tue Sep 16 14:18:59 2008 +0200
>>>
>>>    mac80211: make master iface not wireless
>>>
>>>
>>> The actual crash is in the following routine from include/net/wireless.h:
>>>
>>> /**
>>>  * wiphy_priv - return priv from wiphy
>>>  */
>>> static inline void *wiphy_priv(struct wiphy *wiphy)
>>> {
>>>        BUG_ON(!wiphy);
>>>        return &wiphy->priv;
>>> }
>>>
>>> I'm still looking to see where it goes wrong.
>>
>> What do you mean?  The root cause is written in the commit log.
>> Tomas
>
> The question is who calls wiphy_priv(mdev) or wiphy_priv(NULL) and where.

Actually just the later.

  Luis
