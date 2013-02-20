Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab3BTIkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 03:40:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U85ED-0005ij-TX
	for linux-wireless@vger.kernel.org; Wed, 20 Feb 2013 09:40:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.9 0/2] avoid nl80211 message size overrun
Date: Wed, 20 Feb 2013 09:40:32 +0100
Message-Id: <1361349634-9669-1-git-send-email-johannes@sipsolutions.net> (sfid-20130220_094044_202127_7E3F2397)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Depending on the device configuration, the radar and TCP wake
information (radar is fairly large, ~192 bytes for the typical
case of 12 DFS channels, some devices have more DFS channels)
the netlink default message size limit can be exceeded causing
wpa_supplicant to not initialize the device at all.

Since both TCP WoWLAN and radar detection aren't supported by
any current drivers and userspace apps remove the two features
for 3.9 to avoid getting close to the size limit when they are
implemented; we'll add them back again for 3.10 with the split
wiphy dump feature.

johannes

