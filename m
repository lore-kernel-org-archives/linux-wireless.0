Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39366 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYIVRlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 13:41:12 -0400
Date: Mon, 22 Sep 2008 10:41:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: Progress on aggregation
Message-ID: <20080922174103.GF6048@tesla> (sfid-20080922_194114_590801_A267292E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a quick note on the progress of aggregation. It works but we still
need to hanld the rtnl_lock() in a sane way. Johannes we proposing we
use a workqueue for this.

* iwl4965 has been tested to work
* ath9k *does* xmit aggregate frames but throughput is low

Since ath9k still needs some work we are looking into it.
Tomas, have you had a chance to consider the workqueue usage
for the rtnl_lock()? I figure to leave that to you as we
are still looking into the throughput issues with aggreation with
ath9k.

  Luis
