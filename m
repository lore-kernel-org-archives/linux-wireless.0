Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:41210 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYABRZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 12:25:11 -0500
Date: Wed, 2 Jan 2008 18:25:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH v2] mac80211: better rate control algorithm selection
Message-ID: <20080102172505.GA9772@uranus.ravnborg.org> (sfid-20080102_172526_264986_6F1A706B)
References: <1199283424.4172.88.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1199283424.4172.88.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes.

Lo much better. One small comment.

>  
>  config MAC80211_LEDS
>  	bool "Enable LED triggers"
> --- everything.orig/net/mac80211/Makefile	2007-12-23 10:12:08.658937771 +0100
> +++ everything/net/mac80211/Makefile	2008-01-02 15:07:52.568414117 +0100
> @@ -1,19 +1,15 @@
>  obj-$(CONFIG_MAC80211) += mac80211.o
>  
> -mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
> -mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
> -mac80211-objs-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
> -mac80211-objs-$(CONFIG_MAC80211_RC_PID) += rc80211_pid_algo.o

> +# objects for PID algorithm
> +rc80211_pid-y := rc80211_pid_algo.o
> +rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
>  
> -mac80211-debugfs-objs-$(CONFIG_MAC80211_RC_PID) += rc80211_pid_debugfs.o
> -mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += \
> -	debugfs.o \
> -	debugfs_sta.o \
> -	debugfs_netdev.o \
> -	debugfs_key.o \
> -	$(mac80211-debugfs-objs-y)
> +# build helper for PID algorithm
> +rc-pid-y := $(rc80211_pid-y)

Is this extra indirection ( rc80211_pid-y ) a preparation
for future rate algorithms or was it just coped from my proposal?
It is not needed and it does not help readability.

A second note - but more as a personal taste..
I prefer += assignment in preference of continued lines.
So 
+mac80211-y := \
 	ieee80211.o \
  	ieee80211_ioctl.o \
 	sta_info.o \

would become:
+mac80211-y := ieee80211.o ieee80211_ioctl.o
+mac80211-y += sta_info.o
etc.

	Sam
