Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab2KEOkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 09:40:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TVNqR-0002rE-W0
	for linux-wireless@vger.kernel.org; Mon, 05 Nov 2012 15:40:08 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] mac80211: client-side P2P powersave
Date: Mon,  5 Nov 2012 15:40:43 +0100
Message-Id: <1352126445-25088-1-git-send-email-johannes@sipsolutions.net> (sfid-20121105_154021_900032_74F25FFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement passing the P2P powersave parameters (except NoA
schedules) to the mac80211 hardware driver. To do this, I
introduced a generic function to get a copy of some P2P
attribute into a buffer, I did it that way because of the
potential for fragmentation into multiple IEs.

The only change over the RFC is that I now use the correct
attribute ID definition from Arend's patch.

johannes

