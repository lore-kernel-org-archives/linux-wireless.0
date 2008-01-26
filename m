Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49425 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755413AbYAZA5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 19:57:54 -0500
Message-ID: <479A858F.9030601@lwfinger.net> (sfid-20080126_005759_238123_7040E9AF)
Date: Fri, 25 Jan 2008 17:57:51 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Advice regarding mac80211 bug
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

As you have likely seen in recent E-mails, there is a bug in the rc80211_pid rate algorithm where a
loop runs away causing a kernel page fault panic. I'm working on a proper solution, but the bug
triggers only infrequently. For debugging I have a band-aid solution that detects the runaway to
prevent the crash. When this occurs, I am printing diagnostic info, and hope to find the root cause
of the problem, but with only 1 or 2 of these per day, it may take a while.

Now that 2.6.24 has been released, this bug will be propagating into mainline in 2.6.25-rcX and many
more systems may crash as a result. My question is as follows: Should I submit the band-aid patch
now while still looking for a better solution, or wait?

Thanks,

Larry



