Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:16469 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYETHva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 03:51:30 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: fix multicast filtering on eth and msh interfaces.
Date: Tue, 20 May 2008 09:51:14 +0200
Cc: David Woodhouse <dwmw2@infradead.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <1211208955.21380.163.camel@pmac.infradead.org>
In-Reply-To: <1211208955.21380.163.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805200951.14516.hs4233@mail.mn-solutions.de> (sfid-20080520_095153_780235_BF15E9BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces trailing blanks, e.g. here:


> +	     dev = (dev==priv->mesh_dev?NULL:priv->mesh_dev)) {
> +		if ((dev_get_flags(dev) & (IFF_UP|IFF_MULTICAST)) !=
> +		    (IFF_UP|IFF_MULTICAST))
> +			continue;


The whole warning was: Warning: trailing whitespace in lines
621,625,654 of drivers/net/wireless/libertas/main.c.


I also had one patch reject against wireless-testing,
v2.6.26-rc2-7503-gc24e096, which was easy to fix:

@@ -1169,6 +1202,7 @@ int lbs_remove_card(struct lbs_private *priv)

        cancel_delayed_work(&priv->scan_work);
        cancel_delayed_work(&priv->assoc_work);
+       cancel_work_sync(&priv->mcast_work);
        destroy_workqueue(priv->work_thread);

        if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
