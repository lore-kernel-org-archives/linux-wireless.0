Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:48540 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbA3JsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 04:48:20 -0500
Received: by mail-we0-f178.google.com with SMTP id k48so26083800wev.9
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 01:48:19 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] ath10k: implement fw stats for wmi-tlv
Date: Fri, 30 Jan 2015 10:47:20 +0100
Message-Id: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com> (sfid-20150130_104825_698752_1270236E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some slight differences in fw stats
(sic) in wmi-tlv.

Firmware has changed the querying scheme and no
longer requires the ping-pong to get all stats.
The patchset doesn't change this behaviour so with
wmi-tlv it's possible to see the following
warnings when reading fw stats:

 ath10k_pci 0000:00:06.0: received unsolicited stats update event

The logic in ath10k still produces correct results
so this is harmless.

I wonder how to deal with this in a sane way. An
`if (op_ver == WMI_TLV)` is a little bad but
having a new ar->fw_feature flag just for a debug
facility like this is a bit silly. Or we can just
drop the warning and leave a comment. Ideas?


Michal Kazior (4):
  ath10k: add vdev stats processing
  ath10k: change request stats command prototype
  ath10k: add more wmi fw stat defines
  ath10k: implement fw stats for wmi-tlv

 drivers/net/wireless/ath/ath10k/core.h    |  20 +++++
 drivers/net/wireless/ath/ath10k/debug.c   | 101 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   7 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 117 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |   9 +++
 drivers/net/wireless/ath/ath10k/wmi.c     |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |  10 ++-
 7 files changed, 254 insertions(+), 17 deletions(-)

-- 
1.8.5.3

