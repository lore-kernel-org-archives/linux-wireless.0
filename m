Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50104 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1A2EnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 23:43:24 -0500
Received: from [71.112.48.101] (pool-71-112-48-101.sttlwa.dsl-w.verizon.net [71.112.48.101])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p0T4hNZH032706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 20:43:23 -0800
Message-ID: <4D439AEA.6020101@candelatech.com>
Date: Fri, 28 Jan 2011 20:43:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k:  Still seeing DMA issues in latest wireless-testing.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like some potentially nice ath9k patches just got merged into
wireless-testing.  It has been stable and fast so far, but I
do still see DMA issues in the logs.

This is on a system with 30 STAs associated with a flakey netgear running
HT40-, and 30 associated with a cisco running HT20.  (Through some luck,
the netgear managed to send proper ht-info channel this time,
so the NIC went HT40-).

ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
sta0: authenticate with 30:46:9a:10:0b:9a (try 1)
sta0: authenticated
sta0: associate with 30:46:9a:10:0b:9a (try 1)
sta0: RX ReassocResp from 30:46:9a:10:0b:9a (capab=0x421 status=0 aid=31)
sta0: associated
ieee80211 wiphy0: Allocated STA 30:46:9a:10:0b:9a
ieee80211 wiphy0: Inserted STA 30:46:9a:10:0b:9a
ieee80211 wiphy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
ieee80211 wiphy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
ieee80211 wiphy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
ieee80211 wiphy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ADDRCONF(NETDEV_CHANGE): sta0: link becomes ready
sta0: no IPv6 routers present
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
