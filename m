Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.211.177]:65009 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZHFSnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:43:06 -0400
Received: by ywh7 with SMTP id 7so1390439ywh.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 11:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249580707.14919.29.camel@mj>
References: <4A7A8F7E.6020503@redfish-solutions.com> <1249569993.6446.2.camel@jdl-desktop>
	<1249576886.14919.16.camel@mj> <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>
	<1249580707.14919.29.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Aug 2009 11:42:46 -0700
Message-ID: <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>
Subject: Re: CRDA and cross-compilation
To: Pavel Roskin <proski@gnu.org>
Cc: Jon Loeliger <jdl@bigfootnetworks.com>,
	"Philip A. Prindeville" <philipp_subx@redfish-solutions.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 6, 2009 at 10:45 AM, Pavel Roskin<proski@gnu.org> wrote:
> On Thu, 2009-08-06 at 09:56 -0700, Luis R. Rodriguez wrote:
>
>> ACK, is it possible to make it simpler?
>
> OK, here's my take.
>
> We only need a native compiler to verify regulatory.bin.  I believe it's
> orthogonal to building CRDA.
>
> For someone doing a cross-compilation, it makes no sense to verify the
> installed regulatory.bin.  Thus, the verification should be optional.
>
> But the compilation of regdbdump shouldn't be.  Firstly, it's installed
> by "make install".  Secondly, somebody may want to verify regulatory.bin
> on the target system.
>
> Here's the patch:
>
>
> crda: make it possible to disable verification
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  Makefile |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index b93b735..3cc61c2 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -24,7 +24,9 @@ PUBKEY_DIR?=pubkeys
>
>  CFLAGS += -Wall -g
>
> -all: $(REG_BIN) crda intersect verify
> +all: all_noverify verify
> +
> +all_noverify: crda intersect regdbdump

You removed REG_BIN from here, was that intentional?

>  ifeq ($(USE_OPENSSL),1)
>  CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
> @@ -74,11 +76,12 @@ $(REG_BIN):
>        $(NQ) '  EXIST ' $(REG_BIN)
>        $(NQ)
>        $(NQ) ERROR: The file: $(REG_BIN) is missing. You need this in place in order
> -       $(NQ) to build CRDA. You can get it from:
> +       $(NQ) to verify CRDA. You can get it from:
>        $(NQ)
>        $(NQ) $(REG_GIT)
>        $(NQ)
>        $(NQ) "Once cloned (no need to build) cp regulatory.bin to $(REG_BIN)"
> +       $(NQ) "Use \"make noverify\" to disable verification"
>        $(NQ)
>        $(Q) exit 1
>
>
> --
> Regards,
> Pavel Roskin
>
