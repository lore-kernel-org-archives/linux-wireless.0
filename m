Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36154 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbYEJHYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 03:24:34 -0400
Date: Sat, 10 May 2008 09:24:28 +0200
From: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
Subject: [PATCH] [NET] libertas: check for mesh support before trying to
	use it
Message-ID: <20080510072428.GA1153@Chamillionaire.breakpoint.cc> (sfid-20080510_092458_605517_7B59DDDE)
References: <1208448814.9212.270.camel@pmac.infradead.org> <1208455363.20193.3.camel@localhost.localdomain> <20080417194437.GA18291@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <20080417194437.GA18291@Chamillionaire.breakpoint.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sebastian Siewior <sebastian@breakpoint.cc>

This will prevent the execution of lbs_ethtool_get_stats() via ethtool -S
if there is no mesh support.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
Dan, this will test prevent the usage of ethtool -S in case there is no
mesh support. If you fine with this than we could apply my or David's
other patch to enable the function again and then worry about the error
path.
David: I saw your patch that is doing this in a other way but I thing
that one looks better :)

 drivers/net/wireless/libertas/ethtool.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index dcfdb40..a79d698 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -113,8 +113,14 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
 
 static int lbs_ethtool_get_sset_count(struct net_device * dev, int sset)
 {
+	struct lbs_private *priv = dev->priv;
+
 	switch (sset) {
 	case ETH_SS_STATS:
+
+		if (!priv->mesh_tlv)
+			return -EOPNOTSUPP;
+
 		return MESH_STATS_NUM;
 	default:
 		return -EOPNOTSUPP;
-- 
1.5.4.3

