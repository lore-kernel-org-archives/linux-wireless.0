Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28315.mail.ukl.yahoo.com ([87.248.110.134]:40152 "HELO
	web28315.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753616AbZITSDV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2009 14:03:21 -0400
Message-ID: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
Date: Sun, 20 Sep 2009 11:03:24 -0700 (PDT)
From: Albert Herranz <albert_herranz@yahoo.es>
Subject: Problems with "cfg80211: fix SME connect" commit
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Patch "cfg80211: fix SME connect" breaks my setup (WPA2/AES-CCMP between my b43 card and my AP).

When the patch is applied, the usual kernel messages "direct probe" and "authenticate" never happen, and IP address adquisition via dhcp fails:

[   12.709769] b43-phy0 debug: Chip initialized
[   12.725621] b43-phy0 debug: PIO initialized
[   12.733015] b43-phy0 debug: QoS disabled
[   12.913516] b43-phy0 debug: Wireless interface started
[   13.021170] b43-phy0 debug: Adding Interface type 2

When the patch is reverted everything works again:

[   13.222940] b43-phy0 debug: Chip initialized
[   13.291359] b43-phy0 debug: PIO initialized
[   13.330116] b43-phy0 debug: QoS disabled
[   13.861636] b43-phy0 debug: Wireless interface started
[   13.969153] b43-phy0 debug: Adding Interface type 2
[   16.679249] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)
[   16.700998] wlan1 direct probe responded
[   16.707013] wlan1: authenticate with AP 00:12:17:15:e7:79 (try 1)
[   16.720205] wlan1: authenticated
[   16.726261] wlan1: associate with AP 00:12:17:15:e7:79 (try 1)
[   16.740697] wlan1: RX AssocResp from 00:12:17:15:e7:79 (capab=0x431 status=0 aid=1)
[   16.758042] wlan1: associated

Any clues?

Thanks,
Albert



      
