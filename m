Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34517 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbcBEVSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 16:18:06 -0500
Received: by mail-ig0-f172.google.com with SMTP id ik10so49865258igb.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2016 13:18:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CCD6FE5@AcuExch.aculab.com>
References: <1454619643-14444-1-git-send-email-keescook@chromium.org>
	<1454619643-14444-3-git-send-email-keescook@chromium.org>
	<063D6719AE5E284EB5DD2968C1650D6D1CCD6FE5@AcuExch.aculab.com>
Date: Fri, 5 Feb 2016 13:18:04 -0800
Message-ID: <CAGXu5jJrFv5Y8Q_i3yFYBDmT0+pO05dS3ijB0gOn-huasxZWmA@mail.gmail.com> (sfid-20160205_221826_717992_47D8109D)
Subject: Re: [PATCH v2 2/4] lib: update single-char callers of strtobool
From: Kees Cook <keescook@chromium.org>
To: David Laight <David.Laight@aculab.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Steve French <sfrench@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	Joe Perches <joe@perches.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 5, 2016 at 2:46 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Kees Cook
>> Sent: 04 February 2016 21:01
>> Some callers of strtobool were passing a pointer to unterminated strings.
>> In preparation of adding multi-character processing to kstrtobool, update
>> the callers to not pass single-character pointers, and switch to using the
>> new kstrtobool_from_user helper where possible.
>
> Personally I think you should change the name of the function so that the
> compiler (and linker) will pick up places that have not been changed.
> Relying on people to make the required changes will cause problems.

After the single-character users were pointed out, I looked for others
and there aren't any.

> The current code (presumably) treats "no", "nyet" and "nkjkkrkjrkjterkj" as false.
> Changing that behaviour will break things.

There's no change there. All three of those will still be "false".
Perhaps my changelog shouldn't say "unterminated" but rather
"character array".

> If you want to support "on" and "off", then maybe check for the supplied string
> starting with the character sequences "on\0" and "off\0" (as well as any others).
> This doesn't need the input string be '\0' terminated - since you match y and n
> without looking at the 2nd byte.
> You'd have to be extremely unlucky to get a page fault in the 3 bytes
> following an 'o' if the caller supplied a single byte buffer.

I'd prefer to keep the switch statement as short as possible, and I
don't want to do full string compares. And as you say, even fixing the
single-byte callers seems like a needless exercise, but seeing as how
it's a net clean-up, I think it's good they way I've got the series.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
