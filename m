Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:61351 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2FSAUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 20:20:00 -0400
Message-ID: <4FDFC5AE.1080004@opentechinstitute.org> (sfid-20120619_022004_773957_8DA0C700)
Date: Mon, 18 Jun 2012 20:19:58 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linville@tuxdriver.com
Subject: [PATCH 0/2 v3] mac80211/cfg80211: add support for userspace to handle
 auth frames on adhoc ifaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I am sending along 2 patches to add support for user space applications
to register for authentication frames on adhoc interfaces. These are
revisions to a previous patch that I submitted to accomplish the same
thing.

Patch 1/2 adds a cfg80211_mgmt_reg_match function to cfg80211 to
check whether a user space application is registered for a particular
type of management frame rx'd on a particular device. The new function
is very similar to cfg80211_rx_mgmt. cfg80211_rx_mgmt could not be
reused because of its side-effect of transmitting the "query" frames to
the registered userspace applications. This patch modifies the
documentation for cfg80211_rx_mgmt to reflect that.

Patch 2/2 sets the necessary flags to allow userspace
applications to register for authentication frames on adhoc interfaces.
It also adds a check to make sure that "open" authentication frames are
not sent when a user space application is registered for authentication
frames.

As I've said before, I'm still new to this process so I look forward to
your feedback on improving.

Will
