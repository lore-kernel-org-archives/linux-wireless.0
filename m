Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2L1JJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 04:09:22 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ToVwN-0005mL-AE
	for linux-wireless@vger.kernel.org; Fri, 28 Dec 2012 10:09:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211: refine TX aggregation session stop handling
Date: Fri, 28 Dec 2012 10:09:37 +0100
Message-Id: <1356685781-6758-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_100936_158377_93399A38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We ran into problems when an aggregation session is stopped
when disconnecting, we can't clean it up completely and drop
all packets right away because we don't know this is valid
but when we don't doing it later when the station is removed
gets tricky.

To solve this, split out the STOP action into the different
kinds of stop: "stop and continue transmitting" (normal stop),
"stop and flush packets" (connection drop) and "stop and flush
a previously stopped session" (can happen when the connection
drops while a session is still stopping.)

johannes

