Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58778 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2GBPQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 11:16:14 -0400
Received: by gglu4 with SMTP id u4so4174669ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 08:16:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341241929.19642.17.camel@jlt3.sipsolutions.net>
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1341210756-11054-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <CA+XVXfduVieZEVF4eav+K+YHv=B+VoTjZmquMtOrg6XPKVVkOA@mail.gmail.com> <1341241929.19642.17.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Mon, 2 Jul 2012 18:15:58 +0300
Message-ID: <CA+XVXfebumem+DMgsmUSd7vr7ZaK+x-S2gxzu8BAhB-KoXTr6Q@mail.gmail.com> (sfid-20120702_171618_174025_37C631E4)
Subject: Re: [PATCH 60g v2 1/5] wireless: add 802.11ad (60gHz band)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 2, 2012 at 6:12 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2012-07-02 at 17:22 +0300, Arik Nemtsov wrote:
>
>> enum ieee80211_band {
>>       IEEE80211_BAND_2GHZ = NL80211_BAND_2GHZ,
>>       IEEE80211_BAND_5GHZ = NL80211_BAND_5GHZ,
>>
>>       /* keep last */
>>       IEEE80211_NUM_BANDS
>> };
>>
>> If the 60Ghz band goes here as well, IEEE80211_NUM_BANDS will be
>> incremented.
>
> Yes, this happened.
>
>> I'm guessing this can be problematic for a lot of drivers
>> that use this value more or less blindly (and pass indices to FW etc).
>> At least the wlcore driver will be impacted.
>>
>> So this probably should be added, but maybe keep IEEE80211_NUM_BANDS
>> the same for legacy reasons?
>
> Can't do that, it's used for array sizing etc.
>
> It looks like your driver may crash as it accesses bands[x] for all
> possible values of x ... might want to fix that soon as I've applied
> these patches :)

Yes. That's the alternative :)
