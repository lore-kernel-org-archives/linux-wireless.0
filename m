Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34786 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbbLGVFD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 16:05:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>,
	Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH 0/4] fine timing measurement
Date: Mon,  7 Dec 2015 22:04:49 +0100
Message-Id: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net> (sfid-20151207_220508_589293_4560D07B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As we've discussed with a number of people already, here's our current
work to add fine timing measurement support. Most of the work is really
done by the firmware, so this just defines the API.

We've gone back and forth over this, and I guess one thing that might
need explaining is the decision to only allow aborting a measurement by
closing a socket. The reasoning behind this was that (a) it needs to be
supported anyway, if the application crashes, and forcing it that way
makes the code path more tested; (b) if you wanted to reuse a socket
for this and other things, eventually you'd make your code more complex
because you'd have to handle events while waiting for the ACK message
for a command - but in most testing it'll work if you forget, and then
randomly lose some events every once a while ... forcing a new socket
also prevents that issue.

Please send comments :)

johannes

