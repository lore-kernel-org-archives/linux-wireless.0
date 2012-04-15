Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:52676 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717Ab2DORV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 13:21:57 -0400
Message-ID: <4F8B03B4.8090501@openwrt.org> (sfid-20120415_192216_267409_D5596260)
Date: Sun, 15 Apr 2012 19:21:56 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 1/3] ath9k: use consistent value for REDUCE_SCALED_POWER_BY_THREE_CHAIN
References: <1334433719-1144-1-git-send-email-juhosg@openwrt.org> <CALSq=BYgJ-bawvPPb7bcqL2XXQjA8=j3irdr6h41C-G7CE3C=Q@mail.gmail.com>
In-Reply-To: <CALSq=BYgJ-bawvPPb7bcqL2XXQjA8=j3irdr6h41C-G7CE3C=Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thank you for the comments.

> (Failed to reply-all originally, sorry:)
> 
> Erm...
> 
> On Sat, Apr 14, 2012 at 1:01 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>>
>> In eeprom_def.c and in ar9003_eeprom.c the value
>> of the symbol is 9, however the comments in these
>> files indicates the value should be 10*log10(3)*2
>> which is 9.54242509439325. Replace the the value
>> to 10 in these files.
> 
> So the truncated constant is off by a quarter-dB for 9 or for 10. Do
> the chips care one way or the other? (For comparison, Intel uses 4.5
> dB, i.e. 9 in this notation, to mean "divide-by-3". That's what ath9k
> has now).

In my understanding the value is not related to the chip. It is used for
per-chain tx power reduction, in order to ensure regulatory compliance. Using 10
instead of 9 means that the overall tx power will be lower.

> Are you making it consistent with some other file that's not mentioned
> here? If not, why?

I'm tyring to make it consistent between ar9003_eeprom.c, eeprom_def.c and
eeprom_9287.c. The first two files uses 9, whereas eeprom_9287 uses 10.

Considering Felix's comment, I will update the patch and will use 9 instead of
10. Although that will replace the value in eeprom_9287.c, but that should not
cause problems, because the AR9287 does not supports 3x3.

>>  #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
>> -#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   9  /* 10*log10(3)*2 */
>> +#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
>>  #define PWRINCR_3_TO_1_CHAIN      9             /* 10*log(3)*2 */
> 
> Why only change one of two 9s to a 10? Why not also PWRINCR_3_TO_1_CHAIN?

The PWRINCR_* symbols are not used anywhere and should be removed.

-Gabor
