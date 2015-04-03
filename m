Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33496 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbbDCJfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2015 05:35:52 -0400
MIME-Version: 1.0
Date: Fri, 3 Apr 2015 15:05:51 +0530
Message-ID: <CAGKQeFipVR5L1T1fKL-FWLO2HmT3n7cUWH6x=BrgGH43qf5atA@mail.gmail.com> (sfid-20150403_113602_177330_E8FE8331)
Subject: stp broadcast packet not receving with the bridge and wpa_supplicant
From: deepak kumar Pradhan <hydipu@gmail.com>
To: majordomo@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are using IXDP465 intel board which is running kernel 3.12.2 with a
wireless Atheros card (driver ath9k) for wireless driver.

We had configured the wireless client on this board and try to connect
Target board Access point.
Wireless client able to connect this Access point (With open and
secure mode).ping also working between Access point to wireless client
bridge.
But we are not observing any stp & arp broadcast packet passing
through the wireless client(capture the data using the tcpdump).
>From the Target board this packet are trasmited confirm by tcpdump.
We had also kept some debug print on our kernel (3.12.3) and this
packet also passing through the ath9k driver but not receiving on the
application layer.

Our Board configuration:
We have two wireless card and two ethernet interface,which are added
to the bridge.
wpa_supplicant(0.7.3) running on the wireless interface with the drive
nl80211 and set 4addr flag on using iw command.

Target board configuration:
Running with the kernel 2.6.15 and for access point they had used the
hostapd (0.5.8).
Driver used for Access point is madwifi(0.9.3) and Access point also
added to the Bridge with the wds support.
(We don't have access to target source code so we can't modify code on
target platform)

So it looks like madwifi + stp interoperability issue.
Has someone observed this issue. Any inputs on this is much appreciated.
Please forgive me if I have posted to a wrong list, and please guide
me where should I post this?

Thanks & regards,
Deepak Kumar Pradhan
