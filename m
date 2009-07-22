Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:57159 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZGVRye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 13:54:34 -0400
Received: by an-out-0708.google.com with SMTP id d40so450913and.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 10:54:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248285140-10140-1-git-send-email-lrodriguez@atheros.com>
References: <1248285140-10140-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 22 Jul 2009 10:54:14 -0700
Message-ID: <43e72e890907221054x5d114bddt44476a2475553ebf@mail.gmail.com>
Subject: Re: [PATCH] wireless-regb: make db2bin.py use new hashlib for sha1
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	johannes@sipsolutions.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2009 at 10:52 AM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> Python now complains about sha module as its deprecated:
>
> ./db2bin.py regulatory.bin db.txt ~/.wireless-regdb-mcgrof.key.priv.pem
> ./db2bin.py:5: DeprecationWarning: the sha module is deprecated; use the hashlib module instead
>  import sha
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  db2bin.py      |    6 +++---
>  regulatory.bin |  Bin 3084 -> 3084 bytes
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/db2bin.py b/db2bin.py
> index e783b3a..23d3ee2 100755
> --- a/db2bin.py
> +++ b/db2bin.py
> @@ -2,7 +2,7 @@
>
>  from cStringIO import StringIO
>  import struct
> -import sha
> +import hashlib
>  from dbparse import DBParser
>  import sys
>
> @@ -127,13 +127,13 @@ if len(sys.argv) > 3:
>
>     # determine signature length
>     key = RSA.load_key(sys.argv[3])
> -    hash = sha.new()
> +    hash = hashlib.sha1()
>     hash.update(output.getvalue())
>     sig = key.sign(hash.digest())
>     # write it to file
>     siglen.set(len(sig))
>     # sign again
> -    hash = sha.new()
> +    hash = hashlib.sha1()
>     hash.update(output.getvalue())
>     sig = key.sign(hash.digest())
>
> diff --git a/regulatory.bin b/regulatory.bin

Bleh, forgot to clean this, will resend.

  Luis
