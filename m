Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:39302 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZA0Dm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 22:42:26 -0500
Received: by yw-out-2324.google.com with SMTP id 9so2707974ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 19:42:24 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 26 Jan 2009 22:42:24 -0500
Message-ID: <c4d76b3b0901261942v23a84b65jab3cf59215c45307@mail.gmail.com> (sfid-20090127_044230_358519_ED420A05)
Subject: p54usb and 2.13.24.0 Firmware fail to probe 1st generation (ISL3886 +
	net2280)
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device is ID 2001:3701 D-Link Corp. [hex] DWL-G120 Spinnaker 802.11b

With firmware 2.13.24.0.lm86.arm, the probe fails:

Jan 26 22:24:26 rainbow kernel: [  153.217044] usb 5-2: new high speed
USB device using ehci_hcd and address 3
Jan 26 22:24:26 rainbow kernel: [  153.349788] usb 5-2: configuration
#1 chosen from 1 choice
Jan 26 22:24:26 rainbow kernel: [  153.350045] usb 5-2: firmware:
requesting isl3886usb
Jan 26 22:24:26 rainbow kernel: [  153.357700] phy2: p54 detected a
LM86 firmware
Jan 26 22:24:26 rainbow kernel: [  153.357706] p54: rx_mtu reduced
from 3240 to 2392
Jan 26 22:24:26 rainbow kernel: [  153.357711] phy2: FW rev 2.13.24.0
- Softmac protocol 5.9
Jan 26 22:24:26 rainbow kernel: [  153.357716] phy2: cryptographic
accelerator WEP:YES, TKIP:YES, CCMP:YES
Jan 26 22:24:28 rainbow kernel: [  155.552234] p54usb: probe of
5-2:1.0 failed with error -110
Jan 26 22:24:48 rainbow kernel: [  174.879425] usb 5-2: USB
disconnect, address 3

Change firmware to 2.13.1.0.arm.0 and it succeeds:

Jan 26 22:24:50 rainbow kernel: [  177.316145] usb 5-2: new high speed
USB device using ehci_hcd and address 4
Jan 26 22:24:50 rainbow kernel: [  177.448722] usb 5-2: configuration
#1 chosen from 1 choice
Jan 26 22:24:50 rainbow kernel: [  177.448935] usb 5-2: firmware:
requesting isl3886usb
Jan 26 22:24:50 rainbow kernel: [  177.485489] phy3: p54 detected a
LM86 firmware
Jan 26 22:24:50 rainbow kernel: [  177.485496] p54: rx_mtu reduced
from 3240 to 2392
Jan 26 22:24:50 rainbow kernel: [  177.485501] phy3: FW rev 2.13.1.0 -
Softmac protocol 5.5
Jan 26 22:24:50 rainbow kernel: [  177.485506] phy3: cryptographic
accelerator WEP:YES, TKIP:YES, CCMP:YES
Jan 26 22:24:52 rainbow kernel: [  179.392096] phy3: hwaddr
00:15:e9:12:3f:65, MAC:isl3886 RF:Frisbee
Jan 26 22:24:52 rainbow kernel: [  179.400242] wmaster0 (p54usb): not
using net_device_ops yet
Jan 26 22:24:52 rainbow kernel: [  179.401500] phy3: Selected rate
control algorithm 'minstrel'
Jan 26 22:24:52 rainbow kernel: [  179.401592] wlan0 (p54usb): not
using net_device_ops yet
Jan 26 22:24:52 rainbow kernel: [  179.421574] udev: renamed network
interface wlan0 to wlan2
Jan 26 22:24:56 rainbow kernel: [  183.486290] ADDRCONF(NETDEV_UP):
wlan2: link is not ready
Jan 26 22:24:57 rainbow kernel: [  184.181337] wlan2: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 22:24:57 rainbow kernel: [  184.190363] wlan2: authenticated
Jan 26 22:24:57 rainbow kernel: [  184.190370] wlan2: associate with
AP 00:30:bd:c0:90:24
Jan 26 22:24:57 rainbow kernel: [  184.193885] wlan2: RX AssocResp
from 00:30:bd:c0:90:24 (capab=0x1 status=0 aid=8)
Jan 26 22:24:57 rainbow kernel: [  184.193892] wlan2: associated
Jan 26 22:24:57 rainbow kernel: [  184.194510] wlan2: disassociating
by local choice (reason=3)
Jan 26 22:25:03 rainbow kernel: [  189.870792] wlan2: authenticate
with AP 00:30:bd:c0:90:24
Jan 26 22:25:03 rainbow kernel: [  189.875492] wlan2: authenticated
Jan 26 22:25:03 rainbow kernel: [  189.875498] wlan2: associate with
AP 00:30:bd:c0:90:24
Jan 26 22:25:03 rainbow kernel: [  189.878367] wlan2: RX AssocResp
from 00:30:bd:c0:90:24 (capab=0x1 status=0 aid=8)
Jan 26 22:25:03 rainbow kernel: [  189.878374] wlan2: associated
Jan 26 22:25:03 rainbow kernel: [  189.883084]
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
Jan 26 22:25:13 rainbow kernel: [  200.460142] wlan2: no IPv6 routers present

This message is went with the older 2.13.1.0 firmware.

Jason
