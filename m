Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38282 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbeITPDA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 11:03:00 -0400
Date: Thu, 20 Sep 2018 12:20:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Simon Wunderlich <sw@simonwunderlich.de>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Eliad Peller <eliad@wizery.com>
Subject: Re: [PATCH] mac80211: allow scans on radar channels, unless there is
 CAC or CSA
Message-ID: <20180920092014.ajgykw7o7p73grfj@mwanda> (sfid-20180920_112033_768085_22586506)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180918141633.10282-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

I love your patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Simon-Wunderlich/mac80211-allow-scans-on-radar-channels-unless-there-is-CAC-or-CSA/20180919-071924
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git master

New smatch warnings:
net/mac80211/scan.c:508 ieee80211_can_scan() warn: signedness bug returning '(-16)'

Old smatch warnings:
net/mac80211/scan.c:511 ieee80211_can_scan() warn: signedness bug returning '(-16)'

# https://github.com/0day-ci/linux/commit/ad9617f275c425ddf25eb83678062ab87d4c0870
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout ad9617f275c425ddf25eb83678062ab87d4c0870
vim +508 net/mac80211/scan.c

f3b85252 Johannes Berg     2009-04-23  503  
133d40f9 Stanislaw Gruszka 2012-03-28  504  static bool ieee80211_can_scan(struct ieee80211_local *local,
                                                   ^^^^
133d40f9 Stanislaw Gruszka 2012-03-28  505  			       struct ieee80211_sub_if_data *sdata)
133d40f9 Stanislaw Gruszka 2012-03-28  506  {
ad9617f2 Simon Wunderlich  2018-09-18  507  	if (sdata->wdev.cac_started)
ad9617f2 Simon Wunderlich  2018-09-18 @508  		return -EBUSY;
                                                        ^^^^^^^^^^^^^
ad9617f2 Simon Wunderlich  2018-09-18  509  
ad9617f2 Simon Wunderlich  2018-09-18  510  	if (sdata->vif.csa_active)
ad9617f2 Simon Wunderlich  2018-09-18  511  		return -EBUSY;
                                                        ^^^^^^^^^^^^^^
164eb02d Simon Wunderlich  2013-02-08  512  
2eb278e0 Johannes Berg     2012-06-05  513  	if (!list_empty(&local->roc_list))
133d40f9 Stanislaw Gruszka 2012-03-28  514  		return false;
133d40f9 Stanislaw Gruszka 2012-03-28  515  
133d40f9 Stanislaw Gruszka 2012-03-28  516  	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
392b9ffb Stanislaw Gruszka 2013-08-27  517  	    sdata->u.mgd.flags & IEEE80211_STA_CONNECTION_POLL)
133d40f9 Stanislaw Gruszka 2012-03-28  518  		return false;
133d40f9 Stanislaw Gruszka 2012-03-28  519  
133d40f9 Stanislaw Gruszka 2012-03-28  520  	return true;
133d40f9 Stanislaw Gruszka 2012-03-28  521  }
133d40f9 Stanislaw Gruszka 2012-03-28  522  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
