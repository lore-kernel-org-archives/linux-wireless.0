Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:37148 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388427AbeGXTBE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 15:01:04 -0400
Received: by mail-yw0-f194.google.com with SMTP id w76-v6so1856872ywg.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 10:53:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1bdc706ae86039c4ffcff39698251424d54af116.camel@perches.com>
References: <20180724164936.37477-1-keescook@chromium.org> <20180724164936.37477-19-keescook@chromium.org>
 <1bdc706ae86039c4ffcff39698251424d54af116.camel@perches.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 24 Jul 2018 10:53:26 -0700
Message-ID: <CAGXu5j+gTpZFkXE8XSNgYPEpBT4+hCb1kzv8s8KrSTerHyKp6w@mail.gmail.com> (sfid-20180724_195330_645615_4D3CD27E)
Subject: Re: [PATCH v6 18/18] crypto: Remove AHASH_REQUEST_ON_STACK
To: Joe Perches <joe@perches.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
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
        Will Deacon <will.deacon@arm.com>,
        device-mapper development <dm-devel@redhat.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        drbd-dev@lists.linbit.com,
        linux-block <linux-block@vger.kernel.org>, qat-linux@intel.com,
        linux-ppp@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        linux-afs@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 24, 2018 at 10:31 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2018-07-24 at 09:49 -0700, Kees Cook wrote:
>> All users of AHASH_REQUEST_ON_STACK have been removed from the kernel, so
>> drop it entirely so no VLAs get reintroduced by future users.
>
> checkpatch has a test for that.
> It could now be removed as well.
> ---
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 34e4683de7a3..a3517334d661 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -796,7 +796,7 @@ our $declaration_macros = qr{(?x:
>         (?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
>         (?:$Storage\s+)?[HLP]?LIST_HEAD\s*\(|
>         (?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(|
> -       (?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(
> +       (?:SKCIPHER_REQUEST|SHASH_DESC)_ON_STACK\s*\(
>  )};

Ah! Cool. I've added this now.

-Kees

-- 
Kees Cook
Pixel Security
