Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33442 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbcEaQUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 12:20:32 -0400
Received: by mail-oi0-f47.google.com with SMTP id k23so305038503oih.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2016 09:20:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rz6N_indSm7WNyJdyWmbKnkx-dTBzwUN=x+m5ooSkbRXA@mail.gmail.com>
References: <1463739223-19205-1-git-send-email-zajec5@gmail.com>
	<1464689804.3076.13.camel@sipsolutions.net>
	<CACna6rw--bPNdWcp1Bx1GOKv9cnOgfr5D_YU1RF7A8CS_Bt7Vg@mail.gmail.com>
	<1464700487.3076.28.camel@sipsolutions.net>
	<CACna6rz6N_indSm7WNyJdyWmbKnkx-dTBzwUN=x+m5ooSkbRXA@mail.gmail.com>
Date: Tue, 31 May 2016 18:20:31 +0200
Message-ID: <CACna6rwcbHye5k5vRrvQg0mHwkMA1p+GgJJK4s=RXTjErHUVFQ@mail.gmail.com> (sfid-20160531_182036_678755_1F203DF1)
Subject: Re: [PATCH iw] add "channels" PHY command listing frequencies with
 more details
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 May 2016 at 17:58, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 31 May 2016 at 15:14, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Tue, 2016-05-31 at 15:10 +0200, Rafał Miłecki wrote:
>>
>>> > Unfortunately, I get compiler warnings about width_* being possibly
>>> > used uninitialized. Can you address that please?
>>> It's nice your compiled got this mistake, my didn't. There were
>>> actually meant to be static. I'll fix that.
>>
>> I actually think the compiler is wrong, and there's no reason for them
>> to be static, is there?
>>
>> The first iteration of the loop should always initialize since -1 is
>> used for initialization?
>>
>> In any case, I'd prefer to avoid static, if necessary pass some kind of
>> context structure in to the function?
>
> I don't know if we can assume getting all three attributes:
> NL80211_BAND_ATTR_HT_CAPA
> NL80211_BAND_ATTR_VHT_CAPA
> NL80211_BAND_ATTR_FREQS
> at the same single handler call. I guess not. That's why I believe we
> need all width_* to be static, so they keep value across separated
> handler calls.

Yes, this is definitely the case. I did some debugging from user space
and printed one line per a single handler call:
[i:0] WIPHY_BANDS:0
[i:1] WIPHY_BANDS:0
[i:2] WIPHY_BANDS:0
[i:3] WIPHY_BANDS:1 ATTR_HT_CAPA:1 ATTR_VHT_CAPA:0 ATTR_FREQS:0
[i:4] WIPHY_BANDS:1 ATTR_HT_CAPA:1 ATTR_VHT_CAPA:1 ATTR_FREQS:0
[i:5] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
[i:6] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
[i:7] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
[i:8] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
[i:9] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
[i:10] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
[i:11] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
[i:12] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
[i:13] WIPHY_BANDS:1 ATTR_HT_CAPA:0 ATTR_VHT_CAPA:0 ATTR_FREQS:1
(...)

As you can see we have ATTR_HT_CAPA and ATTR_VHT_CAPA set only in few
early calls. It means we need to extract info from them and store it
in static variables.
