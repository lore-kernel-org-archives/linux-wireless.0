Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:60232 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZDGAAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 20:00:07 -0400
Subject: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 03:00:01 +0300
Message-Id: <1239062401.4705.23.camel@maxim-laptop> (sfid-20090407_020013_939126_90578556)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently I was trying to reduce time it takes for wireless card to
connect.

I noticed that always first attempt at scan fails when NM asks for scan.
I also noticed that this happens with quite recent kernels (I think
2,6.28) didn't have this behavior.

Looking a bit deeper I discovered that each time NM disconnects from a
networks it sets random ssid/essid to the card (using wireless
extensions)

After that scan fails for some time.

as a NM free example you can run 

iwconfig wlan0 essid dummy
iwlist scan


and this will fail



NM in this case waits for whole 10 seconds.


What do you think about this?

I confirm that on iwl3945 and ath5k, so this isn't driver specific.

Best regards,
	Maxim Levitsky

