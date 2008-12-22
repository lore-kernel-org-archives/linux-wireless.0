Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56412 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbYLVIv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 03:51:59 -0500
Date: Mon, 22 Dec 2008 10:51:46 +0200
From: Jouni Malinen <j@w1.fi>
To: Igor Trindade Oliveira <igor_trindade@yahoo.com.br>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] mac80211_hwsim: configfs support
Message-ID: <20081222085146.GC5732@jm.kir.nu> (sfid-20081222_095203_340300_8239F8AE)
References: <700428.4819.qm@web59316.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <700428.4819.qm@web59316.mail.re1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 20, 2008 at 09:48:22AM -0800, Igor Trindade Oliveira wrote:

> +++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-12-20 13:42:06.000000000 -0400
> @@ -21,15 +21,13 @@
>  #include <linux/if_arp.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/etherdevice.h>
> -#include <linux/debugfs.h>
> +#include <linux/configfs.h>

Hmm.. The addition of support to add interfaces dynamically with mkdir
sounds reasonable, but I'm not sure whether I really like the part of
removing debugfs support.. mac80211_hwsim is a developer tool and I want
to be able to have an undocumented and free for changes interface
(debugfs) that does not have so strict requirement on kernel-userspace
interface. This patch seems to also be moving the PS testing parameter
to use configfs. If this means that it will be more difficult to change
that mechanism or add new parameters in the future, I'm not sure I would
support that part of the change.

At minimum, I would like to see these two changes in separate patches:
1) change static (load time) radio setup to use mkdir in configfs, 2)
move ps parameter from debugfs to configfs. My initial thought would be
to only support (1), though, unless being convinced that (2) is useful
change, too.

We need to keep in mind that this is a developer test tool and it would
benefit from being able to easily add new parameters for whatever test
someone wants to run. In some cases, these are only for private testing
and the interface does not really matter that much, but sometimes the
change is useful for more people and it may be reasonable to merge that
into the upstream version. That power save code is an example of such a
case. However, it was by no means trying to make a permanent
kernel-userspace interface that we would need to maintain for years to
come.

> @@ -498,8 +501,8 @@ static void mac80211_hwsim_bss_info_chan
>  
>  	if (changed & BSS_CHANGED_HT) {
>  		printk(KERN_DEBUG "  %s: HT: op_mode=0x%x\n",
> -		       wiphy_name(hw->wiphy),
> -		       info->ht.operation_mode);
> +			wiphy_name(hw->wiphy),
> +			info->ht.operation_mode);			

Why? This does not seem to change anything apart from breaking
indentation.

> + * ConfigFS attribute declaration, to add a new attribute we just need to use 
> + * the MAC_HWSIM_ATTR_FOO macros and insert the new attribute in 

There seems to be trailing whitespace on those lines; please remove.

> +static void drop_mac80211_hwsim(struct config_group *group,
> +                                   struct config_item *item)

Please use tabs for indentation.

-- 
Jouni Malinen                                            PGP id EFC895FA
