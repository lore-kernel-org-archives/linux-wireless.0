Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34134 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbBLKUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 05:20:52 -0500
Received: by labhs14 with SMTP id hs14so8617070lab.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 02:20:51 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "Rustad\, Mark D" <mark.d.rustad@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwl4965: Enable checking of format strings
References: <1423695069-23436-1-git-send-email-linux@rasmusvillemoes.dk>
	<60178C37-F104-430E-92EB-B6DDFAEB2F99@intel.com>
Date: Thu, 12 Feb 2015 11:20:49 +0100
In-Reply-To: <60178C37-F104-430E-92EB-B6DDFAEB2F99@intel.com> (Mark
	D. Rustad's message of "Thu, 12 Feb 2015 00:41:39 +0000")
Message-ID: <87vbj7zb0e.fsf@rasmusvillemoes.dk> (sfid-20150212_112057_113418_ACE2E5CA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12 2015, "Rustad, Mark D" <mark.d.rustad@intel.com> wrote:

> On Feb 11, 2015, at 2:51 PM, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>
>> Since these fmt_* variables are just const char*, and not const
>> char[], gcc (and smatch) doesn't to type checking of the arguments to
>> the printf functions. Since the linker knows perfectly well to merge
>> identical string constants, there's no point in having three static
>> pointers waste memory and give an extra level of indirection.
>> 
>> This removes over 100 "non-constant format argument" warnings from
>> smatch, accounting for about 20% of all such warnings in an
>> allmodconfig.
>> 
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>> drivers/net/wireless/iwlegacy/4965-debug.c | 7 +++----
>> 1 file changed, 3 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/iwlegacy/4965-debug.c b/drivers/net/wireless/iwlegacy/4965-debug.c
>> index e0597bfdddb8..18855325cc1c 100644
>> --- a/drivers/net/wireless/iwlegacy/4965-debug.c
>> +++ b/drivers/net/wireless/iwlegacy/4965-debug.c
>> @@ -28,10 +28,9 @@
>> #include "common.h"
>> #include "4965.h"
>> 
>> -static const char *fmt_value = "  %-30s %10u\n";
>> -static const char *fmt_table = "  %-30s %10u  %10u  %10u  %10u\n";
>> -static const char *fmt_header =
>> -    "%-32s    current  cumulative       delta         max\n";
>
> Why not change these to:
> static const char fmt_value[] = "  %-30s %10u\n";
> static const char fmt_table[] = "  %-30s %10u  %10u  %10u  %10u\n";
> static const char fmt_header[] =
>     "%-32s    current  cumulative       delta         max\n";
>
> I think that is better than the macros and avoids the extra pointers that I agree are useless.

Rather weak arguments, but I have three of them :-)

(1) If I'm reading some code and spot a non-constant format argument, I
sometimes track back to see how e.g. fmt_value is defined. If I then see
it's a macro, I immediately think "ok, the compiler is doing
type-checking". If it is a const char[], I have to remember that gcc
also does it in that case (as opposed to for example const char*const).

(2) The names of these variables themselves may end up wasting a few
bytes in the image.

(3) gcc/the linker doesn't merge identical const char[] arrays across
translation units. It also doesn't consider their tails for merging with
string literals. So although these specific strings are unlikely to
appear elsewhere, a string such as "%10u\n" or "max\n" couldn't be
merged with one of the above.

Rasmus
