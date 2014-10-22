Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:45291 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJVNsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 09:48:15 -0400
Received: by mail-lb0-f181.google.com with SMTP id l4so2817430lbv.40
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 06:48:14 -0700 (PDT)
From: Karsten Wiese <fzuuzf@googlemail.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org,
	Karsten Wiese <fzuuzf@googlemail.com>
Subject: [PATCH 2/3] rtl8192cu: Call ieee80211_register_hw from rtl_usb_probe
Date: Wed, 22 Oct 2014 15:47:33 +0200
Message-Id: <1413985654-25070-3-git-send-email-fzuuzf@googlemail.com> (sfid-20141022_154818_679591_A6983789)
In-Reply-To: <1413985654-25070-1-git-send-email-fzuuzf@googlemail.com>
References: <1413985654-25070-1-git-send-email-fzuuzf@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a previous patch the call to ieee80211_register_hw was moved from the
load firmware callback to the rtl_pci_probe only.
rt8192cu also uses this callback. Currently it doesnt create a wlan%d device.
Fill in the call to ieee80211_register_hw in rtl_usb_probe.

Signed-off-by: Karsten Wiese <fzuuzf@googlemail.com>
---
 drivers/net/wireless/rtlwifi/usb.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 10cf69c..46ee956 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -1117,7 +1117,18 @@ int rtl_usb_probe(struct usb_interface *intf,
 	}
 	rtlpriv->cfg->ops->init_sw_leds(hw);
 
+	err = ieee80211_register_hw(hw);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Can't register mac80211 hw.\n");
+		err = -ENODEV;
+		goto error_out;
+	}
+	rtlpriv->mac80211.mac80211_registered = 1;
+
+	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
+
 error_out:
 	rtl_deinit_core(hw);
 	_rtl_usb_io_handler_release(hw);
-- 
1.9.1

