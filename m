Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab2GFVFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 17:05:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SnFiY-0002aF-9Y
	for linux-wireless@vger.kernel.org; Fri, 06 Jul 2012 23:05:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/3] mac80211 scanning restructuring
Date: Fri,  6 Jul 2012 23:05:30 +0200
Message-Id: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net> (sfid-20120706_230540_209882_E0AA5747)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I decided that with multi-channel coming and thus us using more
virtual interfaces, the scanning code was going to be the first
victim of some factoring ;-)

Please review. The only thing that isn't quite clear to me is
whether or not I can really remove the channel == oper_channel
check, but it's only applied to probe resp/beacon frames so it
seems a bit pointless to try to keep it?

johannes

