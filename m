Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:40548 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZF0IzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2009 04:55:14 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: USB level power management for wireless dongles
Date: Sat, 27 Jun 2009 10:55:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200906271055.22894.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this very experimental patch adds USB autosuspend support
to a wireless driver. Please test this to verify to concept works.

	Regards
		Oliver

--

commit d0806743041f9d2e3e215877b869b85ab4287574
Author: Oliver Neukum <oneukum@linux-d698.(none)>
Date:   Sat Jun 27 10:40:54 2009 +0200

    support for simple USB autosuspend for rt2x00
    
    USB autosuspend is hooked into STATE_RADIO_ON/OFF
    This allows USB autosuspend if the network interface is down

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 66daf68..1507dcf 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1126,14 +1126,21 @@ static int rt2500usb_set_state(struct rt2x00_dev *rt2x00dev,
 static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 				      enum dev_state state)
 {
+	struct usb_interface *usb_intf;
 	int retval = 0;
 
 	switch (state) {
 	case STATE_RADIO_ON:
+		usb_intf = to_usb_interface(&rt2x00dev->dev);
+		retval = usb_autopm_get_interface(usb_intf);
+		if (retval < 0)
+			break;
 		retval = rt2500usb_enable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_OFF:
+		usb_intf = to_usb_interface(&rt2x00dev->dev);
 		rt2500usb_disable_radio(rt2x00dev);
+		usb_autopm_put_interface(usb_intf);
 		break;
 	case STATE_RADIO_RX_ON:
 	case STATE_RADIO_RX_ON_LINK:
@@ -2053,6 +2060,7 @@ static struct usb_driver rt2500usb_driver = {
 	.disconnect	= rt2x00usb_disconnect,
 	.suspend	= rt2x00usb_suspend,
 	.resume		= rt2x00usb_resume,
+	.supports_autosuspend = 1,
 };
 
 static int __init rt2500usb_init(void)
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3756166..4d20e58 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1907,6 +1907,7 @@ static int rt2800usb_set_state(struct rt2x00_dev *rt2x00dev,
 static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 				      enum dev_state state)
 {
+	struct usb_interface *usb_intf;
 	int retval = 0;
 
 	switch (state) {
@@ -1916,17 +1917,24 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		 * to be woken up. After that it needs a bit of time
 		 * to be fully awake and the radio can be enabled.
 		 */
+		usb_intf = to_usb_interface(&rt2x00dev->dev);
+		retval = usb_autopm_get_interface(usb_intf);
+		if (retval < 0)
+			break;
+		msleep(1); /* Paranoia */
 		rt2800usb_set_state(rt2x00dev, STATE_AWAKE);
 		msleep(1);
 		retval = rt2800usb_enable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_OFF:
+		usb_intf = to_usb_interface(&rt2x00dev->dev);
 		/*
 		 * After the radio has been disablee, the device should
 		 * be put to sleep for powersaving.
 		 */
 		rt2800usb_disable_radio(rt2x00dev);
 		rt2800usb_set_state(rt2x00dev, STATE_SLEEP);
+		usb_autopm_put_interface(usb_intf);
 		break;
 	case STATE_RADIO_RX_ON:
 	case STATE_RADIO_RX_ON_LINK:
@@ -3062,6 +3070,7 @@ static struct usb_driver rt2800usb_driver = {
 	.disconnect	= rt2x00usb_disconnect,
 	.suspend	= rt2x00usb_suspend,
 	.resume		= rt2x00usb_resume,
+	.supports_autosuspend = 1,
 };
 
 static int __init rt2800usb_init(void)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index c188488..18c2fbe 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1403,14 +1403,21 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 				    enum dev_state state)
 {
+	struct usb_interface *usb_intf;
 	int retval = 0;
 
 	switch (state) {
 	case STATE_RADIO_ON:
+		usb_intf = to_usb_interface(&rt2x00dev->dev);
+		retval = usb_autopm_get_interface(usb_intf);
+		if (retval < 0)
+			break;
 		retval = rt73usb_enable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_OFF:
+		usb_intf = to_usb_interface(&rt2x00dev->dev);
 		rt73usb_disable_radio(rt2x00dev);
+		usb_autopm_put_interface(usb_intf);
 		break;
 	case STATE_RADIO_RX_ON:
 	case STATE_RADIO_RX_ON_LINK:
@@ -2442,6 +2449,7 @@ static struct usb_driver rt73usb_driver = {
 	.disconnect	= rt2x00usb_disconnect,
 	.suspend	= rt2x00usb_suspend,
 	.resume		= rt2x00usb_resume,
+	.supports_autosuspend = 1,
 };
 
 static int __init rt73usb_init(void)

