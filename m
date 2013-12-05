Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab3LEMgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:04 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VoY9w-0006OG-E7
	for linux-wireless@vger.kernel.org; Thu, 05 Dec 2013 13:36:00 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] mac80211: speed up station cleanup/AP shutdown
Date: Thu,  5 Dec 2013 13:35:48 +0100
Message-Id: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133615_238897_7D79C534)
In-Reply-To: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inspired by hostap shutdown potentially taking a long time (which is
in part also its fault), I took a closer look at the station removal
code and I think it's too complex. Only a single driver (iwlmvm) has
a need for an RCU grace period after sta_state() returns, and that
can easily be addressed differently.

So consolidate many of the synchronize_rcu()/_net() in these paths
and get rid of the rcu_barrier() stuff completely.

Testing is still pending, but it should improve timing.

johannes

