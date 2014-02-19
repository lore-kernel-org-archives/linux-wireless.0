Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:48205 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaBSVzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 16:55:50 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so742173lab.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 13:55:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzY+CnnssaZpqgWuJ=QH-k=zJbHpLaGkJXAQSWSxq7kKa6Q@mail.gmail.com>
References: <CABPxzY+CnnssaZpqgWuJ=QH-k=zJbHpLaGkJXAQSWSxq7kKa6Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 19 Feb 2014 13:55:28 -0800
Message-ID: <CAB=NE6Xdj=RMc=rZ8FpFge0vaX=5HNmf-3dnR-icPBEhDzpGxg@mail.gmail.com> (sfid-20140219_225553_778022_13345575)
Subject: Re: [RFC] crda: Fix the linking order to avoid compilation error
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 16, 2013 at 8:27 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
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
>
> Note: This still doesn't fix the below error (will send another mail)
>
>   CHK  /usr/lib/crda/regulatory.bin
> Database signature verification failed.
> Invalid or empty regulatory file, note: a binary regulatory file should be used.
> make: *** [verify] Error 234
>
> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>

Applied and pushed, thanks!

  Luis
