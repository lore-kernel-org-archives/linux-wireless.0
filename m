Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:49029 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935325AbeEIV1g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:27:36 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [wl-testing/master] build regression in brcmfmac
In-Reply-To: <1525900945.6910.28.camel@sipsolutions.net>
References: <5AF36449.9050906@broadcom.com> <1525900945.6910.28.camel@sipsolutions.net>
Date: Wed, 09 May 2018 23:27:42 +0200
Message-ID: <874ljgzfht.fsf@toke.dk> (sfid-20180509_232740_097570_36C986E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-05-09 at 23:12 +0200, Arend van Spriel wrote:
>> Since yesterday I get the following build error on wl-testing/master:
>>=20
>>    CC [M]  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.o
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function=
=20
>> =E2=80=98brcmf_notify_connect_status_ap=E2=80=99:
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5530:1:=20
>> error: the frame size of 1592 bytes is larger than 1024 bytes=20
>> [-Werror=3Dframe-larger-than=3D]
>>   }
>>   ^
>>=20
>> In the function brcmf_notify_connect_status_ap() I do have following on=
=20
>> the stack:
>>=20
>> static s32
>> brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
>>                                 struct net_device *ndev,
>>                                 const struct brcmf_event_msg *e, void *d=
ata)
>> {
>>          static int generation;
>>          u32 event =3D e->event_code;
>>          u32 reason =3D e->reason;
>>          struct station_info sinfo;
>>=20
>> I guess the struct station_info grew bigger by these commits:
>>=20
>> 52539ca cfg80211: Expose TXQ stats and parameters to userspace	+816
>> 81d5439 cfg80211: average ack rssi support for data frames	+1
>>=20
>> There are a number of other (cfg80211-based) drivers doing the same=20
>> thing, ie. mwifiex, ath6kl, qtnfmac.
>
> Yeah. Toke said this morning he was working on fixes.

That would be these:

https://patchwork.kernel.org/patch/10389333/
https://patchwork.kernel.org/patch/10389331/
https://patchwork.kernel.org/patch/10389335/

-Toke
