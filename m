Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50736 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932169AbeGCIcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 04:32:04 -0400
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
To: Kalle Valo <kvalo@codeaurora.org>, Pkshih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
References: <20180518093007.23594-1-pkshih@realtek.com>
 <20180518093007.23594-14-pkshih@realtek.com>
 <87po1fhwfd.fsf@purkki.adurom.net> <1527732798.8418.7.camel@realtek.com>
 <87sh56f3sv.fsf@codeaurora.org> <1530597815.6330.4.camel@realtek.com>
 <87y3esrgkr.fsf@kamboji.qca.qualcomm.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <b69340e7-b7ae-2b54-9488-c9c7bcffecf2@nbd.name> (sfid-20180703_103209_329021_810946F9)
Date: Tue, 3 Jul 2018 10:32:00 +0200
MIME-Version: 1.0
In-Reply-To: <87y3esrgkr.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-03 08:14, Kalle Valo wrote:
> Pkshih <pkshih@realtek.com> writes:
> 
>> On Fri, 2018-06-29 at 10:30 +0300, Kalle Valo wrote:
>>> Pkshih <pkshih@realtek.com> writes:
>>> 
>>> > On Tue, 2018-05-29 at 08:18 +0300, Kalle Valo wrote:
>>> >> <pkshih@realtek.com> writes:
>>> >> 
>>> >
>>> > Because C2H data is little endian order, the struct will look like
>>> > struct foo {
>>> > #ifdef __LITTLE_ENDIAN
>>> > 	u8 bar:4;
>>> > 	u8 koo:4;
>>> > #else
>>> > 	u8 koo:4;
>>> > 	u8 bar:4;
>>> > #endif
>>> > }
>>> 
>>> With u8 you don't need endian check, right? I would assume that with
>>> both little and big endian bar and koo would be in the same place.
>>
>> I think u8 with bitfield would be different between little and big endian
>> machines.
> 
> To me that does not make any sense, I have never heard about bit
> endianness any of the devices I have worked on.
Unfortunately, the order in which these fields are laid out is different
between big and little endian, even when only dealing with u8.
That alone is a strong reason to avoid bitfields entirely for anything
shared between the host and something else.

- Felix
