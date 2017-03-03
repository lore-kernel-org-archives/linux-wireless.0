Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37332 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdCCLjG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 06:39:06 -0500
From: <mpubbise@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
Subject: [RFCv2 0/2] Add new transmit data path for ethernet frame format
Date: Fri, 3 Mar 2017 17:03:25 +0530
Message-ID: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20170303_123946_457729_1DC9A892)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>

This patch set adds a new transmit data path to offload 802.11 header
encap to driver/hardware. Drivers having support for ieee80211
header encap and other offload functionalities which can't be done
before encap can make use of this new data path. Currently it is
implemented for STA and AP interface type, this can be extend other
interface types like adhoc.

This patchset only adds support for tx in ethernet frame format
and receive can happen in 802.11 format with existing rx framework.

With ath10k driver changes using this new Tx/Rx path, 10 - 15%
CPU usage and upto ~20Mbps TCP performance improvements are
observed with this ethernet data path.

Vasanthakumar Thiagarajan (2):
  mac80211: Add provision for 802.11 encap offload
  mac80211: Implement data xmit for 802.11 encap offload

V2:
 * 802.11 decap offload is removed from the patchset
 * Code changes as per review comments of v1.

 include/net/mac80211.h     |   30 ++++++-
 net/mac80211/cfg.c         |    9 ++
 net/mac80211/debugfs.c     |    1 +
 net/mac80211/ieee80211_i.h |   10 +++
 net/mac80211/iface.c       |   72 +++++++++++++++
 net/mac80211/key.c         |    3 +
 net/mac80211/status.c      |   79 +++++++++++++++++
 net/mac80211/tx.c          |  207 +++++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 406 insertions(+), 5 deletions(-)

-- 
1.7.9.5
