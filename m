Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab2EJUdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 16:33:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SSa3S-0005kT-Ej
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 22:33:42 +0200
Message-Id: <20120510203021.240931880@sipsolutions.net> (sfid-20120510_223347_307624_28E76B25)
Date: Thu, 10 May 2012 22:30:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] simplify AP channel setting
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For AP and mesh interfaces userspace currently sets
the channel before the interface is even operating.
This isn't really the best API for all drivers, e.g.
ath6kl just has to store it until the AP is really
started. Similarly, for future multi-channel work it
would be better to only commit to the channel when
starting the AP.

I haven't tested this yet, but I think it's the right
way to go. Note how ath6kl is really simplified by it.

johannes
