Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:41328 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932442Ab3FRQsP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 12:48:15 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <i@lri.fr>)
	id 1Uoz4n-0003iL-6e
	for linux-wireless@vger.kernel.org; Tue, 18 Jun 2013 18:48:13 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.80)
	(envelope-from <i@lri.fr>)
	id 1Uoz4m-00006I-8J
	for linux-wireless@vger.kernel.org; Tue, 18 Jun 2013 18:48:12 +0200
Date: Tue, 18 Jun 2013 18:48:12 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: ath9k_htc: station unable to authenticate
Message-ID: <20130618164812.GA32498@zenon.in.qult.net> (sfid-20130618_184821_432259_308989DA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After a lot of git-bisecting and other testing, it appears that commit
382a103b2b528a3085cde4ac56fc69d92a828b72 is the culprit.

To reproduce the problem, use backports-20130607, and the ath9k defconfig
(with no change otherwise).

The station is unable to authenticate with WPA2 to the AP.  Interestingly
enough, if a monitor vif is created and upped beforehand, the authentication
succeeds.

After reverting the commit, authentication succeeds very quickly (without the
need to up a monitor vif), just as expected.

Note that I have kernel 3.8.0 (as per Ubuntu 13.04) and that original
ath9k_htc driver works as expected.  This has been also tested on Debian with
driver from original kernel 3.9 (i.e. without backports).

For the moment I can live with the commit reverted, but I suppose it's been
there to fix something else, so this should probably be looked into by someone
more knowledgeable than me.

Ignacy

-- 
A person is shit's way of making more shit.
		-- S. Barnett, anthropologist.
