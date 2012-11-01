Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nk11p00mm-asmtp003.mac.com ([17.158.161.2]:46101 "EHLO
	nk11p00mm-asmtp003.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171Ab2KAFy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 01:54:57 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Received: from [10.20.200.174]
 (p3027-ipbf5206marunouchi.tokyo.ocn.ne.jp [118.8.142.27])
 by nk11p00mm-asmtp003.mac.com
 (Oracle Communications Messaging Server 7u4-26.01(7.0.4.26.0) 64bit (built Jul
 13 2012)) with ESMTPSA id <0MCS00FWJLNJGS30@nk11p00mm-asmtp003.mac.com> for
 linux-wireless@vger.kernel.org; Thu, 01 Nov 2012 04:54:56 +0000 (GMT)
Message-id: <509200A2.9060300@mac.com> (sfid-20121101_065514_626032_E7E12016)
Date: Thu, 01 Nov 2012 13:54:58 +0900
From: Akira Nonaka <nonaka@mac.com>
To: linux-wireless@vger.kernel.org
Subject: rtl8723e disconnect problem on the kernel 3.4.9.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I have a problem RTl8723 wifi connection. I can connect the access point
fine but exactly 10 seconds later, the connection will be lost. This is
100% reproducible.  Here is the "iw event" log.

---
1351707196.317590: wlan0 (phy #0): scan started
1351707197.302943: wlan0 (phy #0): scan finished: 2412 2417 2422 2427
2432 2437 2442 2447 2452 2457 2462 2467 2472, ""
1351707210.124514: wlan0 (phy #0): scan started
1351707211.109857: wlan0 (phy #0): scan finished: 2412 2417 2422 2427
2432 2437 2442 2447 2452 2457 2462 2467 2472, ""
1351707212.091111: wlan0 (phy #0): scan started
1351707213.075847: wlan0 (phy #0): scan finished: 2412 2417 2422 2427
2432 2437 2442 2447 2452 2457 2462 2467 2472, "WHRG300N"
1351707213.125596: wlan0: new station 00:24:a5:b4:d6:28
1351707213.128086: wlan0 (phy #0): auth 00:24:a5:b4:d6:28 ->
74:e5:43:d3:83:1f status: 0: Successful [frame: b0 00 3a 01 74 e5 43 d3
83 1f 00 24 a5 b4 d6 28 00 24 a5 b4 d6 28 40 02 00 00 02 00 00 00]
1351707213.190419: wlan0 (phy #0): assoc 00:24:a5:b4:d6:28 ->
74:e5:43:d3:83:1f status: 0: Successful ...
1351707213.190577: wlan0 (phy #0): connected to 00:24:a5:b4:d6:28
1351707222.948847: wlan0: unknown event 20
1351707222.965529: wlan0 (phy #0): deauth 74:e5:43:d3:83:1f ->
00:24:a5:b4:d6:28 reason 4: Disassociated due to inactivity [frame: c0
00 00 00 00 24 a5 b4 d6 28 74 e5 43 d3 83 1f 00 24 a5 b4 d6 28 00 00 04 00]
1351707222.965603: wlan0 (phy #0): disconnected (local request)
1351707222.979348: phy #0: regulatory domain change: set to world
roaming by the wireless core upon initialization request
1351707222.982223: regulatory domain change: set to JP by a user request
---

Does anyone have the same problem? Can someone tell me what is "wlan0:
unknown event 20"? I suspect this is the cause of the disconnection. I
am no wifi expert. Where should I take look at in the source code?

I am using Fedora 16 kernel 3.4.9 with some minor patches and Realktek
driver provided from my vendor,
"8723AE_linux_WiFimac80211_0007.0809.2012.tar.gz".

And here is lspci info.

02:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device 8723
Subsystem: Realtek Semiconductor Co., Ltd. Device 0726
Flags: bus master, fast devsel, latency 0, IRQ 18
I/O ports at e000 [size=256]
Memory at f7b00000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
Capabilities: [70] Express Endpoint, MSI 00
Capabilities: [100] Advanced Error Reporting
Capabilities: [140] Virtual Channel
Capabilities: [160] Device Serial Number 01-23-87-fe-ff-4c-e0-00
Kernel driver in use: rtl8723e
Kernel modules: rtl8723e

I have sent the same question to the Realtek support but I also
appreciate your help.

Regards,

-- 
Akira Nonaka
Tokyo, Japan
