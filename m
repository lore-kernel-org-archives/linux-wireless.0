Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55913 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933846AbbA1UlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 15:41:20 -0500
MIME-Version: 1.0
Message-ID: <trinity-b84f3a65-5baa-4caa-9533-38c502a97908-1422443369840@3capp-gmx-bs18> (sfid-20150128_224019_910870_E5BDE3DE)
From: hansimgl@gmx.de
To: linux-wireless@vger.kernel.org
Subject: rtl8187 tx power question
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Jan 2015 12:09:30 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
 
 
In my application I need to lower the tx power of a rtl8187 based card. However, neither setting the tx power with iw nor changing the tx power in the radiotap header (I'm using injection) seems to make any difference.
I took a look at the driver code and noticed that the only source of the settings for rtl8225_rf_set_tx_power is the eeprom data that is read out in rtl8187_probe into the priv->channels array. rtl8187_tx also does not seem to change the tx power. This would let me conclude that the tx power is always fixed using the data from the eeprom.
However, on the other side there are all these wardriving kids that change their regulatory domain to increase their power for the exact same chip. Are all of them wrong or am I overseeing something in the driver?
 
 
Best regards,
Bob.
