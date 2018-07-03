Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752721AbeGCK5c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 06:57:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: Pkshih <pkshih@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
References: <20180518093007.23594-1-pkshih@realtek.com>
        <20180518093007.23594-14-pkshih@realtek.com>
        <87po1fhwfd.fsf@purkki.adurom.net>
        <1527732798.8418.7.camel@realtek.com> <87sh56f3sv.fsf@codeaurora.org>
        <1530597815.6330.4.camel@realtek.com>
        <87y3esrgkr.fsf@kamboji.qca.qualcomm.com>
        <b69340e7-b7ae-2b54-9488-c9c7bcffecf2@nbd.name>
Date: Tue, 03 Jul 2018 13:57:27 +0300
In-Reply-To: <b69340e7-b7ae-2b54-9488-c9c7bcffecf2@nbd.name> (Felix Fietkau's
        message of "Tue, 3 Jul 2018 10:32:00 +0200")
Message-ID: <87po04r3hk.fsf@kamboji.qca.qualcomm.com> (sfid-20180703_125741_214799_BCE73A8C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2018-07-03 08:14, Kalle Valo wrote:
>> Pkshih <pkshih@realtek.com> writes:
>>=20
>>> On Fri, 2018-06-29 at 10:30 +0300, Kalle Valo wrote:
>>>> Pkshih <pkshih@realtek.com> writes:
>>>>=20
>>>> > On Tue, 2018-05-29 at 08:18 +0300, Kalle Valo wrote:
>>>> >> <pkshih@realtek.com> writes:
>>>> >>=C2=A0
>>>> >
>>>> > Because C2H data is little endian order, the struct will look like
>>>> > struct foo {
>>>> > #ifdef=C2=A0__LITTLE_ENDIAN
>>>> >=C2=A0	u8 bar:4;
>>>> >=C2=A0	u8 koo:4;
>>>> > #else
>>>> >=C2=A0	u8 koo:4;
>>>> >=C2=A0	u8 bar:4;
>>>> > #endif
>>>> > }
>>>>=20
>>>> With u8 you don't need endian check, right? I would assume that with
>>>> both little and big endian bar and koo would be in the same place.
>>>
>>> I think u8 with bitfield would be different between little and big endi=
an
>>> machines.
>>=20
>> To me that does not make any sense, I have never heard about bit
>> endianness any of the devices I have worked on.
>
> Unfortunately, the order in which these fields are laid out is different
> between big and little endian, even when only dealing with u8.

Oh, didn't know that. Can you give some examples about endian problems
with u8 bitfields? Still not getting it. Not that it matters, just
curious.

> That alone is a strong reason to avoid bitfields entirely for anything
> shared between the host and something else.

Very good to know, thanks.

--=20
Kalle Valo
