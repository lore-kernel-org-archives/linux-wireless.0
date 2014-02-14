Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:27835 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaBNJF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 04:05:57 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	<mcgrof@do-not-panic.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<wireless-regdb@lists.infradead.org>
Subject: Re: [RFC] crda: Fix the linking order to avoid compilation error
References: <CABPxzY+CnnssaZpqgWuJ=QH-k=zJbHpLaGkJXAQSWSxq7kKa6Q@mail.gmail.com>
Date: Fri, 14 Feb 2014 11:05:50 +0200
In-Reply-To: <CABPxzY+CnnssaZpqgWuJ=QH-k=zJbHpLaGkJXAQSWSxq7kKa6Q@mail.gmail.com>
	(Krishna Chaitanya's message of "Mon, 16 Dec 2013 21:57:39 +0530")
Message-ID: <87wqgy5aj5.fsf@kamboji.qca.qualcomm.com> (sfid-20140214_100605_912974_2F53A852)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Krishna Chaitanya <chaitanya.mgit@gmail.com> writes:

> While linking the crda.o and libreg.so, first put crda.o
> and then -lreg. This fixed the below error:
>
> # make
>   GEN  keys-gcrypt.c
>   Trusted pubkeys: pubkeys/linville.key.pub.pem
>   CC   libreg.so
>   CC   crda.o
>   LD   crda
> crda.o: In function `main':
> crda/crda.c:196: undefined reference to `reglib_get_rd_alpha2'
> collect2: ld returned 1 exit status
> make: *** [crda] Error 1

[...]

> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> ---
>  Makefile |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 4a351c6..0b2f0d7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -28,10 +28,11 @@ RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
>  CFLAGS += -O2 -fpic
>  CFLAGS += -std=gnu99 -Wall -Werror -pedantic
>  CFLAGS += -Wall -g
> -LDLIBS += -lm
>  LDLIBREG += -lreg
> +LDLIBS += $(LDLIBREG)
> +LDLIBS += -lm
>  LIBREG += libreg.so
> -LDFLAGS += -L ./ $(LDLIBREG)
> +LDFLAGS += -L ./
>
>  all: all_noverify verify

Without this patch crda didn't compile on my Ubuntu 12.04 box. IMHO this
should be applied.

-- 
Kalle Valo
