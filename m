Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33785 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2GJVNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 17:13:52 -0400
Received: by weyx8 with SMTP id x8so359143wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 14:13:51 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] cfg80211/mac80211: fix snprintf misuses
Date: Wed, 11 Jul 2012 00:13:49 +0300
Message-Id: <1341954831-10313-1-git-send-email-eliad@wizery.com> (sfid-20120710_231356_662092_FDAC02CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that the following idiom is pretty common in
the kernel:

res += snprintf(buf + res, sizeof(buf) - res, "string1");
res += snprintf(buf + res, sizeof(buf) - res, "string2");
...

However, since snprintf returns "the number of characters
which would be generated for the given input" the return
value must be checked against the buffer size in order
to avoid writing past the buffer bounds.

Fix it by replacing snprintf with scnprintf, to make
the original code work as expected.

(As noted, it seems that this error exists in many
other places in the kernel. it can be found by
git grep "\+=\s*snprintf". However, these places
are mostly in debugging code, so the security
implications are hopefully minor. I haven't reviewed
them all, though...)

Eliad Peller (2):
  cfg80211: replace snprintf with scnprintf
  mac80211: replace snprintf with scnprintf

 net/mac80211/debugfs.c             |   48 ++++++++++++++++++------------------
 net/mac80211/debugfs_netdev.c      |   10 +++---
 net/mac80211/rc80211_pid_debugfs.c |   26 +++++++++---------
 net/wireless/debugfs.c             |   25 +++++++++---------
 4 files changed, 54 insertions(+), 55 deletions(-)

-- 
1.7.6.401.g6a319

