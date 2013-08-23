Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab3HWJJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 05:09:55 -0400
Date: Fri, 23 Aug 2013 11:08:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: iwlwifi micorcode errors and hardware resets problems
Message-ID: <20130823090821.GB2632@redhat.com> (sfid-20130823_110958_788937_7994E2DF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have those bug reports on RH bugzilla, and various other iwlwifi
problems, but those have some common scenario:

https://bugzilla.redhat.com/show_bug.cgi?id=979873
https://bugzilla.redhat.com/show_bug.cgi?id=990536
https://bugzilla.redhat.com/show_bug.cgi?id=994322
https://bugzilla.redhat.com/show_bug.cgi?id=996502
https://bugzilla.redhat.com/show_bug.cgi?id=969610
https://bugzilla.redhat.com/show_bug.cgi?id=999053

First there is Microcode error or other firmware problem, what make we
do iwl_trans_stop_device() which set trans->state to IWL_TRANS_NO_FW.
If mac80211 has some pending works/timers i.e. ieee80211_sta_work(),
it calls drv and we trigger on of those warnings

        WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
                  "%s bad state = %d", __func__, trans->state);

on some trans operation.

I think this can be fixed by first do quiesce on mac80211 (for example
by ieee80211_sta_quiesce() procedure, which I removed but can be added
back) and then do iwlagn_prepare_restart() & ieee80211_restart_hw().

Though I'm not sure if it's worth to do this since those warnings are
indicator for malfunctioning iwlwifi firmware (or driver not correctly
communicating with firmware), which will be unnoticed if not reported
automatically by tool like ABRT. But perhaps we could add WARN_ONCE on
Microcode error condition ?

Additionally I wonder if there is good way to debug those microcode
problems (I mean root of the problem), since most of them happen at
random after hours or days uptime?

Thoughts?

Stanislaw

