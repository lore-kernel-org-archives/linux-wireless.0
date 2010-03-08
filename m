Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64202 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab0CHQZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 11:25:10 -0500
Received: by vws9 with SMTP id 9so2833204vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 08:25:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003081317.25155.br1@einfach.org>
References: <20100308025841.7460.69949.stgit@void> <43e72e891003071956xb651ec0he6774b43c56d8d91@mail.gmail.com>
	<201003081317.25155.br1@einfach.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Mar 2010 08:24:48 -0800
Message-ID: <43e72e891003080824l74ecd4fbrf5a02e51c275c9b1@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: fix I/Q calibration (for real)
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 7, 2010 at 8:17 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Monday 08 March 2010 12:56:52 Luis R. Rodriguez wrote:
>> On Sun, Mar 7, 2010 at 6:59 PM, Bruno Randolf <br1@einfach.org> wrote:
>> > I/Q calibration was completely broken, resulting in a high number of CRC
>> > errors on received packets. before i could see around 10% to 20% CRC
>> > errors, with this patch they are between 0% and 3%.
>> >
>> > 1.) the removal of the mask in commit "ath5k: Fix I/Q calibration
>> > (f1cf2dbd0f798b71b1590e7aca6647f2caef1649)" resulted in no mask beeing
>> > used when writing the I/Q values into the register. additional errors in
>> > the calculation of the values (see 2.) resulted too high numbers,
>> > exceeding the masks, so wrong values like 0xfffffffe were written. to be
>> > safe we should always use the bitmask when writing parts of a register.
>> >
>> > 2.) using a (s32) cast for q_coff is a wrong conversion to signed, since
>> > we convert to a signed value later by substracting 128. this resulted in
>> > too low numbers for Q many times, which were limited to -16 by the
>> > boundary check later on.
>> >
>> > 3.) checked everything against the HAL sources and took over comments and
>> > minor optimizations from there.
>> >
>> > 4.) we can't use ENABLE_BITS when we want to write a number (the number
>> > can contain zeros). also always write the correction values first and
>> > set ENABLE bit last, like the HAL does.
>> >
>> > Signed-off-by: Bruno Randolf <br1@einfach.org>
>> > ---
>> > v2: use clamp() as Bob suggested
>>
>> Thanks Bruno, are these stable fixes?
>
> hi luis!
>
> i think so. the behaviour before was completely broken, now it's better.
>
> but i'm not sure about that whole Cc: stable@kernel.org thing... (sorry i've
> been away for a while)... i read Documentation/stable_kernel_rules.txt but
> still not sure if that applies for this patch.

Just add:

Cc: stable@kernel.org

below your Singed-off-by on the commit log entry. That list will get
spammed once the patch is merged on Linus' tree.

  Luis
