Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:36047 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168Ab2DKKZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 06:25:49 -0400
Received: by lbon3 with SMTP id n3so621890lbo.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 03:25:46 -0700 (PDT)
Message-ID: <1334139944.10398.11.camel@cumari> (sfid-20120411_122553_215309_5CF470DC)
Subject: Re: wl1271: communication fails with kernel 3.4-rc2 and firmware
 series 4
From: Luciano Coelho <coelho@ti.com>
To: yegor_sub1@visionsystems.de
Cc: linux-wireless@vger.kernel.org, arik@wizery.com,
	Yegor Yefremov <yegorslists@googlemail.com>
Date: Wed, 11 Apr 2012 13:25:44 +0300
In-Reply-To: <4F855997.20603@visionsystems.de>
References: <4F855997.20603@visionsystems.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yegor,

On Wed, 2012-04-11 at 12:14 +0200, Yegor Yefremov wrote:
> continuing our yesterdays discussion on IRC I try to summarize my
> results. 
> 
> First of all I calibrated my WLAN card via ti-utils as described here
> http://linuxwireless.org/en/users/Drivers/wl12xx/calibrator using
> calibrator plt calibrate. 
> 
> Then I integrated this nvs file into kernel, so I have no longer these
> nasty errors.
> 
> Still I cannot ping anything. Here you can see the end of
> wpa_supplicant's log:
> 
> WPA: Installing PTK to the driver.
> wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=0x42a48 key_idx=0 set_tx=1 seq_len=6 key_len=32
>    addr=5c:d9:98:f9:30:d9
> EAPOL: External notification - portValid=1
> State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
> RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
> WPA: Group Key - hexdump(len=32): [REMOVED]
> WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
> WPA: RSC - hexdump(len=6): b1 7c 0d 00 00 00
> wpa_driver_nl80211_set_key: ifindex=3 alg=2 addr=0x2a443 key_idx=1 set_tx=0 seq_len=6 key_len=32
> WPA: Key negotiation completed with 5c:d9:98:f9:30:d9 [PTK=TKIP GTK=TKIP]
> Cancelling authentication timeout
> Removed BSSID 5c:d9:98:f9:30:d9 from blacklist
> State: GROUP_HANDSHAKE -> COMPLETED
> CTRL-EVENT-CONNECTED - Connection to 5c:d9:98:f9:30:d9 completed (reauth) [id=1
> id_str=]
> wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
> netlink: Operstate: linkmode=-1, operstate=6
> EAPOL: External notification - portValid=1
> EAPOL: External notification - EAP success=1
> EAPOL: SUPP_PAE entering state AUTHENTICATING
> EAPOL: SUPP_BE entering state SUCCESS
> EAP: EAP entering state DISABLED
> EAPOL: SUPP_PAE entering state AUTHENTICATED
> EAPOL: Supplicant port status: Authorized
> EAPOL: SUPP_BE entering state IDLE
> EAPOL authentication completed successfully
> RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> EAPOL: startWhen --> 0
> EAPOL: disable timer tick
> 
> Any ideas? As i told before both 2.6.37 and 3.3-rc7 made no problems.

Hard to say.  From these logs everything seems to be working fine.  What
IP address are you using? Are you sure your routes are all set up
correctly? Do you get any messages in the kernel logs, TX stuck
watchdog, maybe?


-- 
Cheers,
Luca.

