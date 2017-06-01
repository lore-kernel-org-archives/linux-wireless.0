Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36182 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdFASHI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 14:07:08 -0400
Received: by mail-pf0-f180.google.com with SMTP id m17so33833542pfg.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jun 2017 11:07:08 -0700 (PDT)
Date: Thu, 1 Jun 2017 11:07:01 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Fw: [Bug 195953] New: Possible access to unintended variable in
 "linux/net/mac80211/sta_info.c" line 2158
Message-ID: <20170601110701.21dcef2a@xeon-e3> (sfid-20170601_200712_425985_60499553)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Begin forwarded message:

Date: Thu, 01 Jun 2017 06:55:22 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 195953] New: Possible access to unintended variable in "linux/net/mac80211/sta_info.c" line 2158


https://bugzilla.kernel.org/show_bug.cgi?id=195953

            Bug ID: 195953
           Summary: Possible access to unintended variable in
                    "linux/net/mac80211/sta_info.c" line 2158
           Product: Networking
           Version: 2.5
    Kernel Version: 4.12-rc3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: petrum@gmail.com
        Regression: No

While experimenting with a CodeSonar plugin we develop, we noticed a
potential issue in file "linux/net/mac80211/sta_info.c" line 2158 function
sta_set_sinfo

        sinfo->rx_dropped_misc = sta->rx_stats.dropped;
        if (sta->pcpu_rx_stats) {
                for_each_possible_cpu(cpu) {
                        struct ieee80211_sta_rx_stats *cpurxs;

                        cpurxs = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
        /*HERE*/        sinfo->rx_packets += cpurxs->dropped;
                }
        }

Wasn't the intention to use "rx_dropped_misc" (instead of "rx_packets") in the
indicated line. In the first line, "rx_dropped_misc" is updated.

Thank you.

-- 
You are receiving this mail because:
You are the assignee for the bug.
