Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61543 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab2AIHrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 02:47:45 -0500
From: Thirumalai <tpachamu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Thirumalai <tpachamu@qca.qualcomm.com>
Subject: [PATCH 0/4] Enable uAPSD support in AP mode
Date: Mon, 9 Jan 2012 13:14:43 +0530
Message-ID: <1326095083-1538-1-git-send-email-tpachamu@qca.qualcomm.com> (sfid-20120109_084754_846351_9C65331D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In addition to legacy power save, this series of patch adds
support for uAPSD in AP mode.

When connected station goes into suspend state, the driver will
start queuing pkts in the separate queue (called uapsd queue)
until the station ask for it. 

The moment driver starting queuing, it will enable traffic indication
bit for the client connected to indicate data availability. 
Once station ask for the data (via Trigger frame), the driver will 
dequeue and send pkt one by one to the station.

Thirumalai (4):
  ath6kl: Add new WMI functions for uAPSD
  ath6kl: Introduce new queue for uAPSD.
  ath6kl: Add uAPSD support in rx path.
  ath6kl: Add UAPSD support in tx path.

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +
 drivers/net/wireless/ath/ath6kl/core.h     |    6 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    8 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |  258 ++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |   62 ++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   50 +++++-
 6 files changed, 339 insertions(+), 51 deletions(-)

