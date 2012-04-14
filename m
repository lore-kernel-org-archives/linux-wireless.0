Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51509 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2DNWLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 18:11:36 -0400
Received: by vcqp1 with SMTP id p1so2678866vcq.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 Apr 2012 15:11:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334433719-1144-1-git-send-email-juhosg@openwrt.org>
References: <1334433719-1144-1-git-send-email-juhosg@openwrt.org>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sat, 14 Apr 2012 15:11:15 -0700
Message-ID: <CALSq=BYgJ-bawvPPb7bcqL2XXQjA8=j3irdr6h41C-G7CE3C=Q@mail.gmail.com> (sfid-20120415_001139_958035_55AAC77F)
Subject: Re: [PATCH 1/3] ath9k: use consistent value for REDUCE_SCALED_POWER_BY_THREE_CHAIN
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Failed to reply-all originally, sorry:)

Erm...

On Sat, Apr 14, 2012 at 1:01 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>
> In eeprom_def.c and in ar9003_eeprom.c the value
> of the symbol is 9, however the comments in these
> files indicates the value should be 10*log10(3)*2
> which is 9.54242509439325. Replace the the value
> to 10 in these files.

So the truncated constant is off by a quarter-dB for 9 or for 10. Do
the chips care one way or the other? (For comparison, Intel uses 4.5
dB, i.e. 9 in this notation, to mean "divide-by-3". That's what ath9k
has now).

Are you making it consistent with some other file that's not mentioned
here? If not, why?

>  #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
> -#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   9  /* 10*log10(3)*2 */
> +#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
>  #define PWRINCR_3_TO_1_CHAIN      9             /* 10*log(3)*2 */

Why only change one of two 9s to a 10? Why not also PWRINCR_3_TO_1_CHAIN?

Dan
