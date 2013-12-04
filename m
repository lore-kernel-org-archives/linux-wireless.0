Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:62716 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3LDJIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 04:08:32 -0500
Received: by mail-ie0-f176.google.com with SMTP id at1so26328697iec.35
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 01:08:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386145635.4284.10.camel@jlt4.sipsolutions.net>
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	<1386060648-6020-4-git-send-email-janusz.dziedzic@tieto.com>
	<1386080659.4393.29.camel@jlt4.sipsolutions.net>
	<CALhHN=q63LmZb7CvO=4sDWf70-O7_vc7T6jhU7gFQNtsH7PuDQ@mail.gmail.com>
	<1386145635.4284.10.camel@jlt4.sipsolutions.net>
Date: Wed, 4 Dec 2013 10:08:32 +0100
Message-ID: <CAFED-jkJ0d+AAmjusWXhFH5dutof7VSQkwqK+Ead1M8JUmhjVg@mail.gmail.com> (sfid-20131204_100845_167594_69A34497)
Subject: Re: [PATCH 4/4] nl80211: add VHT support for set_bitrate_mask
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/12/4 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2013-12-03 at 17:21 +0100, Janusz Dziedzic wrote:
>
>> We need this for test purpose. Need to test different MCS/NSS
>> configurations using our HW (mainly for VHT).
>> Our HW supports setting TX fixed_rate for legacy/HT/VHT.
>> So, we decided to use set_tx_bitrate_mask() as the best interface for
>> that in nl80211.
>> And after that we realize VHT implementation/change will be needed in
>> nl80211/iw also.
>> Because of that I send this VHT patch.
>> So, we need this :)
>
> Fair enough - please add a line or two to the commit log.
>
>> >> +#define NL80211_MAX_SUPP_VHT_RATES           80
>> >
>> > Where does 80 come from? That seems odd?
>> >
>> NSS_MAX (8) * MCS_MAX (10)
>>
>> Eg.
>> 9 - NSS=1, MCS=9
>> 10 - NSS=2, MCS=0
>> 11 - NSS=2, MCS=1
>> ...
>
> Can we please find a better way to encode this?
>
>> >> + * @NL80211_TXRATE_VHT_MCS: VHT (MCS) rates allowed for TX rate selection
>> >> + *   in an array of MCS numbers.
>> >
>> > VHT has no "MCS numbers", so this doesn't make much sense?
>> >
>> You mean description only or mcs mask for vht (like above)?
>
> Well, for VHT, there's no single "MCS" identifier for a rate, rates are
> identified using MCS (0-9) and NSS (1-8). In mac80211, we do some bit
> tricks to fit them into a single byte, but I see no reason to do this in
> the nl80211 API and would rather have an API that makes this obvious.
> The easiest would be using a struct, but then you don't need 80 bytes,
> only 8 bitmaps (one for each NSS), for example.
>
Yes, and I added 8 bitmaps:

+ u16 vht_mcs[IEEE80211_VHT_NSS_MAX];

80 bytes is because of format we will from user mode (80 available
combinations for VHT mask).
I decided for:
>> 9 - NSS=1, MCS=9
>> 10 - NSS=2, MCS=0
>> 11 - NSS=2, MCS=1
To be compatible with ht-mcs set.
You mean better to send 8*u16 from user mode and do conversion in IW
(currently we send 80 bytes and do conversion in nl80211, same as for
HT)?

BR
Janusz
