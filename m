Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36756 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbcCCDwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 22:52:51 -0500
Message-ID: <56D7B511.3040406@candelatech.com> (sfid-20160303_045254_298896_7F2996D5)
Date: Wed, 02 Mar 2016 19:52:49 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Bug report for ath10k and scanning many ssids.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a bug in at least 10.1 ath10k firmware where the scan machine
cannot send more than 5 or so probe requests due to running out of firmware
management buffers..  Stock firmware is not smart enough to
wait a bit and send them later.  To reproduce, use a supplicant file like
this (below).  Maybe there is a way to work around it in the driver, but probably
better to just fix the firmware...  A quick glance at 10.4 firmware makes
me think the bug is very likely there as well.

Thanks,
Ben


ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
eapol_version=1
ap_scan=1
country=US
autoscan=periodic:10

network={
ssid="nonexist1"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="nonexist2"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="nonexist3"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="nonexist4"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="nonexist5"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="nonexist6"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="nonexist7"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="nonexist8"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="nonexist9"
scan_ssid=1
key_mgmt=NONE
}

network={
ssid="dd-wrt-ath1"
scan_ssid=1
key_mgmt=NONE
}


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
