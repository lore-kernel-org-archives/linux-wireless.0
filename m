Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:50872 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZHJWUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 18:20:21 -0400
Received: by pzk34 with SMTP id 34so3108633pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 15:20:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249735096-27071-3-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
	<1249735096-27071-3-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 10 Aug 2009 15:20:02 -0700
Message-ID: <43e72e890908101520x19fddcddx72215fb0851baf2f@mail.gmail.com>
Subject: Re: [PATCH 3/7] [compat-2.6] pcmcia_parse_tuple was redefined in
	pcmcia/cistpl.h
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 8, 2009 at 5:38 AM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
> fix build:
> undef pcmcia_parse_tuple before redefine it again.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  compat/compat-2.6.28.h |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
> index fdc021a..e25259f 100644
> --- a/compat/compat-2.6.28.h
> +++ b/compat/compat-2.6.28.h
> @@ -29,7 +29,13 @@
>  })
>  #endif /* From include/asm-generic/bug.h */
>
> -#define pcmcia_parse_tuple(tuple, parse) pcmcia_parse_tuple(NULL, tuple, parse)
> +#include <pcmcia/cs_types.h>
> +#include <pcmcia/cs.h>
> +#include <pcmcia/cistpl.h>
> +#ifdef pcmcia_parse_tuple
> +#undef pcmcia_parse_tuple
> +#define pcmcia_parse_tuple(tuple, parse) pccard_parse_tuple(tuple, parse)
> +#endif

Where did pccard_parse_tuple() come from?

Did you see the commit 0df8084caf53774113c8f118e9dd43e660cf9e15 by any
chance? That fixed compilation for me against older kernels.

  Luis
