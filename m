Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36643 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaJTKir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 06:38:47 -0400
Message-ID: <1413801518.10246.17.camel@jlt4.sipsolutions.net> (sfid-20141020_123850_504077_493D7119)
Subject: Re: [PATCH v2 23/23] ath9k: Do not start BA when scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Mon, 20 Oct 2014 12:38:38 +0200
In-Reply-To: <21572.55352.564813.169136@gargle.gargle.HOWL>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
	 <1413511830-5536-24-git-send-email-sujith@msujith.org>
	 <1413797433.10246.2.camel@jlt4.sipsolutions.net>
	 <21572.55352.564813.169136@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 15:09 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > If it's a mac80211 race, wouldn't it make sense to fix it in mac80211?
> 
> Yes, definitely. :-)
> 
> But, we also ran into issues where starting a BA session
> when HW scan was in progress (with MCC enabled) caused connectivity
> problems, hence this fix in ath9k.

mac80211 is also aware of HW scanning, but I'm not sure what it should
do, I guess.

> Regarding the BA race, would it make sense to flush
> sdata->work after scan completion ?

Err, no idea, I haven't really looked :)

johannes

