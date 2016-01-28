Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19212 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbcA1V5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 16:57:12 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 0/4] ath10k: rename mesh and add abstraction layer
Date: Thu, 28 Jan 2016 13:54:06 -0800
Message-ID: <cover.1454015989.git.poh@qca.qualcomm.com> (sfid-20160128_225716_234753_B13D6E3C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split Mesh service to 11s Mesh and non-11s Mesh according to
firmware service bit to help users distinguish 11s Mesh from
non 11s Mesh.
And add abstraction layer for vdev subtype to solve subtype mismatch
and to give flexible compatibility among different firmware revisions.

v2:
 * Rebased. No code changes.

Peter Oh (4):
  ath10k: rename Mesh related service names
  ath10k: update 10.4 WMI service map
  ath10k: use vif->type and vif->p2p for P2P_GO check
  ath10k: add abstraction layer for vdev subtype

 drivers/net/wireless/ath/ath10k/mac.c     | 25 +++++------
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 11 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     | 72 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     | 67 ++++++++++++++++++++++------
 5 files changed, 151 insertions(+), 25 deletions(-)

-- 
1.9.1

