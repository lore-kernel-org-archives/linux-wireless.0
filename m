Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751022AbYAPXtg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 18:49:36 -0500
Subject: Re: rc80211-pid: fix last_sample initialization
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <20080117003829.6d1c15cc@morte>
References: <20080117003829.6d1c15cc@morte>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 00:49:33 +0100
Message-Id: <1200527373.7499.5.camel@localhost> (sfid-20080116_234941_179837_A60C0FA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2008-01-17 at 00:38 +0100, Stefano Brivio wrote:
> Fix last_sample initialization. kzalloc'ing the per-STA data wasn't enough,
> as jiffies can assume negative values as well. This fixes a bug which
> prevented correct PID operation for a while after booting.
> 
> Thanks to Michael Buesch for reporting this.
> 
> Reported-and-tested-by: Michael Buesch <mb@bu3sch.de>
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

Ack.

> ---
> Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
> ===================================================================
> --- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
> +++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
> @@ -496,6 +496,8 @@ static void *rate_control_pid_alloc_sta(
>  	if (spinfo == NULL)
>  		return NULL;
>  
> +	spinfo->last_sample = jiffies;
> +
>  #ifdef CONFIG_MAC80211_DEBUGFS
>  	spin_lock_init(&spinfo->events.lock);
>  	init_waitqueue_head(&spinfo->events.waitqueue);
> 
> 

