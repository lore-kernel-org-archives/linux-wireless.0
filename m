Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37228 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbdIOKSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 06:18:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <johannes@sipsolutions.net>)
        id 1dsnhM-0006UH-6D
        for linux-wireless@vger.kernel.org; Fri, 15 Sep 2017 12:18:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/4] cfg80211: in-kernel regulatory database
Date: Fri, 15 Sep 2017 12:18:06 +0200
Message-Id: <20170915101810.11435-1-johannes@sipsolutions.net> (sfid-20170915_121816_243861_053989BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been sitting on these patches for pretty much 2 years, waiting
for the firmware loader to gain signature checking abilities. This
hasn't happened, and even the suggested code from AKASHI Takahiro
doesn't fulfill all requirements, notably having extra keys/keyring.

I'm not sure building the keys into the module really is the best
option, but then again, that's the same way it's done with crda.

Additionally, we've not been able to extend the regulatory database
format, and for even longer we've been wanting to do that, e.g. to
add spectral density power limits and DFS configuration. Since the
new database format is easily extensible (variable size on all of
the structures used, with only the minimum size being required), the
extensions can finally be done with this.

johannes
