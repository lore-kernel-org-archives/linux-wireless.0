Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59137 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab2KAQK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 12:10:56 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so2014815iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2012 09:10:55 -0700 (PDT)
Message-ID: <50929F0C.5060501@lwfinger.net> (sfid-20121101_171115_917673_A2854BF9)
Date: Thu, 01 Nov 2012 11:10:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Akira Nonaka <nonaka@mac.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8723e disconnect problem on the kernel 3.4.9.
References: <509200A2.9060300@mac.com>
In-Reply-To: <509200A2.9060300@mac.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2012 11:54 PM, Akira Nonaka wrote:
> Dear all,
> 
> I have a problem RTl8723 wifi connection. I can connect the access point
> fine but exactly 10 seconds later, the connection will be lost. This is
> 100% reproducible.  Here is the "iw event" log.
> 
> ---
> 1351707196.317590: wlan0 (phy #0): scan started
> 1351707197.302943: wlan0 (phy #0): scan finished: 2412 2417 2422 2427
> 2432 2437 2442 2447 2452 2457 2462 2467 2472, ""
> 1351707210.124514: wlan0 (phy #0): scan started
> 1351707211.109857: wlan0 (phy #0): scan finished: 2412 2417 2422 2427
> 2432 2437 2442 2447 2452 2457 2462 2467 2472, ""
> 1351707212.091111: wlan0 (phy #0): scan started
> 1351707213.075847: wlan0 (phy #0): scan finished: 2412 2417 2422 2427
> 2432 2437 2442 2447 2452 2457 2462 2467 2472, "WHRG300N"
> 1351707213.125596: wlan0: new station 00:24:a5:b4:d6:28
> 1351707213.128086: wlan0 (phy #0): auth 00:24:a5:b4:d6:28 ->
> 74:e5:43:d3:83:1f status: 0: Successful [frame: b0 00 3a 01 74 e5 43 d3
> 83 1f 00 24 a5 b4 d6 28 00 24 a5 b4 d6 28 40 02 00 00 02 00 00 00]
> 1351707213.190419: wlan0 (phy #0): assoc 00:24:a5:b4:d6:28 ->
> 74:e5:43:d3:83:1f status: 0: Successful ...
> 1351707213.190577: wlan0 (phy #0): connected to 00:24:a5:b4:d6:28
> 1351707222.948847: wlan0: unknown event 20
> 1351707222.965529: wlan0 (phy #0): deauth 74:e5:43:d3:83:1f ->
> 00:24:a5:b4:d6:28 reason 4: Disassociated due to inactivity [frame: c0
> 00 00 00 00 24 a5 b4 d6 28 74 e5 43 d3 83 1f 00 24 a5 b4 d6 28 00 00 04 00]
> 1351707222.965603: wlan0 (phy #0): disconnected (local request)
> 1351707222.979348: phy #0: regulatory domain change: set to world
> roaming by the wireless core upon initialization request
> 1351707222.982223: regulatory domain change: set to JP by a user request
> ---
> 
> Does anyone have the same problem? Can someone tell me what is "wlan0:
> unknown event 20"? I suspect this is the cause of the disconnection. I
> am no wifi expert. Where should I take look at in the source code?
> 
> I am using Fedora 16 kernel 3.4.9 with some minor patches and Realktek
> driver provided from my vendor,
> "8723AE_linux_WiFimac80211_0007.0809.2012.tar.gz".
> 
> And here is lspci info.
> 
> 02:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device 8723
> Subsystem: Realtek Semiconductor Co., Ltd. Device 0726
> Flags: bus master, fast devsel, latency 0, IRQ 18
> I/O ports at e000 [size=256]
> Memory at f7b00000 (64-bit, non-prefetchable) [size=16K]
> Capabilities: [40] Power Management version 3
> Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> Capabilities: [70] Express Endpoint, MSI 00
> Capabilities: [100] Advanced Error Reporting
> Capabilities: [140] Virtual Channel
> Capabilities: [160] Device Serial Number 01-23-87-fe-ff-4c-e0-00
> Kernel driver in use: rtl8723e
> Kernel modules: rtl8723e
> 
> I have sent the same question to the Realtek support but I also
> appreciate your help.

According to the table at
http://etutorials.org/Networking/Wireless+lan+security/Chapter+4.+WLAN+Fundamentals/Basic+Choreography/,
event 20 is "Invalid AKMP". That acronym stands for Active Key Management Protocol.

I have some questions:

(1) What version of the vendor driver are you using?
(2) Are the memset errors fixed? There are a number of calls where args 2 and 3
are reversed.
(3) Can you build your own kernel? If so, check
http://www'lwfinger.com/realtek_drivers/rtl8723ae_master_patch. That will patch
a 3.4 kernel to include the driver rtl8723ae that has been submitted for
inclusion in kernel 3.8.

Larry

