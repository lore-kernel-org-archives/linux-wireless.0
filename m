Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35634 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbbL3UBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 15:01:55 -0500
Received: by mail-lf0-f45.google.com with SMTP id c192so54760754lfe.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 12:01:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFqt6zYfQwBN1in2dwYRY6CE1vf9-Kznc0z5UhBGxJzvEs7-kw@mail.gmail.com>
References: <1450946006-7498-1-git-send-email-bjorn.andersson@sonymobile.com>
	<CAFqt6zam7maK4wFrKo=yqWxaBkVDJhZGbKAFAdmcZPQonXTcxA@mail.gmail.com>
	<CAJAp7Oinz993CQgA81SifcJoeHicD9YNhBv0HHkiav3rD5=M4Q@mail.gmail.com>
	<CAFqt6zYfQwBN1in2dwYRY6CE1vf9-Kznc0z5UhBGxJzvEs7-kw@mail.gmail.com>
Date: Wed, 30 Dec 2015 12:01:53 -0800
Message-ID: <CAJAp7OisPmCGbMUjjAR_30TLXD1Wm_gOMRp-xfXWEVz-R2yUOA@mail.gmail.com> (sfid-20151230_210221_391718_3987570C)
Subject: Re: [PATCH] mac80211: Make addr const in SET_IEEE80211_PERM_ADDR()
From: Bjorn Andersson <bjorn@kryo.se>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 30, 2015 at 10:30 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> On Wed, Dec 30, 2015 at 10:35 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
>> On Wed, Dec 30, 2015 at 8:47 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>>>
>>> HI Bjorn,
>>>
>>> On Thu, Dec 24, 2015 at 2:03 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
>>> > Make the addr parameter const in SET_IEEE80211_PERM_ADDR() to save
>>> > clients from having to cast away a const qualifier.
>>> >
>>> > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>>> > ---
>>> >  include/net/mac80211.h | 2 +-
>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >
>>> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>>> > index 7c30faff245f..a6f3c9c4b7c2 100644
>>> > --- a/include/net/mac80211.h
>>> > +++ b/include/net/mac80211.h
>>> > @@ -2167,7 +2167,7 @@ static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev
>>> >   * @hw: the &struct ieee80211_hw to set the MAC address for
>>> >   * @addr: the address to set
>>> >   */
>>> > -static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, u8 *addr)
>>> > +static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, const u8 *addr)
>>>
>>> I guess without const or with const doesn't make much difference here.
>>> Correct me if I am wrong.
>>
>> For most cases it doesn't make any difference, but in my driver I
>> acquire the mac address as a const u8 *. Therefor I need to cast away
>> the const part when calling this API.
>>
>> There's an existing example of this in
>> drivers/net/wireless/st/cw1200/main.c line 601.
>
> Is the path correct ? I think path is
> drivers/net/wireless/cw1200/main.c line 334
>

It's apparently being relocated in linux-next, and I'm not sure where
I got that line number from. But that's the example I tried to refer
to ;)

Sorry about that.

Regards,
Bjorn

>> I think it's safe to assume that this API won't ever modify the passed
>> addr buffer, so there would be no future issues of marking the
>> parameter const either.
>
> I agree with you.
>
>>
>>>
>>> >  {
>>> >         memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
>>> >  }
>>>
>>
>> Regards,
>> Bjorn
>
> -Souptick
