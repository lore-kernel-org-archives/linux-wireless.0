Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54489 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab3IOIUQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Sep 2013 04:20:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VL7Yy-0002Mx-6W
	for linux-wireless@vger.kernel.org; Sun, 15 Sep 2013 10:20:13 +0200
Received: from 157.144.69.111.dynamic.snap.net.nz ([111.69.144.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Sep 2013 10:20:12 +0200
Received: from olivier by 157.144.69.111.dynamic.snap.net.nz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Sep 2013 10:20:12 +0200
To: linux-wireless@vger.kernel.org
From: Olivier Reuland <olivier@reuland.ch>
Subject: Re: RTL8192CU continually reconnecting
Date: Sun, 15 Sep 2013 08:17:15 +0000 (UTC)
Message-ID: <loom.20130915T101439-276@post.gmane.org> (sfid-20130915_102022_861021_FE0D7592)
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm facing the same issue with a slightly different device: "ID 0b05:17ab 
ASUSTek Computer, Inc. USB-N13 802.11n Network Adapter (rev. B1) [Realtek 
RTL8192CU]". I'm also using Ubuntu, Saucy: "Linux desktop 3.11.0-7-generic 
#13-Ubuntu SMP Tue Sep 10 20:55:38 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux".

Sep 15 19:59:07 desktop NetworkManager[791]: <info> Config: added 'ssid' 
value 'MyWiFi'
Sep 15 19:59:07 desktop NetworkManager[791]: <info> Config: added 
'scan_ssid' value '1'
Sep 15 19:59:07 desktop NetworkManager[791]: <info> Config: added 'key_mgmt' 
value 'WPA-PSK'
Sep 15 19:59:07 desktop NetworkManager[791]: <info> Config: added 'psk' 
value '<omitted>'


Disconnect/reconnect cycle every 20-30 seconds.
Disconnect to fail every few minutes.

Sep 15 20:07:18 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:07:19 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> completed
Sep 15 20:07:50 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: completed -> disconnected
Sep 15 20:07:50 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:07:50 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:07:50 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> associating
Sep 15 20:07:51 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associating -> associated
Sep 15 20:07:51 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:07:52 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> completed
Sep 15 20:08:02 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: completed -> disconnected
Sep 15 20:08:02 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:08:02 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:08:03 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> disconnected
Sep 15 20:08:03 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:08:04 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:08:04 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> associating
Sep 15 20:08:04 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associating -> associated
Sep 15 20:08:04 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:08:16 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> disconnected
Sep 15 20:08:16 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> inactive
[FAILED JUST HERE]
Sep 15 20:08:29 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: inactive -> scanning
Sep 15 20:08:29 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:08:30 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> associating
Sep 15 20:08:30 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associating -> associated
Sep 15 20:08:30 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:08:30 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> completed
Sep 15 20:09:06 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: completed -> disconnected
Sep 15 20:09:06 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:09:07 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:09:07 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> associating
Sep 15 20:09:07 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associating -> associated
Sep 15 20:09:07 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:09:07 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> completed
Sep 15 20:09:26 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: completed -> disconnected
Sep 15 20:09:26 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:09:27 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:09:27 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> disconnected
Sep 15 20:09:27 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:09:28 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:09:28 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> disconnected
Sep 15 20:09:28 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:09:35 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:09:35 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> associating
Sep 15 20:09:35 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associating -> associated
Sep 15 20:09:35 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:09:35 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> completed
Sep 15 20:09:42 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: completed -> disconnected
Sep 15 20:09:42 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:09:43 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:09:43 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> disconnected
Sep 15 20:09:43 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:09:44 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:09:44 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> associating
Sep 15 20:09:44 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associating -> associated
Sep 15 20:09:44 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:09:44 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> completed
Sep 15 20:09:58 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: completed -> disconnected
Sep 15 20:09:58 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:09:59 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:09:59 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> disconnected
Sep 15 20:09:59 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:10:00 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:10:00 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> associating
Sep 15 20:10:00 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associating -> associated
Sep 15 20:10:00 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:10:00 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> completed
Sep 15 20:10:16 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: completed -> disconnected
Sep 15 20:10:16 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:10:17 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:10:17 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> disconnected
Sep 15 20:10:17 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> scanning
Sep 15 20:10:24 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: scanning -> authenticating
Sep 15 20:10:24 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: authenticating -> associating
Sep 15 20:10:24 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associating -> associated
Sep 15 20:10:24 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: associated -> 4-way handshake
Sep 15 20:10:30 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> disconnected
Sep 15 20:10:30 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: disconnected -> inactive
[FAILS AGAIN HERE]


The interesting part is probably:
Sep 15 20:10:30 desktop kernel: [ 4778.434695] wlan0: Connection to AP 
9c:c7:a6:1c:dc:a5 lost
Sep 15 20:10:30 desktop wpa_supplicant[6415]: wlan0: WPA: 4-Way Handshake 
failed - pre-shared key may be incorrect
Sep 15 20:10:30 desktop wpa_supplicant[6415]: wlan0: CTRL-EVENT-DISCONNECTED 
bssid=9c:c7:a6:1c:dc:a5 reason=4
Sep 15 20:10:30 desktop kernel: [ 4778.454580] cfg80211: Calling CRDA to 
update world regulatory domain
Sep 15 20:10:30 desktop NetworkManager[791]: <info> (wlan0): supplicant 
interface state: 4-way handshake -> disconnected
Sep 15 20:10:30 desktop NetworkManager[791]: <info> Activation 
(wlan0/wireless): disconnected during association, asking for new key.
Sep 15 20:10:30 desktop NetworkManager[791]: <info> (wlan0): device state 
change: activated -> need-auth (reason 'supplicant-disconnect') [100 60 8]




Let me know if there is anything I can do to help

Olivier





