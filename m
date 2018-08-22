Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53986 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbeHVNNX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 09:13:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v2 0/2] workqueue lockdep limitations/bugs
Date: Wed, 22 Aug 2018 11:49:02 +0200
Message-Id: <20180822094904.15718-1-johannes@sipsolutions.net> (sfid-20180822_114946_748590_5495A14A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses the first two issues.

The third problem is actually caught when the flush ever does
anything, but that might be rare depending on the circumstances,
so I still think it'd be nice to catch it somehow, but right now
I don't have the time to look into it.

johannes

v2:
 * move the acquire/release into flush_work() where it used to be
 * also re-add the acquire/release into flush_workqueue()
