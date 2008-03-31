Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:33821 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748AbYCaOq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 10:46:59 -0400
Received: by wr-out-0506.google.com with SMTP id c48so768974wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 07:46:58 -0700 (PDT)
Message-ID: <c85cb4470803310746h36b20d0egce98f8cea3becb0b@mail.gmail.com> (sfid-20080331_154726_003392_C46030DA)
Date: Mon, 31 Mar 2008 17:46:57 +0300
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: mac80211: holding sta_info for non associated stations
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks

examining prints form the tear down of 11n session (see thread "Try to
stop Tx aggregation on non active TID messages"), i found an
interesting issue.
If i associate to a random AP "x" (what happened automatically as i
was configured by ifup scripts to do that), and then scan and
associate to my desired AP "y", i notice that AP "x" was not removed
from the mac80211 station table. Then, what happened was that during
ieee80211_stop, when we reach

list_for_each_entry_rcu(sta, &local->sta_list, list) {
    if (sta->sdata == sdata)
    ieee80211_sta_tear_down_BA_sessions(dev, sta->addr);
}

we try to tear down sessions to irrelevant stations (AP "x" in my
example), which leads to bugs.

did i miss something, or is there really a problem in the state
machine in the described scenario?

Thanks
Ron
