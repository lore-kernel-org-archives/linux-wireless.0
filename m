Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35275 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbbDFFZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2015 01:25:46 -0400
MIME-Version: 1.0
Date: Mon, 6 Apr 2015 10:55:45 +0530
Message-ID: <CAGKQeFjwX-xU6gxF7E-oyiuJzWpAOqApyrfmcWv3To6pUDAkzg@mail.gmail.com> (sfid-20150406_073740_064246_5A3577A4)
Subject: stp broadcast packet not receving with the bridge and wpa_supplicant
From: deepak kumar Pradhan <hydipu@gmail.com>
To: linux-wireless@vger.kernel.org, majordomo@vger.kernel.org
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
I had also kept some debug prints in our kernel (3.12.3) and this
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
