Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:12394 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759654AbYJ3VvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 17:51:05 -0400
Received: by yx-out-2324.google.com with SMTP id 8so377800yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 14:51:04 -0700 (PDT)
Message-ID: <40f31dec0810301451t3f704406u50c8514c1aa3bd4a@mail.gmail.com> (sfid-20081030_225113_005353_9106CC81)
Date: Thu, 30 Oct 2008 23:51:03 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Update PCU code
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20081030032426.GB26970@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081029021121.GA3079@makis>
	 <20081029024603.GA22759@hash.localnet>
	 <40f31dec0810290408h5ee08c8l1e14d576064f01a4@mail.gmail.com>
	 <b6c5339f0810290705j36995186j382a8415886fb061@mail.gmail.com>
	 <40f31dec0810290741t6378eebelbdacf4e5c8d63bff@mail.gmail.com>
	 <20081030032426.GB26970@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/30 Bob Copeland <me@bobcopeland.com>:
> On Wed, Oct 29, 2008 at 04:41:22PM +0200, Nick Kossifidis wrote:
>> 2008/10/29 Bob Copeland <me@bobcopeland.com>:
>> Yup you are right, we should set both to NULL so a temp micentry var
>> would do the trick.
>>
>> Should i resend this one or you 'll resend yours ?
>
> Well I just decided to put this in a different patch.  Then I saw the
> 5211 check.. we already read the type without such a check and the
> other tkip stuff may well all blow up on such hardware.  So not sure
> what to do about that case.
>
> Anyway feel free to just roll this up into your original patch, or to
> write it differently given the above.
>
> From: Bob Copeland <me@bobcopeland.com>
> Subject: [PATCH] ath5k: fix keytable type buglet in ath5k_hw_reset_key
>
> Be sure we clear out both the mic (if applicable) and
> the encryption key type.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/pcu.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
> index 9b46d64..d7f0c10 100644
> --- a/drivers/net/wireless/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath5k/pcu.c
> @@ -960,6 +960,7 @@ int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr)
>  int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
>  {
>        unsigned int i, type;
> +       u16 micentry = entry + AR5K_KEYTABLE_MIC_OFFSET;
>
>        ATH5K_TRACE(ah->ah_sc);
>        AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
> @@ -972,10 +973,10 @@ int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
>        /* Reset associated MIC entry if TKIP
>         * is enabled located at offset (entry + 64) */
>        if (type == AR5K_KEYTABLE_TYPE_TKIP) {
> -               entry = entry + AR5K_KEYTABLE_MIC_OFFSET;
> -               AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
> +               AR5K_ASSERT_ENTRY(micentry, AR5K_KEYTABLE_SIZE);
>                for (i = 0; i < AR5K_KEYCACHE_SIZE / 2 ; i++)
> -                       ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
> +                       ath5k_hw_reg_write(ah, 0,
> +                               AR5K_KEYTABLE_OFF(micentry, i));
>        }
>
>        /*
> @@ -987,10 +988,16 @@ int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
>         * Note2: Windows driver (ndiswrapper) sets this to
>         *        0x00000714 instead of 0x00000007
>         */
> -       if (ah->ah_version > AR5K_AR5211)
> +       if (ah->ah_version > AR5K_AR5211) {
>                ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
>                                AR5K_KEYTABLE_TYPE(entry));
>
> +               if (type == AR5K_KEYTABLE_TYPE_TKIP) {
> +                       ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
> +                               AR5K_KEYTABLE_TYPE(micentry));
> +               }
> +       }
> +
>        return 0;
>  }
>

Let's apply this for now and i'll take a look on what's going on for
AR5211 (i don't know if TKIP/MIC is supported or not right now, i'll
have to test this). Let's finish with AR5212 first (i also have a
patch for QCU updates pending) since many people want AR5212 hw
encryption support ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
