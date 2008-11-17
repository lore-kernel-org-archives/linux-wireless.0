Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbYKQKsh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 05:48:37 -0500
Message-ID: <49214BF3.8050306@suse.de> (sfid-20081117_114841_523707_4E6E4EC1)
Date: Mon, 17 Nov 2008 11:48:19 +0100
From: Frank Seidel <fseidel@suse.de>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"hschaa@suse.de" <hschaa@suse.de>
Subject: [PATCH] Re: Problem with Kernel Oops in ipw2200
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de>	 <20081112213350.GJ2411@tuxdriver.com>  <491BF062.4050705@suse.de> <1226631539.2604.411.camel@debian.sh.intel.com>
In-Reply-To: <1226631539.2604.411.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Fixes Oops in ipw2200:ipw_tx_skb when pinging through
a WPA enterprise connection.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Tested-by: Frank Seidel <fseidel@suse.de>
Signed-off-by: Ffrank Seidel <fseidel@suse.de>

---
 drivers/net/wireless/ipw2200.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -10190,6 +10190,11 @@ static int ipw_tx_skb(struct ipw_priv *p
 	u16 remaining_bytes;
 	int fc;
 
+	if (!(priv->status & STATUS_ASSOCIATED)) {
+		IPW_DEBUG_TX("Tx attempt while not associated.\n");
+		goto drop;
+	}
+
 	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 	switch (priv->ieee->iw_mode) {
 	case IW_MODE_ADHOC:
