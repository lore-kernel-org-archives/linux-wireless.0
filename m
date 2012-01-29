Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60148 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab2A2VkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 16:40:06 -0500
Message-ID: <4F25BCAE.3040709@hauke-m.de> (sfid-20120129_224048_197741_C541A4B0)
Date: Sun, 29 Jan 2012 22:39:58 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [compat-wireless] modprobe -l is legacy compatibility mode and
 is being removed from some distros
References: <4F1F0810.2000306@gmail.com>
In-Reply-To: <4F1F0810.2000306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2012 08:35 PM, Richard Farina wrote:
> module-init-tools has been deprecated in favor of kmod in Arch Linux,
> and kmod doesn't have the legacy --list option for modprobe.
> This patch fixes the areas of the Makefile which actually needed the
> output of modprobe -l. The other 100's of uses are just to echo info to
> the screen which in this case will simply fail in an extremely noisy
> fashion yet non-fatal way.
> 
> Please apply to all branches.
> 
> Signed-of-By: Rick Farina <sidhayn@gmail.com>
> 
> diff -Naur compat-wireless-3.3-rc1-2/Makefile
> compat-wireless-3.3-rc1-2-modinfo-migration/Makefile
> --- compat-wireless-3.3-rc1-2/Makefile    2012-01-21 02:00:21.000000000
> -0500
> +++ compat-wireless-3.3-rc1-2-modinfo-migration/Makefile    2012-01-24
> 14:27:20.000000000 -0500
> @@ -9,11 +9,6 @@
>  # Sometimes not available in the path
>  MODPROBE := /sbin/modprobe
> 
> -ifneq ($(wildcard $(MODPROBE)),)
> -MADWIFI=$(shell $(MODPROBE) -l ath_pci)
> -OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
> -endif
> -
What happens if modinfo is not available? I do not know on what systems
this is the case, but I do not think that modinfo is available when
modprobe is not.
>  DESTDIR?=
> 
>  ifneq ($(KERNELRELEASE),)
> @@ -188,7 +183,7 @@
>      @install scripts/athload    $(DESTDIR)/usr/sbin/
>      @install scripts/b43load    $(DESTDIR)/usr/sbin/
>      @install scripts/iwl-load    $(DESTDIR)/usr/sbin/
> -    @if [ ! -z "$(MADWIFI)" ] && [ -z "$(DESTDIR)" ]; then \
> +    @if [ `modinfo ath_pci > /dev/null 2>&1` ] && [ -z "$(DESTDIR)" ];
> then \
>          echo ;\
>          echo -n "Note: madwifi detected, we're going to disable it. "  ;\
>          echo "If you would like to enable it later you can run:"  ;\
> @@ -197,7 +192,7 @@
>          echo Running athenable ath5k...;\
>          /usr/sbin/athenable ath5k ;\
>      fi
> -    @if [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
> +    @if [ `modinfo iwl4965 > /dev/null 2>&1` ] && [ -z "$(DESTDIR)" ];
> then \
>          echo ;\
>          echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
>          echo "If you would like to enable it later you can run:"  ;\
> 

