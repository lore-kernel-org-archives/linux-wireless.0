Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54460 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYJVU2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 16:28:44 -0400
Date: Wed, 22 Oct 2008 16:27:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/6] p54: borrow some setup code from stlc45xx
Message-ID: <20081022202755.GI15808@tuxdriver.com> (sfid-20081022_222850_867663_175A47A2)
References: <200810150407.56189.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810150407.56189.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 04:07:56AM +0200, Christian Lamparter wrote:
> This patch initialize all remaining values which are necessary for SPI firmwares.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

I had to apply this patch on top to get this to build...please make
sure you send me the same patches that you tested yourself!

John

---

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 77ece7c..9895563 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1032,13 +1032,13 @@ static int p54_setup_mac(struct ieee80211_hw *dev, u16 mode, const u8 *bssid)
 	struct sk_buff *skb;
 	struct p54_setup_mac *setup;
 
-	skb = p54_alloc_skb(dev, 0x8001, sizeof(struct p54_tx_control_hdr) +
+	skb = p54_alloc_skb(dev, 0x8001, sizeof(struct p54_control_hdr) +
 			    sizeof(*setup), P54_CONTROL_TYPE_SETUP,
 			    GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
-	setup = (struct p54_tx_control_filter *) skb_put(skb, sizeof(*filter));
+	setup = (struct p54_setup_mac *) skb_put(skb, sizeof(*setup));
 	priv->mac_mode = mode;
 	setup->mac_mode = cpu_to_le16(mode);
 	memcpy(setup->mac_addr, priv->mac_addr, ETH_ALEN);
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
