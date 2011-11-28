Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61184 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1K1VbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:31:15 -0500
Received: by vbbfc26 with SMTP id fc26so4187503vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 13:31:14 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH v2 0/2] cfg80211: reg fixes
Date: Mon, 28 Nov 2011 16:31:08 -0500
Message-Id: <1322515870-3392-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_223123_127288_41EF7D3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a series of reg fixes, I'm sending these separate from the
other patches given that we need these fixes merged soon. I'm sending
this on top of what I see right now on wireless-testing which is
that Johannes' patch is not yet reverted so ammending his fix.

I address the issue pointed out by Timo by passing a parameter
for reset_regdomains() and only do a full reset on
restore_regulatory_settings() and on __exit().

Luis R. Rodriguez (2):
  cfg80211: fix race on init and driver registration
  cfg80211: amend regulatory NULL dereference fix

 net/wireless/reg.c |   53 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 18 deletions(-)

-- 
1.7.4.15.g7811d

