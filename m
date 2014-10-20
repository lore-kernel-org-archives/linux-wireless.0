Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54923 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaJTJiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:38:05 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.55352.564813.169136@gargle.gargle.HOWL> (sfid-20141020_113809_649866_E8330878)
Date: Mon, 20 Oct 2014 15:09:04 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH v2 23/23] ath9k: Do not start BA when scanning
In-Reply-To: <1413797433.10246.2.camel@jlt4.sipsolutions.net>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
	<1413511830-5536-24-git-send-email-sujith@msujith.org>
	<1413797433.10246.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> If it's a mac80211 race, wouldn't it make sense to fix it in mac80211?

Yes, definitely. :-)

But, we also ran into issues where starting a BA session
when HW scan was in progress (with MCC enabled) caused connectivity
problems, hence this fix in ath9k.

Regarding the BA race, would it make sense to flush
sdata->work after scan completion ?

Sujith

