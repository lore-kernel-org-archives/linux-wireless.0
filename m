Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52500 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3EIFPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 01:15:55 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20875.12412.946993.203664@gargle.gargle.HOWL> (sfid-20130509_071558_999166_EB389FB6)
Date: Thu, 9 May 2013 10:43:32 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fun with QoS in AP mode.
In-Reply-To: <518A6C21.5070408@candelatech.com>
References: <5189DB72.3020809@candelatech.com>
	<20873.56643.216380.594657@gargle.gargle.HOWL>
	<518A6C21.5070408@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Yes, both AP and Station machine are ath9k, 3.9.0+, etc....
> 
> Basically identicaly hardware and software loads..just one is acting as AP
> and one as station(s) in this scenario.

Works okay here.

STA1 <-> AP <-> STA2 (ath9k stations, ath9k AP running OpenWrt trunk).

Voice traffic from STA1 to STA2 and in the other direction are marked
as VO in the AP.

root@OpenWrt:/# cat /sys/kernel/debug/ieee80211/phy1/ath9k/xmit 
                            BE         BK        VI        VO

MPDUs Queued:              411          0         0   1780727
MPDUs Completed:           411          0         0   1780659
MPDUs XRetried:              0          0         0         2
Aggregates:             111093          0         0         0
AMPDUs Queued HW:        21843          0         0         0
AMPDUs Queued SW:      2297530          0         0         0
AMPDUs Completed:      2319373          0         0         0
AMPDUs Retried:          28995          0         0         0
AMPDUs XRetried:             0          0         0         0
TXERR Filtered:              0          0         0       217
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:           2319784          0         0   1780661
TX-Bytes-All:        455830482          0         02734843421
HW-put-tx-buf:          153471          0         0    263350
HW-tx-start:                 0          0         0         0
HW-tx-proc-desc:        153681          0         0   1780661
TX-Failed:                   0          0         0         0

Sujith
