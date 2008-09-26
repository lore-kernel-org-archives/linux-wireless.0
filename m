Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:17358 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbYIZIM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 04:12:27 -0400
Received: by yx-out-2324.google.com with SMTP id 8so144188yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 01:12:26 -0700 (PDT)
Message-ID: <43e72e890809260112p3a368505n3c8cc7a3b35b6573@mail.gmail.com> (sfid-20080926_101230_633134_90E272AF)
Date: Fri, 26 Sep 2008 01:12:25 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809260111i217ff844q73036685e6d74aee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net>
	 <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
	 <48DC51AF.6000900@lwfinger.net>
	 <43e72e890809260006kfc833fdsccbe3f22b3ad4c56@mail.gmail.com>
	 <43e72e890809260043n1b31dea9yaad2e7a2d80ed819@mail.gmail.com>
	 <1ba2fa240809260111i217ff844q73036685e6d74aee@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 1:11 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Fri, Sep 26, 2008 at 10:43 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Fri, Sep 26, 2008 at 12:06 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Thu, Sep 25, 2008 at 8:06 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>> Tomas Winkler wrote:
>>>>> wild guess try to revert:
>>>>> 'mac80211: make master iface not wireless'
>>>>
>>>> You win the prize. Bisection shows that
>>>> 84b0ba8ed0423a3c56a28e701b735daae3e15766 is first bad commit
>>>>
>>>> commit 84b0ba8ed0423a3c56a28e701b735daae3e15766
>>>> Author: Johannes Berg <johannes@sipsolutions.net>
>>>> Date:   Tue Sep 16 14:18:59 2008 +0200
>>>>
>>>>    mac80211: make master iface not wireless
>>>>
>>>>
>>>> The actual crash is in the following routine from include/net/wireless.h:
>>>>
>>>> /**
>>>>  * wiphy_priv - return priv from wiphy
>>>>  */
>>>> static inline void *wiphy_priv(struct wiphy *wiphy)
>>>> {
>>>>        BUG_ON(!wiphy);
>>>>        return &wiphy->priv;
>>>> }
>>>>
>>>> I'm still looking to see where it goes wrong.
>>>
>>> Actually wouldn't you get a stack trace here?
>>
>> Yeah not sure I tested against !wiphy on its callers and didn't find a
>> case where it hit. I don't think this is it.
>
> u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
> {
>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>        struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> --- this is the line

Yeah I just landed there too.

  Luis
