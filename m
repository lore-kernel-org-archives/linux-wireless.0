Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:59543 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0IMS2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 14:28:13 -0400
Received: by pxi10 with SMTP id 10so2248719pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 11:28:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 13 Sep 2010 11:27:52 -0700
Message-ID: <AANLkTi=uRPLoO=RbKDfoenW2NUymbah==5tAyw39=O7s@mail.gmail.com>
Subject: Re: [PATCH 0/8 v2] compat-wireless: ath9kl and compat_autoconf.h fixes
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 11, 2010 at 9:18 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This series contains some fixes for the ath6kl driver, the
> compat_autoconf.h file now contains most of the conditions from
> config.mk and some fixes for CONFIG_WIRELESS_EXT=n were added.
>
> This patch series was build tested with kernel 2.6.24 to 2.6.37.
> It was build tested with kernel config:
>  * CONFIG_WIRELESS_EXT=n + CONFIG_CFG80211_WEXT=n
>  * CONFIG_WIRELESS_EXT=n + CONFIG_CFG80211_WEXT=y
>  * CONFIG_WIRELESS_EXT=y + CONFIG_CFG80211_WEXT=n
>  * CONFIG_WIRELESS_EXT=y + CONFIG_CFG80211_WEXT=y
>
> v1 -> v2:
>  * split "add conditions form config into compat_autoconf.h"
>  * reorder patches
>  * add brcm80211 driver
>
> Hauke Mehrtens (8):
>  compat-wireless: handle depending on something build as module
>  compat-wireless: make atk6kl build with older kernels
>  compat-wireless: fix for CONFIG_WIRELESS_EXT=n
>  compat-wireless: build if kernel does not have mac80211
>  compat-wireless: add conditions form config into compat_autoconf.h
>  compat-wireless: Add warning if wext is deactivated
>  compat-wireless: remove special handling for CONFIG_CFG80211_WEXT
>  compat-wireless: add brcm80211 driver
>
>  Makefile                                     |    1 +
>  config.mk                                    |  139 ++++++++++++++------------
>  patches/10-add-wext-handlers-to-netdev.patch |    8 ++-
>  patches/33-autoconf.patch                    |   15 +++
>  patches/34-backport-bin_attribute.patch      |   47 +++++++++
>  patches/35-backport-brcm80211-Makefile.patch |   11 ++
>  scripts/admin-update.sh                      |    1 +
>  scripts/gen-compat-autoconf.sh               |    8 +-
>  8 files changed, 161 insertions(+), 69 deletions(-)
>  create mode 100644 patches/33-autoconf.patch
>  create mode 100644 patches/34-backport-bin_attribute.patch
>  create mode 100644 patches/35-backport-brcm80211-Makefile.patch

Great stuff, this makes life so much easier, thanks a lot for all this
work! Applied and pushed out. Think it'll get sucked in, in time for
the next tarball.

  Luis
