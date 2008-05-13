Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37896 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbYEMXZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 19:25:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] b43: use the bitrev helpers rather than rolling a private one
Date: Wed, 14 May 2008 01:24:07 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1210708518.6191.0.camel@brick>
In-Reply-To: <1210708518.6191.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805140124.07982.mb@bu3sch.de> (sfid-20080514_012550_045801_B00D4541)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 May 2008 21:55:18 Harvey Harrison wrote:
> The 4-bit reversal flip_4bit is replaced with the bitrev helper
> bitrev8 and a 4-bit shift.  The B43_WARN is moved to the location
> where a register is read from for checking there.  The other caller
> explicitly passes an array index which is guaranteed to be within range
> and so a B43_WARN is not added there.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

ACK

But I'd prefer if we had something like the following
and use that:

#define bitrev4(x)	(bitrev8(x) >> 4)

This way the confusing (confusing to me :) ) shifts in the code would go away.
I have a hard time realizing that
bitrev8(x) >> 3
does actually mean
bitrev4(x) << 1
Maybe I'm just stupid, though. :)

> @@ -3069,13 +3053,13 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
>  		}
>  		radio_stacksave(0x0078);
>  		tmp = (b43_radio_read16(dev, 0x0078) & 0x001E);
> -		flipped = flip_4bit(tmp);
> +		B43_WARN_ON(tmp > 15);
> +		flipped = bitrev8(tmp) >> 4;
>  		if (flipped < 10 && flipped >= 8)


-- 
Greetings Michael.
