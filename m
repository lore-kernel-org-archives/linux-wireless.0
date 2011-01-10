Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1599 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab1AJTeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 14:34:02 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 10 Jan 2011 11:33:45 -0800
Subject: cfg80211 rfkill interface
Message-ID: <400C43189542CE41BC0A5B252FC90136952F059529@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I am looking into implementing rfkill into our brcm80211 open-source driver. Our driver detects disable switch by an interrupt, but switching back does not give an interrupt. For the latter I wanted to use the rfkill_poll callback and wiphy_rfkill_start_polling. However, I tried a wiphy_rfkill_stop_polling in the rfkill_poll callback when rf is unblocked, and this resulted in a system hang. So I moved the wiphy_rfkill_stop_polling to the start callback. Does that make sense or is there another way you would recommend?

Gr. AvS
