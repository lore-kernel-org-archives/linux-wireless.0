Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2CONaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 09:30:16 -0400
Subject: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 14:30:14 +0100
Message-ID: <1331818214.3432.12.camel@jlt3.sipsolutions.net> (sfid-20120315_143021_596556_86CB54CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The commit "mac80211: stop tx before doing hw config and rate
update" (and a later commit fixing it) introduced a queue stop & flush
on switching 20/40.

I'm working on not calling hw_config() for switching between 20/40 but
instead only calling rate_control_rate_update() and
ieee80211_bss_info_change_notify() to tell the rate control and driver.

If we do that, is it still necessary to stop the queues for it? It seems
like it shouldn't.

johannes

