Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:19954 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbbGVC5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 22:57:00 -0400
Date: Wed, 22 Jul 2015 04:50:45 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: ahmed.taahir@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] Support python 3 in utils/key2pub.py.
Message-ID: <20150722045045.30642c25@mir> (sfid-20150722_045704_575300_F18AE317)
In-Reply-To: <1437525466-27512-2-git-send-email-ahmed.taahir@gmail.com>
References: <1437525466-27512-1-git-send-email-ahmed.taahir@gmail.com>
	<1437525466-27512-2-git-send-email-ahmed.taahir@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On 2015-07-21, ahmed.taahir@gmail.com wrote:
> From: Taahir Ahmed <ahmed.taahir@gmail.com>
> 
> utils/key2pub.py can now be run under either python 2.7 or python 3.x.
> This required some minor syntactical changes as well as switching from
> M2Crypto to pycrypto, since M2Crypto doesn't support python 3.x.
[...]
> diff --git a/Makefile b/Makefile
> index a3ead30..65fc780 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -112,7 +112,7 @@ $(REG_BIN):
>  keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
>  	$(NQ) '  GEN ' $@
>  	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
> -	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
> +	$(Q) python /utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
[...]

Without having tested it, nor being that familiar with python coding,
but this hunk seems to be problematic on two accords.

You omit $(pwd) from ./utils/key2pub.py, while /utils/key2pub.py
won't exist.

As little as I know about python packaging policies in Debian
(and probably Fedora), /usr/bin/python is never supposed to point
to python3 - afaik the interpreter should always be called python3
there, so I don't really see how that's going to work there.

Sorry if I missed anything obvious, but these things just caught
my attention without having looked any deeper.

Regards
	Stefan Lippers-Hollmann
