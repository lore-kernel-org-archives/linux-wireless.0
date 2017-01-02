Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35838 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755547AbdABOF3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 09:05:29 -0500
MIME-Version: 1.0
In-Reply-To: <1483364298.21014.3.camel@sipsolutions.net>
References: <20170102132747.3491-1-zajec5@gmail.com> <1483364298.21014.3.camel@sipsolutions.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 2 Jan 2017 15:05:28 +0100
Message-ID: <CACna6rzc2hk2xosd54eZVSUCtqgtT5E2vii24rgWBV96PR1W7A@mail.gmail.com> (sfid-20170102_150533_492620_30391C32)
Subject: Re: [PATCH V2 1/3] cfg80211: allow passing struct device in the
 wiphy_new call
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 January 2017 at 14:38, Johannes Berg <johannes@sipsolutions.net> wrote=
:
>
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -3730,8 +3730,8 @@ static inline const char *wiphy_name(const
>> struct wiphy *wiphy)
>>   * Return: A pointer to the new wiphy. This pointer must be
>>   * assigned to each netdev's ieee80211_ptr for proper operation.
>>   */
>> -struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int
>> sizeof_priv,
>> -                        const char *requested_name);
>> +struct wiphy *wiphy_new_nm(struct device *dev, const struct
>> cfg80211_ops *ops,
>> +                        int sizeof_priv, const char
>> *requested_name);
>
> This is obviously missing documentation updates.
>
>>   */
>> -static inline struct wiphy *wiphy_new(const struct cfg80211_ops
>> *ops,
>> +static inline struct wiphy *wiphy_new(struct device *dev,
>> +                                   const struct cfg80211_ops
>> *ops,
>
> Ditto.
>
> It looks like you practically removed all users of set_wiphy_dev(), why
> not do that completely and remove that entirely?

There are 2 users left:
1) ipw2x00 - I missed that one
2) mac80211 - it's a big one as it's used in SET_IEEE80211_DEV

I was planning to work on mac80211 drivers later. This will require
similar modification of ieee80211_alloc_hw.

--=20
Rafa=C5=82
