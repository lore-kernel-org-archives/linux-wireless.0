Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43091 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGJLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 05:11:11 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so4669135wiv.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2014 02:11:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5341F1A9.2030202@candelatech.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<5341F1A9.2030202@candelatech.com>
Date: Mon, 7 Apr 2014 11:11:09 +0200
Message-ID: <CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com> (sfid-20140407_111116_011372_10654191)
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 April 2014 02:30, Ben Greear <greearb@candelatech.com> wrote:
> On 04/04/2014 04:37 AM, Michal Kazior wrote:
>>
>> Hi,
>>
>> After digging around I've found what seems to be
>> the problem with WMI Tx credit starvation and
>> inability to properly flush Tx in ath10k_flush().
>
>
> I applied all four, rebooted AP and Station machine with the
> new kernel (3.14.0-wl-ath+).  I had removed my own tx-hang detection
> hack.
>
> It is not working well...though perhaps it is not directly related
> to your patches...I will do some reboots and try reversing some patches.
> But, 3.14.0-rc8-wl-ath+ was working mostly OK for me....
>
> It seems my user-space app got hung, probably because rtnl was being
> held too long while doing admin-down on a bunch of stations.
>
> Out of 32 stations, maybe 5 of them managed to come up and get
> an IP address through DHCP before user-space app hung and log
> started filling with the errors at the end of the dmesg below.
>
>
> sta218: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): sta218: link becomes ready
> sta219: authenticate with 04:f0:21:03:38:99
> ath10k: mac vdev 19 beacon_interval 100
> ath10k: mac vdev 19 create peer 04:f0:21:03:38:99
> ath10k: mac vdev 19 start 04:f0:21:03:38:99
> ath10k: mac vdev 19 start center_freq 5180 phymode 11ac-vht80
>
> sta219: send auth to 04:f0:21:03:38:99 (try 1/3)
> sta219: authenticated
> sta218: deauthenticating from 04:f0:21:03:38:99 by local choice (Reason:
> 3=DEAUTH_LEAVING)
> ath10k: mac flushing peer 04:f0:21:03:38:99 on vdev 18 mgmt tid for unicast
> mgmt
> ath10k: mac vdev 18 peer delete 04:f0:21:03:38:99 (sta gone)
> ath10k: mac vdev 18 stop (disassociated
> ath10k: mac vdev 18 down
> ath10k: mac vdev 18 cts_prot 0
> ath10k: mac vdev 18 slot_time 1
> ath10k: mac vdev 18 preamble 1n
> sta219: associate with 04:f0:21:03:38:99 (try 1/3)
> sta219: RX AssocResp from 04:f0:21:03:38:99 (capab=0x1 status=0 aid=22)
> ath10k: mac vdev 19 dtim_period 2
> ath10k: mac vdev 19 slot_time 2
> ath10k: mac ht peer 04:f0:21:03:38:99 mcs cnt 24 nss 3
> ath10k: mac vht peer 04:f0:21:03:38:99 max_mpdu 65535 flags 0x6003001
> ath10k: mac peer 04:f0:21:03:38:99 phymode 11ac-vht80
> ath10k: mac vdev 19 up (associated) bssid 04:f0:21:03:38:99 aid 22
> sta219: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): sta219: link becomes ready
> sta220: authenticate with 04:f0:21:03:38:99
> ath10k: mac vdev 20 beacon_interval 100
> ath10k: mac vdev 20 create peer 04:f0:21:03:38:99
> ath10k: mac vdev 20 start 04:f0:21:03:38:99
> ath10k: mac vdev 20 start center_freq 5180 phymode 11ac-vht80
> sta220: send auth to 04:f0:21:03:38:99 (try 1/3)
> sta220: authenticated
> sta220: associate with 04:f0:21:03:38:99 (try 1/3)
> sta220: RX AssocResp from 04:f0:21:03:38:99 (capab=0x1 status=0 aid=23)
> ath10k: mac vdev 20 dtim_period 2
> ath10k: mac vdev 20 slot_time 2
> ath10k: mac ht peer 04:f0:21:03:38:99 mcs cnt 24 nss 3
> ath10k: mac vht peer 04:f0:21:03:38:99 max_mpdu 65535 flags 0x6003001
> ath10k: mac peer 04:f0:21:03:38:99 phymode 11ac-vht80
> ath10k: mac vdev 20 up (associated) bssid 04:f0:21:03:38:99 aid 23
> sta220: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): sta220: link becomes ready
> ath10k: Creating vdev id: 21  map: 4292870144
> ath10k: mac vdev create 21 (add interface) type 2 subtype 0
> ath10k: mac vdev 21 cts_prot 0
> ath10k: mac vdev 21 slot_time 1
> ath10k: mac vdev 21 preamble 1n
> IPv6: ADDRCONF(NETDEV_UP): sta221: link is not ready
> ath10k: mac vdev 21 delete (remove interface)
> ath10k: peer-unmap-event: unknown peer id 23
> ath10k: Creating vdev id: 21  map: 4292870144
> ath10k: mac vdev create 21 (add interface) type 2 subtype 0
> ath10k: mac vdev 21 cts_prot 0
> ath10k: mac vdev 21 slot_time 1
> ath10k: mac vdev 21 preamble 1n
> IPv6: ADDRCONF(NETDEV_UP): sta221: link is not ready
> sta217: authenticate with 04:f0:21:03:38:99
> ath10k: mac vdev 17 beacon_interval 100
> ath10k: mac vdev 17 create peer 04:f0:21:03:38:99
> ath10k: mac vdev 17 start 04:f0:21:03:38:99
> ath10k: mac vdev 17 start center_freq 5180 phymode 11ac-vht80
>
> sta217: send auth to 04:f0:21:03:38:99 (try 1/3)
> sta217: authenticated
> sta217: associate with 04:f0:21:03:38:99 (try 1/3)
> sta217: RX AssocResp from 04:f0:21:03:38:99 (capab=0x1 status=0 aid=20)
> ath10k: mac vdev 17 dtim_period 2
> ath10k: mac vdev 17 slot_time 2
> ath10k: mac ht peer 04:f0:21:03:38:99 mcs cnt 24 nss 3
> ath10k: mac vht peer 04:f0:21:03:38:99 max_mpdu 65535 flags 0x6003001
> ath10k: mac peer 04:f0:21:03:38:99 phymode 11ac-vht80
> ath10k: mac vdev 17 up (associated) bssid 04:f0:21:03:38:99 aid 20
> sta217: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): sta217: link becomes ready
> sta218: authenticate with 04:f0:21:03:38:99
> ath10k: mac vdev 18 beacon_interval 100
> ath10k: mac vdev 18 create peer 04:f0:21:03:38:99
> ath10k: mac vdev 18 start 04:f0:21:03:38:99
> ath10k: mac vdev 18 start center_freq 5180 phymode 11ac-vht80
> sta218: send auth to 04:f0:21:03:38:99 (try 1/3)
> ath10k: Creating vdev id: 22  map: 4290772992
> ath10k: mac vdev create 22 (add interface) type 2 subtype 0
> sta218: authenticated
> ath10k: mac vdev 22 cts_prot 0
> ath10k: mac vdev 22 slot_time 1
> ath10k: mac vdev 22 preamble 1n
> IPv6: ADDRCONF(NETDEV_UP): sta222: link is not ready
> sta218: associate with 04:f0:21:03:38:99 (try 1/3)
> sta218: RX AssocResp from 04:f0:21:03:38:99 (capab=0x1 status=0 aid=18)
> ath10k: mac vdev 18 dtim_period 2
> ath10k: mac vdev 18 slot_time 2
> ath10k: mac ht peer 04:f0:21:03:38:99 mcs cnt 24 nss 3
> ath10k: mac vht peer 04:f0:21:03:38:99 max_mpdu 65535 flags 0x6003001
> ath10k: mac peer 04:f0:21:03:38:99 phymode 11ac-vht80
> ath10k: mac vdev 18 up (associated) bssid 04:f0:21:03:38:99 aid 18
> sta218: associated
> sta222: authenticate with 04:f0:21:03:38:99
> ath10k: mac vdev 22 beacon_interval 100
> ath10k: mac vdev 22 create peer 04:f0:21:03:38:99
> ath10k: mac vdev 22 start 04:f0:21:03:38:99
> ath10k: mac vdev 22 start center_freq 5180 phymode 11ac-vht80
>
> sta222: send auth to 04:f0:21:03:38:99 (try 1/3)
> ath10k: mac vdev 22 peer delete 04:f0:21:03:38:99 (sta gone)
> ath10k: mac vdev 22 stop (disassociated
> ath10k: mac vdev 22 down
> ath10k: mac vdev 22 delete (remove interface)
> ath10k: peer-unmap-event: unknown peer id 24
> ath10k: Creating vdev id: 22  map: 4290772992
> ath10k: mac vdev create 22 (add interface) type 2 subtype 0
> ath10k: mac vdev 22 cts_prot 0
> ath10k: mac vdev 22 slot_time 1
> ath10k: mac vdev 22 preamble 1n
> IPv6: ADDRCONF(NETDEV_UP): sta222: link is not ready
> sta221: authenticate with 04:f0:21:03:38:99
> ath10k: mac vdev 21 beacon_interval 100
> ath10k: mac vdev 21 create peer 04:f0:21:03:38:99
> ath10k: mac vdev 21 start 04:f0:21:03:38:99
> ath10k: mac vdev 21 start center_freq 5180 phymode 11ac-vht80
>
> sta221: send auth to 04:f0:21:03:38:99 (try 1/3)
> sta221: authenticated
> sta221: associate with 04:f0:21:03:38:99 (try 1/3)
> sta221: RX AssocResp from 04:f0:21:03:38:99 (capab=0x1 status=0 aid=19)
> ath10k: mac vdev 21 dtim_period 2
> ath10k: mac vdev 21 slot_time 2
> ath10k: mac ht peer 04:f0:21:03:38:99 mcs cnt 24 nss 3
> ath10k: mac vht peer 04:f0:21:03:38:99 max_mpdu 65535 flags 0x6003001
> ath10k: mac peer 04:f0:21:03:38:99 phymode 11ac-vht80
> ath10k: mac vdev 21 up (associated) bssid 04:f0:21:03:38:99 aid 19
> sta221: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): sta221: link becomes ready
> sta222: authenticate with 04:f0:21:03:38:99
> ath10k: mac vdev 22 beacon_interval 100
> ath10k: mac vdev 22 create peer 04:f0:21:03:38:99
> ath10k: mac vdev 22 start 04:f0:21:03:38:99
> ath10k: mac vdev 22 start center_freq 5180 phymode 11ac-vht80
> sta222: send auth to 04:f0:21:03:38:99 (try 1/3)
> sta222: authenticated
> sta222: associate with 04:f0:21:03:38:99 (try 1/3)
> sta222: RX AssocResp from 04:f0:21:03:38:99 (capab=0x1 status=0 aid=24)
> ath10k: mac vdev 22 dtim_period 2
> ath10k: mac vdev 22 slot_time 2
> ath10k: mac ht peer 04:f0:21:03:38:99 mcs cnt 24 nss 3
> ath10k: mac vht peer 04:f0:21:03:38:99 max_mpdu 65535 flags 0x6003001
> ath10k: mac peer 04:f0:21:03:38:99 phymode 11ac-vht80
> ath10k: mac vdev 22 up (associated) bssid 04:f0:21:03:38:99 aid 24
> sta222: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): sta222: link becomes ready
>
> sta213: deauthenticating from 04:f0:21:03:38:99 by local choice (Reason:
> 3=DEAUTH_LEAVING)
> ath10k: mac flushing peer 04:f0:21:03:38:99 on vdev 13 mgmt tid for unicast
> mgmt
> ath10k: mac vdev 13 peer delete 04:f0:21:03:38:99 (sta gone)
> ath10k: mac vdev 13 stop (disassociated
> ath10k: mac vdev 13 down
> ath10k: mac vdev 13 cts_prot 0
> ath10k: mac vdev 13 slot_time 1
>
> ath10k: failed to set erp slot for vdev 13: -11
> ath10k: mac vdev 13 preamble 1n
> ath10k: failed to set preamble for vdev 13: -11
> ath10k: failed to set wmm params: -11
> ath10k: failed to set wmm params: -11

These logs are not enough. I'd love to see traces for this to see what
frames are actually submitted and when tx credits are replenished.

I also wonder if this can be somehow related to your FW changes to
allow connecting multiple client virtual interfaces to a single AP?


Michał
