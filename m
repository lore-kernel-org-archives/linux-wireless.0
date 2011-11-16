Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab1KPO3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:29:47 -0500
Message-Id: <20111116142854.518391560@sipsolutions.net> (sfid-20111116_152951_065321_9D0D4A0A)
Date: Wed, 16 Nov 2011 15:28:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] submit fragmented packets to drivers at once
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is something I have wanted to do for a while -- many
drivers can handle multiple fragments at once much easier
than getting every single one at a time.

I've long thought about how to do this best and arrived at
the conclusion now that simply adding a compat handler for
tx_frags (which mac80211 uses) is best.

Tested on iwlagn with the compat handler, will use the new
tx_frags soon I hope.

johannes

