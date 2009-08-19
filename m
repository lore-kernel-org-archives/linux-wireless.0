Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:5274 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZHSXc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 19:32:59 -0400
Received: by an-out-0708.google.com with SMTP id d40so4135499and.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 16:33:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 19 Aug 2009 16:33:00 -0700
Message-ID: <445f43ac0908191633xf9348cdu5bbdd3ac08e13260@mail.gmail.com>
Subject: ath9k mesh beaconing behavior
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Could someone familiar with the ath9k help us solve a problem with
mesh beaconing?

For reference, with ath5k the following sequence will bring up a mesh
interface and start beaconing:

modprobe ath5k debug=0x10      # ATH5K_DBG_BEACON
iw phy phy0 interface add mesh type mp mesh_id kangaroo
iw dev mesh set channel 11
ifconfig mesh up

dmesg:
[  622.869143] ath5k phy0: (ath5k_beaconq_config:1512): beacon
queueprops tqi_aifs:0 tqi_cw_min:0 tqi_cw_max:0
[  622.869234] ath5k phy0: (ath5k_beacon_update_timers:2239):
reconfigured timers based on HW TSF
[  622.869234] ath5k phy0: (ath5k_beacon_update_timers:2250): bc_tsf
ffffffffffffffff hw_tsf 85a8fb61a bc_tu 4294967295 hw_tu 35038189
nexttbtt 35039000
[  622.869234] ath5k phy0: (ath5k_beacon_update_timers:2254): intval
1000 AR5K_BEACON_ENA
[  623.690964] ath5k phy0: (ath5k_beacon_send:2094): in beacon_send
[  623.691301] ath5k phy0: (ath5k_beacon_send:2144): TXDP[7] = 5ce5e00
(c5ce5e00)
...

With ath9k, the following sequence will bring up a mesh interface and
*not* start beaconing:

modprobe ath5k debug=0x100    # ATH_DBG_BEACON
iw phy phy0 interface add mesh type mp mesh_id kangaroo
iw dev mesh set channel 11
ifconfig mesh up

dmesg reports that beaconing has started, but no beacons are observed
in the air:

[  518.277283] ath9k: IBSS nexttbtt 29406000 intval 1000 (1000)
[  518.301884] ath9k: TXDP9 = 68ca000 (c68ca000)

Beacons are only observed after scanning:

iw dev mesh scan

dmesg:
[  768.944564] ath9k: IBSS nexttbtt 4291335000 intval 1000 (1000)
[  768.964665] ath9k: TXDP9 = 68ca000 (c68ca000)

Any suggestions will be appreciated.

Thanks,

Javier
