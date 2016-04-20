Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35049 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbcDTFn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 01:43:56 -0400
Received: by mail-io0-f194.google.com with SMTP id u185so5601322iod.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2016 22:43:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD3r-iRQD5nVBuC1_zYmu_FtmP4CdP2BbHxz1Q579mBPKg5zmQ@mail.gmail.com>
References: <CAD3r-iRQD5nVBuC1_zYmu_FtmP4CdP2BbHxz1Q579mBPKg5zmQ@mail.gmail.com>
Date: Wed, 20 Apr 2016 00:43:55 -0500
Message-ID: <CAD3r-iTvJZLM0=tpoKZr8RGFrymdzPBV8xAEsx-qvnFeh6y=5g@mail.gmail.com> (sfid-20160420_074400_699541_0F9D7D85)
Subject: Fwd: ap + adhoc not working with Mwifiex driver for sd8887
From: Luana Borgia <luanaborgia1969@gmail.com>
To: linux-wireless@vger.kernel.org, Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I've successfully managed to get this driver working in adhoc with
olsrd on mlan0 interface, now I'm trying to add a uap0 working at the
same time, with all this command:

rfkill unblock wlan
ip link set uap0 down
ip link set mlan0 down
iw dev mlan0 set type ibss
ip link set mlan0 up
iw dev mlan0 ibss join mesh 2437 fe:de:fe:de:fe:de
olsrd-start.sh
cat <<EOF > /etc/hostapd.conf
ssid=PCM_AP_fede
interface=uap0
driver=nl80211
hw_mode=g
channel=6
EOF
iw phy phy0 interface add uap0 type __ap
hostapd /etc/hostapd.conf &
dnsmasq --interface=uap0 --except-interface=lo --bind-interfaces
--dhcp-range=192.168.3.2,192.168.3.10,12h --conf-file=/dev/null
ip addr add 192.168.3.1/24 broadcast 192.168.3.255 dev uap0

but I get this error after run the hostapd command:

[ 4980.201096] IPv6: ADDRCONF(NETDEV_CHANGE): mlan0: link becomes ready
[ 4983.335467] IPv6: ADDRCONF(NETDEV_UP): uap0: link is not ready
[ 4983.358879] mwifiex_sdio mmc0:0001:1: CMD_RESP: cmd 0xb1 error, result=0x1

adhoc is fine, with the above order of command
but if I run before hostapd and than adhoc part than the issue occur
in the adhoc part.

I'm using the firmware
http://git.marvell.com/?p=mwifiex-firmware.git;a=blob;f=mrvl/sd8887_uapsta.bin;h=165e6c3d34b0c2a630252907a7ac4daf6e13c9d5;hb=HEAD

and the mwifiex from kernel linux 4.1.1

thanks in advance for any support
best regards

Luana
