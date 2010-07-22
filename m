Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53462 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab0GVMVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 08:21:31 -0400
Date: Thu, 22 Jul 2010 14:21:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <holgerschurig@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] libertas: precedence bug
Message-ID: <20100722122102.GH17585@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Negate has precedence over comparison so the original test was always
false.  (Neither 0 nor 1 are equal to NL80211_IFTYPE_MONITOR).

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 411a3bb..8000ca6 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -180,7 +180,7 @@ void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count)
 {
 	struct tx_radiotap_hdr *radiotap_hdr;
 
-	if (!priv->wdev->iftype == NL80211_IFTYPE_MONITOR ||
+	if (priv->wdev->iftype != NL80211_IFTYPE_MONITOR ||
 	    priv->currenttxskb == NULL)
 		return;
 
