Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:2011 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbYF0GCN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 02:02:13 -0400
Received: from [192.168.1.33] ([192.168.1.33])
	(authenticated user iwo@call-direct.com.au)
	by mail.call-direct.com.au (Kerio MailServer 6.4.1 patch 1)
	for linux-wireless@vger.kernel.org;
	Fri, 27 Jun 2008 15:57:03 +1000
Message-ID: <48648130.40402@call-direct.com.au> (sfid-20080627_080216_985183_62D87AE6)
Date: Fri, 27 Jun 2008 15:57:04 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
MIME-Version: 1.0
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: mac80211: Question about beacons
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to debug the AP mode of the rt73usb driver. It works OK,
as far as I can tell, but there are no beacons in the air. Not even garbled
packets. The AP is happy to respond to SSID broadcast requests though.

Now, when starting hostapd, the driver gets three rt73usb_beacon_update()
calls (struct ieee80211_ops ->beacon_update()). The SKBs passed in are
identical IEEE802.11 beacon packets, with the sequence numbers 0, 1 and 2.

I believe the hardware is supposed to be auto-beaconing.

Here is the question: why three calls? I would have expected a single 
call for
such a device.

Kind regards,

Iwo



