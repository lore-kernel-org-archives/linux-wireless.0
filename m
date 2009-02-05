Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZBEQNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 11:13:35 -0500
Message-Id: <20090205160738.990564487@sipsolutions.net> (sfid-20090205_171347_265481_1C63CB85)
Date: Thu, 05 Feb 2009 17:07:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/11] mac80211 aggregation cleanups/fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few previously posted, now rebased, patches for
mac80211 aggregation. This is mostly preparatory for getting
Intel aggregation working again, which is working for me but
right now I'm unclear what sort of internal validation Intel
folks want to do (and I hear there was one issue in testing)

This series contains:
 * remove stray aggregation debugfs definition
   - nothing really interesting

 * fix RX aggregation timeouts
   - timeout calculations fixed to use TU not ms

 * restructure HT code
   - make the whole thing easier to work on

 * restrict aggregation to supported interface modes
   - only allow aggregation for AP/VLAN/STA

 * hardware should not deny going back to legacy
   - remove the -EBUSY special case

 * document TX aggregation (and small cleanup)
   - some documentation, a little cleanup

 * fix race in TX aggregation
   - race fix

 * fix aggregation timer lockups
   - fix a timer lock inversion problem
     (I think there's another one somewhere)

 * clean up BA session teardown
 * RX aggregation: clean up stop session
 * further cleanups to stopping BA sessions
   - cleanups

johannes

