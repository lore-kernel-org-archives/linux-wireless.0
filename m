Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0CLBEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 20:04:30 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org, stable@kernel.org
Cc: linux-kernel@vger.kernel.org, linville@tuxdriver.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [FYI] cfg80211: cfg80211: fix suspend/resume case when world roaming
Date: Thu, 11 Mar 2010 20:04:30 -0500
Message-Id: <1268355870-1496-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a heads up to distribution maintainers, for 2.6.33 has an issue
with suspend and resume and world roaming when you move from one AP
with one set of regulatory settings to another. The issue happens when for
example if a user from JP travels to the US and connects to an AP
which disables channel 13, they suspend and go home, and resume
channel 13 will still be disabled. This has been fixed on 2.6.34
but the fix was rather large for propagating to stable but if you do
wnat the fix I have backported them for you.

These patches have been baking on wireless-testing, linux-next, and
now upstream 2.6.34-rc1 for a while now. You can find them here:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/cfg80211/2010-03/reg-fixes-33/02-suspend-resume-regulatory/

Luis R. Rodriguez (2):
  cfg80211: avoid flushing the global workqueue for core reg hints
  cfg80211: add regulatory hint disconnect support

 include/net/regulatory.h |    1 +
 net/wireless/reg.c       |  162 ++++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/reg.h       |   18 +++++
 net/wireless/sme.c       |   40 +++++++++++
 4 files changed, 215 insertions(+), 6 deletions(-)

