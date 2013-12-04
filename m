Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3LDVaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 16:30:15 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VoK1N-0004eh-SN
	for linux-wireless@vger.kernel.org; Wed, 04 Dec 2013 22:30:14 +0100
Message-ID: <1386192610.5660.4.camel@jlt4.sipsolutions.net> (sfid-20131204_223020_487440_79922990)
Subject: question for mac80211 driver maintainers - RCU usage in drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 04 Dec 2013 22:30:10 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Except for iwlmvm, I don't find much RCU usage wrt. stations in drivers.

Is there any other driver that assumes it is safe to delete a station
pointer in the sta_state callback and not use synchronize_rcu()? From
looking at the code, I don't see any, but I can't really be sure that
everyone uses __rcu annotations correctly ... :)

Would anyone object if we changed mac80211 to *immediately* free the
station after calling the driver's sta_state (or sta_remove) callback?
We currently delay this until after an RCU grace period, but that way we
end up having a lot of delay in station freeing ... We'd like to
optimise that.

johannes

PS: I'll probably have to add another callback "sta going away before
RCU" so you can invalidate pointers there ... otherwise I'd have to
synchronize_rcu() in iwlmvm which would kinda defeat the purpose.

