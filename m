Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab0HXKOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 06:14:18 -0400
Subject: [PATCH] nl80211: fix missing nesting
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Philip A. Prindeville" <philipp@redfish-solutions.com>,
	Philip Prindeville <philipp_subx@redfish-solutions.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 12:15:53 +0200
Message-ID: <1282644953.3695.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit 95a6ccbb46c70cff376684c752831c014c87029d
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Aug 12 15:38:38 2010 +0200

    cfg80211/mac80211: extensible frame processing

introduced a netlink bug that caused parsing errors
in userspace because it forgot to close a nesting,
which would advertise a nesting length of zero to
userspace, which then completely threw off parsing
and led to

	Illegal nla->nla_type == 0

being printed by libnl.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-08-24 12:11:16.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-08-24 12:11:21.000000000 +0200
@@ -636,6 +636,8 @@ static int nl80211_send_wiphy(struct sk_
 			nla_nest_end(msg, nl_ftypes);
 		}
 
+		nla_nest_end(msg, nl_ifs);
+
 		nl_ifs = nla_nest_start(msg, NL80211_ATTR_RX_FRAME_TYPES);
 		if (!nl_ifs)
 			goto nla_put_failure;


