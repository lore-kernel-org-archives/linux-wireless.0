Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm19-vm0.bullet.mail.ird.yahoo.com ([77.238.189.92]:31810 "HELO
	nm19-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753186Ab3IAH6C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 03:58:02 -0400
Message-ID: <1378021881.73447.YahooMailBasic@web172302.mail.ir2.yahoo.com> (sfid-20130901_095806_924699_3188217C)
Date: Sun, 1 Sep 2013 08:51:21 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: fix use after free on failure path in rtl8187_init_urbs()
To: khoroshilov@ispras.ru, herton@canonical.com,
	larry.finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------------------------
On Sat, Aug 31, 2013 22:18 BST Alexey Khoroshilov wrote:

>In case of __dev_alloc_skb() failure rtl8187_init_urbs()
>calls usb_free_urb(entry) where 'entry' can points to urb
>allocated at the previous iteration. That means refcnt will be
>decremented incorrectly and the urb can be used after memory
>deallocation.
>
>The patch fixes the issue and implements error handling of init_urbs
>in rtl8187_start().
>
>Found by Linux Driver Verification project (linuxtesting.org).
>
>Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>---
> drivers/net/wireless/rtl818x/rtl8187/dev.c | 15 ++++++++++-----
> 1 file changed, 10 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>index f49220e..e83d53c 100644
>--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
>+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>@@ -438,17 +438,16 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
>         skb_queue_tail(&priv->rx_queue, skb);
>         usb_anchor_urb(entry, &priv->anchored);
>         ret = usb_submit_urb(entry, GFP_KERNEL);
>+        usb_free_urb(entry);
>         if (ret) {
>             skb_unlink(skb, &priv->rx_queue);
>             usb_unanchor_urb(entry);
>             goto err;
>         }
>-        usb_free_urb(entry);
>     }
>     return ret;
>
> err:
>-    usb_free_urb(entry);
>     kfree_skb(skb);
>     usb_kill_anchored_urbs(&priv->anchored);
>     return ret;

This part looks wrong - you free_urb(entry) then unanchor_urb(entry).

>@@ -956,8 +955,12 @@ static int rtl8187_start(struct ieee80211_hw *dev)
>                   (RETRY_COUNT < 8  /* short retry limit */) |
>                   (RETRY_COUNT < 0  /* long retry limit */) |
>                   (7 < 21 /* MAX TX DMA */));
>-        rtl8187_init_urbs(dev);
>-        rtl8187b_init_status_urb(dev);
>+        ret = rtl8187_init_urbs(dev);
>+        if (ret)
>+            goto rtl8187_start_exit;
>+        ret = rtl8187b_init_status_urb(dev);
>+        if (ret)
>+            usb_kill_anchored_urbs(&priv->anchored);
>         goto rtl8187_start_exit;
>     }
> 
>@@ -966,7 +969,9 @@ static int rtl8187_start(struct ieee80211_hw *dev)
>     rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
>     rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
> 
>-    rtl8187_init_urbs(dev);
>+    ret = rtl8187_init_urbs(dev);
>+    if (ret)
>+        goto rtl8187_start_exit;
> 
>     reg = RTL818X_RX_CONF_ONLYERLPKT |
>           RTL818X_RX_CONF_RX_AUTORESETPHY |
>-- 
>1.8.1.2
>


