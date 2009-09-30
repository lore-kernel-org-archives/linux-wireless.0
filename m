Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2929 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZI3RVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 13:21:08 -0400
Message-ID: <4AC39383.9010109@canonical.com>
Date: Wed, 30 Sep 2009 11:21:07 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [iw PATCH] default install to $(PREFIX)/sbin
References: <1254316786-4670-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1254316786-4670-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The iw utility isn't generally useful to normal users, so move it to
> $(PREFIX)/sbin with other system management executables.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> As "suggested" by Johannes... :-)
> 
>  Makefile |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index cb5fcc1..68bef4d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -3,7 +3,7 @@
>  MAKEFLAGS += --no-print-directory
>  
>  PREFIX ?= /usr
> -BINDIR ?= $(PREFIX)/bin
> +SBINDIR ?= $(PREFIX)/sbin
>  MANDIR ?= $(PREFIX)/share/man
>  PKG_CONFIG ?= pkg-config
>  
> @@ -85,8 +85,8 @@ check:
>  
>  install: iw iw.8.gz
>  	@$(NQ) ' INST iw'
> -	$(Q)$(MKDIR) $(DESTDIR)$(BINDIR)
> -	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(BINDIR) iw
> +	$(Q)$(MKDIR) $(DESTDIR)$(SBINDIR)
> +	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(SBINDIR) iw
>  	@$(NQ) ' INST iw.8'
>  	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man8/
>  	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)$(MANDIR)/man8/ iw.8.gz

FWIW Ubuntu wireless-tools drops rfkill in /sbin, where I think tools
that require root for changes should live.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
