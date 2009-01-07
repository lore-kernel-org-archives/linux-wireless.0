Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34001 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZAGL1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 06:27:37 -0500
Message-Id: <20090107112346.369581673@atheros.com> (sfid-20090107_122743_074542_EE9618F4)
Date: Wed, 07 Jan 2009 13:23:46 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/14] mac80211: IEEE 802.11w (management frame protection)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches adds support for IEEE 802.11w (management frame
protection) into mac80211. It is up-to-date with the latest IEEE 802.11w
draft (D7.0) and I do not expect any major changes to IEEE 802.11w
anymore.

This version is ready to be applied into wireless-testing.

Differences to the last RFC round:
- rebase against current wireless-testing + CSA patch from Sujith (it
  is also allocating a new flag and would have conflicted with the
  previous MFP patches)
- fix ieee80211_is_robust_mgmt_frame() for encrypted (on RX) frames
  (must not check Category field for them since it may be encrypted)
- add a new option for CCMP hwaccel keys to allow the driver to request
  management frame crypto be done in mac80211 if needed
- update ath9k to support MFP

-- 
Jouni Malinen                                            PGP id EFC895FA
