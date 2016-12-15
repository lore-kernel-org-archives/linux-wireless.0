Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25122 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935003AbcLOGAx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 01:00:53 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [RFC 0/3] Add new data path for ethernet frame format
Date: Thu, 15 Dec 2016 11:30:05 +0530
Message-ID: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20161215_070106_681074_D612E423)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set adds a new data path to offload 802.11 header
encap/decap to driver or hardware. Drivers having support
for ieee80211 header encap/decap and other offload functionalities
which can't be done before encap or after decap can make use of
this new data path. Currently it is implemented for STA and AP
interface type, this can be extend other interface types like
adhoc.  

With ath10k driver changes using this new Tx/Rx path, 10 - 15%
CPU usage and upto ~20Mbps TCP performance improvements are
observed with this ethernet data path. This patch set is
prepared on a older mac80211 code base on top of
commit 7d27a0ba7adc ("cfg80211: Add mesh peer AID setting API").
Sorry, I could not get a chance to rework it on top of latest
mac80211 code base.

TODO (from initial review):

	- Consider ieee8011 header and cipher header size also while updating tx/rx stats for
	  ethernet frame format.
	- Any optimization to reduce the amount of code change.
	- Improve commit log and doc

Vasanthakumar Thiagarajan (3):
  mac80211: Add provision for 802.11 encap/decap offload
  mac80211: Implement data xmit for 802.11 encap offload
  mac80211: Add receive path for ethernet frame format

 include/net/mac80211.h     |  68 +++++++++++++-
 net/mac80211/cfg.c         |   8 ++
 net/mac80211/debugfs.c     |   1 +
 net/mac80211/driver-ops.h  |  21 +++++
 net/mac80211/ieee80211_i.h |  12 +++
 net/mac80211/iface.c       | 147 +++++++++++++++++++++++++++++
 net/mac80211/key.c         |  16 +++-
 net/mac80211/main.c        |   7 ++
 net/mac80211/rx.c          | 189 ++++++++++++++++++++++++++++++++++++-
 net/mac80211/status.c      |  83 ++++++++++++++++-
 net/mac80211/trace.h       |  33 +++++++
 net/mac80211/tx.c          | 225 ++++++++++++++++++++++++++++++++++++++++++++-
 12 files changed, 800 insertions(+), 10 deletions(-)

-- 
1.9.1
