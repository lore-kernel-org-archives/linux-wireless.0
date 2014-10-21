Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43611 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbaJUMvE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 08:51:04 -0400
Message-ID: <1413895856.1998.6.camel@jlt4.sipsolutions.net> (sfid-20141021_145108_358885_283E97FA)
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 21 Oct 2014 14:50:56 +0200
In-Reply-To: <CAB3XZEd8xCieC8xhOw=V0rHtJadYBKwe9NjwkNsmAmXqiL4ZRQ@mail.gmail.com> (sfid-20141021_142704_044572_7DA56B09)
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	 <CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	 <21568.29077.518022.812356@gargle.gargle.HOWL>
	 <1413797588.10246.3.camel@jlt4.sipsolutions.net>
	 <21572.55536.308167.684155@gargle.gargle.HOWL>
	 <1413798712.10246.14.camel@jlt4.sipsolutions.net>
	 <21572.58249.490532.207564@gargle.gargle.HOWL>
	 <1413801423.10246.16.camel@jlt4.sipsolutions.net>
	 <21572.60015.349942.74265@gargle.gargle.HOWL>
	 <1413806542.10246.21.camel@jlt4.sipsolutions.net>
	 <1413809136.24269.0.camel@jlt4.sipsolutions.net>
	 <21573.55666.43231.68176@gargle.gargle.HOWL>
	 <1413873729.1998.2.camel@jlt4.sipsolutions.net>
	 <CAB3XZEd8xCieC8xhOw=V0rHtJadYBKwe9NjwkNsmAmXqiL4ZRQ@mail.gmail.com>
	 (sfid-20141021_142704_044572_7DA56B09)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-21 at 15:27 +0300, Eliad Peller wrote:

> This patch actually solves a kernel panic that can be reproduced
> easily by increasing the delay in ieee80211_scan_completed() and
> removing the driver right after initiating a scan - the delayed
> scan_work never gets flushed, resulting in invalid memory access, etc.

Yeah I thought about that too - we flush the workqueue but if the timer
hasn't yet fired you can get issues.

OTOH, the delay there is 0, so the workqueue code doesn't even arm the
timer but rather puts the work on the workqueue immediately. Therefore
flush_work() should be enough?

Or did you not test with something like

@@ -357,7 +357,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
        set_bit(SCAN_COMPLETED, &local->scanning);
        if (aborted)
                set_bit(SCAN_ABORTED, &local->scanning);
-       ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
+       ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 1);


johannes

