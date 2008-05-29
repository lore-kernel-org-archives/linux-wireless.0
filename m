Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18040 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYE2Hh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 03:37:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: question about ...: wrong count at exit"
Date: Thu, 29 May 2008 09:37:22 +0200
Cc: libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805290937.22146.hs4233@mail.mn-solutions.de> (sfid-20080529_093731_142217_77BB66EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After pulling the newest sparse, I got some new sparse warnings
which puzzle me. Here's one of them:

drivers/net/wireless/libertas/main.c:477:9: warning: context imbalance in 'lbs_eth_stop': wrong count at exit
drivers/net/wireless/libertas/main.c:477:9:    context 'lock': wanted 0, got 1

However, the function looks quite innocent, and I cannot see
any imbalance there. Did I oversee something or is that a
problem of sparse?

static int lbs_eth_stop(struct net_device *dev)
{
        struct lbs_private *priv = (struct lbs_private *) dev->priv;

        lbs_deb_enter(LBS_DEB_NET);

        spin_lock_irq(&priv->driver_lock);
        priv->infra_open = 0;
        netif_stop_queue(dev);
        spin_unlock_irq(&priv->driver_lock);

        schedule_work(&priv->mcast_work);

        lbs_deb_leave(LBS_DEB_NET);
        return 0;
}
