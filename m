Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:47044 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbcECHAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 03:00:41 -0400
From: Martin Willi <martin@strongswan.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/2] wireless: Allow wiphy/hwsim management from user namespaces
Date: Tue,  3 May 2016 08:53:16 +0200
Message-Id: <1462258398-6749-1-git-send-email-martin@strongswan.org> (sfid-20160503_090055_364271_9AD686F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set enables user namespaces having CAP_NET_ADMIN to manage
wiphy devices and create/destroy hwsim radios.

The first patch allows a caller from a non-initial user namespace to run
privileged nl80211 phy/dev operations. The second patch enables hwsim
radio management over Netlink from such namespaces. Together, with these
patches an unprivileged test environment can create user/network
namespaces and set up abitrary simulated wireless networks.

Martin Willi (2):
  nl80211: Allow privileged operations from user namespaces
  mac80211_hwsim: Allow managing radios from non-initial namespaces

 drivers/net/wireless/mac80211_hwsim.c |  88 +++++++++++++++++++-
 net/wireless/nl80211.c                | 150 +++++++++++++++++-----------------
 2 files changed, 160 insertions(+), 78 deletions(-)

--
2.7.4
