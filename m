Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34874 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbdGEGGO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:06:14 -0400
Received: by mail-wm0-f54.google.com with SMTP id w126so211512365wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jul 2017 23:06:14 -0700 (PDT)
MIME-Version: 1.0
From: Heena Sirwani <heenasirwani@gmail.com>
Date: Wed, 5 Jul 2017 11:36:12 +0530
Message-ID: <CAFEh7=nvzWUHDi4CKexfMPiw8_bQd2Hhw0RQV-LzYsdT37VBsA@mail.gmail.com> (sfid-20170705_080617_756673_9FB88B50)
Subject: Mwifiex_pcie issues while connecting to access point.
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

We use the mwifiex driver for wifi from kernel-backports-4.2.6.1 for
kernel version 3.2.26 and mwifiex driver from kernel tree 4.1.8
without backporting for kernel 4.1.8.

We are having issues connecting to the access point and looks like
authenticating issues during the initial association phase.
We use wpa_cli to configure access points with security WPA-PSK.
However we also tried associating with security None.
Following ways were used to reproduce the issues:

Mwifiex for 3.2.26 (usign kernel-backports 4.2.6.1 )
Associated an access point with WPA/WPA2 with AES security.
On boot device is associated with access point.
Run dhclient -v ra0 - interface gets an ip address but does not ping
other ip addresses in network or google.
Do ifconfig ra0 down and then up. ra0 does not get an ip. Association
request fails with message "disconnected successfully"
with reason codes 2,3 and 15 randomly. The last sta event received
before this message is, EVENT="Deauthenticated" from the firmware.
dhclient -v ra0 either keeps making dhcp discover requests or fails
with terminated.
Same behaviour observerd when associated with AP without security
settings and with WEP security.
Tried changing the channel for the access point from 0 to 1 (2.417
GHz) or 149(5 Ghz) but operation is not permitted on device.
Some issue threads mentioned turning of MAC randomization in
network-manager but I guess our netmgr doesn't use mac randomization.

Mwifiex for 4.1.8
Associated AP with security = None --->able to get ip address and can
ping google.com (after a long time) with dhclient -v ra0 ---> red
light still blinks
Associated AP security = WPA_PSK ----> able to get ip address, can
ping google.com (after a long time) with dhclient -v ra0 ----> red
light still blinks
Tried ifconfig ra0 down and up with dhclient -v ra0 once, could get IP
and ping google (Have to try this multiple times)
When device booted with ethernet connected and then the ethernet is
disconnected which causes the network manager to use wifi, we see
similar deauthentication messages as in 3.2.26.

We know that we use the correct PSKs and have confirmed them.

The logs while connecting are as follows:

mwifiex_pcie 0000:00:00.0: info: trying to associate to 'NETGEAR10'
bssid b0:7f:b9:88:01:c8
mwifiex_pcie 0000:00:00.0: info: associated to bssid b0:7f:b9:88:01:c8
successfully
mwifiex_pcie 0000:00:00.0: info: successfully disconnected from
b0:7f:b9:88:01:c8: reason code 15
cfg80211: World regulatory domain updated:
cfg80211:  DFS Master region: unset
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp), (dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO),
(N/A, 2000 mBm), (N/A)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO),
(N/A, 2000 mBm), (0 s)
cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
mwifiex_pcie 0000:00:00.0: info: trying to associate to 'NETGEAR10'
bssid b0:7f:b9:88:01:c8
mwifiex_pcie 0000:00:00.0: info: associated to bssid b0:7f:b9:88:01:c8
successfully
mwifiex_pcie 0000:00:00.0: info: successfully disconnected from
b0:7f:b9:88:01:c8: reason code 15
cfg80211: World regulatory domain updated:
cfg80211:  DFS Master region: unset
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp), (dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO),
(N/A, 2000 mBm), (N/A)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO),
(N/A, 2000 mBm), (0 s)
cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)

mwifiex_pcie 0000:00:00.0: info: successfully disconnected from
b0:7f:b9:88:01:c8: reason code 3
mwifiex_pcie 0000:00:00.0: info: successfully disconnected from
00:00:00:00:00:00:      reason code 3
cfg80211: World regulatory domain updated:
cfg80211:  DFS Master region: unset
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp), (dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO),
(N/A, 2000 mBm), (N/A)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO),
(N/A, 2000 mBm), (0 s)
cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
ADDRCONF(NETDEV_UP): ra0: link is not ready
mwifiex_pcie 0000:00:00.0: info: trying to associate to 'NETGEAR10'
bssid b0:7f:b9:88:01:c8
mwifiex_pcie 0000:00:00.0: info: associated to bssid b0:7f:b9:88:01:c8
successfully
ADDRCONF(NETDEV_CHANGE): ra0: link becomes ready
mwifiex_pcie 0000:00:00.0: info: successfully disconnected from
b0:7f:b9:88:01:c8: reason code 15
cfg80211: World regulatory domain updated:
cfg80211:  DFS Master region: unset
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp), (dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO),
(N/A, 2000 mBm), (N/A)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO),
(N/A, 2000 mBm), (0 s)
cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)

Please let me know if you have inputs on this.

Thanks,
Heena
