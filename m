Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:46390 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYJ2OF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 10:05:26 -0400
Received: by rv-out-0506.google.com with SMTP id k40so8160rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 07:05:25 -0700 (PDT)
Message-ID: <b6c5339f0810290705j36995186j382a8415886fb061@mail.gmail.com> (sfid-20081029_150531_132344_F0461AFC)
Date: Wed, 29 Oct 2008 10:05:25 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Update PCU code
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <40f31dec0810290408h5ee08c8l1e14d576064f01a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081029021121.GA3079@makis>
	 <20081029024603.GA22759@hash.localnet>
	 <40f31dec0810290408h5ee08c8l1e14d576064f01a4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 7:08 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2008/10/29 Bob Copeland <me@bobcopeland.com>:
>> On Wed, Oct 29, 2008 at 04:11:22AM +0200, Nick Kossifidis wrote:
>>>  * Properly clean MIC key from keytable when TKIP is used (Bob is
>>>  working on set_key function etc so i leave it for now).
>>
>> Heh, I was just prepping patches to send out.  I had basically the
>> same thing for _reset_key too so I'll just rebase mine on top of this.
>>
>
> ACK, sorry for the bad coordination ;-(

No worries, it was easy enough to drop that hunk.  But I do think this:

> +       /* Reset associated MIC entry if TKIP
> +        * is enabled located at offset (entry + 64) */
> +       if (type == AR5K_KEYTABLE_TYPE_TKIP) {
> +               entry = entry + AR5K_KEYTABLE_MIC_OFFSET;
> +               AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
> +               for (i = 0; i < AR5K_KEYCACHE_SIZE / 2 ; i++)
> +                       ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
> +       }
> +

...should move a couple of lines down or use a temporary for the micentry
slot; otherwise we are setting keytype to NULL in the mic entry and not
the original key slot.

The only other difference in mine was I went ahead and reset the whole line
instead of just the first 4 words... since nothing goes in that half of the
cache line that's probably wasted effort, and the HAL does the above so it
should be fine.  I just wasn't sure if power-up state clears the keytype
properly.

-- 
Bob Copeland %% www.bobcopeland.com
