Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:60164 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3CQJyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 05:54:08 -0400
Subject: [PATCH] rtlwifi: usb: add missing freeing of skbuff
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 17 Mar 2013 11:54:04 +0200
Message-ID: <20130317095404.23346.42853.stgit@localhost6.localdomain6> (sfid-20130317_105412_736973_B25C322A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 drivers/net/wireless/rtlwifi/usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index b5c80b5..41dce83 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -850,6 +850,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(!_urb)) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Can't allocate urb. Drop skb!\n");
+		kfree_skb(skb);
 		return;
 	}
 	_rtl_submit_tx_urb(hw, _urb);

