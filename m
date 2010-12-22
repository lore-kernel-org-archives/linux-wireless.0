Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:33615 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0LVSYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 13:24:09 -0500
Received: by iyf40 with SMTP id 40so2394367iyf.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 10:24:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293041434-3594-1-git-send-email-hauke@hauke-m.de>
References: <1293041434-3594-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 22 Dec 2010 13:23:48 -0500
Message-ID: <AANLkTik9=gSpE6sRoYZu-RZv3PjeQdtf_Y9hc=X-Z7w=@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: build led support conditionally
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 1:10 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> diff --git a/config.mk b/config.mk
> index 964c646..1f95908 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -133,7 +133,9 @@ CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel_ht
>  CONFIG_MAC80211_RC_PID=y
>  CONFIG_MAC80211_RC_MINSTREL=y
>  CONFIG_MAC80211_RC_MINSTREL_HT=y
> +ifdef CONFIG_LEDS_TRIGGERS
>  CONFIG_MAC80211_LEDS=y
> +endif #CONFIG_LEDS_TRIGGERS

Without using a space for the ifdef'd variable the
include/linux/compat_autoconf.h will end up still defining it but you
should not get it set on the local Makefiles, in this case we want it
to not be defined in the compat_autoconf.h as well so how about
instead (handing off to my atheros address as I use mutt there, one
second)

 Luis
