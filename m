Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55691 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbbBRTVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 14:21:22 -0500
Message-ID: <54E4E631.70800@candelatech.com> (sfid-20150218_202125_851227_86FCA8F2)
Date: Wed, 18 Feb 2015 11:21:21 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: ath10k <ath10k@lists.infradead.org>
Subject: ath10k number-of-peers exceeded (hacked 3.17, CT firmware)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the users of CT firmware (and my 3.17 kernel backported to their 3.14)
reported this.  This system is also having bad WMI mgt timeout issues, and
firmware crashed before these logs started (due to WMI tx hang), so possibly
that is the root cause of the peer issues.  The user believes he has only
a few stations connected to this AP.

There may be additional patches to the driver/kernel as well..some of this looks
a bit strange to me.

I am curious if there are known bugs in the 3.17 era with peer counter
mis-management?

Feb 18 09:31:00  wlan1: AP-STA-CONNECTED 00:1f:3b:11:b1:25
Feb 18 09:31:00  hostapd: wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: associated (aid 8)
Feb 18 09:31:00  kernel: [84594.723772] ath10k_pci 0000:07:00.0: state: 1 number of peers exceeded: peers number 64 (max peers 64)
Feb 18 09:31:00  wlan1: NEW-STA-CONNECTED 00:1f:3b:11:b1:25
Feb 18 09:31:00  wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: Could not add STA to kernel driver
Feb 18 09:31:00  wlan1: AP-STA-DISCONNECTED 00:1f:3b:11:b1:25
Feb 18 09:31:00  hostapd: wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: Could not add STA to kernel driver
Feb 18 09:31:00  wlan1: AUTH-RECEIVED 00:1f:3b:11:b1:25|04:f0:21:0f:3d:57|-41|9999|
Feb 18 09:31:00  wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: authenticated
Feb 18 09:31:00  hostapd: wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: authenticated
Feb 18 09:31:00  wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: associated (aid 8)
Feb 18 09:31:00  wlan1: AP-STA-CONNECTED 00:1f:3b:11:b1:25
Feb 18 09:31:00  hostapd: wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: associated (aid 8)
Feb 18 09:31:00  kernel: [84594.776796] ath10k_pci 0000:07:00.0: state: 1 number of peers exceeded: peers number 64 (max peers 64)
Feb 18 09:31:00  wlan1: NEW-STA-CONNECTED 00:1f:3b:11:b1:25
Feb 18 09:31:00  wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: Could not add STA to kernel driver
Feb 18 09:31:00  hostapd: wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: Could not add STA to kernel driver
Feb 18 09:31:00  wlan1: AP-STA-DISCONNECTED 00:1f:3b:11:b1:25
Feb 18 09:31:00  wlan1: AUTH-RECEIVED       00:1f:3b:11:b1:25|04:f0:21:0f:3d:57|-39|9999|
Feb 18 09:31:00  wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: authenticated
Feb 18 09:31:00  hostapd: wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: authenticated
Feb 18 09:31:00  wlan1: AUTH-RECEIVED 00:21:6a:5f:3f:c2|04:f0:21:0f:3d:57|-34|9999|
Feb 18 09:31:00  wlan1: STA 00:21:6a:5f:3f:c2 IEEE 802.11: authenticated
Feb 18 09:31:00  hostapd: wlan1: STA 00:21:6a:5f:3f:c2 IEEE 802.11: authenticated
Feb 18 09:31:00  wlan1: STA 00:1f:3b:11:b1:25 IEEE 802.11: associated (aid 8)
Feb 18 09:31:00  wlan1: AP-STA-CONNECTED 00:1f:3b:11:b1:25

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

