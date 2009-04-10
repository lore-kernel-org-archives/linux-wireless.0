Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:45577 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbZDJTaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 15:30:18 -0400
Message-ID: <49DF9E38.5030801@lwfinger.net> (sfid-20090410_213025_132293_FCD7A766)
Date: Fri, 10 Apr 2009 14:30:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Michael Buesch <mb@bu3sch.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43legacy AP
References: <30353c3d0904100736g69782d46g18d99edd0dd0660d@mail.gmail.com>
In-Reply-To: <30353c3d0904100736g69782d46g18d99edd0dd0660d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Ellingsworth wrote:
> I'd like to try and get b43legacy running in AP mode this weekend. Can
> anyone tell me what modifications to b43legacy need to be made in
> order to do so? The last time I tried, I applied the two patches by
> Larry to address beaconing issues in b43legacy without much success.
> My tests indicated that hostapd seemed capable of communicating with
> b43legacy and my 4306 rev 2 through nl80211 but that the card was
> still not producing any beacons when monitored remotely. The only sign
> of failure from hostapd is the repeated message of "MGMT (TX callback)
> fail" whenever hostapd received a probe for the ssid it configured the
> interface for. This isn't much information to go on but it points us
> in a direction to where the problem(s) may exist. Again, any help
> would be appreciated.

There may be problems that are unique to your 4306 rev 2, but b43legacy with my
patches runs as an AP just fine.

My configuration is as follows:

LAN ======= eth0 -- BCM4312/1 as AP ~~~~~~~~~~~~~~ laptop with BCM4318.

As my BCM4312/1 uses ucode5 firmware, I only have to change the ssb_tbl entries
to have it use either b43 or b43legacy.

I started with b43 driving the AP. I use hostapd v0.6.8 as the basis for the AP
and the current wireless-testing as my kernel.  My hostapd.conf contains the
following:

==================================================
interface=wlan0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
debug=0
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
hw_mode=g
channel=11
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
ignore_broadcast_ssid=0
wme_enabled=1
wme_ac_bk_cwmin=4
wme_ac_bk_cwmax=10
wme_ac_bk_aifs=7
wme_ac_bk_txop_limit=0
wme_ac_bk_acm=0
wme_ac_be_aifs=3
wme_ac_be_cwmin=4
wme_ac_be_cwmax=10
wme_ac_be_txop_limit=0
wme_ac_be_acm=0
wme_ac_vi_aifs=2
wme_ac_vi_cwmin=3
wme_ac_vi_cwmax=4
wme_ac_vi_txop_limit=94
wme_ac_vi_acm=0
wme_ac_vo_aifs=2
wme_ac_vo_cwmin=2
wme_ac_vo_cwmax=3
wme_ac_vo_txop_limit=47
wme_ac_vo_acm=0
eapol_key_index_workaround=0
eap_server=0
own_ip_addr=127.0.0.1
wpa=1
wpa_passphrase=123456789
==================================================

I created a file dhcpd.conf, which contains

==================================================
option domain-name-servers 192.168.1.1;
default-lease-time 600;
max-lease-time 7200;
ddns-update-style none; ddns-updates off;
subnet 192.168.0.0 netmask 255.255.255.0 {
        range 192.168.0.200 192.168.0.229;
        option subnet-mask 255.255.255.0;
        option broadcast-address 192.168.0.255;
        option routers 192.168.0.1;
}
==================================================

My script to control the AP is as follows:

==================================================
#!/bin/sh
# Script to start/stop a hostapd-based access point
#
# Symbols for needed programs

IPTABLES=/usr/sbin/iptables
IFCONFIG=/sbin/ifconfig
DHCPD=/usr/sbin/dhcpd
HOSTAPD=/usr/local/bin/hostapd

# Symbols for internal and external interfaces

NET_INT=wlan0
NET_EXT=eth0

# IP address for the AP

INT_ADDR=192.168.0.1

case "$1" in
start)
        echo "Starting AP mode for $NET_INT at address $INT_ADDR"

        # Disable packet forwarding

        echo 0 > /proc/sys/net/ipv4/ip_forward

        # Stop hostapd and dhcpd daemons

        killproc hostapd
        killproc dhcpd

        #Set up forwarding

        $IPTABLES -t nat -A POSTROUTING -o $NET_EXT -j MASQUERADE
        $IPTABLES -A FORWARD -i $NET_EXT -o $NET_INT -m state \
		--state RELATED,ESTABLISHED -j ACCEPT
        $IPTABLES -A FORWARD -i $NET_INT -o $NET_EXT -j ACCEPT

        # Enable packet forwarding

        echo 1 > /proc/sys/net/ipv4/ip_forward

        # Get the internal interface in the right state

        $IFCONFIG $NET_INT down
        $IFCONFIG $NET_INT up
        $IFCONFIG $NET_INT $INT_ADDR

        # dhcpd needs to have a leases file available - create it if needed

        if [ ! -f /var/lib/dhcp/db/dhcpd.leases ]; then
                touch /var/lib/dhcp/db/dhcpd.leases
        fi

        # Bring up the DHCP server

        $DHCPD -cf /root/dhcpd.conf $NET_INT

        # Bring up hostapd

        $HOSTAPD -B /root/hostapd.conf
        ;;
stop)
        echo "Stopping AP mode on $NET_INT"

        # Stop hostapd and dhcpd daemons
        killproc hostapd
        killproc dhcpd
        ;;
*)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
===============================================

The first thing I found when using b43 as the AP host was that many hundreds of
"PHY transmission errors" were generated every second. I got rid of those be
eliminating the code that reports the error in drivers/net/wireless/b43/main.c.
I also made the same change to b43legacy.

Testing was done with a separate laptop that has a PCMCIA format BCM4318. The
link was kept busy using a 10-second TX test from the utility tcpperf. The
server for tcpperf is connected to my hub via a 100 Mb wired connection. The
base rate for the test is 13-14 Mb/s through my Linksys AP. Using b43 as the AP,
the rate was a little lower with a maximum rate of 12-13 Mb/s. The client's
connection is at 54 Mb/s.

After verifying that my setup would work with b43, I switched to b43legacy.
There was no difference in stability or performance. After eliminating the PHY
transmission error messages, the only thing logged on the AP host were the
10-minute DCHP renewals.

Larry
