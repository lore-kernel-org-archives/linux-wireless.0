Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59212 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934691AbcA0TBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 14:01:40 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] ath10k: rename mesh and add abstraction layer
Date: Wed, 27 Jan 2016 10:55:53 -0800
Message-ID: <1453920957-9908-1-git-send-email-poh@qca.qualcomm.com> (sfid-20160127_200208_023921_14C6F8DE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split Mesh service to 11s Mesh and non-11s Mesh according to
firmware service bit to help users distinguish 11s Mesh from
non 11s Mesh.
And add abstraction layer for vdev subtype to solve subtype mismatch
and to give flexible compatibility among different firmware revisions.

Peter Oh (4):
  ath10k: rename Mesh related service names
  ath10k: update 10.4 WMI service map
  ath10k: use vif->type and vif->p2p for P2P_GO check
  ath10k: add abstraction layer for vdev subtype

 drivers/net/wireless/ath/ath10k/mac.c     | 25 +++++------
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 11 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     | 72 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     | 69 +++++++++++++++++++++++------
 5 files changed, 153 insertions(+), 25 deletions(-)

-- 
1.9.1

