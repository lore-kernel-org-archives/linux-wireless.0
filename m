Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43156 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbbCTPY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 11:24:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1YYymh-0003Np-0Z
	for linux-wireless@vger.kernel.org; Fri, 20 Mar 2015 16:24:27 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211: TX station lookup improvements
Date: Fri, 20 Mar 2015 16:24:20 +0100
Message-Id: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net> (sfid-20150320_162431_815553_A8F89A37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While thinking about a "TX fastpath" for data frames, I realized that
we have a number of inefficiencies when looking up stations, as we do
this up to three times.

Remove this and just do the lookup once for each frame.

johannes

