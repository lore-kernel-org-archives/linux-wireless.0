Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538Ab2FTOdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 10:33:32 -0400
Date: Wed, 20 Jun 2012 16:33:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: WEP-LEAP regression
Message-ID: <20120620143330.GA8505@redhat.com> (sfid-20120620_163336_087749_7A317AF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our QA reported regression on ath9k connecting to legacy WEP-LEAP AP,
with the following supplicant parameters:

fast_reauth=1
ap_scan=1

eapol_version=1

network={
        ssid="qe-wep-enterprise-cisco"
        key_mgmt=IEEE8021X
        auth_alg=LEAP
        eap=LEAP
        identity="AAA"
        password="BBB"
}

Device associate but DHCP fails (we do no recive any frame).

Reverting both related commits:

commit f88373fa47f3ce6590fdfaa742d0ddacc2ae017f
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sun Feb 5 21:15:17 2012 +0100

    ath9k: fix a WEP crypto related regression

and
 
commit 7a532fe7131216a02c81a6c1b1f8632da1195a58
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sat Jan 14 15:08:34 2012 +0100

    ath9k_hw: fix interpretation of the rx KeyMiss flag

fixes the problem.

Felix could you look at this?

Stanislaw
