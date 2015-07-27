Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34798 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbbG0ST7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 14:19:59 -0400
Received: by igk11 with SMTP id 11so73679237igk.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 11:19:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87pp3hbh18.fsf@kamboji.qca.qualcomm.com>
References: <1434138966-3652-1-git-send-email-cfliu.tw@gmail.com> <87pp3hbh18.fsf@kamboji.qca.qualcomm.com>
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Mon, 27 Jul 2015 11:19:19 -0700
Message-ID: <CAG5N3qH0VOxiqxTSfUEQWnQ7+Uhyh-ay8w=tMvswcBQzwHhhwQ@mail.gmail.com> (sfid-20150727_202009_565115_F783AD89)
Subject: Re: [PATCH v4] ath10k: enable raw encap mode and software crypto engine.
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle. I reviewed the change and it looks good to me.

Thanks
David

On Fri, Jul 24, 2015 at 10:29 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Liu CF/TW <cfliu.tw@gmail.com> writes:
>
>> From: David Liu <cfliu.tw@gmail.com>
>>
>>   This patch enables raw Rx/Tx encap mode to support software based
>>   crypto engine. This patch introduces a new module param 'cryptmode'.
>>
>>    cryptmode:
>>
>>      0: Use hardware crypto engine globally with native Wi-Fi mode TX/RX
>>         encapsulation to the firmware. This is the default mode.
>>      1: Use sofware crypto engine globally with raw mode TX/RX
>>         encapsulation to the firmware.
>>
>>    Known limitation:
>>      A-MSDU must be disabled for RAW Tx encap mode to perform well when
>>      heavy traffic is applied.
>>
>>    Testing: (by Michal Kazior <michal.kazior@tieto.com>)
>>
>>      a) Performance Testing
>>
>>       cryptmode=1
>>        ap=qca988x sta=killer1525
>>         killer1525  ->  qca988x     194.496 mbps [tcp1 ip4]
>>         killer1525  ->  qca988x     238.309 mbps [tcp5 ip4]
>>         killer1525  ->  qca988x     266.958 mbps [udp1 ip4]
>>         killer1525  ->  qca988x     477.468 mbps [udp5 ip4]
>>         qca988x     ->  killer1525  301.378 mbps [tcp1 ip4]
>>         qca988x     ->  killer1525  297.949 mbps [tcp5 ip4]
>>         qca988x     ->  killer1525  331.351 mbps [udp1 ip4]
>>         qca988x     ->  killer1525  371.528 mbps [udp5 ip4]
>>        ap=killer1525 sta=qca988x
>>         qca988x     ->  killer1525  331.447 mbps [tcp1 ip4]
>>         qca988x     ->  killer1525  328.783 mbps [tcp5 ip4]
>>         qca988x     ->  killer1525  375.309 mbps [udp1 ip4]
>>         qca988x     ->  killer1525  403.379 mbps [udp5 ip4]
>>         killer1525  ->  qca988x     203.689 mbps [tcp1 ip4]
>>         killer1525  ->  qca988x     222.339 mbps [tcp5 ip4]
>>         killer1525  ->  qca988x     264.199 mbps [udp1 ip4]
>>         killer1525  ->  qca988x     479.371 mbps [udp5 ip4]
>>
>>       Note:
>>        - only open network tested for RAW vs nwifi performance comparison
>>        - killer1525 (qca6174 hw2.2) is 2x2 device (hence max 866mbps)
>>        - used iperf
>>        - OTA, devices a few cm apart from each other, no shielding
>>        - tcpX/udpX, X - means number of threads used
>>
>>       Overview:
>>        - relative Tx performance drop is seen but is within reasonable and
>>          expected threshold (A-MSDU must be disabled with RAW Tx)
>>
>>      b) Connectivity Testing
>>
>>       cryptmode=1
>>        ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta          OK
>>        ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta          OK
>>        ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta          OK
>>        ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta          OK
>>        ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta          OK
>>        ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta          OK
>>        ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta          OK
>>        ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta          OK
>>        ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br       OK
>>        ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br       OK
>>        ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br       OK
>>        ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br       OK
>>        ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br       OK
>>        ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br       OK
>>        ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br       OK
>>        ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br       OK
>>        ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br1vlan  OK
>>        ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br1vlan  OK
>>        ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br1vlan  OK
>>        ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br1vlan  OK
>>        ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br1vlan  OK
>>        ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br1vlan  OK
>>        ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br1vlan  OK
>>        ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br1vlan  OK
>>
>>       Note:
>>        - each test takes all possible endpoint pairs and pings
>>        - each pair-ping flushes arp table
>>        - ip6 is used
>>
>>      c) Testbed Topology:
>>
>>       1ap1sta:
>>         [ap] ---- [sta]
>>
>>         endpoints: ap, sta
>>
>>       1ap1sta2br:
>>         [veth0] [ap] ---- [sta] [veth2]
>>            |     |          |     |
>>         [veth1]  |          \   [veth3]
>>             \   /            \  /
>>             [br0]            [br1]
>>
>>         endpoints: veth0, veth2, br0, br1
>>         note: STA works in 4addr mode, AP has wds_sta=1
>>
>>       1ap1sta2br1vlan:
>>         [veth0] [ap] ---- [sta] [veth2]
>>            |     |          |     |
>>         [veth1]  |          \   [veth3]
>>             \   /            \  /
>>           [br0]              [br1]
>>             |                  |
>>           [vlan0_id2]        [vlan1_id2]
>>
>>         endpoints: vlan0_id2, vlan1_id2
>>         note: STA works in 4addr mode, AP has wds_sta=1
>>
>>   Credits:
>>
>>     Thanks to Michal Kazior <michal.kazior@tieto.com> who helped find the
>>     amsdu issue, contributed a workaround (already squashed into this
>>     patch), and contributed the throughput and connectivity tests results.
>>
>> Signed-off-by: David Liu <cfliu.tw@gmail.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> Tested-by: Michal Kazior <michal.kazior@tieto.com>
>
> Sorry for taking so long with the review and testing, this got delayed
> because of my vacation. I now rebased the patch to the pending branch
> and fixed conflicts. Please review carefully my changes:
>
> https://github.com/kvalo/ath/commit/8f30e155b942cc712afe9ec80b463f923e7c2700
>
> --
> Kalle Valo
