Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61648 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaG2WaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 18:30:01 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so1332214wib.2
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2014 15:30:00 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
Date: Wed, 30 Jul 2014 00:29:56 +0200
Message-ID: <3302077.5sUEMiqNRr@debian64> (sfid-20140730_003008_253604_02CCFD82)
In-Reply-To: <53D6B78E.1070705@candelatech.com>
References: <5338F1B8.5040305@candelatech.com> <12936014.DUEgOXk110@blech> <53D6B78E.1070705@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 28, 2014 01:50:22 PM Ben Greear wrote:
> On 03/31/2014 11:09 AM, Christian Lamparter wrote:
> > Hello,
> > 
> > On Sunday, March 30, 2014 09:40:24 PM Ben Greear wrote:
> >> Due to hardware/firmware limitations, it does not appear possible to
> >> have a wifi NIC do hardware decrypt when using multiple stations on a single
> >> NIC (and have both stations connected to the same AP).
> >>
> >> This just happens to be one of my favourite things to do, and it kills
> >> performance compared to normal 'Open' throughput.
> >>
> >> I am curious if anyone knows of any way to accelerate rx-decrypt, perhaps by
> >> using a specialized hardware board or maybe a feature of certain CPUs?
> > 
> > You could check if your CPU (bios and kernel) have support for AES-NI [0].
> > AFAICT mac80211 utilizes the cryptoapi. Therefore anything that supports
> > the proper crypto bindings can be used to accelerate the encryption and
> > decryption process to some degree. And it just happens that thanks to
> > AES-NI parts of math can be efficiently calculated by the CPU. 
> 
> I recently took a look at this again, and the Intel E5 I'm using
> does use the aesni instructions/driver as far as I can tell.
Which E5 exactly? There are many different E5. 

> Throughput is still around 500Mbps where open is around 800Mbps.
I can't test ath10k or your multiple station on a single NIC thing. But
can you run a test for a "simple" single station - single AP wpa2 setup?
I want to know how close to the 800Mbps it actually goes.

> perf top shows this:
> 
> Samples: 37K of event 'cycles', Event count (approx.): 19360716192
>  12.01%  [kernel]                                      [k] math_state_restore
>  11.64%  [kernel]                                      [k] _aesni_enc1
>   8.25%  [kernel]                                      [k] __save_init_fpu
>   2.44%  [kernel]                                      [k] crypto_xor
>   1.87%  [kernel]                                      [k] irq_fpu_usable
>   1.30%  [kernel]                                      [k] aes_encrypt
>   0.76%  [kernel]                                      [k] __kernel_fpu_end
> ....
Yes, aesni is doing some of the heavy lifting! But in your original post,
you said you are interested in accelerate rx-decrypt... Now it's about 
encryption offload?! [please make up your mind :-D]

That being said 12.01% (math_state_restore -  
called by kernel_fpu_end) and 8.25% (__save_init_fpu - called 
by kernel_fpu_begin) cycles are wasted due fpu save and 
restore overhead. [You have noticed that before, didn't you ;-) ]

I think part of the poor performance is due to the design of
aes_encrypt in arch/x86/crypto/aesni-intel_glue.c:

> static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
> {
>        struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
>        [...]
>                kernel_fpu_begin();
>                aesni_enc(ctx, dst, src);
>                kernel_fpu_end();
>        [...]
> }

Ideally you would want something like:

>                kernel_fpu_begin();
>                aesni_enc(ctx, dst_frame1, src_frame1);
>                aesni_enc(ctx, dst_frame2, src_frame2);
>                ...
>                aesni_enc(ctx, dst_frameN, src_frameN);
>                kernel_fpu_end();

But getting there might not be easy and involve more than a bit
of "real programming".

In theory, it should be enough to test if there is some potential
in this approach by "enhancing" the tx-path in the following way:

1. the fpu_begin and fpu_end calls should be added to
ieee80211_crypto_ccmp_encrypt in net/mac80211/wpa.c.

>+     kernel_fpu_begin();
>        skb_queue_walk(&tx->skbs, skb) {
>                if (ccmp_encrypt_skb(tx, skb) < 0)
>                        return TX_DROP;
>        }
>+      kernel_fpu_end();
>
>       return TX_CONTINUE;

2. ieee80211_aes_ccm_encrypt in net/mac80211/aes_ccm.c
has to call __aes_encrypt instead of aes_encrypt in crypto_aead_encrypt.
[I can't think of a sane way to make this work. Of course, it's possible to
make a copy of ccm(aes) crypto_alg* and overwrite aes_encrypt with
__aes_encrypt. But that's not very nice... (It should work though) ]

> Any other magic add-in cards that would somehow just make this all faster w/out
> having to do any real programming work? :)
I doubt there is an magic add-in card for such a use-case. I think most of
them target directly applications/libraries and not the crypto-kernel
interface mac80211 is using.

[It would be really nice to know what E5 you actually have]

Regards
Christian
