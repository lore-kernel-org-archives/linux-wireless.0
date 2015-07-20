Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbbGTTnQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 00/10] Add TSO and Tx A-MSDU for iwlwifi 
Date: Mon, 20 Jul 2015 22:42:54 +0300
Message-Id: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214326_555405_C96C33CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is really just an RFC: it won't work as
is. I just wanted to share early what we have in the pipe.
We enable TSO to get a lot of data at once to build A-MSDUs.
Our hardware doesn't have (yet) TCP CSUM offload, so we do
it manually. TSO won't be enabled on hardware that don't
support CSUM offload in release code, computing TCP CSUM
in the driver is just a way to start coding the flows.
This is why the "CSUM offload" implementation in the driver
in so bad in terms of efficiency. I preferred to have the
flows as close as they will be when the hardware will be
able to the CSUM than to try to seek efficiency.
The hardware that will have CSUM offload will still require
the driver to split the skb in software including the
IP / TCP header copy and update etc...

I am pretty much a newbie in all the netstack stuff, so
I am certain that people out there will have remarks which
I will be more than happy to hear.
I know that I can use more skb APIs instead of reinventing
the wheel, OTOH, for most of the cases, the code was hacky
enough to make it easier to touch the skb members than to
use the API functions.
Of course, suggestions are most welcome.

I ran quite a bit of testing on that code. I could run
long iperf sessions with lots of A-MSDUs in the air.
Corner cases are still failing. E.g. if you put a very
small MSS so that the number of DMA descriptors for an
A-MSDU starts to be the limit, then at some point, I blow
up.

Emmanuel Grumbach (8):
  mac80211: allow the driver to adverise A-MSDU within A-MPDU Rx support
  mac80211: allow to transmit A-MSDU within A-MPDU
  mac80211: limit the A-MSDU based on the Extended Capabilities element
  iwlwifi: mvm: don't adverise SUPPORTS_CLONED_SKBS anymore
  iwlwifi: mvm: support TSO
  iwlwifi: mvm: add support for A-MSDU Tx
  iwlwifi: mvm: allow to configure the maximal size of an A-MSDU
  iwlwifi: don't send A-MSDU when not allowed by peer

Johannes Berg (2):
  iwlwifi: mvm: pretend to have CSUM OFFLOAD
  iwlwifi: mvm: move TX PN assignment for CCMP to the driver

 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |   2 +-
 drivers/net/wireless/iwlwifi/mvm/constants.h |   1 +
 drivers/net/wireless/iwlwifi/mvm/debugfs.c   |  19 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |  17 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  16 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c       |   6 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h       |   6 +-
 drivers/net/wireless/iwlwifi/mvm/tdls.c      |  12 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c        | 666 ++++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.c        |   2 +-
 include/linux/ieee80211.h                    |   9 +
 include/net/mac80211.h                       |  14 +-
 net/mac80211/agg-rx.c                        |   8 +-
 net/mac80211/agg-tx.c                        |  15 +-
 net/mac80211/cfg.c                           |  23 +
 net/mac80211/debugfs.c                       |   1 +
 net/mac80211/driver-ops.h                    |   7 +-
 net/mac80211/sta_info.h                      |   2 +
 net/mac80211/trace.h                         |  10 +-
 net/mac80211/vht.c                           |  16 +
 20 files changed, 795 insertions(+), 57 deletions(-)

-- 
2.1.4

