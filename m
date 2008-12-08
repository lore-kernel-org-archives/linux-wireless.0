Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:51340 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYLHNFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:05:49 -0500
Date: Mon, 8 Dec 2008 15:05:36 +0200
From: Jouni Malinen <j@w1.fi>
To: Igor Trindade Oliveira <igor_trindade@yahoo.com.br>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] mac80211_hwsim: configfs support
Message-ID: <20081208130536.GA6026@jm.kir.nu> (sfid-20081208_140601_931981_F7CC08D7)
References: <52953.29307.qm@web59310.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52953.29307.qm@web59310.mail.re1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 05, 2008 at 01:37:48PM -0800, Igor Trindade Oliveira wrote:

> Mac80211_hwsim: Support to configfs operations for create a new radio

The change in general looks reasonable, but I have couple of comments
about the details.

Could you please also update Documentation/networking/mac80211_hwsim/
README to replace the kernel module parameter with description on how to
add virtual radios?

> +++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-12-02 06:21:56.000000000 -0400
> @@ -140,10 +138,15 @@ struct mac80211_hwsim_data {
>  		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
>  	} ps;
>  	bool ps_poll_pending;
> -	struct dentry *debugfs;
> -	struct dentry *debugfs_ps;
> +	struct config_item item;
>  };
>  
> +struct mac80211_hwsim_attr {
> +	struct configfs_attribute attr;
> +	 ssize_t(*show) (struct mac80211_hwsim_data *hwsim, char *buf);
> +	 ssize_t(*store) (struct mac80211_hwsim_data *hwsim,
> +			  const char *buf, ssize_t count);

There is extra space (<TAB><SPACE>ssize_t) in indentation here. As far
as function pointer style is concerned, my preference would be to move
the space to be before the variable name: ssize_t (*show)(struct..).

> +static struct configfs_atribbute *mac80211_hwsim_attrs[] = {

Has this been even compile tested? I would assume no, since that struct
name has two typos in it..

> +/*
> + * now we just have one attribute with this function we can
> + * add new attributes in mac80211_hwsim_attrs and do not change
> + * others parts of the code
> + */

Is that comment specific to this function or is it just description of
what the change in whole is doing? Is it describing the change, it
should be in commit message, not in the source code. If it describe this
particular function, I would suggest somewhat different wording to make
that cleaner. It could also be moved above mac80211_hwsim_attrs
initialization if it is describing how new attributes are added.

> @@ -875,3 +993,4 @@ static void __exit exit_mac80211_hwsim(v
>  
>  module_init(init_mac80211_hwsim);
>  module_exit(exit_mac80211_hwsim);
> +

Please don't add unnecessary (and unwanted) whitespace changes.

-- 
Jouni Malinen                                            PGP id EFC895FA
