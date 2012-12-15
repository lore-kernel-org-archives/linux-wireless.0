Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33498 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2LOG5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 01:57:12 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so1604178eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 22:57:11 -0800 (PST)
Message-ID: <50CC1F45.8050508@googlemail.com> (sfid-20121215_075722_174397_22CB3E78)
Date: Sat, 15 Dec 2012 07:57:09 +0100
From: Tamer Higazi <th982a@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Could not set interface mon.wlan1
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to get hostapd with my Atheros Wlan USB Stick to run
(zd1211rw) on Gentoo Linux to run and I am not getting further.

Now I really don't know if it's the USB stick, the driver or the hostapd itself that makes me troubles. 

I am running Gentoo x64 bit with the kernel 3.3.8. 

If somebody knows the answer, I would kindly thank him/her.


output of "sudo hostapd -dd /etc/hostapd/hostapd.conf":

random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
nl80211: interface wlan1 in phy phy0
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
nl80211: Using driver-based off-channel TX
nl80211: Add own interface ifindex 5
nl80211: Set mode ifindex 5 iftype 3 (AP)
nl80211: Create interface iftype 6 (MONITOR)
nl80211: New interface mon.wlan1 created: ifindex=9
nl80211: Add own interface ifindex 9
Could not set interface mon.wlan1 flags: No such file or directory
nl80211: Remove interface ifindex=9
nl80211: Failed to set interface wlan1 into AP mode
netlink: Operstate: linkmode=0, operstate=6
nl80211: Set mode ifindex 5 iftype 2 (STATION)
nl80211 driver initialization failed.
rmdir[ctrl_interface]: No such file or directory


my hostapd.conf:


interface=wlan1
driver=nl80211

logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=Tux
macaddr_acl=0
auth_algs=3
eap_server=0
eap_message=hello
eapol_key_index_workaround=0
own_ip_addr=127.0.0.1
wpa=3
ieee8021x=0
wpa_passphrase=secretpassword
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP TKIP
hw_mode=g
channel=8

