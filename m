Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:56430 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab0IRDBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 23:01:36 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id o8I31Y41025397
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 20:01:35 -0700
Received: from iwn38 (iwn38.prod.google.com [10.241.68.102])
	by hpaq1.eem.corp.google.com with ESMTP id o8I31WjS013443
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 20:01:33 -0700
Received: by iwn38 with SMTP id 38so2375386iwn.32
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 20:01:32 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Sep 2010 20:01:32 -0700
Message-ID: <AANLkTimYa4A=WFoY_sv-iMOPeZ37u8Hcy9wbsZO5eNun@mail.gmail.com>
Subject: mac80211: Why probe after each scan?
From: Paul Stewart <pstew@google.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Leffler <sleffler@chromium.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a small bit of behavior related in some vague way to
connection monitoring:  During the scan-completed notification
(ieee80211_mlme_notify_scan_completed) we call
ieee80211_restart_sta_timer() on all our interfaces, which in turn
queues up the &ifmgd->monitor_work, which does a probe request of our
AP.  Why should we do a probe request of your associated AP every time
a scan completes?  Wouldn't the other active monitoring schemes (like
beacon loss) be sufficient for a "scan finished" condition?

--
Paul
