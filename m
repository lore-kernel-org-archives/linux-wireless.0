Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:23195 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbZDJUtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 16:49:46 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1274976ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2009 13:49:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DF9E38.5030801@lwfinger.net>
References: <30353c3d0904100736g69782d46g18d99edd0dd0660d@mail.gmail.com>
	 <49DF9E38.5030801@lwfinger.net>
Date: Fri, 10 Apr 2009 16:49:39 -0400
Message-ID: <30353c3d0904101349o915439arffb652b98e245e10@mail.gmail.com> (sfid-20090410_224950_916972_55F7D667)
Subject: Re: b43legacy AP
From: David Ellingsworth <david@identd.dyndns.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 10, 2009 at 3:30 PM, Larry Finger <Larry.Finger@lwfinger.ne=
t> wrote:
> David Ellingsworth wrote:
>> I'd like to try and get b43legacy running in AP mode this weekend. C=
an
>> anyone tell me what modifications to b43legacy need to be made in
>> order to do so? The last time I tried, I applied the two patches by
>> Larry to address beaconing issues in b43legacy without much success.
>> My tests indicated that hostapd seemed capable of communicating with
>> b43legacy and my 4306 rev 2 through nl80211 but that the card was
>> still not producing any beacons when monitored remotely. The only si=
gn
>> of failure from hostapd is the repeated message of "MGMT (TX callbac=
k)
>> fail" whenever hostapd received a probe for the ssid it configured t=
he
>> interface for. This isn't much information to go on but it points us
>> in a direction to where the problem(s) may exist. Again, any help
>> would be appreciated.
>
> There may be problems that are unique to your 4306 rev 2, but b43lega=
cy with my
> patches runs as an AP just fine.
>
> My configuration is as follows:
>
> LAN =3D=3D=3D=3D=3D=3D=3D eth0 -- BCM4312/1 as AP ~~~~~~~~~~~~~~ lapt=
op with BCM4318.
>
> As my BCM4312/1 uses ucode5 firmware, I only have to change the ssb_t=
bl entries
> to have it use either b43 or b43legacy.
>
> I started with b43 driving the AP. I use hostapd v0.6.8 as the basis =
for the AP
> and the current wireless-testing as my kernel. =A0My hostapd.conf con=
tains the
> following:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> interface=3Dwlan0
> driver=3Dnl80211
> logger_syslog=3D-1
> logger_syslog_level=3D2
> logger_stdout=3D-1
> logger_stdout_level=3D2
> debug=3D0
> dump_file=3D/tmp/hostapd.dump
> ctrl_interface=3D/var/run/hostapd
> ctrl_interface_group=3D0
> hw_mode=3Dg
> channel=3D11
> beacon_int=3D100
> dtim_period=3D2
> max_num_sta=3D255
> rts_threshold=3D2347
> fragm_threshold=3D2346
> macaddr_acl=3D0
> ignore_broadcast_ssid=3D0
> wme_enabled=3D1
> wme_ac_bk_cwmin=3D4
> wme_ac_bk_cwmax=3D10
> wme_ac_bk_aifs=3D7
> wme_ac_bk_txop_limit=3D0
> wme_ac_bk_acm=3D0
> wme_ac_be_aifs=3D3
> wme_ac_be_cwmin=3D4
> wme_ac_be_cwmax=3D10
> wme_ac_be_txop_limit=3D0
> wme_ac_be_acm=3D0
> wme_ac_vi_aifs=3D2
> wme_ac_vi_cwmin=3D3
> wme_ac_vi_cwmax=3D4
> wme_ac_vi_txop_limit=3D94
> wme_ac_vi_acm=3D0
> wme_ac_vo_aifs=3D2
> wme_ac_vo_cwmin=3D2
> wme_ac_vo_cwmax=3D3
> wme_ac_vo_txop_limit=3D47
> wme_ac_vo_acm=3D0
> eapol_key_index_workaround=3D0
> eap_server=3D0
> own_ip_addr=3D127.0.0.1
> wpa=3D1
> wpa_passphrase=3D123456789
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
> I created a file dhcpd.conf, which contains
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> option domain-name-servers 192.168.1.1;
> default-lease-time 600;
> max-lease-time 7200;
> ddns-update-style none; ddns-updates off;
> subnet 192.168.0.0 netmask 255.255.255.0 {
> =A0 =A0 =A0 =A0range 192.168.0.200 192.168.0.229;
> =A0 =A0 =A0 =A0option subnet-mask 255.255.255.0;
> =A0 =A0 =A0 =A0option broadcast-address 192.168.0.255;
> =A0 =A0 =A0 =A0option routers 192.168.0.1;
> }
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
> My script to control the AP is as follows:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> #!/bin/sh
> # Script to start/stop a hostapd-based access point
> #
> # Symbols for needed programs
>
> IPTABLES=3D/usr/sbin/iptables
> IFCONFIG=3D/sbin/ifconfig
> DHCPD=3D/usr/sbin/dhcpd
> HOSTAPD=3D/usr/local/bin/hostapd
>
> # Symbols for internal and external interfaces
>
> NET_INT=3Dwlan0
> NET_EXT=3Deth0
>
> # IP address for the AP
>
> INT_ADDR=3D192.168.0.1
>
> case "$1" in
> start)
> =A0 =A0 =A0 =A0echo "Starting AP mode for $NET_INT at address $INT_AD=
DR"
>
> =A0 =A0 =A0 =A0# Disable packet forwarding
>
> =A0 =A0 =A0 =A0echo 0 > /proc/sys/net/ipv4/ip_forward
>
> =A0 =A0 =A0 =A0# Stop hostapd and dhcpd daemons
>
> =A0 =A0 =A0 =A0killproc hostapd
> =A0 =A0 =A0 =A0killproc dhcpd
>
> =A0 =A0 =A0 =A0#Set up forwarding
>
> =A0 =A0 =A0 =A0$IPTABLES -t nat -A POSTROUTING -o $NET_EXT -j MASQUER=
ADE
> =A0 =A0 =A0 =A0$IPTABLES -A FORWARD -i $NET_EXT -o $NET_INT -m state =
\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0--state RELATED,ESTABLISHED -j ACCEPT
> =A0 =A0 =A0 =A0$IPTABLES -A FORWARD -i $NET_INT -o $NET_EXT -j ACCEPT
>
> =A0 =A0 =A0 =A0# Enable packet forwarding
>
> =A0 =A0 =A0 =A0echo 1 > /proc/sys/net/ipv4/ip_forward
>
> =A0 =A0 =A0 =A0# Get the internal interface in the right state
>
> =A0 =A0 =A0 =A0$IFCONFIG $NET_INT down
> =A0 =A0 =A0 =A0$IFCONFIG $NET_INT up
> =A0 =A0 =A0 =A0$IFCONFIG $NET_INT $INT_ADDR
>
> =A0 =A0 =A0 =A0# dhcpd needs to have a leases file available - create=
 it if needed
>
> =A0 =A0 =A0 =A0if [ ! -f /var/lib/dhcp/db/dhcpd.leases ]; then
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0touch /var/lib/dhcp/db/dhcpd.leases
> =A0 =A0 =A0 =A0fi
>
> =A0 =A0 =A0 =A0# Bring up the DHCP server
>
> =A0 =A0 =A0 =A0$DHCPD -cf /root/dhcpd.conf $NET_INT
>
> =A0 =A0 =A0 =A0# Bring up hostapd
>
> =A0 =A0 =A0 =A0$HOSTAPD -B /root/hostapd.conf
> =A0 =A0 =A0 =A0;;
> stop)
> =A0 =A0 =A0 =A0echo "Stopping AP mode on $NET_INT"
>
> =A0 =A0 =A0 =A0# Stop hostapd and dhcpd daemons
> =A0 =A0 =A0 =A0killproc hostapd
> =A0 =A0 =A0 =A0killproc dhcpd
> =A0 =A0 =A0 =A0;;
> *)
> =A0 =A0 =A0 =A0echo "Usage: $0 {start|stop}"
> =A0 =A0 =A0 =A0exit 1
> =A0 =A0 =A0 =A0;;
> esac
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The first thing I found when using b43 as the AP host was that many h=
undreds of
> "PHY transmission errors" were generated every second. I got rid of t=
hose be
> eliminating the code that reports the error in drivers/net/wireless/b=
43/main.c.
> I also made the same change to b43legacy.
>
> Testing was done with a separate laptop that has a PCMCIA format BCM4=
318. The
> link was kept busy using a 10-second TX test from the utility tcpperf=
=2E The
> server for tcpperf is connected to my hub via a 100 Mb wired connecti=
on. The
> base rate for the test is 13-14 Mb/s through my Linksys AP. Using b43=
 as the AP,
> the rate was a little lower with a maximum rate of 12-13 Mb/s. The cl=
ient's
> connection is at 54 Mb/s.
>
> After verifying that my setup would work with b43, I switched to b43l=
egacy.
> There was no difference in stability or performance. After eliminatin=
g the PHY
> transmission error messages, the only thing logged on the AP host wer=
e the
> 10-minute DCHP renewals.
>
> Larry
>

Hmm.. very interesting.

The configuration I got working was...

LAN =3D=3D=3D=3D=3D=3D br0(eth0 -- wlan0 (BCM4318)) as AP ~~~~~~~~~~ la=
ptop with
BCM4306 rev 2

=2E..but I believe the BCM4318 I have is defective.. even with a
standard AP, I haven't got it transfer any faster than about .5Mb/s.

In the reverse configuration...

LAN =3D=3D=3D=3D=3D=3D br0(eth0 -- wlan0 (BCM4306 rev 2)) as AP ~~~~~~~=
~~~ server
with BCM4318

=2E..I was unable to observe any beacons coming from the AP.

Like you said, the issue might be related to my particular card since
you were successful at getting your card to send beacons. I'll
experiment with your patches to see if I can't determine where they
seem to fail with my card. Hopefully, some well placed debug messages
will help locate the problem.

Ideally, my server will eventually be the AP but for now I need
something my BCM4318 can try to connect to. Thus when a Linksys tech
isn't capable of producing the speeds claimed by the 4318 card I can
get it RMA'd for a new device.

Regards,

David Ellingsworth
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
