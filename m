Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:60347 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab3BAQkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 11:40:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 2/6] rtlwifi: Fix warnings in usb.c
Date: Fri,  1 Feb 2013 10:40:23 -0600
Message-Id: <1359736827-30977-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130201_174057_050605_D7C75C8F)
In-Reply-To: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Building this driver with "make W=1" results in the following 2 warnings:

drivers/net/wireless/rtlwifi/usb.c:829:21: warning: variable ‘urb_list’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/usb.c:828:23: warning: variable ‘skb_list’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 1535efd..d42bbe2 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -825,8 +825,6 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	u32 ep_num;
 	struct urb *_urb = NULL;
 	struct sk_buff *_skb = NULL;
-	struct sk_buff_head *skb_list;
-	struct usb_anchor *urb_list;
 
 	WARN_ON(NULL == rtlusb->usb_tx_aggregate_hdl);
 	if (unlikely(IS_USB_STOP(rtlusb))) {
@@ -836,7 +834,6 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return;
 	}
 	ep_num = rtlusb->ep_map.ep_mapping[qnum];
-	skb_list = &rtlusb->tx_skb_queue[ep_num];
 	_skb = skb;
 	_urb = _rtl_usb_tx_urb_setup(hw, _skb, ep_num);
 	if (unlikely(!_urb)) {
@@ -844,7 +841,6 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 			 "Can't allocate urb. Drop skb!\n");
 		return;
 	}
-	urb_list = &rtlusb->tx_pending[ep_num];
 	_rtl_submit_tx_urb(hw, _urb);
 }
 
-- 
1.8.1

