Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:24979 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754156Ab0ELIUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 04:20:51 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0395612449
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 17:20:50 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 2/2] compat-wireless: make patches apply again
Date: Wed, 12 May 2010 17:20:50 +0900
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
References: <1273526650-26282-1-git-send-email-hauke@hauke-m.de> <1273526650-26282-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1273526650-26282-2-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201005121720.50514.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 May 2010 06:24:10 Hauke Mehrtens wrote:
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  patches/07-change-default-rate-alg.patch |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/patches/07-change-default-rate-alg.patch
> b/patches/07-change-default-rate-alg.patch index af65207..f0ccbce 100644
> --- a/patches/07-change-default-rate-alg.patch
> +++ b/patches/07-change-default-rate-alg.patch
> @@ -21,7 +21,7 @@ at compilation time.
>   module_param(ieee80211_default_rc_algo, charp, 0644);
>   MODULE_PARM_DESC(ieee80211_default_rc_algo,
>   		 "Default rate control algorithm for mac80211 to use");
> -@@ -118,8 +118,8 @@ ieee80211_rate_control_ops_get(const cha
> +@@ -119,8 +119,8 @@ ieee80211_rate_control_ops_get(const cha
>   		ops = 
ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
> 
>   	/* try built-in one if specific alg requested but not found */
> @@ -29,6 +29,6 @@ at compilation time.
>  -		ops = 
ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
>  +	if (!ops && strlen(CONFIG_COMPAT_MAC80211_RC_DEFAULT))
>  +		ops =
> ieee80211_try_rate_control_ops_get(CONFIG_COMPAT_MAC80211_RC_DEFAULT); +
> 	kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
> 
>   	return ops;
> - }

this is somehow messed up and doesn't apply. here is a fixed version of the 
patch (not a patch for a patch)...

---

Your current kernels configuration (.config and linux/autoconf.h)
are always respected when compiling external modules. Because
of this if you are using an old kernel which preferred the
PID rate control algorithm we cannot force it to use minstrel
instead. Minstrel is now the default rate control algorithm
and we want you to use it. To let you use it we redefine here
the CONFIG_MAC80211_RC_DEFAULT to CONFIG_COMPAT_MAC80211_RC_DEFAULT
and define CONFIG_COMPAT_MAC80211_RC_DEFAULT on config.mk.
Through the compat autoconf we then get it also defined there
at compilation time.

--- a/net/mac80211/rate.c	2010-05-12 16:27:02.245747971 +0900
+++ b/net/mac80211/rate.c	2010-05-12 17:00:45.855748158 +0900
@@ -23,7 +23,7 @@
 static LIST_HEAD(rate_ctrl_algs);
 static DEFINE_MUTEX(rate_ctrl_mutex);
 
-static char *ieee80211_default_rc_algo = CONFIG_MAC80211_RC_DEFAULT;
+static char *ieee80211_default_rc_algo = CONFIG_COMPAT_MAC80211_RC_DEFAULT;
 module_param(ieee80211_default_rc_algo, charp, 0644);
 MODULE_PARM_DESC(ieee80211_default_rc_algo,
 		 "Default rate control algorithm for mac80211 to use");
@@ -118,8 +118,8 @@
 		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
 
 	/* try built-in one if specific alg requested but not found */
-	if (!ops && strlen(CONFIG_MAC80211_RC_DEFAULT))
-		ops = ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
+	if (!ops && strlen(CONFIG_COMPAT_MAC80211_RC_DEFAULT))
+		ops = 
ieee80211_try_rate_control_ops_get(CONFIG_COMPAT_MAC80211_RC_DEFAULT);
 
 	return ops;
 }
