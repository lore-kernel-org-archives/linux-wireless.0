Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from averell.mail.tiscali.it ([213.205.33.55]:43164 "EHLO
	averell.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab1FZU4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 16:56:48 -0400
Received: from e6550.localnet (84.220.145.52) by averell.mail.tiscali.it (8.5.137)
        id 4DE4FA2800B8944E for linux-wireless@vger.kernel.org; Sun, 26 Jun 2011 22:51:32 +0200
From: "dj_def@webmail.it" <dj_def@webmail.it>
To: linux-wireless@vger.kernel.org
Subject: Can't correctly capture EAPOL packets when in monitor mode
Date: Sun, 26 Jun 2011 22:51:31 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201106262251.31720.dj_def@webmail.it> (sfid-20110626_230301_618653_5C7A07D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the bugzilla link:
https://bugzilla.kernel.org/show_bug.cgi?id=38282

The network card doesn't work as expected in monitor mode (rt61pci driver).
It should be able to capture every EAPOL packet but with newer kernels it
can't.
To reproduce:

1) stop all network managers
2) sudo ifconfig wlan0 192.168.0.77
3) sudo route add default gw 192.168.0.1
4) wpa_passphrase myEssid
   ----> myWPA
   insert the output into /etc/wpa_supplicant.conf
5) sudo airmon-ng start wlan0 11
6) open wireshark with the correct privileges, start capturing from mon0,
select "eapol" filter, enable decryption inserting the correct wpa in the
preferences of the IEEE 802.11 protocol.
7) sudo wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf

With a 2.6.35 kernel (I tried with Ubuntu 10.10 and Backtrack 4) I can see all
the six EAPOL packets that I need to decrypt the traffic.

With a 2.6.38 kernel (I tried with Ubuntu 11.04 and Backtrack 5) I can see 
four
EAPOL packets (or five if I select "ignore the protection bit" + "with IV
detection" in the preferences of the IEEE 802.11 protocol). In particular the
"key" "(group msg 2/2)" packet is missing.
