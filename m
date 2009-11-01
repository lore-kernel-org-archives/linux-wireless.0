Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59896 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbZKAUK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 15:10:28 -0500
Date: Sun, 1 Nov 2009 22:10:24 +0200
From: Jouni Malinen <j@w1.fi>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] Allow scanning while in authenticated only state
Message-ID: <20091101201024.GA29524@jm.kir.nu>
References: <1256939391.31271.11.camel@maxim-laptop> <1256939549.31271.14.camel@maxim-laptop> <1256967782.3555.69.camel@johannes.local> <1256982381.3089.10.camel@maxim-laptop> <1256983366.3555.119.camel@johannes.local> <1256985196.3089.34.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1256985196.3089.34.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 31, 2009 at 12:33:16PM +0200, Maxim Levitsky wrote:

> How about putting this in wpa_supplicant, and end all trouble with this
> for once?
> 
> This is a workaround/hack, but at least it works....

Could you please add a comment pointing that out and explaining that the
deauth in disassoc is there due to mac80211's inability to handle
multiple APs in authenticated-but-not-associated state?

> diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
>  static int wpa_driver_nl80211_disassociate(void *priv, const u8 *addr,
>                                            int reason_code)

> -       return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISASSOCIATE,
> +
> +       err = wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISASSOCIATE,
> +                                      reason_code);
> +       if (err)
> +               return err;
> +       return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DEAUTHENTICATE,
>                                        reason_code);

There should be no need for doing both disassoc and deauth; just send
deauth only if that is needed. This will save one extra frame
transmission and speeds up roaming a bit.

Though, is this enough to handle the roaming cases where wpa_supplicant
may not try to send either disassociation or deauthentication?

-- 
Jouni Malinen                                            PGP id EFC895FA
