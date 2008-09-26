Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:11773 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbYIZGu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 02:50:59 -0400
Received: by yw-out-2324.google.com with SMTP id 9so141937ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 23:50:57 -0700 (PDT)
Message-ID: <43e72e890809252350n13a04099ne205480201cae26c@mail.gmail.com> (sfid-20080926_085106_191159_03843B1A)
Date: Thu, 25 Sep 2008 23:50:57 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809252342x4b85b7e3u8341bb96a03b95a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net>
	 <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
	 <48DC51AF.6000900@lwfinger.net>
	 <1ba2fa240809252342x4b85b7e3u8341bb96a03b95a7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 11:42 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Fri, Sep 26, 2008 at 6:06 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Tomas Winkler wrote:
>>> wild guess try to revert:
>>> 'mac80211: make master iface not wireless'
>>
>> You win the prize. Bisection shows that
>> 84b0ba8ed0423a3c56a28e701b735daae3e15766 is first bad commit
>>
>> commit 84b0ba8ed0423a3c56a28e701b735daae3e15766
>> Author: Johannes Berg <johannes@sipsolutions.net>
>> Date:   Tue Sep 16 14:18:59 2008 +0200
>>
>>    mac80211: make master iface not wireless
>>
>>
>> The actual crash is in the following routine from include/net/wireless.h:
>>
>> /**
>>  * wiphy_priv - return priv from wiphy
>>  */
>> static inline void *wiphy_priv(struct wiphy *wiphy)
>> {
>>        BUG_ON(!wiphy);
>>        return &wiphy->priv;
>> }
>>
>> I'm still looking to see where it goes wrong.
>
> What do you mean?  The root cause is written in the commit log.
> Tomas

The question is who calls wiphy_priv(mdev) or wiphy_priv(NULL) and where.

  Luis
