Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:56050 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0GZLHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 07:07:19 -0400
Subject: Hardware needs to know when EAP nego is complete
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Coelho Luciano Roth <luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 14:06:40 +0300
Message-ID: <1280142400.6475.33.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes, hello all,

As you may know the wl1271 hardware implements WLAN-Bluetooth
co-existence by toggling a single antenna between WLAN and Bluetooth.

To pull this off, several quirks are required, for instance WLAN must be
forced to full-PSM so that antenna-time for BT can be made available.
This is implemented by the wl1271 driver with the help of the mac80211.

There are lots of timing issues involved, and there is a priority
between WLAN an BT. To ensure BT A2DP and SCO work properly, BT needs to
have enough priority at the expense of WLAN performance. While this
works well enough when connected, during WLAN association and especially
during EAP negotiation the priority needs to be more on the WLAN side to
ensure reliability.

The wl1271 driver starts association with the priority on WLAN, which
means that BT performance is compromised. The wl1271 driver should
change the priority to BT after association and the EAP negotiations are
complete, to make sure BT is performing acceptably.

So, what this all boils down to is that the wl1271 driver needs to know
when the association, including the possible EAP negotations are fully
complete, to be able to adjust the priority.

Currently, there is no such information available to the driver. In fact
this information is not available anywhere in the kernel level either
(as the details of the EAP negotiation, needed keys etc are controlled
in user-space), so the trigger would need to come from user-space.

To enable this, an operand would be needed to nl80211 to indicate
completion of association (including the EAP negotiations.)
Corresponding functions would then be needed on the cfg80211 ops and
mac80211 ops.

User-space would then call the operand when association is complete. For
open/WEP AP's the operand would be called immediately after association,
and for WPA AP's the operand would be called once the EAP negotiations
are complete.


Thoughts? Ideas? Would this be acceptable?

-Juuso

