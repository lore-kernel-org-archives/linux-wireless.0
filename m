Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15067 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934659AbdCJKmn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 05:42:43 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rostyslav Khudolii <rkhudolii@airtame.com>,
        "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Attila Sukosd <attila@airtame.com>
Subject: Re: [PATCH] ath6kl: Remove old 802.11a-only channels
Date: Fri, 10 Mar 2017 10:42:25 +0000
Message-ID: <87r3252z2y.fsf@kamboji.qca.qualcomm.com> (sfid-20170310_114255_232885_076D637A)
References: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
        <1489136175.3038.2.camel@sipsolutions.net>
        <CAPXt_daQxHAsPfeRjP0CZfq_Uu4EXHvjsko-EUb0mKmDaef_SQ@mail.gmail.com>
        <1489137311.3038.3.camel@sipsolutions.net>
In-Reply-To: <1489137311.3038.3.camel@sipsolutions.net> (Johannes Berg's
        message of "Fri, 10 Mar 2017 10:15:11 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2017-03-10 at 10:11 +0100, Rostyslav Khudolii wrote:
>> On 10 March 2017 at 09:56, Johannes Berg <johannes@sipsolutions.net>
>> wrote:
>> > On Fri, 2017-03-10 at 09:49 +0100, Rostyslav Khudolii wrote:
>> > > Channels 34/38/42/46 can only be used for compatibility with
>> > > old devices sold in Japan. Modern products, such as AR6003/AR6004
>> > > don't support these channels.
>> > > Keeping them in the upstream is error prone and requires full
>> > > network stack support.
>> >=20
>> > Seems pointless. Nothing in the network stack really cares much
>> > about
>> > the channel numbers, so what exactly does this improve?
>> >=20
>>=20
>> Without this one, a user is able to start an AP using wpa_supplicant,
>> for example, on one of these channels (34/38/42/46), without getting
>> any warning/error from the cfg80211 or ath6kl - which is correct
>> (since these channels match regdom rules). However, the AR6003 and
>> its
>> firmware (we're using v3.4.0.225) will fail and return
>> "WMI_CMDERROR_EVENTID" with "INVALID_PARAM" error code.
>> In my opinion, ath6kl shouldn't support anything the firmware
>> doesn't.
>> We should also handle WMI_CMDERROR_EVENTID properly (not just
>> printing
>> a message), but this is another problem, I believe.
>
> Ah. I didn't make the connection that AR6003 was actually a product
> that used this driver and thought you were using it as another peer and
> then the two couldn't make a connection...
>
> My bad.

I'll copy Rostyslav's description above to the commit log, I think it's
useful information to document.

--=20
Kalle Valo=
