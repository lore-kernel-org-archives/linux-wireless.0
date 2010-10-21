Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57912 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0JUQAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 12:00:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1P8xYj-00047d-BU
	for linux-wireless@vger.kernel.org; Thu, 21 Oct 2010 18:00:06 +0200
Received: from user130.3eti.com ([65.220.88.130])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 18:00:05 +0200
Received: from clin by user130.3eti.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 18:00:05 +0200
To: linux-wireless@vger.kernel.org
From: Chaoxing <clin@3eti.com>
Subject: Help: Guidance on "AP/VLAN" mode
Date: Thu, 21 Oct 2010 15:54:30 +0000 (UTC)
Message-ID: <loom.20101021T172706-705@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1. Can any one here help me understand what mac80211 "AP/VLAN" mode is and how
it's used? I googled and could not find a good document on this. 

2. If it's meant for VLAN interface for multiple-SSID, how is the VLAN ID
configured?

3. In my AP with proprietary driver, there's multiple-SSID over the same BSSID.
(Meaning they share the same MAC address.) Each SSID is mapped to one VLAN.
Broadcasting SSID is disabled.
On receiving packet from clients, AP adds VLAN tag per SSID client associates.
On transmitting packet to clients, AP remove VLAN tag.
Is it possible to achieve the above functionality through existing open source
software(mac80211, iw, hostapd, radio driver, etc)?

Thanks in advance.


The following is my experiment on AP/VLAN interface.


On "iw list" command, my system shows that it supports AP/VLAN type interface

=========iw list screen shot, (part) begin ============================

        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * mesh point
========iw list screen shot, (part) end =========================

And it does allow me to add such kind of interface by command "iw phy phy0
interface add vlan2 type __ap_vlan"

===========================screen shot begin =============================
root@mini-dell:~/hostapd-conf# iw phy phy0 interface add vlan2 type __ap_vlan
root@mini-dell:~/hostapd-conf# iw vlan2 info
Interface vlan2
        ifindex 10
        type AP/VLAN
root@mini-dell:~/hostapd-conf# iwconfig vlan2
vlan2     IEEE 802.11abgn  Mode:Secondary  Tx-Power=17 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
===========================screen shot ends =============================

Now, how do I use this vlan interface "vlan2"? I tried to run hostapd over vlan2
interface with no success. Here is my hostapd.conf and screenshot.


===========================screen shot begin =============================
root@mini-dell:~/hostapd-conf# hostapd -dd hostapd.conf
Configuration file: hostapd.conf
ctrl_interface_group=0
nl80211: Register Action command failed: ret=-95 (Operation not supported)
nl80211: Register Action match - hexdump(len=1): 06
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Add own interface ifindex 10
nl80211: Failed to set interface 10 to mode 3: -95 (Operation not supported)
nl80211: Failed to set interface 10 to mode 3: -95 (Operation not supported)
Could not set interface vlan2 flags: Link has been severed
nl80211: Interface mode change to 3 from 0 failed
nl80211: Failed to set interface vlan2 into AP mode
nl80211 driver initialization failed.
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=4 eloop_data=0x80a7870 user_data=0x80a94f8
handler=0x8072070
ELOOP: remaining socket: sock=6 eloop_data=0x80aaf38 user_data=(nil)
handler=0x807ab20
root@mini-dell:~/hostapd-conf#
===========================screen shot ends =============================


------------------hostapd.conf begin ------------------
interface=vlan2
#bridge=brg0
driver=nl80211
logger_syslog=-1
logger_syslog_level=0
logger_stdout=-1
logger_stdout_level=0
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0

##### IEEE 802.11 related configuration #######################################
ssid=bypass
country_code=US
ieee80211d=1
hw_mode=a
channel=36
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
------------------hostapd.conf end------------------


