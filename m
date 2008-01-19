Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:2024 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYASKVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 05:21:35 -0500
Received: by ug-out-1314.google.com with SMTP id z38so586059ugc.16
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jan 2008 02:21:34 -0800 (PST)
Message-ID: <4791CF2B.7090604@gmail.com> (sfid-20080119_102141_043023_09ABF14D)
Date: Sat, 19 Jan 2008 11:21:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bruno Randolf <bruno@thinktube.com>
CC: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ath5k: debug level improvements
References: <200801191147.04877.bruno@thinktube.com> <20080119024926.12055.9695.stgit@one>
In-Reply-To: <20080119024926.12055.9695.stgit@one>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2008 03:49 AM, Bruno Randolf wrote:
> * use only one debug level for beacon debugging: unify ATH5K_DEBUG_BEACON and
> ATH5K_DEBUG_BEACON_PROC
> 
> * remove debug level ATH5K_DEBUG_FATAL. doesn't make sense as a debug level -
> if it's fatal it should be logged as an error.
> 
> * fancier printing of debug levels. cat /debugfs/ath5k/phy0/debug
> 
> * allow debug levels to be changed by echoing their name into
> /debugfs/ath5k/phy0/debug. this will toggle the state, when it was off it will
> be turned on and vice versa.
> 
> drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
> drivers/net/wireless/ath5k/debug.c:     Changes-licensed-under: GPL
> drivers/net/wireless/ath5k/debug.h:     Changes-licensed-under: GPL
> 
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> ---
> 
>  drivers/net/wireless/ath5k/base.c  |   10 ++--
>  drivers/net/wireless/ath5k/debug.c |   95 +++++++++++++++++++++++++++++++-----
>  drivers/net/wireless/ath5k/debug.h |   18 +++----
>  3 files changed, 93 insertions(+), 30 deletions(-)
> 
> 
[...]
> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
> index 4ba649e..63e39f9 100644
> --- a/drivers/net/wireless/ath5k/debug.c
> +++ b/drivers/net/wireless/ath5k/debug.c
> @@ -314,6 +314,76 @@ static const struct file_operations fops_reset = {
[...]
> +static ssize_t write_file_debug(struct file *file,
> +				 const char __user *userbuf,
> +				 size_t count, loff_t *ppos)
> +{
> +	struct ath5k_softc *sc = file->private_data;
> +	int i;

BTW. unsigned int generates better code on most platforms.

> +
> +	for (i = 0; i < ARRAY_SIZE(dbg_info); i++) {
> +		if (strncmp(userbuf, dbg_info[i].name,
> +					strlen(dbg_info[i].name)) == 0)

Ah, we have bugs in debug write methods. You can't pass user buffer to strcmp. 
You must copy_from_user() it first. Otherwise kernel won't be happy from 
userspace code such as:
fd = open("path_to_the_debug_file", O_RDWR);
write(fd, 1234 or NULL or whatever meaningless, 1);

Also you don't need to call strncmp, strcmp is OK (you can rely on dbg_info.name 
being null terminated and also the static strings such as "disable" are...) and 
shorter.

Microoptimisation is to put "break" right after it:

 > +			sc->debug.level ^= dbg_info[i].level; /* toggle bit */

but it's not mandatory at all.

thanks,
--js
