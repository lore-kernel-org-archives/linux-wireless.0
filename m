Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:63267 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYIZILz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 04:11:55 -0400
Received: by fg-out-1718.google.com with SMTP id 19so569549fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 01:11:53 -0700 (PDT)
Message-ID: <1ba2fa240809260111i217ff844q73036685e6d74aee@mail.gmail.com> (sfid-20080926_101201_039059_657F7B4B)
Date: Fri, 26 Sep 2008 11:11:53 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890809260043n1b31dea9yaad2e7a2d80ed819@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net>
	 <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
	 <48DC51AF.6000900@lwfinger.net>
	 <43e72e890809260006kfc833fdsccbe3f22b3ad4c56@mail.gmail.com>
	 <43e72e890809260043n1b31dea9yaad2e7a2d80ed819@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 10:43 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Sep 26, 2008 at 12:06 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Sep 25, 2008 at 8:06 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
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
>> Actually wouldn't you get a stack trace here?
>
> Yeah not sure I tested against !wiphy on its callers and didn't find a
> case where it hit. I don't think this is it.

u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
{
        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
        struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
--- this is the line

Tomas
