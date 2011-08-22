Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout8.freenet.de ([195.4.92.98]:52018 "EHLO mout8.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1HVKYD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 06:24:03 -0400
Received: from [195.4.92.18] (helo=8.mx.freenet.de)
	by mout8.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1QvRfk-0004v3-HM
	for linux-wireless@vger.kernel.org; Mon, 22 Aug 2011 12:24:00 +0200
Received: from p4fde108b.dip0.t-ipconnect.de ([79.222.16.139]:59866 helo=mail.maya.org)
	by 8.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #5)
	id 1QvRfk-0007jI-92
	for linux-wireless@vger.kernel.org; Mon, 22 Aug 2011 12:24:00 +0200
Message-Id: <201108221023.p7MANt13003500@mail.maya.org> (sfid-20110822_122408_764753_2EDE03C8)
Date: Mon, 22 Aug 2011 12:23:58 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Subject: Broken 4 way handshake in hostapd during load
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,


please read the following as it is really a problem for me (and may
be others, too). I tried very hard to examine it (may be not hard
enough :-)) to get a hopefully good description of what's going on.


Always on rekeying PTK with load (throughput is about 4 MByte/s or more)
on the AP device, I'm getting the following timeout in the hostapd
(versions 0.6.10, 0.7.3. 0.8.x) log (it's working fine if the
connection is idle during the rekeying or the throughput is lower than
4 MByte/s):

Aug 22 09:24:19 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: rekeying PTK
Aug 22 09:24:19 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: sending 1/4 msg of 4-Way Handshake
Aug 22 09:24:19 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: received EAPOL-Key frame (2/4 Pairwise)
Aug 22 09:24:19 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: sending 3/4 msg of 4-Way Handshake
Aug 22 09:24:19 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: EAPOL-Key timeout
Aug 22 09:24:19 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: sending 3/4 msg of 4-Way Handshake
Aug 22 09:24:20 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: EAPOL-Key timeout
Aug 22 09:24:20 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: sending 3/4 msg of 4-Way Handshake
Aug 22 09:24:21 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: EAPOL-Key timeout
Aug 22 09:24:21 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: sending 3/4 msg of 4-Way Handshake
Aug 22 09:24:23 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: EAPOL-Key timeout
Aug 22 09:24:23 pc hostapd: wlan1: STA 11:11:11:11:11:11 WPA: PTKINITNEGOTIATING: Retry limit 4 reached
Aug 22 09:24:23 pc hostapd: wlan1: STA 11:11:11:11:11:11 IEEE 802.11: deauthenticated due to local deauth request

I can see this behavior with a rt2800pci and an ath9k based AP.

I sniffed the "air" using 802.11g mode (I was alone on the channel I
used) and saw, that the supplicant sent the 4/4 packet, but it seems
not to be seen on the AP device (neither in mon.wlan nor in wlan). To
confirm this, I added this debug entry to net/mac80211/rx.c and tested
again:

--- rx.c        2011-08-22 11:50:13.000000000 +0200
+++ rx.c.debug  2011-08-22 11:49:39.000000000 +0200
@@ -1646,8 +1646,10 @@
         */
        if (ehdr->h_proto == rx->sdata->control_port_protocol &&
            (compare_ether_addr(ehdr->h_dest, rx->sdata->vif.addr) == 0 ||
-            compare_ether_addr(ehdr->h_dest, pae_group_addr) == 0))
+            compare_ether_addr(ehdr->h_dest, pae_group_addr) == 0)) {
+               printk(KERN_DEBUG "received EAPOL");
                return true;
+               }
 
        if (ieee80211_802_1x_port_control(rx) ||
            ieee80211_drop_unencrypted(rx, fc)) {
---

This debug entry confirmed what I saw on the wlan or the mon.wlan -
device.


Which behavior of wpa_supplicant and hostapd could I see in detail now?

1. The 2/2 part of the 4/4 handshake has been done successfully

2. hostapd sends the 3/4 packet

3. wpa_supplicant sends the answer and is ready:
WPA: Key negotiation completed with 68:7f:74:fb:39:ee [PTK=CCMP GTK=CCMP]

4. hostapd doesn't see this frame -> hostapd times out

5. hostapd sends the 3/4 packet again and again (until the retry
limit is reached)

6. wpa_supplicant doesn't react any more - it's already ready!

7. Deauthentication and reauthentication

8. The throughput of the wireless connection is broken until now - I
have to restart the hostapd device and the client device to get my old
throughput again.


Is there any possibility to avoid this situation? Or did
I get something wrong (what?)?



Thank you very much for your time, work and support!
Kind regards,
Andreas
