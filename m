Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:53880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751545AbcEXWbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 18:31:20 -0400
From: Austin Riffle <ARiffle@efji.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Access Point will not disconnect
Date: Tue, 24 May 2016 21:58:26 +0000
Message-ID: <4C851F03BEE04A418B7A2D283DDCAB5D01E89F22@EFJDFWMB01.EFJDFW.local> (sfid-20160525_003124_655672_55758BB4)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm having an issue where missed beacons are not causing an access point to disconnect.

Here is my setup:
* Kernel 3.3 (Unfortunately I cannot change this)
* WPA Supplicant 2.5
* Wireless Extension 29
* RTL8192cu Device Driver

I've already done some debugging, and have found a possible issue in the kernel (that I'm unsure how to solve at this point). Here is what my debugging has revealed:

In the file: net/mac80211/scan.c line 214 I see a BSS with a bssid matching my AP as being linked (with my cfg80211_registered_device I believe???) via the function ieee80211_scan_rx. If I power off my AP, I no longer see this specific BSS as being received, so the driver seems to be scanning correctly and returning valid results.

After 15 seconds (IEEE80211_SCAN_RESULT_EXPIRE in net/wireless/scan.c) of missing a beacon, I would expect this BSS to be unlinked at the end of the next scan via cfg80211_wext_giwscan->ieee80211_scan_results->cfg80211_bss_expire. However, in the function cfg80211_bss_expire, this particular BSS is not unlinked, because line 205 asserts that the BSS atomic "lock" is being held (>1 value read).

Looking into why it is held, I believe that the BSS is held once we authenticate at the MLME layer.

My question is, how do I get this BSS to be unheld (probably in the MLME layer) so my AP is no longer linked - as it clearly should not be linked after being powered off long enough?

Could this be an error in my wpa_supplicant.conf, or is it a kernel bug? To me it seems like a kernel bug because the registered device still thinks that BSS is being held.

I've tried a few things to get this to work correctly with wpa_supplicant, but the only thing that I've done that has made the kernel give up on the current BSS is:

    # wpa_cli reassociate

which seems to make sense as that forces the registered device to give up its current BSS.

I've also tried

    # wpa_cli bss_expire_age 10
    # wpa_cli bss_expire_count 2

Which is another user-space attempt at a solution, but I think the issue may be deeper than that.

Thanks for your time and help
Austin
This e-mail transmission, and any documents, files or previous e-mail messages attached to it, may contain confidential information. If you are not the intended recipient, or a person responsible for delivering it to the intended recipient, you are hereby notified that any disclosure, distribution, review, copy or use of any of the information contained in or attached to this message is STRICTLY PROHIBITED. If you have received this transmission in error, please immediately notify us by reply e-mail, and destroy the original transmission and its attachments without reading them or saving them to disk. Thank you.

