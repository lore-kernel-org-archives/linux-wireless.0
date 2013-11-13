Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:49457 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab3KMSNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:13:04 -0500
Received: by mail-we0-f177.google.com with SMTP id t60so783697wes.8
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 10:13:03 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 0/5] cfg80211: regulatory quiescing and exporting DFS regions
Date: Wed, 13 Nov 2013 19:12:54 +0100
Message-Id: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191310_092938_FC2B477C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series depends on my last posted series.

This set tries to address some issues I was with checking for DFS region
support on the cfg80211 path for starting radar detection. Apart from
checking for the DFS region when we get a request to start DFS radar
detection we should always check the DFS region also when we want to
use a mode of operation that requires DFS support in the kernel. IBSS
has a mode of operation, when NL80211_ATTR_HANDLE_DFS is set, which
should be taken into consideration for DFS support. My patch 5 titled
"cfg80211: DFS check dfs_region before usage" really is incomplete
and should check for NL80211_ATTR_HANDLE_DFS on IBSS wdevs when set
to make the appropriate exception.

While at it I considered the corner cases of changing regulatory domains,
this pushed me to add regulatory quiescing support. This is particularly
important when we switch regulatory domains and the DFS region changes but
should nevertheless still be done even in other cases. I think we should
also extend the IBSS NL80211_ATTR_HANDLE_DFS case to require newer
implementations to send their supported DFS regions, otherwise we assume
userespace is doing the right thing. I think we can take care of that better
in kernel space.

Janusz, please test, and likely feel free to take on the last patch.
We may need help from Johannes on the rtnl lock question now required
for checks on enabling beacon operation.

Jouni, thoughts on the approach? Sunit, Rakesh?

Luis R. Rodriguez (5):
  cfg80211: pass the wdev on the country IE regulatory hint
  cfg80211: make cfg80211_leave_all() available outside of sysfs
  cfg80211: add regulatory quiescing support
  cfg80211: add DFS region capability support
  cfg80211: DFS check dfs_region before usage

 include/net/cfg80211.h       | 57 +++++++++++++++++++++++++++++++++++++++++++
 include/net/regulatory.h     |  4 +++
 include/uapi/linux/nl80211.h | 21 +++++++++++++++-
 net/wireless/chan.c          |  8 ++++++
 net/wireless/core.c          | 47 +++++++++++++++++++++++++++++++++++
 net/wireless/core.h          |  2 ++
 net/wireless/nl80211.c       | 15 ++++++++++++
 net/wireless/reg.c           | 58 +++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/reg.h           | 13 +++++-----
 net/wireless/sme.c           |  2 +-
 net/wireless/sysfs.c         |  8 ------
 11 files changed, 218 insertions(+), 17 deletions(-)

-- 
1.8.4.rc3

