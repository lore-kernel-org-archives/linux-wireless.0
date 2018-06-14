Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:45292
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755010AbeFNQZM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 12:25:12 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] mac80211: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
Date: Thu, 14 Jun 2018 16:25:09 +0000
Message-ID: <VI1PR02MB363134497AAC8BFCABF1FCFE9A7D0@VI1PR02MB3631.eurprd02.prod.outlook.com> (sfid-20180614_182516_979482_1C9166CE)
References: <1528971073-349-1-git-send-email-omer.efrat@tandemg.com>
         (sfid-20180614_121125_842548_E3DF065D),<1528974485.26847.3.camel@sipsolutions.net>
        ,<VI1PR02MB3631079EA8E79B0C8900DEE09A7D0@VI1PR02MB3631.eurprd02.prod.outlook.com>
         <VI1PR02MB3631E24AA7D7E58CEB0E7D889A7D0@VI1PR02MB3631.eurprd02.prod.outlook.com>,<1528992733.26847.6.camel@sipsolutions.net>
In-Reply-To: <1528992733.26847.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>I don't think it is.
>
>The bugfix is certainly legitimate, but I don't want to claim such a
>long patch as the bugfix, with a single compiler warning to show for.

Understood.

>If you prefer, I can do the bugfix separately myself, and then you can
>focus on the remaining patches as cleanups for -next.

I will send both as v3.

Omer.

________________________________________
From: Johannes Berg <johannes@sipsolutions.net>
Sent: Thursday, June 14, 2018 7:12:13 PM
To: Omer Efrat; linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mac80211: use BIT_ULL for NL80211_STA_INFO_* at=
tribute types

On Thu, 2018-06-14 at 15:55 +0000, Omer Efrat wrote:
> Omer Efrat wrote:
> > Johannes Berg wrote:
> > > Perhaps, though I'm not sure I see it, there's some value in switchin=
g
> > > them all so that if you copy something and change it to a new value y=
ou
> > > don't run into this problem again, but if anything that should be (a)
> > > separate patch(es) since this one is a bugfix and the others aren't.
> >
> > Exactly my thoughts. I accept the need for the cleanup to be separated
> > to different patches as well, I will send a v3.
>
> Actually, after some more thought, I don't think changing to BIT_ULL for
> attribute types less than 32 should be in separated patches because of th=
e claim
> they are not a bug fix.

I disagree, they aren't a bugfix.

> This enum already has different numbering in different versions (attribut=
es removed from the middle,
> i.e. NL80211_STA_INFO_MAX_RSSI).

This must be in some non-upstream tree, because it certainly never
happened in upstream, nor did that attribute (MAX_RSSI) ever exist
there.

> Therefore, it's hard to mark each of them as "bug fix" or "cleanup only" =
change.
> (Some versions has NL80211_STA_INFO_TID_STATS =3D 32, while others has
> NL80211_STA_INFO_TID_STATS =3D 31, etc.)
>
> If that's acceptable, I will send a v3 for adding which commit is being f=
ixed
> by this patch series.

I don't think it is.

The bugfix is certainly legitimate, but I don't want to claim such a
long patch as the bugfix, with a single compiler warning to show for.

If you prefer, I can do the bugfix separately myself, and then you can
focus on the remaining patches as cleanups for -next.

johannes
