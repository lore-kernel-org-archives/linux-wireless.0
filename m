Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48608 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab1KWPEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:04:51 -0500
Received: by vcbfk14 with SMTP id fk14so399943vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:04:51 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 0/2] cfg80211: two stable fixes
Date: Wed, 23 Nov 2011 10:04:45 -0500
Message-Id: <1322060687-6512-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_160455_020328_C7E1B7AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, here's two stable fix patches I had mentioned. The first
one addresses a race but also makes it easier to fix the issue
Johannes had reported if request_wiphy being NULL on __set_regdom().
Since Johannes' patch is  merged already this series ammends his
fix but the first patch needs to be applied in order to take advantage
of the clearing of the stale last_request through reset_regdomains().

I'm submitting these as RFCs as I have only test compiled this stuff
but we need a fix soon so sending out ASAP for review.

Luis R. Rodriguez (2):
  cfg80211: fix race on init and driver registration
  cfg80211: amend regulatory NULL dereference fix

 net/wireless/reg.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

-- 
1.7.4.15.g7811d

