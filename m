Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36035 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754493AbcJVTP5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 15:15:57 -0400
Received: by mail-wm0-f48.google.com with SMTP id b80so39018807wme.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2016 12:15:57 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: Re: crypto: aesni - add ccm(aes) algorithm implementation
Date: Sat, 22 Oct 2016 21:15:54 +0200
Message-ID: <4298972.T1UOBYP9Tx@debian64> (sfid-20161022_211600_609367_51AA87DC)
In-Reply-To: <3e0552f3-b7f5-2ff3-1f63-9001bceb96f0@candelatech.com>
References: <1476895046-16549-1-git-send-email-greearb@candelatech.com> <3e0552f3-b7f5-2ff3-1f63-9001bceb96f0@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, October 19, 2016 9:39:49 AM CEST Ben Greear wrote:
> On 10/19/2016 09:37 AM, greearb@candelatech.com wrote:
> > From: Yauhen Kharuzhy <jekhor@gmail.com>
> >
> > Add ccm(aes) implementation from linux-wireless mailing list (see
> > http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
> >
> > This eliminates FPU context store/restore overhead existing in more
> > general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
> >
> > Convert this patch to new AEAD API.
> >
> > Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
> > Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> I've been using this patch or something similar for a while and it
> significantly helps me with sw-crypt performance.  One version or another
> has been around the internet for some time, and I am not the originator
> of this code, but would still be happy to see it upstream if someone
> can review and bless it.

No. I don't think this will ever fly by the crypto folks in this
form due to the CRYPTO_ALGO_ASYNC fallback parts which are necessary
to get it to work with mac80211. 

It would be a great if mac80211 would do to the encryption and
decryption asynchronously. As this would work for other ciphers
and also allows crypto offload to dedicated crypto hardware.

Regards,
Christian
