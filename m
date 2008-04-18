Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57042 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYDRJLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 05:11:32 -0400
Subject: Re: [PATCH] libertas: Fix ethtool statistics
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200804181102.03107.hs4233@mail.mn-solutions.de>
References: <1208448814.9212.270.camel@pmac.infradead.org>
	 <200804181102.03107.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 10:11:28 +0100
Message-Id: <1208509888.9212.291.camel@pmac.infradead.org> (sfid-20080418_101135_976350_7DE9DA26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-04-18 at 11:02 +0200, Holger Schurig wrote:
> NACK.

Thanks for testing.

> When I apply this patch and do "ethtool -S eth1", I get this:
> 
> $ ethtool -S eth1
> NIC statistics:
>      drop_duplicate_bcast: 7
>      drop_ttl_zero: 0
>      drop_no_fwd_route: 0
>      drop_no_buffers: 9223372036854775808
>      fwded_unicast_cnt: 0
>      fwded_bcast_cnt: 0
>      drop_blind_table: 0
>      tx_failed_cnt: 9223372036854775808

You were getting that anyway.

> But more severely, I get this in dmesg:
> 
> libertas enter: lbs_ethtool_get_stats()
> libertas: PREP_CMD: command 0x009b failed: 2

Now at least it's _trying_ to get the stats :)
                
> My firmware simply doesn't support the 009b command. It seems 
> also wrong to call an MESH related command on an struct 
> net_device *dev which is not priv->mesh_dev.
> 
> 
> That ethtool returns junk like "9223372036854775808" is another 
> error. lbs_mesh_access() returned 2, and the code does "if (ret) 
> return ret". Maybe it should be like "if (ret) return -ENOSYS 
> (or some other ENOxxx) instead?

The code does 'if (ret) return;', because it has no option to return an
error. I think the way round it would be something like this:

diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 21e6f98..2ca3f4f 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -146,12 +144,12 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
 
 static int lbs_ethtool_get_sset_count(struct net_device * dev, int sset)
 {
-	switch (sset) {
-	case ETH_SS_STATS:
+	struct lbs_private *priv = dev->priv;
+
+	if (sset == ETH_SS_STATS && dev == priv->mesh_dev)
 		return MESH_STATS_NUM;
-	default:
+	else
 		return -EOPNOTSUPP;
-	}
 }
 
 static void lbs_ethtool_get_strings(struct net_device *dev,

-- 
dwmw2

