Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0115.outbound.protection.outlook.com ([104.47.0.115]:8689
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754950AbeFNPzi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:55:38 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] mac80211: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
Date: Thu, 14 Jun 2018 15:55:34 +0000
Message-ID: <VI1PR02MB3631E24AA7D7E58CEB0E7D889A7D0@VI1PR02MB3631.eurprd02.prod.outlook.com> (sfid-20180614_175542_383081_E4FA3289)
References: <1528971073-349-1-git-send-email-omer.efrat@tandemg.com>
         (sfid-20180614_121125_842548_E3DF065D),<1528974485.26847.3.camel@sipsolutions.net>,<VI1PR02MB3631079EA8E79B0C8900DEE09A7D0@VI1PR02MB3631.eurprd02.prod.outlook.com>
In-Reply-To: <VI1PR02MB3631079EA8E79B0C8900DEE09A7D0@VI1PR02MB3631.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Omer Efrat wrote:
>Johannes Berg wrote:
>>Perhaps, though I'm not sure I see it, there's some value in switching
>>them all so that if you copy something and change it to a new value you
>>don't run into this problem again, but if anything that should be (a)
>>separate patch(es) since this one is a bugfix and the others aren't.
>
>Exactly my thoughts. I accept the need for the cleanup to be separated
>to different patches as well, I will send a v3.

Actually, after some more thought, I don't think changing to BIT_ULL for
attribute types less than 32 should be in separated patches because of the =
claim
they are not a bug fix.
This enum already has different numbering in different versions (attributes=
 removed from the middle,
i.e. NL80211_STA_INFO_MAX_RSSI).
Therefore, it's hard to mark each of them as "bug fix" or "cleanup only" ch=
ange.
(Some versions has NL80211_STA_INFO_TID_STATS =3D 32, while others has
NL80211_STA_INFO_TID_STATS =3D 31, etc.)

If that's acceptable, I will send a v3 for adding which commit is being fix=
ed
by this patch series.

Best Regards,
Omer Efrat.

________________________________________
From: Omer Efrat
Sent: Thursday, June 14, 2018 3:30:27 PM
To: Johannes Berg; linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mac80211: use BIT_ULL for NL80211_STA_INFO_* at=
tribute types

Johannes Berg wrote:
>Perhaps, though I'm not sure I see it, there's some value in switching
>them all so that if you copy something and change it to a new value you
>don't run into this problem again, but if anything that should be (a)
>separate patch(es) since this one is a bugfix and the others aren't.

Exactly my thoughts. I accept the need for the cleanup to be separated
to different patches as well, I will send a v3.

Omer Efrat.

________________________________________
From: Johannes Berg <johannes@sipsolutions.net>
Sent: Thursday, June 14, 2018 2:08:05 PM
To: Omer Efrat; linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mac80211: use BIT_ULL for NL80211_STA_INFO_* at=
tribute types

On Thu, 2018-06-14 at 13:11 +0300, Omer Efrat wrote:
> Since 'filled' member in station_info changed to u64, BIT_ULL macro
> should be used with NL80211_STA_INFO_* attribute types instead of BIT.
>
> The BIT macro uses unsigned long type which some architectures handle as =
32bit
> and this results in compilation warnings such as:
>
> net/mac80211/sta_info.c:2223:2: warning: left shift count >=3D width of t=
ype
>   sinfo->filled |=3D BIT(NL80211_STA_INFO_TID_STATS);
>   ^

It seems like the only change needed is with
BIT(NL80211_STA_INFO_TID_STATS), so I'd argue you should restrict the
patch to that.


Perhaps, though I'm not sure I see it, there's some value in switching
them all so that if you copy something and change it to a new value you
don't run into this problem again, but if anything that should be (a)
separate patch(es) since this one is a bugfix and the others aren't.

johannes
