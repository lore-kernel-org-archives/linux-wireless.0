Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:39069 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab1KHVXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 16:23:32 -0500
Message-ID: <018001cc9e5b$e1cb2060$f9b5a8c0@pii350> (sfid-20111108_222354_243197_76D41855)
From: "Gilles Espinasse" <g.esp@free.fr>
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <1320739783-3415-1-git-send-email-g.esp@free.fr>
Subject: Re: [PATCH] Fix linking with libnl-3
Date: Tue, 8 Nov 2011 22:17:53 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


----- Original Message ----- 
From: "Gilles Espinasse" <g.esp@free.fr>
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>; "Gilles Espinasse" <g.esp@free.fr>
Sent: Tuesday, November 08, 2011 9:09 AM
Subject: [PATCH] Fix linking with libnl-3


> iw3.2 fail to link libnl-3.2.2 with this error
> /usr/bin/ld: cannot find -lnl-genl
>
> Contrary to previous libnl version, on v3 there is a dedicated
libnl-genl-3.0.pc file
> Simply use that.
>
> Signed-off-by: Gilles Espinasse <g.esp@free.fr>
> ---
>  Makefile |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 8443ee6..fb46324 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -36,10 +36,11 @@ LIBS += -lnl-genl
>  NLLIBNAME = libnl-2.0
>  endif
>
> +# libnl-3 has a separate libnl-genl-3.0.pc
>  ifeq ($(NL3FOUND),Y)
>  CFLAGS += -DCONFIG_LIBNL30
> -LIBS += -lnl-genl
> -NLLIBNAME = libnl-3.0
> +LIBS =
> +NLLIBNAME = libnl-genl-3.0
>  endif
>
>  ifeq ($(NLLIBNAME),)
> -- 
> 1.5.6.5
>
I had a bit of doubt and checked libnl-3.0, libnl-3.1, libnl-3.2.0
While the patch perfectly work for libnl-3.2.0..3.2.2 :
- it break libnl-3.0 where previous code would have work (no
libnl-genl-3.0.pc)
- libnl-3.1 had a libnl-genl-3.1.pc, so Makefile is broken with previous and
new code

Unsure there is a need to support 3.0 and 3.1 when three 3.2.<x> versions
exist?

Gilles

