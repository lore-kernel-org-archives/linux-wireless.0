Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44214 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0CHD5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 22:57:13 -0500
Received: by pvb32 with SMTP id 32so1310368pvb.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Mar 2010 19:57:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100308025841.7460.69949.stgit@void>
References: <20100308025841.7460.69949.stgit@void>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 7 Mar 2010 19:56:52 -0800
Message-ID: <43e72e891003071956xb651ec0he6774b43c56d8d91@mail.gmail.com>
Subject: Re: [PATCH v2] ath5k: fix I/Q calibration (for real)
To: Bruno Randolf <br1@einfach.org>
Cc: me@bobcopeland.com, linville@tuxdriver.com, 8an@praha12.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, benoit.papillault@free.fr
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 7, 2010 at 6:59 PM, Bruno Randolf <br1@einfach.org> wrote:
> I/Q calibration was completely broken, resulting in a high number of CRC errors
> on received packets. before i could see around 10% to 20% CRC errors, with this
> patch they are between 0% and 3%.
>
> 1.) the removal of the mask in commit "ath5k: Fix I/Q calibration
> (f1cf2dbd0f798b71b1590e7aca6647f2caef1649)" resulted in no mask beeing used
> when writing the I/Q values into the register. additional errors in the
> calculation of the values (see 2.) resulted too high numbers, exceeding the
> masks, so wrong values like 0xfffffffe were written. to be safe we should
> always use the bitmask when writing parts of a register.
>
> 2.) using a (s32) cast for q_coff is a wrong conversion to signed, since we
> convert to a signed value later by substracting 128. this resulted in too low
> numbers for Q many times, which were limited to -16 by the boundary check later
> on.
>
> 3.) checked everything against the HAL sources and took over comments and minor
> optimizations from there.
>
> 4.) we can't use ENABLE_BITS when we want to write a number (the number can
> contain zeros). also always write the correction values first and set ENABLE
> bit last, like the HAL does.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
> v2: use clamp() as Bob suggested

Thanks Bruno, are these stable fixes?

  Luis
