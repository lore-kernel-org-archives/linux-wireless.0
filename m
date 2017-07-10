Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:36486 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932079AbdGJNqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 09:46:11 -0400
Received: by mail-wr0-f172.google.com with SMTP id c11so139620612wrc.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 06:46:10 -0700 (PDT)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@google.com
Cc: davem@davemloft.net, dm-devel@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] crypto/algapi - refactor crypto_xor() to avoid memcpy()s
Date: Mon, 10 Jul 2017 14:45:46 +0100
Message-Id: <20170710134548.20234-1-ard.biesheuvel@linaro.org> (sfid-20170710_155328_668011_9A903616)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 2/2:

"""
There are quite a number of occurrences in the kernel of the pattern

    if (dst != src)
            memcpy(dst, src, walk.total % AES_BLOCK_SIZE);
    crypto_xor(dst, final, walk.total % AES_BLOCK_SIZE);

or

    crypto_xor(keystream, src, nbytes);
    memcpy(dst, keystream, nbytes);

where crypto_xor() is preceded or followed by a memcpy() invocation
that is only there because crypto_xor() uses its output parameter as
one of the inputs.
"""

Patch #1 is a preparatory patch, which is split off for ease of review.

Patch #2 updates all occurrences of crypto_xor() to use a separate
output argument.

Ard Biesheuvel (2):
  crypto/algapi - use separate dst and src operands for __crypto_xor()
  crypto/algapi - make crypto_xor() take separate dst and src arguments

 arch/arm/crypto/aes-ce-glue.c       |  4 +---
 arch/arm/crypto/aes-neonbs-glue.c   |  9 +++----
 arch/arm64/crypto/aes-glue.c        |  8 +++----
 arch/arm64/crypto/aes-neonbs-glue.c |  9 +++----
 arch/sparc/crypto/aes_glue.c        |  3 +--
 arch/x86/crypto/aesni-intel_glue.c  |  4 ++--
 arch/x86/crypto/blowfish_glue.c     |  3 +--
 arch/x86/crypto/cast5_avx_glue.c    |  3 +--
 arch/x86/crypto/des3_ede_glue.c     |  3 +--
 crypto/algapi.c                     | 25 ++++++++++++--------
 crypto/ccm.c                        |  2 +-
 crypto/chacha20_generic.c           |  4 ++--
 crypto/cmac.c                       |  8 +++----
 crypto/ctr.c                        |  7 +++---
 crypto/cts.c                        |  4 ++--
 crypto/gcm.c                        |  4 ++--
 crypto/ghash-generic.c              |  2 +-
 crypto/keywrap.c                    |  4 ++--
 crypto/pcbc.c                       | 20 +++++++---------
 crypto/salsa20_generic.c            |  4 ++--
 crypto/seqiv.c                      |  2 +-
 crypto/xcbc.c                       |  8 +++----
 drivers/crypto/vmx/aes_ctr.c        |  3 +--
 drivers/md/dm-crypt.c               | 19 +++++++--------
 include/crypto/algapi.h             | 12 ++++++----
 include/crypto/cbc.h                | 10 ++++----
 net/mac80211/fils_aead.c            |  6 ++---
 27 files changed, 89 insertions(+), 101 deletions(-)

-- 
2.9.3
