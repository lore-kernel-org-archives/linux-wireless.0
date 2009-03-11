Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38978 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbZCKWZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 18:25:28 -0400
Message-ID: <49B83A53.2000902@lwfinger.net> (sfid-20090311_232541_801420_183A66A8)
Date: Wed, 11 Mar 2009 17:25:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 - nice work!
References: <50533.82.152.175.172.1236798263.squirrel@www.phantomjinx.co.uk>    <49B813E9.8050108@lwfinger.net> <41788.82.152.175.172.1236803718.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <41788.82.152.175.172.1236803718.squirrel@www.phantomjinx.co.uk>
Content-Type: multipart/mixed;
 boundary="------------060503090109030909060408"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060503090109030909060408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

P.G. Richardson wrote:
> phy0: Selected rate control algorithm 'pid'
> 
> which is a first as it has always been 'mistral'. The only difference with
> compiling last night was I was not running the kernel I compiled against.
> I used 'make KLIB=/usr/src/{my new kernel} KLIB_BUILD=/usr/src/{my new
> kernel}' instead.
> 
> Just recompiled while running {my new kernel} and mistral correctly
> selected as rate control algorithm. Once installed, it does correctly auto
> select rate as expected.
> 
> iperf shows Mb performance has dropped though but gets improved by again
> fixing the rate at 11Mb.
> 
> So cheers for the info.

Minstrel is definitely a better choice than pid.

There is one thing that might make your interface work better. For performance
reasons, I chose not to pause the mac80211 queues at one point in the driver.
For my device, it did not make a difference, but it might for you. Please try
the attached patch.

Thanks,

Larry


--------------060503090109030909060408
Content-Type: text/plain;
 name="rtl8187_queue_pause"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rtl8187_queue_pause"

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -216,6 +216,7 @@ static void rtl8187_tx_cb(struct urb *ur
 		 * here, thus queue the skb and finish on a work queue. */
 		skb_queue_tail(&priv->b_tx_status.queue, skb);
 		queue_delayed_work(hw->workqueue, &priv->work, 0);
+		ieee80211_stop_queues(hw);
 	}
 }
 
@@ -898,6 +899,7 @@ static void rtl8187_work(struct work_str
 	}
 	retry = tmp;
 	mutex_unlock(&priv->conf_mutex);
+	ieee80211_wake_queues(dev);
 }
 
 static int rtl8187_start(struct ieee80211_hw *dev)

--------------060503090109030909060408--
