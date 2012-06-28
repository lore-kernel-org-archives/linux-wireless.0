Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:57919 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738Ab2F1KHV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 06:07:21 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] respect channels in iface combinations
Date: Thu, 28 Jun 2012 12:06:52 +0200
Message-ID: <1340878025-2695-1-git-send-email-michal.kazior@tieto.com> (sfid-20120628_120725_496053_A9CE008C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patchset introduces channel tracking per interface which is needed
to start enforcing num_different_channels in interface combinations.
Changes to monitor mode behaviour is also required for sane channel
accounting (considering how mac80211 handles monitor interfaces).

This prepares cfg80211 for multi-channel operation.

Remaining issue that needs addressing at a later time is CSA handling
(which is already broken anyway).

Changes since RFC v3:
 * fixed nla_put error handling
 * BUG_ON replaced with a return -EBUSY


-- Pozdrawiam / Best regards, Michal Kazior.

