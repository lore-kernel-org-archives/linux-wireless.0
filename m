Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:36354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbYFPSVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 14:21:45 -0400
Received: by fg-out-1718.google.com with SMTP id 19so3330977fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 11:21:41 -0700 (PDT)
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Mon, 16 Jun 2008 20:21:36 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <200806131937.03680.Michal.Kudla@gmail.com> <1213581088.7814.882.camel@debian.sh.intel.com>
In-Reply-To: <1213581088.7814.882.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806162021.37105.Michal.Kudla@gmail.com> (sfid-20080616_202150_559700_C804B7A2)
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After

laptok ~ # echo 0 > /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rf_kill
laptok ~ # iwconfig wlan0 txpower on
laptok ~ # /etc/init.d/net.wlan0 restart
 * Service net.wlan0 starting
 * Service net.wlan0 started
laptok ~ # dmesg >dmesg-`uname -r`_`date +%F`.txt


I get in dmesg

=2E..
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
ACPI: PCI interrupt for device 0000:04:00.0 disabled
HW CONFIG: channel=3D10 freq=3D2457 phymode=3D2
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 1=
00102,=20
writing 100106)
HW CONFIG: channel=3D10 freq=3D2457 phymode=3D2
ADDRCONF(NETDEV_UP): wlan0: link is not ready
HW CONFIG: channel=3D10 freq=3D2457 phymode=3D2
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=3D30) FC=3D0x00b0 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35
HW CONFIG: channel=3D10 freq=3D2457 phymode=3D2
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=3D30) FC=3D0x00b0 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35
wlan0: RX authentication from 00:01:e3:06:00:35 (alg=3D0 transaction=3D=
2 status=3D0)
wlan0: authenticated
wlan0: associate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=3D50) FC=3D0x0000 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35
wlan0: authentication frame received from 00:01:e3:06:00:35, but not in=
=20
authenticate state - ignored
wlan0: authentication frame received from 00:01:e3:06:00:35, but not in=
=20
authenticate state - ignored
wlan0: RX AssocResp from 00:01:e3:06:00:35 (capab=3D0x11 status=3D0 aid=
=3D1)
wlan0: associated
phy0: Added STA 00:01:e3:06:00:35
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
phy0: TX to low-level driver (len=3D116) FC=3D0x4108 DUR=3D0x0102=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D33:33:00:00:00:16
HW CONFIG: channel=3D10 freq=3D2457 phymode=3D2
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=3D30) FC=3D0x00b0 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35
wlan0: RX authentication from 00:01:e3:06:00:35 (alg=3D0 transaction=3D=
2 status=3D0)
wlan0: authenticated
wlan0: associate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=3D56) FC=3D0x0020 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35
wlan0: RX ReassocResp from 00:01:e3:06:00:35 (capab=3D0x11 status=3D0 a=
id=3D1)
wlan0: associated
wlan0: association frame received from 00:01:e3:06:00:35, but not in as=
sociate=20
state - ignored
phy0: TX to low-level driver (len=3D104) FC=3D0x4108 DUR=3D0x0102=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D33:33:ff:42:88:f9
phy0: TX to low-level driver (len=3D96) FC=3D0x4108 DUR=3D0x0102=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D33:33:00:00:00:02
phy0: TX to low-level driver (len=3D68) FC=3D0x4108 DUR=3D0x0102=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3Dff:ff:ff:ff:ff:ff
phy0: TX to low-level driver (len=3D116) FC=3D0x4108 DUR=3D0x0102=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D33:33:00:00:00:16
phy0: TX to low-level driver (len=3D68) FC=3D0x4108 DUR=3D0x0102=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3Dff:ff:ff:ff:ff:ff
phy0: TX to low-level driver (len=3D96) FC=3D0x4108 DUR=3D0x0102=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D33:33:00:00:00:02
phy0: TX to low-level driver (len=3D96) FC=3D0x4108 DUR=3D0x0102=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D33:33:00:00:00:02
wlan0: no IPv6 routers present
phy0: TX to low-level driver (len=3D46) FC=3D0x0040 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35
phy0: TX to low-level driver (len=3D46) FC=3D0x0040 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35
phy0: TX to low-level driver (len=3D46) FC=3D0x0040 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35
phy0: TX to low-level driver (len=3D46) FC=3D0x0040 DUR=3D0x013a=20
A1=3D00:01:e3:06:00:35 A2=3D00:13:e8:42:88:f9 A3=3D00:01:e3:06:00:35

And my wifi working!

Bt, I don't know why my wifi working under 2.6.23 and 2.6.24?


W li=C5=9Bcie datowanym na poniedzia=C5=82ek, 16 czerwca 2008, Zhu Yi p=
isze:
>ZY On Fri, 2008-06-13 at 19:37 +0200, Micha=C5=82 Kud=C5=82a wrote:
>ZY > dmesg-2.6.26-rc5_2008-06-13.txt
>ZY
>ZY >From this log:
>ZY
>ZY iwl4965: U iwl4965_radio_kill_sw Manual SW RF KILL set to: RADIO OF=
=46
>ZY iwl4965: I iwl4965_rx_card_state_notif Card state received: HW:On
>ZY SW:Kill
>ZY iwl4965: U iwl4965_mac_config leave - radio disabled
>ZY iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd failed:=
 -5
>ZY iwl4965: U iwl4965_bg_rf_kill Can not turn radio back on - disabled=
 by
>ZY SW switch
>ZY iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
>ZY
>ZY Your radio is disabled by the software rf_kill switch. Please do a
>ZY
>ZY $ echo 0 > /sys/bus/pci/drivers/iwl4965/<dev id>/rfkill\:rfkill0/st=
ate
>ZY
>ZY I wonder if you (or some application) did something like a `iwconfi=
g
>ZY wlan0 txpower off` so that the radio is disabled. Maybe you can try
>ZY `iwconfig wlan0 txpower on`?
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
