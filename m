Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22497 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbYLVRQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 12:16:14 -0500
Message-ID: <20081222121621.66jxpzr6lt8okk4o-cebfxv@webmail.spamcop.net> (sfid-20081222_181621_767424_496AEE78)
Date: Mon, 22 Dec 2008 12:16:21 -0500
From: Pavel Roskin <proski@gnu.org>
To: yyhymmh@yahoo.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] How to enable Monitor mode?
References: <690453.5943.qm@web80505.mail.mud.yahoo.com>
In-Reply-To: <690453.5943.qm@web80505.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting hwang <yyhymmh@yahoo.com>:

> I am first time use ath9k driver. I like to change the card to   
> Monitor mode. Can anyone tell which command does it?
>
> I tried to use iwconfig, but failed.

Moving discussion from ath9k-devel@lists.ath9k.org to  
linux-wireless@vger.kernel.org, as it's a common problem for all  
mac80211 based drivers.

Following code in net/mac80211/iface.c, ieee80211_if_change_type()  
prevents setting monitor mode:

         /* Setting ad-hoc mode on non-IBSS channel is not supported. */
         if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
                 return -EOPNOTSUPP;

The effect of the code exceeds the effect described by the comment, so  
something must be wrong.  I'm not running crda, so I guess I'm in the  
"world" domain that doesn't prermit IBSS.  But it should not disable  
monitor mode.

A simple fix would be:

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5abbc3f..b907482 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -699,7 +699,8 @@ int ieee80211_if_change_type(struct  
ieee80211_sub_if_data *sdata,
  		return 0;

  	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
-	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
+	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
+	    type == NL80211_IFTYPE_ADHOC)
  		return -EOPNOTSUPP;

  	/*

I've tested it, and it actually enables monitor mode.  I remember Luis  
mentioning that IEEE80211_CHAN_NO_IBSS means no beacons, so maybe  
other modes need to be disabled (AP, maybe mesh), but there are no  
beacons sent in the monitor mode.

-- 
Regards,
Pavel Roskin
