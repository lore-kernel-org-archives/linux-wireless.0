Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52840 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaDVDjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 23:39:44 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so4415386pab.22
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 20:39:44 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, lkml20140418@newton.leun.net,
	arik@wizery.com, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH 0/2] cfg80211: two reg fixes
Date: Mon, 21 Apr 2014 20:39:33 -0700
Message-Id: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140422_053947_047577_2EEF9773)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This rebases Arik's patch to apply first and then piggy back
the non modular fix on top of that. I think you all have
more fancy things to test this series than I do now.

Michael Leun <lkml20140418@newton.leun.net> you reported a regression
with commit 2a901468c221e778af52603e006a53 on v3.14, I however cannot
see how that commit caused the issue you reported, can you test this
patch ported onto v3.14? A port is here:

http://drvbp1.linux-foundation.org/~mcgrof/patches/2014/04/22/test-ariks-patch-for-314.patch

Arik Nemtsov (1):
  cfg80211: avoid freeing last_request while in flight

Luis R. Rodriguez (1):
  cfg80211: fix processing world regdomain when non modular

 net/wireless/reg.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

-- 
1.9.0

