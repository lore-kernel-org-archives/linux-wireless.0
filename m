Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40524 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056AbYDDDVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 23:21:25 -0400
Subject: Re: [PATCH] rtl8187b work in progress...
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
In-Reply-To: <1207074268-16335-1-git-send-email-linville@tuxdriver.com>
References: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us>
	 <1207074268-16335-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 23:21:23 -0400
Message-Id: <1207279283.2585.11.camel@dv> (sfid-20080404_042134_935806_E1B954E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-01 at 14:24 -0400, John W. Linville wrote:
> No idea if it even compiles...

Sorry for delay.  Thanks for the code!  It needs some minor changes to
compile:

diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index 4c297d1..35c6486 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -50,6 +50,13 @@ struct rtl8187_tx_info {
 	struct ieee80211_hw *dev;
 };
 
+enum {
+	DEVICE_RTL8187,
+	DEVICE_RTL8187B
+};
+
+#define RTL818X_MSR_ENEDCA		(1 << 4)
+
 /* Tx flags are common between rtl8187 and rtl8187b */
 #define RTL8187_TX_FLAG_NO_ENCRYPT	(1 << 15)
 #define RTL8187_TX_FLAG_MORE_FRAG	(1 << 17)
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index ec7f80b..b1b2548 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -224,7 +224,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	info->urb = urb;
 	info->dev = dev;
 	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, 2),
-			  priv->is_rtl8187b ? hdr_b : hdr,
+			  priv->is_rtl8187b ? (void *)hdr_b : (void *)hdr,
 			  skb->len, rtl8187_tx_cb, skb);
 	usb_submit_urb(urb, GFP_ATOMIC);
 

Plus there are spurious messages about uninitialized hdr and hdr_b in
rtl8187_tx().  Perhaps a cleaner solution would be to use a union or
separate functions to populate the header, but that's details.  sparse
doesn't report anything serious.

Anyway, the module loads fine:

rtl8187 1-1:1.0: usb_probe_interface
rtl8187 1-1:1.0: usb_probe_interface - got id
phy2: Selected rate control algorithm 'pid'
phy2: hwaddr 00:14:d1:45:a9:0b, rtl8187 V0 + rtl8225
usbcore: registered new interface driver rtl8187

But if I bring the interface up, it takes a lot of time, and I get this
in the kernel log:

phy2: RF Calibration Failed! 0

Scanning causes immediate kernel panic in
ieee80211_generic_frame_duration(), which is called from rtl8187_tx().
Sorry, no time to capture the backtrace now, but it's the code added by
you.

-- 
Regards,
Pavel Roskin
