Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52406 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1I3Tap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 15:30:45 -0400
Date: Fri, 30 Sep 2011 15:15:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Drake <dsd@laptop.org>
Cc: dcbw@redhat.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: detect TX lockups and reset hardware
Message-ID: <20110930191547.GD2526@tuxdriver.com> (sfid-20110930_213049_201163_506C8A28)
References: <20110921153017.8FDAE9D401D@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110921153017.8FDAE9D401D@zog.reactivated.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 04:30:17PM +0100, Daniel Drake wrote:
> Recent patches added support for resetting the SD8686 hardware when
> commands time out, which seems to happen quite frequently soon after
> resuming the system from a Wake-on-WLAN-triggered resume.
> 
> At http://dev.laptop.org/ticket/10969 we see the same thing happen
> with transmits. In this case, the hardware will fail to respond to
> a frame passed for transmission, and libertas (correctly) will block
> all further commands and transmissions as the hardware can only
> deal with one thing at a time. This results in a lockup while the
> system waits indefinitely for the dead card to respond.
> 
> Hook up a TX lockup timer to detect this and reset the hardware.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

> @@ -995,6 +1029,7 @@ void lbs_stop_card(struct lbs_private *priv)
>  
>  	/* Delete the timeout of the currently processing command */
>  	del_timer_sync(&priv->command_timer);
> +	del_timer_sync(&priv->tx_lockup_timer);
>  	del_timer_sync(&priv->auto_deepsleep_timer);
>  
>  	/* Flush pending command nodes */

This hunk doesn't apply.  What tree are you using as a base?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
