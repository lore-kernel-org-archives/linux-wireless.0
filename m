Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54936 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269AbZEKS6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 14:58:49 -0400
Message-Id: <20090511185754.653711567@atheros.com>
Date: Mon, 11 May 2009 21:57:54 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] nl80211/mac80211: Fix station mode key setup issues 
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using nl80211, we cannot currently set drop_unencrypted flag that
was used with WEXT to avoid need for IEEE 802.1X port control in station
mode. Because of this, we cannot currently set the keys in a secure way.
In addition, we do not support setting the expected RSC for keys either
with WEXT or nl80211 which is needed to avoid leaving a window for
replaying broadcast frames.

This set of patches addresses these issues and allows nl80211 to
securely set up keys in station mode. This is on top of the pending
MFP patches, RX-drop-unencrypted-based-on-key-setup, and WEXT key
handling to cfg80211 patches (from Johannes).

-- 
Jouni Malinen                                            PGP id EFC895FA
