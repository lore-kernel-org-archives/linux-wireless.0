Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38816 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388509AbeGXR5I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 13:57:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id x17-v6so984258pfh.5
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 09:49:47 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Will Deacon <will.deacon@arm.com>, dm-devel@redhat.com,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        qat-linux@intel.com, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-afs@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/18] crypto: Remove VLA usage
Date: Tue, 24 Jul 2018 09:49:18 -0700
Message-Id: <20180724164936.37477-1-keescook@chromium.org> (sfid-20180724_185246_879089_BDD8C4CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For newly added CCs on this series: your Ack/Review would be very
welcome! Especially for the ahash-to-shash conversion patches.

v6:
- make xcbc blocksize unconditional
- add ahash-to-shash conversion patch series to entirely remove
  AHASH_REQUEST_ON_STACK from the kernel

v5:
- limit AHASH_REQUEST_ON_STACK size only to non-async hash wrapping.
- sanity-check ahash reqsize only when doing shash wrapping.
- remove frame_warn changes in favor of shash conversions and other fixes.
- send ahash to shash conversion patches and other fixes separately.

v4:
- add back *_REQUEST_ON_STACK patches.
- programmatically find stack sizes for *_REQUEST_ON_STACK patches.
- whitelist some code that trips FRAME_WARN on 32-bit builds.
- fix alignment patches.

v3:
- drop *_REQUEST_ON_STACK patches. The rest of this series is pretty
  straight-forward, and I'd like to get them tested in -next while
  we continue to chip away at the *_REQUEST_ON_STACK VLA removal patches
  separately. "Part 2" will continue with those.

v2:
- use 512 instead of PAGE_SIZE / 8 to avoid bloat on large-page archs.
- swtich xcbc to "16" max universally.
- fix typo in bounds check for dm buffer size.
- examine actual reqsizes for skcipher and ahash instead of guessing.
- improve names and comments for alg maxes

This is nearly the last of the VLA removals[1], but it's one of the
largest because crypto gets used in lots of places. After looking
through code, usage, reading the threads Gustavo started, and comparing
the use-cases to the other VLA removals that have landed in the kernel,
I think this series is likely the best way forward to shut the door on
VLAs forever.

For background, the crypto stack usage is for callers to do an immediate
bit of work that doesn't allocate new memory. This means that other VLA
removal techniques (like just using kmalloc) aren't workable, and the
next common technique is needed: examination of maximum stack usage and
the addition of sanity checks. This series does that, and in several
cases, these maximums were already implicit in the code.

This series is intended to land via the crypto tree for 4.19, though it
touches dm, networking, and a few other things as well, since there are
dependent patches (new crypto #defines being used, etc).

Thanks!

-Kees

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Ard Biesheuvel (1):
  crypto: ccm: Remove VLA usage

Kees Cook (17):
  crypto: xcbc: Remove VLA usage
  crypto: cbc: Remove VLA usage
  crypto: hash: Remove VLA usage
  dm: Remove VLA usage from hashes
  crypto alg: Introduce generic max blocksize and alignmask
  crypto: qat: Remove VLA usage
  crypto: shash: Remove VLA usage in unaligned hashing
  crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
  ppp: mppe: Remove VLA usage
  x86/power/64: Remove VLA usage
  dm crypt: Convert essiv from ahash to shash
  drbd: Convert from ahash to shash
  wireless/lib80211: Convert from ahash to shash
  staging: rtl8192u: ieee80211: Convert from ahash to shash
  staging: rtl8192e: ieee80211: Convert from ahash to shash
  rxrpc: Reuse SKCIPHER_REQUEST_ON_STACK buffer
  crypto: Remove AHASH_REQUEST_ON_STACK

 arch/x86/power/hibernate_64.c                 | 36 +++++++-----
 crypto/ahash.c                                |  4 +-
 crypto/algapi.c                               |  7 ++-
 crypto/algif_hash.c                           |  2 +-
 crypto/ccm.c                                  |  9 ++-
 crypto/shash.c                                | 33 ++++++-----
 crypto/xcbc.c                                 |  8 ++-
 drivers/block/drbd/drbd_int.h                 | 13 +++--
 drivers/block/drbd/drbd_main.c                | 14 ++---
 drivers/block/drbd/drbd_nl.c                  | 39 ++++---------
 drivers/block/drbd/drbd_receiver.c            | 35 +++++------
 drivers/block/drbd/drbd_worker.c              | 56 ++++++++----------
 drivers/crypto/qat/qat_common/qat_algs.c      |  8 ++-
 drivers/md/dm-crypt.c                         | 31 +++++-----
 drivers/md/dm-integrity.c                     | 23 ++++++--
 drivers/md/dm-verity-fec.c                    |  5 +-
 drivers/net/ppp/ppp_mppe.c                    | 56 +++++++++---------
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c  | 56 +++++++++---------
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c | 57 +++++++++---------
 include/crypto/algapi.h                       |  4 +-
 include/crypto/cbc.h                          |  4 +-
 include/crypto/hash.h                         | 11 ++--
 include/crypto/internal/skcipher.h            |  1 +
 include/crypto/skcipher.h                     |  4 +-
 include/linux/compiler-gcc.h                  |  1 -
 net/rxrpc/rxkad.c                             | 25 ++++----
 net/wireless/lib80211_crypt_tkip.c            | 58 +++++++++----------
 27 files changed, 313 insertions(+), 287 deletions(-)

-- 
2.17.1
