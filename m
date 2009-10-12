Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56344 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbZJLNJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 09:09:05 -0400
Subject: Re: WARNING: slow-path
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910121335.21807.hs4233@mail.mn-solutions.de>
References: <200910121335.21807.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 14:08:26 +0100
Message-Id: <1255352906.30919.11.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-12 at 13:35 +0200, Holger Schurig wrote:
> [   33.369923] WARNING: at net/wireless/mlme.c:135 __cfg80211_send_deauth+0x3f/0x1e1 [cfg80211]()

You're triggering the warning at line 135 of net/wireless/mlme.c, which
is 'ASSERT_WDEV_LOCK(wdev)' -- it's complaining that the lock isn't
held.
 
> static int lbs_cfg_ret_deauth(struct lbs_private *priv, unsigned long dummy,
>                            struct cmd_header *resp)
>         cfg80211_send_deauth(priv->dev, (u8 *)&mgmt, sizeof(mgmt),
>                              (void *)dummy); 

What happens if you make that last argument NULL instead of passing
'dummy' back to it? That makes cfg80211_send_deauth() magically do
different things w.r.t. locking. Johannes, this is _evil_:

void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len,
                          void *cookie)
{
        struct wireless_dev *wdev = dev->ieee80211_ptr;

        BUG_ON(cookie && wdev != cookie);

        if (cookie) {
                /* called within callback */
                __cfg80211_send_deauth(dev, buf, len);
        } else {
                wdev_lock(wdev);
                __cfg80211_send_deauth(dev, buf, len);
                wdev_unlock(wdev);
        }
}


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

