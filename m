Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38933 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1D1JMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:12:25 -0400
Received: by qyg14 with SMTP id 14so1314198qyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 02:12:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4DB91BB9.2080405@visionsystems.de>
References: <4DB91BB9.2080405@visionsystems.de>
Date: Thu, 28 Apr 2011 11:12:23 +0200
Message-ID: <BANLkTimJmSA4BheDCN+0V8=AbDoN3M=-Bg@mail.gmail.com> (sfid-20110428_111229_441179_33171CC8)
Subject: Re: [PATCH] iw: add libnl-3.0 support
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: yegor_sub1@visionsystems.de
Cc: Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 28, 2011 at 9:48 AM, Yegor Yefremov
<yegor_sub1@visionsystems.de> wrote:
> Extend Makefile to find and use libnl-3.0
>
> Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
> ---
>  Makefile |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> Index: b/Makefile
> ===================================================================
> --- a/Makefile
> +++ b/Makefile
> @@ -24,6 +24,7 @@
>
>  NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
>  NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
> +NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
>
>  ifeq ($(NL1FOUND),Y)
>  NLLIBNAME = libnl-1
> @@ -35,6 +36,12 @@
>  NLLIBNAME = libnl-2.0
>  endif
>
> +ifeq ($(NL3FOUND),Y)
> +CFLAGS += -DCONFIG_LIBNL20
> +LIBS += -lnl-genl
> +NLLIBNAME = libnl-3.0
> +endif
> +

Is this intended -DCONFIG_LIBNL**2**0 and NLLIBNAME = libnl-**3**.0?

- Sedat -

>  ifeq ($(NLLIBNAME),)
>  $(error Cannot find development files for any supported version of libnl)
>  endif
> @@ -53,6 +60,8 @@
>  all: version_check $(ALL)
>
>  version_check:
> +ifeq ($(NL3FOUND),Y)
> +else
>  ifeq ($(NL2FOUND),Y)
>  else
>  ifeq ($(NL1FOUND),Y)
> @@ -60,6 +69,7 @@
>        $(error No libnl found)
>  endif
>  endif
> +endif
>
>
>  VERSION_OBJS := $(filter-out version.o, $(OBJS))
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
