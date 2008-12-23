Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:2133 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYLWF5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 00:57:11 -0500
Received: by yx-out-2324.google.com with SMTP id 8so818054yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 21:57:10 -0800 (PST)
Message-ID: <43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com> (sfid-20081223_065715_676711_6A2EBBD5)
Date: Mon, 22 Dec 2008 21:57:10 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
Cc: linux-wireless@vger.kernel.org,
	"John W Linville" <linville@tuxdriver.com>
In-Reply-To: <20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	 <43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
	 <20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 9:49 PM, Pavel Roskin <proski@gnu.org> wrote:
> Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
>
>> I've been trying to avoid string.h on crda.c, granted it only
>> increases the final crda binary by about 30 bytes, but do we really
>> need it? In fact it'd be nice to further trim crda further to save
>> even more space. Thoughts?
>
> OK, maybe we don't need this patch if CDRA works correctly.  I'm having bad
> luck with it.
>
> First of all, I cannot generate regulatory.bin that crda would accept.
>
> [proski@dv wireless-regdb]$ make
> ./db2bin.py regulatory.bin db.txt key.priv.pem
> openssl rsa -in key.priv.pem -out key.pub.pem -pubout -outform PEM
> writing RSA key

You don't need to build this unless you want to define your own rules.

> [proski@dv crda]$ make
>  GEN  keys-gcrypt.c
>  CC   reglib.o
>  CC   crda.o
>  LD   crda
>  CC   intersect.o
>  CC   print-regdom.o
>  LD   intersect
>  CC   regdbdump.o
>  LD   regdbdump
>  CHK  /home/proski/src/wireless-regdb/regulatory.bin
> Database signature verification failed.
> make: *** [verify] Error 234

And if you do and want to use the signature stuff you need to copy the
RSA public key into pubkeys/ directory of CRDA. Did you try that?

  Luis
