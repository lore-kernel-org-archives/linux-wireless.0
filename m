Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48112 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYIZHnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 03:43:24 -0400
Received: by gxk9 with SMTP id 9so8018334gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 00:43:22 -0700 (PDT)
Message-ID: <43e72e890809260043n1b31dea9yaad2e7a2d80ed819@mail.gmail.com> (sfid-20080926_094328_708716_49C2DEFD)
Date: Fri, 26 Sep 2008 00:43:22 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890809260006kfc833fdsccbe3f22b3ad4c56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net>
	 <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
	 <48DC51AF.6000900@lwfinger.net>
	 <43e72e890809260006kfc833fdsccbe3f22b3ad4c56@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 12:06 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Sep 25, 2008 at 8:06 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
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
> Actually wouldn't you get a stack trace here?

Yeah not sure I tested against !wiphy on its callers and didn't find a
case where it hit. I don't think this is it.

  Luis
