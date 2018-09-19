Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59442 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbeITB2p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 21:28:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 0/5] netlink: nested policy validation
Date: Wed, 19 Sep 2018 21:49:00 +0200
Message-Id: <20180919194905.16462-1-johannes@sipsolutions.net> (sfid-20180919_214936_981283_56B1DBAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I should've tried the idea that David came up with first - it does
in fact make the code quite a bit simpler, and indeed removes the need
for the previously introduced "**error_msg" argument that I hadn't
really liked anyway.

So, changes here are:
 * move setting the bad attr pointer/message into validate_nla()
 * remove the recursion patch since that's no longer needed
 * simply skip the generic bad attr pointer/message setting in
   case of nested nla_validate() failing since that could fail
   only due to validate_nla() failing inside, which already sets
   the extack information

johannes
