Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54960 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbbKLWAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 17:00:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Marek <mmarek@suse.com>
Subject: [RFC v5 0/5] mac80211: elide code for static hw flags
Date: Thu, 12 Nov 2015 23:00:47 +0100
Message-Id: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net> (sfid-20151112_230058_741290_6E875270)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In v5, I've radically simplified the whole concept and dropped the
support for static keys. Instead, I'm now simply entirely removing 
the if statements - replacing them by "if (true)" or "if (false)" 
if that's at all possible.

For many (distro) kernels, this will - as before - mean no change,
but for those of us who are building special purpose systems with
perhaps just a single driver or two this might result in the code
size (and perhaps speed?) improvements I mention in the patch.

johannes

