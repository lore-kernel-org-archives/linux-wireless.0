Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44391 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932634AbeCNBSr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 21:18:47 -0400
MIME-Version: 1.0
In-Reply-To: <423b529d48c54eba9f7ed51922814d46@AcuMS.aculab.com>
References: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com>
 <5AA464DE.90100@broadcom.com> <CA+DvKQ+hbMoWJdOuQB5n+eVF4ePf=kVuRiMbdtTUZ8ars4Pz4A@mail.gmail.com>
 <423b529d48c54eba9f7ed51922814d46@AcuMS.aculab.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 13 Mar 2018 21:18:45 -0400
Message-ID: <CA+DvKQK9jRe5YOk_K4DzBYkh2VUys56XbaYZRGs0fn2WJNT+nQ@mail.gmail.com> (sfid-20180314_021903_984326_7A0770BE)
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9: dfs: remove VLA usage
To: David Laight <David.Laight@aculab.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andreas Christoforou <andreaschristofo@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No, it's undefined behavior to write to a const variable. The `static`
and `const` on the variable both change the code generation in the
real world as permitted / encouraged by the standard. It's placed in
read-only memory. Trying to write to it will break. It's not
"implemented defined" to write to it, it's "undefined behavior" i.e.
it's considered incorrect. There a clear distinction between those in
the standard.

You're confusing having a real `const` for a variable with having it
applied to a pointer. It's well-defined to cast away const from a
pointer and write to what it points at if it's not actually const. If
it is const, that's broken.

There's nothing implementation defined about either case.

The C standard could have considered `static const` variables to work
as constant expressions just like the C++ standard. They borrowed it
from there but made it less useful than const in what became the C++
standard. They also used stricter rules for the permitted implicit
conversions of const pointers which made those much less usable, i.e.
converting `int **` to `const int *const *` wasn't permitted like C++.
I don't think the difference between C and C++ const pointer
conversions, it's a quirk of them being standardized on different
timelines and ending up with different versions of the same thing. On
the other hand, they might have left out having ever so slightly more
useful constant expressions on purpose since people can use #define.
