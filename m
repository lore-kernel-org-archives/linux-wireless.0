Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58658 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZLUApa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 19:45:30 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NMWOr-0001Tj-L6
	for linux-wireless@vger.kernel.org; Mon, 21 Dec 2009 01:45:25 +0100
Received: from p4FF0D2AC.dip.t-dialin.net ([79.240.210.172])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 01:45:25 +0100
Received: from Markus_Baier by p4FF0D2AC.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 01:45:25 +0100
To: linux-wireless@vger.kernel.org
From: Markus Baier <Markus_Baier@web.de>
Subject: Re: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom for alignment operations.
Date: Mon, 21 Dec 2009 00:45:02 +0000 (UTC)
Message-ID: <loom.20091221T011150-33@post.gmane.org>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com> <1259012694-14869-2-git-send-email-gwingerde@gmail.com> <1259012694-14869-3-git-send-email-gwingerde@gmail.com> <1259012694-14869-4-git-send-email-gwingerde@gmail.com> <1259012694-14869-5-git-send-email-gwingerde@gmail.com> <1259012694-14869-6-git-send-email-gwingerde@gmail.com> <1259012694-14869-7-git-send-email-gwingerde@gmail.com> <1259012694-14869-8-git-send-email-gwingerde@gmail.com> <1259012694-14869-9-git-send-email-gwingerde@gmail.com> <loom.20091220T163829-137@post.gmane.org> <4B2E8729.7050501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde <gwingerde@...> writes:

> What kind of rt2x00 device are you using (and which of the rt2x00 drivers)?

The device is a PCMICA card with the RT2561 chipset.
The driver is the rt61pci driver.

>>lsmod
Module                  Size  Used by
rt61pci                18193  0
crc_itu_t               1017  1 rt61pci
rt2x00pci               4189  1 rt61pci
rt2x00lib              22940  2 rt61pci,rt2x00pci
eeprom_93cx6             960  1 rt61pci


> Are there any messages in dmesg when this happens?

No, there are no messages in dmesg


There are no differences in the dmesg output between
the working and the broken kernel
Here is the dmesg output:

rt61pci 0000:02:00.0: enabling device (0000 -> 0002)
rt61pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
rt61pci 0000:02:00.0: setting latency timer to 64
phy0 -> rt61pci_validate_eeprom: EEPROM recovery - NIC: 0xff80
phy0 -> rt61pci_validate_eeprom: EEPROM recovery - Led: 0xe0ff
phy0 -> rt2x00_print_chip: Info - Chipset detected - rt: 0302, rf: 0003, rev:
0002561c.
phy0: Selected rate control algorithm 'minstrel'
Registered led device: rt61pci-phy0::radio
Registered led device: rt61pci-phy0::assoc
phy0 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt2561.bin'.
rt61pci 0000:02:00.0: firmware: requesting rt2561.bin
phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.8.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4,
Aifs: 2, TXop: 102.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5,
Aifs: 2, TXop: 188.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10,
Aifs: 3, TXop: 0.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10,
Aifs: 7, TXop: 0.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4,
Aifs: 2, TXop: 102.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5,
Aifs: 2, TXop: 188.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10,
Aifs: 3, TXop: 0.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10,
Aifs: 7, TXop: 0.
cfg80211: Calling CRDA for country: DE
cfg80211: Regulatory domain changed to country: DE
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
device wlan0 entered promiscuous mode
br0: port 2(wlan0) entering learning state
br0: port 1(eth0) entering forwarding state
br0: port 2(wlan0) entering forwarding state


------------------------------------------------------------------------
But there are differences in the hostapd log.
Here is the log output from the broken system:

>>hostapd -tddd /etc/hostapd/wpa2_ap.conf
....
1261351288.111499: MGMT (TX callback) fail
1261351288.111513: mgmt::proberesp cb
1261351290.256576: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261351290.257122: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261351290.257735: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261351290.258351: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261351290.258971: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261351290.268092: MGMT (TX callback) fail
1261351290.268116: mgmt::proberesp cb
1261351290.277054: MGMT (TX callback) fail
1261351290.277074: mgmt::proberesp cb
1261351290.285832: MGMT (TX callback) fail
1261351290.285848: mgmt::proberesp cb
1261351290.294522: MGMT (TX callback) fail
1261351290.294538: mgmt::proberesp cb
1261351290.303364: MGMT (TX callback) fail
1261351290.303379: mgmt::proberesp cb
1261351291.334698: MGMT
1261351291.334719: mgmt::auth
1261351291.334727: authentication: STA=xx:xx:xx:xx:xx:xx auth_alg=0
auth_transaction=1 status_code=0 wep=0
1261351291.334769: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authentication OK
(open system)
1261351291.334795: wlan0: STA xx:xx:xx:xx:xx:xx MLME:
MLME-AUTHENTICATE.indication(xx:xx:xx:xx:xx:xx, OPEN_SYSTEM)
1261351291.334817: wlan0: STA xx:xx:xx:xx:xx:xx MLME:
MLME-DELETEKEYS.request(xx:xx:xx:xx:xx:xx)
1261351291.334830: authentication reply: STA=xx:xx:xx:xx:xx:xx auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
1261351291.339781: MGMT (TX callback) fail
1261351291.339794: mgmt::auth cb
1261351291.339813: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: did not
acknowledge authentication response
....

------------------------------------------------------------------------
Here the log output from the working system:

>>hostapd -tddd /etc/hostapd/wpa2_ap.conf
....
1261353953.151469: MGMT (TX callback) ACK
1261353956.790339: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261353956.790871: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261353956.791481: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261353956.792098: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261353956.792717: STA xx:xx:xx:xx:xx:xx sent probe request for our SSID
1261353956.794326: MGMT (TX callback) ACK
1261353956.794339: mgmt::proberesp cb
1261353956.795806: MGMT (TX callback) ACK
1261353956.795827: mgmt::proberesp cb
1261353956.797184: MGMT (TX callback) ACK
1261353956.797195: mgmt::proberesp cb
1261353956.798558: MGMT (TX callback) ACK
1261353956.798569: mgmt::proberesp cb
1261353956.799907: MGMT (TX callback) ACK
1261353956.799918: mgmt::proberesp cb
1261353957.868214: MGMT
1261353957.868236: mgmt::auth
1261353957.868245: authentication: STA=xx:xx:xx:xx:xx:xx auth_alg=0
auth_transaction=1 status_code=0 wep=0
1261353957.868266:   New STA
1261353957.868313: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authentication OK
(open system)
1261353957.868344: wlan0: STA xx:xx:xx:xx:xx:xx MLME:
MLME-AUTHENTICATE.indication(xx:xx:xx:xx:xx:xx, OPEN_SYSTEM)
1261353957.868366: wlan0: STA xx:xx:xx:xx:xx:xx MLME:
MLME-DELETEKEYS.request(xx:xx:xx:xx:xx:xx)
1261353957.868385: authentication reply: STA=xx:xx:xx:xx:xx:xx auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
1261353957.869332: MGMT (TX callback) ACK
1261353957.869347: mgmt::auth cb
1261353957.869368: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authenticated
....

Please tell me if some information are missing.


Regards,
Markus

