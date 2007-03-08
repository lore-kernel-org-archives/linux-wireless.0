Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:32457 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbXCHT0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 14:26:31 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1056714uga
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2007 11:26:28 -0800 (PST)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sparse using insane amounts of memory
Date: Thu, 8 Mar 2007 20:26:15 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	linux-sparse@vger.kernel.org
References: <1173319356.3546.54.camel@johannes.berg> <200703081908.40997.IvDoorn@gmail.com> <Pine.LNX.4.64.0703081023490.10832@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703081023490.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703082026.15305.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > 	#define is_power_of_two(x) (!((x) & ((x)-1)))
> > 	#define low_bit_mask(x) (((x)-1) & ~(x))
> > 	#define is_contiguous_mask(x) is_power_of_two(1 + (x) + low_bit_mask(x))
> 
> Side note: I didn't check this. So if you actually do this, please 
> double-check. The math should all be good, but there's a few caveats:

Checked, and seems to work. Even sparse appears to be very happy. :)
I'll do some more extensive testing later today before submitting a patch.
 
> The "zero is special" thing means that if you don't want to accept zero as 
> a valid mask (it technically *is* a contiguous set of bits set - it's just 
> the empty set) you'd need to check for it specially.

Good point, I'll add a check for that as well.

> Thus endeth Linus' "games with bits" lecture. It was probably more than 
> you really wanted to know. There's a ton of games you can play with simple 
> "x-1" and bitmasking ops like this).

Thanks, for both the macro's and the lecture. ;)

Ivo
