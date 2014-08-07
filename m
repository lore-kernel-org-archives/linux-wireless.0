Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:48592 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaHGOFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 10:05:46 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so4293120wev.27
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 07:05:44 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
Date: Thu, 07 Aug 2014 16:05:29 +0200
Message-ID: <1875618.ePecsgGYZf@blech> (sfid-20140807_160550_024636_2DB2C0D2)
In-Reply-To: <53E16436.2020706@candelatech.com>
References: <5338F1B8.5040305@candelatech.com> <6460230.VGl66UFULp@debian64> <53E16436.2020706@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, August 05, 2014 04:09:42 PM Ben Greear wrote:
> On 07/31/2014 01:45 PM, Christian Lamparter wrote:
> > On Thursday, July 31, 2014 11:05:22 PM Jouni Malinen wrote:
> >> On Wed, Jul 30, 2014 at 08:59:33PM +0200, Christian Lamparter wrote:
> >>> If you have disabled rx-decrypt logic of ath10k, then why isn't _aesni_dec1
> >>> or aes_decrypt listed in the perf top result? I think they should be. Have you
> >>> removed them from the "perf top results" or are they really absent 
> >>> altogether? 
> >>>
> >>> Because, from this perf result, it looks like your CPU is not burden by the
> >>> incoming RX at all?! Instead it is busy with the encryption of frames
> >>> it will be transmitting (in case of tcp, this could be tcp acks).
> >>
> >> Keep in mind that this is CCMP, i.e., AES in CCM (Counter with CBC-MAC)
> >> mode. The CCM mode uses only the block cipher encryption function, i.e.,
> >> you won't be seeing aes_decrypt or _aesni_dec1 for this even on the RX
> >> path (AES encryption operations are used to generate the key stream
> >> blocks for CCM decryption).
> > Yes, I remember this detail/the old days (before 3.12/3.13?). Back then
> > ieee80211_aes_ccm_decrypt did exactly that. But these semantic pitfalls
> > were taken care of by the following commit:
> > 
> > commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (from wireless-testing.git)
> > Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Date:   Thu Oct 10 09:55:20 2013 +0200
> 
> This patch is in my tree (I'm using 3.14.14 kernel currently).
> 
> Here is a perf top from a different machine, with single wlan interface
> running UDP download (btserver is user-space app that is generating/receiving
> the traffic).  I can do about 200Mbps download with WPA2 encryption enabled
> on this machine, and ksoftirqd is using about 76% of a core according to top.

Thanks. I looked into AES in CCM (Counter with CBC-MAC) instead of ccm.c
and guess what: "Both the CCM encryption and CCM decryption operations
require only the block cipher encryption function." [0]. (Yes, same as
Jouni said in his mail).

Now to the perf:
 
> Samples: 126K of event 'cycles', Event count (approx.): 29019221373
>  10.74%  [kernel]                 [k] math_state_restore
>  10.50%  btserver                 [.] 0x000000000033260d
>   9.00%  [kernel]                 [k] _aesni_enc1
>   7.33%  [kernel]                 [k] fpu_save_init
>   6.70%  [kernel]                 [k] __lock_acquire
>   2.46%  [kernel]                 [k] irq_fpu_usable
>   2.34%  [kernel]                 [k] crypto_xor
>   1.88%  [kernel]                 [k] arch_local_save_flags
>   1.83%  [kernel]                 [k] arch_local_irq_restore
>   1.58%  [kernel]                 [k] lock_release
>   1.48%  [kernel]                 [k] aes_encrypt
>   1.27%  [kernel]                 [k] mark_lock
>   1.12%  [kernel]                 [k] lock_acquire
>   1.02%  [kernel]                 [k] mark_held_locks
>   0.96%  [kernel]                 [k] trace_hardirqs_on_caller
>   0.93%  [kernel]                 [k] get_data_to_compute
>   0.83%  [kernel]                 [k] hlock_class
>   0.81%  [kernel]                 [k] __kernel_fpu_begin
>   0.81%  [kernel]                 [k] crypto_ctr_crypt
>   0.80%  [kernel]                 [k] crypto_inc

The high overhead (math_state_restore and fpu_save_init) are caused by 
the way ccm.c interacts with the aesni implementation when calculating
the MAC [1] (in compute_mac). 

>    [ ... ]
>	/* now encrypt rest of data */
>	while (datalen >= 16) {
>		crypto_xor(odata, data, bs);
>		crypto_cipher_encrypt_one(tfm, odata, odata);
>
>		datalen -= 16;
>		data += 16;
>	}
>   [...]

crypto_cipher_encrypt_one is a wrapper which in your case calls 
aesni's aes_encrypt [2].

And aes_encrypt looks like this: 

>	[...]
>	kernel_fpu_begin();
>	aesni_enc(ctx, dst, src); <-- this is where it goes to _aesni_enc1
>	kernel_fpu_end();
>	[...] 

Or: for every 16 Bytes of payload there is one fpu context save and
restore... ouch!

[0] http://tools.ietf.org/html/rfc3610
[1] http://lxr.free-electrons.com/source/crypto/ccm.c#L164
[2] http://lxr.free-electrons.com/source/arch/x86/crypto/aesni-intel_glue.c#L323


Regards

Christian
