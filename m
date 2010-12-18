Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab0LRQXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 11:23:13 -0500
Message-Id: <20101218162046.876589704@sipsolutions.net>
Date: Sat, 18 Dec 2010 17:20:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] mac80211: hw offload for remain-on-channel
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds functionality to enable remain-on-channel
hardware offload to mac80211 drivers. Any frames
transmitted during that time on the r-o-c channel
get a new TX flag and must be transmitted correctly
by the driver -- any other activity isn't stopped,
so the device must have different queues for the
different channels with the driver managing it.

johannes

