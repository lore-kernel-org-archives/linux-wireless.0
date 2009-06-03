Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43964 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbZFCFBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 01:01:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 22:01:37 -0700
Date: Wed, 3 Jun 2009 10:30:19 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Remove modparam 'debug'
Message-ID: <20090603050019.GE17632@vasanth-laptop>
References: <1243951136-4033-1-git-send-email-vasanth@atheros.com> <1243951136-4033-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1243951136-4033-2-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2009 at 07:28:56PM +0530, Vasanth Thiagarajan wrote:

John,

> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/Kconfig |    4 ++--
>  drivers/net/wireless/ath/ath9k/debug.c |    5 +----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
> index 0ed1ac3..a5ab53f 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -17,8 +17,8 @@ config ATH9K_DEBUG
>         depends on ATH9K
>         ---help---
>           Say Y, if you need ath9k to display debug messages.
> -         Pass the debug mask as a module parameter:
> +         Pass the debug mask through debugfs interface:
> 
> -         modprobe ath9k debug=0x00002000
> +         echo <debug mask> > /<debugfsroot>/ath9k/phyX/debug
> 
>           Look in ath9k/core.h for possible debug masks
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index 6d20725..a4c0c7a 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -18,9 +18,6 @@
> 
>  #include "ath9k.h"
> 
> -static unsigned int ath9k_debug = DBG_DEFAULT;
> -module_param_named(debug, ath9k_debug, uint, 0);
> -
>  static struct dentry *ath9k_debugfs_root;
> 
>  void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
> @@ -489,7 +486,7 @@ static const struct file_operations fops_wiphy = {
> 
>  int ath9k_init_debug(struct ath_softc *sc)
>  {
> -       sc->debug.debug_mask = ath9k_debug;
> +       sc->debug.debug_mask = DBG_DEFAULT;
> 
>         if (!ath9k_debugfs_root)
>                 return -ENOENT;
> --
> 1.5.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Please ignore this patch as we will miss debug information during
device attach time if we remove the option to pass debug mask as 
modparam. thanks.


Vasanth
