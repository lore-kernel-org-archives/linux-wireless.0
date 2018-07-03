Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753987AbeGCGO4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 02:14:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
References: <20180518093007.23594-1-pkshih@realtek.com>
        <20180518093007.23594-14-pkshih@realtek.com>
        <87po1fhwfd.fsf@purkki.adurom.net>
        <1527732798.8418.7.camel@realtek.com> <87sh56f3sv.fsf@codeaurora.org>
        <1530597815.6330.4.camel@realtek.com>
Date: Tue, 03 Jul 2018 09:14:44 +0300
In-Reply-To: <1530597815.6330.4.camel@realtek.com> (pkshih@realtek.com's
        message of "Tue, 3 Jul 2018 06:03:42 +0000")
Message-ID: <87y3esrgkr.fsf@kamboji.qca.qualcomm.com> (sfid-20180703_081500_717675_CE320020)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

> On Fri, 2018-06-29 at 10:30 +0300, Kalle Valo wrote:
>> Pkshih <pkshih@realtek.com> writes:
>>=20
>> > On Tue, 2018-05-29 at 08:18 +0300, Kalle Valo wrote:
>> >> <pkshih@realtek.com> writes:
>> >>=C2=A0
>> >
>> > Because C2H data is little endian order, the struct will look like
>> > struct foo {
>> > #ifdef=C2=A0__LITTLE_ENDIAN
>> >=C2=A0	u8 bar:4;
>> >=C2=A0	u8 koo:4;
>> > #else
>> >=C2=A0	u8 koo:4;
>> >=C2=A0	u8 bar:4;
>> > #endif
>> > }
>>=20
>> With u8 you don't need endian check, right? I would assume that with
>> both little and big endian bar and koo would be in the same place.
>
> I think u8 with bitfield would be different between little and big endian
> machines.

To me that does not make any sense, I have never heard about bit
endianness any of the devices I have worked on.

https://en.wikipedia.org/wiki/Endianness

--=20
Kalle Valo
