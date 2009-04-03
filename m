Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:34889 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZDCFMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 01:12:50 -0400
Message-ID: <49D59AA1.6030602@lwfinger.net> (sfid-20090403_071251_562294_91EF2F53)
Date: Fri, 03 Apr 2009 00:12:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Directory in sysfs being truncated
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg and Kay,

The wireless driver b43legacy uses a leds-class entry to interact with the
rfkill subsystem to control the radio LED. The name under which the LED is
registered is "b43legacy-phy0::radio", which is 21 characters in length. When
the corresponding directory is created in sysfs, the name is truncated to 19
characters due to the "#define BUS_ID_SIZE 20" statement in include/linux/device.h.

Marcel Holtmann wrote that he understood that this limitation will be
eliminated, and suggested that I contact you regarding this matter. I was
thinking of changing the driver so as to be able to control the naming; however,
if this limitation will be relaxed then I will just wait.

Thanks,

Larry
