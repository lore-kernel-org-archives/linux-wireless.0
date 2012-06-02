Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344Ab2FBRx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 13:53:29 -0400
Message-ID: <1338659608.12823.4.camel@jlt3.sipsolutions.net> (sfid-20120602_195354_124758_5B7B5BB4)
Subject: Re: [PATCH v2]: iw: fix the Makefile for multiple libnl
 installations
From: Johannes Berg <johannes@sipsolutions.net>
To: Guido Trentalancia <guido@trentalancia.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 02 Jun 2012 19:53:28 +0200
In-Reply-To: <201206021653.q52Gre5c017440@vivaldi07.register.it>
References: <201206021653.q52Gre5c017440@vivaldi07.register.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-02 at 18:53 +0200, Guido Trentalancia wrote:

> -NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
> -NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
> -NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
> -NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
> +ifeq ($(NLLIBNAME),)
>  NL3xFOUND := $(shell $(PKG_CONFIG) --atleast-version=3.2 libnl-3.0 && echo Y)
> +ifneq ($(NL3xFOUND),Y)
> +NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
> +ifneq ($(NL31FOUND),Y)
> +NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
> +ifneq ($(NL3FOUND),Y)
> +NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
> +ifneq ($(NL2FOUND),Y)
> +NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
> +endif

If you have this part, then

>  ifeq ($(NL2FOUND),Y)
> -CFLAGS += -DCONFIG_LIBNL20
> -LIBS += -lnl-genl
> +CFLAGS = -DCONFIG_LIBNL20
> +LIBS = -lnl-genl

All these changes aren't necessary, right? I'd prefer not to make these
changes since people might want to set some CFLAGS somewhere.

johannes

