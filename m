Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36272
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXHUWYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 18:24:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: allow disabling hardware encryption
Date: Wed, 22 Aug 2007 00:22:45 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1187712498.4218.3.camel@johannes.berg>
In-Reply-To: <1187712498.4218.3.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200708220022.45381.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 21 August 2007 18:08:18 Johannes Berg wrote:
> For debugging it seems useful to be able to turn off
> hardware encryption. With the changes I made to mac80211
> that is now simple.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> ---
>  drivers/net/wireless/b43/main.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-21 16:41:30.955923881 +0200
> +++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-21 16:47:46.175923881 +0200
> @@ -96,6 +96,10 @@ static int modparam_hwpctl;
>  module_param_named(hwpctl, modparam_hwpctl, int, 0444);
>  MODULE_PARM_DESC(hwpctl, "Enable hardware-side power control (default off)");
>  
> +static int modparam_nohwcrypt;
> +module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0644);
> +MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
> +
>  static const struct ssb_device_id b43_ssb_tbl[] = {
>  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
>  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
> @@ -2850,6 +2854,9 @@ static int b43_dev_set_key(struct ieee80
>  	u8 index;
>  	int err = -EINVAL;
>  
> +	if (modparam_nohwcrypt)
> +		return -ENOSPC;
> +
>  	if (!dev)
>  		return -ENODEV;
>  	switch (key->alg) {

I queued this, although your mac80211 patch that changes the key
stuff is not in, yet. /me looks at John. :)

-- 
Greetings Michael.
