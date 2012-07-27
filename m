Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2G0LC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:02:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SuiJr-0005uM-4H
	for linux-wireless@vger.kernel.org; Fri, 27 Jul 2012 13:02:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] P2P Device abstraction
Date: Fri, 27 Jul 2012 13:02:48 +0200
Message-Id: <1343386972-5044-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130300_181466_224ED178)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've now given this more testing and it appears to work,
so I'm reposting for comments and will apply the patches
next week.

The idea is that now a P2P Device will get its own virtual
interface, allowing the driver to determine the MAC address
to use and also handle better internally when to expect any
remain-on-channel calls for P2P.

The required wpa_s patches are still WIP, but have gotten
far enough for some testing.

Obviously, I also have an iwlwifi patch to use this since
that's where I needed it first.

However, I think that e.g. Broadcom would be interested in
this and the wpa_s changes since it would allow using any
MAC address for the P2P Device by separating the P2P Device
from wlan0.

johannes

