Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37879 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaGaUpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:45:51 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so276765wiv.7
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:45:50 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
Date: Thu, 31 Jul 2014 22:45:47 +0200
Message-ID: <6460230.VGl66UFULp@debian64> (sfid-20140731_224555_831314_B4BC8E48)
In-Reply-To: <20140731200522.GA8868@w1.fi>
References: <5338F1B8.5040305@candelatech.com> <2968058.2zJHmYrLUV@debian64> <20140731200522.GA8868@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, July 31, 2014 11:05:22 PM Jouni Malinen wrote:
> On Wed, Jul 30, 2014 at 08:59:33PM +0200, Christian Lamparter wrote:
> > If you have disabled rx-decrypt logic of ath10k, then why isn't _aesni_dec1
> > or aes_decrypt listed in the perf top result? I think they should be. Have you
> > removed them from the "perf top results" or are they really absent 
> > altogether? 
> > 
> > Because, from this perf result, it looks like your CPU is not burden by the
> > incoming RX at all?! Instead it is busy with the encryption of frames
> > it will be transmitting (in case of tcp, this could be tcp acks).
> 
> Keep in mind that this is CCMP, i.e., AES in CCM (Counter with CBC-MAC)
> mode. The CCM mode uses only the block cipher encryption function, i.e.,
> you won't be seeing aes_decrypt or _aesni_dec1 for this even on the RX
> path (AES encryption operations are used to generate the key stream
> blocks for CCM decryption).
Yes, I remember this detail/the old days (before 3.12/3.13?). Back then
ieee80211_aes_ccm_decrypt did exactly that. But these semantic pitfalls
were taken care of by the following commit:

commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (from wireless-testing.git)
Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu Oct 10 09:55:20 2013 +0200

  mac80211: port CCMP to cryptoapi's CCM driver
   
  Use the generic CCM aead chaining mode driver rather than a local
  implementation that sits right on top of the core AES cipher.
  
  This allows the use of accelerated implementations of either
  CCM as a whole or the CTR mode which it encapsulates.
  [...]

Regards
Christian
