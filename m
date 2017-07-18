Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:35317 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGRJTU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 05:19:20 -0400
Received: by mail-wr0-f170.google.com with SMTP id w4so19725928wrb.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 02:19:20 -0700 (PDT)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc: ebiggers@google.com, davem@davemloft.net, dm-devel@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/2] crypto/algapi - refactor crypto_xor() to avoid memcpy()s
Date: Tue, 18 Jul 2017 10:19:10 +0100
Message-Id: <20170718091912.14104-1-ard.biesheuvel@linaro.org> (sfid-20170718_111925_763698_D0E22626)
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

Patch #2 updates all occurrences of crypto_xor() involving a memcpy() to
use a new API function crypto_xor_cpy() which combines the two operations.

v2: - keep existing crypto_xor() as-is, and add crypto_xor_cpy() for the
      cases where a redundant memcpy() can be eliminated.

Ard Biesheuvel (2):
  crypto/algapi - use separate dst and src operands for __crypto_xor()
  crypto/algapi - make crypto_xor() take separate dst and src arguments

 arch/arm/crypto/aes-ce-glue.c       |  4 +---
 arch/arm/crypto/aes-neonbs-glue.c   |  5 ++--
 arch/arm64/crypto/aes-glue.c        |  4 +---
 arch/arm64/crypto/aes-neonbs-glue.c |  5 ++--
 arch/sparc/crypto/aes_glue.c        |  3 +--
 arch/x86/crypto/aesni-intel_glue.c  |  4 ++--
 arch/x86/crypto/blowfish_glue.c     |  3 +--
 arch/x86/crypto/cast5_avx_glue.c    |  3 +--
 arch/x86/crypto/des3_ede_glue.c     |  3 +--
 crypto/algapi.c                     | 25 ++++++++++++--------
 crypto/ctr.c                        |  3 +--
 crypto/pcbc.c                       | 12 ++++------
 drivers/crypto/vmx/aes_ctr.c        |  3 +--
 drivers/md/dm-crypt.c               | 11 ++++-----
 include/crypto/algapi.h             | 23 ++++++++++++++++--
 15 files changed, 59 insertions(+), 52 deletions(-)

-- 
2.9.3
