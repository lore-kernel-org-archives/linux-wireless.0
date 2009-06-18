Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:65302 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbZFRDBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 23:01:05 -0400
Received: by ewy6 with SMTP id 6so1112697ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 20:01:07 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: lashkevi@landau.ac.ru, alan-jenkins@tuffmail.co.uk,
	Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH/RFC] rtl8187: initial suspend/resume support
Date: Thu, 18 Jun 2009 04:01:05 +0100
Message-Id: <1245294065-2189-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry wrote this patch in Dec 2008 in response to a posting of
rtl8187 suspend/resume problem on the linux-wireless mailing list.
Hin-Tak posted this to the kernel bugzilla #11887. It has since been tested
by a few people with mixed results - hibernation seems to work
(rather than hang), suspend-to-ram still doesn't. Resume in some
circumstances requires re-inserting the device where possible
(i.e. not built-in to laptops).

Larry later wrote another based on _stop()/_start().
Apparently a reset_resume() method is needed if the
device is physically removed during hibernation.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Tested-by: Michael Lashkevich <lashkevi@landau.ac.ru>
Tested-by: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   30 ++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 7c3966e..4c0e560 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1526,6 +1526,32 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	return err;
 }
 
+#ifdef CONFIG_PM
+
+static int rtl8187_suspend(struct usb_interface *intf, pm_message_t state)
+{
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+	struct rtl8187_priv *priv;
+	int time;
+
+	if (!dev)
+		return 0;
+
+	priv = dev->priv;
+
+	time = usb_wait_anchor_empty_timeout(&priv->anchored, 1000);
+	if (!time)
+		usb_kill_anchored_urbs(&priv->anchored);
+	return 0;
+}
+
+static int rtl8187_resume(struct usb_interface *intf)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PM */
+
 static void __devexit rtl8187_disconnect(struct usb_interface *intf)
 {
 	struct ieee80211_hw *dev = usb_get_intfdata(intf);
@@ -1551,6 +1577,10 @@ static struct usb_driver rtl8187_driver = {
 	.id_table	= rtl8187_table,
 	.probe		= rtl8187_probe,
 	.disconnect	= __devexit_p(rtl8187_disconnect),
+#ifdef CONFIG_PM
+	.suspend	= rtl8187_suspend,
+	.resume		= rtl8187_resume,
+#endif /* CONFIG_PM */
 };
 
 static int __init rtl8187_init(void)
-- 
1.6.2.2

