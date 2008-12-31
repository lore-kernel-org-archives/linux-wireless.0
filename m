Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:40826 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbYLaXAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 18:00:14 -0500
Message-ID: <495BF975.7030603@lwfinger.net> (sfid-20090101_000022_882721_C0F57A0E)
Date: Wed, 31 Dec 2008 17:00:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: htl10@users.sourceforge.net,
	Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
References: <348894.23448.qm@web23108.mail.ird.yahoo.com> <495B82CB.6050205@tuffmail.co.uk> <495BC8F9.4040203@lwfinger.net>
In-Reply-To: <495BC8F9.4040203@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is a second try at a suspend/resume patch for rtl8187. This one
also seems a bit too easy; however, it did work for me, at least for
STD. I now realize that my machine didn't power off in my previous
test. This time I manually turned it off before restarting. My
computer still doesn't STR, thus that was not tested.

Larry

=============





Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1464,6 +1464,28 @@ static int __devinit rtl8187_probe(struc
 	return err;
 }

+#ifdef CONFIG_PM
+
+static int rtl8187_suspend(struct usb_interface *intf, pm_message_t
state)
+{
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+
+	rtl8187_stop(dev);
+
+	return 0;
+}
+
+static int rtl8187_resume(struct usb_interface *intf)
+{
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+
+	rtl8187_start(dev);
+
+	return 0;
+}
+
+#endif /* CONFIG_PM */
+
 static void __devexit rtl8187_disconnect(struct usb_interface *intf)
 {
 	struct ieee80211_hw *dev = usb_get_intfdata(intf);
@@ -1484,6 +1506,10 @@ static struct usb_driver rtl8187_driver
 	.id_table	= rtl8187_table,
 	.probe		= rtl8187_probe,
 	.disconnect	= __devexit_p(rtl8187_disconnect),
+#ifdef CONFIG_PM
+	.suspend	= rtl8187_suspend,
+	.resume		= rtl8187_resume,
+#endif /* CONFIG_PM */
 };

 static int __init rtl8187_init(void)

