Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46213 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZLOPvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 10:51:49 -0500
Received: by fxm21 with SMTP id 21so2273fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 07:51:47 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Gerhard van Gorkum <gerhard7@gmail.com>
Subject: Re: p54: unknown rssi calibration data packing
Date: Tue, 15 Dec 2009 16:51:39 +0100
Cc: linux-wireless@vger.kernel.org
References: <1260875438.8291.8.camel@linus1.gentoo.dynalias.org>
In-Reply-To: <1260875438.8291.8.camel@linus1.gentoo.dynalias.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MC7JLuOQCqmff0T"
Message-Id: <200912151651.40220.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_MC7JLuOQCqmff0T
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

On Tuesday 15 December 2009 12:10:38 Gerhard van Gorkum wrote:
> Hello,
> 
> I have 3 Dell 1450 Wireless USB adapters, and 2 of them give me issues
> with 'unknown rssi calibration data packing'.  Should I just report it
> here?
yes.

Do you know the hardware revisions of all three devices?
(Usually, this is written on the sticker at the bottom).
A lsusb -v of all three would be nice as well.

> phy2: p54 detected a LM87 firmware
> phy2: unknown rssi calibration data packing  type:(1908) len:14.
> rssical:00 00 8f 09 87 00 71 fe 78 14 81 00 7c fe        ......q.x...|.
> phy2: please report this issue.
> phy2: hwaddr 00:14:a5:95:5e:78, MAC:isl3892 RF:Xbow
Gee! No wonder the drivers complains: They put an extra 2 NULL bytes header
before the calibration data. I've no idea why, but I can give you a workaround
(see attached patch) to fix the issue (for now).

> phy3: p54 detected a LM87 firmware
> phy3: unknown rssi calibration data packing  type:(1908) len:14.
> rssical:00 00 8f 09 85 00 76 fe 78 14 81 00 7c fe        ......v.x...|.
> phy3: please report this issue.
> phy3: hwaddr 00:14:a5:d0:0a:1a, MAC:isl3892 RF:Xbow
Interesting: Same problem, but different 2.4GHz data.
maybe you got 2 different (preproduction)-revisions? 

Regards,
	Chr

--Boundary-00=_MC7JLuOQCqmff0T
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="p54-eeprom-wa-for-special-dell-1450usb-rssical.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-eeprom-wa-for-special-dell-1450usb-rssical.diff"

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 8e3818f..8497c96 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -417,6 +417,17 @@ static void p54_parse_rssical(struct ieee80211_hw *dev, void *data, int len,
 	int num_entries = (type == PDR_RSSI_LINEAR_APPROXIMATION) ? 1 : 2;
 	int i;
 
+	/*
+	 * Workaround for _some_ Dell 1450 Wireless USB adapters revisions
+	 *
+	 * For no apparent reason Dell decided to add an extra 2-byte NULL
+	 * array at the beginning of the rssi calibration parameter table.
+	 */
+	if (len == 14) {
+		data += 2;
+		len -= 2;
+	}
+
 	if (len != (entry_size * num_entries)) {
 		printk(KERN_ERR "%s: unknown rssi calibration data packing "
 				 " type:(%x) len:%d.\n",

--Boundary-00=_MC7JLuOQCqmff0T--
