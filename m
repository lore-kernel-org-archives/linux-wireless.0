Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54285 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab2AQDAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 22:00:10 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RmzHM-0005P0-L7
	for linux-wireless@vger.kernel.org; Tue, 17 Jan 2012 04:00:08 +0100
Received: from c-98-192-246-202.hsd1.de.comcast.net ([98.192.246.202])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 04:00:08 +0100
Received: from gnorkus by c-98-192-246-202.hsd1.de.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 04:00:08 +0100
To: linux-wireless@vger.kernel.org
From: Gerhard J Norkus <gnorkus@comcast.net>
Subject: RTL8192CU problems with EAPOL
Date: Tue, 17 Jan 2012 02:54:32 +0000 (UTC)
Message-ID: <loom.20120117T033430-62@post.gmane.org> (sfid-20120117_040015_111811_7C2E1005)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using a BeagleBoard-xM with Ubuntu 11.10 on it.  The problem is with a 
NetGear WNA1000M using the RTL8192CU firwmare.  I'm quite new to Linux, so 
treat me gently please!  I'd really like Larry Finger to reply if possible, 
since he seems to have done the most work on this.

What happens is I cannot connect to my wireless access point that has been 
setup using the following hostapd.conf:

interface=wlan1
driver=nl80211
ssid=EnvisicAccessPoint
hw_mode=g
channel=1
auth_algs=3
wpa=3
wpa_passphrase=GoofyPhrase
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=CCMP
macaddr_acl=0
ignore_broadcast_ssid=0
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
eapol_key_index_workaround=0

I already have isc-dhcp-server running in the background pointing to wlan1.  I 
launch hostapd using the following command:

hostapd -dd /etc/hostapd/hostapd.conf

I get a bunch of output to the console, and when I try to connect using my 
Windows 7 machine, it seems like it's trying to negotiate a connection, however 
it does not succeed and repeatedly gives me the following in the output log:

WPA:  00:1a:73:bb:f8:11 WPA_PTK entering state PTKSTART
wlan1:  STA 00:1a:73:bb:f8:11 WPA: sending 1/4 msg of 4-Way handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8...
wlan1: STA 00:1a:73:bb:f8:11 WPA:  EAPOL-Key timeout

Eventually it unauthorizes the port and deauthenticates it.  I'm not sure how 
to proceed so as to get a proper connection.  My BeagleBoard has the drivers 
stored at /lib/modules/3.1.6-x6/kernel/drivers/net/wireless/rtlwifi/rtl8192cu 
and the firmware stored at /lib/firmware/rtlwifi.

A dump of lsmod yields the following:
Module               Size  Used by
arc4                 1195  2
rtl8192cu           89347  0
rtl8192cu_common    62334  1 rtl8192cu
rtlwifi             71274  1 rtl8192cu
mac80211           259211  3 rtl8192cu,rtl8192c_common,rtlwifi
cfg80211           164606  2 rtlwifi,mac80211
rfkill              17026  1 cfg80211
smsc95xx            10950  0
usbhid              34524  0
gpio_keys            6801  0
rtc_ds1307           6350  0
rtc_twl              4402  0

Can you point me in the right direction?  I've burned many hours on this and 
would like to use this dongle for a 3D scanner we're building...

Thanks ahead of time!
Sincerely,
Gerhard J Norkus

