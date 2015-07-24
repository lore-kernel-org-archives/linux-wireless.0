Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36197 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbbGXR3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 13:29:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Liu CF/TW <cfliu.tw@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH v4] ath10k: enable raw encap mode and software crypto engine.
References: <1434138966-3652-1-git-send-email-cfliu.tw@gmail.com>
Date: Fri, 24 Jul 2015 20:29:39 +0300
In-Reply-To: <1434138966-3652-1-git-send-email-cfliu.tw@gmail.com> (Liu CF's
	message of "Fri, 12 Jun 2015 12:56:06 -0700")
Message-ID: <87pp3hbh18.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_192949_441992_CA33E7AD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Liu CF/TW <cfliu.tw@gmail.com> writes:

> From: David Liu <cfliu.tw@gmail.com>
>
>   This patch enables raw Rx/Tx encap mode to support software based
>   crypto engine. This patch introduces a new module param 'cryptmode'.
>
>    cryptmode:
>
>      0: Use hardware crypto engine globally with native Wi-Fi mode TX/RX
>         encapsulation to the firmware. This is the default mode.
>      1: Use sofware crypto engine globally with raw mode TX/RX
>         encapsulation to the firmware.
>
>    Known limitation:
>      A-MSDU must be disabled for RAW Tx encap mode to perform well when
>      heavy traffic is applied.
>
>    Testing: (by Michal Kazior <michal.kazior@tieto.com>)
>
>      a) Performance Testing
>
>       cryptmode=1
>        ap=qca988x sta=killer1525
>         killer1525  ->  qca988x     194.496 mbps [tcp1 ip4]
>         killer1525  ->  qca988x     238.309 mbps [tcp5 ip4]
>         killer1525  ->  qca988x     266.958 mbps [udp1 ip4]
>         killer1525  ->  qca988x     477.468 mbps [udp5 ip4]
>         qca988x     ->  killer1525  301.378 mbps [tcp1 ip4]
>         qca988x     ->  killer1525  297.949 mbps [tcp5 ip4]
>         qca988x     ->  killer1525  331.351 mbps [udp1 ip4]
>         qca988x     ->  killer1525  371.528 mbps [udp5 ip4]
>        ap=killer1525 sta=qca988x
>         qca988x     ->  killer1525  331.447 mbps [tcp1 ip4]
>         qca988x     ->  killer1525  328.783 mbps [tcp5 ip4]
>         qca988x     ->  killer1525  375.309 mbps [udp1 ip4]
>         qca988x     ->  killer1525  403.379 mbps [udp5 ip4]
>         killer1525  ->  qca988x     203.689 mbps [tcp1 ip4]
>         killer1525  ->  qca988x     222.339 mbps [tcp5 ip4]
>         killer1525  ->  qca988x     264.199 mbps [udp1 ip4]
>         killer1525  ->  qca988x     479.371 mbps [udp5 ip4]
>
>       Note:
>        - only open network tested for RAW vs nwifi performance comparison
>        - killer1525 (qca6174 hw2.2) is 2x2 device (hence max 866mbps)
>        - used iperf
>        - OTA, devices a few cm apart from each other, no shielding
>        - tcpX/udpX, X - means number of threads used
>
>       Overview:
>        - relative Tx performance drop is seen but is within reasonable and
>          expected threshold (A-MSDU must be disabled with RAW Tx)
>
>      b) Connectivity Testing
>
>       cryptmode=1
>        ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta          OK
>        ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta          OK
>        ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta          OK
>        ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta          OK
>        ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta          OK
>        ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta          OK
>        ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta          OK
>        ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta          OK
>        ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br       OK
>        ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br       OK
>        ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br       OK
>        ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br       OK
>        ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br       OK
>        ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br       OK
>        ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br       OK
>        ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br       OK
>        ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br1vlan  OK
>        ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br1vlan  OK
>        ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br1vlan  OK
>        ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br1vlan  OK
>        ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br1vlan  OK
>        ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br1vlan  OK
>        ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br1vlan  OK
>        ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br1vlan  OK
>
>       Note:
>        - each test takes all possible endpoint pairs and pings
>        - each pair-ping flushes arp table
>        - ip6 is used
>
>      c) Testbed Topology:
>
>       1ap1sta:
>         [ap] ---- [sta]
>
>         endpoints: ap, sta
>
>       1ap1sta2br:
>         [veth0] [ap] ---- [sta] [veth2]
>            |     |          |     |
>         [veth1]  |          \   [veth3]
>             \   /            \  /
>             [br0]            [br1]
>
>         endpoints: veth0, veth2, br0, br1
>         note: STA works in 4addr mode, AP has wds_sta=1
>
>       1ap1sta2br1vlan:
>         [veth0] [ap] ---- [sta] [veth2]
>            |     |          |     |
>         [veth1]  |          \   [veth3]
>             \   /            \  /
>           [br0]              [br1]
>             |                  |
>           [vlan0_id2]        [vlan1_id2]
>
>         endpoints: vlan0_id2, vlan1_id2
>         note: STA works in 4addr mode, AP has wds_sta=1
>
>   Credits:
>
>     Thanks to Michal Kazior <michal.kazior@tieto.com> who helped find the
>     amsdu issue, contributed a workaround (already squashed into this 
>     patch), and contributed the throughput and connectivity tests results.
>
> Signed-off-by: David Liu <cfliu.tw@gmail.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Tested-by: Michal Kazior <michal.kazior@tieto.com>

Sorry for taking so long with the review and testing, this got delayed
because of my vacation. I now rebased the patch to the pending branch
and fixed conflicts. Please review carefully my changes:

https://github.com/kvalo/ath/commit/8f30e155b942cc712afe9ec80b463f923e7c2700

-- 
Kalle Valo
