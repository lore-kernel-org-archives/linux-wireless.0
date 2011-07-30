Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37585 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1G3SYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 14:24:55 -0400
Received: by qyk9 with SMTP id 9so2671607qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 11:24:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107301754.13432.chunkeey@googlemail.com>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <201107301317.14486.chunkeey@googlemail.com>
 <CAB=NE6V-=m+S2mkK5ugAfUnBUD_Wvttot6rndC6ToCi8hc2RGw@mail.gmail.com> <201107301754.13432.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 30 Jul 2011 11:24:35 -0700
Message-ID: <CAB=NE6UhZNV0-SLP_pRP5iVbCy6O6C8vfnUSouv7-vP0R6hfUw@mail.gmail.com> (sfid-20110730_202458_937255_9A1277B8)
Subject: Re: problem on ACS
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: MingAnn Ng <devil_eddie01@hotmail.com>, nbd@openwrt.org,
	wireless testing <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 30, 2011 at 8:54 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Saturday 30 July 2011 13:29:52 Luis R. Rodriguez wrote:
>> On Sat, Jul 30, 2011 at 4:17 AM, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>> > Wait a sec... I guess you misunderstood my post about the cut-off.
>> > I meant that you can cut of at the bottom by using log2(max(1, val)).
>> > This ensures that the log2 will always be >= 0 anyway. In fact log2(1) = 0.
>>
>> I get that now, but my point was that we also had to cap it for a
>> higher value too. We now restrict the input to values within the data
>> type and also ensure log2 will always be >= 0.
> Doesn't acs [not to be confused with cisco acs] use u64 for all input
> data? If so, why do we need to restrict those? After all 2^64-1 ms is
> still around 584.9 million years.
>
> (BTW: I don't understand the comment of log2_sane.
> log2(2^30) + log2(2^30) = 60. so this should work very well
> with a long double. Even with just 80-bit, the range goes from
> something like 3.65 * 10^-4951 to 1.19 x 10^4932.)

Input data is u64, however interference factor is long double.

  Luis
