Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:40568 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388397AbeGXSiy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 14:38:54 -0400
Message-ID: <1bdc706ae86039c4ffcff39698251424d54af116.camel@perches.com> (sfid-20180724_193144_452653_60B90F55)
Subject: Re: [PATCH v6 18/18] crypto: Remove AHASH_REQUEST_ON_STACK
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
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
Date: Tue, 24 Jul 2018 10:31:13 -0700
In-Reply-To: <20180724164936.37477-19-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
         <20180724164936.37477-19-keescook@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-07-24 at 09:49 -0700, Kees Cook wrote:
> All users of AHASH_REQUEST_ON_STACK have been removed from the kernel, so
> drop it entirely so no VLAs get reintroduced by future users.

checkpatch has a test for that.
It could now be removed as well.
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34e4683de7a3..a3517334d661 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -796,7 +796,7 @@ our $declaration_macros = qr{(?x:
 	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
 	(?:$Storage\s+)?[HLP]?LIST_HEAD\s*\(|
 	(?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(|
-	(?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(
+	(?:SKCIPHER_REQUEST|SHASH_DESC)_ON_STACK\s*\(
 )};
