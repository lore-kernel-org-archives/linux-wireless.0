Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38620 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbcBEUud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 15:50:33 -0500
Received: by mail-ig0-f174.google.com with SMTP id mw1so22023442igb.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2016 12:50:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8737t8ni8w.fsf@rasmusvillemoes.dk>
References: <1454619643-14444-1-git-send-email-keescook@chromium.org>
	<1454619643-14444-2-git-send-email-keescook@chromium.org>
	<8737t8ni8w.fsf@rasmusvillemoes.dk>
Date: Fri, 5 Feb 2016 12:50:31 -0800
Message-ID: <CAGXu5j+CLQrhtyoOcaTMWRgodzQcXM1TifKyxi7sMJawDwpGJg@mail.gmail.com> (sfid-20160205_215049_910083_1D656DE2)
Subject: Re: [PATCH v2 1/4] lib: move strtobool to kstrtobool
From: Kees Cook <keescook@chromium.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Steve French <sfrench@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 4, 2016 at 3:55 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> On Thu, Feb 04 2016, Kees Cook <keescook@chromium.org> wrote:
>
>> Create the kstrtobool_from_user helper and moves strtobool logic into
>> the new kstrtobool (matching all the other kstrto* functions). Provides
>> an inline wrapper for existing strtobool callers.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  include/linux/kernel.h |  3 +++
>>  include/linux/string.h |  6 +++++-
>>  lib/kstrtox.c          | 35 +++++++++++++++++++++++++++++++++++
>>  lib/string.c           | 29 -----------------------------
>>  4 files changed, 43 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index f31638c6e873..cdc25f47a23f 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -357,6 +357,7 @@ int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
>>  int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
>>  int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
>>  int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
>> +int __must_check kstrtobool(const char *s, unsigned int base, bool *res);
>>
>>  int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
>>  int __must_check kstrtoll_from_user(const char __user *s, size_t count, unsigned int base, long long *res);
>> @@ -368,6 +369,8 @@ int __must_check kstrtou16_from_user(const char __user *s, size_t count, unsigne
>>  int __must_check kstrtos16_from_user(const char __user *s, size_t count, unsigned int base, s16 *res);
>>  int __must_check kstrtou8_from_user(const char __user *s, size_t count, unsigned int base, u8 *res);
>>  int __must_check kstrtos8_from_user(const char __user *s, size_t count, unsigned int base, s8 *res);
>> +int __must_check kstrtobool_from_user(const char __user *s, size_t count,
>> +                                   unsigned int base, bool *res);
>>
>>  static inline int __must_check kstrtou64_from_user(const char __user *s, size_t count, unsigned int base, u64 *res)
>>  {
>> diff --git a/include/linux/string.h b/include/linux/string.h
>> index 9eebc66d957a..d2fb21b1081d 100644
>> --- a/include/linux/string.h
>> +++ b/include/linux/string.h
>> @@ -128,7 +128,11 @@ extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
>>  extern void argv_free(char **argv);
>>
>>  extern bool sysfs_streq(const char *s1, const char *s2);
>> -extern int strtobool(const char *s, bool *res);
>> +extern int kstrtobool(const char *s, unsigned int base, bool *res);
>> +static inline int strtobool(const char *s, bool *res)
>> +{
>> +     return kstrtobool(s, 0, res);
>> +}
>>
>>  #ifdef CONFIG_BINARY_PRINTF
>>  int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
>> diff --git a/lib/kstrtox.c b/lib/kstrtox.c
>> index 94be244e8441..e18f088704d7 100644
>> --- a/lib/kstrtox.c
>> +++ b/lib/kstrtox.c
>> @@ -321,6 +321,40 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
>>  }
>>  EXPORT_SYMBOL(kstrtos8);
>>
>> +/**
>> + * kstrtobool - convert common user inputs into boolean values
>> + * @s: input string
>> + * @base: ignored
>> + * @res: result
>> + *
>> + * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
>> + * Otherwise it will return -EINVAL.  Value pointed to by res is
>> + * updated upon finding a match.
>> + */
>> +int kstrtobool(const char *s, unsigned int base, bool *res)
>> +{
>
> Being able to create the kstrtobool_from_user with a single macro
> invocation is convenient, but I don't think that justifies the ugliness
> of having an unused parameter. People reading this code or trying to use
> the interface will wonder what it's doing there, and it will generate
> slightly larger code for all the users of strtobool.
>
> So I'd just make a separate explicit definition of kstrtobool_from_user
> (the stack buffer sizing doesn't apply to the strings we want to parse
> anyway, though 11 is of course plenty).

Okay, thanks. So many things were bothering me, but I feared code
duplication would be seen as worse. I'm much happier to drop the
unused argument. :)

I'll send a v3 with all the changes.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
