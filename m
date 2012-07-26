Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53528 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GZL2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 07:28:30 -0400
Received: by ghrr11 with SMTP id r11so1822681ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 04:28:29 -0700 (PDT)
Message-ID: <501129D9.4060407@lwfinger.net> (sfid-20120726_132834_515472_6EDC28A3)
Date: Thu, 26 Jul 2012 06:28:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com>
In-Reply-To: <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com>
Content-Type: multipart/mixed;
 boundary="------------040005080404020609040102"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040005080404020609040102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/26/2012 06:01 AM, Xavier de Almeida wrote:
> Cool let's get this sorted then.
>
> Here is the output now with the 3.4.6 kernel. If you prefer me to try with the 3.5, I can.
>
> thanks
>
> uname -r
> 3.4.6-custom
>
> ifconfig
>
> br0       Link encap:Ethernet  HWaddr 80:ee:73:31:54:b2
>            inet addr:192.168.0.40  Bcast:192.168.0.255  Mask:255.255.255.0
>            inet6 addr: fe80::82ee:73ff:fe31:54b2/64 Scope:Link
>            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>            RX packets:426 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:548 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:0
>            RX bytes:30369 (30.3 KB)  TX bytes:79172 (79.1 KB)
>
> eth0      Link encap:Ethernet  HWaddr 80:ee:73:31:54:b2
>            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>            RX packets:510 errors:0 dropped:4 overruns:0 frame:0
>            TX packets:546 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:54044 (54.0 KB)  TX bytes:79000 (79.0 KB)
>            Interrupt:45
>
> lo        Link encap:Local Loopback
>            inet addr:127.0.0.1  Mask:255.0.0.0
>            inet6 addr: ::1/128 Scope:Host
>            UP LOOPBACK RUNNING  MTU:16436  Metric:1
>            RX packets:968 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:968 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:0
>            RX bytes:72060 (72.0 KB)  TX bytes:72060 (72.0 KB)
>
> iwconfig
> br0       no wireless extensions.
>
> wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.437 GHz  Tx-Power=20 dBm
>            Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
>            Power Management:on
>
> lo        no wireless extensions.
>
> eth0      no wireless extensions.
>
> sudo modinfo rtl8192ce
> filename:       /lib/modules/3.4.6-custom/kernel/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko
> firmware:       rtlwifi/rtl8192cfwU_B.bin
> firmware:       rtlwifi/rtl8192cfwU.bin
> firmware:       rtlwifi/rtl8192cfw.bin
> description:    Realtek 8192C/8188C 802.11n PCI wireless
> license:        GPL
> author:         Larry Finger    <Larry.Finger@lwfinger.net>
> author:         Realtek WlanFAE <wlanfae@realtek.com>
> author:         lizhaoming      <chaoming_li@realsil.com.cn>
> srcversion:     AE758D5E662358264A4DB35
> alias:          pci:v000010ECd00008176sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008177sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008178sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008191sv*sd*bc*sc*i*
> depends:        rtlwifi,rtl8192c-common,mac80211
> intree:         Y
> vermagic:       3.4.6-custom SMP mod_unload modversions 686
> parm:           swenc:Set to 1 for software crypto (default 0)
> parm:           ips:Set to 0 to not use link power save (default 1)
>
> parm:           swlps:Set to 1 to use SW control power save (default 0)
>
> parm:           fwlps:Set to 1 to use FW control power save (default 1)
>
> parm:           debug:Set debug level (0-5) (default 0) (int)
>
>
>
> sudo hostapd -dd /etc/hostapd/hostapd.conf
> Configuration file: /etc/hostapd/hostapd.conf
>
> nl80211: Register Action command failed: ret=-114 (Operation already in progress)
> nl80211: Register Action match - hexdump(len=1): 06
> nl80211: Failed to register Action frame processing - ignore for now
> nl80211: Interface wlan0 is in bridge br0
> nl80211: Add own interface ifindex 3
> nl80211: Add own interface ifindex 4
> Failed to create interface mon.wlan0: -23 (Too many open files in system)
> Try to remove and re-create mon.wlan0
> nl80211: Remove interface ifindex=5
> nl80211: New interface mon.wlan0 created: ifindex=6
> nl80211: Add own interface ifindex 6
> Could not set interface mon.wlan0 flags: Success
> nl80211: Remove interface ifindex=6
> nl80211: Failed to set interface wlan0 into AP mode
> nl80211 driver initialization failed.
> ELOOP: remaining socket: sock=4 eloop_data=0x8423900 user_data=0x8423eb0 handler=0x807c5e0
> ELOOP: remaining socket: sock=6 eloop_data=0x8425cb8 user_data=(nil) handler=0x8086770

I'm not sure why you are getting that error -23 (too many open files). Is that 
number set artificially low for some reason? What does

cat /proc/sys/fs/file-max

report? On my system, it is 300000.

Attached is a script file that I use to start an AP on my system. Please try it 
and see if it works differently. You mnay have to adjust the symbols for 
different locations of hostapd, etc, and the address of the wireless network 
that is currently set at 192.168.0.X. The script is run with

sudo ./control_ap start <name_of_wireless_iface> <name_of_external_iface>

or

sudo ./control_ap stop

For a normal configuration, the command would be "control_ap start wlan0 eth0".

In addition, one of the attachments in 
https://bugzilla.redhat.com/show_bug.cgi?id=797709 is a hostapd configuration 
file that works. You might compare it with yours.

Larry


--------------040005080404020609040102
Content-Type: text/plain; charset=UTF-8;
 name="control_ap"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="control_ap"

#!/bin/sh
# Script to start/stop a hostapd-based access point
#
# Sample start call "control_ap start wlan0 eth0"
# Stop with "control_ap stop"
#

case "$1" in
start)
	if [ $# -ne 3 ]
	then
	  echo "Usage: $0 start AP_iface NET_iface"
	  exit 1
	fi
;;
stop)
	if [ $# -ne 1 ]
	then
	  echo "Usage: $0 stop"
	  exit 1
	fi
;;
*)
        echo "Usage:"
	echo "$0 start AP-iface net_iface"
	echo "or"
	echo "$0 stop"
        exit 1
        ;;
esac

# Symbols for needed programs

IPTABLES=/usr/sbin/iptables
IFCONFIG=/sbin/ifconfig
DHCPD=/usr/sbin/dhcpd
HOSTAPD=/usr/sbin/hostapd

# Symbols for AP and external interfaces

NET_AP=$2
NET_EXT=$3

# First 3 octets of IP address for the AP

AP_ADDR=192.168.0

# IP address for nameserver

NAME_SERVER=8.8.8.8

# AP Channel, SSID, Encryption method,  and Encryption secret

AP_CHANNEL=11
AP_SSID=RTL8192SE
WPA_SECRET="\"s!will@be#hard$to%crack^\""
ENCRYPT_MODE=2

case "$1" in
start)
        echo "Starting AP mode for $NET_AP at address $AP_ADDR.1"
        # Disable packet forwarding
        echo 0 > /proc/sys/net/ipv4/ip_forward
        # Stop any existing hostapd and dhcpd daemons
        killproc hostapd
        killproc dhcpd
        #Set up forwarding
        $IPTABLES -t nat -A POSTROUTING -o $NET_EXT -j MASQUERADE
        $IPTABLES -A FORWARD -i $NET_EXT -o $NET_AP -m state \
		--state RELATED,ESTABLISHED -j ACCEPT
        $IPTABLES -A FORWARD -i $NET_AP -o $NET_EXT -j ACCEPT
        # Enable packet forwarding
        echo 1 > /proc/sys/net/ipv4/ip_forward
        # Get the AP interface in the right state
        $IFCONFIG $NET_AP down
        $IFCONFIG $NET_AP up
        $IFCONFIG $NET_AP $AP_ADDR.1
        # dhcpd needs to have a leases file available - create it if needed
        if [ ! -f /var/lib/dhcp/db/dhcpd.leases ]; then
                touch /var/lib/dhcp/db/dhcpd.leases
        fi
	# Write the DHCP server configuration file
	echo "option domain-name-servers $NAME_SERVER;" > ~/dhcpd.conf
	echo "default-lease-time 600;" >> ~/dhcpd.conf
	echo "max-lease-time 7200;" >> ~/dhcpd.conf
	echo "ddns-update-style none; ddns-updates off;" >> ~/dhcpd.conf
	echo "subnet $AP_ADDR.0 netmask 255.255.255.0 {" >> ~/dhcpd.conf
	echo "        range $AP_ADDR.200 $AP_ADDR.229;" >> ~/dhcpd.conf
	echo "        option subnet-mask 255.255.255.0;" >> ~/dhcpd.conf
	echo "        option broadcast-address $AP_ADDR.255;" >> ~/dhcpd.conf
	echo "        option routers $AP_ADDR.1;" >> ~/dhcpd.conf
	echo "}" >> ~/dhcpd.conf
        # Bring up the DHCP server
        $DHCPD -cf ~/dhcpd.conf $NET_AP
	# Write the hostapd configuration file
	cat > ~/hostapd.conf << EOF
auth_algs=1
beacon_int=100
#bridge=br0
country_code=US
ctrl_interface_group=0
ctrl_interface=/var/run/hostapd
dtim_period=2
dump_file=/tmp/hostapd.dump
fragm_threshold=2346
ht_capab=[HT40-][SHORT-GI-20][SHORT-GI-40][MAX-AMSDU-7935][DSSS_CCK-40]
ieee80211d=1
ieee80211n=1
ignore_broadcast_ssid=0
logger_stdout=-1
logger_stdout_level=2
logger_syslog=-1
logger_syslog_level=2
macaddr_acl=0
max_num_sta=255
rts_threshold=2347
wmm_ac_be_acm=0
wmm_ac_be_aifs=3
wmm_ac_be_cwmax=10
wmm_ac_be_cwmin=4
wmm_ac_be_txop_limit=0
wmm_ac_bk_acm=0
wmm_ac_bk_aifs=7
wmm_ac_bk_cwmax=10
wmm_ac_bk_cwmin=4
wmm_ac_bk_txop_limit=0
wmm_ac_vi_acm=0
wmm_ac_vi_aifs=2
wmm_ac_vi_cwmax=4
wmm_ac_vi_cwmin=3
wmm_ac_vi_txop_limit=94
wmm_ac_vo_acm=0
wmm_ac_vo_aifs=2
wmm_ac_vo_cwmax=3
wmm_ac_vo_cwmin=2
wmm_ac_vo_txop_limit=47
wmm_enabled=1
EOF
	echo "interface=$NET_AP" >> ~/hostapd.conf
	echo "ssid=$AP_SSID" >> ~/hostapd.conf 
	echo "driver=nl80211" >> ~/hostapd.conf 
	echo "hw_mode=g" >> ~/hostapd.conf 
	echo "channel=$AP_CHANNEL" >> ~/hostapd.conf 
	echo "wpa=$ENCRYPT_MODE" >> ~/hostapd.conf 
	echo "wpa_key_mgmt=WPA-PSK" >> ~/hostapd.conf 
	echo "wpa_pairwise=TKIP CCMP" >> ~/hostapd.conf 
	echo "rsn_pairwise=CCMP" >> ~/hostapd.conf
	echo "wpa_passphrase=$WPA_SECRET" >> ~/hostapd.conf 
        # Bring up hostapd
        $HOSTAPD -B ~/hostapd.conf
        ;;
stop)
        echo "Stopping AP mode"
        # Stop hostapd and dhcpd daemons
        killproc hostapd
        killproc dhcpd
	rm -f ~/hostapd.conf
	rm -f ~/dhcpd.conf
        ;;
esac


--------------040005080404020609040102--
