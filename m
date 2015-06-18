Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:58089 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbbFRKgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 06:36:13 -0400
Message-ID: <55829F18.9050807@neratec.com> (sfid-20150618_123616_957557_6093F09B)
Date: Thu, 18 Jun 2015 12:36:08 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: spectral - simplify max_index calculation
References: <1434446492-4127-1-git-send-email-zefir.kurtisi@neratec.com> <CAFtRNNxvBC8SD3P5u=bEZPofA-A8YfHYuZnfA4Y07W7Wx4keAQ@mail.gmail.com>
In-Reply-To: <CAFtRNNxvBC8SD3P5u=bEZPofA-A8YfHYuZnfA4Y07W7Wx4keAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2015 10:43 AM, Nick Kossifidis wrote:
> max_index is a 6bit signed integer in both cases (sorry for the 5bit
> typo in the comments), so the current function handles it correctly
> for both HT20 and dynamic HT20/40 modes (I've tested it extensively).
> Also you don't handle the negative indices we get from the hardware
> (you just remove the sign). Have you tested this and if you did on
> which hardware did you do the test ?
> 
> 2015-06-16 11:21 GMT+02:00 Zefir Kurtisi <zefir.kurtisi@neratec.com>:
>> [...]
>> +/* return the max magnitude from the all/upper/lower bins
>> + *
>> + * in HT20: 6-bit signed number of range -28 to +27
>> + * in HT40: 6-bit unsigned number of range 0 to +63
>> + *          (upper sub-channel index 0 is DC)
>> + *
>> + * Correct interpretation of the value has to be done at caller
>> + */

The comment above is taken from developer NDA documents and should be correct.
With that, in HT40 mode the max_index value has to be taken as is, while in HT20
it needs to be shifted to the unsigned range.

I used the proposed method with the chirp detector for FFTs provided for long
radar pulses on an AR9590 (patch posted the same day). Max bin index is used there
the same way as with spectral, but now I realize my mistake: for chirp detection,
the relative max_index is sufficient, while for spectral the absolute value is needed.

Toggling the MSB in HT20 shifts the signed values by 32 and leaves the index with
an offset of 4, therefore the correct operation should be:
ht20_max_index_absolute = (ht20_max_index ^ 0x20) - 4

The following code snipped proves the correctness of the operation:

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

const char *char_to_bin(char x)
{
	int z;
	static char b[7];
	b[0] = '\0';
	for (z = 32; z > 0; z >>= 1)
		strcat(b, ((x & z) == z) ? "1" : "0");
	return b;
}
int main (void)
{
	char s;
	for (s = -28; s < 28; s++)
		printf("%3d: %s\n", s, char_to_bin((s ^ 0x20) - 4));
	return 0;
}

I'll provide a v2 patch for you to test. My intention with this is not to fix
something that is already working, but to share the related functions between
spectral and chirp detector.


Thanks,
Zefir

