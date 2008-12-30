Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:52546 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYL3Rw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 12:52:59 -0500
Message-ID: <495A5FEC.5070608@lwfinger.net> (sfid-20081230_185306_380281_8ED22973)
Date: Tue, 30 Dec 2008 11:52:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
References: <Pine.LNX.4.44L0.0812301220090.2386-100000@iolanthe.rowland.org> <495A5AE5.1040902@tuffmail.co.uk>
In-Reply-To: <495A5AE5.1040902@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Jenkins wrote:
> That won't fix hibernation though.  The disconnect method can still get
> called in resume from hibernation, before the workqueue gets unfrozen. 
> To be honest, I'm far more interested in suspend-to-disk than
> suspend-to-ram.

Does this patch fix your problem? It works here, but I only did one
test. The patch is for wireless-testing.

Larry


Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1464,6 +1464,32 @@ static int __devinit rtl8187_probe(struc
 	return err;
 }

+#ifdef CONFIG_PM
+
+static int rtl8187_suspend(struct usb_interface *intf, pm_message_t
state)
+{
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+	struct rtl8187_priv *priv;
+        int time;
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
@@ -1484,6 +1510,10 @@ static struct usb_driver rtl8187_driver
 	.id_table	= rtl8187_table,
 	.probe		= rtl8187_probe,
 	.disconnect	= __devexit_p(rtl8187_disconnect),
+#ifdef CONFIG_PM
+	.suspend	= rtl8187_suspend,
+	.resume		= rtl8187_resume,
+#endif /* CONFIG_PM */
 };

 static int __init rtl8187_init(void)
