Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38685 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889AbZC2NtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 09:49:25 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: p54spi - mesh mode summary
Date: Sun, 29 Mar 2009 15:49:17 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <200903282251.42585.chunkeey@web.de> <200903290841.59902.jcmvbkbc@gmail.com>
In-Reply-To: <200903290841.59902.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dx3zJo5/DDtXBlI"
Message-Id: <200903291549.17216.chunkeey@web.de> (sfid-20090329_154945_317371_19583639)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_dx3zJo5/DDtXBlI
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 29 March 2009 06:41:59 Max Filippov wrote:
> > your last patches had some offset, do you have more code fixes or
> > does everything work (properly)?
> The offset is caused by the fact that I haven't merged in changes that has been done since 2009.01.09.
> Now I've cherry-picked all recent patches related to p54, and IBSS and mesh are working good.
> 
> There are 3 issues that I'm focused on now:
> 
> - 'cx3110x spi2.0: WR_READY timeout' which sometimes occurs on ifdown-ifup cycle. Communication
>   with firmware breaks and sometimes the box hangs altogether. It looks like some locking-concurrency
>   issue, but I still haven't found it for sure;
> 
> - this, which happens every time when IBSS or mesh starts:
> <7>[  211.754448] wlan0: Creating new IBSS network, BSSID 56:75:0c:c5:65:0d
> <7>[  213.681352] phy0: Adding new IBSS station 00:1d:6e:9b:ee:6d (dev=wlan0)
> <7>[  213.681443] phy0: Allocated STA 00:1d:6e:9b:ee:6d
> <4>[  213.684251] ------------[ cut here ]------------
> <4>[  213.691850] WARNING: at kernel/softirq.c:138 local_bh_enable+0x54/0xbc()
> <4>[  213.699571] Modules linked in: p54spi
> <4>[  213.707231] [<c0034ff8>] (dump_stack+0x0/0x14) from [<c005b1f0>] (warn_on_slowpath+0x4c/0x68)
> <4>[  213.715623] [<c005b1a4>] (warn_on_slowpath+0x0/0x68)
> <4>[  213.740464] [<c00604c8>] (local_bh_enable+0x0/0xbc)
> <4>[  213.766221] [<bf000000>] (p54spi_op_tx+0x0/0x4c [p54spi])
> <4>[  213.793016] [<c01a4d34>] (p54_sta_unlock+0x0/0x78) 
hmm, sta_unlock is called from a tasklet, so we must use the irqsave functions
does this warning go away with the attached patch?

Regards,
	Chr

--Boundary-00=_dx3zJo5/DDtXBlI
Content-Type: text/x-diff;
  charset="utf-8";
  name="p54spi-irqsave-locks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54spi-irqsave-locks.diff"

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 155f453..5202312 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -469,9 +469,10 @@ static int p54spi_wq_tx(struct p54s_priv *priv)
 	struct ieee80211_tx_info *info;
 	struct p54_tx_info *minfo;
 	struct p54s_tx_info *dinfo;
+	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 
 	while (!list_empty(&priv->tx_pending)) {
 		entry = list_entry(priv->tx_pending.next,
@@ -479,7 +480,7 @@ static int p54spi_wq_tx(struct p54s_priv *priv)
 
 		list_del_init(&entry->tx_list);
 
-		spin_unlock_bh(&priv->tx_lock);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 		dinfo = container_of((void *) entry, struct p54s_tx_info,
 				     tx_list);
@@ -491,16 +492,14 @@ static int p54spi_wq_tx(struct p54s_priv *priv)
 
 		ret = p54spi_tx_frame(priv, skb);
 
-		spin_lock_bh(&priv->tx_lock);
-
 		if (ret < 0) {
 			p54_free_skb(priv->hw, skb);
-			goto out;
+			return ret;
 		}
-	}
 
-out:
-	spin_unlock_bh(&priv->tx_lock);
+		spin_lock_irqsave(&priv->tx_lock, flags);
+	}
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 	return ret;
 }
 
@@ -510,12 +509,13 @@ static void p54spi_op_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct p54_tx_info *mi = (struct p54_tx_info *) info->rate_driver_data;
 	struct p54s_tx_info *di = (struct p54s_tx_info *) mi->data;
+	unsigned long flags;
 
 	BUILD_BUG_ON(sizeof(*di) > sizeof((mi->data)));
 
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 	list_add_tail(&di->tx_list, &priv->tx_pending);
-	spin_unlock_bh(&priv->tx_lock);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	queue_work(priv->hw->workqueue, &priv->work);
 }
@@ -616,6 +616,7 @@ out:
 static void p54spi_op_stop(struct ieee80211_hw *dev)
 {
 	struct p54s_priv *priv = dev->priv;
+	unsigned long flags;
 
 	if (mutex_lock_interruptible(&priv->mutex)) {
 		/* FIXME: how to handle this error? */
@@ -627,9 +628,9 @@ static void p54spi_op_stop(struct ieee80211_hw *dev)
 	cancel_work_sync(&priv->work);
 
 	p54spi_power_off(priv);
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 	INIT_LIST_HEAD(&priv->tx_pending);
-	spin_unlock_bh(&priv->tx_lock);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	priv->fw_state = FW_STATE_OFF;
 	mutex_unlock(&priv->mutex);

--Boundary-00=_dx3zJo5/DDtXBlI--
