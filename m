Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:48736 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYAVBUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 20:20:54 -0500
Received: by an-out-0708.google.com with SMTP id d31so488563and.103
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2008 17:20:53 -0800 (PST)
Message-ID: <40f31dec0801211720h4ae38da4uf344dae65821eef7@mail.gmail.com> (sfid-20080122_012057_986534_30EB66CA)
Date: Tue, 22 Jan 2008 03:20:53 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: use AR5K_KEYTABLE_SIZE when initializing key table
Cc: linux-wireless@vger.kernel.org,
	"ath5k mailing-list" <ath5k-devel@lists.ath5k.org>,
	"Bruno Randolf" <bruno@thinktube.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <1200947765-12012-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1200947765-12012-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/21, John W. Linville <linville@tuxdriver.com>:
> ...instead of using AR5K_KEYCACHE_SIZE, which would seem to be a
> typo/thinko...
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath5k/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 742616a..75e5970 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -663,7 +663,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
>          * Reset the key cache since some parts do not
>          * reset the contents on initial power up.
>          */
> -       for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
> +       for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
>                 ath5k_hw_reset_key(ah, i);
>
>         /*
> --
> 1.5.3.3
>

This seems ok since we check entry against KEYTABLE_SIZE (it was
indeed a typo)...

int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
{
	unsigned int i;

	ATH5K_TRACE(ah->ah_sc);
	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
...

So it's O.K. by me ;-)

But now that you 've mentioned it, i have found the following...

reset_key seems ok for 5211 since the whole cache is zeroed, that's
what we also get on regdumps during atach...

W: 0x8800 = 0x00000000 - AR5K_KEYTABLE_0_5211(0)
................................ (ath_hal_keyreset)
W: 0x8804 = 0x00000000 - AR5K_KEYTABLE_0_5211(1)
................................ (ath_hal_keyreset)
W: 0x8808 = 0x00000000 - AR5K_KEYTABLE_0_5211(2)
................................ (ath_hal_keyreset)

...

W: 0x97f4 = 0x00000000 - AR5K_KEYTABLE_0_5211(1021)
................................ (ath_hal_keyreset)
W: 0x97f8 = 0x00000000 - AR5K_KEYTABLE_0_5211(1022)
................................ (ath_hal_keyreset)
W: 0x97fc = 0x00000000 - AR5K_KEYTABLE_0_5211(1023)
................................ (ath_hal_keyreset)

(We have 128 * 8 = 1024 entries as expected)

BUT on newer chips, during reset the cache is not entirely zero, check
this out...

This is repeating for every key cache entry (every 8 steps on the table)...

a) We read the register entry + 5 (in our code just before the for
loop -we need nested loops for this)...
R: 0x8814 = 0x00003058 - AR5K_KEYTABLE_0_5211(5)
..................11.....1.11... (ath_hal_keyreset)

b) Inside the for loop we just replace it with 0x00000007 (no matter
what we read)...
W: 0x8814 = 0x00000007 - AR5K_KEYTABLE_0_5211(5)
.............................111 (unknown)

This is how it looks...

1st entry...
R: 0x8814 = 0x00003058 - AR5K_KEYTABLE_0_5211(5)
..................11.....1.11... (ath_hal_keyreset)
W: 0x8800 = 0x00000000 - AR5K_KEYTABLE_0_5211(0)
................................ (ath_hal_keyreset)
W: 0x8804 = 0x00000000 - AR5K_KEYTABLE_0_5211(1)
................................ (ath_hal_keyreset)
W: 0x8808 = 0x00000000 - AR5K_KEYTABLE_0_5211(2)
................................ (ath_hal_keyreset)
W: 0x880c = 0x00000000 - AR5K_KEYTABLE_0_5211(3)
................................ (ath_hal_keyreset)
W: 0x8810 = 0x00000000 - AR5K_KEYTABLE_0_5211(4)
................................ (ath_hal_keyreset)
W: 0x8814 = 0x00000007 - AR5K_KEYTABLE_0_5211(5)
.............................111 (ath_hal_keyreset)
W: 0x8818 = 0x00000000 - AR5K_KEYTABLE_0_5211(6)
................................ (ath_hal_keyreset)
W: 0x881c = 0x00000000 - AR5K_KEYTABLE_0_5211(7)
................................ (ath_hal_keyreset)

2nd entry...
R: 0x8834 = 0x0000be95 - AR5K_KEYTABLE_0_5211(13)
................1.11111.1..1.1.1 (ath_hal_keyreset)
W: 0x8820 = 0x00000000 - AR5K_KEYTABLE_0_5211(8)
................................ (ath_hal_keyreset)
W: 0x8824 = 0x00000000 - AR5K_KEYTABLE_0_5211(9)
................................ (ath_hal_keyreset)
W: 0x8828 = 0x00000000 - AR5K_KEYTABLE_0_5211(10)
................................ (ath_hal_keyreset)
W: 0x882c = 0x00000000 - AR5K_KEYTABLE_0_5211(11)
................................ (ath_hal_keyreset)
W: 0x8830 = 0x00000000 - AR5K_KEYTABLE_0_5211(12)
................................ (ath_hal_keyreset)
W: 0x8834 = 0x00000007 - AR5K_KEYTABLE_0_5211(13)
.............................111 (ath_hal_keyreset)
W: 0x8838 = 0x00000000 - AR5K_KEYTABLE_0_5211(14)
................................ (ath_hal_keyreset)
W: 0x883c = 0x00000000 - AR5K_KEYTABLE_0_5211(15)
................................ (ath_hal_keyreset)

etc.

Same happens on 5418 also (just there registers always read
0x00000007, at least in my case).

So for chips newer than 5211 we have to tweak reset_key a little. I
have a patch ready but i'll post them all together on my next series
that 'll addd 2413 support + rf code cleanups/refactoring (currently
we 're having exams and i don't have any time to propertly make a
patch series the way i want to).


Anyway this patch is correct so thanx again ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
