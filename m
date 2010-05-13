Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44050 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab0EMLsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 07:48:38 -0400
Message-ID: <4BEBE70E.60500@hauke-m.de>
Date: Thu, 13 May 2010 13:48:30 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat-wireless: fix 07-change-default-rate-alg.patch
References: <20100513011711.13007.45318.stgit@tt-desk>
In-Reply-To: <20100513011711.13007.45318.stgit@tt-desk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 13.05.2010 03:17, schrieb Bruno Randolf:
> i need this change to make it apply again
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  patches/07-change-default-rate-alg.patch |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/patches/07-change-default-rate-alg.patch b/patches/07-change-default-rate-alg.patch
> index f0ccbce..f73a4c5 100644
> --- a/patches/07-change-default-rate-alg.patch
> +++ b/patches/07-change-default-rate-alg.patch
> @@ -10,9 +10,9 @@ and define CONFIG_COMPAT_MAC80211_RC_DEFAULT on config.mk.
>  Through the compat autoconf we then get it also defined there
>  at compilation time.
>  
> ---- a/net/mac80211/rate.c
> -+++ b/net/mac80211/rate.c
> -@@ -23,7 +23,7 @@ struct rate_control_alg {
> +--- a/net/mac80211/rate.c	2010-05-12 16:27:02.245747971 +0900
> ++++ b/net/mac80211/rate.c	2010-05-12 17:00:45.855748158 +0900
> +@@ -23,7 +23,7 @@
>   static LIST_HEAD(rate_ctrl_algs);
>   static DEFINE_MUTEX(rate_ctrl_mutex);
>   
> @@ -21,7 +21,7 @@ at compilation time.
>   module_param(ieee80211_default_rc_algo, charp, 0644);
>   MODULE_PARM_DESC(ieee80211_default_rc_algo,
>   		 "Default rate control algorithm for mac80211 to use");
> -@@ -119,8 +119,8 @@ ieee80211_rate_control_ops_get(const cha
> +@@ -118,8 +118,8 @@
>   		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
>   
>   	/* try built-in one if specific alg requested but not found */
> @@ -29,6 +29,6 @@ at compilation time.
>  -		ops = ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
>  +	if (!ops && strlen(CONFIG_COMPAT_MAC80211_RC_DEFAULT))
>  +		ops = ieee80211_try_rate_control_ops_get(CONFIG_COMPAT_MAC80211_RC_DEFAULT);
> - 	kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
>   
>   	return ops;
> + }
> 
Hi Bruno,

For me it does not apply any more against linux-next with your patch,
without your patch it still applies.

In the linux-next tree there is this line
kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
it was introduced 2 days ago. In wireless-text this does not exist for now.

Could it be that you tried to generate compat-wireless out of
wireless-testing and not linux-next?

Please run "./scripts/admin-refresh.sh refresh" after changing a patch
to format it automatically in a common way.

Hauke
