Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10616 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161383Ab2COUto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:49:44 -0400
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: mac80211 20/40 coexist
Date: Thu, 15 Mar 2012 20:49:39 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b> (sfid-20120315_214949_123720_9212BA88)
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The commit "mac80211: stop tx before doing hw config and rate
> update" (and a later commit fixing it) introduced a queue stop & flush
> on switching 20/40.
>
> I'm working on not calling hw_config() for switching between 20/40 but
> instead only calling rate_control_rate_update() and
> ieee80211_bss_info_change_notify() to tell the rate control and driver.

Johannes,

Not calling hw_config could affect drivers like ath9k_htc where the rate control runs in the firmware.
Those drivers will update the rate control based on CHANGED_HT flag.

>
> If we do that, is it still necessary to stop the queues for it? It seems
> like it shouldn't.

Actually the queue stop was added to avoid mismatches b/w hw and rate control. But If you dont stop the queues
before the rate control change, the station might send the frames in different ht mode (for example ht40) wrt AP's ht mode (ht20).

-Rajkumar