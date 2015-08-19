Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:11337 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbbHSM74 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 08:59:56 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: ido@wizery.com, netdev@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC v2 0/3] add TSO / A-MSDU TX for iwlwifi
Date: Wed, 19 Aug 2015 15:59:38 +0300
Message-Id: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150819_150050_329918_8FAC69B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

We could have enabled A-MSDU based on xmit-more, but the
rationale of using LSO is that when using pfifo-fast,
the Qdisc gets one packet and dequeues is straight away
which limits the possibility to get a lot of packets at
once. (Am I right here?).

A note about A-MSDUs for non-wireless people:
*********************************************
An A-MSDU is a aggregated frame. It is one big 802.11
packet that contains several subframes. Each subframe
is a TCP segment. One A-MSDU is represented by one single
skb which means that we need to copy / duplicate the TCP
/ IP / SNAP headers in one single skb. This is why those
headers are copied to a separate page: that page is added
multiple times to the skb with different offsets. Each
subframes needs at least 2 frags: 1 for the headers, 1 (or
more) for the payload.

I am quite a newbie in skb handling, so I guess that this
code can be improved. I have tested it decently using iperf,
but this doesn't mean that there are no issues using other
applications. We are enabling pktgen on TCP (using patches
that were sent a year ago or so) to test the different
layouts of the skb (payload partition amongst the header
and the different frags).

I'll be very happy to get comments on that code, this is
why I am sending it to netdev as well since the TSO experts
are there :)

Emmanuel Grumbach (3):
  iwlwifi: mvm: add real TSO implementation
  iwlwifi: mvm: allow to create A-MSDUs from a large send
  iwlwifi: mvm: transfer the truesize to the last TSO segment

 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   3 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c      |   4 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h      |   6 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 669 ++++++++++++++++++++++++++--
 4 files changed, 647 insertions(+), 35 deletions(-)

-- 
2.1.4

