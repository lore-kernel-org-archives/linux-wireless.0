Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:52411 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZIXR24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 13:28:56 -0400
Date: Thu, 24 Sep 2009 18:18:20 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: 2.6.31-git wireless broken
Message-ID: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've noticed for a while that wireless is broken in linux-next, on both
the machines I use it on (a Fujitsu Siemens laptop using iwl3945 and an
Acer Aspire One using ath5k: both running openSUSE 11.1, with WPA):
I hoped to find it fixed later, but no, Linus's git is broken now.

Only found time to bisect it a couple of days ago (on the Aspire One:
guess the other would show the same, but that's no more than a guess).
It arrived at the commit below as the culprit, which from your own
words doesn't seem like a very hopeful place to land :-(

That commit does give me a "WARNING: at net/mac80211/mlme.c:1904",
followed by "WARNING: at net/mac80211/mlme.c:2308" every few seconds;
and those do get fixed later on (don't appear with latest git).
But I think there's another problem that comes in later, because
at this commit iwconfig does show my ESSID, whereas with later
git it just says "ESSID:off/any" (I have not bisected when that
change comes in).

I expect you'll need a lot more info from me: please do ask
(but bear in mind that I'm wireless and network ignorant).

Thanks,
Hugh

77fdaa12cea26c204cc12c312fe40bc0f3dcdfd8 is first bad commit
commit 77fdaa12cea26c204cc12c312fe40bc0f3dcdfd8
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Jul 7 03:45:17 2009 +0200

    mac80211: rework MLME for multiple authentications
    
    Sit tight. This shakes up the world as you know
    it. Let go of your spaghetti tongs, they will no
    longer be required, the horrible statemachine in
    net/mac80211/mlme.c is no more...
    
    With the cfg80211 SME mac80211 now has much less
    to keep track of, but, on the other hand, for FT
    it needs to be able to keep track of at least one
    authentication being in progress while associated.
    So convert from a single state machine to having
    small ones for all the different things we need to
    do. For real FT it will still need work wrt. PS,
    but this should be a good step.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 437301807c7c27495cee7692f293dac1ca56ed78 02520ec555c0873050318af669dade9e066f479d M	net
