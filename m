Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab2CLMwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 08:52:00 -0400
Message-Id: <20120312124912.474580156@sipsolutions.net> (sfid-20120312_135206_763193_476DC6E3)
Date: Mon, 12 Mar 2012 13:49:12 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] optimize non-linear RX
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was debugging something with non-linear RX and noticed
that all frames, even hw-decrypted ones, are completely
linearized. This was because in crypto, not linearizing
hadn't been pushed through to where needed and we would
always linearize if if only the replay counters had to
be checked.

Fix that and hopefully improve performance that way.

johannes
