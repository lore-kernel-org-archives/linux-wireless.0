Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2INMgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:36:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TCV8O-0006ke-Hd
	for linux-wireless@vger.kernel.org; Fri, 14 Sep 2012 14:36:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/10] mac80211 multi-channel work (final?)
Date: Fri, 14 Sep 2012 14:37:03 +0200
Message-Id: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143641_493953_B2559877)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm happy with this now. It works for me, I've tested actual
multi-channel work with hwsim and converted a hardware driver
to the API as well for testing.

I know I still need to sort out TX power that gets broken in
this patchset for *new* drivers (still works for drivers not
using channel contexts), but I think I can do that later. I
hope you're not afraid I'll abandon the task :-)

The other thing that I might want to sort out is the RCU use
in this patchset, but that's an internal thing in mac80211
and is therefore also not needed to work on drivers.

I've included the hwsim patch, but don't intend to merge it
as is since it has issues with wmediumd. I need to work with
the developers there to figure out what should be done.

I also don't intend to merge this for 3.7, it's late in the
cycle now and the merge window will open soon, I'd rather
have a little more time to let this be sorted out, and also
for the TX power issue. I'll put it into mac80211-next as
soon as the merge window opens, until then you can find it
in the 'wip' branch of my mac80211-next tree.

Please review and see what it does to your drivers :-)

johannes

