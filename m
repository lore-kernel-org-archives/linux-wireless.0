Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:52448 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbXHLG2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2007 02:28:07 -0400
Message-ID: <46BEA874.1090209@lwfinger.net>
Date: Sun, 12 Aug 2007 01:28:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Bug in mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When V3 firmware is used for BCM43xx devices as will be required in b43legacy, the device cannot do 
hardware encryption. Accordingly, IEEE80211_HW_DEVICE_HIDES_WEP must not be set in the flags member 
of the ieee80211_hw struct. WEP is properly handled; however, when that flag is not set and WPA-PSK 
TKIP encryption is used, the log is full of "eth1: TKIP decrypt failed for RX frame from <AP MAC> 
(res=-2)" messages.

I tried some things, but so far I have not found a fix.

Thanks,

Larry
