Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65239 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab0EFSwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:52:03 -0400
Received: by bwz19 with SMTP id 19so171283bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 11:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005062038.24982.helmut.schaa@googlemail.com>
References: <201005061229.04897.helmut.schaa@googlemail.com>
	 <s2ma32f33a41005061001w5e7258f0p3715ec238a00a4f4@mail.gmail.com>
	 <201005062038.24982.helmut.schaa@googlemail.com>
Date: Thu, 6 May 2010 20:51:58 +0200
Message-ID: <m2wa32f33a41005061151h6aa62957qde225d5d8654a631@mail.gmail.com>
Subject: Re: [PATCH 1/3] rt2x00: rt2800: update initial SIFS values
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 6, 2010 at 8:38 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Donnerstag 06 Mai 2010 schrieb Ivo Van Doorn:
>> On Thu, May 6, 2010 at 12:29 PM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>> > Currently the CCK and OFDM SIFS value is set to 32us. This value is neither
>> > used by the Ralink driver nor specified in 802.11.
>> >
>> > Instead of using 10us for CCK SIFS (as defined in 802.11) use 16us like in the
>> > Ralink drivers. And indeed using a SIFS value of 10us breaks connectivity with
>> > 11g + CTS protected connections. Add a comment to the code why we don't use 10us
>> > for CCK SIFS value.
>> >
>> > The OFDM SIFS value is set to 16us (as defined in 802.11 and also used by the
>> > Ralink drivers).
>>
>> Just wondering, but we hardcode the SIFS value in the rt2x00.h file.
>> Perhaps we should remove it in there, and no longer pass it from
>> rt2x00lib. That way there can't be any confusion about which drivers
>> uses the sifs field and whcih do not.
>
> Yes, wouldn't be too bad I guess. But all non 2800 drivers use the same sifs
> value, so we could just leave the define in rt2x00.h and remove the sifs value
> from the config_erp calback and use the define in all other places?

Well I would still remove the define in that case. I think some of the
legacy drivers
work with different SIFS values but always accepted the value which we used in
the define. So I would still remove the define, and then each driver
is free to set
the value as used in the legacy drivers.

> Nevertheless, I'm not sure why the rt2800 devices don't like the 10us CCK
> SIFS value (which is defined in 802.11) but I wasn't able to get CTS to self
> working correctly with it set to 10 (the actual data frame was sent out
> way too late after the CTS frame, somtimes with delays >100us). Using the 16us
> also for CCK (as the ralink drivers do) results in perfect CTS & data frame
> timing. Maybe it's a hardware issue and the (ralink) driver just works around
> it?

Yes, I expect it to be case. This kind of odd values are used in the
legacy drivers
for other settings as well.

Ivo
