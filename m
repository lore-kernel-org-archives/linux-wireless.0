Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:60753 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbYE3VBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 17:01:35 -0400
Received: by nf-out-0910.google.com with SMTP id d3so78372nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 14:01:33 -0700 (PDT)
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: "BUG: unable to handle kernel paging request" on shutdown or killing NetworkManager in latest wireless-testing (with rt73usb wireless adapter)
Date: Fri, 30 May 2008 23:06:48 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <69e28c910805301336m319f6134i11f999d56b740314@mail.gmail.com>
In-Reply-To: <69e28c910805301336m319f6134i11f999d56b740314@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805302306.48653.IvDoorn@gmail.com> (sfid-20080530_230205_575215_3C0CE409)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I have just compiled a kernel from wireless-testing (32-bit x86), and
> I get this during shutdown or if I kill NetworkManager (blacklisting
> rt73usb fixes it):

Could you try below patch to see if that works?

Ivo

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 58d1633..63381cf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -347,8 +347,11 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Kill guardian urb.
+	 * Kill guardian urb (if required by driver).
 	 */
+	if (!test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags))
+		return;
+
 	for (i = 0; i < rt2x00dev->bcn->limit; i++) {
 		bcn_priv = rt2x00dev->bcn->entries[i].priv_data;
 		if (bcn_priv->guardian_urb)
