Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:52722 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab2LVVzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 16:55:51 -0500
Date: Sat, 22 Dec 2012 13:55:45 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Fw: [Bug 51901] New: mac80211/cfg.c:1995: possible bad call to
 memcpy ?
Message-ID: <20121222135545.1f134c5a@samsung-9> (sfid-20121222_225554_897530_D9193457)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Begin forwarded message:

Date: Sat, 22 Dec 2012 16:28:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: shemminger@linux-foundation.org
Subject: [Bug 51901] New: mac80211/cfg.c:1995: possible bad call to memcpy ?


https://bugzilla.kernel.org/show_bug.cgi?id=51901

           Summary: mac80211/cfg.c:1995: possible bad call to memcpy ?
           Product: Networking
           Version: 2.5
    Kernel Version: 3.8-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: shemminger@linux-foundation.org
        ReportedBy: dcb314@hotmail.com
        Regression: Yes


The source code is 

static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device
*dev,
                    int rate[IEEE80211_NUM_BANDS])
{
    struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);

    memcpy(sdata->vif.bss_conf.mcast_rate, rate, sizeof(rate));

The compiler says

cfg.c: In function ‘int ieee80211_set_mcast_rate(wiphy*, net_device*, int*)’:
cfg.c:1995: warning: argument to ‘sizeof’ in ‘void* memcpy(void*, const void*,
size_t)’ call is the same expression as the source; did you mean to dereference
it? [-Wsizeof-pointer-memaccess]
     memcpy(rate2, rate, sizeof(rate));
                               ^

Here is static analyser cppcheck also finding the same problem

[linux-3.8-rc1/net/mac80211/cfg.c:1995]: (error) Using 'sizeof' on array given
as function argument returns size of a pointer.


Suggest code rework.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
