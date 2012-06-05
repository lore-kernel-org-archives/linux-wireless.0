Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2FEMbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 08:31:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SbsvG-0008HZ-88
	for linux-wireless@vger.kernel.org; Tue, 05 Jun 2012 14:31:42 +0200
Message-Id: <20120605122839.664762975@sipsolutions.net> (sfid-20120605_143147_354847_A5311F2E)
Date: Tue, 05 Jun 2012 14:28:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211 remain-on-channel unification
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We found major bugs with the mac80211 ROC code in
particular in the offloaded case.

As a result, I've decided to get rid of the pseudo-
generic "off-channel work" code since it's not used
any more except for remain-on-channel and instead
have written new ROC support that is more unified
between SW and HW implementations, in particular
wrt. merging etc.

This is also going to be the long-term trend: with
multi-channel getting closer, we don't want to have
to deal with this in mac80211 as much any more as
it's all timing sensitive.

johannes

